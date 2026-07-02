---
type: rule
title: "Own the memory, rent the intelligence"
description: "Memory + skills + orchestration are portable and belong to you. Intelligence (frontier models) is rented — swap providers freely. Never couple your knowledge to one vendor's tool."
tags: [agent, memory, skills, portability, strategy, karpathy]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/agent-fleet-parity
  - rules/agent/mcp-config-single-source-of-truth
  - rules/agent/globals-derived-from-workspace
  - rules/agent/karpathy-guidelines
---

# Own the memory, rent the intelligence

## The principle

**Memory belongs to you. Intelligence is rented.**

- **Memory** = `knowledge/` OKF bundle + `~/.claude/projects/*/memory/` per-session facts.
- **Skills** = `repos/own/infra/agent-skills/` junctioned into every fleet agent's skills dir.
- **Orchestration** = `.mcp.json` + `AGENTS.md` + reusable workflows in `chirag127/workflows`.
- **Intelligence** = whichever frontier model is best/cheapest/available this week — Opus 4.8, Fable 5, Sonnet 4.6, Haiku 4.5, GLM 5.2, Gemini, or a local model.

Models get locked (Fable pulled last week), vetted-only (GPT 5.6), deprecated (any older tier), or price-gouged mid-quarter. Your memory + skills + orchestration survive every provider swap.

## What this means in practice

| Layer | Rule |
|---|---|
| Memory | Every durable fact goes to `knowledge/` OKF, never in-chat-only or vendor-owned "memory feature" |
| Skills | Every reusable operation goes to `repos/own/infra/agent-skills/<skill>/SKILL.md` |
| MCP config | Single source of truth at `.mcp.json`, synced to all agents via `scripts/sync-mcp-configs.mjs` |
| Agent rules | Single source of truth at `AGENTS.md`, auto-imported into every agent per `agent-fleet-parity` |
| Model choice | `/model` per-task. Never build features that require a specific model. |

## Anti-patterns

- ❌ Storing a decision in ChatGPT's persistent memory instead of `knowledge/`
- ❌ Building a workflow only Claude Code can run (uses tools no other agent has)
- ❌ Committing memory-file paths that assume a specific harness location
- ❌ Setting `ANTHROPIC_MODEL=claude-opus-4-8` in a place where switching is painful
- ❌ Losing chat history to "the search doesn't find it" — that's exactly the failure mode; keep durable facts in `knowledge/`, not in chat

## The two anchors

1. **Frontier providers get locked.** Fable disappeared 2026-06-27, came back with 6-day promo period. GPT 5.6 shipped to vetted shops only. GLM 5.2 launched open-source in the same week. When any single-provider dependency exists, migration cost is high. When memory is portable, migration is a `/model` command.

2. **Agents will one-shot most workflows.** Cost of building the "own memory" layer dropped ~5× in 6 months. Claude Code + Codex + open-source agents can now write the SQL + configs + skills for you. The technical build barrier is nearly gone; only the human parts (accounts, permissions, approval, taste) belong to you.

## The "prove it" corollary

An agent that acts without evidence is out of policy. Every agent operation must:
- Cite what it read (files, URLs, prior context)
- Point to what it changed (paths, commit SHAs, PR URLs)
- Say plainly when something is unverified

Ties to [`karpathy-guidelines`](./karpathy-guidelines.md) §Goal-Driven Execution and the "make it prove it" habit in [`fable-5-prompting`](./fable-5-prompting.md).

## Cross-refs

- [`agent-fleet-parity`](./agent-fleet-parity.md) — same rules + skills across all 6 agents
- [`mcp-config-single-source-of-truth`](./mcp-config-single-source-of-truth.md) — MCP portability
- [`globals-derived-from-workspace`](./globals-derived-from-workspace.md) — workspace canonical, globals are cache
- [`karpathy-guidelines`](./karpathy-guidelines.md) — assumptions before code, verifiable goals
- [`fable-5-prompting`](./fable-5-prompting.md) — "make it prove it" verification habit
- Source: Nate B Jones YouTube 2026-06 + Nikita's Lemonade insurance story
