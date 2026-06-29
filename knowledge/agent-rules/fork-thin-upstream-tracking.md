---
type: rule
title: 'Fork model: thin tracking + personal-author PRs + umbrella weekly auto-PR sync'
description: Forks under oriz-org track upstream main. origin=upstream + fork=oriz-org. PRs from chirag127. Sync via weekly auto-PR with auto-merge on clean.
tags: [forks, upstream, sync, ci, oriz-org, chirag127, hard-rule]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
supersedes:
  - agent-rules/fork-thin-upstream-tracking-2026-06-27
related:
  - rules/development/fork-discipline
  - decisions/fleet/fleet-owner-oriz-org
  - decisions/fleet/aggregator-strategy-side-by-side
---

# Fork model

## Locked decisions (2026-06-29 — revises 2026-06-27)

### Fork ownership
- All forks live under `oriz-org` on GitHub (per existing `fleet-owner-oriz-org` rule).
- Local checkouts: `repos/frk/<name>/`.
- Current matrix (audited 2026-06-29, revised): `freellmapi`, `omniroute`, `ai-rewrite-bs-ext`. Three upstream trackers.
  - `freellmapi` ← `tashfeenahmed/freellmapi`
  - `omniroute` ← `diegosouzapw/OmniRoute`
  - `ai-rewrite-bs-ext` ← `SupratimRK/Ai-rewrite` (added 2026-06-29 — was missed in the 2026-06-29 morning audit because it uses the standard remote model, which the audit script didn't check)

### Remote naming — STANDARD model
Default Git remote names in each local fork clone:
- `origin`   → oriz-org fork  (e.g. `oriz-org/freellmapi.git`)
- `upstream` → source         (e.g. `tashfeenahmed/freellmapi.git`)

This matches GitHub default, `gh repo fork`, IDE assumptions, and the broader git ecosystem. `git pull` pulls from your fork by default. To pull upstream: `git pull upstream main`. Add a local alias if you want a shorter verb.

**What changed 2026-06-29 (evening):** Earlier the same day, this rule documented an INVERTED model where `origin`=upstream + `fork`=oriz-org. That model was used by freellmapi + omniroute but not ai-rewrite-bs-ext (which used the standard model). User chose to standardise on the standard model. freellmapi and omniroute local remotes were flipped via `git remote rename origin upstream && git remote rename fork origin`.

### Fork main = upstream main, eventually consistent
Fork's `main` branch tracks upstream `main`. Drift is allowed for up to 1 week (between cron runs) and during the lifetime of an open sync PR. Oriz work never lands on fork main, so the only legitimate divergence between syncs is when upstream itself moves.

**What changed 2026-06-29:** Previous version of this rule (2026-06-27) used hourly force-push to keep divergence at zero. User overrode 2026-06-29: weekly auto-PR gives a review checkpoint between upstream and fork main, catches upstream regressions or hostile commits before they propagate. Trade: up to a week of staleness in exchange for an audit trail and a halt button.

### Where oriz work lives
Never on `main` of a fork. Three valid surfaces:
1. **`oriz/<topic>` branches on the fork** — for work-in-progress that's not ready for upstream.
2. **`chirag127/<repo>` personal fork** — when filing an upstream PR. Branch named `oriz-<topic>`.
3. **Umbrella `c:/D/oriz/`** — for workspace tooling, sync workflows, knowledge.

### PRs to upstream: personal branding
PRs to upstream go from `chirag127/<repo>` (personal account), not from `oriz-org`. Keeps oriz-org clean of PR noise; keeps individual contribution credit on chirag127.

Workflow to file a PR:
1. `cd repos/frk/<name>`
2. `git fetch origin && git checkout -b oriz-<topic> origin/main`
3. Make changes + commit
4. `gh repo fork --remote=true --remote-name=personal` (once per repo, creates chirag127 personal fork if missing)
5. `git push personal oriz-<topic>`
6. `gh pr create --repo <upstream-owner>/<repo> --head chirag127:oriz-<topic> --base main`

### Auto-sync (weekly auto-PR with auto-merge on clean)
Umbrella `oriz-org/workspace` runs `.github/workflows/oriz-sync-forks.yml`:
- **Cron:** Sunday 03:00 IST (`30 21 * * 6` UTC). Weekend timing leaves Monday for triage.
- **Per fork in matrix:**
  1. Clone `oriz-org/<fork>` using `SYNC_TOKEN` (PAT, classic, repo scope).
  2. Fetch upstream.
  3. If SHAs match, exit early.
  4. Otherwise create `upstream-sync/YYYY-MM-DD` branch from `upstream/main`, push, open PR into fork main.
  5. Enable GitHub auto-merge. Clean PRs merge immediately when CI passes; conflicting PRs wait for human resolution.
- **Manual trigger** via `workflow_dispatch` for ad-hoc sync.
- **Secret required:** `SYNC_TOKEN` in `oriz-org/workspace` settings (default `GITHUB_TOKEN` cannot push to or open PRs in other repos).

Forks stay upstream-clean. No oriz workflow files on fork main.

### Where 68-commit history of freellmapi went
Saved as `archive/pre-2026-06-27` branch on `oriz-org/freellmapi`. Old work survives forever; cherry-pick when needed. Main was hard-reset to upstream HEAD on 2026-06-27.

## Anti-patterns

- ❌ Commit any oriz-authored file to fork `main`
- ❌ PR upstream from `oriz-org:branch` (use `chirag127:branch`)
- ❌ Let fork main drift from upstream main for > 1 week (cron handles this; if you see longer drift, the cron is broken — investigate)
- ❌ Force-push fork main from the cron (the 2026-06-27 model; replaced 2026-06-29)
- ❌ Use the inverted remote model (`origin`=upstream, `fork`=oriz-org) — was tried 2026-06-29 morning, reverted same evening
- ❌ Add a `backup` remote to forks (per `no-dual-remote-backup`)
- ❌ `git clone https://github.com/oriz-org/<repo>` and treat that as primary — clone from upstream

## Cross-refs

- `no-dual-remote-backup` — companion: GitHub IS the backup
- `fork-discipline` — what stays in fork branches (`deploy/`, `docs/oriz/`, `.github/workflows/oriz-*`) + the minimum-diff principle
- `fleet-owner-oriz-org` — ownership lives at org level
- `aggregator-strategy-side-by-side` — OmniRoute + freellmapi side-by-side eval; both currently localhost-only at `:20128` and `:8123`
