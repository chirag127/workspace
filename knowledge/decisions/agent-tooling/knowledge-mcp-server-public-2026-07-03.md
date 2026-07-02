---
type: decision
title: Public knowledge MCP server — chirag127-knowledge-mcp
description: MCP server exposing knowledge/ OKF bundle over MCP; boone-backed; no auth; any AGENTS.md-reader can wire and query.
tags: [mcp, okf, knowledge, public]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: medium
durability: durable
related:
  - decisions/agent-tooling/cloud-publish-knowledge-2026-07-03
  - decisions/agent-tooling/boone-as-okf-search-2026-07-03
  - rules/development/mcp-repo-naming-suffix
  - decisions/architecture/security/no-auth-in-apps-or-apis-2026-06-25
---

# Public knowledge MCP server

## Decision

Ship `chirag127/knowledge-mcp` (per `mcp-repo-naming-suffix`). Public MCP server. Exposes `knowledge/` OKF bundle for external agents to query over MCP.

Tools exposed:
- `search(query, limit=3)` — BM25 via boone.
- `read(path)` — single concept file content.
- `list(type, tag)` — filter concept files.
- `related(path)` — graph neighbors.

No auth. Public. Per `no-auth-in-apps-or-apis`.

## Why an MCP server (not just the static site)

- **Agent-native** — MCP is the protocol AI agents already speak. Static site requires HTTP fetch + parse.
- **Structured queries** — `list(type='rule', tag='cloud')` cleaner than crawling markdown.
- **Ecosystem contribution** — one of first public OKF-MCP servers.

## Deployment

- **Runtime:** CF Worker (per `cloudflare-workers`). Zero cold start, free tier.
- **Storage:** OKF files bundled into Worker at build time (small — ~5 MB total).
- **Index:** boone index generated at build, shipped with Worker.
- **Endpoint:** `https://knowledge-mcp.oriz.in` OR `wss://knowledge-mcp.oriz.in`.

## Security

- **Rate limit** — per-IP burst limit at edge. Prevents abuse.
- **Read-only** — no write tools exposed. Static bundle in Worker.
- **Public data only** — knowledge/ already public via git. No new exposure.

## Anti-patterns

- ❌ Write tools — makes it a service, not a knowledge source.
- ❌ Auth — violates no-auth rule and MCP-server-should-be-frictionless taste.
- ❌ Deploy on paid tier — must stay CF Workers free per `no-card-on-file`.

## Cross-refs

- [`cloud-publish-knowledge-2026-07-03`](./cloud-publish-knowledge-2026-07-03.md)
- [`boone-as-okf-search-2026-07-03`](./boone-as-okf-search-2026-07-03.md)
- [`mcp-repo-naming-suffix`](../../rules/development/mcp-repo-naming-suffix.md)
