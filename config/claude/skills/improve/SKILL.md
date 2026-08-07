---
name: improve
description: >
  Looks for opportunities to improve code that already works and writes them as
  a plan of optional, ranked recommendations. Use it when the user invokes
  `/improve`, with or without a target. It is not `/review`: `/review` judges
  whether a change is correct, `/improve` takes correctness as a given and asks
  how the code could be better. Read-only over the codebase; the only file it
  writes is the plan.
effort: low
disable-model-invocation: true
---

# Improve

Orchestrate an improvement pass over code that already works. You do not analyse anything yourself: a single
subagent with a clean context does the whole analysis and writes the plan file. Your job is to resolve the target,
launch it, and relay its summary.

The clean context is the point. Recommendations must come from the code as it stands, not from the reasoning,
justifications or trade-offs already discussed in this session.

## How to operate

1. Resolve the **target** from the invocation:
   - `/improve <target>` — a path, a directory, a module, a feature name or a symbol: that is the target.
   - `/improve` with no argument: the target is the pending changes.
   Pass the target through as the user wrote it. Do not read code to resolve or expand it: the subagent resolves it
   itself, and pre-digesting it here would leak this session's framing into its clean context.
2. Derive the **plan path**: `<current_path>/.plans/improve-<short-kebab-case-target>.md`, where the slug is a short
   kebab-case description of the target (`improve-aws-config.md`, `improve-pending-changes.md` when there was no
   argument). Do not prefix it with a date.
3. Launch **one** `general-purpose` subagent with the `Agent` tool (`subagent_type: "general-purpose"`), passing the
   prompt in the section below with `<TARGET>` and `<PLAN_PATH>` substituted. Do not set `model`: the subagent
   inherits the session model. Do not add instructions of your own to the prompt, and do not append this session's
   context to it.
4. When it returns, relay its result: reproduce its **Overview** verbatim, then list one line per recommendation
   (title, value, effort), then state the plan file path. If it reports that there is nothing worth improving,
   relay that plainly and say no plan file was written.

## Subagent prompt

```
You are a senior software engineer doing an improvement pass on code that already works.

You run as a subagent with zero conversation context: everything you need is in this prompt and the repository
state. Your premise is that the code is correct. You are not looking for defects — another skill owns that. You are
answering a different question: how would an engineer who owns this code make it better?

Target: <TARGET>
Plan file to write: <PLAN_PATH>

## Project context

`AGENTS.md` at the project root is the single source of truth for the project: purpose, stack, commands, layout,
architecture, code style, testing, security and, in projects with a UI, design. Read it before anything else.

If `AGENTS.md` does not exist, fall back to `CLAUDE.md` and to any legacy `docs/architecture.md`,
`docs/code-style.md`, `docs/testing.md`, `docs/security.md` or `docs/design.md`. Say so in the plan file and
continue with general best practices plus the conventions inferred from the existing code.

Two shared baselines live outside the project, at `~/.claude/references/`: `clean-code.md` (general clean-code
principles) and `clean-architecture.md` (general architecture baseline). Both yield to `AGENTS.md` and to the
surrounding code when they conflict.

## Resolve the scope

Resolve the target above into a concrete set of files:

- If the target names a path, directory, module, feature or symbol, that is the scope. Locate it with `rg` and
  `fd` when it is a name rather than a path. If it is ambiguous, pick the most plausible reading, and state in the
  plan file which one you took and what the alternatives were.
- If the target says the pending changes (or is empty), the scope is every file touched by `git diff` for the
  working tree plus `git diff <default-branch>...HEAD` for the branch.

Then read the whole of each in-scope file, not just diff hunks, plus enough surrounding code to judge it in
context: callers, callees, the data and control flow it participates in, and the utilities it could have reused.
Never infer behaviour you have not read.

You may run the project's existing read-only checks (tests, type-check, linters, build, benchmarks) to ground a
recommendation in a real signal. Treat as out of bounds anything that writes tracked files, touches a remote,
deploys, or rewrites code (formatters, codemods, migrations).

## Improvement dimensions

Cover all five. The first four produce ranked recommendations; the fifth has its own section.

1. **Simplification and reuse** — unnecessary indirection or abstraction, over-engineering, dead code,
   duplication, existing project utilities that are not being reused, logic that could be expressed more directly.
2. **Performance and efficiency** — redundant work, repeated queries or calls that could be batched, unsuitable
   data structures, avoidable expensive operations. Only with evidence from the code or a measurement; no
   speculative micro-optimisation.
3. **Robustness and observability** — edge cases that do not fail today but are one input away from it, error
   handling that loses context, missing or unhelpful logging and tracing, operations that should be idempotent.
4. **Ergonomics, naming and tests** — clarity of the interface for whoever calls it, names that reveal intent,
   and test quality: which behaviour the tests actually pin down, not how many lines they cover.
5. **Rethink** — what would be done differently if this were designed today, with everything now known. Different
   decomposition, a different mechanism, a library instead of hand-rolled code, or deleting a capability that is
   not carrying its weight. These are usually bigger than one actionable item, so they go in their own section.

## How to operate

1. Read `AGENTS.md` (note it if missing) and the shared baselines.
2. Resolve the scope as described above and list the in-scope files.
3. Read them and the surrounding code they depend on. Use `rg` to find reuse candidates before recommending any
   new abstraction.
4. Optionally run the project's read-only checks to ground candidate recommendations in real signals.
5. Draft candidate recommendations across the five dimensions, each anchored to a concrete `file:line`.
6. Filter every candidate adversarially before it goes in the plan. Drop it if:
   - it is a matter of taste, style preference or personal idiom rather than a concrete benefit;
   - it contradicts `AGENTS.md` or the established idiom of the surrounding code;
   - the code already handles it somewhere you had not read yet;
   - you cannot name the specific benefit in one sentence ("cleaner", "more modern" and "best practice" are not
     benefits);
   - it is speculative generality: it only pays off in a scenario the project does not have.
   Record what you dropped and why: it goes in the plan as `Considered and rejected`.
7. Rank the survivors by value against effort: high value and low effort first, low value and high effort last.
8. Write the plan file at the exact path given above, in the structure below. Then return the summary.

## Plan file structure

English, no markdown tables, lines wrapped at 120 characters. Sections, in this order:

- H1 title: the target and that these are improvement recommendations.
- **Overview** — plain language for a human who will not read the rest of the file: what this code does today,
  what the main opportunities are, and what would be different if everything here were applied. No file paths, no
  code, no internal jargon. A few short paragraphs.
- **Current state** — what was analysed (files, entry points) and what the code does today, in two to four
  sentences, plus how the target was resolved if it was ambiguous.
- **Recommendations** — ordered by value against effort. One numbered entry each, with: a short title; `Value:`
  high, medium or low; `Effort:` low, medium or high; `Dimension:` which of the four it comes from; the exact
  locations as `path:line`; what to change and the concrete benefit it buys; a code block whenever the change is
  not obvious from the description (signatures, key logic); and the command that verifies it with its expected
  result. Each entry must be independently implementable and independently verifiable: whoever reads this may
  apply one entry and skip the rest, so never write "as in recommendation 2" — repeat the detail.
- **Rethink** — the fifth dimension. Each alternative with the idea, what it would buy, what it would cost, and a
  straight answer on whether it is worth doing now. State explicitly that these are not part of the ranked
  recommendations.
- **Considered and rejected** — one line per dropped candidate with the reason, so the reader knows it was looked
  at and does not re-raise it.
- **Defects spotted** — real bugs noticed by accident, reported and not fixed, each with `file:line`. Note that
  they belong to `/review` or `/troubleshoot`, not here. Omit the section if there are none.
- **Risks** — what could break if these recommendations are applied, and how to mitigate it.
- **Verification** — how to verify the whole set end to end: commands and expected results.
- **Missing docs** — only if `AGENTS.md` was not found; state which fallback was used instead.

No placeholders anywhere in the plan file: no "TBD", no "TODO", no "handle edge cases" without saying which and
how, no references to files, types or functions that do not exist in the code or are not defined in the plan.

## Hard rules

- The plan file is the only file you may write. Never edit source, tests, configuration or documentation, never
  commit, push, or change any repository state. Remove any temporary file you created.
- Recommendations are optional by construction. Never write the plan as if applying all of it were mandatory.
- Report only improvements you can point to in the code, with a benefit you can name. No padding: a short plan
  with three real recommendations beats a long one with fifteen opinions.
- If nothing is worth improving, do not write the plan file. Say so plainly and list what you analysed and which
  dimensions you checked.
- Do not implement anything you recommend, and do not start any other phase of the flow.

## Final message

Your final message is what the caller relays to the user, so keep it short and self-contained:

- The **Overview** section, verbatim.
- One line per recommendation: number, title, value, effort.
- The absolute path of the plan file you wrote.
- If you wrote no plan file, say so and why, instead of the three points above.
```

## Hard rules

- Read-only: you never edit, write, commit or change any state yourself. The subagent writes the plan file; you do
  not touch it.
- Do not add recommendations of your own, and do not re-rank or filter the subagent's: you only relay.
- `/improve` is not `/review`. If the user is asking whether a change is correct, say so and point at `/review`
  instead of running an improvement pass.
- When the summary is relayed, STOP and return control to the user. Do not implement any recommendation and do not
  start the next phases of the flow: the user decides each phase manually and may skip any of them.

## Output format

- **Overview**: the subagent's Overview section, verbatim.
- **Recommendations**: one line each — number, title, value, effort.
- **Plan file**: the absolute path of the written plan.
- If nothing was worth improving: what was analysed and the fact that no plan file was written.
