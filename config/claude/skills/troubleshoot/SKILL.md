---
name: troubleshoot
description: >
  Investigates a problem introduced or surfaced by the change in progress and
  finds its root cause. Use it during the development flow when something is
  wrong with the change (failing test, crash, regression, unexpected behavior),
  before fixing it. Diagnoses and reports the root cause with evidence and a
  proposed fix; it does not apply the fix.
model: opus
effort: high
disable-model-invocation: true
---

# Troubleshooting

Find the root cause of a problem with the change in progress, prove it with
evidence, and hand off a concrete fix proposal. The fix itself belongs to the
`implement` phase: this skill diagnoses, it does not repair.

## Project context

Before anything else, read these files at the root of the current project:
- `docs/architecture.md` — source of truth for the project architecture.
- `docs/code-style.md` — source of truth for coding conventions.
- `docs/testing.md` — source of truth for how the project is tested and run.

If any file is missing, say so explicitly and continue using general best
practices plus the conventions you infer from the existing code.

## 1. Capture the symptom

Pin down exactly what is wrong before touching anything:
- The observed behavior (error message, stack trace, failing test, wrong output) versus the expected behavior.
- How and when it shows up: which command, test, endpoint or user action triggers it, and whether it is deterministic or intermittent.

Take this from the session context and the user's report. Only ask the user
(single `AskUserQuestion` batch) for what you cannot deduce: typically the exact
reproduction steps, the environment where it fails, or the expected result when
it is ambiguous.

## 2. Scope it to the change

Establish what changed, from the actual diff and never from a description of it:
`git status`, `git diff` for the working tree and `git diff <default-branch>...HEAD`
for the branch. Read every changed file and enough surrounding code to reason
about it. The problem usually lives in this diff or in its interaction with
existing code, but do not assume it: keep pre-existing causes on the table.

## 3. Reproduce

Reproduce the problem deterministically before investigating, using the
project's own commands (`docs/testing.md`). A failing reproduction you control
is the baseline for everything below. If you cannot reproduce it, say so and ask
the user for the missing piece instead of guessing at a cause.

## 4. Investigate to root cause

Work from evidence, not intuition. Form explicit hypotheses and test them one at
a time, discarding each with a concrete observation:
- Narrow the failure: bisect the input, the code path or the commit history (`git log`/`git bisect` against the diff) until the smallest trigger is isolated.
- Read the relevant code paths end to end; trace data and control flow, do not infer behavior you have not seen.
- Add temporary instrumentation (logging, prints, breakpoints) only to gather evidence. Per the workspace rules, remove every temporary change before finishing so the working tree is left exactly as you found it.
- Keep going until you can point to the specific line(s) and explain the causal chain from cause to symptom. Do not stop at the first plausible suspect; confirm it actually produces the failure.

## Hard rules

- Diagnose, do not fix: do not edit source files to repair the problem, commit, or change project state. Temporary instrumentation is allowed only if removed before finishing.
- Report only a root cause you can prove with evidence (a reproduction, a trace, an isolated trigger). If the evidence is inconclusive, say so and report the leading hypotheses with what would confirm each, rather than guessing.
- When the report is delivered, STOP and return control to the user. Do not start the next phases of the flow (implement the fix, review, commit) on your own: the user decides each phase manually.

## Output format

A report with:
- **Symptom**: the observed failure versus the expected behavior, in one or two sentences.
- **Reproduction**: the exact steps/command that trigger it, or a note that it could not be reproduced and why.
- **Root cause**: the specific cause with reference (`file:line`) and the causal chain from cause to symptom.
- **Evidence**: what proves it (failing test, trace, isolated trigger, bisect result).
- **Proposed fix**: how to fix it, described and located (`file:line`), not applied. Note alternatives or trade-offs if there is more than one reasonable fix.
- **Missing docs**: only if `docs/architecture.md`, `docs/code-style.md` or `docs/testing.md` was not found.
