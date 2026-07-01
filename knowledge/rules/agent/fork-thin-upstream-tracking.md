---
type: rule
title: 'Fork model: chirag127-owned + upstream tracking + weekly auto-sync'
description: Forks live under chirag127 personal account. origin=chirag127 + upstream=source. PRs directly from origin. Weekly auto-PR sync from upstream.
tags: [forks, upstream, sync, ci, chirag127, hard-rule]
timestamp: 2026-07-01
format_version: okf-v0.1
status: active
supersedes:
  - rules/agent/fork-thin-upstream-tracking-2026-06-29
related:
  - rules/development/fork-discipline
  - rules/agent/no-fork-divergence
  - decisions/agent-tooling/oss-audit-2026-07-01
---

# Fork model — chirag127-owned

## Locked decisions (2026-07-01 — reverses 2026-06-29 `oriz-org` model)

### Fork ownership
- **All forks live under `chirag127` on GitHub** (personal account, not the `oriz-org` organization).
- Local checkouts: `repos/frk/<name>/`.
- Current matrix (2026-07-01):
  - `freellmapi` ← `tashfeenahmed/freellmapi`
  - `omniroute` ← `diegosouzapw/OmniRoute`
  - `ai-rewrite-bs-ext` ← `SupratimRK/Ai-rewrite`
  - `youtube` ← `code-charity/youtube`

### Remote naming — STANDARD model
Default Git remote names in each local fork clone:
- `origin`   → chirag127 fork  (e.g. `chirag127/OmniRoute.git`)
- `upstream` → source          (e.g. `diegosouzapw/OmniRoute.git`)

Matches GitHub default, `gh repo fork`, IDE assumptions.

### Why chirag127, not oriz-org (2026-07-01 reversal)

Real-world friction from the 2026-06-29 `oriz-org` model:

- **"Allow edits from maintainers" broken.** GitHub's `maintainer_can_modify` flag on PRs does NOT apply to org-owned forks. Confirmed via [OmniRoute PR #5752](https://github.com/diegosouzapw/OmniRoute/pull/5752#issuecomment-4850260724): maintainer Diego Souza couldn't push a test onto the branch and had to create an integration PR (#5769) as a workaround. This adds latency to every upstream contribution.
- **PR authorship attribution.** PRs from `oriz-org:<branch>` show the org as the author on `gh pr list`; upstream maintainers seeing dozens of org-named PRs read like a company campaign, not a contributor. `chirag127:<branch>` reads as a person.
- **No compensating benefit.** The `oriz-org` model was chosen for "namespace tidiness" but GitHub already redirects deleted-org-fork URLs for a year; the tidiness was theoretical.

### Fork main = upstream main, byte-identical

Fork's `main` branch = upstream `main` exactly. **No drift allowed.** Per [`no-fork-divergence`](./no-fork-divergence.md), every local change files as an upstream PR branch — never as a commit on fork main.

Weekly auto-sync (see below) keeps this true even if upstream advances.

### PRs to upstream

PRs go **directly from chirag127-owned fork** — no personal-secondary-fork dance.

Workflow:
1. `cd repos/frk/<name>`
2. `git fetch upstream && git checkout -b <topic> upstream/main`
3. Make changes + commit
4. `git push origin <topic>` (pushes to chirag127 fork)
5. `gh pr create --repo <upstream-owner>/<repo> --head chirag127:<topic> --base main`

### Auto-sync (weekly auto-PR)

Umbrella `oriz-org/workspace` runs `.github/workflows/oriz-sync-forks.yml`:
- **Cron:** Sunday 03:00 IST (`30 21 * * 6` UTC).
- **Per fork:**
  1. Clone `chirag127/<fork>` using `SYNC_TOKEN` (PAT for chirag127 account, repo scope).
  2. Fetch upstream.
  3. If SHAs match, exit early.
  4. Otherwise create `upstream-sync/YYYY-MM-DD` branch from `upstream/main`, push, open PR into `chirag127/<fork>` main.
  5. Enable GitHub auto-merge. Clean → merge. Conflict → wait for human.
- Manual trigger via `workflow_dispatch`.
- **Secret needed:** `SYNC_TOKEN` — PAT for chirag127, `repo` scope, stored in `oriz-org/workspace` secrets.

## Migration checklist (executed 2026-07-01)

- [x] Delete `oriz-org/omniroute`, `oriz-org/freellmapi`, `oriz-org/ai-rewrite-bs-ext`
- [x] Re-fork under `chirag127/*` (rename from `-1` suffix to clean names)
- [x] Update local remotes: `git remote set-url origin https://github.com/chirag127/<name>.git`
- [x] Re-push our open branches (`feat/version-in-startup-banner`, `fix/missing-runtime-deps-toon-safe-regex`) to new chirag127 forks
- [x] Handle in-flight upstream PRs: close old (#5752 already merged via #5769; #5766 auto-closed on fork deletion); reopen from new head (#5771 replaces #5766)
- [x] Update `.github/workflows/oriz-sync-forks.yml` to point at `chirag127/*` (in workspace repo — not this file)
- [x] Update `AGENTS.md`, `knowledge/` refs

## Anti-patterns

- ❌ Commit any local change to fork `main` (files upstream PR instead)
- ❌ PR upstream from `oriz-org:branch` (this rule and predecessor are both explicit: PRs from `chirag127`)
- ❌ Create sub-forks like `chirag127/<repo>-1` — always rename to clean name
- ❌ Force-push fork main (auto-sync does merges, not overwrites)

## Cross-refs

- [`no-fork-divergence`](./no-fork-divergence.md) — mandates zero drift; this rule enables it
- [`fork-discipline`](../development/fork-discipline.md) — general fork rules
- [`oss-audit-2026-07-01`](../../decisions/agent-tooling/oss-audit-2026-07-01.md) — the audit that exposed the `oriz-org` friction
