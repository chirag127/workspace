---
type: service
title: "Atom 1.0 feed"
description: "Atom 1.0 syndication feed at /atom.xml on every site"
tags: [seo, feed, atom, syndication, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: feed-atom
provider: spec-rfc-4287
free_tier: "Open spec (RFC 4287). No backend, no service — generated at build time."
swap_cost: low
related:
  - services/monitoring/monitoring/seo/json-feed
  - services/monitoring/monitoring/seo/index
  - decisions/architecture/feeds-rss-atom-json
  - decisions/architecture/cross-post-engine
---

# Atom 1.0 feed

## Role

Atom 1.0 (RFC 4287) syndication feed published at `/atom.xml` on
every content-bearing site (`blog.oriz.in`, `me.oriz.in` public
sections, per-extension changelog feeds). Sits alongside the RSS 2.0
feed and the JSON Feed — see
[`decisions/architecture/feeds-rss-atom-json.md`](../../decisions/architecture/feeds-rss-atom-json.md).

Some readers (notably older newsreaders + a few search engines'
crawl pipelines) prefer Atom over RSS; some don't auto-discover
unless the `<link rel="alternate" type="application/atom+xml">` tag
is present. Publishing all three formats means we never lose a
subscriber to a format gap.

## Free tier

- Open spec, no backend
- Generated at build time inside each Astro site, dropped into
  `dist/atom.xml`
- Served by Cloudflare Pages as a static asset — no runtime cost

## Card / subscription required?

**NO.** Pure build-time output.

## How it's used

`@chirag127/oriz-kit` ships:

- A `<FeedDiscovery />` component that injects all three `<link>`
  tags (RSS 2.0, Atom 1.0, JSON Feed) into the document head.
- A `generateAtomFeed(posts)` helper that consumes the same
  `Post[]` shape the RSS generator does, emits valid Atom 1.0 XML.

```ts
// astro.config.mjs / build hook
import { generateAtomFeed } from "@chirag127/oriz-kit/feeds";
const xml = generateAtomFeed({
  site: "https://blog.oriz.in",
  title: "Oriz Blog",
  posts,
});
await fs.writeFile("dist/atom.xml", xml);
```

## Alternatives

- RSS 2.0 only — ignored by some Atom-only readers
- JSON Feed only — too new, smaller reader install base
- Skip Atom — losses some long-tail subscribers + search-pipeline
  hints; not worth the saved bytes

## Swap cost

Low — a build-step output. Removing or swapping is a generator-helper
change, no runtime impact.

## Why this is our pick

Three-format publishing is the safest reach. Atom's strict spec
(timestamps, IDs, namespaces) has historically been more robust than
loose RSS, and several reader / crawler tools default to Atom when
both are advertised. Cost to publish: one build-step helper.

## Cross-refs

- [Multi-format feeds decision](../../decisions/architecture/feeds-rss-atom-json.md)
- [JSON Feed sibling](./json-feed.md)
- [SEO services index](./index.md)
- [Cross-post engine](../../decisions/architecture/cross-post-engine.md) — `oriz-omnipost` reads RSS as the source-of-truth feed; Atom + JSON ride alongside for human readers
- <!-- TODO: broken link, was [oriz-kit glossary](../../glossary/o-r/oriz-kit.md) --> — `<FeedDiscovery />` component lives here
