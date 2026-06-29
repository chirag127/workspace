---
type: decision
title: "Hosting migration: Cloudflare Pages -> GitHub Pages + analytics-everywhere stack"
description: CF Pages abandoned for GH Pages, CF DNS retained, analytics everywhere
tags: [hosting, migration, analytics, observability, github-pages, cloudflare-dns]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
supersedes:
  - infrastructure/hosting-split-cf-and-gh-2026-06-25
  - decisions/fleet/multi-git-mirror-and-auto-start-2026-06-28
related:
  - rules/agent/preferences/always-search-twice-before-deciding
  - rules/agent/preferences/dont-recreate-what-exists-freely
---

# Hosting migration to GitHub Pages + analytics-everywhere

## Decision

**All static API sites move from Cloudflare Pages to GitHub Pages.** Cloudflare DNS is retained (no change). Each API repo gets a GitHub Pages site at `<subdomain>.oriz.in` via CNAME.

**Analytics + observability stack on every page** (shared via the `@oriz-org-fleet/api-fleet-template-astro-integration` package — long descriptive names per user preference 2026-06-28):

| Service | Purpose | Tier |
|---|---|---|
| Google Analytics 4 | Pageviews, events, sessions | Free |
| Microsoft Clarity | Heatmaps, session recordings | Free |
| PostHog | Product analytics, funnels | Free (1M events/mo) |
| Sentry | JS error tracking, perf | Free (5k errors/mo) |
| Cloudflare Web Analytics | Privacy-first, cookieless | Free unlimited |

All IDs/DSNs stored as **GitHub org-level secrets** on `oriz-org` (per existing `github-org-level-secrets` rule). Each repo's GitHub Actions reads them at build time and inlines `<script>` tags into the rendered HTML. No runtime fetching of analytics config.

## Why

1. **Cloudflare Pages free plan caps at 100 projects.** We have 6 deployed (rto/constants/ragas/dynasties/countries-plus + the killed api-fleet-landing) and growing. GitHub Pages has no per-account project cap — every public repo gets a Pages site for free.
2. **Cloudflare OAuth scopes via wrangler login** don't include `dns_records:write`. The DNS step kept needing either the workspace-level `CLOUDFLARE_API_TOKEN` env var (which appeared in tool output, prompting concern) or manual dashboard work. GitHub Pages + CNAME is fully scriptable via `gh` CLI which we already have authed.
3. **GitHub Pages is the natural home for OSS data APIs.** Each API repo is already on GitHub; the Pages site is a build-and-publish step away. No second platform to wire.
4. **Analytics everywhere** because the spirit of the family is "instrument everything we ship" (analytics stay inline per `atomic-packages-lazy`). All 5 services have generous free tiers and don't need a credit card.

## Naming convention (user preference 2026-06-28)

> "use ass long names ass possible for the everything you might rewrite the everything at this stage"

Long, descriptive names everywhere going forward. Examples:

- npm package: `@oriz-org-fleet/api-fleet-template-astro-integration` (was `@oriz/api-fleet-template`)
- npm package: `@oriz-org-fleet/analytics-injector-google-microsoft-posthog-sentry-cloudflare-multi-provider`
- repos can stay short (existing `rto-api` etc.) since the GitHub slug is the public surface
- workflow names: `mirror-to-all-managed-git-hosts-on-push-to-main.yml`
- secret names: `ORIZ_FLEET_GOOGLE_ANALYTICS_MEASUREMENT_ID`, `ORIZ_FLEET_MICROSOFT_CLARITY_PROJECT_ID`, etc.

## Implementation phases

### Phase 1 — Delete Cloudflare Pages projects + remove custom domains

For each of rto-api, constants-api, ragas-api, dynasties-api, countries-plus-api, api-fleet-landing:

1. `wrangler pages project delete <project-name>` (removes the Pages project)
2. CNAME records `<slug>.oriz.in` stay pointing at `<slug>-api.pages.dev` BRIEFLY (so URLs don't die during migration) — flip them to `oriz-org.github.io` once GH Pages is live for that repo.

### Phase 2 — Set up GitHub Pages for each repo

For each existing API repo:

1. Add `.github/workflows/deploy-to-github-pages.yml` that:
   - Runs on push to main
   - Reads org-level analytics secrets
   - `npm run build` (Astro static build)
   - Inlines analytics scripts into all HTML via build-time env vars
   - Uploads `dist/` as Pages artifact
   - Deploys via `actions/deploy-pages@v4`
2. Repo Settings -> Pages -> Source: GitHub Actions
3. Repo Settings -> Pages -> Custom domain: `<slug>.oriz.in` (writes a `CNAME` file)
4. Update DNS: change `<slug>.oriz.in` CNAME to `oriz-org.github.io` (or `chirag127.github.io` for personal repos)
5. Wait for cert provisioning (~10 min)
6. Verify subdomain works
7. Then run Phase 1 for that repo

### Phase 3 — npm package for analytics injection

`@oriz-org-fleet/analytics-injector-google-microsoft-posthog-sentry-cloudflare-multi-provider` — a small package that takes config + env vars and returns the `<script>` tags to inject. Consumed by `@oriz-org-fleet/api-fleet-template-astro-integration` so every site auto-gets all 5 providers.

### Phase 4 — Org-level secret seeding

GitHub org `oriz-org` -> Settings -> Secrets and variables -> Actions. Add:

- `ORIZ_FLEET_GOOGLE_ANALYTICS_MEASUREMENT_ID`
- `ORIZ_FLEET_MICROSOFT_CLARITY_PROJECT_ID`
- `ORIZ_FLEET_POSTHOG_PROJECT_API_KEY`
- `ORIZ_FLEET_POSTHOG_API_HOST` (e.g. https://us.i.posthog.com)
- `ORIZ_FLEET_SENTRY_DSN_BROWSER_SDK`
- `ORIZ_FLEET_CLOUDFLARE_WEB_ANALYTICS_TOKEN`

Repos opt in to using these via repo-level workflow inheritance.

### Phase 5 — Fleet landing (api.oriz.in)

Rebuild `oriz-org/api-fleet-landing` for GH Pages instead of CF Pages. Same Astro static site, different deploy target.

## What stays the same

- Cloudflare DNS for oriz.in
- jsDelivr URLs (those serve from GitHub raw, unaffected by hosting change)
- All 5 API repos' data files at repo root
- Submodule structure in umbrella
- `@oriz-org-fleet/api-fleet-template-astro-integration` package (just gets analytics-injector dep added)

## Cost

| Item | Cost |
|---|---|
| GitHub Pages | ?0 (10GB soft cap, 100GB/mo bandwidth, every public repo) |
| Cloudflare DNS | ?0 |
| jsDelivr CDN | ?0 |
| GA4 / Clarity / PostHog / Sentry / CF Web Analytics | All ?0 (free tiers, no card) |
| **Total ongoing** | **?0** |

## Risks

- **Brief downtime** during DNS cutover per subdomain (~5 min each). Acceptable since these are new APIs with no users yet.
- **Analytics signups required** for GA4, Clarity, PostHog, Sentry. Each takes ~5 min. User must do these manually (no card, no API).
- **GitHub Pages custom domain SSL** can take up to 30 min to provision per domain.

## Rule deletion

This supersedes the `hosting-split-cf-and-gh-2026-06-25` decision which had CF Pages as the primary host. That file is deleted in the same commit.
