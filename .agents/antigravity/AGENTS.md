# Per-agent stub: Antigravity

Antigravity is Google's agent-first IDE (VS Code fork). Reads `AGENTS.md` natively.

## Where this stub lives

`.agents/antigravity/AGENTS.md` (this file). Antigravity reads the workspace's root `AGENTS.md` directly when you open `C:\D\oriz\` as a project. This per-agent stub exists for symmetry with the other 4 agents and to hold Antigravity-specific overrides.

## Antigravity-specific notes

- Free public preview as of 2026-05 with personal Gmail account. No card-on-file required.
- Standalone IDE: install from https://antigravity.google.com/.
- Two views: **Editor** (synchronous AI-powered IDE) and **Manager** (agent workflows).
- Default model: Gemini 3 Flash via Google account. Bring your own Anthropic API key for Claude models.

## MCP servers

Antigravity reads MCP config from `.antigravity/mcp.json` when present. We DO NOT auto-create this file because Antigravity install is manual (one-off IDE install, not a CLI).

When you install Antigravity and want the workspace MCPs:

```bash
# Copy the same MCP config Claude Code uses
cp .mcp.json .antigravity/mcp.json
```

This keeps Antigravity in sync with the rest of the workspace.

## No overrides

(none yet)
