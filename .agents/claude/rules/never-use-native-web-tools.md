---
type: rule
title: 'Never use native web tools — only MCP-based web tools'
description: WebFetch and WebSearch (native Claude Code tools) are blocked from this point. Use MCP web tools only. See knowledge/services/broken-mcp-servers-2026-06-28.md for which are working vs broken.
tags: [web, fetch, search, agent-behavior, hard-rule, feedback]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - rules/agent/preferences/edit-mode-prefs
  - services/broken-mcp-servers-2026-06-28
---

# Never use native web tools — only MCP-based

## The rule

Do NOT call:
- `WebFetch`
- `WebSearch`

Use MCP web tools instead. If a tool returns "Connection not found" / schema-not-loaded, use `ToolSearch` to load schemas first, then retry. Don't fall back to native.

## Pick order (tested 2026-06-28)

| Need | Pick | Status |
|---|---|---|
| Default search | `mcp__chirag127__keenable-web-search_search_web_pages` | ✅ reliable |
| Fast fallback | `mcp__chirag127__oevortex-ddg-search_web-search` | ✅ reliable |
| Multi-source deep research | `mcp__chirag127__linkupplatform-linkup-mcp-server_linkup-search` (depth: deep) | ✅ reliable |
| Fetch single URL as markdown | `mcp__fetch__fetch` | ✅ reliable |
| Documentation search | `mcp__chirag127__ref-tools-ref-tools-mcp_ref_search_documentation` | untested this session |
| Library API/code docs | `mcp__chirag127__upstash-context7-mcp_query-docs` | untested |
| Web crawl whole site | `mcp__chirag127__tavily_tavily_crawl` or `mcp__crawl-md__crawl` | retry after ToolSearch |

## DO NOT USE (broken/paywalled)

See [`services/broken-mcp-servers-2026-06-28`](../../../knowledge/services/broken-mcp-servers-2026-06-28.md) for the canonical block-list. Quick summary:

- ❌ `mcp__chirag127__ghostrouter-*` — crypto micropayment paywall
- ❌ `mcp__chirag127__exa_*` — free-tier exhausted; needs paid key
- ❌ `mcp__chirag127__pinkpixel-dev-web-scout-mcp_DuckDuckGoWebSearch` — returns empty results
- ⚠ `mcp__chirag127__tavily_*` + `mcp__chirag127__brave_*` — conditional; need ToolSearch load + 24h between bursts
- ⚠ `mcp__searxng__searxng_web_search` — JSON-parse error sometimes; retry once

