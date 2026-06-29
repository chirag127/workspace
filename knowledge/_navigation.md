---
type: navigation
title: "Knowledge navigation \u2014 where to look in knowledge/"
description: Extracted from AGENTS.md 2026-06-22 to keep AGENTS.md tight. This file
  maps user-intent ('looking for X') to the right knowledge/ path. Includes the per-site
  knowledge convention.
tags:
- navigation
- index
- meta
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
---


# Knowledge navigation

## Where to look in `knowledge/`

| Looking for | Read |
|---|---|
| **How to OPERATE this knowledge bundle as an AI agent** (start here on every session) | [`rules/agent/agent-minimum-context.md`](./rules/agent/agent-minimum-context.md) |
| Why we do (or don't do) something | [`rules/`](./rules) |
| When + why a specific decision was locked | [`decisions/`](./decisions) |
| Which external services we use + free-tier limits + alternatives | [`services/`](./services) |
| The 5-layer stack + API umbrella + canonical store | [`decisions/stack/`](./decisions/stack) |
| Age-gating, monetisation, ingester contract, secrets handling | [`policy/`](./policy) |
| Step-by-step actions (auth setup, add a site, rotate secrets) | [`runbooks/`](./runbooks) |
| Per-site v2 design briefs + family design rules | [`design/`](./design) |
| Family-specific term definitions | [`glossary/`](./glossary) |
| Multi-engine "Search the web" button — every site ships one (in `@chirag127/oriz-kit` as `<MultiSearch />`) | [`decisions/frontend/multi-engine-search-button.md`](./decisions/frontend/multi-engine-search-button.md) |
| Repo naming — sites are `<subdomain-prefix>-site`; extensions `-ext`, VS Code extensions `-vsc-ext`, CLIs `-cli`, MCP servers `-mcp`, Workers `-worker`, Cloud Functions `-fn`, data repos `-data`, agent skills `-skill`, rule bundles `-rules`. NPM packages stay clean (no suffix). | [`branding/repo-naming-suffixes.md`](./branding/repo-naming-suffixes.md) |
| Workspace layout — `repos/<owner>/<own\|forks>/<bucket>/<category>/<repo>/` 5-level hierarchy. Owner is `oriz/` (oriz-org) or `c127/` (chirag127). Buckets are `prod` / `svc` / `lib` / `content`. Folder names shortened 2026-06-24 (bs-ext, ide-ext, mcp, npm, api). | [`infrastructure/projects-owner-own-forks-layout.md`](infrastructure/projects-owner-own-forks-layout.md) |
| Org rename oriz-co → oriz-org (2026-06-24) — GitHub auto-redirects; supersedes the 2026-06-22 migrate-to-oriz-org runbook | [`branding/oriz-org-rename-from-co.md`](./branding/oriz-org-rename-from-co.md) |
| cs-me-app moved from oriz-org → chirag127 (personal, puter.js auth, no brand auth) | <!-- TODO: broken link, was [`branding/cs-me-app-moved-to-chirag127.md`](./branding/cs-me-app-moved-to-chirag127.md) --> |
| Recruiter strategy — pinned repos + contribution graph carry the signal; repo list is a tiebreaker | [`rules/interaction/recruiter-strategy.md`](./rules/interaction/recruiter-strategy.md) |
| Profile README must cross-link — chirag127 ↔ oriz-org both surfaces lead to the other in one click | [`rules/interaction/profile-readme-cross-link.md`](./rules/interaction/profile-readme-cross-link.md) |
| Geo-routed payment matrix — Razorpay (India) + Lemon Squeezy (international, MoR) + keygen.sh (licenses) + six donation rails | [`monetisation/max-payment-methods.md`](./monetisation/max-payment-methods.md) |
| Razorpay donation button (one-time) — pl_T4iEPIDcALKLPk, mounted on every app's `/sponsors` route + oriz-cs-me-app footer | [`security/razorpay-donation-button.md`](./security/razorpay-donation-button.md) |
| RSS → every-platform cross-poster — `@chirag127/oriz-omnipost` watches `blog.oriz.in/rss.xml` | [`decisions/content/cross-post-engine.md`](./decisions/content/cross-post-engine.md) |
| Secrets management — Doppler upstream; GitHub Secrets / CF Worker secrets / Firebase config are runtime mirrors | [`security/secrets-management-doppler.md`](./security/secrets-management-doppler.md) |
| SOPS — git-native value-level encryption (CNCF Sandbox, v3.13.1) | [`services/business/security/sops.md`](./services/business/security/sops.md) |
| age — file encryption backend for SOPS, single-key recovery via Bitwarden | [`services/business/security/age.md`](./services/business/security/age.md) |
| Three-env file split — `.env` (shared) + `.env.development` (TEST) + `.env.production` (LIVE), all SOPS-encrypted | [`security/env-three-file-split.md`](./security/env-three-file-split.md) |
| **Env files in submodules** — every submodule has `.env` (gitignored) + `.env.enc` (committed, sops) + `.env.example` (committed, placeholders); all use the SAME age key from Bitwarden | [`rules/security/submodule-env-files-three-file-pattern.md`](./rules/security/submodule-env-files-three-file-pattern.md) |
| Consent management — 5-category Klaro; geo-routed defaults | [`security/consent-management-multi-category.md`](./security/consent-management-multi-category.md) |
| Auto-only tracking — every metric auto-captured | [`rules/interaction/auto-only-tracking.md`](./rules/interaction/auto-only-tracking.md) |
| Env keys + GH Actions secrets — single source of truth, two delivery tracks | [`security/env-and-secrets-single-source.md`](./security/env-and-secrets-single-source.md) |
| packages.oriz.in catalog hub — auto-discovery catalog of every `@chirag127/*-npm-pkg` repo | [`decisions/packages/packages-oriz-in-catalog.md`](./decisions/packages/packages-oriz-in-catalog.md) |
| Brand capitalisation — Title-Case "Oriz" in user-facing copy; lowercase in identifiers | [`branding/title-case-oriz.md`](./branding/title-case-oriz.md) |
| Revenue channels 2026 — every product auto-publishes to as many channels as 2026 APIs allow | [`monetisation/revenue-channels-2026.md`](./monetisation/revenue-channels-2026.md) |
| Book publish pipeline — 5 books, Markua → Pandoc → EPUB+PDF+MOBI via `@chirag127/oriz-book-build` | [`decisions/content/book-publish-pipeline.md`](./decisions/content/book-publish-pipeline.md) |
| Design divergence is NOT duplication — per-app Header/Footer/Wordmark intentional | [`rules/design/design-divergence-vs-dedup.md`](./rules/design/design-divergence-vs-dedup.md) |
| Monetisation channel matrix — per-channel + per-app | [`policy/monetisation-channel-matrix.md`](./policy/monetisation-channel-matrix.md) |
| Drafts queue host — private GH repo `chirag127/oriz-drafts` with Issues (Telegram banned in India) | [`decisions/compute/drafts-queue-host.md`](./decisions/compute/drafts-queue-host.md) |
| Telegram is banned in India — drafts via GH Issues; no Telegram bots | <!-- TODO: broken link, was [`rules/no-telegram-india-banned.md`](./rules/no-telegram-india-banned.md) --> |
| No PAID self-hosting — free providers (Supabase / Render / Fly / Oracle Always-Free / etc.) are FINE | [`rules/infrastructure/no-paid-self-hosting-only.md`](./rules/infrastructure/no-paid-self-hosting-only.md) |
| No Firebase Cloud Functions (Blaze required, card on file banned) | [`rules/infrastructure/no-firebase-functions-blaze.md`](./rules/infrastructure/no-firebase-functions-blaze.md) |
| Fork discipline — minimum-diff, rebase-friendly, `repos/<owner>/forks/<upstream-name>/` (owner = `oriz/` for brand-maintained, `c127/` for drive-by) | [`rules/development/fork-discipline.md`](./rules/development/fork-discipline.md) |
| CF Pages branch-deploys (100-project mitigation) | [`runbooks/platform/cf-pages-branch-deploys.md`](./runbooks/platform/cf-pages-branch-deploys.md) |
| Family inventory (canonical counts SSoT) — 27 apps + 23 npm packages + 5 books + 15 APIs + 2 browser-extension forks + 75 submodules | [`services/infra/dev-tools/family-inventory.md`](./services/infra/dev-tools/family-inventory.md) |

## Per-site knowledge

Per-app knowledge lives INSIDE each app submodule under its own
`knowledge/` folder (OKF-light: `index.md` + `decisions/` + `runbooks/` +
`services/`). The richest example is
<!-- TODO: broken link, was [`repos/c127/own/prod/apps/personal/cs-me-app/knowledge/`](./repos/c127/own/prod/apps/personal/cs-me-app/knowledge) -->
— lifestream architecture, age-gating, ingester contract, 100-year
strategy. Each per-app bundle follows the same OKF contract
([`_okf.md`](./_okf.md)). Master `knowledge/` holds family-wide rules /
decisions / architecture only; the deprecated `knowledge/sites/<app>/`
location is NOT used.
