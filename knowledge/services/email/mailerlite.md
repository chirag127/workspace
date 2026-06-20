---
type: service
title: "MailerLite"
description: "Fallback marketing email / newsletter — 1K subs free."
tags: [email, newsletter, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: fallback
role: marketing-email-fallback
provider: mailerlite
free_tier: "1,000 subscribers, 12,000 emails/month, automation included"
swap_cost: low
---

# MailerLite

## Role

Documented fallback for newsletter / marketing email if Buttondown
became unavailable.

## Free tier

- 1,000 subscribers
- 12,000 emails / month
- Automation, landing pages, sign-up forms
- 1 user

## Card / subscription required?

**NO.** Free tier sign-up doesn't require a payment method, but
MailerLite does require account approval (manual review on first
campaign send).

## Alternatives

- Buttondown (primary in AGENTS.md)
- EmailOctopus (2.5K subs)
- Sender (15K emails)

## Swap cost

Low — subscriber list exports as CSV, imports into any alternative.

## Why fallback only

Buttondown's 100-sub free tier is smaller but fits today's audience.
MailerLite's 1K is for when we grow past it.

## Cross-refs

- [Resend](./resend.md) — for transactional, not marketing
