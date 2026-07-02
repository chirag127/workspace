---
type: decision
title: oriz-org dissolved — everything to chirag127
description: GitHub org dissolved 2026-07-03; all repos + workspace umbrella now under chirag127 personal account; sweep replaces all references.
tags: [github, migration, ownership, org]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: high
durability: durable
supersedes:
  - decisions/fleet/fleet-owner-oriz-org
  - decisions/ops/backup-keys-repo-oriz-org-backup
related:
  - rules/agent/fork-thin-upstream-tracking
  - decisions/branding/chirag127-owns-everything-2026-07-02
  - decisions/branding/repo-naming-drop-oriz-prefix-2026-06-25
---

# oriz-org dissolved — chirag127 owns everything

## Decision

`oriz-org` GitHub org dissolved 2026-07-03. All repos + umbrella `workspace` now under `chirag127/*`. Single-account model.

## Reality check (found during migration)

`.gitmodules` + umbrella remote **already** pointed at `chirag127/*` when grill fired. Fleet-cut 2026-07-01 already moved forks (`fork-thin-upstream-tracking`). Branding decision 2026-07-02 already declared chirag127-owns-everything. Only stale text in docs, workflows, package.json remained — 416 occurrences across 122 files. Migration = grep-and-replace sweep + delete superseded decision docs.

## Why chirag127-only

Matches 3 prior locked decisions:
- `fork-thin-upstream-tracking-2026-07-01` — forks under chirag127
- `chirag127-owns-everything-2026-07-02` — brand consolidation
- `repo-naming-drop-oriz-prefix-2026-06-25` — drop `oriz-` prefix

Real friction that killed oriz-org:
- **PR attribution** — org-authored PRs read as company campaigns not contributor. See [oss-audit-2026-07-01](./oss-audit-2026-07-01.md).
- **maintainer_can_modify broken** for org-owned forks per GitHub. Cost latency on every upstream PR.
- **No compensating benefit** — GitHub redirects deleted-org URLs for 1 year; "namespace tidiness" was theoretical.

## Actions

1. Sweep 122 files: `oriz-org` → `chirag127`. Category A live pointers rewritten; Category B superseded docs `git rm`ed.
2. Deleted: `fleet-owner-oriz-org.md`, `backup-keys-repo-oriz-org-backup.md`, `scripts/migrate-to-oriz-org.mjs`.
3. `oriz.in` domain kept. Brand = domain, not repo names.
4. Publish targets shift: `knowledge.oriz.in` + `skills.oriz.in` under chirag127-owned CF Pages account.

## Anti-patterns

- ❌ Reference `oriz-org/*` anywhere going forward — org does not exist.
- ❌ Recreate `oriz-org` at GitHub — decision locked at chirag127.
- ❌ Move to new org (`oriz` etc.) — same reasons this failed.

## Cross-refs

- [`chirag127-owns-everything-2026-07-02`](../../branding/chirag127-owns-everything-2026-07-02.md)
- [`fork-thin-upstream-tracking`](../../rules/agent/fork-thin-upstream-tracking.md)
- [`oss-audit-2026-07-01`](./oss-audit-2026-07-01.md)
