---
type: decision
title: "Cloudflare Pages free hosts every site; Firebase Hosting dropped"
description: "All 11+ sites and the extensions catalog deploy to Cloudflare Pages free. Firebase Hosting is no longer used (journal previously did; reversed)."
tags: [hosting, cloudflare, firebase, pages]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/infrastructure/firebase-spark-forever
  - decisions/monetisation/no-subscriptions-anywhere
  - decisions/infrastructure/github-pages-mirror-per-site
  - services/hosting/cloudflare-pages
  - architecture/layer-1-static-hosting
---

# Cloudflare Pages free hosts every site; Firebase Hosting dropped

## Decision

Every site in the family — all 11 current sites, the extensions
catalog, and per-extension subdomains — deploys to Cloudflare Pages
free. Firebase Hosting is no longer used. The `oriz-journal` site,
which previously hosted on Firebase Hosting, moves to Cloudflare
Pages so all sites share one host.

## Why

Cloudflare Pages free has unlimited bandwidth, unlimited
static-asset requests, 100 projects/account (soft cap), 100 custom
domains/project, 500 builds/month — well above the family's needs
indefinitely. It fails closed with HTTP 1027 at quota, no card
required ever. Firebase Hosting offered no advantage over this and
came tied to the same Firebase project we're keeping on Spark —
running both was needless surface area.

## Implications

- Every site gets a `wrangler.toml` with `name = "oriz-<site>"`, `compatibility_date`, and `[assets] directory = "./dist"`.
- Deploy command: `pnpm wrangler pages deploy dist`.
- Master matrix workflow at `chirag127/oriz/.github/workflows/deploy.yml` runs deploys (one job per site) on master pointer-bump commits.
- Each site also builds a static GitHub Pages mirror per [github-pages-mirror-per-site](./github-pages-mirror-per-site.md) for survival fallback.
- Firebase project usage is now exclusively Auth + Firestore + App Check + (future) Storage — never Hosting.
- DNS: `*.oriz.in` subdomains resolve to Cloudflare Pages projects via Cloudflare DNS free.

## Cross-refs

- [Firebase Spark forever](./firebase-spark-forever.md)
- [No subscriptions anywhere](../monetisation/no-subscriptions-anywhere.md)
- [GitHub Pages mirror per site](./github-pages-mirror-per-site.md)
- [Cloudflare Pages service entry](../../services/hosting/cloudflare-pages.md)
- [Layer 1 — Static hosting architecture](../../architecture/layer-1-static-hosting.md)
