---
type: decision
title: "ONE subscription unlocks every site and every extension"
description: "Single Razorpay-driven subscription stored in Firestore as users/{uid}/subscription unlocks paid features across the entire family — sites and extensions."
tags: [subscription, billing, firebase, entitlement]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/monetisation/razorpay-as-primary-billing
  - decisions/infrastructure/extension-auth-firebase-plus-license-key
  - decisions/infrastructure/firebase-spark-forever
  - decisions/monetisation/no-subscriptions-anywhere
---

# ONE subscription unlocks every site and every extension

## Decision

A single subscription per user — paid through Razorpay, stored at
`users/{uid}/subscription` in Firestore — unlocks paid features
across every site AND every extension in the family. There are no
per-site or per-extension subscriptions.

## Why

Per-product subscriptions multiply checkout friction and confuse
users who can't tell where the family ends. A single subscription
amortises the billing infra (one webhook, one entitlement doc, one
churn metric) and turns every new site or extension into a free
multiplier of the subscription's perceived value. This applies the
package-isolation rule at the entitlement level: every consumer
reads the same Firestore doc.

## Implications

- Razorpay webhook → `apps/api/routes/razorpay/webhook.ts` → writes `users/{uid}/subscription` in Firestore (`status`, `tier`, `current_period_end`, etc.).
- Each site reads `users/{uid}/subscription` directly via the Firestore client SDK (browser-side) to gate features.
- Each extension reads it via `chrome.storage.local`-cached ID token + Firestore client (or via `@chirag127/api-client` calling `apps/api/routes/firestore/`).
- Free-tier features remain on every site/extension regardless of subscription — paid features are additive enhancements, not gates on the core.
- Note: this does NOT contradict [no-subscriptions-anywhere](./no-subscriptions-anywhere.md) which is about OUR cost, not the user's. We never PAY a subscription; we may COLLECT one from users for premium features.
- Switching billing providers (Razorpay → Stripe / Lemon Squeezy / Paddle) is a webhook handler swap — entitlement schema doesn't change.

## Cross-refs

- [Razorpay as primary billing](./razorpay-as-primary-billing.md)
- [Extension auth: Firebase + license-key fallback](../infrastructure/extension-auth-firebase-plus-license-key.md)
- [Firebase Spark forever](../infrastructure/firebase-spark-forever.md)
- [No subscriptions anywhere (our cost side)](./no-subscriptions-anywhere.md)
