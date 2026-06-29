---
type: service
title: "Lemon Squeezy"
description: "MoR checkout for non-Indian buyers — auto VAT/GST, card + Apple Pay"
tags: [billing, lemon-squeezy, mor, international, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: subscription-billing-international
provider: lemon-squeezy
free_tier: "No monthly platform fee — pay-per-transaction (5% + 50¢ per charge); MoR fee covers VAT/GST/sales-tax filing"
swap_cost: medium
related:
  - monetisation/razorpay-as-primary-billing
  - monetisation/max-payment-methods
  - services/business/payment/razorpay
  - rules/no-card-on-file
---

# Lemon Squeezy

## Role

International billing for **non-Indian buyers**. Geo-detected at
checkout: India routes to [Razorpay](./razorpay.md), everything else
routes here. Lemon Squeezy is **merchant-of-record (MoR)** — they
collect, remit, and file VAT / GST / US-state sales tax on our behalf,
which is the only tractable way for a sole-proprietor with no entity
to sell software internationally.

## Methods supported

Credit + debit cards (Visa / Mastercard / Amex / Discover / JCB),
Apple Pay, Google Pay, PayPal (via Lemon Squeezy account, not
required of the buyer). No card-on-file required for one-off
license-key purchases.

## Free tier

- No setup, no monthly platform fee
- Pay-per-transaction (5% + 50¢ per charge — includes the MoR fee)
- Free dashboard, free webhooks, free test-mode

The MoR fee is bundled into the 5% — they handle VAT registration,
quarterly filing, and reverse-charge invoicing. For an Indian sole
proprietor with no foreign tax presence, this fee is cheaper than the
accountant-time it replaces.

## Card / subscription required?

**NO** to use the dashboard or test mode. Onboarding needs only
business name, bank account / Wise / Payoneer for payouts, and a
tax-residency declaration. No card on file from us; their cut is
withheld at settlement.

## Alternatives

- Stripe (fallback if LS rejects the merchant — but no MoR, we'd owe
  VAT/GST filing ourselves)
- Paddle (MoR, similar story to LS, slightly higher fees)
- Razorpay International (still routes through India settlement —
  worse FX + slower payouts)

## Swap cost

Medium — the webhook handler in the Hono Worker is wrapped behind a
`@chirag127/billing-lemon-squeezy` package (planned). Swap = re-impl
webhook verifier + the checkout link generator.

## Why this is our pick

The MoR model removes every international-tax obstacle for an
Indian-resident sole proprietor. Stripe and Paddle exist as fallbacks;
Razorpay International was rejected because it still books revenue
into India FX (worse rates, GST exposure on cross-border digital
services).

## Cross-refs

- [Razorpay (India primary)](./razorpay.md)
- [Max payment methods decision](../../monetisation/max-payment-methods.md)
- [Razorpay as primary billing](../../monetisation/razorpay-as-primary-billing.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
