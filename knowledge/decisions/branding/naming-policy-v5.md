---
type: decision
title: "Naming policy v5 — universal suffix matrix, per-language + per-runtime + per-target"
description: "Fifth-pass naming. Every repo carries a suffix that names: (1) runtime category (-site, -app, -worker, -fn), (2) language + registry (-npm-pkg, -py-pkg, -rs-crate, -go-mod, -npm-cli, -py-cli, -rs-cli), (3) extension target (-browser-ext, -vsc-ext). Sites with code that ships as PWA + APK + EXE use -app; web-only marketing pages use -site. Single cross-platform repo per app via PWABuilder."
tags: [naming, repo, suffix, family, branding, v5, cross-platform, pwa]
timestamp: 2026-06-21
format_version: okf-v0.1
status: active
supersedes: [decisions/branding/repo-naming-suffixes, decisions/branding/keep-oriz-add-site-suffix, decisions/branding/naming/policy/family-naming-policy]
related: [decisions/architecture/multi-target-build, decisions/architecture/family-deploy-architecture]
---

# Naming policy v5

## Decision

Every chirag127 repo carries a suffix that names its category. Five
axes are encoded in the suffix:

1. **Runtime / deploy target** (site vs app vs worker vs function)
2. **Language + registry** (npm vs Python vs Rust vs Go)
3. **Sub-role** (package vs CLI)
4. **Extension target** (browser vs VS Code)
5. **Service category** (data, skill, rules, MCP)

The org slug `chirag127/` is the prefix; no brand prefix in the slug.

## The matrix

| Category | Suffix | Examples |
|---|---|---|
| Web-only site (marketing, status) | `-site` | (no current uses — apex hub `home-app` ships as PWA too) |
| Multi-target app (PWA → site + APK + EXE) | `-app` | `pdf-tools-app`, `journal-app`, `me-app`, `home-app` |
| npm package | `-npm-pkg` | `astro-shell-npm-pkg`, `firebase-init-npm-pkg`, `auth-ui-npm-pkg` |
| Python package (PyPI) | `-py-pkg` | future |
| Rust crate (crates.io) | `-rs-crate` | future |
| Go module | `-go-mod` | future |
| npm CLI | `-npm-cli` | `oriz-deploy-npm-cli` |
| Python CLI | `-py-cli` | future |
| Rust CLI | `-rs-cli` | future |
| Browser extension (cross-browser via WXT) | `-browser-ext` | future |
| VS Code extension | `-vsc-ext` | future |
| Model Context Protocol server | `-mcp-server` | future |
| Cloudflare Worker | `-worker` | `api-worker` (future) |
| Cloudflare / Firebase Function | `-fn` | `og-image-fn` (future) |
| Static data repo | `-data` | `oriz-me-data` |
| Agent skill (Claude Code, etc.) | `-skill` | `grill-me-skill`, `agents-md-sync-skill` |
| Agent rule bundle | `-rules` | `family-rules` (future) |
| Umbrella / meta / knowledge bundle | _(no suffix)_ | `workspace` |

## What changed from v4

Fourth pass (v4) used `<subdomain-prefix>-site` for sites and bare
scoped names for npm packages. Fifth pass adds:

- Every site that ships as a PWA becomes `-app` (24 renames).
- npm packages get explicit `-npm-pkg` suffix to differentiate from
  future Python / Rust / Go packages.
- CLIs get explicit per-language suffixes.
- Browser extensions become `-browser-ext` (was `-ext`).
- MCP servers become `-mcp-server` (was `-mcp`).

## The 24 site → app renames (locked)

Every site repo becomes `-app` because every site is a PWA per
[multi-target-build](../architecture/multi-target-build.md). Sites
ship as static web + APK + EXE artifacts from one codebase.

| Old slug | New slug | Subdomain |
|---|---|---|
| `chirag127/home-site` | `chirag127/home-app` | oriz.in |
| `chirag127/blog-site` | `chirag127/blog-app` | blog.oriz.in |
| `chirag127/journal-site` | `chirag127/journal-app` | journal.oriz.in |
| `chirag127/me-site` | `chirag127/me-app` | me.oriz.in |
| `chirag127/cards-site` | `chirag127/cards-app` | cards.oriz.in |
| `chirag127/lore-site` | `chirag127/lore-app` | (TBD) |
| `chirag127/ncert-site` | `chirag127/ncert-app` | ncert.oriz.in |
| `chirag127/post-site` | `chirag127/post-app` | post.oriz.in |
| `chirag127/janaushdhi-site` | `chirag127/janaushdhi-app` | (TBD) |
| `chirag127/pdf-tools-site` | `chirag127/pdf-tools-app` | pdf.oriz.in |
| `chirag127/image-tools-site` | `chirag127/image-tools-app` | image.oriz.in |
| `chirag127/finance-tools-site` | `chirag127/finance-tools-app` | finance.oriz.in |
| `chirag127/dev-tools-site` | `chirag127/dev-tools-app` | dev.oriz.in |
| `chirag127/text-tools-site` | `chirag127/text-tools-app` | text.oriz.in |
| `chirag127/convert-tools-site` | `chirag127/convert-tools-app` | convert.oriz.in |
| `chirag127/qr-tools-site` | `chirag127/qr-tools-app` | qr.oriz.in |
| `chirag127/data-tools-site` | `chirag127/data-tools-app` | data.oriz.in |
| `chirag127/audio-tools-site` | `chirag127/audio-tools-app` | audio.oriz.in |
| `chirag127/video-tools-site` | `chirag127/video-tools-app` | video.oriz.in |
| `chirag127/seo-tools-site` | `chirag127/seo-tools-app` | seo.oriz.in |
| `chirag127/crypto-tools-site` | `chirag127/crypto-tools-app` | crypto.oriz.in |
| `chirag127/health-tools-site` | `chirag127/health-tools-app` | health.oriz.in |
| `chirag127/random-tools-site` | `chirag127/random-tools-app` | random.oriz.in |
| `chirag127/print-tools-site` | `chirag127/print-tools-app` | print.oriz.in |

## The 25 package → npm-pkg renames (locked)

Every npm package repo gets the `-npm-pkg` suffix. Repo slug changes;
the npm package name itself STAYS bare (`@chirag127/astro-shell`, etc.)
— only the GitHub repo identifier carries the registry indicator.

| Old slug | New slug | npm name (unchanged) |
|---|---|---|
| `chirag127/astro-shell` | `chirag127/astro-shell-npm-pkg` | `@chirag127/astro-shell` |
| `chirag127/astro-chrome` | `chirag127/astro-chrome-npm-pkg` | `@chirag127/astro-chrome` |
| `chirag127/astro-tools` | `chirag127/astro-tools-npm-pkg` | `@chirag127/astro-tools` |
| `chirag127/astro-config` | `chirag127/astro-config-npm-pkg` | `@chirag127/astro-config` |
| `chirag127/astro-icons` | `chirag127/astro-icons-npm-pkg` | `@chirag127/astro-icons` |
| `chirag127/astro-ai` | `chirag127/astro-ai-npm-pkg` | `@chirag127/astro-ai` |
| `chirag127/astro-forms` | `chirag127/astro-forms-npm-pkg` | `@chirag127/astro-forms` |
| `chirag127/astro-data` | `chirag127/astro-data-npm-pkg` | `@chirag127/astro-data` |
| `chirag127/astro-pdf` | `chirag127/astro-pdf-npm-pkg` | `@chirag127/astro-pdf` |
| `chirag127/astro-image` | `chirag127/astro-image-npm-pkg` | `@chirag127/astro-image` |
| `chirag127/astro-video` | `chirag127/astro-video-npm-pkg` | `@chirag127/astro-video` |
| `chirag127/astro-crypto` | `chirag127/astro-crypto-npm-pkg` | `@chirag127/astro-crypto` |
| `chirag127/astro-finance` | `chirag127/astro-finance-npm-pkg` | `@chirag127/astro-finance` |
| `chirag127/astro-text` | `chirag127/astro-text-npm-pkg` | `@chirag127/astro-text` |
| `chirag127/astro-qr` | `chirag127/astro-qr-npm-pkg` | `@chirag127/astro-qr` |
| `chirag127/firebase-init` | `chirag127/firebase-init-npm-pkg` | `@chirag127/firebase-init` |
| `chirag127/auth-ui` | `chirag127/auth-ui-npm-pkg` | `@chirag127/auth-ui` |
| `chirag127/paywall` | `chirag127/paywall-npm-pkg` | `@chirag127/paywall` |
| `chirag127/config` | `chirag127/config-npm-pkg` | `@chirag127/config` |
| `chirag127/share` | `chirag127/share-npm-pkg` | `@chirag127/share` |
| `chirag127/search` | `chirag127/search-npm-pkg` | `@chirag127/search` |
| `chirag127/consent` | `chirag127/consent-npm-pkg` | `@chirag127/consent` |
| `chirag127/analytics` | `chirag127/analytics-npm-pkg` | `@chirag127/analytics` |
| `chirag127/legal` | `chirag127/legal-npm-pkg` | `@chirag127/legal` |
| `chirag127/status` | `chirag127/status-npm-pkg` | `@chirag127/status` |

## Local folder layout

`projects/websites/` → `projects/apps/` with four subdirs:

- `projects/apps/tools/` — 15 tool apps
- `projects/apps/content/` — blog, journal, lore, ncert, cards
- `projects/apps/personal/` — me
- `projects/apps/hub/` — home

`projects/skills/` — 2 agent skill submodules (unchanged).
`projects/npm-packages/` — 25 npm package submodules.

## Why universal suffix this time

- **Per-language + per-registry signaling** future-proofs the family
  for Python / Rust / Go packages without rename pressure later.
- **`-app` signals multi-target builds** so CI infrastructure picks
  the right workflow per repo from the suffix alone.
- **GitHub org listing** sorts repos by suffix; recruiter scanning is
  fastest with explicit categorization.

## Rejected this pass

- Keep brand-only slugs (`pages`, `tabs`, `roam`, `echo`) — fourth-pass
  reversal continued.
- Keep `-site` on multi-target repos — apps deserve their own suffix
  because the build matrix differs.
- Per-browser ext repos (`-chrome-ext` / `-firefox-ext` / `-edge-ext`
  / `-safari-ext`) — single cross-browser repo via WXT preferred.

## Cross-refs

- [decisions/architecture/multi-target-build](../architecture/multi-target-build.md)
- [decisions/architecture/family-deploy-architecture](../architecture/family-deploy-architecture.md)
- [rules/keep-knowledge-fresh](../../rules/keep-knowledge-fresh.md)
- [runbooks/rename-repo](../../runbooks/rename-repo.md)
