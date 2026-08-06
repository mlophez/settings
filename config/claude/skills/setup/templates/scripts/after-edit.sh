#!/usr/bin/env bash
# PostToolUse Edit|Write entrypoint: format the edited file, then lint it.
# Hooks under the same matcher may run in parallel, so chaining them here is what
# guarantees the linter sees the formatted file.
#
# Nothing to configure here: the commands live in hooks.sh at the repository root,
# and a step is active only while its script exists. Delete format.sh or lint.sh
# to drop that step.
set -uo pipefail
here="$(cd -- "$(dirname -- "$0")" && pwd)"

file="${1:-}"
[ -n "$file" ] && [ -f "$file" ] || exit 0

if [ -x "$here/format.sh" ]; then
  "$here/format.sh" "$file" || true   # formatting never blocks the agent
fi

if [ -x "$here/lint.sh" ]; then
  exec "$here/lint.sh" "$file"        # lint decides whether to block (exit 2)
fi
exit 0
