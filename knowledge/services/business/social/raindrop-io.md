---
type: service
title: "Raindrop.io"
description: "Bookmarking SaaS — source of truth for linkroll, free unlimited bookmarks"
tags: [social, bookmarks, linkroll, raindrop, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: linkroll-source
provider: raindrop
free_tier: "Unlimited bookmarks, unlimited collections, 50 requests/min on the REST API. No card."
swap_cost: low
related:
  - services/business/short-link/cloudflare-worker
  - decisions/architecture/linkroll-raindrop-to-links-page
  - rules/no-card-on-file
---

# Raindrop.io

## Role

The **source of truth** for the family's linkroll — the curated list
of links published at `blog.oriz.in/links`. Bookmarks are added in
the Raindrop.io UI / browser extension; the blog site fetches the
public collection at deploy time and renders a static `/links` page.

Per [`decisions/architecture/linkroll-raindrop-to-links-page.md`](../../decisions/architecture/linkroll-raindrop-to-links-page.md):
no Worker call per pageview, no client-side fetch — the data is
pulled at build time, cached at the Cloudflare edge with a 1-hour
TTL on the build artifact, and re-pulled on the next deploy or the
next periodic build trigger.

## Free tier

- **Unlimited bookmarks** + unlimited collections.
- **REST API** — 50 requests / minute, no daily cap; way above the
  one-call-per-deploy + one-call-per-hour-cron load.
- Public collections expose a read-only API endpoint without auth
  (we use the authenticated endpoint via `RAINDROP_TOKEN` for richer
  metadata + private-link visibility on demand).
- Browser extensions (Chrome / Firefox / Edge / Safari) free.
- Mobile apps free.

## Card / subscription required?

**NO.** Raindrop.io's "Pro" tier exists ($28/yr at time of writing)
but is not used by the family — the free tier covers every feature
the linkroll needs (collections, tags, REST API, public sharing).

## How sites consume it

```ts
// sites/oriz-blog-site/src/pages/links.astro (sketch — Astro build-time)
const res = await fetch(
  'https://api.raindrop.io/rest/v1/raindrops/<collection-id>?perpage=200',
  { headers: { Authorization: `Bearer ${import.meta.env.RAINDROP_TOKEN}` } },
);
const { items } = await res.json();
```

The `RAINDROP_TOKEN` lives in
[Doppler](../secrets/doppler.md). The build runs on
[Cloudflare Pages](../hosting/cloudflare-pages.md); a nightly
[GitHub Actions schedule](../cron/github-actions-schedule.md) trigger
re-builds the site so additions show up without a manual deploy.

## Alternatives

- **Pinboard** — bookmarking SaaS, $22 one-time. Acceptable but
  paid-up-front. Deferred unless Raindrop disappears.
- **Self-hosted Linkding** — OSS, fits no-self-host policy poorly
  (need to host it somewhere).
- **GitHub stars** — free but tag taxonomy is weak (no nested
  collections, no notes per item).
- **Plain Markdown file in repo** — simplest, but loses the
  browser-extension capture flow and the cross-device sync.

## Swap cost

Low — the linkroll page is a thin transform from a JSON list to
HTML. Swapping to Pinboard or Linkding is changing the fetch URL +
adapting the field names. No content is locked into Raindrop because
the canonical bookmarks are exported regularly via
`GET /rest/v1/raindrops/<id>` to a JSON file checked into
`oriz-me-data` as a backup.

## Why this is our pick

- **Free unlimited.** Every other no-card bookmark SaaS caps either
  bookmark count or feature set; Raindrop free has neither limit on
  the path that matters.
- **Public-collection API** is well-documented and stable.
- **Browser extension capture** keeps the family's "save link"
  ergonomics sane across Chrome / Firefox / Edge.
- **Pairs cleanly with the
  [s.oriz.in shortener](../short-link/cloudflare-worker.md)** —
  every linkroll item gets a memorable `s.oriz.in/<slug>` mint at
  build time, which is the URL `oriz-omnipost` cross-posts to
  link-aggregator platforms.

## Cross-refs

- [Linkroll architecture decision](../../decisions/architecture/linkroll-raindrop-to-links-page.md)
- [s.oriz.in short-link Worker](../short-link/cloudflare-worker.md)
- [Cloudflare Pages — host that builds /links](../hosting/cloudflare-pages.md)
- [GitHub Actions schedule — nightly re-build](../cron/github-actions-schedule.md)
- [Doppler — `RAINDROP_TOKEN` source](../secrets/doppler.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
