---
name: plan
description: >
  Writes a self-contained implementation plan in .plans/ to be executed
  later, after interviewing the user on open questions. Use it when the
  user asks to plan a feature, a refactor or a bugfix, before writing any
  code. It works without plan mode; never enter plan mode for it.
model: opus
effort: high
disable-model-invocation: true
---

# Writing plans

Produce an implementation plan that anyone can execute without asking
anything: it may be implemented by a subagent with zero conversation context,
the current session or the user directly, so every decision must be resolved
here and the plan file must be self-contained. Do not assume any particular
executor in the plan file, and do not name a specific agent in it.

**Rules (apply to every step):**
- This skill replaces plan mode: do NOT call `EnterPlanMode`. The exploration is read-only and the only file written is the plan file, which the user reviews afterwards.
- Interview the user in the language of the session; the plan file is ALWAYS in English.
- Do not write markdown tables in the plan file.
- Wrap lines in the plan file at 120 characters maximum (code blocks included when feasible).
- Whoever implements the plan reads `docs/architecture.md`, `docs/code-style.md` and `docs/testing.md` on their own: do not restate conventions, reference them.

## 1. Project context

Read these files at the root of the current project:
- `docs/architecture.md` — source of truth for the project architecture.
- `docs/code-style.md` — source of truth for coding conventions.
- `docs/testing.md` — source of truth for how changes are tested; feeds the "Verification" section.
- `docs/design.md` — source of truth for the product/system design; the plan must be consistent with it. It only exists in projects with a UI (the project `CLAUDE.md` references it in that case).

If any file is missing, note it in the plan and continue using general best
practices plus the conventions inferred from the existing code. Exception:
a missing `docs/design.md` is only worth noting if the project `CLAUDE.md`
references it; in a project without UI its absence is correct.

## 2. Explore

Explore the relevant code with `rg` and targeted reads. Trace the real code
paths, do not guess. Identify reusable functions and utilities, and the
minimal set of files to touch.

## 3. Brainstorm solutions

Before interviewing, think through the problem and design more than one way to
solve it. The goal is to surface real alternatives and their trade-offs, not to
rubber-stamp the first idea:

- Devise two to four genuinely distinct approaches (not cosmetic variants). For each one capture: the core idea, how it fits the documented architecture and design, its main trade-offs (complexity, risk, effort, performance, maintainability, blast radius) and what it implies for the rest of the system.
- Discard approaches that clearly violate the architecture or design and say why in one line; keep the ones worth a real decision.
- Form your own recommendation with its rationale, but stay open to the user steering elsewhere during the interview.
- This is a thinking step: explore options in your reasoning. The alternatives considered and the chosen one are recorded later in the plan ("Approach", with the discarded options and why).

## 4. Interview

Combine two things in a single interview pass: the choice of approach from the
brainstorm and every open question the task still leaves unanswered (ambiguous
requirements, unstated constraints, decisions with more than one reasonable
option: scope, edge-case behavior, compatibility, priorities).

- Present the brainstormed approaches as the first question: each option with its core trade-offs and your recommended one first (marked as recommended). Let the user pick or propose their own.
- Then ask the remaining open questions. Ask only what cannot be resolved from the task description, the docs or the code. Never ask something the codebase already answers.
- Ask in one batch with `AskUserQuestion` (grouped free text if unavailable), each question with the options seen and a recommended default. Use the option previews to show short trade-off summaries or snippets when it helps the user compare.
- If the user does not answer some question, take the recommended default (including the recommended approach) and record it in the plan as an assumption.
- Record every answer and assumption in the "Decisions" section, so the plan stays self-contained.

## 5. Plan file

Path: `.plans/<short-kebab-case-description>.md`
(e.g. `.plans/add-retry-to-webhook-sender.md`). Do not prefix the file name with
a date or timestamp: deriving the current date slows down generation.

Write the plan file directly after the interview. Exception: if the session
already happens to be in plan mode (file writes blocked), present the plan
via `ExitPlanMode` and write the file as the FIRST action after approval,
before anything else.

Structure:
- H1 title with a one-line description of the task (no date).
- **Overview**: a high-level summary written in plain language for a human reader who will not read the rest of the file: what is going to change and why, the key decisions taken and their rationale, and the visible effect once done. No file paths, no code, no internal jargon. A few short paragraphs or bullets.
- **Context**: the problem and the intended outcome, in two or three sentences.
- **Decisions**: the answers gathered in the interview and the assumptions taken for unanswered questions.
- **Approach**: the chosen approach and why it fits the documented architecture and design. Briefly list the
  brainstormed alternatives that were considered and the one-line reason each was discarded.
- **Tasks**: ordered tasks, each one independently implementable and verifiable, with:
  - Exact file paths to create or modify (`path:line` when useful) and existing utilities to reuse.
  - Code blocks for anything non-obvious: signatures, interfaces, key logic. Whoever implements it fills in routine code, not design decisions.
  - The verification command for the task with its expected result.
- **Risks**: what could break and how to mitigate it.
- **Verification**: how to verify the change end to end (commands, tests).
- **Missing docs**: only if `docs/architecture.md`, `docs/code-style.md` or `docs/testing.md` was not found, or if `docs/design.md` is referenced by the project `CLAUDE.md` but missing.

No placeholders. These are plan failures, never write them:
- "TBD", "TODO", "implement later", "fill in details".
- "Add appropriate error handling" / "handle edge cases" without saying which and how.
- "Similar to Task N" — repeat the detail; tasks may be read in isolation.
- References to types, functions or files not defined in any task or in the existing code.

## 6. Self-review

Before handing off, check the plan with fresh eyes:
1. **Coverage**: every requirement and every interview answer maps to a task. List any gap and fix it.
2. **Placeholder scan**: search the plan for the patterns above and fix them.
3. **Consistency**: names, signatures and paths used in later tasks match the ones defined in earlier tasks and in the real code.

## 7. Handoff

After writing the file, STOP and return control to the user. Report the plan
path and reproduce the **Overview** section verbatim in your final message,
so the user can judge the plan without opening the file. Offer the next
step, but do NOT start implementing on your own: the
user decides each phase of the flow manually. Typical next steps the user may
choose:
- Review the plan file manually and ask for adjustments.
- Dispatch the `implementer` agent with the plan path (one dispatch for the whole plan, or one per task for large plans, reviewing between tasks).
- Implement in the current session with the `implement` skill.
- Skip implementation entirely.
