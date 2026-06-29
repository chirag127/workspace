---
type: rule
title: 'Fork model: thin tracking + personal-author PRs + umbrella auto-sync'
description: Forks under oriz-org track upstream EXACTLY. origin=upstream + fork=oriz-org. PRs from chirag127
tags: [forks, upstream, sync, ci, oriz-org, chirag127, hard-rule]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/development/fork-discipline
  - decisions/fleet/fleet-owner-oriz-org
---

# Fork model

## Locked decisions (2026-06-27)

### Fork ownership
- All forks live under `oriz-org` on GitHub (per existing fleet-owner-oriz-org rule).
- Local checkouts: `repos/frk/<name>/`.

### Remote naming (THE FLIP)
Default Git remote names in each local fork clone:
- `origin` -> upstream (e.g. `tashfeenahmed/freellmapi.git`)
- `fork`   -> oriz-org (e.g. `oriz-org/freellmapi.git`)

So `git pull` and `git fetch` work against upstream by default. `git push fork <branch>` is the explicit verb to push to our fork.

### Fork main = upstream main, exactly
Fork's `main` branch MUST match upstream `main` SHA-for-SHA. Zero divergence allowed. Force-push if needed.

### Where oriz work lives
Never on `main` of a fork. Three valid surfaces:
1. **`oriz/<topic>` branches on the fork** — for work-in-progress that's not ready for upstream.
2. **`chirag127/<repo>` personal fork** — when filing an upstream PR. Branch named `oriz-<topic>`.
3. **Umbrella `c:/D/oriz/`** — for workspace tooling, sync workflows, knowledge.

### PRs to upstream: personal branding
PRs come FROM `chirag127:oriz-<topic>` INTO `<upstream-owner>:<branch>`. Author = `chirag127` personal account. Even though the storage org is `oriz-org`, the personal account is what shows on the PR. Cleaner OSS convention; matches user's "personal branding" preference (2026-06-27).

Workflow to file a PR:
1. `cd repos/frk/<name>`
2. `git fetch origin && git checkout -b oriz-<topic> origin/main`
3. Make changes + commit
4. `gh repo fork --remote=true --remote-name=personal` (once per repo, creates chirag127 personal fork if missing)
5. `git push personal oriz-<topic>`
6. `gh pr create --repo <upstream-owner>/<repo> --head chirag127:oriz-<topic> --base main`

### Auto-sync (hourly)
Umbrella `oriz-org/workspace` runs `.github/workflows/oriz-sync-forks.yml`:
- Cron: every hour at `:17`.
- For each fork in matrix: clones upstream, force-pushes to oriz-org fork main.
- Needs `SYNC_TOKEN` secret in workspace repo settings (PAT with repo scope).
- Manual trigger via `workflow_dispatch` for ad-hoc sync.

Forks stay 100% upstream-clean. No oriz workflow files on fork main.

### Where 68-commit history of freellmapi went
Saved as `archive/pre-2026-06-27` branch on `oriz-org/freellmapi`. Old work survives forever; cherry-pick when needed. Main was hard-reset to upstream HEAD on 2026-06-27.

## Anti-patterns

- ? Commit any oriz-authored file to fork `main`
- ? PR upstream from `oriz-org:branch` (use `chirag127:branch`)
- ? Let fork main drift from upstream main for > 1 hour (auto-sync handles this)
- ? Add a `backup` remote to forks (per `no-dual-remote-backup`)
- ? `git clone https://github.com/oriz-org/<repo>` and treat that as primary — clone from upstream

## Cross-refs

- `no-dual-remote-backup` — companion: GitHub IS the backup
- `fork-discipline` — what stays in fork branches (deploy/, docs/oriz/, .github/workflows/oriz-*) + the minimum-diff principle
- `fleet-owner-oriz-org` — ownership lives at org level
