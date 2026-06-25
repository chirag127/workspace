---
type: service
title: "Liberapay"
description: "Recurring-donation-only platform — weekly/monthly donations, 0% platform fee, OSS, no card."
tags: [donations, liberapay, recurring, oss]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: donation-recurring
provider: liberapay
free_tier: "Free forever — Liberapay takes 0% platform fee; payment-processor fees apply (Stripe / PayPal as the donor's processor)"
swap_cost: low
related:
  - decisions/monetisation/max-payment-methods
  - services/payment/github-sponsors
  - services/payment/ko-fi
  - services/payment/buymeacoffee
  - services/payment/polar-sh
  - services/payment/opencollective
---

# Liberapay

## Role

**Recurring-donations-only** rail on the family-wide `/support` page.
Sits in the donations grid alongside
[GitHub Sponsors](./github-sponsors.md), [Ko-fi](./ko-fi.md), and
[Buy Me a Coffee](./buymeacoffee.md). Liberapay is donation-only by
design — no products, no perks, no tiers — which makes it the
cleanest fit for "I just want to give the maintainer a few euros a
week" without any expectation of return.

## Free tier

- 0% platform fee, forever — Liberapay is itself a non-profit
  (`Liberapay` ASBL) funded by Liberapay donations
- Payment-processor fees apply (Stripe ~2.9% + 30¢ or PayPal
  equivalent, paid by the donor — not by us)
- Recurring weekly / monthly / yearly donations with caps optionally
  configurable
- OSS codebase (`liberapay/liberapay.com`, AGPL-3.0)
- Multi-currency (EUR / USD / GBP / etc.)

## Card / subscription required?

**NO.** Free-tier sign-up is email + payout method (Stripe Express
Connect, PayPal, or SEPA bank transfer for EU). No payment method
requested from us.

## Methods exposed to the donor

Card (Stripe), PayPal. SEPA direct debit for EU donors. Donor sets
the recurrence schedule themselves; the payment is consent-based
per-transaction (the donor's processor authorises each charge,
Liberapay never stores card-on-file on our side).

## Alternatives

- [GitHub Sponsors](./github-sponsors.md) — also 0% platform, GitHub-native; covers similar audience
- [Ko-fi](./ko-fi.md) — 0% platform, broader UX (one-off + shop + memberships)
- [Buy Me a Coffee](./buymeacoffee.md) — 5% platform fee, similar UX
- [Polar.sh](./polar-sh.md) — adjacent (subscriptions + products with MoR)
- [Open Collective](./opencollective.md) — transparent fund accounting, fiscal-host model

## Swap cost

Low — single button on `/support`; deep-link is `https://liberapay.com/<handle>/donate`. No webhook integration required for the donation itself (Liberapay handles delivery + receipts).

## Why this is our pick

- **0% platform fee** — Liberapay is itself a non-profit, no
  margin-extraction
- **Donation-only by design** — donors who pick Liberapay self-select
  out of any product expectation, which is the cleanest motivation
  alignment we can offer
- **OSS codebase** — escape hatch is real (AGPL-3.0 source available)
- **Mature** (founded 2015) and stable; small but reliable platform
- **EU-friendly** — SEPA direct debit support broadens the donor
  base into Europe at lower cost than card processing

## Quirks worth knowing

- Donations are **paid forward** — Liberapay holds donor funds and
  pays out to the recipient on a weekly schedule. There's a small
  delay between donation and payout.
- Liberapay does **not** issue tax receipts — donors who need
  receipts for charitable deduction should use Open Collective via
  an aligned fiscal host.

## Cross-refs

- [Max payment methods decision](../../decisions/monetisation/max-payment-methods.md)
- [GitHub Sponsors (also 0% fee)](./github-sponsors.md)
- [Ko-fi (also 0% fee, broader UX)](./ko-fi.md)
- [Buy Me a Coffee (5% fee, similar UX)](./buymeacoffee.md)
- [Polar.sh (OSS-friendly checkout)](./polar-sh.md)
- [Open Collective (transparent fund accounting)](./opencollective.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
