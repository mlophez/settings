---
name: commit
description: Make a commit in git repository. Only on demand
#model: sonnet
effort: low
disable-model-invocation: true
---

## FLOW

1. `git pull --rebase`
2. `git add <files>`
3. `git commit -m "<message>"`
4. `git push`
5. Git push to another remotes secondaries.

## RULES

- Do not co-author commits with claude.
