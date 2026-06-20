---
type: index
title: "Hosting services"
description: "Static hosting providers used (or considered) by the oriz family."
tags: [services, hosting, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Hosting services

Every site in the family is a static build deployed to a host in this list. Primary is Cloudflare Pages; GitHub Pages is the survival mirror; Vercel and Netlify are documented swap targets.

| Service | Status | One-line role |
|---|---|---|
| [cloudflare-pages.md](./cloudflare-pages.md) | active (primary) | Unlimited bandwidth static host for every site |
| [github-pages.md](./github-pages.md) | active (survival fallback) | §16 mirror — survives if every primary dies |
| [vercel.md](./vercel.md) | fallback | Hobby tier swap target |
| [netlify.md](./netlify.md) | fallback | Documented swap target |
| [firebase-hosting.md](./firebase-hosting.md) | rejected | Spark 360 MB/day shared cap is too tight for 11+ sites |

## Cross-refs

- [Layer 1 — static hosting](../../architecture/layer-1-static-hosting.md)
- [Layer 2 — survival fallback](../../architecture/layer-2-survival-fallback.md)
- [decisions/cloudflare-pages-for-all-sites](../../decisions/cloudflare-pages-for-all-sites.md)
- [decisions/github-pages-mirror-per-site](../../decisions/github-pages-mirror-per-site.md)
