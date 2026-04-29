Update the description of an existing Bitbucket pull request.

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

## Step 3 — Get new description

Use the description content provided by the user in their message.
If none was provided, ask for it before continuing.

## Step 4 — Update via API

```bash
jq -n --arg desc "$NEW_DESCRIPTION" '{description: $desc}' \
| curl -s -X PUT \
    -u "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" \
    -H "Content-Type: application/json" \
    "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests/$PR_ID" \
    -d @-
```

## Step 5 — Report

Print the updated PR URL from the response `links.html.href`.
If the curl returns an error, print the full JSON response for debugging.
