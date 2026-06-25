---
type: service
title: "Resend"
description: "Transactional email API — 3K/month free, isolated behind @chirag127/email-send."
tags: [email, transactional, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: transactional-email
provider: resend
free_tier: "3,000 emails/month, 100/day, 1 verified domain"
swap_cost: low
---

# Resend

## Role

Sends transactional email — sign-in links, receipts, contact-form
auto-replies. Wrapped behind `@chirag127/email-send`.

## Free tier

- 3,000 emails / month
- 100 emails / day cap
- 1 verified sending domain
- Unlimited team members

## Card / subscription required?

**NO.** Free tier sign-up requires only an email-verified account
plus DNS verification on the sending domain. No payment method on
file. Audit confirms.

## Alternatives

- AhaSend (1K/mo, unlimited domains)
- Brevo (9K/mo)
- Maileroo
- MailerSend

## Swap cost

Low — all alternatives expose a similar `from / to / subject / html`
REST API. The `@chirag127/email-send` wrapper hides the difference.

## Why this is our pick

Cleanest API, fastest sandbox-to-production path, React-email
integration is a nice-to-have we may use.

## Cross-refs

- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [MailerLite](./mailerlite.md) — for marketing email, not transactional
