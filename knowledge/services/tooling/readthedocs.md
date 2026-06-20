---
type: service
title: "Read the Docs"
description: "SDK + API reference docs hosting — versioned, searchable, free for open-source."
tags: [docs, sdk, hosting, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: sdk-api-docs
provider: readthedocs
free_tier: "Unlimited public projects, versioned docs, search, PDF export, custom domain — free for open-source"
swap_cost: medium
---

# Read the Docs

## Role

Hosts API + SDK reference documentation for the family's npm
packages — starting with
[`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md)
JSDoc + TypeScript reference, then each oriz-* package as it
matures. NOT used for site `/privacy` pages: those stay inline as
Astro pages on each site, per the
[per-extension privacy policy](../../policy/privacy-policy-per-extension.md).

## Free tier

- Unlimited public projects (free for open-source)
- Versioned docs (one URL per release)
- Built-in search across versions
- PDF + ePub export
- Custom domain support
- GitHub webhook auto-builds on push

## Card / subscription required?

**NO.** Free tier is permanent for open-source projects on a public
git repo.

## Alternatives

- GitHub Pages with mkdocs / docusaurus / starlight (works, but
  duplicates the per-site Astro stack)
- Astro Starlight on a subdomain (a viable swap target — same Astro
  stack the family already runs)
- Mintlify (paid past 3 users)
- Docs.rs (Rust-only)

## Swap cost

Medium — docs source is plain markdown / mdx + a `conf.py` (Sphinx)
or `mkdocs.yml`, both portable. The hosted-search and version
selector are the bits that re-build elsewhere. URLs change on swap,
so package READMEs need updating.

## Why this is our pick

Free for open-source forever, versioning is built-in (matters for
SDK docs that need to track multiple package releases), and the
hosted search beats anything we'd build on our own subdomain. Keeps
SDK docs out of each site's Astro build, so site builds stay fast.

## Cross-refs

- [oriz-kit glossary entry](../../glossary/o-r/oriz-kit.md)
- [Per-extension privacy policy](../../policy/privacy-policy-per-extension.md) — site /privacy stays inline, NOT on RTD
- [decisions/architecture/lifestream-jsonl-canonical.md](../../decisions/architecture/lifestream-jsonl-canonical.md) — one canonical-store decision example
- [No card-on-file rule](../../rules/no-card-on-file.md)
