---
type: rule
title: 'MCP servers — no-key in this repo, keyed in Smithery toolbox'
description: No-API-key MCPs go in committed .mcp.json. Keyed MCPs go in Smithery toolbox via @smithery/cli (handles credential storage). NEVER commit keys.
tags: [mcp, security, no-card, smithery, dont-dup-tools]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/dont-dup-smithery-tools
  - rules/agent/search-multi-engine-fallback
  - rules/interaction/no-card-on-file
---

# MCP installation: dual-bucket rule

## Rule

Two buckets for MCP servers, **never mixed**:

| Bucket | Where | Authentication | Persistence |
|---|---|---|---|
| **A — no-key** | `c:\D\oriz\.mcp.json` (committed) | none | git, survives clone |
| **B — keyed** | Smithery toolbox at `chirag127` endpoint | per-user via `@smithery/cli` | Smithery cloud |

## Why

- `.mcp.json` is committed to a PUBLIC repo. Tokens MUST NEVER be in it.
- Smithery handles per-user keyed credentials in its own vault — no leakage to repo or to other users who clone.
- Keeps the public repo cloneable / forkable without leaking auth.

## How to add a new MCP

```bash
# Step 1: does it need an API key?
# Check the upstream README. If yes → Smithery. If no → .mcp.json.

# A — no-key
# Edit .mcp.json, add an entry:
#   {"mcpServers": {"<name>": {"command": "npx", "args": ["-y", "<pkg>"]}}}
# Restart Claude Code. Verify with: claude mcp list

# B — keyed
npx -y @smithery/cli install <slug> --client claude
# Smithery CLI prompts for the API key, stores in its own vault,
# routes through your chirag127 toolbox endpoint.
```

## Discovery rules

1. **Check Smithery toolbox first** (per `dont-dup-smithery-tools`). If the MCP is already exposed via `mcp__chirag127__*`, don't re-add.
2. **Survey via web search MCPs** (per `search-multi-engine-fallback`) — smithery.ai, awesome-mcp-servers, npm.
3. **Smoke-test before commit** — `npx -y <pkg>` for 5s, confirm starts cleanly.

## Anti-patterns

- ❌ API key hardcoded in `.mcp.json` (public repo leak)
- ❌ Same MCP in BOTH .mcp.json AND Smithery toolbox (double-routing, 2x context cost)
- ❌ Standalone install of an MCP that's already bundled in Smithery toolbox
- ❌ `claude mcp add --scope user <name>` for an MCP that should be in this repo (won't survive clone elsewhere)

## Today's status (2026-06-27)

**`.mcp.json` (in-repo, committed)**: rebuilt by sibling agent — N no-key MCPs.

**Smithery toolbox (`chirag127`)**: routes hundreds of bundled tools on demand. Keyed MCPs added by user via `@smithery/cli` when needed.

**User-scope standalone (still ok per-user, not project)**: `playwright`, `fetch`, `github` (these 3 are infrastructure-critical and not naturally fit for `.mcp.json` — playwright needs browser binaries, github needs Docker socket).
