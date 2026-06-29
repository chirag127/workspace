@AGENTS.md
@.agents/antigravity/AGENTS.md

# Antigravity environment (this file only — rules live in AGENTS.md + knowledge/ + .agents/antigravity/)

- **Platform:** Google Antigravity (IDE 2.0, CLI, SDK) - agent-first development environment.
- **Models:** Gemini 3 Pro/Flash via Google Account (free public preview, zero card-on-file required).
- **MCP servers:** Reads configuration from `.antigravity/mcp.json`. This is generated from the workspace-wide single source of truth `.mcp.json` via:
  ```bash
  node scripts/sync-mcp-configs.mjs
  ```
- **Configuration:** Local user settings and workspace state are maintained under `%APPDATA%\Google\Antigravity\`.
- **Serena Integration:** Serena is wired in `.mcp.json` with `--project .` to index symbol-level codebase intelligence.
