---
type: index
title: "Queue services"
description: "Durable message queue + webhook ingress reliability. Cloudflare Queues primary (fan-out); Hookdeck primary (webhook ingress); Upstash QStash + Inngest documented as deferred alternatives. Trigger.dev walked back."
tags: [services, queue, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Queue services

The family runs **two reliability layers** stacked: Hookdeck on the
ingress side (external webhook → Worker), Cloudflare Queues on the
fan-out side (Worker → consumers). Both free, both no card.

| Service | Status | Role | Free tier |
|---|---|---|---|
| [cloudflare-queues.md](./cloudflare-queues.md) | active | queue-primary (fan-out) | 1M ops / month |
| [hookdeck.md](./hookdeck.md) | active | webhook-ingress | 50K events / month |
| [upstash-qstash.md](./upstash-qstash.md) | deferred | queue-fallback | 500 messages / day |
| [inngest.md](./inngest.md) | deferred | queue-fallback | Generous free tier (durable workflows) |

## Why Cloudflare Queues + Hookdeck (and not Trigger.dev)

Documented in
[`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md)
(Batch 13 lock) and the earlier
[`decisions/architecture/queue-cloudflare-native.md`](../../decisions/architecture/queue-cloudflare-native.md)
(Batch 8). TL;DR: native Worker bindings + same dashboard as
Pages/R2/Workers + Hookdeck's free ingress retry layer covers the
family's webhook reliability surface without adding a new account.
Trigger.dev's durable-workflow model was considered and walked back
as redundant for current volume.

## When to revisit

- If Cloudflare Queues' 1M ops/month cap becomes a real ceiling
  → consider QStash for low-volume bursts.
- If Hookdeck's 50K events/month cap is approached
  → revisit; paid plans available but card-required (so swap, don't
  upgrade).
- If the family ever ships durable multi-step workflows that survive
  restarts → consider Inngest.

## Cross-refs

- [Distribution + queues locked decision (Batch 13)](../../decisions/architecture/distribution-and-queues-locked.md)
- [Cloudflare-native queue decision (Batch 8)](../../decisions/architecture/queue-cloudflare-native.md)
- [Cloudflare Pages for all sites](../../infrastructure/cloudflare-pages-for-all-sites.md)
- [Hookdeck (queue-ingress facet)](./hookdeck.md)
- [Hookdeck (Razorpay tooling facet)](../tooling/hookdeck.md) — same account, payment-webhook role
- [Earlier Hookdeck-for-Razorpay decision (Batch 4)](../../infrastructure/hookdeck-for-webhook-reliability.md)
