@AGENTS.md
@.agents/zcode/ZCODE.md

# ZCode environment (this file only — rules live in AGENTS.md + knowledge/ + .agents/zcode/)

- **Platform:** ZCode ADE (Agentic Development Environment) from Z.AI — GUI IDE with embedded Claude Code, Gemini CLI, Codex, and OpenCode agents.
- **Instructions:** ZCode reads workspace `AGENTS.md` natively. Global preferences live at `~/.zcode/AGENTS.md`. ZCode does NOT read `CLAUDE.md` continuously — only uses it as a one-time migration source during onboarding.
- **MCP servers:** Configured via ZCode GUI: Settings → MCP Servers. NOT via `.mcp.json`. See runbook: [`knowledge/runbooks/hosting/zcode-mcp-setup.md`](./knowledge/runbooks/hosting/zcode-mcp-setup.md).
- **Skills:** User-global at `~/.zcode/skills/` → `repos/own/infra/agent-skills/`. Run `node scripts/wire-agent-skills-junctions.mjs` to wire. Project-level skills NOT committed to workspace root per [`workspace-root-cleanliness`](./knowledge/rules/infrastructure/workspace-root-cleanliness.md).
- **Agents:** Project-level custom agents in `.zcode/agents/` (committed). Four agents: `security-reviewer`, `code-reviewer`, `docs-writer`, `plan-architect`.
- **Commands:** Reusable prompt templates in `.zcode/commands/` (committed). Four commands: `test`, `lint`, `build`, `deploy`.
- **Provider:** GLM-5.2 (ZCode native) or any BYOK provider via Settings → Model Providers.
