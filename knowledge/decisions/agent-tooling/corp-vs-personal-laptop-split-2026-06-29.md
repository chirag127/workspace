---
type: decision
title: "Corp laptop vs personal laptop split (2026-06-29)"
description: CC + Bedrock corp-only. Personal on free providers. No-card blocks CC paid on personal
tags: [agent-tooling, fleet, claude-code, personal-laptop, corp-laptop, free-providers]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - decisions/agent-tooling/fleet-cut-to-4-agents-2026-06-29
  - decisions/agent-tooling/headroom-always-on-proxy-2026-06-26
  - rules/interaction/no-card-on-file
  - rules/agent/agent-fleet-parity
---

# Corp laptop vs personal laptop split

The 4-agent fleet runs on **two different physical machines** with **different cost profiles**. Same workspace, different agents active.

## Split

| Resource | Corp laptop | Personal laptop |
|---|---|---|
| Claude Code | ? Primary | ? Never (paid only — $20/mo Pro; violates [`no-card-on-file`](../../../rules/interaction/no-card-on-file.md)) |
| OpenCode | ? Secondary | ? Primary |
| Kilo Code (VS Code) | ? | ? |
| Antigravity IDE | ? | ? Primary |
| Hr proxy (`:8787`) | ? — chains to hai `:6655` ? Bedrock | ? — no Bedrock here, no Hr |
| hai (`:6655`) | ? SAP corp routing | ? |
| RTK (Rust Token Killer) | ? | ? — local Rust binary, provider-agnostic |
| Bedrock (Claude via SAP) | ? corp-paid | ? |
| OpenRouter free | — | ? Primary provider |
| Z.ai free tier | — | ? GLM-4.5-air, GLM-4.6 |
| Google AI Studio | — | ? Gemini 2.0/2.5 free with rate limits |
| Antigravity Google free tier | — | ? 1000 reqs/day, free Google account |

## Why CC is corp-only forever

Searched 2026-06-29 (https://claude.com/pricing, https://howdoiuseai.com/blog/2026-04-16-claude-code-pricing-2026):

1. **Claude Code has no free tier.** The Anthropic free Claude plan grants chat access only — Claude Code requires Pro ($20/mo), Max 5× ($100/mo), Max 20× ($200/mo), or API credits.
2. **April 22 2026 confirmation:** Anthropic ran a 2% experiment removing CC from Pro; reversed it. CC permanently gated to paid.
3. **No promotional trial.** No 14-day Pro trial, no time-limited access. Pricing is binary: free chat or paid CC.
4. **Your hard rule:** [`no-card-on-file`](../../../rules/interaction/no-card-on-file.md) — killed CF R2, Vercel Pro, Auth0 Pro, Clerk Pro, Firebase Blaze, Twilio. CC Pro fails the same gate.

Bedrock access exists only via the corp Hr?hai chain (`localhost:8787` ? SAP corp routing ? AWS Bedrock). That chain doesn't exist on personal laptop. So Bedrock-mediated CC is also corp-only.

## Personal laptop free stack (confirmed 2026-06-29)

Per [2026-06-23 dev.to coding-CLI map](https://dev.to/soulentheo/coding-clis-in-mid-2026-the-engineers-map-and-what-changed-in-30-days-23p4) + [2026-05-15 morphllm.com comparison](https://morphllm.com/comparisons/kilo-code-vs-opencode):

| Agent | Tier | Notes |
|---|---|---|
| **Antigravity CLI** (Google) | Free 1000 reqs/day | Replaces Gemini CLI as of May 19 2026 I/O. Gemini CLI sunsets June 18 2026. |
| **OpenCode** | Free OSS | 172K stars, surpassed CC. opencode/big-pickle as default. |
| **Kilo Code** (VS Code ext) | Free | Replaces Roo Code (archived May 2026). Configurable provider. |
| **Cline** | Free OSS | Dropped from fleet 2026-06-29 — overlaps Kilo. Listed for completeness. |

Free providers usable from any of the above:

- **OpenRouter** — ~50 free-tier models (`google/gemini-2.0-flash:free`, `meta-llama/llama-3.3:free`, `qwen/qwen3:free`, etc.). One OAuth, no card.
- **Z.ai coding plan free tier** — `glm-4.5-air`, `glm-4.6`, lightweight 4.x variants.
- **Google AI Studio** — Gemini 2.0/2.5 direct, free tier with rate limits, one Google account.

## Implications for fleet parity

The [`agent-fleet-parity`](../../../rules/agent/agent-fleet-parity.md) rule says "every agent sees same workspace rules, same MCP servers, same skills." That parity holds **per machine**:

- **Corp laptop:** all 4 agents share `.mcp.json` + `~/.claude/CLAUDE.md` + skills.
- **Personal laptop:** 3 agents (OpenCode + Kilo + Antigravity) share same `.mcp.json` + skills. CC absent.

The mirror repos serve both audiences:

- [`chirag127/claude-code-config`](https://github.com/chirag127/claude-code-config) — **corp-only showcase**. Marked as such in README.
- [`chirag127/opencode-config`](https://github.com/chirag127/opencode-config) — runs on both.
- [`chirag127/kilocode-config`](https://github.com/chirag127/kilocode-config) — runs on both.
- [`chirag127/antigravity-config`](https://github.com/chirag127/antigravity-config) — runs on both, **personal-laptop primary**.

## What does NOT apply on personal laptop

- Hr proxy chain (`ANTHROPIC_BASE_URL=http://127.0.0.1:8787`)
- hai corp routing
- `CLAUDE_CODE_USE_POWERSHELL_TOOL` env var
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` env var
- The `claude-api` Claude-Code skill triggers
- All `~/.claude/` global settings (CC isn't installed)
- Speed-stack Headroom layer (provider-agnostic in principle, but no current need without CC)

RTK (Rust Token Killer) **does** apply on personal laptop — it's a local Rust binary that wraps any shell command, provider-agnostic. Install via `C:\D\oriz\scripts\install-speed-stack.cmd` works on both machines.

## Sync workflow per machine

Both machines clone the same workspace (`chirag127/workspace`). After clone:

```bash
# corp laptop
node scripts/sync-globals.mjs       # writes ~/.claude/, ~/.opencode/, ~/.kilocode/

# personal laptop
node scripts/sync-globals.mjs       # writes ~/.opencode/, ~/.kilocode/ only (no ~/.claude/)
```

The sync script must detect Claude Code presence (e.g. `which claude` or `command -v claude`) and skip CC-specific writes on personal. Future enhancement — TODO logged.

## Cross-refs

- [`fleet-cut-to-4-agents-2026-06-29`](./fleet-cut-to-4-agents-2026-06-29.md) — drop Cline.
- [`headroom-always-on-proxy-2026-06-26`](./headroom-always-on-proxy-2026-06-26.md) — Hr chain (corp-only context now explicit).
- [`no-card-on-file`](../../../rules/interaction/no-card-on-file.md) — the rule that makes this permanent.
