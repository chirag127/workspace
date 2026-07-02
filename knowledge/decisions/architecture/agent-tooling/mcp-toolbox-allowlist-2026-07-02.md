---
type: decision
title: MCP toolbox allowlist + audit 2026-07-02
description: Blessed MCP server allowlist grouped by purpose plus audit notes flagging duplicates, health-check candidates, and removal candidates.
tags: [mcp, tools, allowlist, agent-tooling]
timestamp: 2026-07-02
format_version: okf-v0.2
status: active
---

# MCP toolbox allowlist + audit — 2026-07-02

Two docs. First = blessed set. Second = audit reasoning behind cuts / holds.

---

## 1. BLESSED ALLOWLIST

Up to 15 servers. Grouped by purpose. Each row = server name, why blessed, primary tool to call.

### Web search

| Server | Why blessed | Primary tool |
|---|---|---|
| `searxng` | Meta-engine via baresearch.org. Self-hostable fallback. No API key. Broad coverage. | `mcp__searxng__searxng_web_search` |
| `open-websearch` | Multi-engine (DuckDuckGo, Bing, Baidu, Brave, etc.). No API key. Redundancy layer when SearXNG instance flakes. | `mcp__open-websearch__search` |
| `one-search-mcp` | Aggregated search + scrape + map in one server. `SEARCH_PROVIDER=local` = no external key. Covers URL discovery + scraping gaps other search servers miss. | `mcp__one-search-mcp__one_search` |

### Code / IDE

| Server | Why blessed | Primary tool |
|---|---|---|
| `serena` | Semantic code retrieval across umbrella. Wired to `--project .`. Language-server-backed symbol search — beats grep for cross-file refs. | (Serena IDE tools; project-scoped symbol lookup) |
| `codebase-memory` | Local knowledge graph. Complexity/loop-depth queries, call-graph tracing, Cypher over the code. No cloud calls. | `mcp__codebase-memory__search_graph` |

### Docs

| Server | Why blessed | Primary tool |
|---|---|---|
| `chirag127` (Smithery toolbox) | Aggregates Context7 + Ref + other doc servers behind one endpoint. Single MCP entry, N doc backends. Reduces `.mcp.json` bloat. | `mcp__chirag127__upstash-context7-mcp_query-docs` and `mcp__chirag127__ref-tools-ref-tools-mcp_ref_search_documentation` |

### Fetch

| Server | Why blessed | Primary tool |
|---|---|---|
| `fetch` | `uvx mcp-server-fetch`. Zero-config URL → markdown. First reach for any single-URL read. | `mcp__fetch__fetch` |
| `mcp-crawl` | Workspace-local crawler (BFS same-origin). No external service. For multi-page site pulls where `fetch` needs looping. | `mcp__mcp-crawl__crawl` |

### Memory / knowledge

| Server | Why blessed | Primary tool |
|---|---|---|
| `codebase-memory` | Already listed under Code. Dual-purpose: also holds ADRs via `manage_adr`. No separate memory server needed. | `mcp__codebase-memory__manage_adr` |

### Other

| Server | Why blessed | Primary tool |
|---|---|---|
| `resend` | Transactional email for oriz mail flows (`chirag@oriz.in`). API key gated. Only email MCP in inventory. | `mcp__resend__send-email` |
| `morph-mcp` | User-global. Fast semantic file edits (`edit_file`) + GitHub codebase search over external repos without cloning. Complements Edit tool for large-file / multi-edit cases. | `mcp__morph-mcp__edit_file` |

**Blessed count: 10.** Under the 15 cap. Room to add if a gap surfaces.

---

## 2. MCP AUDIT NOTES

Suggestions with reasoning. Not auto-removals — grill-me before deleting anything from `.mcp.json`.

### (a) Obvious duplicates — collapse web search

Four web-search servers in inventory: `searxng`, `open-websearch`, `one-search-mcp`, plus the many search backends inside `chirag127` (axel-belfort, keenable, linkup, oevortex-ddg, parallel-search, tetiai-pixserp).

**Recommended shape: keep 3 top-level + Smithery aggregator.**

| Server | Verdict | Reason |
|---|---|---|
| `searxng` | KEEP | Primary. Meta-engine + self-hostable path. |
| `open-websearch` | KEEP | Backup when SearXNG instance returns JSON-parse errors (see `.agents/claude/rules/never-use-native-web-tools.md`). |
| `one-search-mcp` | KEEP (probation) | Covers scrape+map. If overlap with `mcp-crawl` + `fetch` proves total after 30 days, drop. |
| `chirag127` search backends | KEEP but treat as tertiary | Only reach when top-3 fail. Aggregator saves per-server config cost. |

Duplicates inside `chirag127` (axel-belfort + keenable + parallel-search + tetiai-pixserp all do web search) → not our maintenance burden; Smithery owns the aggregation. Leave alone.

### (b) Health check before promotion

These are in `.mcp.json` but need a live probe before locking as blessed:

| Server | What to verify | Suggested test |
|---|---|---|
| `mcp-crawl` | Local script at `./scripts/crawl-mcp/server.js` — script exists and returns markdown | Run against `https://oriz.in/` seed, cap 5 pages |
| `screenpipe` | Requires `SCREENPIPE_API_KEY` + local Screenpipe agent installed | Confirm agent process running + key valid; if either missing → REMOVE |
| `one-search-mcp` | `SEARCH_PROVIDER=local` — verify no cloud calls | Run a search, packet-capture / check process network |
| `codebase-memory` | Fresh binary at `C:/Users/C5420321/AppData/Local/Programs/codebase-memory-mcp/` — confirm index built for umbrella | `mcp__codebase-memory__list_projects` should return the workspace |

### (c) Servers we probably don't need

| Server | Verdict | Reason |
|---|---|---|
| `screenpipe` | REMOVE unless daily-used | Screen-capture MCP. Not tied to any live oriz workflow. Adds startup cost + `SCREENPIPE_API_KEY` env dependency. If Screenpipe agent isn't installed on this laptop → dead entry. Grill-me first. |
| Duplicate `chirag127` under `projects["C:/d/oriz"].mcpServers` in `~/.claude.json` | REMOVE | Already present at workspace level in `.mcp.json`. Duplicate registration wastes tool schema slots. |
| Some `chirag127` sub-backends (axel-belfort, oevortex, keenable, tetiai) | HIDE (don't remove) | We only use 2-3. Rest inflate the tool list. If Smithery supports per-tool disable, disable unused. Otherwise leave — no local cost. |

### (d) Delta cleanup: `morph-mcp` placement

`morph-mcp` lives only in user-global `~/.claude.json`. Per [`mcp-config-single-source-of-truth`](../../rules/agent/mcp-config-single-source-of-truth.md), workspace `.mcp.json` is canonical. Two paths:

1. **Promote to workspace** — add to `.mcp.json` so Claude Code reads it natively. Preferred if `morph-mcp` is durable / not per-machine credential-tied.
2. **Keep user-global only** — if it's Claude-Code-specific credential-shape, document in `.agents/claude/CLAUDE.md`.

Recommend path 1: `edit_file` is durable. Grill-me before deciding — no auto-promote.

### (e) Servers to add later (gaps identified)

None right now. Current 10 blessed cover: search × 3, code × 2, docs × 1, fetch × 2, memory × 1 (dual-role), other × 2. Add on demand only, per [`no-global-config-without-grilling`](../../rules/agent/no-global-config-without-grilling.md).

---

## Cross-refs

- [`mcp-config-single-source-of-truth`](../../rules/agent/mcp-config-single-source-of-truth.md) — `.mcp.json` is canonical; sync via `scripts/sync-mcp-configs.mjs`.
- [`never-use-native-web-tools`](../../../.agents/claude/rules/never-use-native-web-tools.md) — MCP-only web tools; drives the search-server picks above.
- [`broken-mcp-servers-2026-06-28`](../../services/broken-mcp-servers-2026-06-28.md) — canonical block-list for MCP servers that fail live probes.
- [`agent-fleet-parity`](../../rules/agent/agent-fleet-parity.md) — parity is vacuous under CC-only fleet; kept for reintroduction path.