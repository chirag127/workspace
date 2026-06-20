---
type: service
title: "Inngest"
description: "Deferred queue alternative — durable workflows + step functions, generous free tier, no card. Held in reserve if Cloudflare Queues' simple model is outgrown."
tags: [queue, inngest, durable-functions, deferred]
timestamp: 2026-06-20
format_version: okf-v0.1
status: deferred
role: queue-fallback
provider: inngest
free_tier: "Generous free tier (50K events/mo, multi-step durable functions), no card"
swap_cost: high
related:
  - services/queue/cloudflare-queues
  - services/queue/upstash-qstash
  - decisions/architecture/queue-cloudflare-native
---

# Inngest

## Status

**Deferred.** Held in reserve as a documented swap target if the
family ever needs **durable multi-step workflows** that Cloudflare
Queues' simple message model can't express ergonomically.

Inngest is a durable-function platform — code defines steps that
survive restarts, with state checkpointed between steps. Free tier
covers a meaningful per-month event budget and email-only signup.
Swap cost is high because the programming model itself differs:
moving from Cloudflare Queues (consumer-style) to Inngest
(step-function-style) means rewriting consumers, not just bindings.

## Cross-refs

- [Cloudflare Queues](./cloudflare-queues.md) — primary
- [Upstash QStash](./upstash-qstash.md) — sibling deferred alternative
- [Cloudflare-native queue decision](../../decisions/architecture/queue-cloudflare-native.md)
