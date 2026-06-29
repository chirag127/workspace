---
type: rule
title: "Loop engineering for AI agents"
description: AI agent loops across engines/tools with fan-out, fallback, self-correction. No infinite loops
tags: [loop, engineering, fallback, web-search, fan-out]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
---

# Loop engineering for AI agents

## Rule

When a task requires searching, crawling, or fetching — loop across engines with:
1. **Fan-out** — try ≥3 sources in parallel (searxng → open-websearch → duckduckgo → mcp-crawl)
2. **Fallback** — if engine 1 fails/empty, use engine 2 (then 3, 4...)
3. **Stop condition** — result found ∧ confidence ≥ threshold → stop loop
4. **Self-correction** — if result contradicts known facts, re-loop with corrected query
5. **No infinite loops** — max 3 attempts per query (hard cap)

## Search fallback chain (no keys needed)

1. `searxng` — baresearch.org (Google + Bing + Wikipedia meta)
2. `open-websearch` — Bing + Baidu + DuckDuckGo + Brave + Exa + GitHub + Juejin + CSDN (8 engines)
3. `duckduckgo` — DDG direct
4. `mcp-crawl` — @anthropic/mcp-crawl (crawl a URL + linked pages → markdown)
5. `fetch` — single-page URL fetch

## Web crawl chain (for docs)

1. `mcp-crawl` — crawl homepage + linked pages (up to 100 pages, no key)
2. `firecrawl-mcp` — needs API key → install in Smithery toolbox if available
3. `fetch` — single page fallback

## Rate limits

- searxng: 10 req/min (baresearch.org)
- duckduckgo: rate-limited (no hard cap)
- open-websearch: 30 req/min
- mcp-crawl: 20 pages/session

Max 30 sec per loop iteration. If all fail → report "unreachable" + suggestion.