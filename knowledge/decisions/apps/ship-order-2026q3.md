---
type: decision
title: "Q3 2026 ship order — home + janaushdhi + ncert + blog first, then 16 tools, books in parallel"
description: Q3 2026 ship order. Home, janaushdhi, ncert, blog FIRST. 16 tool subdomains. 5 books
tags: [decision, roadmap, q3-2026, ship-order, priority]
timestamp: 2026-06-21
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/home-app-shape
  - decisions/architecture/janaushdhi-app-scope
  - decisions/architecture/ncert-app-scope
  - decisions/architecture/blog-cross-post-strategy
  - decisions/architecture/tools-shape-and-priority
  - decisions/architecture/books-publishing-shape
  - policy/monetisation-channel-matrix
  - rules/communication-stt-friendly
  - rules/no-telegram-india-banned
---

# Q3 2026 ship order

## The order

**Wave 1 — flagship four (block everything else):**

1. `home-app` — `oriz.in` marketing landing + 5-section grid
2. `janaushdhi-app` — `janaushdhi.oriz.in` daily price scrape + substitute finder
3. `ncert-app` — `ncert.oriz.in` merged-PDF catalog
4. `pages-blog-app` — `blog.oriz.in` daily post + omni-publish fan-out

**Wave 2 — 16 tools in this exact order:**

paisa-finance, slice-pdf, scribe-text, pixie-image, grid-qr, forge-dev, shift-convert, dice-random, cipher-crypto, paper-print, vitals-health, rank-seo, reel-video, echo-audio, pivot-data, then any remainder.

**Wave 3 — content apps (after Wave 1 + 2):**

tabs-cards-app, roam-journal-app, lore-book-summaries-app. See [[decisions/architecture/content-apps-scope]].

**Parallel track — 5 books drafted concurrently with Wave 1:**

Oriz Me drafts FULLY. Other 4 (Stack, Paisa, PDF, Janaushdhi) chapter outlines only. See [[decisions/architecture/books-publishing-shape]].

## Constraints baked into the order

- **Per-channel monetisation matrix** governs revenue everywhere ? [[policy/monetisation-channel-matrix]]
- **STT-friendly question rounds** when grilling ? [[rules/communication-stt-friendly]]
- **No Telegram for India-resident user** ? drafts queue on GH Issues ? [[rules/no-telegram-india-banned]] + [[decisions/architecture/drafts-queue-host]]

## Why this order

home + janaushdhi + ncert + blog are the four surfaces that anchor the brand publicly. Tools follow because each tool subdomain inherits the home-app chrome + analytics. Books drafted in parallel because writing is not blocked by code.

## Cross-refs

- Books-app stays static catalog ? [[decisions/architecture/books-publishing-shape]]
- Tools shape + priority ? [[decisions/architecture/tools-shape-and-priority]]
