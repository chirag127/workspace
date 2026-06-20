---
type: service
title: "Satori on Cloudflare Worker (`api.oriz.in/og`)"
description: "Self-built Open Graph card generator using @vercel/og (Satori) on the api.oriz.in Hono Worker. Free unlimited (CF Workers free tier). Renders templated OG PNGs on demand for non-code blog posts."
tags: [og-image, satori, cloudflare-workers, social, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: og-card-generator
provider: self-hosted-on-cloudflare-workers
free_tier: "Cloudflare Workers free tier — 100K req/day; @vercel/og is MIT, no provider account needed"
swap_cost: low
related:
  - services/social/ray-so
  - services/compute/cloudflare-workers
  - decisions/architecture/og-card-generation-satori
  - decisions/architecture/hono-worker-api-umbrella
  - rules/no-card-on-file
---

# Satori on Cloudflare Worker (`api.oriz.in/og`)

## Role

Generates the **og:image** PNG for **non-code** posts and pages
across the family — site landing pages, long-form blog essays, book
reviews, extension pages, etc. The Hono umbrella Worker at
`api.oriz.in` exposes a `/og` route that takes templated query
params (`title`, `theme`, `site`, optional `subtitle`/`emoji`) and
returns a 1200×630 PNG.

Code-heavy posts continue to use [Ray.so](./ray-so.md) — the two
generators sit side by side and a per-post toggle picks between
them. The decision is locked in
[`decisions/architecture/og-card-generation-satori.md`](../../decisions/architecture/og-card-generation-satori.md).

## Free tier

- Cloudflare Workers free plan — 100,000 requests / day
- Static cache headers (`Cache-Control: public, max-age=31536000, immutable`) plus Cloudflare's edge cache push the effective request count to *cold first-render only*
- `@vercel/og` is MIT-licensed; no provider account, no API key, no quota beyond Workers'

## Card / subscription required?

**NO.** `@vercel/og` ships as an npm package; the Worker is on the
existing Cloudflare account that already runs Pages + Workers + KV.
No additional sign-up, no card.

## Endpoint shape

```
GET https://api.oriz.in/og
  ?title=<url-encoded post title>
  &theme=<midnight|sunset|candy|...>
  &site=<oriz-blog|oriz-books|oriz-me|...>
  &subtitle=<optional>
  &emoji=<optional>
```

Returns: `image/png`, 1200×630, with one-year `Cache-Control` and
an `ETag` derived from the parameter hash.

## How it's used

Each site's Astro template sets `<meta property="og:image">` to the
fully-qualified `api.oriz.in/og?...` URL. The first share triggers
generation; subsequent shares hit the edge cache. No build-step
dependency — the URL is just a `<meta>` tag, the image renders on
first social-platform crawl.

## Alternatives

- [Ray.so](./ray-so.md) — kept for code-heavy posts (different
  visual treatment optimized for syntax-highlighted snippets)
- Vercel OG-image hosted endpoint — requires a Vercel project, the
  family's hosting is on Cloudflare Pages
- Netlify Image CDN OG generator — same problem
- Cloudinary text overlays — paid past free credits, more complex
- Pre-built static OGs in the repo — doesn't scale to 11+ sites'
  worth of pages, defeats the templating benefit

## Swap cost

Low — the URL surface is the only coupling. Each site references a
single `api.oriz.in/og?...` URL in its template; if the
implementation moved to Vercel OG, Cloudinary, or self-hosted
Satori on a different runtime, only the route handler changes,
sites are untouched.

## Why this is our pick

1. **Free unlimited at family scale** — 100K req/day Workers cap is
   orders of magnitude above realistic OG-render volume after edge
   caching.
2. **Stack cohesion** — already runs on the
   [api.oriz.in Hono Worker umbrella](../../decisions/architecture/hono-worker-api-umbrella.md);
   no new deployment, no new credentials.
3. **Templated, not hand-drawn** — sites don't commit per-post PNGs
   to their repo; they emit one `<meta>` tag and the OG renders on
   first crawl.
4. **Visual control** — Satori takes JSX → SVG → PNG, so themes
   are React components living in
   [`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md). Each
   site can override per-theme colors/fonts via the `theme`/`site`
   query params.

## Cross-refs

- [Ray.so](./ray-so.md) — code-heavy post OG cards
- [decisions/architecture/og-card-generation-satori.md](../../decisions/architecture/og-card-generation-satori.md)
- [decisions/architecture/hono-worker-api-umbrella.md](../../decisions/architecture/hono-worker-api-umbrella.md)
- [Cloudflare Workers](../compute/cloudflare-workers.md)
- [oriz-kit glossary entry](../../glossary/o-r/oriz-kit.md) — themes live here
- [No card-on-file rule](../../rules/no-card-on-file.md)
