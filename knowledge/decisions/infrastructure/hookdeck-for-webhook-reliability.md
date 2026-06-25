---
type: decision
title: "Add Hookdeck for Razorpay webhook reliability"
description: "Hookdeck queues Razorpay webhooks → forwards to api.oriz.in Worker, with retries + replay. 100K req/mo free, no card."
tags: [decisions, infrastructure, webhooks, payment, razorpay, hookdeck]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - services/tooling/hookdeck
  - services/payment/razorpay
  - architecture/api-umbrella-hono-worker
---

# Add Hookdeck for Razorpay webhook reliability

## Decision

Add **Hookdeck** to the family stack as the webhook reliability layer for Razorpay. Razorpay POSTs payment events to Hookdeck; Hookdeck queues, retries, and forwards to the Hono API Worker at `api.oriz.in/webhooks/razorpay`.

## Why

A Worker outage during a payment webhook silently drops revenue — the user paid but the subscription never activates because Razorpay's retry window is short. Hookdeck's free tier (100K requests/month, 100K attempts, 3-day retention, exponential-backoff retries, manual replay) covers the family's expected payment volume by orders of magnitude and adds a debug-friendly dashboard. No card required, no subscription — fits the family's [no-paid-tier](../policy/no-paid-tier.md) rule.

## Implications

- Razorpay webhook destination URL changes from `https://api.oriz.in/webhooks/razorpay` to a Hookdeck-issued URL (`https://hkdk.events/<connection-id>`).
- Hookdeck forwards every event to `api.oriz.in/webhooks/razorpay` — Worker code is unchanged.
- A new env-var (`HOOKDECK_SIGNING_SECRET`) is added to the Worker so it can verify Hookdeck-signed forwards. Razorpay's signature is preserved in headers.
- Failures within the Worker (5xx response) trigger Hookdeck's retry policy automatically; the team can replay manually from the dashboard.
- Adds Hookdeck to the [services/tooling/](../../services/tooling/index.md) catalog as an active pick.
- Swap cost is low: switching Hookdeck off means pointing Razorpay's webhook URL back at `api.oriz.in` directly (or fronting it with Cloudflare Queues — see [services/tooling/hookdeck.md](../../services/tooling/hookdeck.md) alternatives).

## Cross-refs

- [services/tooling/hookdeck](../../services/tooling/hookdeck.md)
- [services/payment/razorpay](../../services/payment/razorpay.md)
- [architecture/api-umbrella-hono-worker](../architecture/compute/api-umbrella-hono-worker.md)
- [decisions/razorpay-as-primary-billing](../monetisation/razorpay-as-primary-billing.md)
- [decisions/code-quality-stack](../process/code-quality-stack.md) — sibling reliability decision from the same session
