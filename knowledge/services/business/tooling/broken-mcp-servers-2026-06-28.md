---
type: reference
title: 'Broken / unreliable MCP servers — skip list'
description: MCP servers that failed during 2026-06-28 testing; skip list, re-evaluate quarterly
tags: [mcp, blocklist, web-tools, reference, services]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - .agents/claude/rules/never-use-native-web-tools
  - core-concepts/token-compression-techniques-2026-06-28
---

# Broken / unreliable MCP servers — skip list

Tested 2026-06-28 during compression-research session. Each MCP listed below failed in some way. **Do NOT add these to `.mcp.json`, `~/.claude.json`, `.agents/*/mcp.json`, or any other config without re-testing first.**

## Removed from Smithery toolbox 2026-06-28

These 3 were uninstalled from the `chirag127` Smithery toolbox via `smithery mcp remove`. They will not appear in agent tool lists anymore. **Do not re-add** without verifying the underlying issue is resolved.

| MCP | Why removed | Re-add condition |
|---|---|---|
| `exa` (Exa Search) | Free-tier exhausted; needs paid API key. Violates no-card-on-file rule. | Only if user funds a paid Exa key |
| `ghostrouter-ghostrouter-web` | Crypto micropayment paywall (USDC per call). Hard veto. | Never re-add |
| `pinkpixel-dev-web-scout-mcp` (Web Scout / DDG) | Returns empty results consistently for valid queries that worked on other engines. | Test 5 queries return non-empty; if all pass, re-add |

Re-add via: `smithery mcp add <name>` after verifying.

## Web search MCPs — broken / conditional (still in toolbox)

| MCP | Failure mode | Verdict | Re-eval condition |
|---|---|---|---|
| `mcp__chirag127__tavily_*` | "Connection not found: tavily" until ToolSearch loaded schemas; even then rate-limited on first call | **Conditional** — works after ToolSearch load + once-per-day rate window | Try after 24h cooldown |
| `mcp__chirag127__brave_brave_web_search` | "Connection not found: brave" — same ToolSearch pattern | **Conditional** — works after ToolSearch | Try after 24h |

## Web search MCPs — working

| MCP | Notes |
|---|---|
| `mcp__chirag127__keenable-web-search_search_web_pages` | **Default.** Returned 9-10 quality hits per query; filters by date; arxiv + blog mix |
| `mcp__chirag127__linkupplatform-linkup-mcp-server_linkup-search` | Deep search worked; returns 97KB+ payloads with full content from multiple sources |
| `mcp__chirag127__oevortex-ddg-search_web-search` | Returned 8 hits cleanly; fast |
| `mcp__searxng__searxng_web_search` | Failed earlier with JSON-parse error but reportedly works; retry |
| `mcp__fetch__fetch` | Reliable for single-URL markdown extraction |
| `mcp__chirag127__parallel-search_web_search_preview` | Untested this session — try next |
| `mcp__chirag127__axel-belfort-web-search_web_search_query` | Untested |
| `mcp__chirag127__apify_apify--rag-web-browser` | Untested |
| `mcp__chirag127__ref-tools-ref-tools-mcp_ref_search_documentation` | Docs search — different role, not generic web |

## Security flags — working but with known vulnerabilities

| MCP | CVE / Advisory | Risk | Mitigation |
|---|---|---|---|
| `open-websearch` (npm pkg in `~/.claude.json`) | [CVE-2026-42260](https://cvefeed.io/vuln/detail/CVE-2026-42260) — SSRF | Bracketed IPv6 literals + non-resolving hostnames bypass `isPrivateOrLocalHostname` check in `fetchWebContent` tool. SSRF non-blind (response streamed to MCP caller). | Kept active per user decision 2026-06-28. **Don't use it on untrusted URLs.** Patch when upstream releases fix. Check `npm view open-websearch versions` quarterly. |

## Order to try web search (fastest to most-thorough)

1. `mcp__chirag127__keenable-web-search_search_web_pages` — default
2. `mcp__chirag127__oevortex-ddg-search_web-search` — fast fallback
3. `mcp__chirag127__linkupplatform-linkup-mcp-server_linkup-search` (depth: deep) — when need comprehensive
4. `mcp__fetch__fetch` — when you have a specific URL
5. Retry tavily / brave after a ToolSearch load + 24h cooldown

## Other broken / abandoned MCPs noted

| MCP | Issue |
|---|---|
| `DesignSync` | Disconnected mid-session (system-reminder confirmed) — server died |

## Re-evaluation cadence

Test quarterly:
1. Try the conditionally-broken ones (tavily, brave, exa) with fresh API keys
2. Try pinkpixel-ddg to see if results came back
3. Try searxng with a fresh JSON-parse retry

If any becomes reliable for 5+ test queries, remove from this list and add to the working set in `.agents/claude/rules/never-use-native-web-tools.md`.
