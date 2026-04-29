Add a comment to a Bitbucket pull request.

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

## Step 2 — Resolve PR ID

If the user provided a PR ID or URL, extract the numeric ID.
If not, run `/bb-list-pr` first so the user can pick one.

## Step 3 — Get comment content

Use the comment text provided by the user.
If none was provided, ask for it before continuing.

## Step 4 — Post comment via API

```bash
jq -n --arg content "$COMMENT_TEXT" '{content: {raw: $content}}' \
| curl -s -X POST \
    -u "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" \
    -H "Content-Type: application/json" \
    "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests/$PR_ID/comments" \
    -d @-
```

## Step 5 — Report

Confirm comment was posted. Print the comment URL from the response `links.html.href`.
If the curl returns an error, print the full JSON response for debugging.
