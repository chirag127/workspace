---
type: index
title: "SEO services"
description: "The SEO stack across the family — sitemap (Astro plug), IndexNow (instant), JSON-LD (structured), three-format feeds (RSS + Atom + JSON Feed), Google Search Console + Bing Webmaster (consoles)."
tags: [services, seo, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# SEO services

The family's SEO posture is built on **three pillars** (locked in
[`decisions/architecture/seo-three-pillars.md`](../../decisions/architecture/seo-three-pillars.md))
plus **two consoles** that monitor the result, plus a **three-format
feed publishing strategy** (locked in
[`decisions/architecture/feeds-rss-atom-json.md`](../../decisions/architecture/feeds-rss-atom-json.md)).
All layers are free and require no card.

## The five SEO layers

| Layer | Service | Status | Role |
|---|---|---|---|
| Pillar 1 — discovery | [astrojs-sitemap.md](./astrojs-sitemap.md) | active | Generates `sitemap.xml` at `astro build` time |
| Pillar 2 — instant indexing | [indexnow.md](./indexnow.md) | active | Pings Bing + Yandex + Seznam + Naver on publish (via oriz-omnipost) |
| Pillar 3 — semantic markup | [json-ld-structured-data.md](./json-ld-structured-data.md) | active | Schema.org JSON-LD via `<JsonLd>` in oriz-kit |
| Console — Google | [google-search-console.md](./google-search-console.md) | active | Sitemap submission + index monitoring |
| Console — Bing/DDG | [bing-webmaster.md](./bing-webmaster.md) | active | Sitemap submission + IndexNow key management |

## Three-format feed publishing

Every content-bearing site publishes **three feed formats** so we
never lose a subscriber to a format gap:

| Path | Format | Service file |
|---|---|---|
| `/rss.xml` | RSS 2.0 (canonical, source-of-truth for `oriz-omnipost`) | (Astro built-in / oriz-kit helper) |
| `/atom.xml` | Atom 1.0 (RFC 4287) | [atom-feed.md](./atom-feed.md) |
| `/feed.json` | JSON Feed v1.1 (jsonfeed.org) | [json-feed.md](./json-feed.md) |

`@chirag127/oriz-kit` ships a `<FeedDiscovery />` component that
injects all three `<link rel="alternate">` tags, plus
`generateAtomFeed()` / `generateJsonFeed()` helpers that consume the
same `Post[]` shape as the RSS generator.

RSS 2.0 stays the source-of-truth for [oriz-omnipost](../../glossary/o-r/omnipost.md)
cross-posting (locked in
[`decisions/architecture/cross-post-engine.md`](../../decisions/architecture/cross-post-engine.md));
Atom + JSON Feed are for human readers / modern feed tooling.

## Why all five SEO layers + three feeds

Each layer covers a different failure mode:

- **Sitemap alone** is slow — Google can take days to revisit.
- **IndexNow alone** ignores Google entirely.
- **JSON-LD alone** doesn't tell engines about new URLs.
- **Consoles alone** don't push, only observe.
- **One feed format alone** loses subscribers using a reader that
  only auto-discovers another format.

Together they form a discovery → instant-ping → semantic-context →
syndicate → monitor pipeline that runs on free tiers and requires no
card.

## Cross-refs

- [decisions/architecture/seo-three-pillars.md](../../decisions/architecture/seo-three-pillars.md) — the locking decision for the SEO pillars
- [decisions/architecture/feeds-rss-atom-json.md](../../decisions/architecture/feeds-rss-atom-json.md) — the locking decision for the three-format feed strategy
- [decisions/architecture/cross-post-engine.md](../../decisions/architecture/cross-post-engine.md) — oriz-omnipost reads RSS and fires the IndexNow ping on publish
- [glossary/o-r/oriz-kit.md](../../glossary/o-r/oriz-kit.md) — `<JsonLd>`, `<FeedDiscovery />`, feed generators live here
- [No card-on-file rule](../../rules/no-card-on-file.md)
