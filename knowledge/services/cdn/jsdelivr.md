---
type: service
title: "jsDelivr"
description: "npm + GitHub package CDN. Browser-side imports of @chirag127/oriz-kit served at cdn.jsdelivr.net. Free, unlimited, no card."
tags: [cdn, npm, package-delivery, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: npm-cdn
provider: jsdelivr
free_tier: "Unlimited bandwidth, unlimited requests, no account needed"
swap_cost: low
related:
  - services/cdn/index
  - rules/never-hit-quotas
  - rules/no-card-on-file
---

# jsDelivr

## Role

Browser-side delivery of npm packages, used primarily for
`@chirag127/oriz-kit` and any other public family package consumed
via `<script type="module">` or import-map. The canonical URL shape is:

```
https://cdn.jsdelivr.net/npm/@chirag127/oriz-kit@latest/dist/index.js
```

This lets static-site embeds (e.g. extensions' marketing pages, the
oriz-home portal, third-party demos) pull oriz-kit primitives without
a build step. Sites that DO have a build step still bundle from npm
locally — jsDelivr is for the no-bundler case.

## Free tier

- Unlimited bandwidth
- Unlimited requests
- No account required (no sign-up, no API key, no DSN)
- Global multi-CDN edge (Cloudflare + Fastly + Bunny + Quantil)
- Auto-versioning via `@latest`, `@1.x`, exact semver, or commit SHA
- Native CORS, immutable caching, Brotli + gzip

## Card / subscription required?

**NO.** No account exists — jsDelivr is a public good. Nothing to
pay, nothing to log into.

## Alternatives

- unpkg — same shape, single-CDN (Cloudflare only), occasional outages
- esm.sh — additionally rewrites CJS → ESM, more processing
- Skypack (deprecated 2024)
- Self-hosting on Cloudflare R2 (rejected — R2 costs money on egress)

## Swap cost

Low — change the URL prefix. unpkg uses `unpkg.com/@chirag127/...`
with the same path tail. The oriz-kit consumers use a single helper
constant for the CDN base, so swapping is one-line.

## Why this is our pick

The most reliable free npm CDN. Multi-CDN backbone means single-edge
outages don't take the family down. No account = no quota = no
self-update task to track usage. Pairs with the family's
publish-to-npm flow without any extra config.

## Cross-refs

- [oriz-kit glossary](../../glossary/o-r/oriz-kit.md)
- [Never hit quotas rule](../../rules/never-hit-quotas.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
