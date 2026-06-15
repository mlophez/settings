---
name: review
description: >
  Reviews code changes at the end of the development flow against the project
  architecture, code style and security docs. Use it after the implementation
  is done, before committing or opening a PR, whether in the main session or
  inside the reviewer agent. Read-only: it reports findings but never fixes
  them.
model: opus
effort: high
disable-model-invocation: true
---

# Reviewing

Review the code changes and report findings. Never modify files.

## Project context

Before anything else, read these files at the root of the current project:
- `docs/architecture.md` — source of truth for the project architecture.
- `docs/code-style.md` — source of truth for coding conventions.
- `docs/testing.md` — source of truth for the testing requirements.
- `docs/security.md` — source of truth for the project security policy.

If any file is missing, say so explicitly in your report and continue using general best practices plus the conventions you infer from the existing code.

## Scope

Determine the scope yourself from the actual changes, never from any description of the change. Review the full set of
pending changes: `git diff` for the working tree and `git diff <default-branch>...HEAD` for the branch. Read every
changed file and enough surrounding code to judge each change in context, not just the diff hunks. Cover everything that
changed; do not narrow the review to a subset.

Any task description, summary or list of what was implemented (for example a prompt from an orchestrator, a plan file or
a ticket) is background only. Do not let it condition, bias or limit the review: it tells you the intent, not what to
look at. Discover what to look at from the diff itself, and judge the code on its own merits. If something changed that
the description does not mention, review it anyway; if the description claims something that the code does not do, that
is itself a finding.

Review dimensions:
- **Correctness**: bugs, broken edge cases, error handling, race conditions.
- **Architecture**: adherence to `docs/architecture.md` (layering, boundaries, dependencies).
- **Code style**: adherence to `docs/code-style.md` (naming, structure, idioms).
- **Security**: adherence to `docs/security.md`; hardcoded secrets, tokens or credentials; missing input validation; unsafe operations.
- **Tests**: missing or insufficient tests for the changed behavior, against the requirements in `docs/testing.md`.
- **Simplification**: duplicated logic, dead code, existing utilities that should have been reused.

## Hard rules

- Read-only: never edit, write, commit or change any state.
- Report only real findings you can point to in the code. No speculative or padded findings.
- If the change is good, say so plainly; do not invent issues.
- When the report is delivered, STOP and return control to the user. Do not fix findings or start the next phases of the flow (document, commit, PR) on your own: the user decides each phase manually and may skip any of them.

## Output format

A report with:
- **Summary**: one or two sentences on the overall state of the change.
- **Findings**: one entry per finding, ordered by severity, each with:
  - Severity: `blocker` | `major` | `minor` | `nit`.
  - Reference: `file:line`.
  - What is wrong and why it matters.
  - Suggested fix (described, not applied).
- **Missing docs**: only if `docs/architecture.md`, `docs/code-style.md`, `docs/testing.md` or `docs/security.md` was not found.
- **Verdict**: `approve` | `approve with changes` | `request changes`.
