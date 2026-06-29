---
type: index
title: "Social services"
description: "Tools for the social-distribution layer — og:images, share-card generators, social previews, and federation mirrors of the canonical lifestream."
tags: [services, social, federation, lifestream, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Social services

Services that produce or shape what readers see when our URLs are
shared on third-party platforms (X, LinkedIn, WhatsApp, Reddit,
Mastodon, Bluesky). Distinct from analytics — these are output-side,
not measurement-side.

Two roles live in this directory:

- **OG-card generation** — two generators side by side, picked by
  post shape:
  - [satori-og-cards.md](./satori-og-cards.md) — **default** for non-code posts (templated Satori on `api.oriz.in/og`)
  - [ray-so.md](./ray-so.md) — code-heavy posts (syntax-highlighted screenshot)

  The split is locked in
  [`decisions/architecture/og-card-generation-satori.md`](../../decisions/architecture/og-card-generation-satori.md).
- **Lifestream federation mirrors** — read the canonical
  [oriz-me-data JSONL](../../decisions/architecture/lifestream-jsonl-canonical.md)
  and republish it onto two federated protocols in parallel
  (AT Protocol + ActivityPub) per the
  [lifestream-federation decision](../../decisions/architecture/lifestream-federation.md).

| Service | Status | One-line role |
|---|---|---|
| [satori-og-cards.md](./satori-og-cards.md) | active | Templated OG PNG generator on the api.oriz.in Hono Worker (`@vercel/og` / Satori) — default for non-code posts |
| [ray-so.md](./ray-so.md) | active | Code-screenshot PNG generator → og:image for code-heavy blog posts |
| [atproto-firehose.md](./atproto-firehose.md) | active | Lifestream mirror — AT Protocol records under `me.oriz.in.atproto`, follow `chirag127.oriz.in` on Bluesky |
| [activitypub.md](./activitypub.md) | active | Lifestream mirror — self-hosted ActivityPub outbox at `me.oriz.in/activitypub/outbox`, follow `@chirag@me.oriz.in` on Mastodon |
| [raindrop-io.md](./raindrop-io.md) | active | Linkroll source-of-truth (free unlimited bookmarks + REST API); `blog.oriz.in/links` built at deploy time |

## Cross-refs

- [services/code/code-embed/](../code-embed/index.md) — the in-post playgrounds; ray.so generates the social card for the post wrapping them
- [decisions/architecture/og-card-generation-satori.md](../../decisions/architecture/og-card-generation-satori.md) — non-code OG path
- [decisions/architecture/multi-engine-search-button](../../decisions/architecture/multi-engine-search-button.md) — readers who follow a shared link see the OG card, then can use the multi-search button to look up the topic broadly
- [Lifestream federation decision](../../decisions/architecture/lifestream-federation.md) — locks both mirrors
- [Lifestream JSONL is canonical](../../decisions/architecture/lifestream-jsonl-canonical.md) — anchor decision for both mirrors
- [Linkroll → Raindrop.io decision](../../decisions/architecture/linkroll-raindrop-to-links-page.md) — anchor for the linkroll source
