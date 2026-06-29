---
type: decision
title: Eleven saturated tools — archived on GitHub and removed locally
description: 11 tool repos fail build-gate (top-3 Google already well). Archived, subdomains freed
tags:
- decision
- apps
- archive
- saturated
- defect-audit
- cleanup
timestamp: 2026-06-25
format_version: okf-v0.1
status: active
related:
- decisions/apps/fleet-strategy-build-gate-2026-06-25
- branding/subdomain-path-based-on-category-2026-06-25
- decisions/architecture/general/ship-order-2026q3
---

# Eleven saturated tools archived

## Decision

These eleven tools fail the defect-audit gate (the top-3 Google results already serve their users well) and are archived on GitHub + removed from local disk:

1. `slice-pdf` — saturated by Smallpdf, iLovePDF, PDF24
2. `pixie-image` — saturated by TinyPNG, Squoosh, ImageOptim
3. `reel-video` — saturated by HandBrake, CloudConvert
4. `echo-audio` — saturated by Audacity, Online Audio Converter
5. `scribe-text` — saturated by free OCR tools (OnlineOCR, Adobe free tier)
6. `grid-qr` — saturated by qr-code-generator.com, every browser extension
7. `shift-convert` — generic unit-conversion is built into Google search results
8. `dice-random` — generic RNG is a calculator / Google one-box feature
9. `rank-seo` — saturated by Ahrefs free tools, Ubersuggest, SEMrush free tier
10. `pivot-data` — saturated by Excel / Sheets pivot tables themselves
11. `paper-print` — print-formatting is a browser native feature

Two of these had real production code on disk (`slice-pdf`, `pixie-image`); the rest were slug-reservations or stubs. The corresponding subdomains are freed.

## Why

- **Build-gate enforcement** — fleet-strategy-build-gate-2026-06-25 says: no top-3 defect, no build.
- **Maintenance burden** — every kept-but-dormant repo costs CI minutes, dependency-bump PRs, SEO attention dilution.
- **Subdomain real estate** — `pdf.oriz.in`, `image.oriz.in`, etc. become available for higher-priority categories.
- **GitHub archive (not delete)** preserves the history and lets the slug remain visible on the org page.
- **slice-pdf and pixie-image had code** — that code is preserved in the archived repo, can be revived later if a defect appears in the competitive landscape.

## Implications

- Run `gh repo archive oriz-org/<slug>` for each of the eleven (or the new non-prefixed name per repo-naming-drop-oriz-prefix-2026-06-25).
- `rm -rf repos/<slug>/` for each, after the umbrella's submodule entry is removed.
- Update `apps.ts` registry to drop these entries.
- Free DNS records: delete CNAMEs for the 11 freed subdomains in Cloudflare.
- Update any cross-links in `knowledge/` that referenced these tools (most should already be neutral since the ship order is also superseded).
- Revival path: if a defect emerges later, the archived repo can be unarchived and rebuilt without re-reserving the slug.
