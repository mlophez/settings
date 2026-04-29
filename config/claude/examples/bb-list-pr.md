List open pull requests in the current repository's Bitbucket project.

## Prerequisites

Requires env vars:
- `BITBUCKET_TOKEN` — Bitbucket API token
- `BITBUCKET_EMAIL` — Bitbucket account email (used for Basic auth)

## Step 1 — Detect repo

```bash
REMOTE_URL=$(git remote get-url origin)
WORKSPACE=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket\.org[:/]([^/]+)/([^/.]+)(\.git)?.*|\1|')
REPO=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket\.org[:/]([^/]+)/([^/.]+)(\.git)?.*|\2|')
echo "Repo: $WORKSPACE/$REPO"
```

If the remote is not Bitbucket, stop and tell the user.

## Step 2 — Fetch and display PRs

```bash
curl -s \
  -u "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests?state=OPEN&pagelen=50" \
| jq -r '.values[] | "#\(.id)  \(.title)\n    branch: \(.source.branch.name) → \(.destination.branch.name)\n    author: \(.author.display_name)\n    url:    \(.links.html.href)\n"'
```

Display each PR as: ID, title, source → destination branch, author, URL.
If response contains an error field, print full JSON for debugging.
