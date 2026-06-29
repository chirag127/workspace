---
type: index
title: "Short-link services"
description: "URL shorteners used by the oriz family. Primary use case: oriz-omnipost cross-posts to platforms that truncate long content."
tags: [services, short-link, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Short-link services

The family runs a **three-tier free URL-shortener stack** — see
[`decisions/architecture/url-shortener-mitigation-tiers.md`](../../decisions/architecture/url-shortener-mitigation-tiers.md)
for the layering rationale. Tier 1 (`s.oriz.in` self-hosted CF
Worker) covers ~99.9% of clicks; Tiers 2 and 3 add cross-domain
breadth and outage-survival depth without needing a card or a
subscription. The Tier 1 shortener is consumed primarily by
[`@chirag127/oriz-omnipost`](../../decisions/architecture/cross-post-engine.md)
when a target blogging platform doesn't accept long content, and by
the [linkroll build step](../../decisions/architecture/linkroll-raindrop-to-links-page.md)
to mint memorable URLs for shared bookmarks.

The Tier 1 Worker emits `Cache-Control: public, max-age=31536000,
immutable` on every 301, so the CF edge caches the redirect itself
and the Worker is invoked only on the first visit per slug per
edge POP per year — see [`decisions/architecture/url-shortener-quota-mitigation.md`](../../decisions/architecture/url-shortener-quota-mitigation.md).

| Tier | Service | Status | Role |
|---|---|---|---|
| 1 (primary) | [cloudflare-worker.md](./cloudflare-worker.md) | active | Self-hosted shortener on a Cloudflare Worker at `s.oriz.in` (free, no card; cached-301 quota mitigation) |
| 2 (fallback) | [tinyurl.md](./tinyurl.md) | active | TinyURL public `api-create.php` endpoint — free unlimited, no auth, no card. Used for non-oriz.in destinations and Tier 1 outages |
| 3 (zero-infra) | [github-gist-redirect.md](./github-gist-redirect.md) | active | Public GitHub gist with HTML meta-refresh — survives a complete Cloudflare outage; manual-mint, used for permanent / archival redirects |

## Cross-refs

- [Three-tier URL shortener stack decision](../../decisions/architecture/url-shortener-mitigation-tiers.md)
- [URL shortener quota mitigation (Tier 1 detail)](../../decisions/architecture/url-shortener-quota-mitigation.md)
- [Cross-post engine architecture](../../decisions/architecture/cross-post-engine.md)
- [Linkroll → Raindrop](../../decisions/architecture/linkroll-raindrop-to-links-page.md)
- [Cloudflare Workers — base service](../compute/cloudflare-workers.md)
