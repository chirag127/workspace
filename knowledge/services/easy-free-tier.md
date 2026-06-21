---
type: services
title: "Easy free-tier services — only the ones that work for chirag127/oriz* without applications, without cards"
description: "Single SSoT catalog of services every chirag127/oriz* repo uses. Filters: free for public repos, no manual OSS application required, no card-on-file at signup, commercial use allowed (family monetises). Maximum 2-3 picks per concern. Tagged for quick lookup."
tags: [services, catalog, free-tier, easy, no-application, no-card, commercial-use-ok]
timestamp: 2026-06-21
format_version: okf-v0.1
status: active
related:
  - rules/no-card-on-file
  - rules/linux-ci-only
  - rules/cloudflare-pages-only
  - decisions/architecture/mit-license-all-repos
  - decisions/architecture/mirror-to-4-git-hosts
---

# Easy free-tier services — locked picks

## Filter

Every service in this catalog satisfies ALL of:

- Free tier for **public** GitHub repos
- **No manual OSS application** required (one-click install or signup)
- **No card-on-file** at signup
- **Commercial use OK** (family monetises via ads + affiliate + subscription)
- Max **2-3 picks per concern** to avoid duplicacy
- Multiple platforms per concern for failover

The family is **MIT-licensed across all 41 repos** as of 2026-06-21, which unlocks every "free for OSS" perk while keeping commercial use clear via the MIT license itself.

## Locked picks per concern

### Code quality + SAST

| Service | Tag | URL | Free? | Badge URL |
|---|---|---|---|---|
| **SonarCloud** | sast,lint | <https://sonarcloud.io> | ✅ public repos | `https://sonarcloud.io/api/project_badges/measure?project=chirag127_<repo>&metric=alert_status` |
| **DeepSource** | sast,lint | <https://deepsource.com> | ✅ public repos | `https://app.deepsource.com/gh/chirag127/<repo>.svg/?label=active+issues` |
| **CodeQL (GitHub native)** | sast | <https://github.com/features/security> | ✅ public repos | Security tab; no badge |
| **CodeRabbit** | ai-review | <https://coderabbit.ai> | ✅ public repos | PR comments only |

### Test coverage

| Service | Tag | URL | Free? | Badge URL |
|---|---|---|---|---|
| **Codecov** | coverage | <https://codecov.io> | ✅ public repos | `https://codecov.io/gh/chirag127/<repo>/branch/main/graph/badge.svg` |
| **Coveralls** | coverage | <https://coveralls.io> | ✅ public repos | `https://coveralls.io/repos/github/chirag127/<repo>/badge.svg?branch=main` |

### Security + dependency + secret scanning

| Service | Tag | URL | Free? | Setup |
|---|---|---|---|---|
| **Dependabot** | dep-scan,dep-update | github native | ✅ all repos | `.github/dependabot.yml` |
| **Renovate (Mend)** | dep-scan,dep-update | <https://github.com/apps/renovate> | ✅ all repos | `renovate.json` + GH App |
| **GitHub Secret Scanning + Push Protection** | secret-scan | github native | ✅ public repos | Auto-on |
| **Snyk** | dep-scan,sast,container | <https://snyk.io> | ✅ unlimited tests on public | GH App |
| **GitGuardian** | secret-scan | <https://gitguardian.com> | ✅ public repos | GH App |
| **OSSF Scorecard** | posture | <https://github.com/ossf/scorecard> | ✅ public repos | `.github/workflows/scorecard.yml` |
| **Trivy (Action)** | container,sbom,vuln | <https://github.com/aquasecurity/trivy-action> | ✅ free OSS | `aquasecurity/trivy-action@master` |
| **Gitleaks (Action)** | secret-scan | <https://github.com/gitleaks/gitleaks-action> | ✅ public repos free | `gitleaks/gitleaks-action@v2` |

### CI/CD platforms (Linux runners only per [[rules/linux-ci-only]])

| Platform | Tag | URL | Free (public, Linux)? | Migration plan |
|---|---|---|---|---|
| **GitHub Actions** | ci-primary | github native | ✅ unlimited public-repo minutes | Primary |
| **GitLab CI** | ci-fallback-1 | <https://gitlab.com> | ✅ 400 min/mo private + unlimited public | See [[runbooks/migrate-ci-platform]] |
| **CircleCI** | ci-fallback-2 | <https://circleci.com> | ✅ 6000 min/mo Linux | See [[runbooks/migrate-ci-platform]] |

### E2E + visual regression + accessibility

| Service | Tag | URL | Free? | Setup |
|---|---|---|---|---|
| **Playwright** | e2e | <https://playwright.dev> | ✅ Apache-2.0 lib | OSS framework |
| **Vitest** | unit | <https://vitest.dev> | ✅ MIT lib | OSS framework |
| **Chromatic** | visual-regression | <https://www.chromatic.com> | ✅ 5K snapshots/mo on public repos (commercial-use OK) | GH App + project token |
| **axe-core / Pa11y / Lighthouse CI** | a11y | <https://www.deque.com/axe>, <https://pa11y.org>, <https://github.com/GoogleChrome/lighthouse-ci> | ✅ OSS libs | Per-app workflow |
| **BrowserStack for OSS** | cross-browser | <https://www.browserstack.com/open-source> | ✅ unlimited after MIT switch + application | Apply once per project |

### Hosting (static + serverless + database + storage + CDN)

#### Static hosting — fallback chain

| Service | Tag | URL | Free? | Commercial OK? |
|---|---|---|---|---|
| **Cloudflare Pages** | static-primary | <https://pages.cloudflare.com> | ✅ unlimited bandwidth | ✅ |
| **GitHub Pages** | static-mirror | <https://pages.github.com> | ✅ 100 GB/mo | ✅ |
| **Firebase Hosting (Spark)** | static-fallback | <https://firebase.google.com/docs/hosting> | ✅ 10 GB/mo + 360 MB/day | ✅ |
| **Surge.sh** | static-fallback | <https://surge.sh> | ✅ unlimited | ✅ |
| **Deno Deploy** | static-fallback | <https://deno.com/deploy> | ✅ 1M req + 100 GiB | ✅ |
| **Netlify free** | static-fallback | <https://netlify.com> | ✅ 100 GB + 300 build-min | ✅ |
| ~~Vercel Hobby~~ | DROP | — | Free but commercial-use forbidden | ❌ |
| ~~Codeberg Pages~~ | DROP | — | Free but FOSS-only/non-commercial | ❌ |

#### Serverless

| Service | Tag | URL | Free? |
|---|---|---|---|
| **Cloudflare Workers** | serverless-primary | <https://workers.cloudflare.com> | ✅ 100K req/day |
| **Cloudflare Pages Functions** | serverless-shared | <https://pages.cloudflare.com> | ✅ shared with Workers |
| **Firebase Cloud Functions (Spark)** | serverless-fallback | <https://firebase.google.com/products/functions> | ✅ 125K invocations/mo |
| **Deno Deploy** | serverless-fallback | <https://deno.com/deploy> | ✅ included with static |

#### Database

| Service | Tag | URL | Free? |
|---|---|---|---|
| **Neon Postgres** | sql-primary | <https://neon.tech> | ✅ 0.5 GB + scale-to-zero |
| **Turso (libSQL)** | sql-edge | <https://turso.tech> | ✅ 5 GB + 500M reads |
| **Xata** | sql-fallback | <https://xata.io> | ✅ 15 GB + 750 req/sec |
| **MongoDB Atlas M0** | nosql-fallback | <https://www.mongodb.com/cloud/atlas> | ✅ 512 MB |
| **Firestore (Spark)** | nosql-primary | <https://firebase.google.com/docs/firestore> | ✅ 1 GB + 50K reads/day |
| **Upstash Redis** | kv-redis | <https://upstash.com> | ✅ 10K commands/day |
| **Cloudflare D1** | sql-edge-cf | <https://developers.cloudflare.com/d1> | ✅ 5 GB + 5M reads |
| **Cloudflare KV** | kv-cf | <https://developers.cloudflare.com/kv> | ✅ 1 GB + 100K reads/day |

#### Storage

| Service | Tag | URL | Free? |
|---|---|---|---|
| **Cloudflare R2** | object-primary | <https://developers.cloudflare.com/r2> | ✅ 10 GB + zero egress |
| **Backblaze B2** | object-fallback | <https://www.backblaze.com/b2> | ✅ 10 GB + 1 GB/day egress |
| **GitHub Releases + jsDelivr** | binary-versioned | github native | ✅ unlimited public + CDN auto |
| **Storj** | object-fallback | <https://storj.io> | ✅ 25 GB + 25 GB egress |

#### CDN

| Service | Tag | URL | Free? |
|---|---|---|---|
| **Cloudflare CDN** | cdn-primary | included with Pages | ✅ unlimited |
| **jsDelivr** | cdn-npm-gh | <https://www.jsdelivr.com> | ✅ unlimited public CDN |
| **wsrv.nl** | cdn-image | <https://wsrv.nl> | ✅ unlimited image proxy |
| **ImageKit** | cdn-image | <https://imagekit.io> | ✅ 20 GB |
| **Cloudinary** | cdn-image | <https://cloudinary.com> | ✅ 25 credits |
| **Bunny Fonts** | cdn-fonts | <https://fonts.bunny.net> | ✅ unlimited Google Fonts mirror |

### Monitoring + observability

| Service | Tag | URL | Free? | Notes |
|---|---|---|---|---|
| **Sentry for Open Source** | errors,perf,replays | <https://sentry.io/for/open-source> | ✅ 5M errors + 1B spans + 100K replays + Business features | Now eligible (MIT) |
| **Better Stack** | logs,uptime,status | <https://betterstack.com> | ✅ 3 GB logs + 10 monitors + 1 status page | No license check |
| **Axiom** | logs | <https://axiom.co> | ✅ 500 GB/mo ingest | No license check |
| **UptimeRobot** | uptime | <https://uptimerobot.com> | ✅ 50 monitors @ 5-min | No license check |
| **Healthchecks.io** | cron-heartbeat | <https://healthchecks.io> | ✅ 20 checks | Apply for OSS Business plan (now MIT-eligible) |
| **Cloudflare Workers Logs/Tail** | logs-workers | included with Workers | ✅ unlimited | Native |
| **Cloudflare Web Analytics** | rum | <https://cloudflare.com/web-analytics> | ✅ unlimited | Native |
| **Microsoft Clarity** | heatmaps,replays | <https://clarity.microsoft.com> | ✅ unlimited | No license check |
| **PostHog for Startups** | product-analytics | <https://posthog.com/startups> | ✅ 1M events/mo + Pro features | Eligible (MIT) |

### Funding (.github/FUNDING.yml)

| Service | Tag | Fee | Notes |
|---|---|---|---|
| **GitHub Sponsors** | sponsor-primary | 0% platform | Stripe processing only |
| **Open Collective** | sponsor-collective | 10% host (no personal bank) | Apply once for OSC fiscal host |
| **Liberapay** | sponsor-eu | 0% platform | Stripe or PayPal payout |
| **Ko-fi** | sponsor-tips | 0% on tips | Direct to PayPal/Stripe |
| **thanks.dev** | sponsor-aggregator | n/a | Aggregator over GH Sponsors + OC |
| **PayPal.me** | sponsor-direct | processing only | Listed under `custom:` |

### Community

| Service | Tag | URL | Free? |
|---|---|---|---|
| **GitHub Discussions** | forum-default | github native | ✅ unlimited |
| **Discord** | chat | <https://discord.com> | ✅ unlimited |
| **Telegram** | chat,notifications | <https://t.me> | ✅ unlimited |
| **Zulip Cloud Standard for OSS** | chat-power-user | <https://zulip.com/for/open-source> | ✅ free-forever after MIT switch |

### Translation / i18n (now eligible after MIT)

| Service | Tag | URL | Free? |
|---|---|---|---|
| **Crowdin for OSS** | i18n-primary | <https://crowdin.com> | ✅ unlimited strings/members after application (MIT eligible) |
| **Weblate Hosted Libre** | i18n-fallback | <https://weblate.org/en/hosting> | ✅ 160K strings (MIT eligible) |

### Docs hosting (single vendor — Cloudflare Pages)

| Service | Tag | URL | Free? |
|---|---|---|---|
| **Cloudflare Pages + Astro Starlight** | docs-primary | already in stack | ✅ unlimited |
| **Read the Docs Community** | docs-fallback | <https://readthedocs.com> | ✅ free for OSS (MIT eligible) |

### GitHub Apps to install (20+ at org level with "All repositories")

Click each, choose "chirag127", select "All repositories":

| # | App | URL |
|---|---|---|
| 1 | CodeRabbit | <https://github.com/apps/coderabbitai/installations/new> |
| 2 | Codacy | <https://github.com/apps/codacy-production/installations/new> |
| 3 | DeepSource | <https://github.com/apps/deepsource-io/installations/new> |
| 4 | SonarCloud | <https://github.com/apps/sonarcloud/installations/new> |
| 5 | Snyk | <https://github.com/apps/snyk/installations/new> |
| 6 | GitGuardian | <https://github.com/apps/gitguardian/installations/new> |
| 7 | Renovate (Mend) | <https://github.com/apps/renovate/installations/new> |
| 8 | Mergify | <https://github.com/apps/mergify/installations/new> |
| 9 | All Contributors | <https://github.com/apps/allcontributors/installations/new> |
| 10 | Stale | <https://github.com/apps/stale/installations/new> |
| 11 | Welcome | <https://github.com/apps/welcome/installations/new> |
| 12 | Imgbot | <https://github.com/apps/imgbot/installations/new> |
| 13 | Release Drafter | <https://github.com/apps/release-drafter/installations/new> |
| 14 | Lock Threads | <https://github.com/apps/lock/installations/new> |
| 15 | Aikido Security | <https://github.com/apps/aikido-security/installations/new> |
| 16 | Reviewable | <https://github.com/apps/reviewable/installations/new> |
| 17 | Argos CI | <https://github.com/apps/argos-ci/installations/new> |
| 18 | Chromatic | <https://github.com/apps/chromaticio/installations/new> |
| 19 | Mintlify | <https://github.com/apps/mintlify/installations/new> |
| 20 | Greptile | <https://github.com/apps/greptile-bot/installations/new> |

Run via `c:/D/oriz/scripts/install-easy-github-apps.sh` (opens each in browser sequentially).

## Telegram notifications

Single Telegram channel for all 41 repos.

- Env vars at org level: `TELEGRAM_BOT_TOKEN` + `TELEGRAM_CHAT_ID`
- Workflow action: `appleboy/telegram-action@master`
- Posts on: release create, CI failure, security alert, mirror push complete, weekly digest from master cron

## Git host mirrors (insurance against GitHub shutdown)

Master umbrella runs a weekly cron (Friday 4am Asia/Kolkata) that pushes every submodule's HEAD to:

1. **GitLab.com** — `gitlab.com/chirag127/<repo>`
2. **Codeberg.org** — `codeberg.org/chirag127/<repo>`
3. **Bitbucket** — `bitbucket.org/chirag127/<repo>`
4. **GitFlic.ru** — `gitflic.ru/project/chirag127/<repo>`

Env vars: `GITLAB_TOKEN`, `CODEBERG_TOKEN`, `BITBUCKET_APP_PASSWORD`, `GITFLIC_TOKEN` (org-level GH secrets).

If a single mirror push fails, others still succeed. If GitHub itself disappears: see [[runbooks/migrate-from-github]] (TODO when needed).

## Strict drop list (services we DO NOT use)

| Service | Reason |
|---|---|
| Vercel Hobby | Free but commercial-use forbidden |
| Codeberg Pages | Free but FOSS-only / non-commercial |
| Tabnine | No free tier since 2025 |
| Sourcegraph Cody (Free/Pro) | Closed to new signups 2026-06-25 |
| Sweep AI | Discontinued 2024 |
| Bountysource | Bankrupt Nov 2023 |
| Pingdom | Free tier dead |
| Freshping | Shut 2026-03-06 |
| Baselime | Sunset post-CF acquisition |
| Cirrus CI unlimited OSS | Capped at ~16K CPU-min/mo since Sept 2023 |
| Drone Cloud | Shut down 2021 |
| PlanetScale Hobby | Killed Apr 2024 |
| FaunaDB | Shut May 2025 |
| Fly.io free | Removed 2024 |
| Glitch free | Ended Jul 2025 |
| Heroku free | Gone since 2022 |
| Tidelift | Invite-only |
| Patreon | 10% fee + processing |
| Polar.sh | 5% + 50¢ |
| Buy Me a Coffee | 5% on everything |
| AWS / GCP / Azure free tiers | Card required at signup |
| Oracle Cloud | Card required at signup |

## Cross-refs

- The MIT license decision → [[decisions/architecture/mit-license-all-repos]]
- The Linux-CI-only rule → [[rules/linux-ci-only]]
- The mirror cron → [[decisions/architecture/mirror-to-4-git-hosts]] + [[runbooks/master-mirror-cron]]
- The migration plan if GitHub Actions becomes unusable → [[runbooks/migrate-ci-platform]]
- GitHub Apps install runbook → [[runbooks/install-easy-github-apps]]
- The 169 existing per-vendor service files → [[services/index]]
