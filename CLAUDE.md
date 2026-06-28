@AGENTS.md
@.agents/claude/CLAUDE.md

# Claude Code environment (this file only — rules live in AGENTS.md + knowledge/ + .agents/claude/)

- **Hr chain:** Claude Code → `localhost:8787` (Headroom, input compression) → `localhost:6655` (hai, SAP corp routing) → Bedrock. Hr down = Claude down. Single config in `~/.claude/settings.json`. Decision: [`knowledge/decisions/architecture/agent-tooling/headroom-always-on-proxy-2026-06-26.md`](./knowledge/decisions/architecture/agent-tooling/headroom-always-on-proxy-2026-06-26.md).
- **MCP servers:** workspace in `.mcp.json` (committed), user-credential in `~/.claude.json` global. Add workspace MCP via `claude mcp add <name> -s project -- <cmd> <args...>` — never use default `-s local` for workspace tools.
- **Serena** wired in `.mcp.json` with `--project .`; indexes the umbrella on first prompt.
- **OmniRoute** at port `20128` is eval-only. Never set as `ANTHROPIC_BASE_URL`.
