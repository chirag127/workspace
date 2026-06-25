---
type: service
title: "Google Search Console"
description: "Submit sitemaps to Google, monitor index coverage, see search-query analytics, get spam / manual-action notices. Free, no card."
tags: [seo, google, search-console, monitoring, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: search-console-google
provider: google
free_tier: "Free, unlimited properties. DNS-record or HTML-file ownership verification. Sitemap submission, index coverage, query analytics, Core Web Vitals report, Rich Results report."
swap_cost: low
related:
  - services/seo/astrojs-sitemap
  - services/seo/json-ld-structured-data
  - services/seo/bing-webmaster
  - decisions/architecture/seo-three-pillars
  - services/auth/firebase-spark
---

# Google Search Console

## Role

Lets the family **see** how Google indexes every site:

- Submits the sitemap (`https://<site>/sitemap-index.xml`) to Google's crawler
- Reports index coverage, errors, redirects, soft 404s
- Surfaces top search queries, CTR, average position
- Validates JSON-LD via the **Rich Results** tab
- Notifies of manual actions / spam flags

Each `*.oriz.in` subdomain is a separate property; the apex
`oriz.in` is verified at the Domain-property level (one DNS TXT
record covers every subdomain too).

## Free tier

- Unlimited properties
- Domain-property verification via Cloudflare DNS TXT record (one
  record covers every subdomain — fits well with the family's
  Cloudflare DNS setup per
  [`decisions/infrastructure/spaceship-registrar-cloudflare-dns.md`](../../decisions/infrastructure/spaceship-registrar-cloudflare-dns.md))
- 16-month query history
- Core Web Vitals report driven by Chrome UX Report data

## Card / subscription required?

**NO.** Standard Google account, no Cloud Billing link, no card.

## Setup

1. Add Domain property `oriz.in` (covers every subdomain).
2. Verify via Cloudflare DNS TXT record (`_google-site-verification`).
3. Submit `https://oriz.in/sitemap-index.xml` and
   `https://<each-subdomain>/sitemap-index.xml`.
4. Check Index Coverage weekly, Rich Results monthly.

## Alternatives

- None for Google's index — GSC is the only first-party surface.
- Third-party SEO tools (Ahrefs / Semrush) infer Google data but
  cost money and don't replace GSC's manual-action notices.

## Swap cost

Zero — GSC is a read-only console; abandoning it doesn't change
anything on the sites. Re-adding a property later is a few
minutes.

## Why this is our pick

It's the only first-party Google index surface. Free,
domain-verifies once for every subdomain, no card.

## Cross-refs

- [SEO three pillars decision](../../decisions/architecture/seo-three-pillars.md)
- [@astrojs/sitemap](./astrojs-sitemap.md) — what GSC ingests
- [JSON-LD](./json-ld-structured-data.md) — what GSC's Rich Results report reads
- [Bing Webmaster](./bing-webmaster.md) — same role, different engine
- [Cloudflare DNS](../domain/cloudflare-dns.md) — TXT verification lives here
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
