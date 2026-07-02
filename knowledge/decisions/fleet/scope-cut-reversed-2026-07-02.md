---
type: decision
title: "Scope-cut reversed — all 99 archived repos back in fleet 2026-07-02"
description: "Reverses scope-cut-2026-06-25. Every archived repo unarchived and returns to the maintained fleet. Fleet now = 119 (20 active + 99 revived). Maintenance level: alive (Dependabot + working CI), not full-feature reactivation."
tags: [fleet, scope, archived, unarchive, maintenance, reversal]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
supersedes:
  - decisions/fleet/scope-cut-2026-06-25
  - decisions/apps/eleven-saturated-archived-2026-06-25
  - decisions/apps/fleet-strategy-build-gate-2026-06-25
related:
  - branding/chirag127-owns-everything-2026-07-02
  - branding/brand-independent-naming-2026-07-02
  - decisions/architecture/agent-tooling/reusable-workflows-layered-2026-07-02
---

# Scope-cut reversed 2026-07-02

## Decision

Every archived chirag127 repo (99 total) is unarchived and returns to the maintained fleet. Fleet = **119 repos**: 20 already active (this session's Dagger sweep) + 99 revived.

## Why (reversal from 2026-06-25)

The scope-cut on 2026-06-25 archived 33+ in-progress repos as "won't be maintained." Six weeks later:

- **The build barrier collapsed.** Claude Code + agents can now write CI + configs + reusable-workflow pins for you in minutes. Zero technical cost to maintain a repo now vs. real cost in June.
- **Recruiter surface benefits.** 119 active repos on chirag127 profile beats 20 active + 99 archived. Archived repos are visually greyed on GitHub and don't count on the profile activity graph.
- **Supply-chain risk was accruing.** Archived repos accumulate stale-dep security advisories that show up in dependabot alerts across the account.
- **Reusable-workflow model scales cheap.** With `chirag127/workflows` reusable workflow (2026-07-02) + Dagger modules, each repo needs 5 lines of workflow config + one dagger.json to have working CI. Not per-repo cost.

## Maintenance level (locked)

**Keep alive only.** No feature work on the 99. Specifically:

| Maintenance | Yes/No |
|---|---|
| Dependabot enabled + auto-merge on CI green | Yes |
| Reusable-workflow pin at `chirag127/workflows` | Yes (next-session sweep) |
| CI green on push | Yes |
| Fresh deploy | No (deploy secrets stay on the 20 active fleet) |
| New feature commits | No unless the user explicitly picks a repo to work on |
| Renovate config | Yes (opt-in Dependabot alternative for grouped updates) |
| Listing in profile README | Only the 20 primary fleet repos are named; the other 99 covered by the "500+ more" pointer to workspace/knowledge/index.md |

## Fleet tiering (implicit)

- **Tier 1 (20 active):** Sites, APIs, apps, ext, books currently deployed at `*.oriz.in`. Named in profile README. Dagger + reusable workflow migrated.
- **Tier 2 (99 revived):** Alive but not actively deployed. Dependabot on. Discoverable via `chirag127/*` browse. Not named individually.

No hard-coded tier flag in knowledge — the distinction is who lands in the profile README and who doesn't.

## Superseded

The following files are DELETED per [`knowledge-deletion-not-supersession`](../../rules/agent/knowledge-deletion-not-supersession.md):

- `decisions/fleet/scope-cut-2026-06-25.md` — the original archive decision
- `decisions/apps/eleven-saturated-archived-2026-06-25.md` — the 11-app archive
- `decisions/apps/fleet-strategy-build-gate-2026-06-25.md` — the build-gate that gated the archive

## Anti-patterns

- ❌ Re-archiving repos in a future scope-cut without first checking Dependabot cost + Renovate load
- ❌ Treating the 99 as first-class deploy targets (they're not; that's the 20)
- ❌ Adding all 99 to the profile README individually
- ❌ Feature work on Tier-2 without moving it to Tier-1 first (deploy target update)

## Cross-refs

- [`chirag127-owns-everything-2026-07-02`](../../branding/chirag127-owns-everything-2026-07-02.md) — the umbrella of everything-under-chirag127
- [`brand-independent-naming-2026-07-02`](../../branding/brand-independent-naming-2026-07-02.md) — the naming pattern the 99 keep
- [`reusable-workflows-layered-2026-07-02`](../architecture/agent-tooling/reusable-workflows-layered-2026-07-02.md) — the CI they'll adopt
