---
type: decision
title: Enable auto-sync scripts for cross-machine parity
description: Reverse the 2026-06-29 manual-only stance; MEMORY sync + globals-derived + mirror hosts now auto on hooks/cron with grill-on-drift.
tags: [sync, hooks, automation, cross-machine]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: medium
durability: durable
supersedes:
  - decisions/agent-tooling/globals-derived-rule-2026-06-29
related:
  - decisions/agent-tooling/memory-cross-machine-sync-2026-07-03
  - rules/agent/globals-derived-from-workspace
---

# Auto-sync scripts enabled

## Decision

Enable auto-sync for three surfaces:

1. **MEMORY.md** — Stop hook push, SessionStart hook pull (per `memory-cross-machine-sync-2026-07-03`).
2. **globals-derived** — SessionStart hook checks workspace-vs-globals drift, fires grill-me on non-trivial diff.
3. **Mirror hosts** — GH Actions cron pushes to 6 mirrors weekly (per `mirror-all-hosts-setup` — already scheduled, verify).

Reverses 2026-06-29 stance ("don't sync automatically anyway anything for now i will do it individually") because cross-machine sync now in scope.

## Why revoke manual-only

- **Cross-machine sync locked** — MEMORY between corp + personal laptops requires auto-push/pull to work at all. Manual runs = forgotten runs = stale memory.
- **Grill-on-drift preserved** — auto doesn't mean silent. Non-trivial drift still surfaces MCQ.
- **Zero-friction failover** — dropped Sonnet fleet means if CC breaks on corp, personal laptop must be ready in <5 minutes. Auto-sync makes that real.

## Confidence: medium

- New hook surface — bugs likely.
- Grill-on-drift depends on `claude` CLI being available in hook context. Fallback = interactive PowerShell prompt.
- Watch for: hook execution time bloating session start; conflicts between corp + personal + laptop offline; sops key not decrypting on new machine.

## Rollback

- Revert this decision by re-locking manual-only.
- Remove hooks from `~/.claude/settings.json` template.
- Delete auto-push/pull scripts.

## Anti-patterns

- ❌ Auto-sync without grill-on-drift — silent overwrites.
- ❌ Push on every tool call — Stop-hook only (once per session).
- ❌ Auto-run on machines without sops key — fails gracefully, doesn't corrupt.

## Cross-refs

- [`memory-cross-machine-sync-2026-07-03`](./memory-cross-machine-sync-2026-07-03.md)
- [`globals-derived-from-workspace`](../../rules/agent/globals-derived-from-workspace.md)
