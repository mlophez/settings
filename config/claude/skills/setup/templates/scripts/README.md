# Agent validation scripts

Hook logic backing the Claude Code hooks wired in `.claude/settings.json`. They are plain scripts: CI and humans
can call them directly.

**The commands live in `hooks.sh` at the repository root — that is the only file to edit** when the formatter,
linter, build command, test command, protected paths or credential patterns change. These scripts source it and
hold no project-specific command.

- `format.sh <file>` — formats one file with `format_file` from `hooks.sh`. Never blocks.
- `lint.sh <file>` — lints one file with `lint_file` from `hooks.sh`. Exits 2 so the agent fixes the issues before
  continuing.
- `after-edit.sh <file>` — hook entrypoint after every Edit/Write: runs `format.sh`, then `lint.sh`. A step is
  active only while its script exists.
- `validate.sh` — full validation from the repository root, running `run_lint`, `run_build` and `run_test` from
  `hooks.sh`. It reads the hook payload from stdin, so call it as `scripts/agent/validate.sh </dev/null` by hand.
- `guard.sh` — denies edits to `PROTECTED_PATHS` and asks before writing content matching `SECRET_PATTERNS`.

If `hooks.sh` is missing, every script exits 0 and the hooks become no-ops.

Requirements: bash 3.2+ and `jq` (used by `guard.sh` and `validate.sh`; without it both allow the action).
