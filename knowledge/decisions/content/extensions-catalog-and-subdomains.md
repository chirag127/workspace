---
type: decision
title: "Keep extensions.oriz.in catalog AS WELL AS per-extension subdomains"
description: "Both surfaces exist: a central catalog at extensions.oriz.in for browsing/discovery and individual <slug>.oriz.in subdomains for each extension's deep website."
tags: [extensions, catalog, subdomain, navigation]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/content/per-extension-subdomain
  - decisions/content/big-website-per-extension
  - decisions/content/oriz-home-cross-promos-extensions
---

# Keep extensions.oriz.in catalog AS WELL AS per-extension subdomains

## Decision

The `extensions.oriz.in` catalog is NOT being collapsed in favor of
per-extension subdomains. Both exist: the catalog is the family-wide
"browse all extensions" surface, and each `<slug>.oriz.in` is the
deep marketing/docs site for one extension. They cross-link.

## Why

Per-extension subdomains optimise for SEO and store-review compliance
on a single product. The catalog optimises for users who want to see
the family's full extension portfolio in one view — a different
intent. Killing the catalog would lose the cross-discovery surface
and the apex AdSense placement opportunity; killing per-extension
subdomains would lose store-friendly privacy URLs and per-product
SEO. Both are cheap on Cloudflare Pages free, so we keep both.

## Implications

- `extensions.oriz.in` lists every extension with name, one-line pitch, install buttons, and a "learn more" link to `<slug>.oriz.in`.
- Each `<slug>.oriz.in` site links back to the catalog in its footer.
- The catalog is also embedded as a section at `oriz.in/extensions` for cross-promo (see [oriz-home-cross-promos-extensions](./oriz-home-cross-promos-extensions.md)).
- Catalog data is generated from the `extensions/` submodules' manifests at build time — single source of truth, no drift between the catalog and per-extension sites.
- AdSense apex application covers all of these per AdSense 2026 rules.

## Cross-refs

- [Per-extension subdomain](./per-extension-subdomain.md)
- [Big website per extension](./big-website-per-extension.md)
- [oriz-home cross-promos extensions](./oriz-home-cross-promos-extensions.md)
- [AdSense apex application](../monetisation/adsense-apex-application.md)
