---
type: service
title: "Polar.sh"
description: "OSS-friendly checkout — Stripe-backed merchant-of-record for digital products + subscriptions + donations; lower fees than Lemon Squeezy."
tags: [billing, polar, oss, mor, donations, checkout]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: donation-oss
provider: polar-sh
free_tier: "Free to onboard, no monthly platform fee; 4% + 40¢ per transaction (covers Stripe + MoR fee — VAT/GST/sales-tax filing handled)"
swap_cost: medium
related:
  - decisions/monetisation/max-payment-methods
  - services/payment/lemon-squeezy
  - services/payment/github-sponsors
  - services/payment/liberapay
  - services/payment/opencollective
  - rules/no-card-on-file
---

# Polar.sh

## Role

**OSS-friendly checkout** that sits between
[Lemon Squeezy](./lemon-squeezy.md) (international MoR) and the
donation grid on the family-wide `/support` page. Targets the
"sponsor an OSS maintainer" workflow that Lemon Squeezy doesn't
naturally cover — public sponsor tiers, GitHub repo integration,
direct issue funding. Polar is itself OSS (`polarsource/polar`,
Apache-2.0) and built specifically for the sponsor / maintainer
relationship.

## Free tier

- No setup, no monthly platform fee
- Pay-per-transaction: **4% + 40¢** (lower than Lemon Squeezy's 5% + 50¢)
- Polar acts as merchant-of-record — VAT / GST / US sales-tax filing
  handled (same MoR posture as Lemon Squeezy)
- GitHub OAuth onboarding; bank/Wise/Payoneer for payouts; no
  payment method requested from us
- Public sponsor pages, tiers, one-off support, and digital-product
  checkout in one tool

## Card / subscription required?

**NO.** Free-tier sign-up is GitHub OAuth + payout method. Their cut
is withheld at settlement.

## Methods exposed to the donor

Card (any major brand), Apple Pay, Google Pay, Link, ACH (US). Same
breadth as Lemon Squeezy; lacks the PayPal / UPI rails (covered
elsewhere in the donation grid).

## Where it sits on /support

Slots **between** [Lemon Squeezy](./lemon-squeezy.md) (international
checkout) and the donation rails — explicitly tagged "OSS-friendly
checkout" so visitors looking to sponsor maintainership end up here,
visitors looking to license a product end up at LS, and visitors
looking to drop a tip end up at the
[Ko-fi](./ko-fi.md) / [BMC](./buymeacoffee.md) / [GitHub Sponsors](./github-sponsors.md) row.

## Alternatives

- [Lemon Squeezy](./lemon-squeezy.md) — broader product catalog, slightly higher fees
- [GitHub Sponsors](./github-sponsors.md) — adjacent role, GitHub-native, 0% platform but limited product surface (donations + tiers, no checkout for digital products)
- Stripe direct — no MoR (we'd owe VAT/GST/sales-tax filing ourselves)
- [Liberapay](./liberapay.md) — donation-only, recurring-only, 0% platform but no product checkout
- [Open Collective](./opencollective.md) — fiscal-host model, transparent fund accounting

## Swap cost

Medium — webhook handler in the Hono Worker is wrapped behind a
`@chirag127/billing-polar` package (planned alongside the existing
`billing-lemon-squeezy` and `billing-razorpay` modules). Swap =
re-implement webhook verifier + checkout-link generator.

## Why this is our pick

- **Lower fees than Lemon Squeezy** for the OSS sponsor / maintainer
  case (4% + 40¢ vs. 5% + 50¢)
- **GitHub-native UX** — repo integration shows sponsor tiers on the
  README badge alongside the existing GitHub Sponsors button
- **MoR coverage** matches LS — VAT / GST / US sales-tax handled
- **OSS itself** — escape hatch is real (Apache-2.0 codebase) so
  vendor-disappearance risk is bounded

## Cross-refs

- [Max payment methods decision](../../decisions/monetisation/max-payment-methods.md)
- [Lemon Squeezy (international product MoR)](./lemon-squeezy.md)
- [GitHub Sponsors (developer donations, 0% fee)](./github-sponsors.md)
- [Liberapay (recurring donations, 0% fee)](./liberapay.md)
- [Open Collective (transparent fund accounting)](./opencollective.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
