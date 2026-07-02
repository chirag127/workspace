---
type: rule
title: Everything durable → cloud
description: Every long-lived artefact (knowledge, skills, memory, secrets, repo mirrors) has a cloud copy; local machine is a cache, not source of truth.
tags: [cloud, backup, sync, availability]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: high
durability: durable
related:
  - decisions/agent-tooling/cloud-publish-knowledge-2026-07-03
  - decisions/agent-tooling/cloud-publish-skills-2026-07-03
  - decisions/agent-tooling/memory-cross-machine-sync-2026-07-03
  - decisions/ops/mirror-to-9-popular-alternatives-2026-06-28
---

# Everything durable → cloud

## Rule

Every durable artefact has a cloud copy. Local machine is a cache, not source of truth. Reproducibility requires cloud-primary posture.

## What counts as durable

| Artefact | Cloud target | Rule doc |
|---|---|---|
| `knowledge/` bundle | `knowledge.oriz.in` (CF Pages public) | [`cloud-publish-knowledge-2026-07-03`](../../decisions/agent-tooling/cloud-publish-knowledge-2026-07-03.md) |
| `agent-skills/` bundle | `skills.oriz.in` + registry + GH Pages | [`cloud-publish-skills-2026-07-03`](../../decisions/agent-tooling/cloud-publish-skills-2026-07-03.md) |
| MEMORY.md + per-project memory/ | `chirag127/claude-memory` private repo (sops+age) | [`memory-cross-machine-sync-2026-07-03`](../../decisions/agent-tooling/memory-cross-machine-sync-2026-07-03.md) |
| Secrets | Bitwarden + `.env.enc` (sops+age) in workspace | [`sops-plus-doppler-hybrid`](../../security/sops-plus-doppler-hybrid.md) |
| Workspace repo | 6-host mirror (GitHub + 5 alternatives) | [`mirror-all-hosts-setup`](../../runbooks/platform/mirrors/mirror-all-hosts-setup.md) |
| Fork PRs | chirag127 fork + upstream PR + auto-sync | [`fork-thin-upstream-tracking`](./fork-thin-upstream-tracking.md) |

## What does NOT need cloud

- Runtime state (open files, running processes, TUI history)
- Machine-specific paths (`C:\D\oriz\...`)
- Cached indexes (regenerate on demand)
- `.mimo/`, `.opencode/`, etc. — dropped agent state, dropped rule

## Why cloud-primary

- **Machine loss** — corp laptop wipe or personal laptop failure = zero-loss recovery.
- **Cross-machine parity** — every laptop can be primary in <5 min bootstrap.
- **Zero-fleet failover** — single-agent (CC only) means no in-fleet backup; cloud IS the backup.
- **Public discovery** — knowledge/ + skills/ have value beyond us; publish them.

## Constraints

- **No card-on-file** — cloud targets must be free-tier per `no-card-on-file`.
- **sops+age encrypted** — anything sensitive travels encrypted.
- **Git as sync target when possible** — vendor-neutral, portable.

## Anti-patterns

- ❌ Local-only artefact that can't be recreated from cloud
- ❌ Cloud target that requires card
- ❌ Sync without encryption for sensitive data
- ❌ "I'll push it later" — auto-sync hooks per `auto-sync-enabled-2026-07-03`

## Cross-refs

- [`cloud-publish-knowledge-2026-07-03`](../../decisions/agent-tooling/cloud-publish-knowledge-2026-07-03.md)
- [`memory-cross-machine-sync-2026-07-03`](../../decisions/agent-tooling/memory-cross-machine-sync-2026-07-03.md)
- [`no-card-on-file`](../interaction/no-card-on-file.md)
