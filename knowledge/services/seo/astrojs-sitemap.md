---
type: service
title: "@astrojs/sitemap"
description: "Official Astro integration that generates sitemap.xml + robots.txt-compatible URL list at build time. Free, no card."
tags: [seo, sitemap, astro, build-time, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: sitemap-generator
provider: astro
free_tier: "Free, OSS, MIT — no service backend, generates static sitemap.xml + sitemap-index.xml at build"
swap_cost: low
related:
  - services/seo/indexnow
  - services/seo/json-ld-structured-data
  - services/seo/google-search-console
  - services/seo/bing-webmaster
  - decisions/architecture/seo-three-pillars
---

# @astrojs/sitemap

## Role

Generates `sitemap-index.xml` + `sitemap-0.xml` for every Astro site
in the family at build time. Output ships in the static bundle on
Cloudflare Pages — no runtime cost, no service to depend on.

## Free tier

- MIT-licensed npm package
- No backend, no API, no quota
- Generates sitemap files at `astro build` time, dropped into `dist/`

## Card / subscription required?

**NO.** Pure build-time tool.

## Configuration

```ts
// astro.config.mjs
import sitemap from "@astrojs/sitemap";
export default {
  site: "https://blog.oriz.in",
  integrations: [
    sitemap({
      changefreq: "weekly",
      priority: 0.7,
      lastmod: new Date(),
      filter: (page) => !page.includes("/draft/"),
    }),
  ],
};
```

Site URL passed to `site:` in the Astro config feeds the
fully-qualified URLs in the output XML.

## Alternatives

- Hand-rolled sitemap generator script — works but every site
  reimplements the same boilerplate
- `next-sitemap` — wrong framework
- Algolia / sitemap-as-a-service — paid past trial, no value over
  the build-step approach

## Swap cost

Low — output is plain `sitemap.xml`, the contract any consumer
reads. Replacing the integration is a build-step change inside one
site repo.

## Why this is our pick

It's the official Astro integration. Every site already runs Astro
([`decisions/architecture/oriz-ui-split-into-5-packages.md`](../../decisions/architecture/oriz-ui-split-into-5-packages.md)
context), so adding the integration is one line in `astro.config.mjs`.
Free, OSS, no backend, no card.

## Cross-refs

- [SEO three pillars decision](../../decisions/architecture/seo-three-pillars.md) — sitemap is pillar 1
- [IndexNow](./indexnow.md) — pillar 2 (instant indexing)
- [JSON-LD structured data](./json-ld-structured-data.md) — pillar 3 (semantic markup)
- [Google Search Console](./google-search-console.md) — sitemap submission target
- [Bing Webmaster](./bing-webmaster.md) — sitemap submission target
