#!/usr/bin/env bash
# Lints one file with the project linter. Callable by hand: scripts/agent/lint.sh <file>
# Wired as part of the PostToolUse Edit|Write hook through after-edit.sh.
# Exit 2 makes Claude Code feed stderr back to the agent, which then fixes the issues.
#
# The commands live in hooks.sh at the repository root; this script is only logic.
set -uo pipefail
here="$(cd -- "$(dirname -- "$0")" && pwd)"
root="$(cd -- "$here/../.." && pwd)"

[ -f "$root/hooks.sh" ] || exit 0   # no tooling configured: nothing to do
# shellcheck source=/dev/null
. "$root/hooks.sh"
command -v lint_file >/dev/null 2>&1 || exit 0   # hooks.sh defines no linter

file="${1:-}"
[ -n "$file" ] && [ -f "$file" ] || exit 0

output="$(lint_file "$file" 2>&1)"
status=$?
case "$status" in
  0|3) exit 0 ;;   # clean, or no linter for this file type
esac

printf 'Lint failed for %s. Fix these issues before continuing:\n%s\n' "$file" "$output" >&2
exit 2
