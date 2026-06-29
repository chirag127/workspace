---
type: service
title: "Web3Forms"
description: "Browser-only contact form backend — domain-bound key, no server, free unlimited"
tags: [forms, contact, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: contact-form-backend
provider: web3forms
free_tier: "Unlimited submissions, unlimited domains per key, 1 access key per email"
swap_cost: low
---

# Web3Forms

## Role

Backs the `<ContactForm>` component on every site. The access key is
domain-bound so it can ship in client JS without leaking server
credentials.

## Free tier

- Unlimited submissions
- Unlimited domains per access key
- Email forwarding included
- Spam protection (hCaptcha optional)

## Card / subscription required?

**NO.** Sign-up is email-only — Web3Forms emails the access key after
verifying the address. No payment method requested.

## Alternatives

- [Formspree](./formspree.md) — fallback
- Formspark
- FormKeep
- Pageclip

## Swap cost

Low — same form-POST shape, swap the `action` URL and the key field
name. Wrapped behind `@chirag127/contact-form`.

## Why this is our pick

Truly free, browser-only, domain-binding means no server token to
leak, and the spam protection is good enough out of the box.

## Cross-refs

- [Formspree](./formspree.md) — fallback
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
