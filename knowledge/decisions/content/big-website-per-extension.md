---
type: decision
title: "Each extension gets a rich website, not a small landing page"
description: Per-extension full marketing/docs/changelog/support sites
tags: [extensions, website, marketing, content]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/content/per-extension-subdomain
  - decisions/content/per-extension-privacy-policy
  - decisions/content/extensions-catalog-and-subdomains
---

# Each extension gets a rich website, not a small landing page

## Decision

Each `<slug>.oriz.in` site is a full website with multiple pages —
landing / features / pricing / docs / changelog / privacy / support /
blog as relevant — not a single-page landing.

## Why

A rich site ranks better for long-tail queries (e.g. "how to fix X
with <extension>"), gives the user a real onboarding surface after
install, and provides the content depth needed for AdSense approval
on the apex. Single-page landings under-monetise and under-rank.
Cloudflare Pages free tier covers however many pages we ship per
extension, so there's no infra cost to going broader.

## Implications

- Each extension repo includes a full Astro site (or equivalent) under `site/` (or root), not just a README.
- Content includes: features deep-dive, common-use-case tutorials, full changelog, FAQ, troubleshooting docs, install buttons for all 3 stores.
- Per-extension blog posts (when relevant) cross-link to `blog.oriz.in` for SEO link equity.
- Sites use the same `@chirag127/oriz-kit` primitives so the family identity stays coherent — but each extension picks its own accent / typography per the design family rules.
- The 7-day fix-or-pause SLA from the 100-year strategy applies to extension docs too: a stale changelog flags red on the family status page.

## Cross-refs

- [Per-extension subdomain](./per-extension-subdomain.md)
- [Per-extension privacy policy](./per-extension-privacy-policy.md)
- [Extensions catalog AND per-extension subdomains](./extensions-catalog-and-subdomains.md)
- [Cloudflare Pages for all sites](../infrastructure/cloudflare-pages-for-all-sites.md)
