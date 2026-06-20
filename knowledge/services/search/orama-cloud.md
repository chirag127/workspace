---
type: service
title: "Orama Cloud"
description: "Modern in-browser vector + keyword search. Documented as a deferred future option to revisit if vector search becomes valuable. 10K docs / 5K searches/mo free, no card."
tags: [search, orama, vector, hybrid, deferred, future]
timestamp: 2026-06-20
format_version: okf-v0.1
status: deferred
role: search-vector-future
provider: orama
free_tier: "10,000 documents stored + 5,000 searches/month, hybrid (BM25 + vector), no card required"
swap_cost: medium
related:
  - services/search/algolia
  - services/search/pagefind
  - rules/never-hit-quotas
  - rules/no-card-on-file
---

# Orama Cloud

## Status

**Deferred.** Documented as a candidate replacement for
[Pagefind](./pagefind.md) on the smaller / static sites if vector
search ever becomes a valuable addition to the family's search UX
(e.g. semantic-similar-posts, embeddings-driven "more like this"
panels). Not adopted in 2026-06-20 Batch 11 — user direction was
"i am not sure", interpreted as **don't add now, document for
later**.

If / when this flips to `status: active`, the swap target is
Pagefind on small/static sites; Algolia stays on the
large-corpus sites because Orama's free tier (10K docs) is below
those sites' index sizes.

## Role (when adopted)

In-browser hybrid search — runs as a WASM module in the visitor's
tab, indexing pulled at first interaction; falls back to the Orama
Cloud hosted instance for vector / embeddings queries. Different
shape from Algolia (hosted full-text) and Pagefind (build-time
keyword) — adds **semantic** retrieval and the option of a
client-side privacy-first index.

## Free tier

- 10,000 documents stored
- 5,000 searches / month
- Hybrid retrieval (BM25 keyword + vector embeddings)
- All client SDKs (React / Vue / Svelte / vanilla JS) on the free
  tier
- Self-hosted Orama (`@orama/orama`) is OSS — escape hatch if the
  hosted free tier ever tightens
- No card required at sign-up

## Card / subscription required?

**NO.** Free-tier sign-up is GitHub-OAuth-only. No payment method
requested.

## When to revisit

Promote `deferred → active` (replacing Pagefind on small/static
sites) when **any one** of these holds:

1. The family ships an embeddings-driven feature (e.g.
   "semantically similar posts" on `oriz-blog`) that Pagefind's
   keyword index can't serve.
2. Pagefind's bundle size on a large site crosses the
   [Cloudflare Pages](../hosting/cloudflare-pages.md) static-asset
   budget.
3. Orama Cloud's free tier expands meaningfully or its
   hybrid-retrieval becomes a clear UX win the user wants on
   every site.

Until one of those holds, Pagefind stays — its zero-infra +
zero-network-call posture beats Orama on simplicity for small
corpora.

## Alternatives

- [Pagefind](./pagefind.md) — current pick for small sites; pure
  keyword, build-time index, no service to call.
- [Algolia](./algolia.md) — current pick for large corpora;
  hosted, typo-tolerant, no vector retrieval on the free tier.
- Meilisearch Cloud — comparable hosted full-text; hybrid search
  on paid tiers only.
- Self-hosted Typesense — vector + keyword, but self-host fights
  the family's no-self-host posture.

## Swap cost

Medium — Orama's `@orama/orama` client and indexing pipeline
differ from Pagefind's. The swap involves: (a) replacing the
`<Search>` wrapper in
[`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md), (b)
re-running the index build at deploy time, (c) wiring an
embeddings step into the build for vector retrieval (optional).

## Why deferred (not active, not rejected)

- **Active is premature** — the family's current search UX is
  serving users. Adding vector search before there's a concrete
  feature that needs it spends complexity for no gain.
- **Rejected is wrong** — Orama is genuinely the best free
  hybrid-search candidate the family has surveyed; it would be the
  swap target the moment the use-case lands.
- **Deferred is honest** — documents the candidate, the trigger
  conditions, and the swap surface so the next agent doesn't
  re-derive the analysis when the use-case appears.

## Cross-refs

- [search services index](./index.md)
- [Pagefind — current pick for small sites](./pagefind.md)
- [Algolia — current pick for large corpora](./algolia.md)
- [oriz-kit glossary](../../glossary/o-r/oriz-kit.md)
- [Never hit quotas rule](../../rules/never-hit-quotas.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
