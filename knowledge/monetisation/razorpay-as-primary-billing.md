---
type: decision
title: "Razorpay is the primary subscription provider"
description: Razorpay primary billing. Stripe, Lemon Squeezy, Paddle fallbacks
tags: [billing, razorpay, subscription, services]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - monetisation/one-subscription-unlocks-all
  - services/business/payment/razorpay
---

# Razorpay is the primary subscription provider

## Decision

Razorpay is the primary subscription/billing provider. The fallback
order if Razorpay rejects the merchant application or shuts down
is: Stripe ? Lemon Squeezy ? Paddle. Switching is a webhook-handler
change behind the `@chirag127/billing-razorpay` (planned) package,
not an architectural one.

## Why

Razorpay supports UPI, which Stripe still doesn't in 2026 — and UPI
is the dominant payment rail for the primary user market (India).
The same Firestore-webhook integration pattern that works for Stripe
works for Razorpay, so we don't lose architecture flexibility by
picking the Indian-first option. Stripe / Lemon Squeezy / Paddle
remain documented fallbacks because Razorpay's merchant onboarding
can reject for compliance reasons outside our control.

## Implications

- User pays through Razorpay Checkout (browser-side).
- Razorpay webhook hits `apps/api/routes/razorpay/webhook.ts` on the umbrella Hono Worker.
- Worker validates webhook signature using the Razorpay webhook secret (from envpact), writes to `users/{uid}/subscription` in Firestore.
- Webhook handler is wrapped behind a `@chirag127/billing-razorpay` package (planned) so swapping to Stripe is a package version bump.
- The free-tier billing constraint applies: Razorpay free plan covers transaction processing; we never pay a fixed monthly fee.

## Cross-refs

- [ONE subscription unlocks everything](./one-subscription-unlocks-all.md)
- [Razorpay service entry](../../services/business/payment/razorpay.md)
- [Hookdeck for webhook reliability](../infrastructure/hookdeck-for-webhook-reliability.md)
- [AGENTS.md subscription model section](../../../AGENTS.md)
