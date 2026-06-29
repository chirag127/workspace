---
type: decision
title: "MCP config single source of truth across all 5 agents"
description: Single .mcp.json synced to all 5 agents via script
tags: [mcp, config, agents, sync, infrastructure]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
supersedes:
  - (no prior decision — new)
related:
  - rules/agent/mcp-config-single-source-of-truth.md
---

# MCP config single source of truth

## The problem

18 MCP servers total (6 core + 12 toolbox), configured across 5 agents (Claude Code, OpenCode, Kilo Code, Cline, Antigravity). Each agent had its own config file with copy-pasted definitions. A single fix required editing 5 files.

## The decision (grill-locked 2026-06-29)

| Question | Chosen option |
|---|---|
| Config sync strategy | **Single source + sync script** — `.mcp.json` canonical, `scripts/sync-mcp-configs.mjs` derives all 5 agent configs |
| Server count | **Keep all 18, prune later** — no urgent need to consolidate |
| Agents to maintain | **Keep all 5**, single source of truth — each has different strengths |
| Search strategy | **Keep independent search tools** — no unified search wrapper needed |

## The 6 core MCP servers

| Server | Tool | Why kept |
|---|---|---|
| `fetch` | `mcp-server-fetch` | URL fetching, lightweight |
| `searxng` | `mcp-searxng` ? baresearch.org | Free multi-engine search |
| `open-websearch` | `open-websearch` (MODE=stdio) | GitHub README fetch + multi-engine |
| `mcp-crawl` | `./scripts/crawl-mcp/server.js` | Full browser crawl |
| `serena` | `oraios/serena` | Symbol-level code intelligence |
| `codebase-memory` | `codebase-memory-mcp` | Code graph / RAG |

## What was fixed

- `open-websearch` defaulted to `MODE=both`, tried to bind HTTP port 3000, crashed with EADDRINUSE. Fixed by adding `MODE=stdio` and `DEFAULT_SEARCH_ENGINE=duckduckgo` in all 5 configs.
- OpenCode's `opencode.jsonc` had a stale config (no env vars for open-websearch). Fixed.

## Related

- Free coding agent alternatives researched (Crab Code, SideCar, gocode, Codeep, Coddy, Claurst, free-code) — all BYOK, zero markup.
- Antigravity 2.0 announced at Google I/O 2026 with CLI + SDK. Still keeping all 5 agents.
- See `knowledge/rules/agent/mcp-config-single-source-of-truth.md` for the enforceable rule.
