---
type: service
title: "Family inventory \u2014 canonical counts of apps, packages, books, APIs, submodules"
description: Canonical oriz-org family count totals; cite this file to avoid drift
tags:
- service
- inventory
- counts
- family
- canonical-source-of-truth
timestamp: 2026-06-25
format_version: okf-v0.1
status: active
related:
- architecture/packages/the-23-packages
- decisions/architecture/general/ship-order-2026q3
- decisions/stack/tools-shape-and-priority
- decisions/content/first-book-oriz-learnings
- decisions/content/book-publish-pipeline
- decisions/compute/market-data-apis
- decisions/packages/oriz-ai-providers-package
- decisions/architecture/general/projects-owner-own-forks-layout
- branding/oriz-org-rename-from-co
- architecture/ops/repo-layout
---


# Family inventory — canonical counts

This file is the **single source of truth** for every count claim ("N apps", "N packages", "N books", "N APIs", "N submodules") that appears anywhere else in the knowledge bundle. When a count changes on disk, update THIS file first, then sweep cross-references.

Run `git submodule status | wc -l` from `c:/D/oriz/` to verify the submodule total.

**2026-06-25 scope-cut**: 33 repos archived to `oriz-archive` under the repo-level build-gate. See [[decisions/fleet/scope-cut-2026-06-25]] for the full kill list and rationale. Counts below reflect the post-cut state.

## Apps — 6 total (+ 1 hub)

### Hub (1, not in catalog)

- `home` — `oriz.in` marketing landing; renders the catalog of the apps below.

### Personal (1)

- `me` — `me.oriz.in` personal site (hero, now, uses, CV, contact).

### Content (5)

- `oriz-janaushdhi-app` — `janaushdhi.oriz.in` PMBJP generic medicine catalog.
- `oriz-lore-app` — `book-lore.oriz.in` book / movie / show summaries.
- `oriz-ncert-app` — `books.oriz.in` NCERT textbook directory.
- `blog` — `blog.oriz.in` long-form posts.
- `journal` — `journal.oriz.in` privacy-first PWA journal.

### Archived 2026-06-25 (cut, not counted)

- **Scaffold apps**: `cards`, `finance`, `health`, `packages`, `tools`, `oriz-cipher-crypto-tools-app`, `oriz-forge-dev-tools-app`, `oriz-omni-post-app`.
- **Hub**: `status` (no probes wired).
- **Auth**: `auth` (orphaned by [[no-auth-in-apps-or-apis]]).
- **11 saturated tools archived 2026-06-25 AM**: slice-pdf, pixie-image, reel-video, echo-audio, scribe-text, grid-qr, shift-convert, dice-random, rank-seo, pivot-data, paper-print.

## NPM packages — 0 in-house

All 23 packages archived 2026-06-25 per [[atomic-packages-lazy]] (rebuild any one on 2nd-use). Analytics (CF Web Analytics + Clarity + PostHog + GA4) stays inlined in each app's `BaseLayout.astro` via `<script>` tags; brand tokens live in repo-local `tailwind.config.ts`; SEO helpers are inlined per app.

Community packages are used freely (Astro, React, Tailwind, shadcn, etc.) — only **in-house** packages were cut.

## Books — 3 active drafts (of 5 outlined)

- **Oriz Learnings** — *My Learnings from the Oriz Project family* (full draft in progress).
- **Oriz Janaushdhi** — Generic Medicines India (outline → active drafting).
- **Oriz Stack** — Astro + Cloudflare architecture (outline; *kept on review*).

Cut 2026-06-25 (meta books, not started): `oriz-paisa-book`, `oriz-pdf-book`.

Earlier reference to *Oriz Me* as first-to-draft was superseded 2026-06-22 — `oriz-learnings` is now first.

## APIs — 0 in-house

All 15 India-data APIs archived 2026-06-25 per [[decisions/fleet/scope-cut-2026-06-25]]. Apps that previously consumed them now hit public 3rd-party APIs at build time:

- Currency rates → `api.exchangerate-api.com` (free, no card).
- MF NAV → `api.mfapi.in` (direct).
- Gold rates → GH Actions scrape at build time if needed.
- PMBJP medicine list → `janaushadhi.gov.in` (downloadable JSON, cached in repo).
- NCERT PDFs → `ncert.nic.in` (direct links).
- IFSC, pincode, holidays, etc. → public CSV/JSON datasets cached in repo per [[data-in-app-repos-not-separate]].

Cut list (15): `oriz-air-quality-india-api`, `oriz-currency-rates-api`, `oriz-flow-fii-dii-activity-api`, `oriz-gold-silver-rates-api`, `oriz-ifsc-api`, `oriz-india-budget-numbers-api`, `oriz-india-holidays-api`, `oriz-india-petrol-diesel-api`, `oriz-india-train-schedules-api`, `oriz-india-weather-api`, `oriz-mf-nav-api`, `oriz-mmi-tickertape-mmi-api`, `oriz-nse-bse-tickers-api`, `oriz-pincode-api`, `oriz-rbi-rates-api`. (`openmodel-shim-api` was deleted earlier the same day — see [[openmodel-shim-api-deleted-2026-06-25]].)

## Browser extensions — 4 total

All browser-extension repo slugs follow the `-bs-ext` suffix per [`repo-naming-suffixes`](../branding/repo-naming-suffixes.md) (revised 2026-06-24).

- `ai-rewrite-bs-ext` — Chrome extension, AI-powered text rewriting via Gemini. **Personal fork** of `SupratimRK/Ai-rewrite` (GPL-3.0). Submodule under `repos/oriz/frk/prod/bs-ext/ai-rewrite-bs-ext/`. Repo: `chirag127/Ai-rewrite`.
- `dearrow-plus-bs-ext` — Chrome extension replacing YouTube titles + thumbnails with crowdsourced alternatives. **Personal fork** of `ajayyy/DeArrow` (GPL-3.0), renamed for distinct CWS listing. Submodule under `repos/oriz/frk/prod/bs-ext/dearrow-plus-bs-ext/`. Repo: `oriz-org/dearrow-plus-bs-ext`. Divergence: `showOriginalAlongsideTitle` toggle.
- `chathub-bs-ext` — Multi-LLM chat browser extension. **Personal fork** of `chathub-dev/chathub` (GPL-3.0). Submodule under `repos/oriz/frk/prod/bs-ext/chathub-bs-ext/`. Repo: `oriz-org/chathub-bs-ext`. Divergence: `ALWAYS_PREMIUM=true` (personal-use only — NOT distributed to CWS).
- `bookmark-mind-bs-ext` — Browser extension that auto-categorizes bookmarks via Gemini / Groq / other LLMs; snapshot/undo + model-performance dashboard. **Original** (not a fork). CC BY-NC 4.0. Submodule under `repos/oriz/own/prod/bs-ext/bookmark-mind-bs-ext/`. Repo: `oriz-org/bookmark-mind-bs-ext` (transferred from `chirag127` + renamed from `BookmarkMind-AI-Bookmark-Categorizer-Browser-Extension` on 2026-06-25).

## VS Code / IDE extensions — 1 total

- `sops-lens-vsc-ext` — VS Code extension that renders SOPS-encrypted file values in-editor (CodeLens / hover / ghost-text). Decrypts via the `sops` CLI in-memory, never writes plaintext to disk. **Original (not a fork)**, MIT. Submodule under `repos/oriz/own/prod/ide-ext/sops-lens-vsc-ext/`. Repo: `oriz-org/sops-lens-vsc-ext`.

## Other forks — 2 total

Service-API forks (not browser extensions):

- `freellmapi` — OpenAI-compatible aggregator of 16 free LLM provider tiers. **Personal fork** of `tashfeenahmed/freellmapi` (MIT). Submodule under `repos/oriz/frk/svc/api/freellmapi/`. Repo: `chirag127/freellmapi`. Slug unchanged (MIT product brand).
- `omniroute` — AI gateway / router across 231 providers, 50+ free. **Personal fork** of `diegosouzapw/OmniRoute` (MIT). Submodule under `repos/oriz/frk/svc/api/omniroute/`. Repo: `chirag127/OmniRoute`.

## Submodules — ~20 active (post-cut)

After the 2026-06-25 scope-cut, `.gitmodules` is being swept to remove the 33 archived repos. Approximate composition of the survivors (verify with `cd /c/D/oriz && git submodule status | wc -l` after the cleanup commit):

- 6 app submodules — `home`, `me`, `blog`, `journal`, `oriz-janaushdhi-app`, `oriz-lore-app`, `oriz-ncert-app` (+ `oriz-portfolio-engine-app` if kept).
- 0 npm-package submodules (all 23 archived; rebuild lazily per [[atomic-packages-lazy]]).
- 0 in-house API submodules (all 15 archived; see Cut list above).
- 3 active book submodules — `oriz-janaushdhi-book`, `oriz-me-book`, `oriz-stack-book` *(kept on review)*.
- 1 skill monorepo — `agent-skills` (single repo replacing the per-skill submodules per [[agent-skills-monorepo]]).
- 1 userscript monorepo.
- 3 bs-ext forks — `ai-rewrite-bs-ext`, `dearrow-plus-bs-ext` (`chathub-bs-ext` archived 2026-06-25).
- 1 bs-ext original — `bookmark-mind-bs-ext`.
- 1 IDE extension original — `sops-lens-vsc-ext`.
- 1 CLI fork — *(none — `claude-notifications-cli` deleted 2026-06-29)*.
- 1 MCP server — `clear-thought-mcp-server` *(kept on review)*.
- 2 API forks — `freellmapi`, `omniroute`.
- 1 backup repo — `backup` (restic config + RECOVERY.md per [[backup-keys-repo-oriz-org-backup]]).

Re-verify after the `.gitmodules` sweep with: `cd /c/D/oriz && git submodule status | wc -l`.

## Update protocol

When any count changes on disk:

1. Update THIS file first.
2. Sweep cross-references (`grep -rn '<old-count>' c:/D/oriz/knowledge c:/D/oriz/AGENTS.md c:/D/oriz/README.md`).
3. Update `architecture/the-23-packages.md` if package count changed (and rename the file if the integer rolls).
4. Commit with `docs(knowledge): bump family inventory counts`.

## Cross-refs

- 2026-06-25 scope-cut (33 repos) → [[decisions/fleet/scope-cut-2026-06-25]]
- 11 saturated apps cut earlier same day → [[eleven-saturated-apps-archived-2026-06-25]]
- Lazy atomic packages, analytics inline → [[atomic-packages-lazy]]
- No-auth rule (orphaned the `auth` repo) → [[no-auth-in-apps-or-apis]]
- 23 packages prior enumeration (now archived) → [[architecture/the-23-packages]]
- 16 tools prior order (mostly archived) → [[decisions/stack/tools-shape-and-priority]]
- 26 apps prior ship order (superseded by 6-app catalog) → [[decisions/apps/ship-order-2026q3]]
- First book → [[decisions/content/first-book-oriz-learnings]]
- Book pipeline → [[decisions/content/book-publish-pipeline]]
- Repo layout → [[architecture/repo-layout]]
