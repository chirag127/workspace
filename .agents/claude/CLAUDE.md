# Per-agent rules — Claude Code

> **Read [`../../AGENTS.md`](../../AGENTS.md) first.** That file is the workspace source of truth and auto-imports the universal rules.
>
> **Also read [`../../CLAUDE.md`](../../CLAUDE.md)** for the Hr proxy chain and MCP-server pointers.

This stub adds **Claude-Code-only** rules on top of the universal set. Other agents (OpenCode, Cline, Kilo, Antigravity) do NOT load these — they name Claude-Code-specific tools (`WebFetch`, `WebSearch`, `TaskCreate`, `AskUserQuestion`) and Claude-Code-specific skills (`/code-review`, `/grill-me`).

@rules/never-use-native-web-tools.md
@rules/claude-code-skill-triggers.md
@rules/claude-code-latency-techniques.md
