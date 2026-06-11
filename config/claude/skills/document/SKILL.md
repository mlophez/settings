---
name: document
description: >
  Reviews the pending changes and keeps documentation up to date (docstrings,
  comments on non-obvious logic, docs/usecases/). Use it after the
  implementation is done, before committing or opening a PR, whether in the
  main session or inside the documenter agent. All documentation is written
  in English.
model: opus
effort: low
disable-model-invocation: true
---

# Documenting

Review the changes made in the project and make sure they are properly documented, both in the code itself and in the project documentation.

## Project context

Before anything else, read these files at the root of the current project if they exist:
- `docs/architecture.md` — project architecture, to understand where the change fits.
- `docs/code-style.md` — coding conventions, including documentation conventions.
- `docs/usecases/` — existing use case documentation, to learn its structure and naming.
- `README.md` — to detect when a change makes it outdated.

If any of them is missing, note it in your report and continue with general best practices.

## Scope

By default review the pending changes: `git diff` for the working tree and `git diff <default-branch>...HEAD` for the branch. If the user points you to specific files, commits or features, work on those instead. Read enough surrounding code to understand what the change actually does, not just the diff hunks.

## What to document

### Code documentation
- Public APIs (functions, classes, modules, endpoints, CLI commands) get doc comments in the idiom of the language (docstrings, Javadoc, JSDoc, rustdoc, etc.): purpose, parameters, return value, errors.
- Non-obvious logic gets a short comment explaining the why (constraints, trade-offs, gotchas), never the what.
- Do not pad obvious code with comments. Comment density must match the surrounding code and `docs/code-style.md`.
- Fix documentation that the change made stale (outdated comments, wrong parameter descriptions, dead references).

### Use case documentation (`docs/usecases/`)
Only when the change introduces, modifies or removes a user-facing or system-facing use case (a flow, feature or integration someone interacts with). Internal refactors do not need a use case document.

- One file per use case: `docs/usecases/<kebab-case-name>.md`.
- Update the existing file if the use case already has one; create it only if it does not.
- Structure each document with: purpose, actors involved, preconditions, main flow step by step, alternative/error flows, and references to the relevant code (`path/to/file.ext`).

## Hard rules

- All documentation is written in English.
- Write for a dual audience: an AI agent and a human must both understand it. That means: explicit over implicit, full sentences, concrete file paths and identifiers, no ambiguous pronouns, no unexplained internal jargon, self-contained documents that do not rely on conversation context.
- Document what the code does today, not intentions or future plans.
- Never change code behavior: you only add or update documentation (comments, doc comments, markdown). If you find a bug while reading, report it, do not fix it.
- Do not use tables in markdown documents.
- Do not commit; leave the changes in the working tree.
- When the report is delivered, STOP and return control to the user. Do not start the next phases of the flow (commit, PR) on your own: the user decides each phase manually and may skip any of them.

## Output format

A short report with:
- **Summary**: one or two sentences on the documentation state of the change.
- **Code documentation**: list of files where you added or updated doc comments, with a one-line reason each.
- **Use cases**: files created or updated under `docs/usecases/`, or an explicit "not needed" with the reason.
- **Stale docs**: documentation you found outdated elsewhere (e.g. `README.md`, `docs/architecture.md`) — updated if trivial, otherwise reported.
- **Issues found**: bugs or inconsistencies noticed while reading, reported but not fixed.
