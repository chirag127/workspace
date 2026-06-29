# Per-agent stub: Antigravity

> **Read [`../../AGENTS.md`](../../AGENTS.md) first.** That file is the workspace source of truth. This file has Antigravity-specific overrides and environment notes.

Antigravity is Google's agent-first development platform. As of Google I/O 2026 (May), it ships three surfaces:

- **Antigravity IDE** (2.0) — standalone desktop app with Editor (synchronous IDE) + Manager (async agent orchestration)
- **Antigravity CLI** — terminal-native agent, lightweight alternative to Gemini CLI
- **Antigravity SDK** — programmatic harness for building custom agents

## Antigravity-specific notes

- **Free public preview** with personal Gmail account. No card-on-file required.
- **Models:** Gemini 3 Pro/Flash via Google account (free tier). Can add Anthropic/OpenAI BYOK.
- **Windows path:** `C:\Users\C5420321\AppData\Local\Google\Antigravity\`
- **Config directory:** `%APPDATA%\Google\Antigravity\`

## Install

```bash
# IDE: download from https://antigravity.google.com/download
# CLI: antigravity auth login (links Google account)
```

## MCP servers

Antigravity reads MCP config from `.antigravity/mcp.json`. This file is synced from `.mcp.json` (single source of truth) via:

```bash
node scripts/sync-mcp-configs.mjs
```

Run this after any change to `.mcp.json` to keep all agents in sync.

## Free coding agent alternatives (research, June 2026)

If you need a Claude Code alternative with free API or easy MCP setup:

| Agent | License | Runtime | MCP | Free tier | Model support |
|---|---|---|---|---|---|
| **Crab Code** | Apache 2.0 | Rust | stdio/SSE/WS | BYOK | Any provider |
| **free-code** | MIT | Bun | LSP | 50K tokens/day | Qwen, BYOK |
| **SideCar** | MIT | VS Code ext | stdio/HTTP/SSE | BYOK + local | Any + Ollama |
| **gocode** | Apache 2.0 | Go | client+server | BYOK | 200+ models |
| **Codeep** | Apache 2.0 | Node | marketplace | BYOK | Any provider |
| **Coddy** | Apache 2.0 | Go | merge configs | BYOK | Any provider |
| **Claurst** | Apache 2.0 | Rust | ACP | BYOK + free mode | Any provider |

All support BYOK (bring your own API key) with zero markup — you pay your provider directly.

## Overrides

(none yet)
