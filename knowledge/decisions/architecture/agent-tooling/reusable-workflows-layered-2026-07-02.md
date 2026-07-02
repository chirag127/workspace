---
type: decision
title: "Reusable workflows layered with Dagger — 2026-07-02"
description: "chirag127/oriz-workflows publishes reusable GH Actions workflows per repo class. Each workflow calls `dagger call` — the actual logic lives in Dagger TS modules. Downstream repos are 5-line pins."
tags: [ci, github-actions, dagger, dry, reusable-workflows]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - decisions/stack/pipeline-stack-2026-07-01
  - decisions/architecture/agent-tooling/workspace-owns-secrets-2026-07-02
  - branding/chirag127-owns-everything-2026-07-02
---

# Reusable workflows layered with Dagger

## The 3-layer DRY stack

```
Downstream repo (chirag127/oriz-blog)
  └── .github/workflows/ci.yml           # 5-line pin
      └── chirag127/oriz-workflows       # reusable workflow (@v1)
          └── dagger call ci             # actual logic lives in Dagger TS
              └── @oriz/dagger-astro     # composable module for Astro sites
```

## Repo classes → reusable workflow files

`chirag127/oriz-workflows/.github/workflows/`:

| File | For repo class | Downstream slug |
|---|---|---|
| `ci-astro-site.yml` | Astro sites | `sites/*` |
| `ci-astro-api.yml` | Astro static APIs | `api/*` |
| `ci-astro-pwa.yml` | Astro mobile PWAs | `apps-mobile/*` |
| `ci-mdbook.yml` | mdBook books | `books/*` |
| `ci-vsc-ext.yml` | VS Code extensions | `apps-vsc-ext/*` |
| `ci-bs-ext.yml` | Browser extensions | `apps-bs-ext/*` |
| `ci-userscript.yml` | Userscripts | `userscripts/*` |
| `ci-npm-package.yml` | Publishable npm packages | `infra/*` npm-scoped |

## Downstream repo shape (thin)

Every `chirag127/<repo>/.github/workflows/ci.yml`:

```yaml
name: ci
on: [push, pull_request]
jobs:
  ci:
    uses: chirag127/oriz-workflows/.github/workflows/ci-astro-site.yml@v1
    secrets: inherit
```

Nothing else. Actual CI logic lives in `oriz-workflows`.

## Reusable workflow shape

`chirag127/oriz-workflows/.github/workflows/ci-astro-site.yml`:

```yaml
name: ci-astro-site
on:
  workflow_call:
    secrets:
      WORKSPACE_DISPATCH_PAT: { required: true }
jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dagger/dagger-for-github@8
        with:
          version: latest
          call: ci --source=.
      - name: Trigger deploy
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        run: gh api repos/chirag127/workspace/dispatches -f event_type=deploy -f "client_payload[repo]=$GITHUB_REPOSITORY" -f "client_payload[sha]=$GITHUB_SHA"
        env:
          GH_TOKEN: ${{ secrets.WORKSPACE_DISPATCH_PAT }}
```

## Version pinning + Renovate

- Downstream repos pin `@v1` (tag).
- Renovate config in each downstream repo watches `chirag127/oriz-workflows` releases.
- New tag → Renovate opens PR to bump pin.
- Auto-merge if CI green.

Renovate preset lives at `chirag127/oriz-workflows/renovate-preset.json`. Every downstream `renovate.json`:

```json
{ "extends": ["github>chirag127/oriz-workflows"] }
```

## Anti-drift — structural

There's nothing to drift because:
1. Actual logic lives in `oriz-workflows` (one place).
2. Downstream is 5 lines that only reference the version tag.
3. Renovate auto-bumps the tag.
4. If a repo's 5-line pin is missing (e.g. deleted by hand), CI is red on next push. Visible.

## Cross-refs

- [`pipeline-stack-2026-07-01`](../../stack/pipeline-stack-2026-07-01.md)
- [`workspace-owns-secrets-2026-07-02`](../agent-tooling/workspace-owns-secrets-2026-07-02.md)
- [`chirag127-owns-everything-2026-07-02`](../../../branding/chirag127-owns-everything-2026-07-02.md)
