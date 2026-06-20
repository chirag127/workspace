---
type: service
title: "Razorpay"
description: "India-first subscription provider — UPI, cards, netbanking, wallets, EMI, pay-later — webhook-driven entitlement."
tags: [billing, razorpay, primary, india]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: subscription-billing-india
provider: razorpay
free_tier: "No platform fee — pay-per-transaction (2-3% per charge), free dashboard + KYC"
swap_cost: medium
related:
  - decisions/monetisation/razorpay-as-primary-billing
  - decisions/monetisation/max-payment-methods
  - services/payment/lemon-squeezy
  - services/payment/upi-direct
  - rules/no-card-on-file
---

# Razorpay

## Role

Primary subscription provider for **Indian-resident buyers**. Issues
subscriptions, fires webhooks into the Hono Worker, which writes
entitlement to `/users/{uid}/subscription` in Firestore. Non-Indian
buyers route to [Lemon Squeezy](./lemon-squeezy.md) instead — see
[max-payment-methods](../../decisions/monetisation/max-payment-methods.md).

## Methods supported

UPI (PhonePe / GPay / Paytm / BHIM apps + collect-flow), credit + debit
cards (Visa / Mastercard / RuPay / Amex), netbanking (60+ banks),
wallets (PhonePe, Paytm, Mobikwik, Freecharge, Amazon Pay), EMI (cards
+ no-cost EMI), pay-later (Simpl, LazyPay, ICICI Pay Later).
Indian-resident merchant onboarding only — international buyers use
Lemon Squeezy.

## Free tier

- No setup, no monthly platform fee
- Pay-per-transaction (2-3%, varies by method)
- Free test-mode environment, free dashboard, free webhooks

## Card / subscription required?

**NO** to use the dashboard or test mode. The merchant onboarding
needs KYC (PAN + bank account) but no card on file from us. Razorpay
takes its cut from each transaction at settlement.

Buyer-side, Razorpay does NOT require card-on-file — UPI flows are
intent-based per-transaction and satisfy the
[no-card-on-file rule](../../rules/no-card-on-file.md).

## Alternatives

- Stripe Checkout
- Lemon Squeezy
- Paddle

## Swap cost

Medium — the webhook handler in the Hono Worker is wrapped behind
`@chirag127/billing-razorpay`. Swap = re-implement the webhook
verifier and the subscription create flow.

## Why this is our pick

India-first, UPI-native, low-friction for the user's primary market.
Stripe is great in the US but conversion in India is meaningfully
worse without UPI.

## Cross-refs

- [Razorpay as primary billing](../../decisions/monetisation/razorpay-as-primary-billing.md)
- [Hono Worker](../../architecture/api-umbrella-hono-worker.md)
- [Firebase Spark](../auth/firebase-spark.md)
