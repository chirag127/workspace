---
type: index
title: General
description: Index of concepts in architecture/general.
tags:
- index
- general
timestamp: '2026-06-24'
format_version: okf-v0.1
status: active
---

# General

## Concepts

- [Layer 4 — database, sharded by data shape](./layer-4-database-by-shape.md) — Different data shapes go in different free tiers, deliberately spreading load so no single quota gets exhausted. Git for canonical, Firestore for user state, Turso for warm cache, browser for per-user search, R2 only when needed.
- [Layer 5 — compute, in three tiers](./layer-5-compute.md) — Compute work is split across GitHub Actions cron (build-time), Cloudflare Workers (edge runtime), and the user's browser. Each tier has a free quota and a clear remit.
- [Master pointer as production SHA](./master-pointer-as-production-sha.md) — The chirag127/oriz master repo's submodule pointers IS the production state of the family. Bumping a submodule pointer + pushing master = deploying that submodule to production via the matrix workflow.
- [agent-skills monorepo + symlink invariant](./agent-skills-monorepo.md) — Single source of truth for all agent skills used by both Claude Code (~/.claude/skills/) and the cross-agent harness (~/.agents/skills/). Lives as a git submodule of oriz; both target dirs are symlinks into it.
