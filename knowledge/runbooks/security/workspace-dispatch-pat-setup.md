---
type: runbook
title: "WORKSPACE_DISPATCH_PAT setup"
description: "Create fine-grained PAT for downstream repos to trigger umbrella deploy via repository_dispatch."
tags: [security, pat, github, ci, deploy, dispatch]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/agent-tooling/workspace-owns-secrets-2026-07-02
  - runbooks/operations/deploy-workflow-usage-2026-07-02
---

# WORKSPACE_DISPATCH_PAT setup

Fine-grained PAT. Only `chirag127/workspace`. Only `contents:write` + `metadata:read`. Downstream repos use it to fire `repository_dispatch` at umbrella after CI green.

## Why fine-grained not classic

Classic PAT = full account scope. Leak = full account compromise. Fine-grained = single-repo blast radius.

## Create the PAT

1. Open https://github.com/settings/personal-access-tokens/new
2. Name: `workspace-dispatch-pat-YYYY-MM-DD`
3. Expiration: 12 months (max fine-grained allows)
4. Resource owner: `chirag127`
5. Repository access: **Only select repositories** → pick `chirag127/workspace` only
6. Permissions → Repository permissions:
   - **Contents**: Read and write (required for `POST /repos/{owner}/{repo}/dispatches`)
   - **Metadata**: Read-only (auto-selected, mandatory)
   - Everything else: No access
7. Generate token. Copy value once — never shown again.

## Store PAT

### Umbrella `.env`

Add line to `C:/D/oriz/.env`:
```
WORKSPACE_DISPATCH_PAT=github_pat_xxxxxxxxxxxx
```

Then re-encrypt:
```bash
cd C:/D/oriz
sops -e .env > .env.enc
git add .env.enc
git commit -m "chore(env): rotate WORKSPACE_DISPATCH_PAT"
git push
```

Never commit plaintext `.env` (already gitignored — verify).

### Each downstream repo

```bash
PAT=$(grep -E "^WORKSPACE_DISPATCH_PAT=" C:/D/oriz/.env | cut -d= -f2- | tr -d '\r"')

for repo in blog home me journal oriz-ncert-app; do
  echo "$PAT" | gh secret set WORKSPACE_DISPATCH_PAT --repo chirag127/$repo --body -
done
```

Verify:
```bash
gh secret list --repo chirag127/blog
```

Should show `WORKSPACE_DISPATCH_PAT`.

## Rotate PAT

Every 12 months or on suspected leak:

1. Generate new PAT (steps above).
2. Update `.env` + re-encrypt `.env.enc`.
3. Re-set on all downstream repos (loop above).
4. Delete old PAT at https://github.com/settings/personal-access-tokens.

## Verify PAT works

Manual dispatch test from any downstream repo shell:

```bash
gh api repos/chirag127/workspace/dispatches \
  -f event_type=deploy \
  -f 'client_payload[repo]=chirag127/blog' \
  -f 'client_payload[class]=astro-site' \
  -H "Authorization: token $WORKSPACE_DISPATCH_PAT"
```

Should return HTTP 204. Then check umbrella Actions tab — `deploy` run should be queued.

## Anti-patterns

- Classic PAT with full `repo` scope — too broad, leak = account-wide
- PAT stored in downstream repo `.env` — never, only in GitHub secrets
- Shared PAT across users — one PAT per person; rotate on offboard
- PAT expiry >12mo — GitHub caps fine-grained at 12mo anyway
