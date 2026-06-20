---
type: service
title: "PayPal.me"
description: "Personal PayPal payment-link — friends-and-family free, goods-and-services percent fee."
tags: [donations, paypal, p2p, payout]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: p2p-payout
provider: paypal
free_tier: "Free for personal F&F transfers; percent fee for goods-and-services"
swap_cost: low
related:
  - decisions/monetisation/max-payment-methods
  - services/payment/github-sponsors
  - services/payment/ko-fi
---

# PayPal.me

## Role

Personal payout link for international tippers, donations, and
client-side direct payments where the donor explicitly wants PayPal.
Lives on the family-wide `/support` page alongside the donation
buttons. Personal PayPal account, not a business account — keeps
onboarding zero-friction.

## Free tier

- Free for personal "friends and family" transfers (sender pays no
  fee within their currency; cross-border may have FX fee)
- Goods-and-services transfers: ~3.49% + fixed fee (paid by sender)
- No monthly fee, no card-on-file from us required
- Inbound payouts to bank account via standard PayPal withdrawal

## Card / subscription required?

**NO.** Standard personal PayPal account. Bank account linked for
withdrawal.

## Methods exposed to the sender

PayPal balance, card, bank transfer (depending on sender's country).

## Caveats

- "Friends and family" cannot be used for goods/services per PayPal's
  ToS — donations to a creator are in a grey zone. Use the G&S flow
  for license-key sales (those go through
  [Lemon Squeezy](./lemon-squeezy.md) instead anyway).
- Receiving from India to a personal PayPal account has FEMA / RBI
  reporting expectations — track inbound for tax-filing.

## Alternatives

- [GitHub Sponsors](./github-sponsors.md) — for repo-linked donations
- [Ko-fi](./ko-fi.md) — Stripe + PayPal in one button

## Swap cost

Low — single link on `/support`. Deep-link is
`https://paypal.me/<handle>`.

## Why this is our pick

Some international tippers will only use PayPal. Costs nothing to
leave on; the link is just text.

## Cross-refs

- [Max payment methods decision](../../decisions/monetisation/max-payment-methods.md)
- [Lemon Squeezy](./lemon-squeezy.md)
- [GitHub Sponsors](./github-sponsors.md)
- [Ko-fi](./ko-fi.md)
