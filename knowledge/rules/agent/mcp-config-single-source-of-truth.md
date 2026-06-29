---
type: rule
title: "MCP config single source of truth"
description: .mcp.json canonical MCP config. All 5 agents sync via scripts/sync-mcp-configs.mjs. Never edit per-agent configs
tags: [mcp, config, agents, sync, infrastructure]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - infrastructure/mcp-config-sync-2026-06-29
---

# MCP config single source of truth

## The rule

`.mcp.json` at workspace root is the **single canonical MCP server configuration**. Every agent-specific MCP file is a derived copy.

## What this means

1. **Edit `.mcp.json` only** — never modify `.kilocode/mcp.json`, `.vscode/mcp.json`, `.antigravity/mcp.json`, or `.opencode/opencode.jsonc` directly.
2. **Run the sync script** after every `.mcp.json` change:
   ```bash
   node scripts/sync-mcp-configs.mjs
   ```
3. **The sync script** copies to 4 agents with identical format (`.kilocode/`, `.vscode/`, `.antigravity/`) and transforms to OpenCode's JSONC format (`.opencode/opencode.jsonc`).

## Rationale

Previously, each of the 5 agents (Claude Code, OpenCode, Kilo Code, Cline, Antigravity) maintained its own copy of the MCP server definitions. Adding a new server or fixing a config required editing 5 files — error-prone and inconsistent.

## Exceptions

- **User-credential servers** (API keys, OAuth tokens) go in the agent's global config (`~/.claude.json`, `~/.opencode/config.json`), never in the workspace `.mcp.json`.
- **Agent-specific MCP servers** (e.g. a server only one agent supports) can be added to the per-agent file, but must be documented in the per-agent stub with a note that it's not synced.

## Related

- The sync script: `scripts/sync-mcp-configs.mjs`
- The grill decision that locked this: `knowledge/infrastructure/mcp-config-sync-2026-06-29.md`
