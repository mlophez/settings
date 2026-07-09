---
name: build
description: >
  Implements a plan or a concrete development task following the project
  architecture and code style docs. Use it after planning, to write the
  actual code, whether in the main session or inside the implementer agent.
  It edits files and runs tests, but never commits unless explicitly asked.
#model: sonnet
effort: medium
disable-model-invocation: true
---

# Implementing

Execute the given plan or concrete task with the minimal necessary change.

## Project context

Before anything else, read these files at the root of the current project:
- `docs/architecture.md` — source of truth for the project architecture.
- `docs/code-style.md` — source of truth for coding conventions.
- `docs/testing.md` — source of truth for how to run and write tests.

If any file is missing, say so explicitly in your output and continue using general best practices plus the conventions you infer from the existing code.

## Scope

Yes:
- Implement the plan or task: write and modify code.
- Reuse existing functions and utilities instead of duplicating logic.
- Run the project tests and build to verify the change.

No:
- Refactors or improvements not requested in the plan or task.
- Hardcoded or test-only solutions; build general, maintainable implementations.
- Commit or push unless explicitly asked. Never commit secrets, tokens, private keys or certificates.

## Clean code baseline

Apply the principles defined in the two shared baselines in the `review` skill directory (relative paths from here):
- `../review/clean-code.md` — coding style (naming, DRY, small functions, error handling).
- `../review/clean-architecture.md` — architecture and design (domain validation, immutability, pure/shell separation,
  use-case input validation).

They are a baseline, not project law: `docs/code-style.md`, `docs/architecture.md` and the surrounding code always win
when they conflict.

## How to operate

1. Read `docs/architecture.md`, `docs/code-style.md`, `docs/testing.md` and the two shared baselines
   `../review/clean-code.md` and `../review/clean-architecture.md`.
2. Read the relevant code before modifying it. Use `rg` to locate symbols.
3. Apply the minimal change that fulfills the task, matching the surrounding code style and the clean code baseline
   above (which yields to the project's code style when they differ).
4. Comment the generated code where it helps human understanding, without stating the obvious.
5. Run the project tests and build. If they fail, fix the cause or report the failure honestly with the output.
6. Remove any temporary files or scripts you created while working.

## Flow control

When the implementation is done, STOP and return control to the user. Do not start the next phases of the flow (review, document, commit, PR) on your own: the user decides each phase manually and may skip any of them.

## Output format

Concise. State what changed, in which file and line, why, and the result of the verification (tests/build output summary). If the task or plan is wrong or infeasible, say so clearly instead of forcing an implementation.
