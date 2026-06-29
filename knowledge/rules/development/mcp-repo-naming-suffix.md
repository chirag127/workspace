---
type: rule
title: 'MCP server repo naming: <name>-mcp suffix'
description: "MCP repos use <name>-mcp suffix"
tags: [mcp, repo-naming, convention, suffix]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - rules/development/repo-naming
  - branding/repo-naming-drop-oriz-prefix-2026-06-25
  - agent-rules/agent-fleet-parity
---

# MCP server repo naming

## Rule

Own MCP server repos use the **`<name>-mcp`** suffix pattern.

- ✅ `fetch-mcp`, `searxng-mcp`, `codebase-memory-mcp`
- ❌ `mcp-fetch`, `mcp-server-fetch`, `oriz-mcp-fetch`

One MCP server = one repo. No monorepo for own servers.

## Why suffix, not prefix

Matches existing category-suffix convention across the fleet:

| Category | Example |
|---|---|
| Browser extension | `bookmark-mind-bs-ext` |
| VS Code extension | `sops-lens-vsc-ext` |
| Static API | `rto-api`, `dynasties-api` |
| Mobile/PWA | `oriz-janaushdhi-app` |
| Static book | `oriz-janaushdhi-book` |
| **MCP server (new)** | **`fetch-mcp`** |

The suffix makes `ls repos/own/` group naturally by category.

## When to create the repo

Per [ponytail](../agent/ponytail.md) and [`atomic-packages-lazy`](../agent/preferences/atomic-packages-lazy.md):

- Create the repo only when you start writing the MCP server code.
- Don't create stubs for the 3rd-party MCP servers you only consume.
- Reference: 6 servers currently in `.mcp.json` (fetch, searxng, open-websearch, mcp-crawl, serena, codebase-memory) — none are own code yet; all are 3rd-party.

## NPM publishing

If the MCP server is JS/TS and gets published:

- Package name: `@oriz/<name>-mcp` (scoped) or `<name>-mcp` (unscoped, if available).
- Binary name: `<name>-mcp` (matches repo name per [`user-prefers-same-name-repo-and-npm`](../interaction/user-prefers-same-name-repo-and-npm.md)).

## Cross-refs

- [`repo-naming`](./repo-naming.md) — general repo naming rule
- [`repo-naming-drop-oriz-prefix-2026-06-25`](../../branding/repo-naming-drop-oriz-prefix-2026-06-25.md) — drop-prefix decision this builds on
- [`atomic-packages-lazy`](../agent/preferences/atomic-packages-lazy.md) — when to extract a new package
