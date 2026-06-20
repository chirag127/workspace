---
type: service
title: "Formspree"
description: "Fallback contact-form backend — 50 submissions/month free."
tags: [forms, contact, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: fallback
role: contact-form-fallback
provider: formspree
free_tier: "50 submissions/month, 1 form, file uploads, email notifications"
swap_cost: low
---

# Formspree

## Role

Documented fallback if Web3Forms became unavailable or its rate
limits changed.

## Free tier

- 50 submissions / month
- 1 form
- File uploads + email notifications
- Spam filtering (Akismet)

## Card / subscription required?

**NO.** Free tier sign-up is email-only.

## Alternatives

- [Web3Forms](./web3forms.md) — primary
- Formspark, FormKeep, Pageclip

## Swap cost

Low — same form-POST pattern; the wrapper package
`@chirag127/contact-form` swaps backend in one place.

## Why fallback only

50 submissions/month is meaningfully tighter than Web3Forms' unlimited.

## Cross-refs

- [Web3Forms](./web3forms.md) — primary
