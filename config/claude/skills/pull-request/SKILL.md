---
name: pull-request
description: >
  Abre o actualiza la pull request en Bitbucket del cambio en curso. Úsala
  cuando el usuario diga "/pull-request", "abre la PR", "crea la pull request"
  o similar. Deriva título y descripción del contexto de la sesión y de los
  commits de la rama, y solo pregunta lo que no pueda deducir.
---

## Step 1 — Detect repo and branch

```bash
REMOTE_URL=$(git remote get-url origin)
WORKSPACE=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket\.org[:/]([^/]+)/([^/.]+)(\.git)?.*|\1|')
REPO=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket\.org[:/]([^/]+)/([^/.]+)(\.git)?.*|\2|')
BRANCH=$(git branch --show-current)
```

Checks before continuing:
- If the remote is not Bitbucket, stop and tell the user.
- If `BRANCH` is the default branch (`main`/`master`), stop: a PR needs a feature branch.
- If the branch has commits not pushed to origin, push it first (ask the user if the push needs `--set-upstream`).

## Step 2 — Detect existing PR

Check if the branch already has an open PR; if so, switch to update mode (refresh the description via Step 5b instead of creating a new PR):

```bash
http --ignore-stdin -a "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" GET \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests?q=source.branch.name=\"$BRANCH\"+AND+state=\"OPEN\""
```

## Step 3 — Build title and description from the change

Derive everything possible before asking:

1. **Title**: use the argument if provided; otherwise derive it from the purpose of the branch (session context, or `git log -1 --pretty=%s` as fallback). Short and actionable.
2. **Jira ticket**: look for a key (e.g. `TIF-123`, `TS-45`) in the branch name, the commit messages or the session context.
3. **Changes**: summarize the real diff of the branch (`git log <default-branch>..HEAD --oneline` and `git diff <default-branch>...HEAD --stat`), not what was planned.
4. **Validation**: how the change was tested. Take it from the session (tests/build run during implementation) if available.

Description sections (always these three):
- **Contexto**: motivación del cambio, con enlace al ticket de Jira si existe.
- **Cambios**: lista de los cambios técnicos concretos de la PR.
- **Validación**: cómo se ha probado el cambio.

Only ask the user (single `AskUserQuestion` batch) what cannot be deduced: typically the validation if no tests were run in the session, the destination branch if it is not the default one, or the Jira ticket if none was found.

## Step 4 — Confirm before creating

Show the user the proposed PR (title, destination branch and full description) and get confirmation before calling the API.

## Step 5 — Create PR via API

Destination branch: default branch (or user-specified).

```bash
http --ignore-stdin -a "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" POST \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests" \
  title="$TITLE" \
  source:='{"branch": {"name": "'"$BRANCH"'"}}' \
  destination:='{"branch": {"name": "'"$DESTINATION"'"}}' \
  close_source_branch:=true
```

Extract `PR_ID` and the PR URL from `links.html.href` in the response. On error, print the full response.

## Step 5b — Update description via API

```bash
http --ignore-stdin -a "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" PUT \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests/$PR_ID" \
  description="$NEW_DESCRIPTION"
```

## Step 6 — Wrap up

- Return the PR URL to the user.
- If the PR has an associated Jira ticket, add a comment on the ticket with the PR link (`mcp__claude_ai_Atlassian__addCommentToJiraIssue`).
- Then STOP and return control to the user: do not start any other phase of the flow on your own.
