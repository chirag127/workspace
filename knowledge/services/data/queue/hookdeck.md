---
type: service
title: "Hookdeck (webhook ingress)"
description: "Webhook-ingress reliability for CF Queues — 50K events/mo free"
tags: [services, queue, webhook-ingress, hookdeck, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: webhook-ingress
provider: hookdeck
free_tier: "50K events/month, exponential-backoff retries, manual replay, 3-day retention, unlimited connections; no card on free tier"
swap_cost: low
related:
  - services/data/queue/cloudflare-queues
  - services/data/queue/index
  - services/business/tooling/hookdeck
  - services/business/payment/razorpay
  - decisions/architecture/distribution-and-queues-locked
  - infrastructure/hookdeck-for-webhook-reliability
  - rules/no-card-on-file
---

# Hookdeck (webhook ingress)

## Role

Hookdeck sits **in front of** the
[Cloudflare Queues](./cloudflare-queues.md) consumer for every
external webhook the family ingests. Producers (Razorpay, Lemon
Squeezy, GitHub, Stripe-deferred, etc.) POST to a Hookdeck
connection URL; Hookdeck persists the event, retries on Worker 5xx,
and forwards into the api.oriz.in Worker which then enqueues onto
Cloudflare Queues for downstream fan-out.

This is the **same Hookdeck account** documented at
[`services/business/tooling/hookdeck.md`](../tooling/hookdeck.md) (which
covers the Razorpay payment-webhook facet). This file documents the
**queue-ingress** role specifically — the Batch 13 lock makes
Hookdeck the canonical webhook-ingress layer for every external
producer in the family, not just Razorpay.

## Free tier

- 50,000 events / month (current Hookdeck free-plan threshold —
  generous for family scale; verify before adopting a new
  high-volume producer).
- Unlimited destinations + connections.
- Exponential-backoff retry policy.
- Manual replay from dashboard.
- 3-day event retention on free; longer on paid (paid not adopted).

## Card / subscription required?

**NO.** Hookdeck's free tier requires only an email-verified
account. No payment method on file at any stage. Per
[`rules/no-card-on-file.md`](../../rules/interaction/no-card-on-file.md).

## Architecture

```
external producer (Razorpay / GitHub / etc.)
    ↓ POST
Hookdeck connection URL (https://hkdk.events/<connection-id>)
    ↓ persist + retry on 5xx
api.oriz.in/webhooks/<source>   (Hono Worker)
    ↓ verify signature, enqueue
Cloudflare Queues (native binding)
    ↓ consumer Worker
domain logic (fan-out, side effects)
```

The **two reliability layers stack**: Hookdeck protects the
ingress hop (producer → Worker), Cloudflare Queues protects the
fan-out hop (Worker → consumer). The
[Trigger.dev alternative was considered and walked back](../../decisions/architecture/distribution-and-queues-locked.md)
— the durable-workflow programming model was overkill for the
family's webhook volume; CF Queues + Hookdeck covers the same
reliability surface with the family's existing stack.

## Alternatives

- **Cloudflare Queues alone** — DIY equivalent, no ingress retry
  layer. Producer hitting a Worker outage drops the event. Adding
  Hookdeck on top reclaims those minutes for a free-tier cost.
- **Svix** — outbound-webhook focused; wrong shape (we ingest, not
  emit, third-party events).
- **Trigger.dev** — durable workflows with code-defined steps.
  Walked back as redundant with CF Queues + Hookdeck. See
  [`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md)
  "walked back" section.
- **AWS EventBridge / SNS** — requires card.

## Swap cost

**Low.** Each producer's webhook URL is a string in their
dashboard. Pointing it at `api.oriz.in/webhooks/...` directly skips
Hookdeck entirely; pointing it at a different reliability provider
is the same one-string flip. Worker code is unchanged either way.

## Why this is our pick

The family is single-developer, eventually-consistent. A Worker
outage during a webhook drops real revenue / state-change events.
Hookdeck's free tier covers expected volume by orders of magnitude,
the dashboard's replay UI is debug-gold, and stacking it in front of
Cloudflare Queues gives two layers of reliability without
introducing a card-on-file requirement.

## Cross-refs

- [Cloudflare Queues](./cloudflare-queues.md) — fan-out queue downstream
- [Queue bucket index](./index.md)
- [Hookdeck (tooling facet — Razorpay specifically)](../tooling/hookdeck.md)
- [Distribution + queues locked decision](../../decisions/architecture/distribution-and-queues-locked.md)
- [Earlier Hookdeck-for-Razorpay decision (Batch 4)](../../infrastructure/hookdeck-for-webhook-reliability.md)
- [Razorpay (Indian billing)](../payment/razorpay.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
