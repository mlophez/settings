#!/usr/bin/env bash
# PreToolUse Edit|Write hook: denies edits to protected paths and asks the user before
# writing anything that looks like a credential.
#
# PROTECTED_PATHS and SECRET_PATTERNS live in hooks.sh at the repository root;
# this script is only logic.
set -uo pipefail
here="$(cd -- "$(dirname -- "$0")" && pwd)"
root="$(cd -- "$here/../.." && pwd)"

[ -f "$root/hooks.sh" ] || exit 0   # no configuration: allow the edit
# shellcheck source=/dev/null
. "$root/hooks.sh"

payload="$(cat)"
command -v jq >/dev/null 2>&1 || exit 0   # without jq the payload cannot be inspected: allow

file="$(printf '%s' "$payload" | jq -r '.tool_input.file_path // empty')"
[ -n "$file" ] || exit 0
rel="${file#$root/}"

# Emits a PreToolUse decision and exits: decide <deny|ask> <reason>
decide() {
  jq -n --arg d "$1" --arg r "$2" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:$d,permissionDecisionReason:$r}}'
  exit 0
}

for pattern in "${PROTECTED_PATHS[@]:-}"; do
  [ -n "$pattern" ] || continue
  # Unquoted $pattern on purpose: it must be evaluated as a glob.
  case "$rel" in
    $pattern) decide deny "$rel is a protected path (PROTECTED_PATHS in hooks.sh)." ;;
  esac
done

[ -n "${SECRET_PATTERNS:-}" ] || exit 0   # no credential patterns configured

# The content field name differs per tool (new_text, file_text, ...), so scan every string
# in tool_input instead of guessing which field holds the payload.
content="$(printf '%s' "$payload" | jq -r '[.tool_input | .. | strings] | join("\n")')"

# -e is mandatory here: the pattern starts with "-" and grep would read it as an option.
if printf '%s' "$content" | grep -Eqi -e "$SECRET_PATTERNS"; then
  decide ask "This content looks like it contains a credential. Confirm it is a placeholder or test fixture before writing $rel."
fi
exit 0
