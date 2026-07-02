---
type: rule
title: Cross-machine parity via sync
description: Every machine can act as primary; sync auto keeps them equal; no machine-specific state that can't be reproduced from cloud+workspace.
tags: [cross-machine, sync, parity, availability]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: high
durability: durable
related:
  - decisions/agent-tooling/memory-cross-machine-sync-2026-07-03
  - decisions/agent-tooling/auto-sync-enabled-2026-07-03
  - rules/agent/globals-derived-from-workspace
  - rules/agent/everything-durable-to-cloud
---

# Cross-machine parity via sync

## Rule

Every machine (corp laptop, personal laptop, future laptop) can be primary. Sync auto keeps them equal. No machine-specific state that can't be reproduced from cloud + workspace.

## Machines in scope

- **Corp laptop** — Windows 11, `C:\D\oriz`. Bedrock chain for Claude. Currently primary.
- **Personal laptop** — TBD build. Same workspace layout. Free-provider fallback for AI.
- **Future laptops** — bootstrap from `install-and-bootstrap` runbook.

## What syncs

- **Workspace tree** — `git clone --recurse-submodules chirag127/workspace`.
- **Memory** — `chirag127/claude-memory` pull on SessionStart.
- **Globals** — `sync-globals.mjs` derives `~/.claude/`, `~/.opencode/`, etc. from workspace.
- **Skills** — junction from `repos/own/infra/agent-skills` to user-global dirs.

## What does NOT sync

- **Auth tokens** — per-machine, in `~/.claude/settings.local.json` (gitignored). Re-auth on new machine.
- **Session logs / TUI history** — ephemeral.
- **Absolute binary paths** — machine-specific; scripts detect at runtime.

## Bootstrap on new machine

Per `install-and-bootstrap` runbook. 5-minute target:

1. `gh auth login`
2. `git clone --recurse-submodules https://github.com/chirag127/workspace.git C:\D\oriz`
3. `cd C:\D\oriz\repos\own\backup && .\bootstrap.ps1` (installs everything)
4. `node scripts/sync-globals.mjs --bootstrap` (writes globals)
5. Import age key from Bitwarden
6. First session pulls MEMORY.md automatically

## Why 5-min target

- Corp laptop failure = personal laptop primary within 5 min = no work-day lost.
- Card-off dependency check — nothing in bootstrap requires paid tier.

## Anti-patterns

- ❌ Machine-specific rules or scripts that don't check `hostname` or per-machine profile
- ❌ Uncommitted config that "works on my machine"
- ❌ Manual sync steps not in a script — cron / hook everything

## Cross-refs

- [`memory-cross-machine-sync-2026-07-03`](../../decisions/agent-tooling/memory-cross-machine-sync-2026-07-03.md)
- [`auto-sync-enabled-2026-07-03`](../../decisions/agent-tooling/auto-sync-enabled-2026-07-03.md)
- [`globals-derived-from-workspace`](./globals-derived-from-workspace.md)
- [`everything-durable-to-cloud`](./everything-durable-to-cloud.md)
