---
name: setup
description: >
  Generates the single source of truth for a project (AGENTS.md, plus a thin CLAUDE.md
  that imports it and a README.md) by interviewing the user, and installs the validation
  hooks and the scripts/agent/ tooling scripts. Use it when the user says "/setup",
  "initialize the project", "generate the project docs", or starts a new project without
  an AGENTS.md.
disable-model-invocation: true
---

# Setup project docs

Bootstrap the single source of truth that the `plan`, `implement`, `review` and
`document` skills (and the agents that preload them) read, and wire the hooks
that enforce it mechanically. The interview is the single authority on what gets
written: the skill may analyze the project in read-only mode to propose default
answers (see step 1), but it never writes an inferred value the user did not
confirm.

**Rules (apply to every step):**
- Interview the user in the language of the session; generated files are ALWAYS in English.
- Generated files always follow the templates in `templates/` of this skill — `templates/AGENTS.md`, `templates/CLAUDE.md`, `templates/README.md`, `templates/hooks.sh`, `templates/settings.hooks.json` and `templates/scripts/` — with the same headings and the same order. Never invent new structure.
- `AGENTS.md` is the single source of truth. Never write project information into a second file: `CLAUDE.md` only imports it plus Claude-specific notes, and `README.md` only targets human readers.
- Keep `AGENTS.md` concise (target under 250 lines): one-line bullets, no prose, no restating the code.
- Do not write markdown tables in the generated files.
- Ask per thematic block (one `AskUserQuestion` call per block for closed questions, grouped free-text questions for open ones). Do not interrogate one question at a time. `AskUserQuestion` allows at most 4 questions per call: if a block accumulates more closed questions, split them into several calls within the same block. If `AskUserQuestion` is not available, ask the closed questions as grouped free text too.

## 0. Pre-checks

Check if any of these already exists: `AGENTS.md` (project root), `CLAUDE.md`
(project root), `README.md` (project root), `.claude/settings.json`,
`scripts/agent/`, and the legacy documentation set `docs/architecture.md`,
`docs/arquitecture.md` (the misspelling used by old versions of this skill),
`docs/code-style.md`, `docs/testing.md`, `docs/security.md`, `docs/design.md`.

- The full interview ALWAYS runs, even if some or all files exist; existing
  files are regenerated from the new answers.
- List everything that will be overwritten or deleted and confirm once before
  starting the interview. The legacy `docs/` deletions are presented as a single
  item of that confirmation.
- Never touch `docs/usecases/` or any other file under `docs/`: only the legacy
  files listed above are migrated into `AGENTS.md` and deleted.
- When regenerating, preserve the existing content of the
  `## Architecture decisions` section instead of resetting it to `None yet.`,
  reading it from `AGENTS.md` or, when migrating, from the legacy
  `docs/architecture.md`.
- If the project has no UI (block 2), the `## Design` section is not generated,
  and a legacy `docs/design.md` is deleted with the rest of the legacy set.

## 1. Gather defaults

Before interviewing, collect a proposed default answer for each question so
the user only corrects what is wrong or missing. Sources, in priority order:

1. The existing `AGENTS.md` and the legacy `docs/*.md` from the pre-checks:
   their content was already confirmed by the user in a previous run, so it is
   the best default.
2. An existing `.claude/settings.json`, to detect which hooks are already
   installed and which scripts they point at.
3. Read-only analysis of the project code: manifests (`package.json`,
   `pyproject.toml`, `go.mod`...), `Justfile`/`Makefile`, the folder tree,
   linter/formatter configs (`.ruff.toml`, `eslint.config.*`, `.golangci.yml`,
   `.pre-commit-config.yaml`) and CI workflows. These also feed the tooling
   commands of the hooks block.

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
- Does it have a UI? → decides whether the `## Design` section is generated and
  whether block 6 runs.
- Main stack: language(s), framework(s), versions (free text).

## 3. Architecture block → `## Project layout` and `## Architecture`

Ask:
- Folder layout and what goes in each folder.
- Layers/components, their responsibilities and dependency rules between them.
- External integrations (APIs, queues, third parties) — omit the section if not applicable.
- Persistence (database, schema approach, migrations) — omit the section if not applicable.
- Configuration and environments (local/pre/pro, secrets handling).

Do not ask about "Architecture decisions": that section is a cumulative log
that always starts with `None yet.`

## 4. Code conventions block → `## Code style`

Ask:
- Formatter/linter tools and the exact commands.
- Naming conventions and file organization.
- Error handling and logging approach.
- Dependency policy and git workflow (branches, commits).
- Forbidden patterns / anti-patterns in this project.

## 5. Testing block → `## Testing`

Ask:
- Strategy: kinds of tests in the project (unit, integration, e2e...) and
  when each one is required.
- Running tests: the exact command for each suite, including how to run a
  single test.
- Writing tests: framework, test location, naming, fixtures/mocks and test
  data.
- Acceptance criteria: what a change needs to be accepted (coverage,
  required kinds of tests).

## 6. Design block (only if the project has a UI) → `## Design`

Ask:
- Visual identity and tone.
- Colors and tokens, typography, spacing.
- Where shared components and the theme live, how to reuse them.
- Standard UI states (loading, error, empty) and accessibility/i18n requirements.

## 7. Security block → `## Security`

Always generated: security applies to every project, and unanswered sections
stay as `TBD`. Reuses the secrets handling answer from block 3 — do not ask
for it again: `## Architecture` keeps where and how configuration and secrets
are loaded, `## Security` records the policy. Ask:
- Secrets & credentials policy: what counts as a secret, where secrets live,
  how they are injected and rotated.
- Authentication & authorization approach — omit the section if not applicable.
- Input validation and sensitive data: validation approach, what
  sensitive/personal data the project handles, what must never be logged.
- Dependency audit: tooling and update policy.
- Compliance requirements (ENS, eIDAS, GDPR...) — omit the section if not applicable.

## 8. Commands & project notes block → `## Commands` and `## Project notes`

Reuses the lint and format commands from block 4 and the test commands from
block 5; do not ask for them again. Ask:
- Build and run commands (free text), then confirm the full command set
  (build, run, test, single test, lint, format).
- Project-specific notes not derivable from the code (AWS profiles, kubectl contexts, quirks).

## 9. Hooks & validation block → `.claude/settings.json` + `scripts/agent/`

Hooks are what makes the conventions enforceable instead of advisory. Ask, in one `AskUserQuestion` call:

- Which hooks to install (multi-select, all four selected by default):
  - `format-on-edit` — formats the file right after every Edit/Write. Never blocks.
  - `lint-on-edit` — lints the edited file and blocks the agent until it is clean.
  - `validate-on-stop` — runs lint, build and tests when the turn ends and blocks the stop if they fail.
  - `guard` — denies edits to protected paths and asks before writing credential-looking content.
- Protected paths for the guard, if it was selected. Propose defaults from the project layout: `.env*`, private
  keys and certificates, detected lockfiles and generated directories.

Do not ask again for the formatter, linter, build or test commands: reuse blocks 4, 5 and 8. Derive the per-file
dispatch from the project stack — one `case` branch per file extension the project actually contains.

All the commands go into a single easily editable file, `hooks.sh` at the project root: `format_file` and
`lint_file` (per file type), `run_lint`/`run_build`/`run_test` (project-wide), `PROTECTED_PATHS` and
`SECRET_PATTERNS`. The scripts under `scripts/agent/` hold only the hook logic and source that file; never put a
project command inside them.

If the user selects no hook, skip the `scripts/agent/` generation and the `.claude/settings.json` merge entirely,
and omit the `## Agent hooks` section from `AGENTS.md` and the hooks bullet from `CLAUDE.md`.

## 10. README block → `README.md`

Reuses the purpose (block 2) and the main commands (blocks 4, 5 and 8): the
"Development" section is filled with those commands and the "Usage" section
starts from the run command of block 8, do not ask for them again. Only ask:
- Requirements: runtimes, SDKs, tools and accesses needed, with versions.
- Setup: steps to get the project running locally the first time.
- Usage examples: only if applicable, basic usage examples (endpoints, CLI
  invocations...) to complement the run command.

## 11. Generation

1. Generate `AGENTS.md` from `templates/AGENTS.md`, filling each section with the interview answers:
   - Remove the `<!-- ... -->` guidance comments and follow any conditional instruction they contain.
   - Sections without information are filled with `TBD` — never delete them — except sections whose guidance
     comment says "Omit this section ...", which are removed entirely when the condition applies.
   - `## Design` is generated only when the project has a UI; `## Agent hooks` only when hooks were installed.
2. Generate `CLAUDE.md` from `templates/CLAUDE.md`: the `@AGENTS.md` import plus, only when there is something to
   say, the `## Claude Code` section. Never duplicate project information here.
3. Generate `README.md` from `templates/README.md`.
4. If any hook was selected:
   - Copy `templates/hooks.sh` to `hooks.sh` at the project root and fill it with the real commands: the
     `format_file` and `lint_file` dispatch branches per file extension, `run_lint`/`run_build`/`run_test`, and the
     `PROTECTED_PATHS` entries. Leave a function returning 3 when the project has no such tool; never invent a
     command the user did not confirm. `SECRET_PATTERNS` stays as shipped unless the user asks for changes.
   - Create `scripts/agent/` and copy from `templates/scripts/` only the scripts backing the selected hooks
     (`format.sh` for format-on-edit, `lint.sh` for lint-on-edit, `after-edit.sh` when either of the two was
     selected, `validate.sh` for validate-on-stop, `guard.sh` for the guard) plus `README.md`, then
     `chmod +x scripts/agent/*.sh`. Do not copy a script whose hook was not selected: `after-edit.sh` activates
     each step by the mere existence of its script. These scripts are copied verbatim: they contain no project
     command, they source `hooks.sh`.
   - Build the settings fragment from `templates/settings.hooks.json`, dropping the entries for hooks that
     were not selected (`PreToolUse` for the guard, `Stop` for validate-on-stop, `PostToolUse` when neither
     format-on-edit nor lint-on-edit was selected).
   - Merge it into `.claude/settings.json`, preserving every other key and making the merge repeatable by first
     dropping the entries pointing at `scripts/agent/` from a previous run:

     ```bash
     mkdir -p .claude
     [ -f .claude/settings.json ] || echo '{}' > .claude/settings.json
     jq -s '
       def strip_ours:
         with_entries(
           # The parentheses are mandatory: without them "map" would apply to the whole
           # {key, value} entry instead of to the rewritten hook list.
           .value = (
             [ .value[] | .hooks = [ .hooks[] | select((.command // "") | test("scripts/agent/") | not) ] ]
             | map(select((.hooks | length) > 0))
           )
         );
       .[0] as $cur | .[1] as $new
       | (($cur.hooks // {}) | strip_ours) as $kept
       | $cur + { hooks: ($kept + ($new.hooks | with_entries(.value = (($kept[.key] // []) + .value)))) }
     ' .claude/settings.json <fragment.json> > .claude/settings.json.tmp \
       && mv .claude/settings.json.tmp .claude/settings.json
     ```

     Write `<fragment.json>` to a temporary file first, and delete it afterwards.
   - Smoke-test the scripts before reporting success: `bash -n` on each generated script, and
     `scripts/agent/validate.sh </dev/null` to confirm it runs (a genuine lint/test failure here is a finding to
     report, not a generation error).
5. Delete the legacy files confirmed in step 0 (`docs/architecture.md`, `docs/arquitecture.md`,
   `docs/code-style.md`, `docs/testing.md`, `docs/security.md`, `docs/design.md`) now that their content lives in
   `AGENTS.md`. Remove `docs/` only if it ended up empty. Never delete `docs/usecases/`.
6. Show a summary: files created, legacy files deleted, hooks installed, and the sections left as `TBD` so the
   user knows what remains. Remind the user to commit, `.claude/settings.json` and `scripts/agent/` included.
