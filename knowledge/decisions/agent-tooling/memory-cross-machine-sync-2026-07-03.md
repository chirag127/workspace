---
type: decision
title: MEMORY.md cross-machine sync via chirag127/claude-memory + sops+age
description: Private GH repo with sops+age encrypted MEMORY.md and per-project memory/ trees. Auto-push on session end, auto-pull on session start.
tags: [memory, sync, sops, age, encryption, hooks]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: high
durability: durable
related:
  - rules/security/no-hardcoded-secrets
  - services/infra/backup/backup-restic-to-b2
  - decisions/architecture/agent-tooling/globals-derived-rule-2026-06-29
---

# MEMORY.md cross-machine sync

## Decision

Private GH repo `chirag127/claude-memory`. sops+age encrypted. Auto-push on Claude Code session end via Stop hook. Auto-pull on SessionStart hook.

## What syncs

- `~/.claude/projects/*/memory/*.md` (all project memories)
- `~/.claude/projects/*/memory/MEMORY.md` (indexes)

Not: `~/.claude/settings.local.json` (per-machine auth), `~/.claude/history.jsonl` (session logs), skills junctions (already synced via agent-skills submodule).

## Why private repo + sops

- **Private repo** — memories may contain sensitive project detail, personal preferences, WIP context. Public leaks bad.
- **sops+age** — already the workspace secrets pattern per `sops-plus-doppler-hybrid`. Zero new tooling.
- **No vendor lock-in** — sync target = git. Swap host without re-tooling.

## Rejected alternatives

- **Restic to B2** — restic is for backups (point-in-time snapshots), not sync (bidirectional real-time). Different tool.
- **CF R2 encrypted** — R2 needs card. Blocked by `no-card-on-file`.
- **Syncthing P2P** — no cloud, but requires Syncthing running on both machines + LAN or hole-punching. Reliability lower than GH.

## Hook wiring

`~/.claude/settings.json` hooks:
```json
{
  "hooks": {
    "SessionStart": [{"hooks": [{"type": "command", "command": "sh C:/d/oriz/scripts/memory-pull.sh"}]}],
    "Stop": [{"hooks": [{"type": "command", "command": "sh C:/d/oriz/scripts/memory-push.sh"}]}]
  }
}
```

Scripts do:
- **Pull:** `git -C ~/.claude/projects clone --depth 1 chirag127/claude-memory /tmp/mem && sops -d /tmp/mem/*.enc.md > ~/.claude/projects/...`
- **Push:** `sops -e ~/.claude/projects/*/memory/*.md > /tmp/mem/*.enc.md && git commit + push`. Fires only if diff non-empty.

## Anti-patterns

- ❌ Sync unencrypted — memories = sensitive.
- ❌ Sync on every tool call — only on session Stop. Rate control.
- ❌ Overwrite blindly on pull — merge with local. If conflict, warn user.

## Cross-refs

- [`no-hardcoded-secrets`](../../rules/security/no-hardcoded-secrets.md)
- [`sops-plus-doppler-hybrid`](../../security/sops-plus-doppler-hybrid.md)
