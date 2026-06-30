---
type: decision
title: "Zero-cost inference backends — Ollama + Cloudflare Workers AI + Puter.js"
description: "Approved LLM endpoints when not using paid Claude/GPT keys. Local (Ollama) + serverless (Workers AI) + browser (Puter.js). Zero card, zero subscription. Grill-locked 2026-06-30 alongside gemini-cli-agent-addition."
tags: [ai, inference, ollama, cloudflare-workers-ai, puter-js, no-card, grill-decision, fallback-ladder]
timestamp: 2026-06-30
format_version: okf-v0.1
status: active
last_verified: 2026-06-30
supersedes: []
related:
  - rules/interaction/no-card-on-file
  - rules/interaction/never-hit-quotas
  - rules/agent/auto-grill-on-architectural-decisions
  - services/business/ai/cloudflare-workers-ai
  - services/business/ai/puter-js
  - decisions/architecture/agent-tooling/gemini-cli-agent-addition-2026-06-30
  - decisions/compute/ai-puter-plus-cf-workers-ai
---

# Zero-cost inference backends (2026-06-30 grill)

## Decision

Three zero-cost model backends are **approved for oriz workflows**, each marking a distinct deployment surface:

| Backend | Surface | Free tier | Card? | Role |
|---|---|---|---|---|
| **Ollama** | Local, dev machine | Unlimited (your GPU) | n/a | Primary dev runtime; offline; CI on workstation |
| **Cloudflare Workers AI** | Serverless, edge Worker | 10,000 neurons/day | NO | Primary serverless runtime; prod-side inference |
| **Puter.js** | Browser, end-user pays | Unlimited from our side | NO (end-user may optionally add one to their Puter account) | User-facing chat and on-page AI features |

All three pass the [`no-card-on-file`](../../rules/interaction/no-card-on-file.md) hard rule. All three already have service entries in `knowledge/services/business/ai/`. This decision codifies them as a **single fallback ladder** end-to-end.

## Why a ladder (not pick-one)

- **Different points of failure.** Local GPU dies → serverless. Serverless quota hits → browser. Browser blocked (user has no Puter account) → local. Each rung covers the previous rung's gap, satisfying [`parallel-by-default`](../../rules/interaction/parallel-by-default.md) via fallback chain.
- **[`never-hit-quotas`](../../rules/interaction/never-hit-quotas.md) requires ≥10× headroom.** Local Ollama gives essentially infinite headroom. Serverless Workers AI caps at 10K neurons/day — sufficient for edge AI tasks, not for bulk scraping. Browser Puter is end-user pays, so quota is per-user and doesn't reduce our headroom.
- **[`no-card-on-file`](../../rules/interaction/no-card-on-file.md) rejects Anthropic / OpenAI direct.** The free alternatives here are exactly what that rule forces us into.

## Routing rules

| Workload | Backend (first pick) | Fallback |
|---|---|---|
| Dev on laptop, no network / offline | **Ollama** (`localhost:11434/v1/chat/completions`) | Cloudflare Workers AI |
| Prod inference inside a Cloudflare Worker | **Cloudflare Workers AI** (`env.AI.bind()` native binding) | Puter.js dispatched to client |
| User-facing chat in browser | **Puter.js** | Fall back to Workers AI for hard server-side steps |
| Open-source CLI agent failover (any of Aider, Cline, Kilo Code, OpenCode, gocode, Coddy) | **Ollama** at `localhost:11434` (all confirmed OpenAI-compat) | Cloudflare Workers AI over HTTPS |
| Free-tier hosted Google model for general chat | **Gemini CLI** — see [`gemini-cli-agent-addition-2026-06-30`](../architecture/agent-tooling/gemini-cli-agent-addition-2026-06-30.md) | n/a (no public REST) |

## Per-backend details

- **Ollama.** Install via `ollama.com`. Default endpoint `http://localhost:11434`. OpenAI-compat at `/v1/chat/completions` (streaming, vision, tools, reasoning all supported). Desktop GUI + CLI expose the same underlying server. Optional paid "Ollama Cloud" exists — explicitly out of scope; remain on local.
- **Cloudflare Workers AI.** See [`cloudflare-workers-ai`](../../services/business/ai/cloudflare-workers-ai.md). Native worker binding via `env.AI`. 10K neurons/day free. All listed catalog models (Llama 3.x, Mistral, Mixtral, BGE, Nomic, Whisper, Stable Diffusion XL Lightning) included in the free quota.
- **Puter.js.** See [`puter-js`](../../services/business/ai/puter-js.md). Browser-side via `<script src="https://js.puter.com/v2/">`. End-user pays Puter directly; we hold no keys, no accounts. Model IDs mirror OpenRouter's catalog for parity, but billing routes through Puter.
- **Gemini CLI.** See [`gemini-cli-agent-addition-2026-06-30`](../architecture/agent-tooling/gemini-cli-agent-addition-2026-06-30.md). Linked here because it shares the "free-of-cost" framing even though it is not an API endpoint itself.

## Quota invariants (per `never-hit-quotas`)

| Backend | Soft alarm trip | Cap |
|---|---|---|
| Cloudflare Workers AI | 5,000 neurons/day (50%) | 10,000 neurons/day hard cap |
| Local Ollama | Disk space | No API-side cap |
| Puter.js | n/a (end-user pays) | Per-user at Puter's discretion |
| Gemini CLI | 600 req/day (60%); 36 req/min (60%) | 1,000 req/day, 60 req/min |

## What this decision does NOT do

- **Does not replace Claude Code as primary oriz driver.** For the monorepo's full session-cost surface (reasoning-heavy refactors, multi-file architectural changes), paid Claude Code remains primary. The three backends above are for free-routed workloads and failovers.
- **Does not bypass [`auto-grill-on-architectural-decisions`](../../rules/agent/auto-grill-on-architectural-decisions.md).** Any new service joining this ladder (e.g., LM Studio as a 4th option) requires its own grill-locked OKF decision.
- **Does not extend to hosting suggestions.** The Cf Workers-AI free tier is generous but quota-bound, not infinite. Long-context summarisation, bulk scraping, or anything else that could exhaust daily neurons on its own MUST be pre-grilled for quota impact.

## Cross-refs

- [`no-card-on-file`](../../rules/interaction/no-card-on-file.md) — gate this decision respects
- [`never-hit-quotas`](../../rules/interaction/never-hit-quotas.md) — quota alarm rule
- [`auto-grill-on-architectural-decisions`](../../rules/agent/auto-grill-on-architectural-decisions.md) — process producing this file
- [`cloudflare-workers-ai`](../../services/business/ai/cloudflare-workers-ai.md) — serverless service entry
- [`puter-js`](../../services/business/ai/puter-js.md) — browser service entry
- [`ai-puter-plus-cf-workers-ai`](./ai-puter-plus-cf-workers-ai.md) — prior split decision reinforcing the surface split
- [`gemini-cli-agent-addition-2026-06-30`](../architecture/agent-tooling/gemini-cli-agent-addition-2026-06-30.md) — sibling agent-class decision
