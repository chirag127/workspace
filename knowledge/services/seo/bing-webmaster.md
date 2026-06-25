---
type: service
title: "Bing Webmaster Tools"
description: "Submit sitemaps to Bing, monitor index coverage, see search-query analytics, manage IndexNow keys. Free, no card."
tags: [seo, bing, microsoft, search-console, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: search-console-bing
provider: microsoft
free_tier: "Free, unlimited sites. One-click GSC import. Sitemap submission, index coverage, query analytics, IndexNow key management."
swap_cost: low
related:
  - services/seo/astrojs-sitemap
  - services/seo/indexnow
  - services/seo/google-search-console
  - decisions/architecture/seo-three-pillars
---

# Bing Webmaster Tools

## Role

Bing's equivalent of [Google Search Console](./google-search-console.md):

- Submits sitemaps to Bing's crawler
- Reports index coverage + crawl errors
- Surfaces query analytics for Bing + DuckDuckGo (DDG uses Bing's index)
- Manages the **IndexNow key** (the same key Microsoft owns the
  protocol on; Bing's console is the canonical surface to register
  it). See [services/seo/indexnow.md](./indexnow.md).

The Yandex / Naver crawlers indirectly benefit too via IndexNow.

## Free tier

- Unlimited sites
- One-click import from Google Search Console (saves manual
  property setup for every subdomain)
- Sitemap submission, index coverage, query analytics
- IndexNow key registration + history

## Card / subscription required?

**NO.** Microsoft account; no card.

## Setup

1. Sign in with the same Google account used for GSC.
2. Use the **Import from Google Search Console** flow to bring all
   `*.oriz.in` properties over in one shot.
3. Submit each subdomain's `sitemap-index.xml`.
4. Generate IndexNow key, host at `https://<site>/<key>.txt`.

## Alternatives

- Skip Bing — works, but loses ~7% of search traffic + the
  DuckDuckGo overlap + IndexNow's canonical surface.

## Swap cost

Zero — read-only console. Removing it changes nothing on the sites.

## Why this is our pick

Bing covers ~7% of US search traffic and powers DuckDuckGo's index.
Free, one-click GSC import, and the canonical IndexNow key surface
all for the same Microsoft account.

## Cross-refs

- [SEO three pillars decision](../../decisions/architecture/seo-three-pillars.md)
- [@astrojs/sitemap](./astrojs-sitemap.md)
- [IndexNow](./indexnow.md) — key management lives here
- [Google Search Console](./google-search-console.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
