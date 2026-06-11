---
name: setup
description: >
  Generates the base documentation of a project (docs/architecture.md,
  docs/code-style.md, docs/testing.md, docs/security.md, docs/design.md,
  README.md and CLAUDE.md) by interviewing the user. Use it when the user
  says "/setup", "initialize the project", "generate the project docs", or
  starts a new project without docs/.
disable-model-invocation: true
---

# Setup project docs

Bootstrap the documentation that the `plan`, `implement`, `review` and
`document` skills (and the agents that preload them) read as sources of truth. The
interview is the single authority on what gets written: the skill may analyze
the project in read-only mode to propose default answers (see step 1), but it
never writes an inferred value the user did not confirm.

**Rules (apply to every step):**
- Interview the user in the language of the session; generated files are ALWAYS in English.
- Generated files always follow the templates in `templates/` of this skill: same headings, same order. Never invent new structure.
- Do not write markdown tables in the generated files.
- Ask per thematic block (one `AskUserQuestion` call per block for closed questions, grouped free-text questions for open ones). Do not interrogate one question at a time. `AskUserQuestion` allows at most 4 questions per call: if a block accumulates more closed questions, split them into several calls within the same block. If `AskUserQuestion` is not available, ask the closed questions as grouped free text too.
- Keep the file name `architecture.md` exactly as is (the agents expect this spelling).

## 0. Pre-checks

Check if any of `CLAUDE.md` (project root), `README.md` (project root),
`docs/architecture.md`, `docs/code-style.md`, `docs/testing.md`,
`docs/security.md` or `docs/design.md` already exists.

- The full interview ALWAYS runs, even if some or all files exist; existing
  files are regenerated from the new answers.
- If any file exists, list the ones that will be overwritten and confirm once
  before starting the interview.
- If `docs/arquitecture.md` exists (the misspelling used by old versions of
  this skill), treat it as the existing `docs/architecture.md`: use it as a
  default-answer source like any other existing doc, and delete it during
  generation so only `docs/architecture.md` remains.
- When regenerating `docs/architecture.md`, preserve the existing content of
  its "Architecture decisions" section instead of resetting it to `None yet.`
- If `docs/design.md` exists but the block 2 answer is that the project has
  no UI, warn that it is now obsolete and ask for confirmation to delete it;
  either way, do not reference it from the generated `CLAUDE.md` or
  `README.md`.

## 1. Gather defaults

Before interviewing, collect a proposed default answer for each question so
the user only corrects what is wrong or missing. Sources, in priority order:

1. The existing docs from the pre-checks: their content was already
   confirmed by the user in a previous run, so it is the best default.
2. Read-only analysis of the project code: manifests (`package.json`,
   `pyproject.toml`, `go.mod`...), `Justfile`/`Makefile`, the folder tree,
   linter/formatter configs and CI workflows.

When a default comes from code analysis, state its origin when presenting it
(e.g. "inferred from package.json") so the user knows it needs validation.
The interview remains the single authority: an inferred default the user did
not confirm is never written.

## 2. General context block (feeds all files)

Ask:
- Project name and purpose (free text, 2-4 sentences).
- Project type: backend / frontend or fullstack / CLI or library / infra
  (closed options; `AskUserQuestion` allows at most 4 options and the
  automatic "Other" covers anything else). The UI and stack questions
  refine the nuance (e.g. frontend vs fullstack).
- Does it have a UI? → decides whether `docs/design.md` is generated and block 6 runs.
- Main stack: language(s), framework(s), versions (free text).

## 3. Architecture block → `docs/architecture.md`

Ask:
- Folder layout and what goes in each folder.
- Layers/components, their responsibilities and dependency rules between them.
- External integrations (APIs, queues, third parties) — omit the section if not applicable.
- Persistence (database, schema approach, migrations) — omit the section if not applicable.
- Configuration and environments (local/pre/pro, secrets handling).

Do not ask about "Architecture decisions": that section is a cumulative log
that always starts with `None yet.`

## 4. Code conventions block → `docs/code-style.md`

Ask:
- Formatter/linter tools and the exact commands.
- Naming conventions and file organization.
- Error handling and logging approach.
- Dependency policy and git workflow (branches, commits).
- Forbidden patterns / anti-patterns in this project.

## 5. Testing block → `docs/testing.md`

Ask:
- Strategy: kinds of tests in the project (unit, integration, e2e...) and
  when each one is required.
- Running tests: the exact command for each suite, including how to run a
  single test.
- Writing tests: framework, test location, naming, fixtures/mocks and test
  data.
- Acceptance criteria: what a change needs to be accepted (coverage,
  required kinds of tests).

## 6. Design block (only if the project has a UI) → `docs/design.md`

Ask:
- Visual identity and tone.
- Colors and tokens, typography, spacing.
- Where shared components and the theme live, how to reuse them.
- Standard UI states (loading, error, empty) and accessibility/i18n requirements.

## 7. Security block → `docs/security.md`

Always generated: security applies to every project, and unanswered sections
stay as `TBD`. Reuses the secrets handling answer from block 3 — do not ask
for it again: `docs/architecture.md` keeps where and how configuration and
secrets are loaded, `docs/security.md` records the policy. Ask:
- Secrets & credentials policy: what counts as a secret, where secrets live,
  how they are injected and rotated.
- Authentication & authorization approach — omit the section if not applicable.
- Input validation and sensitive data: validation approach, what
  sensitive/personal data the project handles, what must never be logged.
- Dependency audit: tooling and update policy.
- Compliance requirements (ENS, eIDAS, GDPR...) — omit the section if not applicable.

## 8. CLAUDE.md block

Reuses the lint commands from block 4 and the test commands from block 5; do
not ask for them again. Ask:
- Build and run commands (free text), then confirm the full command set
  (build, test, lint, run).
- Project-specific notes not derivable from the code (AWS profiles, kubectl contexts, quirks).

## 9. README block → `README.md`

Reuses the purpose (block 2) and the main commands (blocks 4, 5 and 8): the
"Development" section is filled with those commands and the "Usage" section
starts from the run command of block 8, do not ask for them again. Only ask:
- Requirements: runtimes, SDKs, tools and accesses needed, with versions.
- Setup: steps to get the project running locally the first time.
- Usage examples: only if applicable, basic usage examples (endpoints, CLI
  invocations...) to complement the run command.

## 10. Generation

1. Create `docs/` if it does not exist.
2. For each file to generate, copy the matching template from `templates/`
   in this skill and fill each section with the answers:
   - Remove the `<!-- ... -->` guidance comments and follow any conditional
     instructions they contain.
   - Sections without information are filled with `TBD` — never delete them —
     except sections whose guidance comment says "Omit this section ...",
     which are removed entirely when the condition applies.
   - In `CLAUDE.md`, only reference `docs/design.md` if the project has a UI
     and the file exists or was generated.
3. Show a summary of the created files, list the sections left as `TBD` so
   the user knows what remains to be completed, and remind the user to
   commit them.
