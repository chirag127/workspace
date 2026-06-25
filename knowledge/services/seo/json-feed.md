---
type: service
title: "JSON Feed v1.1"
description: "Modern JSON-based syndication feed at /feed.json on every site, alongside RSS 2.0 and Atom 1.0."
tags: [seo, feed, json-feed, syndication, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: feed-json
provider: jsonfeed-org-v1-1
free_tier: "Open spec (jsonfeed.org v1.1). No backend, no service — generated at build time."
swap_cost: low
related:
  - services/seo/atom-feed
  - services/seo/index
  - decisions/architecture/feeds-rss-atom-json
---

# JSON Feed v1.1

## Role

JSON Feed (jsonfeed.org spec v1.1) published at `/feed.json` on every
content-bearing site. Modern feed readers (NetNewsWire, Feedbin,
Inoreader, custom dev tooling) prefer it over RSS / Atom because it's
plain JSON — no XML parser required, ergonomic to consume from JS.

Sits alongside RSS 2.0 + [Atom 1.0](./atom-feed.md) — see
[`decisions/architecture/feeds-rss-atom-json.md`](../../decisions/architecture/feeds-rss-atom-json.md).

## Free tier

- Open spec — no service, no account, no quota
- Generated at build time, dropped into `dist/feed.json`
- Served by Cloudflare Pages as a static asset

## Card / subscription required?

**NO.** Pure build-time output.

## Spec highlights (v1.1)

- `version`: `"https://jsonfeed.org/version/1.1"`
- Required: `version`, `title`, `items[]`
- Each item: `id`, optional `url`, `title`, `content_html` /
  `content_text`, `date_published`, `tags[]`, `authors[]`
- Authors moved to per-item arrays in 1.1 (was single `author` in
  1.0)
- Cleaner extension model than RSS — custom keys go under
  `_extensions` namespaces

## How it's used

`@chirag127/oriz-kit/feeds` ships `generateJsonFeed(posts)`:

```ts
import { generateJsonFeed } from "@chirag127/oriz-kit/feeds";
const json = generateJsonFeed({
  site: "https://blog.oriz.in",
  title: "Oriz Blog",
  posts,
});
await fs.writeFile("dist/feed.json", JSON.stringify(json));
```

The `<FeedDiscovery />` component injects all three feed `<link>`
tags into the head — JSON Feed gets
`<link rel="alternate" type="application/feed+json" href="/feed.json">`.

## Alternatives

- RSS / Atom only — readers preferring JSON Feed would not
  auto-discover
- Custom JSON shape — would lose reader interop
- Skip — small but real audience of dev-tooling-built-on-JSON-Feed
  loses access; cost to publish is negligible

## Swap cost

Low — build-step helper.

## Why this is our pick

Cheapest of the three formats to ship (it's already valid JSON, no
XML serializer needed). Future-friendly: every modern reader I know
supports it; few legacy readers don't. Three-format publishing
guarantees we never lose a subscriber to a format gap.

## Cross-refs

- [Multi-format feeds decision](../../decisions/architecture/feeds-rss-atom-json.md)
- [Atom 1.0 sibling](./atom-feed.md)
- [SEO services index](./index.md)
- <!-- TODO: broken link, was [oriz-kit glossary](../../glossary/o-r/oriz-kit.md) --> — `<FeedDiscovery />` + generators
- jsonfeed.org spec v1.1 — https://www.jsonfeed.org/version/1.1/
