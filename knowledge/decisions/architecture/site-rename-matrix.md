---
type: decision
title: "Site rename matrix — every site uses -site suffix"
description: "Full rename plan for the 11 existing site repos: every kept site uses the -site suffix; the 4 absorbed-into-tools sites get renamed in place to their new tool-category names. All renames via gh repo rename to preserve issues, stars, forks, history, and gh-pages."
tags: [architecture, repos, naming, migration]
timestamp: 2026-06-20
---

# Site rename matrix — every site uses -site suffix

## The decision

Every site repo gets the `-site` suffix. The 4 existing tool repos get renamed in place into their new tool-category names. **No history wipes.** All renames via `gh repo rename` to preserve everything.

## The matrix

### Kept sites — pure renames

| Old name | New name | Subdomain | What it is |
|---|---|---|---|
| `oriz-blog` | `blog-site` | `blog.oriz.in` | Long-form writing |
| `oriz-home` | `oriz-site` | `oriz.in` (apex) | Brand hub, family directory, account |
| `oriz-me` | `me-site` | `me.oriz.in` | Personal lifestream + portfolio |
| `oriz-journal` | `journal-site` | `journal.oriz.in` | Best-of-five journal apps (Day One + Bear + Notion + Obsidian + Logseq). See [journal-site-sources.md](./journal-site-sources.md). |
| `oriz-book-lore` | `books-site` | `books.oriz.in` | Reading + book reviews |
| `oriz-books` | `ncert-site` | `ncert.oriz.in` | NCERT textbook material (renamed because the apex `books-site` is now the reading app) |
| `oriz-cards` | `cards-site` | `cards.oriz.in` | **Financial cards (India)** — credit + debit + forex + prepaid + travel. See [cards-site-scope.md](./cards-site-scope.md). |

### Tool sites — rename + restructure

These 4 already exist and become the foundation for 4 of the 15 tool subdomains:

| Old name | New name | Subdomain | Notes |
|---|---|---|---|
| `oriz-finance` | `finance-site` | `finance.oriz.in` | EMI, SIP, tax (India + US), retirement, etc. |
| `oriz-image-tools` | `image-site` | `image.oriz.in` | Resize, compress, convert, EXIF strip, etc. |
| `oriz-pdf-tools` | `pdf-site` | `pdf.oriz.in` | Merge, split, compress, OCR, etc. |
| `oriz-urls-to-md` | *merged into* `dev-site` | `dev.oriz.in/url-to-md` | The tool becomes one route inside dev-site. Old repo gets renamed `dev-site` (since dev-site doesn't exist yet), URL-to-MD tool migrated as the seed tool. |

### New repos — created from scratch

The remaining 11 of the 15 tool subdomains, plus none others (no Tier 3 promotions):

`audio-site`, `video-site`, `data-site`, `text-site`, `seo-site`, `crypto-site`, `convert-site`, `health-site`, `qr-site`, `random-site`, `print-site`.

## The rule for future renames

`-site` is the suffix for **anything that ships as a website**. Repos that ship as a package, CLI, extension, worker, or function use the suffix matrix in [repo-naming-suffixes.md](../branding/repo-naming-suffixes.md): `-ext`, `-vsc-ext`, `-cli`, `-worker`, `-fn`, `-data`. npm package names stay clean (no suffix).

## Why no history wipes

User picked "no wipes, rename only" over the wipe options. Reasons that survived:

- `gh repo rename` redirects all old URLs forever — external links don't break.
- Issues, stars, forks, gh-pages, releases all survive.
- History is signal — a 6-month commit log on `oriz-finance` is more recruiter-useful than a 1-day commit log on `finance-site`.
- Rolling back a rename is one command. Rolling back a history wipe is impossible.

## How to actually do it

See [oriz-restructure-2026-06-20.md](../../runbooks/oriz-restructure-2026-06-20.md) for the step-by-step. High-level:

```bash
# For each rename:
gh repo rename --repo chirag127/<old> <new>
# In oriz/ umbrella:
git submodule deinit -f sites/<old>
git rm sites/<old>
git submodule add git@github.com:chirag127/<new>.git sites/<new>
git commit -m "chore(submodules): rename <old> -> <new>"
```

For the 11 new tool repos, run the spin-up runbook ([spin-up-tools-site.md] — to be written) once per repo.

## Related

- [tools-site-15-repos.md](./tools-site-15-repos.md) — why 15 separate repos
- [repo-naming-suffixes.md](../branding/repo-naming-suffixes.md) — the full suffix matrix
- [oriz-restructure-2026-06-20.md](../../runbooks/oriz-restructure-2026-06-20.md) — step-by-step migration
