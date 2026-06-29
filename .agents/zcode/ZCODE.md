# Per-agent overrides — ZCode

> **Read [`../../AGENTS.md`](../../AGENTS.md) first.** That file is the workspace source of truth.
>
> **Also read [`../../ZCODE.md`](../../ZCODE.md)** for MCP setup, skills wiring, and the provider chain.

ZCode reads workspace `AGENTS.md` natively (no wrapper needed). This stub adds **ZCode-only** context on top of the universal set.

## ZCode-specific notes

- ZCode operates as a full GUI ADE — it wraps Claude Code, Gemini CLI, Codex, and OpenCode as sub-agents. The ZCode Agent itself uses GLM-5.2 by default.
- `CLAUDE.md` is used by ZCode only during onboarding (one-time migration). All ongoing rules live in `AGENTS.md`.
- MCP servers are configured via GUI (Settings → MCP Servers), not `.mcp.json`. See [`knowledge/runbooks/hosting/zcode-mcp-setup.md`](../../knowledge/runbooks/hosting/zcode-mcp-setup.md).
- Custom agents live in `.zcode/agents/` and are loaded automatically by ZCode when the workspace is opened.
- Custom commands live in `.zcode/commands/` and are available via `/` in the ZCode chat input.
- Skills are at `~/.zcode/skills/` (user-global junction to `repos/own/infra/agent-skills/`). Available via `$` in the ZCode chat input.
- Execution mode default: **Default Mode**. Switch to Plan Mode for complex multi-file changes; Full Access for clear low-risk tasks.
