---
type: service
title: "Upstash QStash"
description: "Deferred queue alternative — 500 msg/day free, held in reserve"
tags: [queue, upstash, qstash, deferred]
timestamp: 2026-06-20
format_version: okf-v0.1
status: deferred
role: queue-fallback
provider: upstash
free_tier: "500 messages/day, HTTP-based publish + consume, scheduled jobs, no card"
swap_cost: medium
related:
  - services/data/queue/cloudflare-queues
  - services/data/queue/inngest
  - decisions/architecture/queue-cloudflare-native
---

# Upstash QStash

## Status

**Deferred.** Held in reserve as a documented swap target if
[Cloudflare Queues](./cloudflare-queues.md) hits a quota cliff or a
feature we need lands in QStash first.

QStash is an HTTP-first serverless message queue — producers POST to
a URL, consumers receive a webhook callback. It works from any
runtime (not just Workers), supports scheduling, retries, and
dead-lettering, and the free tier (500 messages/day) is plenty for
non-batched workloads but tighter than Cloudflare Queues' 1M/month
allowance. Email-only signup, no card.

## Cross-refs

- [Cloudflare Queues](./cloudflare-queues.md) — primary
- [Inngest](./inngest.md) — sibling deferred alternative
- [Cloudflare-native queue decision](../../decisions/architecture/queue-cloudflare-native.md)
