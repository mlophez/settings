# CLAUDE.md

## Context
- Location: Madrid, Spain (`Europe/Madrid`, Spanish locale)
- Training data may be outdated: always verify current libraries, APIs, tools, versions, and docs using WebSearch/WebFetch before recommending or implementing.

## Communication
- Spanish for explanations
- English for code, commands, and technical terms
- No emojis

## Behavior
- If context is low: commit progress and prepare handoff prompt
- Remove temporary files/scripts created during work

## Planning
- To plan features, refactors or bugfixes, always use the `plan` skill (plan mode included)

## Subagents
- `#<agent-name>` in a prompt (e.g. `#implementer`, `#reviewer`) means: launch that subagent immediately for the task, do not handle it in the main session

## Quality
- No hardcoded/test-only solutions
- Build general, maintainable implementations
- If task/tests are wrong or infeasible, say so clearly

## AWS
- Always use `aws --profile <profile>`
- Never rely on default profile/env vars
- Ignore global `AWS_PROFILE=tools` for workload commands
- Unknown profile: ask Miguel and update inventory

## Kubernetes
- Always use `kubectl --context <context>`
- Never rely on current context
- Unknown context: ask Miguel and update inventory

## Git
- No co-authoring commits

## Markdown
- Do not write tables in markdown

## Coding
- Always comment generated code for human understand.

## Shell Preferences
Use modern tools when available:
- `rg` instead of `grep`
- `fd` instead of `find`
- `bat` instead of `cat`
- `rg --type` for filtered searches
- `jq` for JSON inspection / pretty print

## Procedures

### Run new session of claude

Abre una nueva session de ia en un tab de zellij sobre una carpeta de Logalty y
arranca una sesión interactiva de claude con un prompt de subtarea derivado del contexto de la sesión actual de planificación.
Úsala cuando el usuario diga "vamos a implementar esto en <subproyecto>", "lánzame una sesión de claude en <subproyecto>" o "pásame esto a una nueva tab".

```bash
# New way (use this)
zellij action new-pane --floating --cwd "<project-path>" -- claude "$PROMPT"
# Old way
zellij action new-tab -n "<project-name>" -c "<project-path>" -- claude "$PROMPT"
```

