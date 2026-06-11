---
name: plan
description: >
  Writes an implementation plan in docs/plans/ for the implementer agent to
  execute, after interviewing the user on open questions. Use it when the
  user asks to plan a feature, a refactor or a bugfix, before writing any
  code. It works without plan mode; never enter plan mode for it.
---

# Writing plans

Produce an implementation plan that the `implementer` agent can execute
without asking anything: it runs as a subagent with zero conversation
context, so every decision must be resolved here and the plan file must be
self-contained.

**Rules (apply to every step):**
- This skill replaces plan mode: do NOT call `EnterPlanMode`. The exploration is read-only and the only file written is the plan file, which the user reviews afterwards.
- Interview the user in the language of the session; the plan file is ALWAYS in English.
- Do not write markdown tables in the plan file.
- Wrap lines in the plan file at 120 characters maximum (code blocks included when feasible).
- The implementer reads `docs/architecture.md`, `docs/code-style.md` and `docs/testing.md` on its own: do not restate conventions, reference them.

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

## 3. Interview

List every open question the task leaves unanswered: ambiguous requirements,
unstated constraints, decisions with more than one reasonable option (scope,
behavior on edge cases, compatibility, priorities). Then interview the user:

- Ask only what cannot be resolved from the task description, the docs or the code. Never ask something the codebase already answers.
- Ask in one batch with `AskUserQuestion` (grouped free text if unavailable), each question with the options seen and a recommended default.
- If the user does not answer some question, take the recommended default and record it in the plan as an assumption.
- Record every answer and assumption in the "Decisions" section, so the plan stays self-contained.

## 4. Plan file

Path: `docs/plans/<YYYYMMDDHHMM>-<short-kebab-case-description>.md`
(e.g. `docs/plans/202606101732-add-retry-to-webhook-sender.md`).

Write the plan file directly after the interview. Exception: if the session
already happens to be in plan mode (file writes blocked), present the plan
via `ExitPlanMode` and write the file as the FIRST action after approval,
before anything else.

Structure:
- H1 title with the date and a one-line description of the task.
- A note right under the title: "To be executed by the `implementer` agent."
- **Overview**: a high-level summary written in plain language for a human reader who will not read the rest of the file: what is going to change and why, the key decisions taken and their rationale, and the visible effect once done. No file paths, no code, no internal jargon. A few short paragraphs or bullets.
- **Context**: the problem and the intended outcome, in two or three sentences.
- **Decisions**: the answers gathered in the interview and the assumptions taken for unanswered questions.
- **Approach**: the chosen approach and why it fits the documented architecture and design.
- **Tasks**: ordered tasks, each one independently implementable and verifiable, with:
  - Exact file paths to create or modify (`path:line` when useful) and existing utilities to reuse.
  - Code blocks for anything non-obvious: signatures, interfaces, key logic. The implementer fills in routine code, not design decisions.
  - The verification command for the task with its expected result.
- **Risks**: what could break and how to mitigate it.
- **Verification**: how to verify the change end to end (commands, tests).
- **Missing docs**: only if `docs/architecture.md`, `docs/code-style.md` or `docs/testing.md` was not found, or if `docs/design.md` is referenced by the project `CLAUDE.md` but missing.

No placeholders. These are plan failures, never write them:
- "TBD", "TODO", "implement later", "fill in details".
- "Add appropriate error handling" / "handle edge cases" without saying which and how.
- "Similar to Task N" — repeat the detail; tasks may be read in isolation.
- References to types, functions or files not defined in any task or in the existing code.

## 5. Self-review

Before handing off, check the plan with fresh eyes:
1. **Coverage**: every requirement and every interview answer maps to a task. List any gap and fix it.
2. **Placeholder scan**: search the plan for the patterns above and fix them.
3. **Consistency**: names, signatures and paths used in later tasks match the ones defined in earlier tasks and in the real code.

## 6. Handoff

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
