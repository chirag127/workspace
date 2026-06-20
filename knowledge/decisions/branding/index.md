---
type: index
title: "Branding decisions"
description: "Locked decisions on family naming — repos, packages, domain, and member sites."
tags: [decisions, branding, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Branding decisions

| Decision | One-line summary |
|---|---|
| [keep-oriz-add-site-suffix.md](./keep-oriz-add-site-suffix.md) | Repos become `oriz-<name>-site` / `oriz-<name>-ext`; packages keep `@chirag127/oriz-*` |
| [oriz-kit-package-name.md](./oriz-kit-package-name.md) | `@chirag127/oriz-kit` is the canonical kit package name |
| [oriz-me-added-to-family.md](./oriz-me-added-to-family.md) | `oriz-me` joined the family on 2026-06-19 as the 11th site |
| [omnipost-name.md](./omnipost-name.md) | Cross-post engine package name locked to `@chirag127/oriz-omnipost` |
| [i18n-weblate-when-ready.md](./i18n-weblate-when-ready.md) | English-only today; Weblate Hosted Libre is the chosen translation-management platform when the family adds languages |
| [oriz-urls-to-md-site-empty-placeholder.md](./oriz-urls-to-md-site-empty-placeholder.md) | `oriz-urls-to-md-site` is an empty repo, a deliberate slug reservation for a future URL → Markdown scraper. DO NOT delete |
| [family-wide-privacy-page.md](./family-wide-privacy-page.md) | Master `oriz.in/privacy` is the canonical family-wide privacy policy; per-surface addenda at `/privacy/<site>`, `/privacy/extension/<name>`, `/privacy/worker/<name>`, `/privacy/cli/<name>`. Self-hosted on Cloudflare Pages, no third-party legal-doc tool |
| [title-case-oriz.md](./title-case-oriz.md) | Brand mark is Title-Case **"Oriz"** in user-facing copy (homepage wordmark, page titles, meta, READMEs, social, OG, status page, email "from"). Repo slugs / npm package names / DOM attrs / CSS vars / env vars / shell stay lowercase — they are identifiers, not display strings |
