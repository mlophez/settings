---
name: review
description: >
  Reviews the pending code changes at the end of the development flow by
  launching two `reviewer` agents in parallel and merging their reports. Use it
  after the implementation is done, before committing or opening a PR.
  Read-only: it reports findings but never fixes them.
effort: low
disable-model-invocation: true
---

# Review

Orchestrate the review. You do not review anything yourself: the whole methodology lives in the `reviewer` agent. Your
job is to launch two of them in parallel and merge their reports.

## How to operate

1. Launch **two `reviewer` agents in a single message** so they run concurrently. Each gets the same task prompt except
   for its focus:
   - Agent A — focus: **Correctness, Security, Tests**.
   - Agent B — focus: **Architecture, Code style, Clean code, Simplification**.
2. Give both the same context: the working directory and, only as background, any task description available in the
   session (make explicit that it is background and must not limit the review; the agent resolves scope from `git diff`
   itself).
3. Wait for both reports, then merge them into a single report in the output format below.

## Merge rules

- Deduplicate findings that point at the same `file:line` and the same underlying problem: keep one entry, with the
  highest severity of the two and the clearest description.
- Keep every non-duplicate finding from both agents; never drop a finding just to shorten the report.
- Order the merged findings by severity (`blocker`, `major`, `minor`, `nit`), then by file.
- Drop the `Out of focus` notes that the other agent already reported as a proper finding. Relay the rest verbatim in
  an `Unverified notes` section, with the severity the reporting agent gave them, stating that they come from a
  reviewer working outside its focus and were not verified. Never promote them to `Findings` yourself.
- Union the `Coverage` sections; state it plainly if the two agents disagree on what was covered.
- Final verdict is the strictest of the two: `request changes` > `approve with changes` > `approve`.
- If one agent fails or returns nothing, report the other one's result and say explicitly that half of the review is
  missing and which dimensions were not covered.

## Hard rules

- Read-only: never edit, write, commit, push or change any state.
- Do not add findings of your own; you only merge what the agents reported.
- When the merged report is delivered, STOP and return control to the user. Do not fix findings or start the next phases
  of the flow (document, commit, PR) on your own: the user decides each phase manually and may skip any of them.

## Output format

- **Summary**: one or two sentences on the overall state of the change.
- **Findings**: merged and ordered by severity, each with severity, `file:line`, what is wrong and why it matters, and
  the suggested fix (described, not applied).
- **Coverage**: files and areas reviewed, read-only checks run and their result, anything left out of scope.
- **Unverified notes**: `Out of focus` notes with no counterpart finding, relayed as reported; omit the section if there
  are none.
- **Missing docs**: only if the agents reported that `AGENTS.md` was not found.
- **Verdict**: `approve` | `approve with changes` | `request changes`.
