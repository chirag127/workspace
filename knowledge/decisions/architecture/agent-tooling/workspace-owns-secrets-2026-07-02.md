---
type: decision
title: "Workspace-owns-secrets model 2026-07-02"
description: "chirag127/workspace umbrella holds ALL deploy secrets. Per-repo CI runs public-only (lint/test/build). Deploy triggered via repository_dispatch after CI green."
tags: [security, secrets, ci, github-actions, umbrella, deploy]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
supersedes:
  - rules/security/github-org-level-secrets
  - rules/security/org-level-secrets-only-no-per-repo
related:
  - branding/chirag127-owns-everything-2026-07-02
  - decisions/stack/pipeline-stack-2026-07-01
  - rules/security/no-hardcoded-secrets
---

# Workspace-owns-secrets model

## Decision

`chirag127/workspace` (the umbrella) holds every deploy secret. Individual repo workflows are public-CI-only (lint, typecheck, test, build). Deploys are triggered via `repository_dispatch` from the submodule to the umbrella after CI turns green.

## Two-tier CI model

### Tier 1: Public CI (per repo)

Every `chirag127/<repo>` has a thin `.github/workflows/ci.yml`:

```yaml
name: ci
on: [push, pull_request]
jobs:
  ci:
    uses: chirag127/oriz-workflows/.github/workflows/ci-astro.yml@v1
```

Uses reusable workflow from `chirag127/oriz-workflows`. Runs Dagger `call ci`. NO secrets. External contributors can fork + PR safely.

On success on `main`, the reusable workflow fires a `repository_dispatch` event at the umbrella:

```yaml
- name: Trigger deploy
  if: github.ref == 'refs/heads/main' && github.event_name == 'push'
  run: |
    gh api repos/chirag127/workspace/dispatches \
      -f event_type=deploy \
      -f 'client_payload[repo]=${{ github.repository }}' \
      -f 'client_payload[sha]=${{ github.sha }}'
  env:
    GH_TOKEN: ${{ secrets.WORKSPACE_DISPATCH_PAT }}
```

Only ONE secret in each downstream repo: `WORKSPACE_DISPATCH_PAT` (a PAT with `repo` scope on the umbrella only — narrow).

### Tier 2: Deploy CI (umbrella)

`chirag127/workspace/.github/workflows/deploy.yml`:

```yaml
name: deploy
on:
  repository_dispatch:
    types: [deploy]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { submodules: recursive }
      - uses: dagger/dagger-for-github@8
        with:
          call: |
            deploy
            --source=./repos/own/${{ github.event.client_payload.repo }}
            --cf-api-token=env:CLOUDFLARE_API_TOKEN
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          RESEND_API_KEY: ${{ secrets.RESEND_API_KEY }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

Umbrella owns all deploy secrets. One place to rotate.

## Secret inventory (umbrella-owned)

| Secret | Purpose | Rotation |
|---|---|---|
| `CLOUDFLARE_API_TOKEN` | CF Pages + Workers deploy | Every 6 months |
| `CLOUDFLARE_ACCOUNT_ID` | CF account identifier | Never (not sensitive) |
| `RESEND_API_KEY` | Transactional email | Every 12 months |
| `NPM_TOKEN` | Auto-publish `@oriz/*` | Every 6 months |
| `SYNC_TOKEN` | Weekly fork upstream-sync | Every 6 months |
| `WORKSPACE_DISPATCH_PAT` | Downstream repos → umbrella dispatch | Every 6 months, replicated to all 20 repos via script |

## Downstream repo secret

Every `chirag127/<own-repo>` has exactly one secret: `WORKSPACE_DISPATCH_PAT`. Rotation:

```bash
# scripts/rotate-dispatch-pat.mjs
for repo in $(gh repo list chirag127 --json name -q '.[].name'); do
  gh secret set WORKSPACE_DISPATCH_PAT --repo "chirag127/$repo" --body "$NEW_PAT"
done
```

## Why (2026-07-02)

Reverses [`org-level-secrets-only-no-per-repo`](../../../rules/security/org-level-secrets-only-no-per-repo.md) because `oriz-org` is being dissolved (see [`chirag127-owns-everything-2026-07-02`](../../../branding/chirag127-owns-everything-2026-07-02.md)). Options considered:

| Model | Rotation cost | Blast radius | Public CI safety |
|---|---|---|---|
| Per-repo secrets replicated via script | 20 API calls per rotation | Per-repo | Safe |
| Umbrella-owns-secrets (chosen) | 1 place per secret | Umbrella only | Safe (public CI has no secrets) |
| Org-level secrets | 1 place | All org repos | Safe |

Umbrella-owns wins because:
1. Rotation is one place (matches org-level convenience).
2. Public CI has ZERO deploy secrets → external contributors are safe. Even if their fork's CI leaks a token, there's no token to leak.
3. `repository_dispatch` requires an authenticated caller → attackers can't fake deploy triggers.
4. Post-2025 supply-chain attacks (Shai-Hulud, tj-actions) show smaller blast radius matters.

## Cross-refs

- [`chirag127-owns-everything-2026-07-02`](../../../branding/chirag127-owns-everything-2026-07-02.md)
- [`pipeline-stack-2026-07-01`](../../stack/pipeline-stack-2026-07-01.md)
- [`no-hardcoded-secrets`](../../../rules/security/no-hardcoded-secrets.md)
- Supersedes: `rules/security/github-org-level-secrets.md`, `rules/security/org-level-secrets-only-no-per-repo.md` (both DELETED same commit)
