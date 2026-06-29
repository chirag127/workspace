---
type: glossary
title: "omnipost"
description: @chirag127/oriz-omnipost: RSS-driven cross-post engine to every platform via Adapter pattern
tags: [glossary, package, cross-post, omnipost]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# omnipost

## Definition

`@chirag127/oriz-omnipost` is the family's RSS-driven cross-post
engine. It watches the canonical blog feed at `blog.oriz.in/rss.xml`
and fans each new entry out to every blogging platform that exposes a
public API.

## Expanded

The package implements the Adapter pattern — one file per platform
(`dev-to.ts`, `hashnode.ts`, …) — plus a short-link fallback for
platforms that refuse long content. Every external post carries a
`canonical_url` back to the original at `blog.oriz.in`, so SEO
authority stays consolidated. State is persisted in a JSON file
committed back to the repo, making the engine idempotent.

The name was chosen on 2026-06-20 — short for **omni** (every) +
**post** — see [`branding/omnipost-name.md`](../../branding/omnipost-name.md).

## See also

- [Cross-post engine architecture](../../decisions/architecture/cross-post-engine.md)
- [Cloudflare Worker short-link](../../services/business/short-link/cloudflare-worker.md)
- <!-- TODO: broken link, was [oriz-kit](./oriz-kit.md) -->
- [package-isolation](./package-isolation.md)
