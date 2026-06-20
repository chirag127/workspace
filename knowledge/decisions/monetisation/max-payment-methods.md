---
type: decision
title: "Support every viable payment method, geo-routed"
description: "Locked decision: every paid surface accepts the maximum viable set of payment methods — Razorpay for India, Lemon Squeezy for international, keygen.sh for license fulfilment, plus six donation rails on /support."
tags: [billing, payments, india, international, donations, monetisation]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/monetisation/razorpay-as-primary-billing
  - decisions/monetisation/one-subscription-unlocks-all
  - decisions/monetisation/no-subscriptions-anywhere
  - services/payment/razorpay
  - services/payment/lemon-squeezy
  - services/payment/polar-sh
  - services/payment/keygen-sh
  - services/payment/github-sponsors
  - services/payment/ko-fi
  - services/payment/buymeacoffee
  - services/payment/liberapay
  - services/payment/opencollective
  - services/payment/paypal-me
  - services/payment/upi-direct
  - services/payment/crypto-bitcoinaddr
  - rules/no-card-on-file
---

# Support every viable payment method, geo-routed

## Decision

Every paid surface in the family accepts the **maximum viable set of
payment methods**, geo-routed at checkout. License-key fulfilment is
decoupled from the payment processor via keygen.sh. The family-wide
`/support` page exposes six donation channels in parallel so donors
pick their preferred rail.

User stated 2026-06-20: "i want to support all the payment method i
dont have any entity i will take all paynment in my personal account
in india everyhing should be done properly key gen can be there for
many other methods".

## Why

The user is an Indian-resident sole proprietor with no entity and a
personal bank account. Maximising payment-method coverage is the
cheapest growth lever (no extra cost per channel) and the constraint
to design around is "no entity" — that's why the international rail
must be merchant-of-record, not Stripe direct.

## Routing logic

| Buyer / sender | Rail | Why |
|---|---|---|
| Indian buyer (geo-detected) | [Razorpay](../../services/payment/razorpay.md) primary, [UPI Direct QR](../../services/payment/upi-direct.md) fallback on the same page | UPI is dominant; Razorpay covers UPI + cards + netbanking + wallets + EMI + pay-later |
| Non-Indian buyer | [Lemon Squeezy](../../services/payment/lemon-squeezy.md) | Merchant-of-record handles VAT/GST/sales-tax filing for a no-entity seller |
| Software-license buyer (any geo) | [keygen.sh](../../services/payment/keygen-sh.md) issues key after Razorpay/LS/Polar webhook | Decouples key fulfilment from the checkout provider |
| OSS sponsor / maintainer-funding buyer (any geo) | [Polar.sh](../../services/payment/polar-sh.md) — slots between LS and the donations grid as "OSS-friendly checkout" (4% + 40¢ MoR) | Lower fees than LS for the OSS sponsor case + GitHub-native UX |
| Donation / tip (any geo) | [GitHub Sponsors](../../services/payment/github-sponsors.md) + [Ko-fi](../../services/payment/ko-fi.md) + [Buy Me a Coffee](../../services/payment/buymeacoffee.md) + [Liberapay](../../services/payment/liberapay.md) + [Open Collective](../../services/payment/opencollective.md) + [PayPal.me](../../services/payment/paypal-me.md) + [UPI Direct QR](../../services/payment/upi-direct.md) + [crypto addresses](../../services/payment/crypto-bitcoinaddr.md) ALL displayed on `/support` | Maximum donor choice; cost of running each is a single button |

## Methods covered (cumulative)

Razorpay alone covers: UPI, Visa / Mastercard / RuPay / Amex,
netbanking (60+ banks), wallets (PhonePe / Paytm / Mobikwik / Amazon
Pay / Freecharge), card EMI, no-cost EMI, pay-later (Simpl / LazyPay
/ ICICI Pay Later). Lemon Squeezy adds: international cards, Apple
Pay, Google Pay, PayPal. Polar.sh adds the OSS-sponsor surface
(GitHub-integrated tiers + product checkout) at 4% + 40¢ — lower
than LS, same MoR posture. Donations add: PayPal F&F, BTC, ETH,
USDC, recurring weekly/monthly via Liberapay (0% platform), and
public-ledger sponsorship via Open Collective (transparent fund
accounting). Static UPI QR adds: any UPI app at zero fee for donations.

## 2026-06-20 update — added Polar.sh + Liberapay + Open Collective

`/support` now lists **all 12 rails**. Polar.sh slots between
[Lemon Squeezy](../../services/payment/lemon-squeezy.md) and the
donations grid as "OSS-friendly checkout" — same MoR posture as LS
but with lower fees (4% + 40¢ vs. 5% + 50¢) and GitHub-native UX
better suited to maintainer-sponsorship workflows.
[Liberapay](../../services/payment/liberapay.md) and
[Open Collective](../../services/payment/opencollective.md) sit
alongside [GitHub Sponsors](../../services/payment/github-sponsors.md) /
[Ko-fi](../../services/payment/ko-fi.md) /
[Buy Me a Coffee](../../services/payment/buymeacoffee.md) in the
donations grid — Liberapay covers recurring-donation-only at 0% fee
(EU-friendly via SEPA), and Open Collective is the only rail with a
public expense ledger and US 501(c)(6) tax receipts via the Open
Source Collective fiscal host. Together they bring rail count from 9
to 12.

## Implications

- Geo-detect at checkout time on every paid surface — Cloudflare's
  `cf-ipcountry` header is sufficient (free, no extra service).
- Webhook handlers exist for both Razorpay AND Lemon Squeezy on the
  Hono Worker; both call keygen.sh to mint keys for license-key
  products.
- The family-wide `/support` page is a `<Support />` component shipped
  in `@chirag127/oriz-kit` — single-source-of-truth so adding a
  channel updates every site at once.
- **NO card-on-file anywhere.** No recurring auto-charge that
  requires a stored card. UPI auto-pay (e-Mandate via Razorpay) is
  consent-based per-transaction, NOT card-on-file — this is the only
  recurring rail allowed. See [no-card-on-file rule](../../rules/no-card-on-file.md).
- Crypto receipts are tax-reportable under Indian Section 115BBH
  (30% flat + 1% TDS); track inbound for annual filing.
- PayPal.me inbound to a personal account from international senders
  triggers FEMA/RBI reporting once aggregate crosses thresholds —
  track for filing.
- UPI Direct inbound > ₹10L/year into a personal account triggers
  income-tax scrutiny — track and report under "income from
  donations / professional receipts".

## Cross-refs

- [Razorpay as primary billing](./razorpay-as-primary-billing.md)
- [ONE subscription unlocks everything](./one-subscription-unlocks-all.md)
- [No subscriptions anywhere](./no-subscriptions-anywhere.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
- [`-ext` suffix glossary](../../glossary/d-h/extension-suffix.md)
- [AGENTS.md "Where to look in `knowledge/`"](../../../AGENTS.md)
