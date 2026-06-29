---
type: rule
title: 'Don't install MCP tools already bundled in Smithery toolbox'
description: chirag127 Smithery = meta-toolbox. Check before adding separate MCP server
tags: [mcp, smithery, deduplication]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - agent-rules/try-multiple-on-failure
---

# Don't dup MCP tools already in Smithery toolbox

## Rule

The `chirag127` Smithery endpoint (`https://mcp.smithery.run/chirag127`) is a meta-toolbox routing to many bundled MCPs. Before installing a NEW standalone MCP server, verify it isn't already exposed through Smithery.

## How to apply

1. Need a tool? First call `mcp__chirag127__*` tools — check if Smithery already routes to it
2. Not found in Smithery ? add standalone via `claude mcp add ...`
3. Standalone added ? consider whether to remove from Smithery to avoid dual-routing

## Currently registered standalone (don't re-add via Smithery):

- `searxng` — web search via mcp-searxng (npx)
- `filesystem`, `memory`, `sequential-thinking` — official MCP servers
- `context7` — @upstash/context7-mcp
- `playwright` — @playwright/mcp
- `fetch`, `time`, `git`, `github` — uvx / Docker
- `claude-code-guide` — built-in

## Why

Dual-routing same tool = 2× context cost when the AI agent loads tool schemas, plus ambiguity about which copy gets called. Smithery toolbox is the catalog; standalone is for tools the toolbox doesn't reach.
