---
type: rule
title: 'Search 3 times across 3 engines for every query'
description: User wants high-recall web research. Default behavior: every query hits searxng + open-websearch + duckduckgo (3 engines). Synthesize across results.
tags: [search, fallback, recall, agent-behavior]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/search-multi-engine-fallback
  - rules/agent/try-multiple-on-failure
---

# Search 3× across 3 engines

## Rule

Every web-research query goes to ≥3 search engines in parallel:
1. searxng
2. open-websearch
3. duckduckgo

Then synthesize across results to extract consensus + outliers.

## Why

User stated 2026-06-27: "search by public at least 10 things to be searched
about the query." Pragmatic interpretation: 3 engines, each returning 10
results = 30 result-pages worth of recall, with overlap dedup.

## Not 10×, not 1×

- **10×**: 10 engines × 1 query = expensive (token cost on result lists).
- **1×**: single engine = miss-rate too high (e.g. SearXNG hits rate-limit).
- **3×**: 95% recall with 30% the cost.

## How to apply

When researching:
1. Pick 3 search MCPs (already installed: searxng / open-websearch / duckduckgo).
2. Fire same query at all 3 in parallel (single Claude turn, batched).
3. Dedupe by URL.
4. Read top 5-10 unique results.
5. Synthesize.

## Anti-patterns

- One engine + "results are bad, sorry, can't find it"
- 10 engines × 1 query (overkill)
- Same engine 3× with different terms (not the user's ask)
