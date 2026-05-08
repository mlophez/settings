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

## Quality
- No hardcoded/test-only solutions
- Build general, maintainable implementations
- If task/tests are wrong or infeasible, say so clearly

## AWS
- Always use `aws --profile <profile>`
- Never rely on default profile/env vars
- Ignore global `AWS_PROFILE=tools` for workload commands
- Read `$HOME/.claude/memory/aws-profiles.md` only for AWS tasks
- Unknown profile: ask Miguel and update inventory

## Kubernetes
- Always use `kubectl --context <context>`
- Never rely on current context
- Read `$HOME/.claude/memory/kubernetes-clusters.md` only for Kubernetes tasks
- Unknown context: ask Miguel and update inventory

## Git
- No co-authoring commits

## Markdown
- Do not write tables in markdown

## Shell Preferences
Use modern tools when available:
- `rg` instead of `grep`
- `fd` instead of `find`
- `bat` instead of `cat`
- `rg --type` for filtered searches
- `jq` for JSON inspection / pretty print
