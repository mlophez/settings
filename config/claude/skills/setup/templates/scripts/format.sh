#!/usr/bin/env bash
# Formats one file with the project formatter. Callable by hand: scripts/agent/format.sh <file>
# Wired as part of the PostToolUse Edit|Write hook through after-edit.sh.
# A formatter failure is reported but never blocks the agent.
#
# The commands live in hooks.sh at the repository root; this script is only logic.
set -uo pipefail
here="$(cd -- "$(dirname -- "$0")" && pwd)"
root="$(cd -- "$here/../.." && pwd)"

[ -f "$root/hooks.sh" ] || exit 0   # no tooling configured: nothing to do
# shellcheck source=/dev/null
. "$root/hooks.sh"
command -v format_file >/dev/null 2>&1 || exit 0   # hooks.sh defines no formatter

file="${1:-}"
[ -n "$file" ] && [ -f "$file" ] || exit 0

output="$(format_file "$file" 2>&1)"
status=$?
[ "$status" -eq 3 ] && exit 0   # no formatter for this file type

if [ "$status" -ne 0 ]; then
  printf 'format failed for %s:\n%s\n' "$file" "$output" >&2
  exit 1   # non-blocking error: the action proceeds, the transcript shows the failure
fi
exit 0
