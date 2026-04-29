Create a Bitbucket pull request for the current branch.

## Prerequisites

Requires env vars:
- `BITBUCKET_TOKEN` — Bitbucket API token
- `BITBUCKET_EMAIL` — Bitbucket account email (used for Basic auth)

## Step 1 — Detect repo

```bash
REMOTE_URL=$(git remote get-url origin)
WORKSPACE=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket\.org[:/]([^/]+)/([^/.]+)(\.git)?.*|\1|')
REPO=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket\.org[:/]([^/]+)/([^/.]+)(\.git)?.*|\2|')
```

If the remote is not Bitbucket, stop and tell the user.

## Step 2 — Verify current branch

```bash
BRANCH=$(git branch --show-current)
```

If on `main` or `master`, warn the user and ask to confirm before continuing.

## Step 3 — Determine destination branch

Default destination is `main`. If the user specified a different target, use that.

## Step 4 — Determine PR title

- If the user provided a title as argument, use it.
- Otherwise, infer from the last commit message: `git log -1 --pretty=%s`
- If still unclear, ask the user.

## Step 5 — Build PR description

Generate a markdown description including:
1. **Summary**: what changed and why (infer from `git log origin/main..HEAD --oneline` and changed files).
2. **Changed files**: list from `git diff --name-only origin/main`.
3. Any extra context the user provided.

## Step 6 — Verify remote branch exists

```bash
git push origin "$BRANCH" 2>&1
```

If push fails, report the error and stop.

## Step 7 — Create PR via API

```bash
jq -n \
  --arg title "$TITLE" \
  --arg desc  "$DESCRIPTION" \
  --arg branch "$BRANCH" \
  --arg dest "$DESTINATION" \
  '{
    title: $title,
    description: $desc,
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

## Step 8 — Report

Print the PR URL from the API response field `links.html.href`.
If the curl returns an error, print the full JSON response for debugging.
