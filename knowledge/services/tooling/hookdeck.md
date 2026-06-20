---
type: service
title: "Hookdeck"
description: "Webhook reliability layer — queues + retries + replay for Razorpay → Worker delivery. 100K requests/month free."
tags: [services, webhooks, payment, reliability, tooling]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: webhook-reliability
provider: hookdeck
free_tier: "100K requests/month, 100K delivery attempts, 3-day retention, unlimited connections, exponential-backoff retries"
swap_cost: low
---

# Hookdeck

## Role

Webhook reliability + queueing + replay layer between Razorpay and the Hono API Worker at `api.oriz.in`. Razorpay POSTs the webhook to Hookdeck; Hookdeck persists it, retries on failure, and forwards to the Worker.

Without Hookdeck, a Worker outage during a payment webhook drops the event — the user paid but the subscription never activates. With Hookdeck, the event sits in the queue until the Worker is back, then delivers cleanly.

## Free tier

- 100K requests/month
- 100K delivery attempts/month (retries count)
- 3-day event retention
- Unlimited destinations + connections
- Exponential-backoff retry policy
- Manual replay from dashboard

## Card / subscription required?

**NO.** Hookdeck's free tier requires only an email-verified account. No payment method on file. (Paid plans exist but the free tier is generous enough for the family's expected webhook volume.)

## Alternatives

- **Svix** — similar product but optimised for *outbound* webhooks (you sending events to your customers). Hookdeck's strength is *inbound* (receiving events from third parties), which is what the family needs for Razorpay.
- **Cloudflare Queues** — DIY equivalent. You'd write a Worker that accepts the webhook, pushes to a Queue, and a consumer Worker drains it. Free up to 1M operations/month. Tradeoff: you own the retry logic, dashboard, replay UI.
- **AWS SQS / EventBridge** — requires card.

## Swap cost

**Low.** Razorpay webhook destination URL is just a string in the dashboard. Today it points at `api.oriz.in/webhooks/razorpay`; with Hookdeck it points at `https://hkdk.events/<connection-id>`, and Hookdeck forwards to `api.oriz.in/webhooks/razorpay`. To swap providers, change the Razorpay URL back (or to a Cloudflare Queues-fronted Worker). Code changes inside the Worker: zero.

## Why this is our pick

The family is a single-developer, eventually-consistent project. A Worker can be down for legitimate reasons (deploy, edge incident, mistake). Without a queue layer, those minutes cost real revenue — Razorpay's retry policy is short and capped. Hookdeck's 100K/mo free covers the family's expected payment volume by orders of magnitude, and the dashboard's replay UI is worth the integration alone for debugging.

## Cross-refs

- [services/payment/razorpay](../payment/razorpay.md)
- [architecture/api-umbrella-hono-worker](../../architecture/api-umbrella-hono-worker.md)
- [decisions/hookdeck-for-webhook-reliability](../../decisions/infrastructure/hookdeck-for-webhook-reliability.md)
- [decisions/razorpay-as-primary-billing](../../decisions/monetisation/razorpay-as-primary-billing.md)
