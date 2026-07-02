---
type: decision
title: Dropped-agent configs deleted early — override 90-day cooldown
description: .opencode/.kilocode/.antigravity/.mimo/ config directories deleted now instead of waiting 2026-10-02; pointer stubs preserved for AGENTS.md portability.
tags: [fleet-cut, cleanup, agents]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: high
durability: durable
supersedes:
  - decisions/agent-tooling/fleet-cut-to-cc-only-2026-07-02
related:
  - decisions/agent-tooling/fleet-cut-to-cc-only-2026-07-02
---

# Dropped-agent configs — early cleanup

## Decision

Delete `.opencode/`, `.kilocode/`, `.antigravity/`, `.mimo/` config directories NOW (2026-07-03) instead of waiting the 90-day cooldown (2026-10-02) set by [`fleet-cut-to-cc-only-2026-07-02`](./fleet-cut-to-cc-only-2026-07-02.md).

## What stays

- `.agents/opencode/AGENTS.md` and other pointer stubs — preserved. Any AGENTS.md-reader pointed at this repo still resolves rules.
- Git history — 90-day cooldown replaced by "revive from `git log` if reintroduction proposal locks per gate."

## What goes

- Per-agent MCP config JSONs (dropped-agent-specific).
- Per-agent skill junction targets no longer created.
- Sync script's dropped-agent branches (`scripts/sync-mcp-configs.mjs` — already removed 2026-07-02 per prior commit).

## Why early

- **Disk hygiene** — 4 config trees × N files each = repo bloat.
- **Sync-script complexity** — every stale branch = code path that could break future refactors.
- **90-day cooldown was cautious** — no reintroduction proposals surfaced in 24 hours. Signal: no one wants these back.
- **Reintroduction still possible** via git-log revival + gate rebuttal per [`fleet-cut-to-cc-only-2026-07-02`](./fleet-cut-to-cc-only-2026-07-02.md).

## Anti-patterns

- ❌ Also delete `.agents/*/AGENTS.md` pointer stubs — those keep the repo portable to future agents.
- ❌ Reinstate cooldown for future fleet cuts — decision is: cut fast, revive from git if needed.
- ❌ Delete without commit trail — must be one commit so reintroduction has a `git revert` target.

## Cross-refs

- [`fleet-cut-to-cc-only-2026-07-02`](./fleet-cut-to-cc-only-2026-07-02.md) — parent decision
- [`fleet-cut-gocode-2026-07-01`](./fleet-cut-gocode-2026-07-01.md) — earlier cut
