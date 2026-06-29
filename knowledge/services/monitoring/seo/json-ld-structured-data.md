---
type: service
title: "JSON-LD structured data (schema.org)"
description: "Schema.org JSON-LD via oriz-kit component"
tags: [seo, structured-data, schema-org, json-ld, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: structured-data
provider: schema-org
free_tier: "Free, open vocabulary. No service, no quota. Search engines read JSON-LD blocks from page HTML."
swap_cost: low
related:
  - services/monitoring/monitoring/seo/astrojs-sitemap
  - services/monitoring/monitoring/seo/indexnow
  - services/monitoring/monitoring/seo/google-search-console
  - decisions/architecture/seo-three-pillars
  - glossary/o-r/oriz-kit
---

# JSON-LD structured data (schema.org)

## Role

Emits machine-readable semantic markup on every family page so
search engines, social previewers, and AI crawlers understand
*what* a page is — not just its words. The family standardises on
five schema.org types:

- **Article** — every blog post, book review, long-form essay
- **BreadcrumbList** — every nested page (extension subpages, post permalinks)
- **Organization** — the family meta-entity (`oriz`)
- **WebSite** — each site's own home with a `SearchAction` pointing at on-site search
- **Person** — the author entity for `me.oriz.in`, plus author bylines on every post

Markup is rendered via a single `<JsonLd type="..." data={{...}} />`
component in <!-- TODO: broken link, was [`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md) -->
— a forward reference today; the component lands when oriz-kit's
next release adds it (per
[`decisions/architecture/seo-three-pillars.md`](../../decisions/architecture/seo-three-pillars.md)).

## Free tier

- Open vocabulary at `schema.org` — free, no service, no quota
- Validation via [validator.schema.org](https://validator.schema.org/) +
  Google's Rich Results Test (free, no card)

## Card / subscription required?

**NO.** Pure markup; no account anywhere.

## Component shape

```tsx
// future @chirag127/oriz-kit export
import { JsonLd } from "@chirag127/oriz-kit";

<JsonLd type="Article" data={{
  headline: post.title,
  datePublished: post.date,
  author: { "@type": "Person", name: "Chirag Singhal", url: "https://me.oriz.in" },
  publisher: { "@type": "Organization", name: "oriz", logo: "https://oriz.in/logo.png" },
  image: `https://api.oriz.in/og?title=${encodeURIComponent(post.title)}`,
  mainEntityOfPage: post.canonicalUrl,
}} />
```

The component renders a single `<script type="application/ld+json">`
tag with the JSON serialised. Sites compose multiple `<JsonLd>`
emits per page (e.g. `Article` + `BreadcrumbList` on a blog post).

## Alternatives

- Microdata (`itemtype`/`itemprop`) — older, more verbose,
  search-engine support comparable
- RDFa — older, niche
- No structured data at all — works, but rich-result eligibility
  drops to zero

## Swap cost

Low — markup lives in the rendered HTML; replacing the component
implementation is one kit PR, sites unchanged.

## Why this is our pick

- **JSON-LD over Microdata** — Google explicitly recommends it,
  and the syntax is decoupled from layout (you can drop a
  `<script>` block anywhere; Microdata bleeds into element trees).
- **Component-in-the-kit** — every site reads the same five schema
  types via the same `<JsonLd>` component, so a schema fix lands
  family-wide via one kit version bump.
- **Powers OG card metadata reuse** — the `image` URL inside the
  Article schema is the same Satori URL used in
  `<meta property="og:image">` per
  [`og-card-generation-satori.md`](../../decisions/architecture/og-card-generation-satori.md).

## Cross-refs

- [SEO three pillars decision](../../decisions/architecture/seo-three-pillars.md) — JSON-LD is pillar 3
- [@astrojs/sitemap](./astrojs-sitemap.md) — pillar 1
- [IndexNow](./indexnow.md) — pillar 2
- [Google Search Console](./google-search-console.md) — Rich Results report reads JSON-LD
- <!-- TODO: broken link, was [oriz-kit glossary](../../glossary/o-r/oriz-kit.md) --> — the `<JsonLd>` component lives here (forward reference)
- [decisions/architecture/og-card-generation-satori.md](../../decisions/architecture/og-card-generation-satori.md) — Article.image URL ties to OG card
