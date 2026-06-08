---
name: open-pull-request
description: Open/Update pull request on bitbucket
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

**¡Ask user for this question always!: (mandatory)**
- Como validas el cambio?

Description must have this sections:
- Contexto (Poner enlace al ticket de jira)
- Cambios (List the concrete technical changes made in this PR)
- Validación (How test changed)

## Step 3 — Create PR via API

Destination branch: `main` (or user-specified).

```bash
http --ignore-stdin -a "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" POST \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests" \
  title="$TITLE" \
  source:='{"branch": {"name": "'"$BRANCH"'"}}' \
  destination:='{"branch": {"name": "'"$DESTINATION"'"}}' \
  close_source_branch:=true
```

Extract `PR_ID` and PR URL from `links.html.href` in the response. On error, print the full response.

## Step 3b — Update description via API

```bash
http --ignore-stdin -a "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" PUT \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests/$PR_ID" \
  description="$NEW_DESCRIPTION"
```

## Step 4 - Update other tickets

- Si la pull request tiene un ticket de jira asociado actualizar la informacion de la descripcion tambien con la skill open-infra-ticket
