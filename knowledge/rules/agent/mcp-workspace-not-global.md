---
type: rule
title: 'MCP servers go in repo .mcp.json, NOT global ~/.claude.json'
description: Workspace-scoped MCP belongs in the committed .mcp.json. Don't add to ~/.claude.json (per-project or global). Forks/clones get the same MCPs automatically. No machine-specific paths.
tags: [mcp, scope, workspace-only, hard-rule, never-reask]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/workspace-scoped-agents
  - rules/agent/mcp-no-key-in-repo-keyed-in-smithery
  - rules/agent/serena-mcp-installed
---

# MCP scope: repo .mcp.json only

## Rule

When adding any MCP server for use in this workspace:

- ✅ Add to `c:/D/oriz/.mcp.json` (committed to git, travels with the repo).
- ❌ Do NOT use `claude mcp add` (writes to `~/.claude.json` per-project).
- ❌ Do NOT add to `~/.claude.json` global `mcpServers`.
- ❌ Do NOT hard-code absolute paths like `c:/D/oriz` — use `.` so any clone path works.

## Why

1. **Reproducible across machines**: clone the repo, MCPs come with it.
2. **No global pollution**: `~/.claude.json` stays minimal.
3. **Same rules as for AGENTS.md**: workspace-scoped configuration only.
4. **Visible in git**: anyone reviewing the repo sees which MCPs are wired.

## When to deviate

NEVER, for workspace MCP servers. The only exceptions:

- MCP servers that need user-specific credentials (smithery, github auth) —
  those live in `~/.claude.json` AND/OR Smithery vault per `mcp-no-key-in-repo-keyed-in-smithery`.
- MCP servers that span all workspaces (rare; would be a true global tool).

## Migration

If `claude mcp add` was used and the MCP landed in `~/.claude.json`:

```bash
# Find the project key
node -e "const j=require('os').homedir()+'/.claude.json'; const o=JSON.parse(require('fs').readFileSync(j)); console.log(Object.keys(o.projects).filter(k=>k.toLowerCase().includes('oriz')))"

# Delete it from ~/.claude.json, add to .mcp.json instead
node -e "
const fs=require('fs'); const p=require('os').homedir()+'/.claude.json';
const j=JSON.parse(fs.readFileSync(p));
delete j.projects['C:/d/oriz'].mcpServers['<server-name>'];
fs.writeFileSync(p, JSON.stringify(j, null, 2));
"

# Then add to .mcp.json + commit
```

## Cross-refs

- `workspace-scoped-agents` — same principle for agents (Claude Code, OpenCode, Cline, Kilo Code)
- `mcp-no-key-in-repo-keyed-in-smithery` — secrets go to Smithery, not repo
- `serena-mcp-installed` — concrete example of this rule applied
