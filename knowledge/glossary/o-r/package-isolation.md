---
type: glossary
title: "package isolation"
description: Wrap external service in typed package; swapping providers = version bump, not rewrite
tags: [glossary, rule, packages]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# package isolation

## Definition

The package-isolation rule states that every external service the
family depends on must be wrapped in a typed package, so swapping
providers is a single package version bump rather than a per-site
rewrite.

## Expanded

Examples already in the family: `@chirag127/firebase-init` wraps
Firebase (swap for Supabase = swap the package); `@chirag127/contact-form`
wraps Web3Forms (swap for Formspree = swap the package). Planned:
`@chirag127/email-send` for Resend, `@chirag127/ratelimit-recaptcha`
for reCAPTCHA Enterprise, `@chirag127/billing-razorpay` for Razorpay.

The trigger: any new external service that crosses 3+ sites' boundary
gets a package wrapping it on first introduction. This pairs with the
service catalog's "swap cost" column — the rule's job is to keep that
column "Low" or "Medium" forever.

## See also

- <!-- TODO: broken link, was [oriz-kit](./oriz-kit.md) -->
- [hono-rpc](../d-h/hono-rpc.md)
