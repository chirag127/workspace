---
type: decision
title: 'Fleet cut to 4 agents: CC + OpenCode + Kilo Code + Antigravity'
description: 'Cline dropped 2026-06-29. Fleet 5 to 4. Failover: OpenCode to Kilo to Antigravity. Aider rejected'
tags: [agent, fleet, cline, opencode, kilocode, antigravity, claude-code, grill-decision]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
supersedes:
  - (the 5-agent fleet implicit in AGENTS.md prior to 2026-06-29)
related:
  - rules/agent/agent-fleet-parity
  - decisions/agent-tooling/nothing-global-rule-2026-06-29
---

# Fleet cut to 4 agents

## Decision

The wired-agent fleet is **4 agents**, no more:

1. **Claude Code** (CLI, primary daily-driver)
2. **OpenCode** (CLI, primary CLI failover)
3. **Kilo Code** (VS Code extension)
4. **Antigravity** (Google standalone IDE)

Failover order if Claude Code is unavailable: **OpenCode ? Kilo Code ? Antigravity**.

## What changed

- **Cline dropped.** Was 5th in the fleet. Reason: overlaps Kilo Code (both VS Code extensions, both MCP-native, both card-free). Keeping both meant 2 sync targets for the same workflow surface.
- **`.agents/cline/` removed** along with `cline` rows in AGENTS.md table and `sync-mcp-configs.mjs` target list.
- **`.vscode/mcp.json` kept** — that's VS Code-native MCP config, not Cline-specific. Kilo Code uses `.kilocode/mcp.json`.

## What's NOT in the fleet (live-search verified, 2026-06-29)

| Excluded | Live verdict | Reason |
|---|---|---|
| Cline | ? MCP-native, free | Overlaps Kilo Code |
| Aider | ? No native MCP (confirmed in mcp.directory matrix) | Can't pick up `.mcp.json` |
| Goose | ? MCP-native, Linux Foundation governed | Not currently needed; lazy-install if ever |
| Continue.dev | ? MCP-native, free | Not currently needed |
| Gemini CLI | ? Partial MCP (added 2026) | Not currently needed |
| Cursor / Windsurf | Card-on-file required | Violates [`no-card-on-file`](../../../rules/interaction/no-card-on-file.md) |
| Codex CLI | Repositioned | Out of scope |

The 60-agent registry from the `chirag127/skills` path table is **reference-only**; installation requires grilling.

## Sources (2026-06-29 live search)

- [pinggy.io: Best Open Source CLI Coding Agents in 2026](https://pinggy.io/blog/best_open_source_cli_coding_agents/) (2026-05-25)
- [mcp.directory: Goose vs Cline vs Aider vs Claude Code vs OpenCode (2026)](https://mcp.directory/blog/goose-vs-cline-vs-aider-vs-claude-code-vs-opencode-2026) (2026-05-11)
- [zbuild.io: Best Free AI Coding Tools in 2026](https://zbuild.io/resources/news/best-free-ai-coding-tools-2026) (2026-03-27)
- [codersera.com: AI Coding Agents in 2026: The Complete Guide](https://codersera.com/blog/ai-coding-agents-complete-guide-2026) (2026-05-01)

## Cross-refs

- [`agent-fleet-parity`](../../../rules/agent/agent-fleet-parity.md) — rule that mandates equal config across the 4
- [`nothing-global-rule-2026-06-29`](./nothing-global-rule-2026-06-29.md) — companion decision (workspace-only default)
