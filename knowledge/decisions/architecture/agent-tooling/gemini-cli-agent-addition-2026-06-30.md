---
type: decision
title: "Add Gemini CLI to oriz coding-agent fleet"
description: "11th interactive agent. Free tier via Google OAuth. 1,000 req/day + 60 req/min. Headless scripting flag, no public REST API. No card-on-file. Grill-locked 2026-06-30."
tags: [agent, fleet, gemini-cli, google, free-tier, no-card, grill-decision]
timestamp: 2026-06-30
format_version: okf-v0.1
status: active
last_verified: 2026-06-30
supersedes: []
related:
  - rules/agent/agent-fleet-parity
  - rules/agent/mcp-config-single-source-of-truth
  - rules/agent/auto-grill-on-architectural-decisions
  - knowledge-deletion-not-supersession (rule the body note below relies on)
  - decisions/compute/zero-cost-inference-backends-2026-06-30
  - services/business/ai/cloudflare-workers-ai
  - services/business/ai/puter-js
---

# Add Gemini CLI to oriz coding-agent fleet

## Decision

**Gemini CLI** joins the oriz coding-agent fleet as an **agent-class** member (not a model server). Surface: terminal CLI. Auth: Google account OAuth (no API key needed for the free tier).

## Grill record (2026-06-30, 4 MCQs)

| # | Question | Locked answer |
|---|---|---|
| 1 | Use case | Add to oriz agent fleet |
| 2 | Runtime | Mixed: local for dev, serverless free for prod |
| 3 | Picks (multi) | Ollama + Cloudflare Workers AI + Puter.js + Gemini CLI — codify the whole free ladder |
| 4 | Cost | "Free of cost" — nothing in this expansion can ever bill us |

## Why Gemini CLI fits

- **Free.** Verified against Google's docs 2026-06-30: 1,000 req/day, 60 req/min on the free tier accessed via OAuth. No card-on-file required.
- **No new key surface.** Login uses the user's existing Google account. We do not hold credentials; agents authenticate interactively — passes the [`no-card-on-file`](../../../rules/interaction/no-card-on-file.md) hard rule cleanly.
- **MCP-compatible.** Google's Gemini CLI added partial MCP support in 2026, satisfying the [`agent-fleet-parity`](../../../rules/agent/agent-fleet-parity.md) "every agent sees the same `.mcp.json`" criterion.
- **Reverses prior verdict.** [`fleet-cut-to-4-agents-2026-06-29`](./fleet-cut-to-4-agents-2026-06-29.md) listed Gemini CLI as "Partial MCP, not currently needed." The 2026-06-30 grill explicitly promotes it to fleet — that row of the 2026-06-29 verdict is now superseded; the rest of the cut (Cline dropped, fleet-of-4) stands.

## What this agent is NOT

- **Not a public REST API endpoint.** Gemini CLI is a client-side agent. It does **not** expose its model routing/server as a callable endpoint for other programs. Scripts can drive it headlessly via `-p` and `--output-format json` from a node with an active OAuth session, but that is local invocation, not server-side API. For programmatic access from a Cloudflare Worker or another script, see the sibling [`zero-cost-inference-backends-2026-06-30`](../../compute/zero-cost-inference-backends-2026-06-30.md).
- **Not a daily-driver replacement for Claude Code.** Quota (1,000/day) is <5% of what a typical oriz monorepo session consumes on Anthropic-paid Claude. Positioned as **secondary/parallel** — failover for free-routed work, not replacement for Claude Code on primary paid work.
- **Not credentialed for production automation.** OAuth-dependent; CI/CD or scheduled jobs need a long-lived API key path (REST + service account), which is a card-on-file surface — explicitly out of scope.

## What needs to change (apply in a follow-up grill, NOT this one)

Per [`auto-grill-on-architectural-decisions`](../../../rules/agent/auto-grill-on-architectural-decisions.md), the rule is "write decision, **THEN** code":

1. Add row to `AGENTS.md` fleet table (becomes 11th agent)
2. Create `.agents/gemini/AGENTS.md` pointer stub
3. Extend `scripts/sync-mcp-configs.mjs` to add Gemini CLI MCP target
4. Extend `scripts/install-agents.ps1` + `scripts/install-agents.cmd` to install Gemini CLI
5. Add `~/.gemini/skills/` to `scripts/wire-agent-skills-junctions.mjs` `TARGETS` array for skill parity

The follow-up also has to reconcile the **already-drifted** fleet count: the working `AGENTS.md` documents 10 agents; the [`agent-fleet-parity`](../../../rules/agent/agent-fleet-parity.md) rule still says "four agents, no more." Bringing both into sync is part of the same follow-up grill session.

## Cross-refs

- [`agent-fleet-parity`](../../../rules/agent/agent-fleet-parity.md) — rule this decision satisfies
- [`auto-grill-on-architectural-decisions`](../../../rules/agent/auto-grill-on-architectural-decisions.md) — process producing this file

- [`fleet-cut-to-4-agents-2026-06-29`](./fleet-cut-to-4-agents-2026-06-29.md) — predecessor; Gemini CLI row verdict is reversed; Cline-drop and 4-agent verdict stand
- [`zero-cost-inference-backends-2026-06-30`](../../compute/zero-cost-inference-backends-2026-06-30.md) — sibling decision covering Ollama / Workers AI / Puter.js
- [`cloudflare-workers-ai`](../../../services/business/ai/cloudflare-workers-ai.md) — serverless AI sibling
- [`puter-js`](../../../services/business/ai/puter-js.md) — browser-side AI sibling
