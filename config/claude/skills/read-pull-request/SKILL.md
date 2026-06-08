---
name: read-pull-request
description: Read pull request on bitbucket
---

1. Get info from pull request with this command, **only this command**

```bash
http --ignore-stdin -a "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" GET "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests/$PULL_REQUEST_ID"
```

2. Output resume.

