---
type: policy
title: "Commercial-use boundaries per host"
description: Commercial use defined. Checkout on api/razorpay, never landing
tags: [policy, commercial, hosting, terms-of-service]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
annual_review: true
related:
  - policy/monetisation
  - policy/no-paid-tier
  - architecture/api-umbrella-hono-worker
---

# Commercial-use boundaries per host

## The policy

Every host the family uses defines "commercial intent" differently;
landing pages stay on the content + portfolio side of every host's
line, and the actual checkout (card capture, subscription confirm,
webhook receipt) happens only on `api.oriz.in` or on Razorpay's own
domain.

## Scope

- All sites on Cloudflare Pages.
- All extension landing pages on GitHub Pages.
- The apex `oriz.in` and the `extensions.oriz.in` catalog.
- `api.oriz.in` (the Hono Worker).
- Any future migration of these to alternative hosts in the
  service-catalog fallback list.

## Rules

- **Cloudflare Pages.** Free for any site type including ad-monetised
  content + utilities + portfolio. No commercial-use wall. The 11+
  primary `*.oriz.in` sites all live here.
- **GitHub Pages — content + portfolio + extension landing pages: OK.**
  Per their TOS, GitHub Pages allows ad-monetised content sites and
  describing paid Chrome extensions. The checkout happens inside the
  extension or on Razorpay, not on the landing page, so the page is
  content + portfolio not commerce.
- **GitHub Pages — primarily-commerce sites: NOT OK.** Per their TOS,
  sites "primarily directed at facilitating commercial transactions or
  SaaS" are prohibited. Pure storefronts, B2B SaaS dashboards, or
  pages whose primary purpose is to capture payment do not host on
  GitHub Pages.
- **Extension landing pages count as content.** Describing a paid
  Chrome / Firefox / Edge extension on a landing page is content +
  portfolio + cross-promo, not commerce. The checkout happens inside
  the extension UI or on Razorpay's hosted page.
- **Razorpay checkout flows.** The user is redirected to Razorpay's
  hosted Checkout page or to a route on `api.oriz.in` that proxies
  through Razorpay. Card details never touch a Cloudflare Pages or
  GitHub Pages route.
- **Webhooks land on `api.oriz.in`.** The Razorpay webhook handler at
  `apps/api/src/routes/razorpay/` validates signatures and writes
  entitlement to Firestore. No site directly receives a webhook.
- **AdSense + content.** Per [`./monetisation.md`](./monetisation.md),
  an ad-monetised content site is *not* a commerce site under any of
  these hosts' definitions. Ads are revenue from content, not
  commercial transactions on the site.

## Exceptions

- **Free trials with upgrade prompts.** A site that prominently
  prompts "buy now" on every page risks tipping into "primarily
  commerce" on GitHub Pages. Such pages either move to Cloudflare
  Pages or get rebalanced toward content.
- **Future paid product pages.** If a future site is a primarily-paid
  product (a B2B dashboard, a SaaS console), it goes on Cloudflare
  Pages, not GitHub Pages, and bypasses this policy's GitHub Pages
  rules entirely.

## Annual review

Each year, re-read the GitHub Pages, Cloudflare Pages, and AdSense
TOS for changes to the commercial-intent / acceptable-use clauses.
The wording moves; the boundary moves with it.

## Cross-refs

- [`./monetisation.md`](./monetisation.md) — AdSense apex application that depends on this boundary holding
- [`./no-paid-tier.md`](./no-paid-tier.md) — explains why no subscription wall exists upstream
- [`../architecture/api-umbrella-hono-worker.md`](../architecture/api-umbrella-hono-worker.md) — where checkout webhooks and proxies live
