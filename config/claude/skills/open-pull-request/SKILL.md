---
name: open-pull-request
description: >
  Open/Update pull request on repository for the current branch
---

## Step 1 — Detect repo and branch

```bash
REMOTE_URL=$(git remote get-url origin)
WORKSPACE=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket\.org[:/]([^/]+)/([^/.]+)(\.git)?.*|\1|')
REPO=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket\.org[:/]([^/]+)/([^/.]+)(\.git)?.*|\2|')
BRANCH=$(git branch --show-current)
```

If remote is not Bitbucket, stop and tell the user.

## Step 2 — Determine title

- Use argument if provided.
- Otherwise: `git log -1 --pretty=%s`

## Step 3 - Obtain information from user

- **¡Ask user for how validate changes! (mandatory)**

Description must have this sections:
- Contexto (Poner el ticket de jira)
- Cambios (List the concrete technical changes made in this PR)
- Validación (How test changed)

## Step 3 — Create PR via API

Destination branch: `main` (or user-specified).

```bash
jq -n \
  --arg title "$TITLE" \
  --arg branch "$BRANCH" \
  --arg dest "$DESTINATION" \
  '{
    title: $title,
    source: {branch: {name: $branch}},
    destination: {branch: {name: $dest}},
    close_source_branch: true
  }' \
| curl -s -X POST \
    -u "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" \
    -H "Content-Type: application/json" \
    "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests" \
    -d @-
```

Print PR URL from `links.html.href`. On error, print full JSON.

## Step 3b — Update description via API

```bash
jq -n --arg desc "$NEW_DESCRIPTION" '{description: $desc}' \
| curl -s -X PUT \
    -u "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" \
    -H "Content-Type: application/json" \
    "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests/$PR_ID" \
    -d @-
```

## Step 4 - Update other tickets

- Si la pull request tiene un ticket de jira asociado actualizar la informacion de la descripcion tambien con la skill open-infra-ticket
