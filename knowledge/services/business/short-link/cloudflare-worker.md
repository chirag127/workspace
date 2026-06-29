---
type: service
title: "Cloudflare Worker short-link (s.oriz.in)"
description: "Self-hosted URL shortener at s.oriz.in — 100k req/day free"
tags: [short-link, cloudflare, worker, oriz-omnipost, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: url-shortener
provider: cloudflare
free_tier: "100,000 Worker requests/day; KV: 100k reads/day, 1k writes/day, 1 GiB storage — all free, no card"
swap_cost: low
related:
  - decisions/architecture/cross-post-engine
  - decisions/architecture/url-shortener-quota-mitigation
  - decisions/architecture/linkroll-raindrop-to-links-page
  - services/infra/compute/cloudflare-workers
  - rules/no-card-on-file
  - rules/never-hit-quotas
---

# Cloudflare Worker short-link (s.oriz.in)

## Role

Mints short URLs of the shape `https://s.oriz.in/<slug>` that 302 to
canonical pages on `blog.oriz.in` (or any other family URL). The
primary consumer is
[`@chirag127/oriz-omnipost`](../../decisions/architecture/cross-post-engine.md) —
when a cross-post target platform refuses long content, the adapter
posts a teaser + a unique short link instead of the full body. Each
cross-post mints its own slug so click attribution per platform is
trivial.

Secondary use: any time the family wants a memorable, self-owned short
URL for a tweet, talk, or QR code (e.g. `s.oriz.in/v2`, `s.oriz.in/cv`).

## Free tier

- **Workers**: 100,000 requests / day (rolling).
- **KV namespace** (slug → target URL store): 100k reads / day, 1k writes / day, 1 GiB storage.
- Fails-closed at quota — does not auto-bill.
- Same Cloudflare account as Pages, R2, DNS — no extra signup.

## Card / subscription required?

**NO.** Inherits from the family Cloudflare account. No payment method
needed.

## Alternatives

- `is.gd` — free public shortener, no account, but no analytics, no custom domain, can disappear at any time.
- `bit.ly` free — 100 links / month soft cap, requires account, ad-supported.
- `t.ly` free — 30 links / month, requires account.
- Self-hosted on Vercel Edge Functions — possible but duplicates infra; we already run Cloudflare Workers.

We picked self-hosted on Cloudflare Worker because: custom domain
(`s.oriz.in`) keeps brand cohesion, KV gives us per-slug analytics for
free, no third-party can deprecate or rate-limit us, and it fits the
existing infra one-line.

## Quota mitigation — cache the 301 itself

The free tier is **100,000 Worker requests/day per script**. The
mitigation is a single trick: cache the 301 redirect itself at the
Cloudflare edge.

```ts
return new Response(null, {
  status: 301,
  headers: {
    Location: target,
    'Cache-Control': 'public, max-age=31536000, immutable',
    'CDN-Cache-Control': 'public, max-age=31536000, immutable',
  },
});
```

With this header set:

- The **first** visitor through a given edge POP for a given slug
  triggers the Worker (1 request burned, KV hit, 301 written).
- **Every subsequent visitor** through the same POP for the next
  year hits the CF edge cache and the Worker is never invoked.

A 301 is cacheable HTTP per RFC 7231 §6.4.2 — any CDN may cache it
indefinitely. The Worker emits **only** a 301 — minimal CPU.

**Realistic upper bound at family scale:** ~30 platforms × ~10
cross-posts/day × 1.5 click avg ≈ ~450 omnipost clicks/day, plus
linkroll + QR / talk slugs = ~1-2K Worker requests/day worst-case
across all CF edge POPs. That's **1-2% of the 100K/day free
envelope**, comfortably inside
[`rules/interaction/never-hit-quotas.md`](../../rules/interaction/never-hit-quotas.md).

**Slugs are immutable by design.** Once minted, a slug never
re-points; retire by minting a new one. The cached 301 trick
depends on this immutability — re-pointing would require a CF cache
purge and create a window of inconsistency.

**Trade-off — no analytics from cached visits.** Cache hits never
reach the Worker, so per-slug click counts undercount. The family
accepts this; click attribution lives in
[Cloudflare Web Analytics](../analytics/cloudflare-web-analytics.md)
plus [UTM parameters](../analytics/utm-tracking.md) on the destination
page. The Worker's `/_stats/<slug>` endpoint reports KV-stored mint
counts only.

Full lock at [`decisions/architecture/url-shortener-quota-mitigation.md`](../../decisions/architecture/url-shortener-quota-mitigation.md).

## Swap cost

Low. The Worker is ~30 lines of TypeScript. Migration target candidates
are all standard short-link APIs; swapping means changing the engine's
`shortLink(canonicalUrl)` helper to call a different endpoint.

## Why this is our pick

- Self-owned domain (`s.oriz.in`) — no risk of the shortener
  service vanishing and 404-ing every cross-post.
- KV → free analytics per slug (click count + last-clicked timestamp),
  exposed via a tiny GET `/_stats/<slug>` endpoint behind App Check.
- Zero card, zero quota anxiety, zero extra dashboard.
- Fits the family's "no third-party where Cloudflare already covers
  it" pattern.

## Cross-refs

- [oriz-omnipost cross-post engine](../../decisions/architecture/cross-post-engine.md)
- [Cloudflare Workers — base service](../compute/cloudflare-workers.md)
- [Subdomains under oriz.in](../../infrastructure/subdomains-under-oriz-in.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
