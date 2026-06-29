---
type: decision
title: "claude-notifications-cli — deleted 2026-06-29"
description: CLI fork dropped. Notifications no longer fit 4-agent fleet
tags: [fleet, fork, deletion, claude-code]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
supersedes:
  - decisions/fleet/scope-cut-2026-06-25.md
related:
  - decisions/fleet/scope-cut-2026-06-25.md
  - agent-rules/preferences/scope-cut-only-shipping-survives.md
  - services/family-inventory.md
---

## Decision

Delete the `claude-notifications-cli` submodule + GitHub fork (`oriz-org/claude-notifications-cli`). Was at v1.40.0 with local windows-fixes commits ahead of upstream `777genius/claude-notifications-go`.

## Why

- Standalone notification CLI overlaps with what the Hr proxy chain + native Claude Code hook system already cover.
- Scope-cut discipline ([scope-cut-2026-06-25](./scope-cut-2026-06-25.md)) — only shipping content survives. This CLI was on the survival list but not actually used since 2026-06-22.
- Fork inventory drops from 5 ? 4 (`ai-rewrite-bs-ext`, `dearrow-plus-bs-ext`, `freellmapi`, `omniroute`).

## What was lost

- 2 local commits ahead of upstream — windows fixes (b22c5bb focus-aware notifications, d01f347 package.json slug). If ever resurrected, cherry-pick from `oriz-org/workspace` git reflog before 2026-09-29 (90-day GitHub recovery window) or from local `.git/modules/` snapshot.

## Cleanup performed same turn

- `git submodule deinit -f repos/frk/claude-notifications-cli`
- `git rm -f repos/frk/claude-notifications-cli`
- `gh repo delete oriz-org/claude-notifications-cli --yes`
- Knowledge scrub: `family-inventory.md` (count + line), `scope-cut-2026-06-25.md` (CLI list), `fs-own-frk-split.md` (5?4 forks), `scope-cut-only-shipping-survives.md` (line).
