---
type: service
title: "OpenRouter"
description: "LLM API gateway — rejected; Puter.js mirrors its model IDs"
tags: [ai, llm, gateway, rejected]
timestamp: 2026-06-20
format_version: okf-v0.1
status: rejected
rejection_reason: "We use Puter.js exclusively for Gen AI; OpenRouter model IDs are mentioned only because Puter.js mirrors them. Calling OpenRouter directly would require account + credit signup."
role: server-side-llm-gateway
provider: openrouter
free_tier: "Free models (DeepSeek, Llama, Moonshot etc.), rate-limited; paid models pay-per-token if used"
swap_cost: medium
related:
  - services/business/ai/puter-js
---

# OpenRouter

> **Status: rejected (2026-06-20).** The family uses
> [Puter.js](./puter-js.md) exclusively for Gen AI. The reason
> OpenRouter is mentioned in older notes is that **Puter.js exposes
> model IDs that match OpenRouter's catalog** (DeepSeek R1, Llama,
> Moonshot, etc.) — so it _looks_ like OpenRouter under the hood,
> but billing/quota goes through Puter.js's free tier (the user pays
> Puter, not us). Calling OpenRouter directly would require an
> account, eventual credit signup, and a server to hold the API key —
> all things we explicitly avoid.

## Role (historical)

Server-side LLM calls (e.g. summarisation in build-time scripts,
ingester enrichment). Used for things that can't run in the browser.

## Free tier

- Free routes: `deepseek/deepseek-chat-v3:free`, `meta-llama/...:free`, `moonshotai/...:free`, etc.
- Rate-limited (typically 20 req/min, ~200 req/day per free model)
- Paid models cost-per-token, opt-in only

## Card / subscription required?

**NO** for the free models. Free-tier sign-up needs only an email
or GitHub login. A payment method is required ONLY if you choose to
use paid models.

## Alternatives

- [Puter.js](./puter-js.md) — current primary, browser-side, user-pays
- Pollinations.AI (no auth)
- Direct Hugging Face Inference API

## Swap cost

Medium — OpenRouter is OpenAI-API-compatible, so most swaps are a
base-URL change. Models are namespaced differently across providers.

## Why this is rejected

Picking OpenRouter would mean:

1. Holding an API key on a server (we run no servers we don't have to).
2. Tracking rate-limit windows per model.
3. Eventually attaching a card if the free models get throttled.

Puter.js sidesteps all three: end users sign in to Puter, the family
pays nothing per request, and the same model IDs are available. The
"OpenRouter mention" in code is purely a model-namespace coincidence.

## Cross-refs

- [Puter.js](./puter-js.md) — current primary
- [GitHub Actions](../compute/github-actions.md) — runs build-time scripts (uses Puter.js where Gen AI is needed)
