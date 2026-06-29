---
type: policy
title: "Monetisation — AdSense apex, no ad-slot divs"
description: Single AdSense for apex. No ad-slot divs, runtime inject
tags: [policy, monetisation, ads, adsense]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
annual_review: false
related:
  - policy/commercial-use
  - policy/no-paid-tier
  - services/adsense
---

# Monetisation — AdSense apex, no ad-slot divs

## The policy

One AdSense application covers the `oriz.in` apex and every
`*.oriz.in` subdomain by inheritance; site markup contains zero
reserved ad rectangles, so the layout reads as organic content first
and an ad provider fills available space at runtime.

## Scope

- All 11+ `*.oriz.in` sites.
- The `oriz.in/extensions` cross-promo route and the future
  `extensions.oriz.in` catalog.
- Any future site added under the apex.
- Does NOT cover individual extensions' in-product surfaces.

## Rules

- **Single AdSense application.** Apply once for `oriz.in`. Per AdSense
  2026 rules, all `*.oriz.in` subdomains inherit the approval — there
  is no per-subdomain application option.
- **No ad-slot divs in markup.** Sites have organic content layout that
  AdSense fills around. Never reserve empty rectangles, sidebars
  labelled "ad", or fixed-height "advertisement" containers.
- **Runtime injection only.** The AdSense / Ezoic / Mediavine
  `<script>` tag is the entire integration surface. The provider's
  auto-ad logic decides placement; sites do not call `adsbygoogle.push`
  by hand.
- **Fallback ad providers.** If AdSense rejects, the failover order is
  Ezoic → Mediavine → Raptive (formerly AdThrive). Each is integrated
  the same way: one script tag, no slot divs, runtime injection.
- **Extension landing pages count as content.** Per
  [`./commercial-use.md`](./commercial-use.md), describing a paid
  extension on a landing page is content + portfolio, not commerce —
  AdSense-eligible.
- **No advertorials, no affiliate-as-content.** Affiliate links are
  permitted in body copy where genuinely useful but never disguised as
  editorial recommendations or laid out as "ads" in the page chrome.

## Exceptions

- **`api.oriz.in`.** The Hono Worker serves no HTML and carries no ads.
- **Auth pages at `auth.oriz.in`.** No ads on the auth handoff route —
  Firebase Auth's iframe behavior plus AdSense scripts is a
  cross-origin-headache the family does not need.
- **Age-gated pages.** AdSense forbids serving on adult-rated pages.
  Pages tagged `<meta name="rating" content="adult">` skip the script
  injection.

## Annual review

Not on the annual cycle — re-evaluate on AdSense / Ezoic / Mediavine
policy change announcements (which arrive ad-hoc), not on the calendar.

## Cross-refs

- [`./commercial-use.md`](./commercial-use.md) — what counts as commercial intent on each host
- [`./no-paid-tier.md`](./no-paid-tier.md) — the rule that makes ads (not subscriptions) the monetisation path
- `../../AGENTS.md` § Monetisation — apex source-of-truth section
