---
type: service
title: "GitHub Sponsors"
description: "GitHub-native developer donations — zero platform fees"
tags: [donations, github-sponsors, developer]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: donations-developer
provider: github
free_tier: "Free forever — GitHub takes 0% from donations; Stripe payment-processing fees still apply"
swap_cost: low
related:
  - monetisation/max-payment-methods
  - services/business/payment/ko-fi
  - services/business/payment/buymeacoffee
---

# GitHub Sponsors

## Role

The "developer" donation channel for the family. Linked from every
repo's `FUNDING.yml`, every README, and the family-wide `/support`
page. Targets GitHub-using developers who already trust the GitHub
checkout flow.

## Free tier

- 0% platform fee from GitHub (forever, per their developer pledge)
- Recurring monthly tiers + one-off donations
- Stripe handles payment processing (standard ~2.9% + 30¢, paid by
  the sponsor not us)
- Direct payout to bank account; KYC via Stripe Connect

## Card / subscription required?

**NO.** Sponsors-account onboarding needs identity + bank-account
verification (via Stripe Connect) but no card on file from us.

## Methods exposed to the donor

Card (any major brand). No UPI / Google Pay / Apple Pay / PayPal —
that's the Ko-fi / Buy Me a Coffee / PayPal.me job.

## Alternatives

- [Ko-fi](./ko-fi.md) — broader donor demographic, 0% platform fee
- [Buy Me a Coffee](./buymeacoffee.md) — 5% platform fee, similar UX
- Open Collective — fiscal-host model, requires entity (we have none)

## Swap cost

Low — `FUNDING.yml` line in each repo is the only integration point.

## Why this is our pick

Zero platform fee + GitHub-native badge on every repo means it costs
nothing to leave on. Coexists with Ko-fi / BMC / PayPal.me on the
`/support` page so donors pick their preferred channel.

## Cross-refs

- [Max payment methods decision](../../monetisation/max-payment-methods.md)
- [Ko-fi](./ko-fi.md)
- [Buy Me a Coffee](./buymeacoffee.md)
- [PayPal.me](./paypal-me.md)
