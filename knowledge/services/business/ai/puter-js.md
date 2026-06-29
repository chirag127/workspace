---
type: service
title: "Puter.js"
description: "Browser-side AI inference — user-pays, free unlimited from our side"
tags: [ai, llm, browser, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: browser-ai-inference
provider: puter
free_tier: "Unlimited from the developer's perspective — Puter charges the end user, not us"
swap_cost: medium
---

# Puter.js

## Role

The AI chat in `oriz-me` and any other client-side AI feature.
Puter handles auth + billing on the user side, so the family pays
nothing per request.

## Free tier

- Unlimited from our side
- Users sign in with Puter and bring their own quota / pay-as-you-go
- No backend server needed

## Card / subscription required?

**NO** — not from us. End users may attach a card to their Puter
account at their discretion; we never see it.

## Why not OpenRouter directly?

Older notes in the codebase mention OpenRouter alongside Puter.js.
That is a **model-ID parity** observation, not a direction to call
OpenRouter. Puter.js exposes model IDs that mirror OpenRouter's
catalog (DeepSeek R1, Llama, Moonshot, etc.), so a Puter.js call may
_look_ like an OpenRouter call — but billing and quota route through
Puter.js's user-pays free tier, which is exactly why we picked it.

Calling OpenRouter directly would require:

1. An account + eventual credit attachment.
2. A server to hold the API key (we run no servers we don't have to).
3. Per-model rate-limit tracking on free routes.

Puter.js sidesteps all three. See
[`services/business/ai/openrouter.md`](./openrouter.md) (status: rejected) for
the long-form rationale.

## Alternatives

- [OpenRouter](./openrouter.md) — REJECTED, model-ID parity only
- Pollinations.AI (no auth)
- Mediaworkbench (100K free words)

## Swap cost

Medium — Puter's API shape is its own. Swap means re-wiring the
chat client to OpenRouter (server-paid) or another browser SDK.

## Why this is our pick

Lets us ship AI features without paying for inference. Browser-only
keeps the no-server-needed property. Already in `oriz-me`.

## Browser surface only — server side uses Workers AI

Puter.js is the **browser-side** AI provider. **Server-side** AI calls
(inside the Hono Worker at `api.oriz.in`) go through
[Cloudflare Workers AI](./cloudflare-workers-ai.md) instead — native
Worker binding, zero-egress, 10K neurons / day free, no card. The
two services are not interchangeable: Puter.js needs the browser to
host its auth flow; Workers AI binds at deploy time to a Worker.
Split locked at
[`decisions/architecture/ai-puter-plus-cf-workers-ai.md`](../../decisions/architecture/ai-puter-plus-cf-workers-ai.md).

## Cross-refs

- [Cloudflare Workers AI](./cloudflare-workers-ai.md) — server-side sibling
- [AI split decision](../../decisions/architecture/ai-puter-plus-cf-workers-ai.md)
- [OpenRouter](./openrouter.md)
- [oriz-me design brief](../../design/oriz-me.md)
