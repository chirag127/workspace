---
type: rule
title: 'Web search — 3-MCP fallback chain (10 engines, no keys)'
description: searxng + duckduckgo + open-websearch. 10 engines, no API key. Try in order on failure
tags: [mcp, search, fallback, no-card, no-key]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/try-multiple-on-failure
  - rules/agent/dont-dup-smithery-tools
---

# Web search — 3-MCP fallback chain

## Rule

Three no-key web-search MCPs always installed at user scope. Try them in priority order:

| Priority | MCP | Engines | Notes |
|---|---|---|---|
| 1 | **searxng** | Google + Bing + Wikipedia (meta) | Best aggregate quality |
| 2 | **open-websearch** | Bing, Baidu, DuckDuckGo, Brave, Exa, GitHub, Juejin, CSDN | 8 engines, AUTO routing |
| 3 | **duckduckgo** | DuckDuckGo direct | Simplest fallback |

Total engine coverage: **10 distinct engines** across the 3 MCPs. All free. All zero-API-key. No card-on-file.

## Skipped (require API key)

- **Brave Search MCP** (free 2k/mo) — duplicate, no-key open-websearch covers Brave
- **Tavily** (free 1k/mo) — no-key alternatives exist
- **Exa** ($10 free credit) — open-websearch covers Exa
- **Kagi** (paid + card) — violates no-card-on-file

Revisit if all 3 no-key MCPs fail simultaneously on a query.

## How to apply

When you need web search:
1. Try searxng tool first
2. On failure (rate-limit, 403, 5xx, empty results) ? open-websearch
3. On second failure ? duckduckgo
4. Only escalate (ask user / add new MCP) if all 3 fail consistently

Per `try-multiple-on-failure` — at least 3 alts before reporting blocker. This rule MAKES that achievable in one click.
