---
type: rule
title: Cloudflare Pages = apps only. Everything else = GitHub Pages
description: "Locked 2026-06-23. CF Pages hosts the 25 apps under repos/oriz/own/prod/apps/\
  \ ONLY (content + hub + personal + tools). All other surface area \u2014 npm package\
  \ READMEs, API JSON catalogs, books, extensions, skills, forks \u2014 uses GitHub\
  \ Pages with the repo's CNAME pointing to its <repo>.github.io target. Any subdomain\
  \ that surfaces 'more information' style content for a non-app links to oriz.in.\
  \ Removes confusion about which CF Pages projects should exist; bounds the 100-project\
  \ CF Pages soft cap; matches the 'subdomain per app, GH Pages for everything else'\
  \ shape."
tags:
- rule
- hosting
- cloudflare-pages
- github-pages
- apps
- scope
timestamp: 2026-06-23
format_version: okf-v0.1
status: active
related:
- rules/hosting-split-cf-and-github-pages
- rules/infrastructure/one-level-subdomain-only
- decisions/architecture/compute/api-hosting-triple-rail
- decisions/architecture/security/monetization-centralized-on-oriz-in
---



# CF Pages = apps only. Everything else = GitHub Pages

## Rule

A submodule gets a CF Pages project **if and only if** it lives under `repos/oriz/own/prod/apps/`. Everything else — npm packages, APIs, books, extensions, skills, forks, data repos — hosts on GitHub Pages instead. Stale CF Pages projects for non-apps must be deleted.

## The 25 apps that get CF Pages projects

### hub (2)
- `repos/oriz/own/prod/apps/hub/home-app` → `oriz.in` + `www.oriz.in`
- `repos/oriz/own/prod/apps/hub/oriz-status-app` → `status.oriz.in`

### personal (1)
- `repos/oriz/own/prod/apps/personal/oriz-cs-me-app` → `me.oriz.in`

### content (8)
- `repos/oriz/own/prod/apps/content/oriz-financial-cards-app` → `financial-cards.oriz.in`
- `repos/oriz/own/prod/apps/content/oriz-janaushdhi-app` → `janaushdhi.oriz.in`
- `repos/oriz/own/prod/apps/content/oriz-lore-app` → `book-lore.oriz.in`
- `repos/oriz/own/prod/apps/content/oriz-ncert-app` → `books.oriz.in`
- `repos/oriz/own/prod/apps/content/oriz-omni-post-app` → `omni.oriz.in`
- `repos/oriz/own/prod/apps/content/oriz-packages-catalog-app` → `packages.oriz.in`
- `repos/oriz/own/prod/apps/content/oriz-pages-blog-app` → `blog.oriz.in`
- `repos/oriz/own/prod/apps/content/oriz-roam-journal-app` → `journal.oriz.in`

### tools (15)
- `repos/oriz/own/prod/apps/tools/oriz-cipher-crypto-tools-app` → `crypto.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-dice-random-tools-app` → `random.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-echo-audio-tools-app` → `audio.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-forge-dev-tools-app` → `dev.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-grid-qr-tools-app` → `qr.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-paisa-finance-tools-app` → `finance.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-paper-print-tools-app` → `print.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-pivot-data-tools-app` → `data.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-pixie-image-tools-app` → `image.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-rank-seo-tools-app` → `seo.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-reel-video-tools-app` → `video.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-scribe-text-tools-app` → `text.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-shift-convert-tools-app` → `convert.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-slice-pdf-tools-app` → `pdf.oriz.in`
- `repos/oriz/own/prod/apps/tools/oriz-vitals-health-tools-app` → `health.oriz.in`

**Total: 26 CF Pages projects (with `www.oriz.in` sharing the `oriz-app` project).**

## What does NOT get a CF Pages project

- 23 npm packages under `repos/oriz/own/lib/npm/` — npm itself + GH repo's GitHub Pages site for docs
- 19 APIs under `repos/oriz/own/svc/api/` — GH Pages with `<subdomain>.api.oriz.in` CNAME → `oriz-org.github.io` (already wired)
- Books under `repos/oriz/own/content/books/` — GH Pages
- Forks under `repos/oriz/frk/` — no public surface, just code
- Skills under `repos/oriz/own/content/skills/` — GitHub repo + npm publish only
- Data repos under `repos/oriz/own/content/data/` — GH Pages JSON snapshots

For each of these, if a public landing page is desired, host on GH Pages and add a "for more information visit oriz.in" link.

## Why

1. **CF Pages 100-project soft cap** — staying under it. With 26 apps + 5-10 unrelated projects we have ~30, plenty of headroom.
2. **GH Pages for static JSON is correct** — APIs already serve JSON from `oriz-org.github.io`, no Worker/Pages indirection adds value.
3. **CF Pages auto-deploy needs OAuth handshake** — every new CF Pages project requires interactive GitHub authorization once. Limiting to 26 apps means 26 one-time clicks, not 80.
4. **Mental model:** if it's a Pro/Max app you'd monetize, it's on CF Pages. If it's a public catalog/JSON/docs, it's on GH Pages.

## Implementation

Delete from CF Pages dashboard any project that isn't on the 26 list above. Specifically remove (from prior audit):
- `apis-web` — APIs already on GH Pages, this is duplicate
- `pdf-oriz-in` — duplicates `oriz-slice-pdf` for `pdf.oriz.in`
- `finsuite` — old finance tool, replaced by `oriz-paisa-finance`
- `card-oriz-in` — replaced by `oriz-financial-cards`
- `office-os`, `devsuite`, `sovereign`, `sovereign-web` — old projects, not in app list
- `velvet-os` — DEFERRED app, no CF Pages until shipped
- `repo-pilot`, `repoflux`, `project-omnibus` — separate side projects (keep if you want, not oriz family)
- `urls-to-md` — separate tool (keep if active)
- `me` — duplicates `oriz-cs-me`
- `orizpdf` — duplicates `oriz-slice-pdf`
- `oriz`, `oriz-in`, `oriz-status`, `blog`, `janaushadhi-oriz-in` — old wrong-named projects to be retired AFTER new ones have deployments

## Cross-refs

- Cloudflare Pages hosts every website and app (memory) → [[memory/hosting-split-cf-and-github-pages]] (now refined: apps-only)
- One-level subdomain rule → [[rules/one-level-subdomain-only]]
- API hosting triple-rail → [[decisions/architecture/api-hosting-triple-rail]]
- Monetization centralized → [[decisions/architecture/monetization-centralized-on-oriz-in]]
