---
type: rule
title: "MCP no-key in repo, keyed in Smithery"
description: "No-API-key MCP servers are committed to this repo as configurable entries. Keyed/auth MCP servers go into Smithery toolbox (chirag127) via Smithery CLI."
tags: [mcp, smithery, api-keys, security, tool-config]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
---

# MCP no-key in repo, keyed in Smithery

## Rule

- **No-API-key MCP servers** → committed to this repo as `claude mcp add` config entries in `scripts/` or `.claude.json` snippets
- **Keyed/auth MCP servers** → installed via Smithery CLI (`npx @smithery/cli install <server>`) into the `chirag127` toolbox (Smithery-hosted, not committed)
- **Never** commit API keys, tokens, or env secrets into any repo file

## Rationale

- This repo is public (oriz-org/workspace)
- `.env` is gitignored — only `.env.example` with documentation blocks is committed
- Smithery handles authentication server-side; keys stay in Smithery's vault
- When cloning fresh: `git clone` gets all no-key MCPs + instructions; keyed MCPs need Smithery login

## Current no-key MCPs in repo config

| MCP | Type | Source |
|-----|------|--------|
| searxng | Web search | npx mcp-searxng (baresearch.org) |
| duckduckgo | Web search | npx duckduckgo-mcp-server |
| open-websearch | Web search (8 engines) | npx open-websearch |
| playwright | Browser automation | npx @playwright/mcp |
| fetch | URL fetch | uvx mcp-server-fetch |
| github | GitHub API | Docker (uses GITHUB_PERSONAL_ACCESS_TOKEN from .env) |

## Keyed MCPs in Smithery toolbox

These live in the chirag127 Smithery endpoint, NOT in repo config.
Install via: `npx @smithery/cli install <server> --client claude`