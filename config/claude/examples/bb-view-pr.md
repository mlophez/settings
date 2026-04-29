View details and changed files of a Bitbucket pull request.

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

## Step 3 — Fetch PR metadata

```bash
curl -s \
  -u "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests/$PR_ID" \
| jq '{
    id: .id,
    title: .title,
    state: .state,
    author: .author.display_name,
    source: .source.branch.name,
    destination: .destination.branch.name,
    description: .description,
    created: .created_on,
    updated: .updated_on,
    url: .links.html.href
  }'
```

## Step 4 — Fetch changed files

```bash
curl -s \
  -u "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests/$PR_ID/diffstat" \
| jq -r '.values[] | "\(.status)\t\(.new.path // .old.path)"' \
| sort
```

Display: status (added/modified/removed) + file path.

## Step 5 — Report

Show PR metadata (title, author, branches, state, description) followed by the list of changed files grouped by status.
If any curl returns an error, print full JSON for debugging.
