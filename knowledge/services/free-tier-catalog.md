---
type: services
title: "Free-tier catalog — services that work for chirag127/oriz* (source-available, ad-supported, no card)"
description: "Single-page catalog of free services that fit the family's actual constraints: source-available all-rights-reserved LICENSE (NOT OSI), ad-supported revenue, no card-on-file, public GitHub repos. STRICT-OSS programs (Sentry for OSS, BrowserStack for OSS, FOSSA for OSS, Crowdin for OSS) are NOT eligible because they require OSI-approved license. This catalog lists what's actually usable."
tags: [services, catalog, free-tier, no-card, source-available]
timestamp: 2026-06-21
format_version: okf-v0.1
status: active
related:
  - rules/no-card-on-file
  - rules/no-subscriptions
  - rules/cloudflare-pages-only
  - architecture/the-six-packages
---

# Free-tier catalog — services that fit chirag127/oriz*

## Eligibility filter

The family's LICENSE is **source-available all-rights-reserved** (not OSI). The family monetises via **ads + affiliate + one-subscription** (not "pure non-commercial OSS"). This rules out programs that gate on "OSI-approved license" or "non-commercial OSS only." This catalog only lists services that work under those constraints.

Three columns matter:

- **Free for the family?** — Yes if the standard free tier covers our usage AND there's no card-on-file requirement at signup AND the terms don't forbid ad/affiliate monetisation.
- **License check?** — No if the service grants free tier to any public GitHub repo regardless of license. Yes if it requires OSI / non-commercial — then we're INELIGIBLE.
- **Card required?** — No if we can sign up + use the free tier without entering a card. Yes if we can't.

## Stack — the locked picks

Every `chirag127/oriz*` repo gets these. All zero-card, no license-check, no application:

| Concern | Pick | Tier | Why |
|---|---|---|---|
| Hosting (sites + apps) | **Cloudflare Pages** | Free unlimited bandwidth, 500 builds/mo | Already family lock |
| Hosting (mirror) | **GitHub Pages** | 100 GB/mo, public repos | Survival fallback |
| Compute (server) | **Cloudflare Workers** | 100K req/day | Already locked |
| Object storage | **Cloudflare R2** | 10 GB free + zero egress | Already locked |
| CDN for npm packages | **jsDelivr + GitHub Releases** | Unlimited | Best free auto-CDN |
| Database (relational) | **Neon Postgres** | 0.5 GB + scale-to-zero | Already locked |
| Database (edge SQLite) | **Turso (libSQL)** | 5 GB, 500M reads | Already locked |
| Database (canonical events) | **Firestore (Spark)** | 1 GB + 50K reads/day | Already locked |
| Auth | **Firebase Spark** | Already locked | |
| Errors | **Sentry Developer (standard free)** | 5K errors/mo per project | Standard free works — DON'T apply for OSS program (license check) |
| Logs (Workers) | **Cloudflare Workers Tail/Logs** | Included with Workers free | Native |
| Logs (other) | **Axiom** | 500 GB/mo ingest | Biggest unconditional free |
| Uptime | **UptimeRobot** | 50 monitors @ 5-min | No license check |
| Status page | **Better Stack** | 1 page + 10 monitors | No license check |
| Cron heartbeats | **Healthchecks.io** | 20 checks | Standard free — DON'T apply for OSS plan (license check) |
| Web Analytics (RUM) | **Cloudflare Web Analytics** | Free unlimited, cookieless | Already locked |
| Heatmaps + replays | **Microsoft Clarity** | Free unlimited | No license check |
| Product analytics | **PostHog** | 1M events/mo | Standard free works |
| Code coverage | **Codecov** | "Always free for OSS public repos" — no license check beyond "public" | Works |
| SAST | **GitHub CodeQL** | Free for public repos | No license check |
| Lint/quality | **SonarCloud** | Free for public repos | No license check |
| Lint/quality (alt) | **CodeRabbit Free** | Free Hobby for public repos | No license check |
| Dep updates | **Dependabot** | Free all repos | Native |
| Dep updates (alt) | **Renovate (Mend)** | All hosted plans free since May 2026 | No license check |
| Secret scanning | **GitHub Secret Scanning + Push Protection** | Free for public repos | Native |
| Secret scanning (alt) | **Gitleaks** + **TruffleHog** | Free CLIs | OSS tooling |
| SBOM | **GitHub Dependency Graph SBOM** | Free for public repos | Native |
| SBOM (CLI alt) | **Syft + Grype + Trivy** | Free Apache-2.0 CLIs | OSS tooling |
| Provenance | **npm provenance + GitHub Artifact Attestations** | Free for public packages | SLSA L3 |
| Visual regression | **Chromatic** | 5K snapshots/mo on public repos | License-permissive |
| Visual regression (alt) | **Argos CI** | Hobby tier for public repos | License-permissive |
| Test runner | **Vitest** | OSS lib | n/a |
| E2E | **Playwright** | OSS lib | n/a |
| API mocking | **MSW** + **Mockoon** | OSS lib + free desktop | n/a |
| A11y | **axe-core + Pa11y + Lighthouse CI** | OSS libs | n/a |
| DAST | **OWASP ZAP** | OSS Apache-2.0 | n/a |
| Header audit | **Mozilla HTTP Observatory + securityheaders.com** | Free public scans | n/a |
| TLS audit | **SSL Labs (Qualys)** | Free public scan | n/a |
| Docs hosting | **Cloudflare Pages** | Already chosen | One stack |
| Docs framework | **Astro Starlight** | OSS | n/a |
| Comments | **Giscus** | OSS via GitHub Discussions | Already locked |
| Forum | **GitHub Discussions** | Native, free | Default community |
| Cron jobs | **Cloudflare Cron Triggers + GitHub Actions schedule** | Free | Already locked |
| Queue | **Cloudflare Queues + Hookdeck** | Free tiers | Already locked |
| Email transactional | **Resend** | Free tier | Already locked |
| Email newsletter | **Buttondown + EmailOctopus** | Free tier | Already locked |
| Push notifications | **FCM + Knock** | Free tier | Already locked |
| Forms | **Web3Forms + Static Forms** | Free tier | Already locked |
| Captcha | **Cloudflare Turnstile + hCaptcha** | Free tier | Already locked |
| Image CDN | **wsrv.nl + ImageKit + Cloudinary** | Free tiers | Already locked |
| Search (local) | **Pagefind** | OSS, free | Already locked |
| Search (cloud) | **Orama Cloud** | Free tier (no license check) | Already locked |
| OG cards | **Satori + ray.so** | OSS + free public | Already locked |
| Sponsorships | **GitHub Sponsors + Open Collective + Liberapay + Ko-fi + thanks.dev** | 0% platform combos | See `FUNDING.yml` below |
| Repo insights | **Repobeats + OSS Insight + Star History + contrib.rocks** | Free public widgets | No license check |
| Subdomain helpers | **js.org, is-a.dev, open-domains.net, eu.org** | Free subdomain registries | n/a |
| Local-dev tunnel | **Cloudflare Tunnel** | Already locked | n/a |
| Code signing (Windows EXE) | **SignPath Foundation** | Requires per-project application — **likely INELIGIBLE on license** | Note: SmartScreen reputation builds over time without signing |
| Translation | **Translation.io for OSS** (only one accepting non-OSI) | "Source-available with README mention" might qualify — apply if i18n needed | |

## Programs we are INELIGIBLE for (do not waste effort applying)

These require OSI-approved license. The family's source-available all-rights-reserved LICENSE fails the gate. Skip them entirely unless we switch a repo to MIT/Apache:

- **Sentry for Open Source** (would give 5M errors but rejects on license)
- **Datadog for Open Source** (rejects on license)
- **BrowserStack for OSS / Sauce Labs Open Sauce / LambdaTest for OSS** (all OSI-required)
- **FOSSA for OSS** (OSI-required)
- **Crowdin for OSS / Weblate Hosted Libre** (libre license required)
- **Mintlify OSS Program** ($300/mo Pro free — requires non-commercial OSS)
- **GitBook OSS / Algolia for OSS / Zulip Cloud for OSS** (OSI-required)
- **Atlassian Open Source / JetBrains for OSS / 1Password Teams for OSS** (OSI-required)
- **Docker-Sponsored Open Source (DSOS)** (OSS-only)
- **Greptile for OSS** (MIT/Apache only)
- **Polar.sh OSS-friendly checkout** (OSS-only)
- **Codeberg Pages** (FOSS-only mission)

**Workaround if these are wanted:** switch the specific repo's LICENSE to MIT or Apache-2.0. Per [[free-for-developer-not-for-services]] the family's "no license granted" stance is the current lock — overriding it is a separate decision per repo.

## Standard FUNDING.yml

`.github/FUNDING.yml` for every repo:

```yaml
github: chirag127            # 0% platform, Stripe processing
ko_fi: chirag127             # 0% on tips
liberapay: chirag127         # 0% platform, EU non-profit
thanks_dev: gh/chirag127     # aggregator
custom:
  - https://paypal.me/chirag127
```

DO NOT include: Bountysource (dead Nov 2023), Tidelift (invite-only), Patreon (10% fee), Polar (OSS-only check), Buy Me a Coffee (5%), Open Collective (needs OSC-fiscal-host application).

## Standard repo files (every repo)

- `LICENSE` — source-available all-rights-reserved (family lock)
- `README.md` — minimal per-app shape ([[runbooks/scaffold-a-new-site]])
- `SECURITY.md` — chirag@oriz.in disclosure
- `CODE_OF_CONDUCT.md` — Contributor Covenant 2.1
- `CONTRIBUTING.md` — "no external contributions"
- `.github/FUNDING.yml` — above
- `.github/CODEOWNERS` — `* @chirag127`
- `.github/dependabot.yml` — npm + github-actions weekly
- `.github/workflows/ci.yml` — typecheck + test (already shipped)
- `.github/workflows/release.yml` — tag-driven npm publish (already shipped)

## Standard README badge block

```markdown
[![npm](https://img.shields.io/npm/v/<pkg>)](https://www.npmjs.com/package/<pkg>)
[![downloads](https://img.shields.io/npm/dm/<pkg>)](https://www.npmjs.com/package/<pkg>)
[![bundle](https://img.shields.io/bundlephobia/minzip/<pkg>)](https://bundlephobia.com/package/<pkg>)
[![CI](https://github.com/chirag127/<repo>/actions/workflows/ci.yml/badge.svg)](https://github.com/chirag127/<repo>/actions/workflows/ci.yml)
[![Codecov](https://codecov.io/gh/chirag127/<repo>/branch/main/graph/badge.svg)](https://codecov.io/gh/chirag127/<repo>)
[![SonarCloud](https://sonarcloud.io/api/project_badges/measure?project=chirag127_<repo>&metric=alert_status)](https://sonarcloud.io/dashboard?id=chirag127_<repo>)
[![License: source-available](https://img.shields.io/badge/license-source--available-red.svg)](./LICENSE)
[![Sponsors](https://img.shields.io/github/sponsors/chirag127)](https://github.com/sponsors/chirag127)
```

## Dead / discontinued — never propose

- LGTM.com (shut Dec 2022) → CodeQL
- BetterCodeHub (sunset by SonarSource) → SonarCloud
- Codeball AI (shut 2023) → CodeRabbit
- Sweep AI (discontinued 2024) → PR-Agent / Cursor
- Drone Cloud (shut 2021) → GitHub Actions
- PlanetScale Hobby (killed Apr 2024) → Neon / Turso
- FaunaDB (shut May 2025) → Neon / Turso
- Cyclic.sh (shut 2024) → Cloudflare Workers
- Deta Space (shut Oct 2024) → Cloudflare Workers
- Glitch free (ended Jul 2025) → Cloudflare Pages
- Fly.io free (removed 2024) → Cloudflare Workers
- Bountysource (bankrupt Nov 2023, offline May 2024) → remove from any FUNDING.yml
- Sourcegraph Cody Free/Pro (closed to new signups 2026-06-25) → Codeium
- Tabnine free (discontinued 2025) → Codeium
- Pingdom free (dead) → UptimeRobot
- Freshping (shut 2026-03-06) → UptimeRobot
- Baselime (sunset post-CF acquisition) → CF Workers Logs
- Logz.io Community (deprecated) → Axiom
- Highlight.io hosted (migrating to LaunchDarkly) → Sentry / GlitchTip self-host
- Pirsch (card-gated trial) → Microsoft Clarity / CF Web Analytics

## Cross-refs

- The hosting lock → [[rules/cloudflare-pages-only]] + [[decisions/infrastructure/cloudflare-pages-for-all-sites]]
- The license posture → [[free-for-developer-not-for-services]] (memory)
- The 15 packages → [[architecture/the-six-packages]]
- The 24 apps → [[architecture/repo-layout]]
- Existing per-vendor service files → [[services/index]]
- GitHub Apps bulk install → [[runbooks/install-github-apps]]
