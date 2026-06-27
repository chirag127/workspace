---
type: rule
title: 'AI-coding speed stack: 2 installed layers + 2 inlined rules'
description: Installed - Headroom (chat/file compression) + RTK (shell-output compression). Inlined as workspace AGENTS.md rules - Ponytail (lazy-dev output) + Caveman (terse prose). OmniRoute / 9Router / NeuralMind explicitly skipped.
tags: [speed, tokens, compression, latency, claude-code, hard-rule]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/automate-never-runbook
  - rules/agent/fork-minimize-conflict-surface
  - rules/agent/workspace-scoped-agents
---

# Speed stack — installed layers + inlined rules

## What's installed

| Layer | Tool | Compresses |
|---|---|---|
| Input — chat/files | Headroom | File reads, long chat history (`:8787`, Hr→hai→Bedrock) |
| Input — shell | RTK (Rust Token Killer) | `git diff`, `npm install`, `ls -R` |

Install via `C:\D\oriz\scripts\install-speed-stack.cmd`.

## What's inlined (NOT installed)

Both live in `C:\D\oriz\AGENTS.md` as rule sections. All 4 agents (Claude/OpenCode/Kilo/Cline) pick them up by reading AGENTS.md at session start. Zero plugin install, zero global file writes.

| Discipline | Section in AGENTS.md | Source |
|---|---|---|
| Ponytail (lazy-senior-dev output ladder) | "Ponytail — lazy senior dev (output discipline)" | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| Caveman (terse-prose token compression) | "Caveman — terse prose (token compression)" | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) |

## Why inlined, not installed

- Plugin installs touch `~/.claude/settings.json` (global file). Workspace-scoped-agents rule forbids that.
- Rule-form composes freely with other AGENTS.md rules; plugin-form doesn't.
- Same outcome (terse output + lazy-dev discipline), zero install footprint.
- Works for all 4 supported agents, not just Claude Code.

## Explicitly skipped

- **OmniRoute / 9Router** — proxy/gateway replacements for `:8787`. Would break Hr→hai chain (SAP-mandated). Reconsidered 2026-06-27: OmniRoute is a router, not an LLM-API aggregator like freellmapi. Confirmed skip.
- **NeuralMind** — vaporware coming-soon landing as of 2026-06.

## Cross-refs

- `automate-never-runbook` — install via script, not manual list
- `workspace-scoped-agents` — workspace-only, no global edits
- `fork-minimize-conflict-surface` — speed tools live in agent infra
