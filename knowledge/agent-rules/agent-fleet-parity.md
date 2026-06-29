---
type: rule
title: 'Agent fleet parity: same rules + MCPs across all agents'
description: All fleet agents share same rules + MCP servers. Sync via scripts/sync-mcp-configs.mjs. No private rule sets
tags: [agent, fleet, parity, sync, mcp, claude-code, opencode, kilocode, antigravity, hard-rule]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - agent-rules/no-global-config-without-grilling
  - agent-rules/mcp-config-single-source-of-truth
  - decisions/agent-tooling/fleet-cut-to-4-agents-2026-06-29
---

# Agent fleet parity

## Rule

Every agent in the fleet sees:

1. **Same workspace rules** — via `.agents/<agent>/AGENTS.md` pointing at the root `AGENTS.md` (or the agent's native equivalent file).
2. **Same MCP servers** — via `scripts/sync-mcp-configs.mjs` writing the canonical `.mcp.json` to each agent's expected path.
3. **Same skills** — via junction from `repos/own/infra/agent-skills` to each agent's expected `skills/` location.

Failover between agents is then just a matter of launching a different binary; configuration stays identical.

## Current fleet (2026-06-29)

Four agents, no more:

| Agent | Type | Pointer file | MCP config | Skills dir |
|---|---|---|---|---|
| **Claude Code** | CLI (primary) | `.agents/claude/CLAUDE.md` | `.mcp.json` (canonical) | `.claude/skills/` (junction) |
| **OpenCode** | CLI | `.agents/opencode/AGENTS.md` | `.opencode/opencode.jsonc` (transformed) | `.opencode/skills/` (junction) |
| **Kilo Code** | VS Code ext | `.agents/kilocode/rules/00-pointer.md` | `.kilocode/mcp.json` (direct copy) | `.kilocode/skills/` (junction) |
| **Antigravity** | Standalone IDE | `.agents/antigravity/AGENTS.md` | `.antigravity/mcp.json` (direct copy) | `.agents/skills/` |

Failover order if Claude Code is unavailable: **OpenCode ? Kilo Code ? Antigravity**.

## What's NOT in the fleet (and why)

| Excluded | Why |
|---|---|
| Cline | Dropped 2026-06-29 — overlaps Kilo Code (both VS Code, both MCP-native); avoids duplicate sync target. See [`fleet-cut-to-4-agents-2026-06-29`](../../decisions/agent-tooling/fleet-cut-to-4-agents-2026-06-29.md). |
| Aider | No native MCP support (confirmed live 2026-06-29). |
| Goose, Continue.dev, Gemini CLI | Not currently in use; can be added if needed via grill-me. |
| Cursor, Windsurf | Card-on-file required — violates [`no-card-on-file`](../interaction/no-card-on-file.md). |

## Sync flow

```
.mcp.json                                  ? edit here only
  +-? scripts/sync-mcp-configs.mjs
       +-? .kilocode/mcp.json              (direct copy)
       +-? .antigravity/mcp.json           (direct copy)
       +-? .opencode/opencode.jsonc        (format-transformed)
```

After every `.mcp.json` change: `node scripts/sync-mcp-configs.mjs`.

## Anti-patterns

- ? Edit `.kilocode/mcp.json` or `.antigravity/mcp.json` directly — gets overwritten next sync.
- ? Add an agent-specific rule file outside the pointer pattern.
- ? Install a new agent without adding its pointer + MCP target to this rule.

## Cross-refs

- [`mcp-config-single-source-of-truth`](./mcp-config-single-source-of-truth.md) — the sync mechanic
- [`no-global-config-without-grilling`](./no-global-config-without-grilling.md) — what enables parity (no per-machine drift)
- [`fleet-cut-to-4-agents-2026-06-29`](../../decisions/agent-tooling/fleet-cut-to-4-agents-2026-06-29.md) — Cline-drop decision
