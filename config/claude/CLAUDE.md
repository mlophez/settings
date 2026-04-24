# CLAUDE.md - Miguel López

## Context
- Location: Madrid, Spain (Europe/Madrid timezone, Spanish locale)
- Training data may be outdated. For libraries, APIs, tools, and docs: always use WebSearch/WebFetch to verify current versions and
  behavior before giving recommendations or writing integration code. Never assume training knowledge is current.

## Communication
- Response language: Spanish for communication, English for code/technical terms

## Behavior
- Thoroughly review the style, conventions, and abstractions of the codebase before implementing new features or abstractions
- Use subagents for: parallel independent tasks, context-heavy research, or when main context is filling up
- When context window is running low, proactively: (1) commit current work, (2) create a handoff prompt with necessary context and plan for next session
- If you create any temporary new files, scripts, or helper files for iteration, clean up these files by removing them at the end of the task
- For complex research: develop competing hypotheses, track confidence in notes, self-critique approach
- Make commit without coauthored by claude.

## Quality Standards
- Do not hard-code values or create solutions that only work for specific test inputs. Implement the actual logic that solves the problem generally
- If the task is unreasonable or infeasible, or if any of the tests are incorrect, inform me rather than working around them

## AWS
- Always use `aws --profile <profile>` explicitly — never rely on default profile or environment variables
- Exception: `AWS_PROFILE=tools` is set globally for Claude Code's own Bedrock connection — do not use it for workload commands
- Profile inventory is at `$HOME/.claude/memory/aws-profiles.md` — read it only when working with AWS
- If a profile appears that is not in the inventory, ask Miguel to describe it and add it to the file

## Kubernetes
- Always use `kubectl --context <context-name>` explicitly — never rely on the current context
- Cluster inventory is at `$HOME/.claude/memory/kubernetes-clusters.md` — read it only when working with Kubernetes
- If a context appears that is not in the inventory, ask Miguel to describe it and add it to the file

## Shell tool preferences
Prefer these tools over standard alternatives when available:
- Use `rg` instead of `grep` for searching
- Use `fd` instead of `find` for file discovery
- Use `bat` instead of `cat` when displaying file contents for review
- Always use `rg --type` to filter by file type when relevant
- Use `jq` instead of `grep`/`cat` for inspecting or querying JSON files or API responses
  - Example: `jq '.dependencies' package.json` en lugar de `cat package.json | grep -A20 dependencies`
  - For pretty-printing: `jq '.' archivo.json`
