---
type: service
title: "IndexNow"
description: "Open API for instantly notifying Bing, Yandex, and partner search engines when a URL is added/changed/deleted. Submit-on-publish hook from oriz-omnipost. Free, no card."
tags: [seo, indexing, indexnow, instant, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: instant-indexing-api
provider: indexnow-protocol
free_tier: "Free, open protocol. Bing + Yandex + Seznam + Naver participate. No quota documented."
swap_cost: low
related:
  - services/seo/astrojs-sitemap
  - services/seo/json-ld-structured-data
  - services/seo/bing-webmaster
  - decisions/architecture/seo-three-pillars
  - decisions/architecture/cross-post-engine
---

# IndexNow

## Role

Notifies search engines (Bing + Yandex + Seznam + Naver, and any
future participant) the *instant* a new URL is published, edited,
or removed. Submission is a single HTTPS POST with the URL list +
the site's IndexNow key — engines respond `200` and queue the URL
for crawl within minutes instead of waiting for the next sitemap
poll.

In the family this fires from
[`oriz-omnipost`](../../glossary/o-r/omnipost.md)'s
publish-hook chain — the same RSS-driven trigger that fans new
posts to social platforms also pings IndexNow for the canonical URL.

## Free tier

- Open protocol — any participating engine, any volume, free
- One static `indexnow-key.txt` per site (the site hosts it at
  `https://<site>/<key>.txt` for ownership verification)
- No account, no API key per engine

## Card / subscription required?

**NO.** No account anywhere — the protocol is open.

## How it's used

```ts
// inside oriz-omnipost or a sitemap-changed CF cron
await fetch("https://api.indexnow.org/indexnow", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    host: "blog.oriz.in",
    key: process.env.INDEXNOW_KEY,
    keyLocation: `https://blog.oriz.in/${process.env.INDEXNOW_KEY}.txt`,
    urlList: ["https://blog.oriz.in/posts/foo", "https://blog.oriz.in/posts/bar"],
  }),
});
```

The key is generated once per site, stored in
[Doppler](../secrets/doppler.md), mirrored to GitHub Secrets +
Cloudflare Worker secrets.

## Alternatives

- Google's Indexing API — only supports JobPosting + BroadcastEvent
  schema types, not general blog content
- Wait for sitemap crawl — works but slow (Google can take days,
  Bing hours)
- Bing's URL Submission API — superseded by IndexNow

## Swap cost

Low — the POST endpoint is the only coupling. Adding/removing
IndexNow is a publish-hook tweak, no site code touched.

## Why this is our pick

- **Free, open, multi-engine** — one POST notifies Bing + Yandex +
  Seznam + Naver. No per-engine integration.
- **Instant** — URLs land in the index within minutes, not days.
- **Fits the publish-hook model** — `oriz-omnipost` already runs on
  RSS publish, so adding an IndexNow ping is one extra adapter.
- Google ignoring IndexNow doesn't matter much: Google's own
  algorithms crawl new URLs from sitemap + GSC submission +
  internal-link graph, and the family already does all three.

## Cross-refs

- [SEO three pillars decision](../../decisions/architecture/seo-three-pillars.md) — IndexNow is pillar 2
- [@astrojs/sitemap](./astrojs-sitemap.md) — pillar 1, complementary
- [Bing Webmaster](./bing-webmaster.md) — Bing's console reads IndexNow submissions
- [oriz-omnipost glossary](../../glossary/o-r/omnipost.md) — fires the IndexNow ping
- [Doppler](../secrets/doppler.md) — stores `INDEXNOW_KEY`
