#!/usr/bin/env bash
# Stop hook: runs the project validation (lint, build, tests) when the turn ends and
# blocks the stop so the agent fixes whatever it broke.
# Callable by hand (and from CI): scripts/agent/validate.sh </dev/null
#
# The commands live in hooks.sh at the repository root; this script is only logic.
# The Stop payload carries no stop_hook_active flag, so the loop guard lives here:
# at most MAX_BLOCKS consecutive blocks per session, tracked by session_id.
set -uo pipefail
here="$(cd -- "$(dirname -- "$0")" && pwd)"
root="$(cd -- "$here/../.." && pwd)"

[ -f "$root/hooks.sh" ] || exit 0   # no tooling configured: nothing to validate
# shellcheck source=/dev/null
. "$root/hooks.sh"

MAX_BLOCKS=2

payload="$(cat)"
session=""
if command -v jq >/dev/null 2>&1; then
  session="$(printf '%s' "$payload" | jq -r '.session_id // empty' 2>/dev/null)"
fi
state_dir="${TMPDIR:-/tmp}/claude-validate"
mkdir -p "$state_dir"
state_file="$state_dir/${session:-nosession}.count"

cd "$root" || exit 0

# Runs one validation step by name, or returns 3 when hooks.sh does not define it.
run_step() {
  command -v "run_$1" >/dev/null 2>&1 || return 3
  "run_$1"
}

failures=""
for step in lint build test; do
  output="$(run_step "$step" 2>&1)"
  status=$?
  [ "$status" -eq 3 ] && continue   # step not configured for this project
  [ "$status" -eq 0 ] && continue
  failures="${failures}--- ${step} failed ---
${output}
"
done

if [ -z "$failures" ]; then
  rm -f "$state_file"
  exit 0
fi

blocks=0
[ -f "$state_file" ] && blocks="$(cat "$state_file" 2>/dev/null || echo 0)"
case "$blocks" in *[!0-9]*|"") blocks=0 ;; esac

if [ -z "$session" ] || [ "$blocks" -ge "$MAX_BLOCKS" ]; then
  # Without a session id there is no reliable loop guard, and past MAX_BLOCKS the agent
  # is not converging: report the failure without blocking the stop.
  printf 'Project validation still failing:\n%s\n' "$failures" >&2
  exit 1
fi

printf '%s' "$((blocks + 1))" > "$state_file"
printf 'Project validation failed. Fix it before finishing:\n%s\n' "$failures" >&2
exit 2
