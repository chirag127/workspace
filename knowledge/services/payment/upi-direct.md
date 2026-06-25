---
type: service
title: "UPI Direct (static QR)"
description: "Static UPI QR + handle for Indian-resident inbound — zero fees, instant settlement."
tags: [donations, upi, india, p2p]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: p2p-india-direct
provider: upi
free_tier: "Free forever — UPI is zero-fee P2P infrastructure (NPCI), no platform fee"
swap_cost: low
related:
  - decisions/monetisation/max-payment-methods
  - services/payment/razorpay
  - rules/no-card-on-file
---

# UPI Direct (static QR)

## Role

Zero-fee donation channel for Indian-resident senders. Sits on the
family-wide `/support` page as a static QR + payee-handle (e.g.
`chirag127@axl`-style VPA). Distinct from
[Razorpay](./razorpay.md): Razorpay is for paid-product checkout
(license keys, subscriptions); this is for one-tap tips and
donations where we'd rather skip the 2-3% Razorpay fee entirely.

## Free tier

- Zero platform fee — UPI is NPCI infrastructure, not a vendor
- Instant settlement to linked bank account (24×7)
- No KYC layer beyond the bank account that backs the VPA
- Static QR + handle work in every UPI app (PhonePe, GPay, Paytm,
  BHIM, banking apps)

## Card / subscription required?

**NO.** Just a personal bank account linked to a UPI handle (any
major Indian bank app issues one in minutes).

## Methods exposed to the sender

Any UPI app. The sender's app handles their own card / wallet / bank
choice — we just receive UPI credit.

## Inbound-only

Indian-resident inbound only. UPI does not support cross-border
inbound (NRIs can send via NRO/NRE accounts, but international donors
use [PayPal.me](./paypal-me.md) or
[Buy Me a Coffee](./buymeacoffee.md) instead).

## Caveats

- Annual aggregate inbound > ₹10L into a personal account triggers
  income-tax scrutiny — track and report under "income from
  donations / professional receipts".
- No webhook / programmatic notification on a static QR — for
  programmatic confirmations of paid-product purchases, route through
  Razorpay (which DOES emit webhooks on UPI charges).

## Alternatives

- [Razorpay](./razorpay.md) — adds a 2-3% fee but gives a webhook +
  invoice trail (use this for paid products, not tips)

## Swap cost

Low — single QR image + handle text on the `/support` page.

## Why this is our pick

Zero fee, instant, and the dominant payment rail in India. Pairing it
with Razorpay on the same page means donors who want a receipt go
through Razorpay; donors who just want to tip go through the static
QR with no platform cut.

## Cross-refs

- [Max payment methods decision](../../decisions/monetisation/max-payment-methods.md)
- [Razorpay](./razorpay.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
