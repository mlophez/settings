---
name: setup
description: >
  Generates the base documentation of a project (docs/architecture.md,
  docs/code-style.md, docs/design.md, README.md and CLAUDE.md) by
  interviewing the user. Use it when the user says "/setup", "initialize
  the project", "generate the project docs", or starts a new project
  without docs/.
---

# Setup project docs

Bootstrap the documentation that the `planner`, `implementer` and `designer`
agents read as sources of truth. Generate the files by interviewing the user;
do NOT analyze the project code to infer answers.

**Rules (apply to every step):**
- Interview the user in the language of the session; generated files are ALWAYS in English.
- Generated files always follow the templates in `templates/` of this skill: same headings, same order. Never invent new structure.
- Do not write markdown tables in the generated files.
- Ask per thematic block (one `AskUserQuestion` call per block for closed questions, grouped free-text questions for open ones). Do not interrogate one question at a time. If `AskUserQuestion` is not available, ask the closed questions as grouped free text too.
- Keep the file name `architecture.md` exactly as is (the agents expect this spelling).

## 0. Pre-checks

Check if any of `CLAUDE.md` (project root), `README.md` (project root),
`docs/architecture.md`, `docs/code-style.md` or `docs/design.md` already exists.

- For each existing file, ask the user: regenerate it (full interview for that file) or keep it untouched.
- Never overwrite an existing file without explicit confirmation.
- Only run the interview blocks needed for the files being generated (block 1 always runs).
- If nothing is left to generate, stop.

## 1. General context block (feeds all files)

Ask:
- Project name and purpose (free text, 1-2 sentences).
- Project type: backend / frontend / fullstack / CLI / library / infra (closed options).
- Does it have a UI? → decides whether `docs/design.md` is generated and block 4 runs.
- Main stack: language(s), framework(s), versions (free text).

## 2. Architecture block → `docs/architecture.md`

Ask:
- Folder layout and what goes in each folder.
- Layers/components, their responsibilities and dependency rules between them.
- External integrations (APIs, queues, third parties) — omit the section if not applicable.
- Persistence (database, schema approach, migrations) — omit the section if not applicable.
- Configuration and environments (local/pre/pro, secrets handling).

Do not ask about "Architecture decisions": that section is a cumulative log
that always starts with `None yet.`

## 3. Code conventions block → `docs/code-style.md`

Ask:
- Formatter/linter tools and the exact commands.
- Naming conventions and file organization.
- Error handling and logging approach.
- Tests: framework, location, naming, what is required.
- Dependency policy and git workflow (branches, commits).
- Forbidden patterns / anti-patterns in this project.

## 4. Design block (only if the project has a UI) → `docs/design.md`

Ask:
- Visual identity and tone.
- Colors and tokens, typography, spacing.
- Where shared components and the theme live, how to reuse them.
- Standard UI states (loading, error, empty) and accessibility/i18n requirements.

## 5. CLAUDE.md block

Ask:
- Main commands: build, test, lint, run (free text).
- Project-specific notes not derivable from the code (AWS profiles, kubectl contexts, quirks).

## 6. README block → `README.md`

Reuses the purpose (block 1) and the main commands (block 5). If `CLAUDE.md`
is not being generated, ask the main commands here instead. Only ask:
- Requirements: runtimes, SDKs, tools and accesses needed, with versions.
- Setup: steps to get the project running locally the first time.
- Usage: how to run/use it and, if applicable, basic usage examples.

## 7. Generation

1. Create `docs/` if it does not exist.
2. For each file to generate, copy the matching template from `templates/`
   in this skill and fill each section with the answers:
   - Remove the `<!-- ... -->` guidance comments and follow any conditional
     instructions they contain.
   - Sections without information are filled with `TBD` — never delete them —
     except sections whose guidance comment says "Omit this section ...",
     which are removed entirely when the condition applies.
   - In `CLAUDE.md`, only reference `docs/design.md` if it exists or was generated.
3. If an existing `CLAUDE.md` was kept but new `docs/*` files were generated,
   warn the user if it does not reference them as sources of truth (suggest
   adding a `## Docs` section like the one in the template).
4. Show a summary of the created files and remind the user to commit them.
