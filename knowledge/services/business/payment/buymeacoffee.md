---
type: service
title: "Buy Me a Coffee"
description: "Creator donations — 5% fee, no subscription, alongside Ko-fi"
tags: [donations, buymeacoffee, creator]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: donations-creator
provider: buymeacoffee
free_tier: "5% platform fee on transactions; no monthly fee, no setup fee"
swap_cost: low
related:
  - monetisation/max-payment-methods
  - services/business/payment/ko-fi
  - services/business/payment/github-sponsors
---

# Buy Me a Coffee

## Role

Second "creator" donation channel — on the family-wide `/support`
page next to Ko-fi. Some donors strongly prefer one brand; the cost
of running both is two buttons.

## Free tier

- No monthly fee, no setup fee
- 5% platform fee on transactions (donor-side processing fees on top)
- Stripe + PayPal payouts; payouts in INR, USD, or other supported
  currencies
- Membership tiers, one-off "coffees", and a built-in shop on the
  free plan

## Card / subscription required?

**NO.** Email-only sign-up; payout via Stripe Connect or PayPal. No
card on file from us.

## Methods exposed to the donor

Card (Stripe), Apple Pay, Google Pay, PayPal. No UPI — Indian donors
who want UPI use [`upi-direct`](./upi-direct.md) instead.

## Alternatives

- [Ko-fi](./ko-fi.md) — 0% platform fee, otherwise similar
- [GitHub Sponsors](./github-sponsors.md) — developer-targeted, 0%

## Swap cost

Low — single button on the `/support` page; deep-link is
`https://buymeacoffee.com/<handle>`.

## Why this is our pick

Brand recognition is meaningfully different from Ko-fi's; some donors
will only use one or the other. 5% is acceptable as a "long tail"
channel — the marginal donation lost to fees is still strictly better
than not having the button.

## Cross-refs

- [Max payment methods decision](../../monetisation/max-payment-methods.md)
- [Ko-fi](./ko-fi.md)
- [GitHub Sponsors](./github-sponsors.md)
- [PayPal.me](./paypal-me.md)
