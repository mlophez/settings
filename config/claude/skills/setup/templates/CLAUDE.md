@AGENTS.md

<!-- AGENTS.md above is the single source of truth for this project and is loaded automatically by Claude Code.
Only add below what is specific to Claude Code and useless to other agent tools. Omit the section if empty. -->

## Claude Code

<!-- Bullet list. Include the hooks line only if the agent hooks were installed. -->

- Validation hooks are wired in `.claude/settings.json` and implemented in `scripts/agent/`; every linter,
  formatter, build and test command lives in `hooks.sh` at the project root.
