---
type: index
title: "AI services"
description: "Two-surface AI stack: Puter.js for browser-side calls (user-pays), Cloudflare Workers AI for server-side calls inside the Hono Worker (zero-egress, 10K neurons/day). Different surfaces, different reasons."
tags: [services, ai, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# AI services

Two AI providers, **picked by surface**:

| Surface | Service | Why this surface |
|---|---|---|
| Browser (chat in oriz-me, on-page assistants) | [Puter.js](./puter-js.md) | User-pays; we ship no API key, the family pays nothing per request |
| Server (inside the umbrella Hono Worker at `api.oriz.in`) | [Cloudflare Workers AI](./cloudflare-workers-ai.md) | Native Worker binding, zero-egress within Cloudflare, 10K neurons / day free |
| Hosted Gemini (only when a feature truly needs Google's model) | Firebase AI Logic | Free tier on Spark; document-shaped fits our existing Firebase posture |

OpenRouter is rejected — Puter.js mirrors its model IDs already, and
calling OpenRouter directly would require a server-paid account.

## Per-service files

| Service | Status | One-line role |
|---|---|---|
| [puter-js.md](./puter-js.md) | active | Browser-side AI calls — user-pays free tier, no API keys client-side |
| [cloudflare-workers-ai.md](./cloudflare-workers-ai.md) | active | Server-side AI calls inside the Hono Worker — 10K neurons / day, zero-egress |
| [openrouter.md](./openrouter.md) | rejected | Server-side LLM gateway — rejected; Puter.js mirrors its model IDs and Workers AI covers server inference |

## Why two AI services and not one?

A single provider can't cover both surfaces well:

- **Browser-only providers** (Puter.js) put auth + billing on the
  user, so the family ships nothing per request — but the API key
  can't ride into a Worker without exposing it.
- **Server-only providers** (Workers AI) bind natively to a Worker
  and run on the same edge node, but can't be called from a static
  Cloudflare Pages site without a relay.
- Splitting by surface keeps each free tier reserved for its
  intended workload, so neither cliff hits prematurely.

Locked at
[`decisions/architecture/ai-puter-plus-cf-workers-ai.md`](../../decisions/architecture/ai-puter-plus-cf-workers-ai.md).

## Cross-refs

- [AI split decision (Puter + Workers AI)](../../decisions/architecture/ai-puter-plus-cf-workers-ai.md)
- [Hono Worker API umbrella](../../decisions/architecture/hono-worker-api-umbrella.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
- [Never hit quotas rule](../../rules/never-hit-quotas.md)
