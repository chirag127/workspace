---
type: service
title: "Tally.so"
description: "Rich form builder — surveys, waitlists, payment collection. Unlimited forms + submissions free."
tags: [forms, surveys, waitlist, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: rich-form-builder
provider: tally
free_tier: "Unlimited forms, unlimited submissions, unlimited email notifications, form logic, file upload"
swap_cost: medium
---

# Tally.so

## Role

Backs rich, multi-field forms across the family — surveys, waitlists,
feedback collection, payment-collecting forms, anything that needs
conditional logic, file upload, or multi-step flow. Complements
[Web3Forms](./web3forms.md), which stays as the simple
contact-form backend.

## Free tier

- Unlimited forms
- Unlimited submissions
- Unlimited email notifications
- Form logic (conditional branching)
- File upload
- Custom domains, embeds, integrations

## Card / subscription required?

**NO.** Free tier sign-up is email-only. No payment method requested,
no trial expiry.

## Alternatives

- Typeform (paid past 10 responses/mo — rejected)
- Google Forms (works but visually inconsistent with the family)
- [Formspree](./formspree.md) — POST-only, no UI builder
- Fillout, Youform

## Swap cost

Medium — Tally hosts the form UI, so swapping means rebuilding the
form in another tool and updating the embed URL. Submissions export
as CSV for migration.

## Why this is our pick

The only "rich form" tool with an unconditionally-free unlimited tier
that doesn't require a card. Submission cap on Typeform's free tier
made it unusable; Tally's free tier is functionally the paid tier of
most competitors.

## Cross-refs

- [Web3Forms](./web3forms.md) — simple contact forms only
- [Data canonical store policy](../../decisions/policy/data-canonical-store.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
