---
type: service
title: "Ko-fi"
description: "Creator donations — 0% platform fee on free tier; PayPal or Stripe payout."
tags: [donations, ko-fi, creator]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: donations-creator
provider: ko-fi
free_tier: "0% platform fee; payment-processor fees only (Stripe ~2.9% + 30¢ or PayPal equivalent)"
swap_cost: low
related:
  - decisions/monetisation/max-payment-methods
  - services/payment/github-sponsors
  - services/payment/buymeacoffee
---

# Ko-fi

## Role

The "creator" donation channel — sits on the family-wide `/support`
page next to GitHub Sponsors and Buy Me a Coffee. Targets readers and
visitors of the content sites (`oriz-blog`, `oriz-books`, `oriz-me`)
who don't have a GitHub account.

## Free tier

- 0% platform fee on donations + one-off shop sales (Ko-fi's pledge)
- Payment-processor fees apply (Stripe ~2.9% + 30¢ or PayPal
  equivalent — paid by donor, not by us)
- Recurring "Ko-fi Gold" requires a paid Ko-fi tier — we do NOT use
  this; only the free tier
- No card required to receive payouts (PayPal or Stripe payout)

## Card / subscription required?

**NO.** Free-tier sign-up is email + payout method. Stripe payout
requires Stripe Connect KYC; PayPal payout just needs an existing
PayPal account.

## Methods exposed to the donor

Card (Stripe), PayPal. No UPI directly — Indian donors who want UPI
use [`upi-direct`](./upi-direct.md) instead.

## Alternatives

- [GitHub Sponsors](./github-sponsors.md) — developer-targeted
- [Buy Me a Coffee](./buymeacoffee.md) — 5% platform fee, similar UX

## Swap cost

Low — a single button on the `/support` page; deep-link is
`https://ko-fi.com/<handle>`.

## Why this is our pick

0% platform fee is unbeatable for a donations channel. Sits alongside
BMC because some donors prefer one brand over the other; the cost of
running both is just two buttons on the `/support` page.

## Cross-refs

- [Max payment methods decision](../../decisions/monetisation/max-payment-methods.md)
- [GitHub Sponsors](./github-sponsors.md)
- [Buy Me a Coffee](./buymeacoffee.md)
- [PayPal.me](./paypal-me.md)
