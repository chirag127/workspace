---
type: index
title: "Search services"
description: "On-site search. Algolia for big-corpus sites, Pagefind for small/static sites."
tags: [services, search, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Search services

The family runs a **two-tier on-site search** strategy:

- **Algolia** for the large-corpus sites — `oriz-blog`, `oriz-books`, `oriz-book-lore`. 1M docs + 10K searches/month free, no card.
- **Pagefind** for the rest — `oriz-me`, `oriz-pdf-tools`, `oriz-cards`, `oriz-finance`, `oriz-image-tools`, `oriz-urls-to-md`, `oriz-journal`, `oriz-home`. Build-time index, no service.

The "Search the web" multi-engine launcher is a separate feature — see [`decisions/architecture/multi-engine-search-button.md`](../../decisions/architecture/multi-engine-search-button.md). It lives in `@chirag127/oriz-kit`, not here.

| Service | Status | One-line role |
|---|---|---|
| [algolia.md](./algolia.md) | active | Hosted search index — large-corpus sites (1M docs / 10K searches free) |
| [pagefind.md](./pagefind.md) | active | Build-time static-site search index, fully client-side |
| [orama-cloud.md](./orama-cloud.md) | deferred | Hybrid (BM25 + vector) search candidate — revisit if vector retrieval becomes valuable |

## Why Orama is deferred, not active

User direction on 2026-06-20 was "i am not sure" — interpreted as
**document for later, don't adopt now**. Pagefind's zero-infra
posture is the right pick for small/static sites today; Orama
Cloud is the documented swap target the moment a vector-search
feature lands. Trigger conditions live in
[`orama-cloud.md`](./orama-cloud.md#when-to-revisit).
