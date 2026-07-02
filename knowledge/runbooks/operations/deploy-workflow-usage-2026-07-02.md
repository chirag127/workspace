---
type: runbook
title: "Umbrella deploy workflow usage"
description: "How to trigger, test, and debug .github/workflows/deploy.yml on chirag127/workspace."
tags: [ci, deploy, github-actions, umbrella, dispatch, cloudflare]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/agent-tooling/workspace-owns-secrets-2026-07-02
  - runbooks/security/workspace-dispatch-pat-setup
---

# Umbrella deploy workflow usage

Umbrella workflow: `chirag127/workspace/.github/workflows/deploy.yml`. Owns all deploy secrets. Fires on `repository_dispatch` from downstream CI (green on `main`) or manual `workflow_dispatch`.

## Manual trigger

```bash
gh workflow run deploy.yml \
  --repo chirag127/workspace \
  -f repo=chirag127/blog \
  -f class=astro-site
```

Watch:
```bash
gh run list --repo chirag127/workspace --workflow=deploy.yml --limit 5
gh run watch --repo chirag127/workspace
```

`class` options: `astro-site`, `astro-api`, `astro-pwa`, `mdbook`, `browser-ext`, `vsc-ext`.

## Test repository_dispatch flow

Simulate what a downstream CI does after green on `main`:

```bash
PAT=$(grep -E "^WORKSPACE_DISPATCH_PAT=" C:/D/oriz/.env | cut -d= -f2- | tr -d '\r"')

curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $PAT" \
  https://api.github.com/repos/chirag127/workspace/dispatches \
  -d '{
    "event_type": "deploy",
    "client_payload": {
      "repo": "chirag127/blog",
      "sha": "abc123",
      "class": "astro-site"
    }
  }'
```

HTTP 204 = queued. Check Actions tab.

## Troubleshooting

### Deploy fires but immediately fails

Check `Resolve submodule path` step. If `submodule path not found`, downstream repo not in `.gitmodules`. Add submodule to umbrella + push.

### Deploy silent — no run appears

- PAT missing/expired on downstream. `gh secret list --repo chirag127/<slug>` — confirm `WORKSPACE_DISPATCH_PAT` present.
- PAT scope wrong. Must be fine-grained with `contents:write` on `chirag127/workspace`.
- Umbrella workflow disabled. Check https://github.com/chirag127/workspace/actions.
- Wrong `event_type`. Must be exactly `deploy` (matches `types: [deploy]` in workflow).

### Dagger step fails: "cf-api-token not set"

Umbrella secrets missing. Verify:
```bash
gh secret list --repo chirag127/workspace
```

Should show `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`. If missing, set from `.env`:
```bash
grep -E "^CLOUDFLARE_API_TOKEN=" C:/D/oriz/.env | cut -d= -f2- | tr -d '\r"' | \
  gh secret set CLOUDFLARE_API_TOKEN --repo chirag127/workspace --body -
```

### Wrong submodule deployed

`resolve` step matches `slug` by suffix (`/<slug>$`). Two submodules with same basename = collision. Rename one submodule path in `.gitmodules`.

### Deploy uses stale submodule SHA

Umbrella checkout uses submodule pointers committed to umbrella `main`. If downstream pushed but umbrella pointer stale, umbrella deploys OLD sha. Fix: bump submodule pointer in umbrella + push. Runbook: `knowledge/runbooks/operations/bump-submodule-pointer.md`.

## Rate limits

GitHub Actions free tier: 2000 min/mo (public repos unlimited). Deploy job = ~3-5 min. Budget: ~400-600 deploys/mo. Fine for daily fleet churn.

`repository_dispatch` API: 5000 req/hr per token. Not a real ceiling.

## Parallel safety

`concurrency.group = deploy-${repo}` — same-repo deploys serialize. Different repos deploy in parallel. `cancel-in-progress: false` — never kill an in-flight deploy; queue behind it.

## What each deploy does

1. Checkout umbrella + all submodules (recursive, depth 1).
2. Resolve `chirag127/<slug>` → submodule path via `.gitmodules`.
3. Run `dagger call deploy-cloudflare` with CF secrets, pointing at submodule path.
4. Dagger emits Wrangler deploy → CF Pages/Workers.

## Anti-patterns

- Triggering deploy from downstream repo directly (bypasses umbrella secret model).
- Adding CF secrets to downstream repo `.env` (leaks in fork PRs).
- Manual `workflow_dispatch` on prod before CI green (skips test gate).
- Editing `deploy.yml` without testing via `workflow_dispatch` first.
