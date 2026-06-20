---
type: decision
title: "oriz-home portal also lists extensions"
description: "The oriz.in home portal renders the extensions catalog as a section so visitors arriving at the apex see both sites and extensions."
tags: [extensions, home, portal, cross-promo]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/content/extensions-catalog-and-subdomains
  - decisions/content/per-extension-subdomain
---

# oriz-home portal also lists extensions

## Decision

The `oriz-home` site at `oriz.in` includes a section listing every
extension in the family — same data that powers `extensions.oriz.in`,
just rendered inline on the home portal's datasheet so visitors at
the apex domain see the full product surface area.

## Why

Visitors arriving at `oriz.in` are usually recruiters or
collaborators discovering the family for the first time. Hiding
extensions one click away on a separate subdomain costs discovery.
Inlining the catalog on the home page surfaces every shipped
extension to that audience without requiring them to know the
`extensions.oriz.in` subdomain exists.

## Implications

- `oriz-home` builds the extensions section from the same generated data that powers `extensions.oriz.in` — no duplication, no drift.
- The home section is curated (top N most-relevant or most-recent extensions) with a "see all" link to `extensions.oriz.in`, NOT a full catalog clone.
- Build-time data fetch reads each extension submodule's manifest + listing metadata.
- Updates to any extension's headline / icon propagate to oriz-home on its next deploy via the master matrix workflow.

## Cross-refs

- [Extensions catalog AND per-extension subdomains](./extensions-catalog-and-subdomains.md)
- [Per-extension subdomain](./per-extension-subdomain.md)
- [Big website per extension](./big-website-per-extension.md)
