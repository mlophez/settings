---
name: close
description: >
  Cierra el cambio en curso: hace squash-merge de la pull request de la rama en
  Bitbucket y pasa el ticket de Jira a Completado, dejando un comentario final en
  ambos. Úsala cuando el usuario diga "/close", "cierra esto", "cierra la PR",
  "cierra el ticket" o "da por cerrado el cambio". Sin argumento cierra PR y ticket;
  con argumento acota: /close pr, /close ticket, /close TIF-123.
model: sonnet
effort: low
disable-model-invocation: true
---

**Info**
```
cloudId: 067e6789-c624-4d93-8e50-fb6f31d8130e
```

## Step 0 — Resolve scope from the argument

Determine what to close based on the optional argument:

- No argument → close both PR and ticket.
- Argument matching `^[A-Z]+-[0-9]+$` (e.g. `TIF-123`, `TS-45`) → ticket only, using that exact key.
- Argument `pr` or `PR` → PR only.
- Argument `ticket` or `jira` → ticket only, key derived in Step 1b.
- Any other argument → ask the user once: "¿Qué quieres cerrar: PR, ticket (indica la clave) o ambos?"

## Step 1 — Detect targets from context

### 1a. PR detection (skip when scope is ticket-only)

```bash
REMOTE_URL=$(git remote get-url origin)
WORKSPACE=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket\.org[:/]([^/]+)/([^/.]+)(\.git)?.*|\1|')
REPO=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket\.org[:/]([^/]+)/([^/.]+)(\.git)?.*|\2|')
BRANCH=$(git branch --show-current)

http --ignore-stdin -a "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" GET \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests?q=source.branch.name=\"$BRANCH\"+AND+state=\"OPEN\""
```

- If the remote is not Bitbucket: if the PR was explicitly requested, stop and say so; otherwise skip the PR side.
- If the PR is already MERGED or DECLINED: report its state, skip the PR merge, and continue with the ticket.
- If there is no OPEN PR for the branch: if the PR was explicitly requested, stop; otherwise skip and continue.
- Extract `PR_ID` and the PR URL from the first result.

### 1b. Jira key detection (skip when scope is PR-only)

Look for a Jira key (pattern `[A-Z]+-[0-9]+`) in this order:
1. The argument itself (if it was a key).
2. The branch name.
3. Commit messages: `git log <default-branch>..HEAD --oneline`.
4. The session context.

If the scope includes the ticket but no key is found, ask the user for the key once.
If neither PR nor ticket can be resolved, stop: there is nothing to close.

## Step 2 — Gather context and ask the closing question

Gather the material that will feed the comment template:

- **Ticket info** (when a ticket is in scope): call `mcp__claude_ai_Atlassian__getJiraIssue` with the `cloudId` and
  the key. Extract its `summary` and the **Contexto** / **Alcance** sections of its description to describe what was
  originally asked for.
- **Real change**: `git log <default-branch>..HEAD --oneline` and `git diff <default-branch>...HEAD --stat`.
- **PR description** from the Step 1a response (when in scope).
- The session context.

With that material, draft a one-paragraph summary of what was done. Then ask the user with `AskUserQuestion`:
"¿Resumen de lo realizado?" — offer the draft as the recommended option so the user can accept or replace it.

The user's answer is **one input** to the comment template (Step 3). It is not the whole comment on its own.

## Step 3 — Build the final comment and check PR guards

### Comment template

All closing comments use this single fixed template. Build it in markdown (no tables).

**PR comment** (posted on the Bitbucket PR):
```
**Cierre: Completado**

**Objetivo:** <objective derived from the ticket summary + Contexto/Alcance; if no ticket is in scope, derive it from the PR title and description>

**Resumen de lo realizado:** <user's answer to the closing question, enriched with the real branch changes>
```

**Jira comment** (posted on the Jira ticket — identical except it adds the PR line when a PR was merged this run):
```
**Cierre: Completado**

**Objetivo:** <same as above>

**Resumen de lo realizado:** <same as above>

**Pull request:** <PR URL> (squash-merge)
```

Rules:
- `**Objetivo:**` and `**Resumen de lo realizado:**` are word-for-word identical in both comments.
- The `**Pull request:**` line appears only on the Jira comment, and only when a PR was merged in this run. Omit it on
  the PR comment (circular reference) and when closing only the ticket with no PR.
- When scope is PR-only (`/close pr`), derive `**Objetivo:**` from the PR title/description and post the comment only
  on the PR.

### PR guards (skip when scope is ticket-only)

Run both checks before mutating anything:

1. **Approvals**: inspect `participants[]` in the Step 1a PR object. If no entry has `"approved": true`, warn:
   "La PR no tiene aprobaciones."
2. **Pipeline**: query statuses:
   ```bash
   http --ignore-stdin -a "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" GET \
     "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests/$PR_ID/statuses"
   ```
   If the latest status is not `SUCCESSFUL` (e.g. `FAILED`, `INPROGRESS`, `STOPPED`), warn: "El pipeline no está en
   verde: <state>." No statuses present is not a warning.

If either guard fires, state the problem clearly and require an explicit "sí, mergea igualmente" before proceeding.
Never hard-block: if the user confirms, continue.

## Step 4 — Confirm before mutating

Show the user a single confirmation with:
- What will be closed: PR id/URL and/or ticket key.
- Merge strategy: squash, source branch deleted.
- The Jira transition name that will be applied (discovered in Step 5).
- The full text of the comment(s) that will be posted.

Wait for confirmation. Do not mutate before it.

## Step 5 — Execute the close

### PR side (skip when scope is ticket-only)

**1. Post the PR comment:**
```bash
http --ignore-stdin -a "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" POST \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests/$PR_ID/comments" \
  content:='{"raw": "<PR comment text from the template>"}'
```

**2. Squash-merge and delete the source branch:**
```bash
http --ignore-stdin -a "$BITBUCKET_EMAIL:$BITBUCKET_TOKEN" POST \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO/pullrequests/$PR_ID/merge" \
  merge_strategy=squash \
  close_source_branch:=true \
  message="<PR title> [<Jira key if available>]"
```

On any non-2xx response: print the full response body and stop without touching the ticket. Common causes: squash
disabled by repo settings, required merge checks not met.

### Ticket side (skip when scope is PR-only)

**3. Discover the Done transition:**

Call `mcp__claude_ai_Atlassian__getTransitionsForJiraIssue` with the `cloudId` and `issueIdOrKey`. Match a transition
whose name (case-insensitive) is one of: `Done`, `Finalizada`, `Completado`, `Completada`, `Hecho`, `Resuelta`,
`Cerrada`. If exactly one matches, use it. If several match or none match, list the available transitions and ask the
user which one to apply.

If the ticket is already in a Done-like status: skip the transition, still post the closing comment, and report it.

**4. Apply the transition:**

`mcp__claude_ai_Atlassian__transitionJiraIssue` with `cloudId`, `issueIdOrKey`, `transition: {id: "<id>"}`.

**5. Post the Jira closing comment:**

`mcp__claude_ai_Atlassian__addCommentToJiraIssue` with `cloudId`, `issueIdOrKey`, `contentFormat: "markdown"`, and
`commentBody` set to the Jira variant of the template — which includes the `**Pull request:**` line with the merged PR
URL when a PR was merged in this run.

## Step 6 — Report

Report exactly what happened:
- PR: merged URL, source branch deleted (or skipped with reason).
- Ticket: key, new status, link (or skipped with reason).

Then STOP and return control to the user. Do not chain into any other phase.
