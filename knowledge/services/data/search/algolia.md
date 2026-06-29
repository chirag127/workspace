---
type: service
title: "Algolia"
description: "Hosted search for large-corpus sites — 1M docs + 10K searches/mo free"
tags: [search, hosted, large-corpus, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: search-large-corpus
provider: algolia
free_tier: "1M docs stored + 10K searches/month, no card required"
swap_cost: medium
related:
  - services/data/search/pagefind
  - rules/never-hit-quotas
  - rules/no-card-on-file
---

# Algolia

## Role

Hosted search for the family's **large-corpus** sites — `oriz-blog`,
`oriz-books`, `oriz-book-lore` — where Pagefind's build-time index
either inflates the deployed bundle past Cloudflare Pages' static-asset
budget or returns slow first-keystroke results on long lists.

The split is decided per-site: **Algolia for big corpora, Pagefind for
the rest.** Smaller / static sites (`oriz-me`, `oriz-pdf-tools`,
`oriz-cards`, `oriz-finance`, `oriz-image-tools`, `oriz-urls-to-md`,
`oriz-journal`, `oriz-home`) keep Pagefind.

## Free tier

- 1,000,000 records stored
- 10,000 searches / month
- Unlimited indexes
- Search analytics + A/B testing on the free tier
- All client SDKs (React InstantSearch, vanilla JS, etc.)

## Card / subscription required?

**NO.** Free-tier sign-up is email-only. No payment method requested,
no trial expiry — Algolia has a permanent "Build" free tier.

## Alternatives

- [Pagefind](./pagefind.md) — primary for small/static sites
- Meilisearch Cloud (free tier exists; smaller doc cap)
- Typesense Cloud (no free tier — paid only)
- ElasticSearch self-hosted (rejected — self-host is rejected family-wide)

## Swap cost

Medium — Algolia has its own indexing pipeline + dashboard. Swapping
means rebuilding the index in another tool and re-wiring the
`<InstantSearch>` client. For the family's big-corpus sites the
React InstantSearch component sits behind a thin wrapper in
`@chirag127/oriz-kit`, so the swap-surface is small.

## Why this is our pick

The most generous no-card-required hosted search. 10K searches/month
is plenty for the apex blog + book sites at current traffic, and the
1M doc cap means we don't have to truncate the corpus. Pagefind's
build-time approach can't beat Algolia's typo-tolerance + relevance
tuning on long-tail book/blog content.

## Cross-refs

- [Pagefind](./pagefind.md) — small-site sibling
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- <!-- TODO: broken link, was [oriz-kit glossary](../../glossary/o-r/oriz-kit.md) -->
