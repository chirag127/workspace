---
type: service
title: "Cloudflare Workers AI"
description: "Native AI inference inside Hono Worker — 10K neurons/day free, zero-egress"
tags: [ai, cloudflare, workers, inference, server-side, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: ai-cloudflare-native
provider: cloudflare
free_tier: "10,000 neurons / day, no card, native binding from any Worker, zero-egress within Cloudflare"
swap_cost: medium
related:
  - services/business/ai/puter-js
  - services/infra/compute/cloudflare-workers
  - decisions/architecture/ai-puter-plus-cf-workers-ai
  - decisions/architecture/hono-worker-api-umbrella
  - rules/no-card-on-file
  - rules/never-hit-quotas
---

# Cloudflare Workers AI

## Role

**Server-side** AI inference inside the umbrella Hono Worker at
`api.oriz.in` — the place to put any AI call where:

- The prompt or response includes a secret the browser must not see.
- The output feeds another server-side step (queue dispatch, DB
  write, image-CDN warm-up).
- The model needed is one Workers AI hosts (Llama 3, Mistral, BGE
  embeddings, Stable Diffusion XL, etc.).
- Latency from `api.oriz.in` matters — Workers AI binds natively, so
  the inference happens on the same edge node as the Worker, with
  zero egress.

Browser-side AI stays on [Puter.js](./puter-js.md) — see the split
decision at
[`decisions/architecture/ai-puter-plus-cf-workers-ai.md`](../../decisions/architecture/ai-puter-plus-cf-workers-ai.md).

## Free tier

- **10,000 neurons / day** (rolling 24 h)
- Native binding — no separate credentials surface, declared in the
  Hono Worker's `wrangler.toml` as `[ai]`
- Same-account billing posture as Pages / Workers / Queues / KV
- Zero egress when the call originates inside Cloudflare
- All hosted models on the catalog included in the free quota:
  - Llama 3.1 / Llama 3.3 family
  - Mistral 7B / Mixtral
  - BGE / Nomic embeddings
  - Stable Diffusion XL Lightning (image gen)
  - Whisper (ASR)
  - speech-to-text + text-to-speech variants

## Card / subscription required?

**NO.** Same account as the rest of the Cloudflare stack — the
account stays no-card per
[`rules/no-card-on-file.md`](../../rules/interaction/no-card-on-file.md).

## Quota-headroom plan

Per [`rules/interaction/never-hit-quotas.md`](../../rules/interaction/never-hit-quotas.md):

- The Hono Worker tracks neurons consumed per day in KV; trips a soft
  cap at 50% (5,000 neurons) to flag approach.
- Browser-side AI features go through [Puter.js](./puter-js.md), not
  Workers AI, so the 10K / day budget is reserved for true
  server-side use.
- Long-context summarization batched into low-traffic windows;
  embeddings cached by content hash so re-runs cost zero neurons.

## Why two AI services?

Different surfaces:

| Use case | Service |
|---|---|
| Browser AI (chat in `oriz-me`, on-page assistants) | [Puter.js](./puter-js.md) |
| Server AI (inside Hono Worker, chained with DB / Queue / R2) | Cloudflare Workers AI (this file) |
| Hosted Gemini if a feature truly needs Google's specific model | Firebase AI Logic ([firebase-ai-logic-basics skill](../../../CLAUDE.md)) |

Picked together so each surface has a no-card free tier already
sitting on infra the family uses. See
[`decisions/architecture/ai-puter-plus-cf-workers-ai.md`](../../decisions/architecture/ai-puter-plus-cf-workers-ai.md).

## Alternatives

- [Puter.js](./puter-js.md) — sibling, browser-side
- [OpenRouter](./openrouter.md) — REJECTED, requires server-paid
  account
- Replicate — no card-free tier
- Hugging Face Inference API — small free quota, slower
- Together AI — has a free trial but card-required for production

## Swap cost

Medium — Workers AI's binding API is Cloudflare-specific. A swap
means rewriting the AI helper module to call OpenAI / Anthropic /
Hugging Face over HTTP and adding a credentials surface. Encapsulate
in `apps/api/src/ai/` so the swap is one file.

## Why this is our pick

- **No card, native binding** — zero new accounts.
- **Zero egress + same edge as the Worker** — better p50 than any
  external HTTP gateway.
- **Catalog matches family needs** — Llama for general chat / summary,
  BGE for embeddings (RAG), Stable Diffusion for occasional og:image
  fallbacks, Whisper for podcast / video transcription.
- **Stack cohesion** — same posture as
  [`decisions/architecture/queue-cloudflare-native.md`](../../decisions/architecture/queue-cloudflare-native.md).

## Cross-refs

- [Puter.js](./puter-js.md) — browser-side AI sibling
- [AI services index](./index.md)
- [AI split decision (Puter + Workers AI)](../../decisions/architecture/ai-puter-plus-cf-workers-ai.md)
- [Hono Worker API umbrella](../../decisions/architecture/hono-worker-api-umbrella.md)
- [Cloudflare Workers](../compute/cloudflare-workers.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
