---
name: review
description: >
  Reviews code changes at the end of the development flow against the project
  architecture, code style and security docs. Use it after the implementation
  is done, before committing or opening a PR, whether in the main session or
  inside the reviewer agent. Read-only: it reports findings but never fixes
  them.
#model: opus
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

You may run the project's existing read-only checks (tests, type-check, linters, build) to ground findings in real
signals, provided they do not modify any tracked file or repository state. Treat any command that would write tracked
files, touch a remote, deploy, or rewrite code (formatters, codemods, migrations) as out of bounds.

Review dimensions:
- **Correctness**: bugs, broken edge cases, error handling, race conditions.
- **Architecture**: adherence to `docs/architecture.md` (layering, boundaries, dependencies) and to the general
  architecture baseline `clean-architecture.md` in this skill's directory (domain validation, immutability,
  pure/shell separation, use-case input validation), as a baseline that yields to `docs/architecture.md` and the
  surrounding code when they conflict.
- **Code style**: adherence to `docs/code-style.md` (naming, structure, idioms).
- **Clean code**: adherence to the general clean-code principles in `clean-code.md` (in this skill's directory), as a
  baseline that yields to `docs/code-style.md` and the surrounding code when they conflict.
- **Security**: adherence to `docs/security.md`; hardcoded secrets, tokens or credentials; missing input validation; unsafe operations.
- **Tests**: missing or insufficient tests for the changed behavior, against the requirements in `docs/testing.md`.
- **Simplification**: over-engineering, unnecessary indirection or abstraction, and code that could be expressed more
  directly (the DRY, dead-code and reuse items are covered under Clean code above).

## How to operate

1. Read `docs/architecture.md`, `docs/code-style.md`, `docs/testing.md` and `docs/security.md` (note any that are
   missing), plus the two shared baselines `clean-code.md` and `clean-architecture.md` in this skill's directory.
   For each absent docs file, fall back to best practices and the conventions inferred from the existing code.
2. Resolve the scope from the actual changes: `git diff` for the working tree and `git diff <default-branch>...HEAD`
   for the branch. List every changed file; do not narrow to a subset.
3. For each changed file, read the file and enough surrounding code to judge the change in context, not just the diff
   hunk. Trace the data and control flow the change participates in: callers, callees, error paths and edge cases.
4. Optionally run the project's read-only checks (tests, type-check, linters, build) to confirm or refute suspected
   correctness or test gaps. Never run anything that mutates files or state.
5. Draft candidate findings across the review dimensions, each anchored to a concrete `file:line`.
6. Adversarially verify every candidate finding before reporting it: re-read the cited code and try to refute the
   finding. Drop anything you cannot still point to in the code, anything already handled elsewhere, and anything that
   is speculative or a matter of taste. Only findings that survive this pass go in the report.
7. Calibrate severity and write the report in the output format below.

## Hard rules

- Read-only: never edit, write, commit, push or change any state. Running the project's read-only checks (tests,
  type-check, linters, build) is allowed only when they do not modify tracked files or repository state.
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
- **Coverage**: which files and areas were reviewed, whether read-only checks were run and their result, and anything
  deliberately left out of scope.
- **Missing docs**: only if `docs/architecture.md`, `docs/code-style.md`, `docs/testing.md` or `docs/security.md` was not found.
- **Verdict**: `approve` | `approve with changes` | `request changes`.
