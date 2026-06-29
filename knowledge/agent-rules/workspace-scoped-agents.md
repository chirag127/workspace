---
type: rule
title: '5-agent workspace setup: the AI agent, OpenCode, Cline, Kilo Code, Antigravity'
description: Workspace supports exactly 5 agents. All config inside C:\D\oriz\. Never touch global files
tags: [agents, claude-code, opencode, kilocode, cline, antigravity, scope, hard-rule]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - agent-rules/automate-never-runbook
  - rules/development/fork-discipline
---

# 5-agent workspace setup

## Scope

This workspace (`C:\D\oriz\`) supports **exactly 5** coding agents:

| Agent | Type | Cost | How it sees this workspace |
|---|---|---|---|
| the AI agent | CLI | Anthropic API (covered by SAP hai chain) | reads `C:\D\oriz\CLAUDE.md` + `C:\D\oriz\AGENTS.md` + `.mcp.json` |
| OpenCode | CLI | Free (BYOK) | reads `C:\D\oriz\AGENTS.md` + `.opencode/opencode.jsonc` |
| Cline | VS Code ext | Free (BYOK) | reads `C:\D\oriz\AGENTS.md` + `.vscode/mcp.json` |
| Kilo Code | VS Code ext | Free (provider markup-free) | reads `C:\D\oriz\.kilocode\rules\*.md` (symlinked to `.agents/kilocode/rules/`) + `.kilocode/mcp.json` |
| **Antigravity** | Standalone IDE (VS Code fork) | Free public preview as of 2026-05 | reads `C:\D\oriz\AGENTS.md` natively + `.antigravity/mcp.json` (when wired) |

Other agents (Codex, Crush, Gemini, Aider, Cursor) are NOT supported here. If user wants to add one later, write a new rule first.

## Why Antigravity is in the list

Added 2026-06-27 per user request. Antigravity is Google's agent-first IDE:
- Free public preview with personal Gmail account (no credit card, no waitlist) as of 2026-05.
- VS Code fork; runs on macOS, Linux, Windows.
- Agent-first: separate Editor view (synchronous IDE) and Manager view (agent workflows).
- Reads `AGENTS.md` natively (confirmed adopter of the agents.md open standard).
- Standalone IDE means installation is one-off; we don't run an installer for it.

## Workspace-local only — never touch globals

The installer `scripts/install-agents.cmd` ONLY touches:
- `C:\D\oriz\.agents\*` — per-agent stubs
- `C:\D\oriz\.kilocode\rules\` — symlink for Kilo Code
- `C:\D\oriz\.mcp.json` — the AI agent MCPs
- `C:\D\oriz\.opencode\opencode.jsonc` — OpenCode config + MCPs
- `C:\D\oriz\.vscode\mcp.json` — Cline MCPs
- `C:\D\oriz\.kilocode\mcp.json` — Kilo Code MCPs

It does NOT touch:
- `~/.claude/`, `~/AGENTS.md`, `~/.config/opencode/`, `~/.gemini/`, `~/.codex/`, `~/.config/antigravity/`

## Single source of truth

`C:\D\oriz\AGENTS.md` is read by 4 of 5 agents natively. The 5th (Kilo Code) gets there via a symlink. Per-agent overrides go in `.agents/<agent>/` only.

## Anti-patterns

- ? Add a 6th agent without writing a new rule first
- ? Edit `~/.claude/CLAUDE.md` from a workspace installer
- ? Copy rules from `AGENTS.md` into per-agent stubs (duplication = drift)
- ? Create a `<repo>/AGENTS.md` in any submodule's fork (per `fork-discipline`)
- ? Treat Antigravity as a 4-agent extension; it counts as its own slot
