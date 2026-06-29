---
type: index
title: "Oriz Knowledge Index"
description: "The canonical brain for the oriz family. Single navigable index of every current knowledge file, organized by area."
tags: [okf, index, family]
timestamp: 2026-06-25
format_version: okf-v0.1
status: active
---

# Oriz Knowledge Index

> The canonical brain for the oriz family. Open Knowledge Format (OKF) v0.1.
> Last cleaned: 2026-06-25. Superseded files were hard-deleted; see git history for archaeology.

## How to navigate
- **Agent-rules** - agent behaviour rules (70). Read first.
- **Rules** - non-negotiable design/development/infra/interaction/security rules (68).
- **Decisions** - architecture + product decisions, flattened by category (216).
- **Branding / Design / Infrastructure / Monetisation / Policy / Security** - promoted L1 decision areas.
- **Core-concepts** - foundational concepts (2).
- **Runbooks** - step-by-step procedures, split by platform + workflow (65).
- **Services** - grouped by area (infra/data/code/business/monitoring/media) (218).
- **Glossary** - term definitions (33).

## Agent-rules (70 total)

### Agent behaviour (13)

| File | Description |
|---|---|
| [`agent-minimum-context`](./rules/agent/agent-minimum-context.md) | How any AI agent operates on this repo with minimum upfront token cost. |
| [`agents-md-2025-discipline`](./rules/agent/agents-md-2025-discipline.md) | User locked the 2025 mindset on 2026-06-23: AGENTS.md stays short +\ |
| [`auto-grill-on-architectural-decisions`](./rules/agent/auto-grill-on-architectural-decisions.md) | Before any multi-file architectural choice (storage, auth, deploy, payments,\ |
| [`cc-settings-balance`](./rules/agent/preferences/cc-settings-balance.md) | All 12 Claude Code settings.json picks from 2026-06-29 grill: Opus default + always-thinking floor + adaptive on + 85% compact + agent teams on. Max-quality posture since Bedrock-through-Hr is corp-paid. |
| [`confirm-knowledge-deltas`](./rules/agent/confirm-knowledge-deltas.md) | Whenever the user's latest message contradicts, narrows, widens, or reverses |
| [`grill-on-loc-removal`](./rules/agent/grill-on-loc-removal.md) | TIGHTENED 2026-06-22 evening: threshold dropped from 1000 LOC \u2192\ |
| [`grill-to-knowledge`](./rules/agent/grill-to-knowledge.md) | When the user invokes grill-me or runs a sequence of design questions, |
| [`keep-knowledge-fresh`](./rules/agent/keep-knowledge-fresh.md) | Every session reads knowledge before acting, writes decisions into knowledge |
| [`knowledge-deletion-not-supersession`](./rules/agent/knowledge-deletion-not-supersession.md) | When a decision is superseded, git rm the old file in the same commit that adds the new one. Audit trail lives in git history. |
| [`keep-knowledge-fresh`](./rules/agent/keep-knowledge-fresh.md) | Every session reads knowledge before acting, writes decisions as CURRENT TRUTH, |
| [`read-before-edit`](./rules/agent/read-before-edit.md) | Always Read a file in the current session before calling Edit. The harness\ |
| [`okf-lookup-before-acting`](./rules/agent/okf-lookup-before-acting.md) | Every agent runs scripts/okf-prompt-lookup.py (CC via hook; others manually) to surface top-3 OKF files before answering. |
| [`self-update-rule`](./rules/agent/self-update-rule.md) | Every durable architectural / naming / stack / external-fact decision\ |

### Design (5)

| File | Description |
|---|---|
| [`design-divergence-vs-dedup`](./rules/design/design-divergence-vs-dedup.md) | Per-app design-brief variants (Header, Wordmark, blog's MultiSearch,\ |
| [`frontend-design-skill-baked-in`](./rules/design/frontend-design-skill-baked-in.md) | Permanently baked into knowledge per user mandate 2026-06-22 evening.\ |
| [`no-ad-slots-in-markup`](./rules/design/no-ad-slots-in-markup.md) | Don't reserve empty `<div class=\"ad-slot\">` boxes in HTML. AdSense,\ |
| [`no-emoji-in-chrome`](./rules/design/no-emoji-in-chrome.md) | Never use emoji in nav, headers, footers, wordmarks, or page <title>. |
| [`per-app-distinctive-frontend-design`](./rules/design/per-app-distinctive-frontend-design.md) | Reversal of the ''family-wide chrome'' decision (sweeps #3-#5). Each |

### Development (19)

| File | Description |
|---|---|
| [`always-latest-deps`](./rules/development/always-latest-deps.md) | When adding or refreshing a dependency in any oriz repo, install the\ |
| [`astro-version-pin`](./rules/development/astro-version-pin.md) | Every package.json across the family pins Astro at the current major |
| [`community-packages-first`](./rules/development/community-packages-first.md) | Locked 2026-06-23. Default to a well-maintained community library/package |
| [`conventional-commits`](./rules/development/conventional-commits.md) | Every commit message uses a Conventional Commits prefix: feat, fix, |
| [`fork-discipline`](./rules/development/fork-discipline.md) | All forks live under oriz-org/<upstream-name> on GitHub and repos/oriz/frk/<bucket>/<category>/<upstream-name>/\ |
| [`git-identity-chirag127-noreply`](./rules/development/git-identity-chirag127-noreply.md) | Every commit on this machine attributes to chirag127 via the noreply |
| [`no-force-push-to-main`](./rules/development/no-force-push-to-main.md) | Force-push to main requires a separate, explicit user instruction \u2014\ |
| [`no-rebuilding-free-software`](./rules/development/no-rebuilding-free-software.md) | Family-wide constraint: do NOT build a userscript / extension / tool that replicates existing free software. Only exception: the existing free version paywalls a feature we want behind a payment. Save the build budget for things that don... |
| [`no-web3forms-server-side`](./rules/development/no-web3forms-server-side.md) | Web3Forms server-side calls require their paid plan plus an IP allow-list. |
| [`one-branch-only`](./rules/development/one-branch-only.md) | Only the main branch exists, in the master oriz repo and in every submodule |
| [`playwright-persistent-sessions`](./rules/development/playwright-persistent-sessions.md) | Constraints and instructions for running browser automation with persistent authentication, handling cookie encryption, and preventing memory leaks in long loops. |
| [`push-by-default`](./rules/development/push-by-default.md) | Standing authorisation: agents commit AND push to main immediately after |
| [`readme-star-badge-required`](./rules/development/readme-star-badge-required.md) | Family-wide convention: each repo's README places a `<!-- TODO: broken link, was [⭐ Star this Repo ⭐](<repo-url>) -->` link/badge near the top of the file, above the BLUF/overview section. Promotes discoverability across the 80+ repo fam... |
| [`repo-naming`](./rules/development/repo-naming.md) | Every chirag127/oriz* repo slug must end in -site, -ext, -vsc-ext, -cli,\ |
| [`repos-work-independently`](./rules/development/repos-work-independently.md) | Cloning any single oriz submodule directly must give a fully working |
| [`tests-parallel-and-master-install`](./rules/development/tests-parallel-and-master-install.md) | Vitest + Playwright + Storybook per app and per package; master CI matrix-fans |
| [`use-pnpm`](./rules/development/use-pnpm.md) | pnpm is mandatory across the oriz family. Its content-addressable global |
| [`userscript-author-handle`](./rules/development/userscript-author-handle.md) | All userscripts in the family use `// @author chirag127` (the GitHub handle), not `Chirag Singhal` or any other variant. Keeps attribution consistent with the noreply git identity and the @namespace URL. |

### Infrastructure (10)

| File | Description |
|---|---|
| [`aws-lambda-exception`](./rules/infrastructure/aws-lambda-exception.md) | User-approved exception. AWS Lambda is the 3rd-rail fallback in the\ |
| [`hosting-split-cf-and-github-pages`](./rules/infrastructure/hosting-split-cf-and-github-pages.md) | Locked 2026-06-23. CF Pages hosts the 25 apps under repos/oriz/own/prod/apps/\ |
| [`cloudflare-pages-only`](./rules/infrastructure/cloudflare-pages-only.md) | Family hosting lock. See the decision file for full rationale. |
| [`free-tier-with-cost-controls`](./rules/infrastructure/free-tier-with-cost-controls.md) | REVERSED 2026-06-23. Card-on-file is permitted, but ONLY with providers\ |
| [`no-firebase-admin-in-workers`](./rules/infrastructure/no-firebase-admin-in-workers.md) | Cloudflare's workerd runtime does not fully support gRPC, which firebase-admin |
| [`no-firebase-functions-blaze`](./rules/infrastructure/no-firebase-functions-blaze.md) | Firebase Cloud Functions only run on the Blaze pay-as-you-go plan, which |
| [`no-paid-self-hosting-only`](./rules/infrastructure/no-paid-self-hosting-only.md) | Reversal 2026-06-22: self-hosting is FINE as long as the provider is |
| [`no-subscriptions`](./rules/infrastructure/no-subscriptions.md) | Family monetisation constraint. See the decision file for full rationale. |
| [`one-level-subdomain-only`](./rules/infrastructure/one-level-subdomain-only.md) | Locked 2026-06-22 evening. Family subdomains live AT MOST one level\ |
| [`shared-tenant-by-default`](./rules/infrastructure/shared-tenant-by-default.md) | Locked 2026-06-22 evening. For every 3rd-party SaaS (Sentry / GA4 /\ |

### User interaction (21)

| File | Description |
|---|---|
| [`auto-only-tracking`](./rules/interaction/auto-only-tracking.md) | Every tracked metric in the chirag127/oriz family must be automatically |
| [`communication-stt-friendly`](./rules/interaction/communication-stt-friendly.md) | The user uses speech-to-text software heavily. STT introduces transcription\ |
| [`future-overrides-past`](./rules/interaction/future-overrides-past.md) | When chat contradicts a knowledge file or AGENTS.md, the chat wins; the |
| [`linux-ci-only`](./rules/interaction/linux-ci-only.md) | Every CI workflow in every chirag127/oriz* repo runs on Linux/Ubuntu\ |
| [`match-surrounding-style`](./rules/interaction/match-surrounding-style.md) | When editing existing files, match the file's existing comment density, |
| [`never-delete-empty-placeholder-repos`](./rules/interaction/never-delete-empty-placeholder-repos.md) | An empty repo in the chirag127/oriz* family is a deliberate slug reservation, |
| [`never-hit-quotas`](./rules/interaction/never-hit-quotas.md) | Architect for headroom. Surprise quota walls are a design failure, not |
| [`openai-compat-for-all-ai-providers`](./rules/interaction/openai-compat-for-all-ai-providers.md) | Every adapter in @chirag127/oriz-ai-providers must use the OpenAI SDK |
| [`parallel-fan-out-by-default`](./rules/interaction/parallel-fan-out-by-default.md) | Any parallelisable work MUST be fanned out via background subagents. Sequential is the exception. |
| [`parallel-fan-out-by-default`](./rules/interaction/parallel-fan-out-by-default.md) | Any work that can be parallelised MUST be fanned out via background\ |
| [`parse-mcq-other-for-context`](./rules/interaction/parse-mcq-other-for-context.md) | When the user selects 'Other' on an AskUserQuestion MCQ and adds free-text,\ |
| [`profile-readme-cross-link`](./rules/interaction/profile-readme-cross-link.md) | The chirag127 GitHub profile README must include a one-line cross-link\ |
| [`recruiter-strategy`](./rules/interaction/recruiter-strategy.md) | GitHub recruiters skim a profile in 30\u201360 seconds: pinned repos\ |
| [`telegram-channels-and-roles`](./rules/interaction/telegram-channels-and-roles.md) | Telegram restored in India 2026-06-22. Four channels in the Oriz namespace: |
| [`user-prefers-atomic-split`](./rules/interaction/user-prefers-atomic-split.md) | When given a choice between fewer-bigger-units and more-smaller-units, |
| [`user-prefers-deletion-over-archive`](./rules/interaction/user-prefers-deletion-over-archive.md) | When a repo is superseded by another within the same day or migration |
| [`user-prefers-pure-tool-brand`](./rules/interaction/user-prefers-pure-tool-brand.md) | When tools live at dedicated subdomains, the user picks pure per-tool |
| [`user-prefers-same-name-repo-and-npm`](./rules/interaction/user-prefers-same-name-repo-and-npm.md) | When a project ships as a GitHub repo + npm package, the slugs match |
| [`user-prefers-strict-no-toggle`](./rules/interaction/user-prefers-strict-no-toggle.md) | When a family-wide rule (dark mode, no auth, no card) is offered as 'strict |
| [`user-prefers-wider-coverage`](./rules/interaction/user-prefers-wider-coverage.md) | When a content-site scope question offers narrow-but-deep vs wide-but-shallow, |

### Security (5)

| File | Description |
|---|---|
| [`env-example-synced-from-master`](./rules/security/env-example-synced-from-master.md) | The canonical .env.example lives at templates/.env.example in the master\ |
| [`github-org-level-secrets`](./rules/security/github-org-level-secrets.md) | Every GitHub Actions secret used by any chirag127/oriz* repo is set\ |
| [`no-hardcoded-secrets`](./rules/security/no-hardcoded-secrets.md) | Secrets never live in source. All secrets come from chirag127/envpact-secrets, |
| [`org-level-secrets-only-no-per-repo`](./rules/security/org-level-secrets-only-no-per-repo.md) | User mandate 2026-06-22 evening: ''Don''t hit the GitHub API so many |
| [`submodule-env-files-three-file-pattern`](./rules/security/submodule-env-files-three-file-pattern.md) | Any submodule that consumes env vars MAY have all 3 env files in its\ |

## Decisions (216 total)

### Security (7)

| File | Status | Description |
|---|---|---|
| [`cross-site-auth-via-auth-oriz-in`](./security/cross-site-auth-via-auth-oriz-in.md) | active | Firebase Auth's custom domain auth.oriz.in is shared by every *.oriz.in |
| [`data-hub-and-central-auth`](./security/data-hub-and-central-auth.md) | active | Locked 2026-06-22 evening. (1) New CF Pages app `oriz-data-aggregator-app`\ |
| [`layer-3-auth-firebase-spark`](./security/layer-3-auth-firebase-spark.md) | active | One Firebase project (oriz-app) on the Spark plan, never Blaze. Custom |
| [`no-auth-in-apps-or-apis-2026-06-25`](./security/no-auth-in-apps-or-apis-2026-06-25.md) | active | Apps and APIs are 100% public. Login moves to a dedicated login-manager project; apps/APIs that need authenticated users redirect to it, never embed. |
| [`package-isolation-rule`](./security/package-isolation-rule.md) | active | Every external service must be wrapped in a typed @chirag127 package |
| [`payment-architecture-direct-links`](./security/payment-architecture-direct-links.md) | active | Definition: 'direct platform link' = a button on our site that redirects\ |
| [`razorpay-donation-button`](./security/razorpay-donation-button.md) | active | Razorpay-hosted donation button (button ID pl_T4iEPIDcALKLPk) mounted |

### Packaging (1)

| File | Status | Description |
|---|---|---|
| [`atomic-packages-lazy`](./rules/agent/preferences/atomic-packages-lazy.md) | active | Community-first; extract atomic `@oriz/*` packages only when ≥2 apps need the same logic. Analytics stays inline in `BaseLayout.astro`. Supersedes the prior "zero in-house packages" blanket rule. |

### Packages (9)

| File | Status | Description |
|---|---|---|
| [`legal-pages-package-in-domain`](./decisions/packages/legal-pages-package-in-domain.md) | active | 8+ legal pages (/privacy /terms /contact /about /refunds /disclaimer |
| [`omni-publish-package`](./decisions/packages/omni-publish-package.md) | active | New npm package @chirag127/omni-publish handles auto-publishing release\ |
| [`omni-publish-v0-1-2-followups`](./decisions/packages/omni-publish-v0-1-2-followups.md) | active | Five follow-ups deferred from @chirag127/omni-publish v0.1.1 \u2192\ |
| [`oriz-ai-providers-package`](./decisions/packages/oriz-ai-providers-package.md) | active | New family package `@chirag127/oriz-ai-providers` aggregates EVERY free\ |
| [`packages-catalog-shape`](./decisions/packages/packages-catalog-shape.md) | active | packages.oriz.in is the auto-discovery Starlight catalog. A GitHub Action |
| [`packages-oriz-in-catalog`](./decisions/packages/packages-oriz-in-catalog.md) | active | Packages are surfaced in TWO places: (1) oriz.in renders an /apps + |
| [`single-pricing-page-package`](./decisions/packages/single-pricing-page-package.md) | active | One pricing page shared across all oriz apps, served from a package\ |
| [`the-23-packages`](./decisions/packages/the-23-packages.md) | active | The chirag127/oriz family ships 23 npm packages — 10 Astro (shell, chrome, tools, content, data, forms, billing, pwa, distribute, widgets) + 1 shared test fixtures (astro-test-utils) + 4 cross-surface auth (auth-core, auth-wxt, auth-vsc,... |
| [`the-six-packages`](./decisions/packages/the-six-packages.md) | redirect | Legacy filename. The canonical package set now lives in the-23-packages.md |

### Infrastructure (3)

| File | Status | Description |
|---|---|---|
| [`hosting-split-cf-and-gh-2026-06-25`](./infrastructure/hosting-split-cf-and-gh-2026-06-25.md) | active | Locked 2026-06-25. Apps, PWAs, and end-user websites deploy to Cloudflare Pages on custom subdomains. Software-package landing pages (npm, CLI, extension, MCP-server homes) deploy to GitHub Pages. Both targets are compatible with the don... |
| [`umbrella-as-clone-entrypoint-2026-06-25`](./infrastructure/umbrella-as-clone-entrypoint-2026-06-25.md) | active | Locked 2026-06-25. The oriz-org/oriz umbrella holds knowledge/, apps.ts registry, and every fleet repo as a git submodule. A single git clone --recurse-submodules pulls the entire fleet. No separate workspace repo, no manifest, no subtree. |
| [`workspace-flat-repos-2026-06-25`](./infrastructure/workspace-flat-repos-2026-06-25.md) | active | Locked 2026-06-25. Workspace umbrella holds every submodule under a single flat repos/<slug>/ directory. Type information is encoded in the slug suffix (-api, -npm-pkg, -bs-ext, -ide-ext, -cli, -mcp-server, -app). Forks marked by a singl... |

### Fleet (1)

| File | Status | Description |
|---|---|---|
| [`scope-cut-2026-06-25`](./decisions/fleet/scope-cut-2026-06-25.md) | active | Build-gate applied at repo level. 33 in-progress / scaffold / hub repos archived to oriz-archive. ~20 production-content repos survive. |

### Ops (17)

| File | Status | Description |
|---|---|---|
| [`alternative-free-backup-channels`](./decisions/ops/alternative-free-backup-channels.md) | active | Documents alternative free-forever backup channels to protect GitHub |
| [`analytics-five-tier-stack`](./decisions/ops/analytics-five-tier-stack.md) | active | Locked 2026-06-20: every site runs five analytics layers in parallel\ |
| [`backup-channels-alternative`](./decisions/ops/backup-channels-alternative.md) | active | Documents alternative free-forever backup channels to protect GitHub |
| [`backup-everywhere-weekly`](./decisions/ops/backup-everywhere-weekly.md) | active | Weekly cron backs up to multiple destinations simultaneously: 4-host |
| [`backup-restic-to-b2`](./decisions/ops/backup-restic-to-b2.md) | active | Weekly encrypted, deduplicated backups via restic running on a GitHub |
| [`cf-web-analytics-family-wide`](./decisions/ops/cf-web-analytics-family-wide.md) | active | Locked 2026-06-23. The existing CF_WEB_ANALYTICS_SITE_TAG (4c365cb8a8b3498b90238196fdfcb7ef) |
| [`disk-image-windows-builtin-2026-06-25`](./decisions/ops/disk-image-windows-builtin-2026-06-25.md) | active | Locked 2026-06-25. Macrium Reflect Free is discontinued (Jan 2024) and is no longer available. Replace with Windows built-in Backup-and-Restore (Windows 7-era tool, still present in Windows 11) for full-disk images. Restic to Backblaze B... |
| [`extension-distribution`](./decisions/ops/extension-distribution.md) | active | Every extension is its own GitHub repo, submoduled under extensions/. |
| [`logs-better-stack-plus-cf-tail`](./decisions/ops/logs-better-stack-plus-cf-tail.md) | active | Two-layer log strategy. Cloudflare Workers Tail for live in-Worker debugging |
| [`mirror-to-9-popular-alternatives-2026-06-28`](./decisions/ops/mirror-to-9-popular-alternatives-2026-06-28.md) | active | Mirror repos/own/* to 9 free, no-self-host GitHub alternatives (GitLab, Codeberg, Bitbucket, GitFlic, Azure DevOps, NotABug, GitGud, RocketGit, Radicle) driven from the umbrella repo's GitHub Actions. |
| [`perf-monitoring-vercel-speed-insights`](./decisions/ops/perf-monitoring-vercel-speed-insights.md) | active | Vercel Speed Insights captures Real-User Monitoring Web Vitals on every |
| [`release-cadence`](./decisions/ops/release-cadence.md) | active | Every app rides a weekly release train on Wednesday 9 AM IST via a workspace-level |
| [`seo-a11y-cdn-ssl`](./decisions/ops/seo-a11y-cdn-ssl.md) | active | Multi-engine SEO (Google + Bing + Yandex + IndexNow auto-submission)\ |
| [`seo-three-pillars`](./decisions/ops/seo-three-pillars.md) | active | Every family site ships all three SEO pillars: @astrojs/sitemap (discovery), |
| [`submodule-pattern`](./decisions/ops/submodule-pattern.md) | active | Every site, every package, and every extension is a standalone GitHub |
| [`subscription-flow`](./decisions/ops/subscription-flow.md) | active | One subscription unlocks everything. User pays via Razorpay, webhook |
| [`time-tracking-wakatime-only`](./decisions/ops/time-tracking-wakatime-only.md) | active | Locked 2026-06-20 (walked back same day): time tracking is Wakatime |

### Stack (22)

| File | Status | Description |
|---|---|---|
| [`a11y-three-tools`](./decisions/stack/a11y-three-tools.md) | active | Every PR runs axe-core, Pa11y, and Lighthouse CI in parallel. PR fails |
| [`automation`](./decisions/stack/automation.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for end-to-end automation and testing. |
| [`cli-tools`](./decisions/stack/cli-tools.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for building command-line interfaces. |
| [`code-quality-five-tools`](./decisions/stack/code-quality-five-tools.md) | active | Locked 2026-06-20: every public repo runs five complementary code-quality\ |
| [`cpp`](./decisions/stack/cpp.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for C++. |
| [`csharp`](./decisions/stack/csharp.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for C#. |
| [`databases`](./decisions/stack/databases.md) | active | The absolute best, most minimalist, and fastest database stack, including serverless SQL, edge-native SQL, key-value, and object storage. |
| [`extensions`](./decisions/stack/extensions.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for browser and editor extensions. |
| [`family-stack-lock`](./decisions/stack/family-stack-lock.md) | - | Same stack on every site (longform / catalog / hub / tool). Static output. CF Pages for monetised sites; GH Pages for info-only sites where the product is monetised elsewhere. |
| [`go`](./decisions/stack/go.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, |
| [`hosting`](./decisions/stack/hosting.md) | active | The absolute best, most minimalist, and fastest hosting solutions for static frontend applications, edge workers, and containerized microservices. |
| [`java`](./decisions/stack/java.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for Java. |
| [`javascript-typescript`](./decisions/stack/javascript-typescript.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, |
| [`newsletter-substack`](./decisions/stack/newsletter-substack.md) | active | Single newsletter for the whole oriz family at chirag127.substack.com |
| [`public-image-upload-tool`](./decisions/stack/public-image-upload-tool.md) | active | Locked 2026-06-23. oriz-pixie-image-tools-app gets a public /upload\ |
| [`python`](./decisions/stack/python.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, |
| [`rust`](./decisions/stack/rust.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for Rust. |
| [`stack-picks-2026-06-22`](./decisions/stack/stack-picks-2026-06-22.md) | active | Cross-cutting service picks locked on 2026-06-22. AI: `@chirag127/oriz-ai-providers`\ |
| [`tool-categories-roadmap`](./decisions/stack/tool-categories-roadmap.md) | - | The locked list of 15 tool subdomains: 8 Tier 1 (ship working day 1) |
| [`tool-feature-scopes-2026-06-22`](./decisions/stack/tool-feature-scopes-2026-06-22.md) | active | Final feature scope per tool app. All tools are 100% client-side (no |
| [`tools-shape-and-priority`](./decisions/stack/tools-shape-and-priority.md) | active | 16 tool apps, each at its own *.oriz.in subdomain (paisa, slice, scribe, |
| [`tools-site-15-repos`](./decisions/stack/tools-site-15-repos.md) | - | Each tool category is its own GitHub repo (pdf-site, image-site, ...) |

### Compute (22)

| File | Status | Description |
|---|---|---|
| [`ai-puter-plus-cf-workers-ai`](./decisions/compute/ai-puter-plus-cf-workers-ai.md) | active | Two AI providers, picked by surface. Puter.js for browser-side calls |
| [`api-hosting-triple-rail`](./decisions/compute/api-hosting-triple-rail.md) | active | Every oriz API repo serves data via THREE rails simultaneously. (1)\ |
| [`api-mocks-msw-plus-mockoon`](./decisions/compute/api-mocks-msw-plus-mockoon.md) | active | Two API-mock tools, one per surface. MSW handles in-browser + in-Node |
| [`api-routes-structure`](./decisions/compute/api-routes-structure.md) | active | The Hono Worker splits routes by concern under apps/api/src/routes/\ |
| [`api-scraping-tos-audit`](./decisions/compute/api-scraping-tos-audit.md) | - | (no description) |
| [`api-umbrella-hono-worker`](./decisions/compute/api-umbrella-hono-worker.md) | active | Single Hono Worker at api.oriz.in serves every API route for the family. |
| [`billing-webhook-cf-pages-function`](./decisions/compute/billing-webhook-cf-pages-function.md) | active | Razorpay (INR) + Paddle (ROW) + Play Billing (Android) + MS Store (Windows)\ |
| [`cf-worker-quota-mitigation`](./decisions/compute/cf-worker-quota-mitigation.md) | active | Locked 2026-06-20: 8-step playbook for staying under the CF Workers |
| [`cron-split-cf-vs-gh`](./decisions/compute/cron-split-cf-vs-gh.md) | active | Run cron on BOTH substrates. CF Cron Triggers for in-Worker low-latency |
| [`data-apis-open-meteo-alpha-vantage`](./decisions/compute/data-apis-open-meteo-alpha-vantage.md) | active | Locked 2026-06-20: Open-Meteo for weather data, Alpha Vantage for finance |
| [`distribution-and-queues-locked`](./decisions/compute/distribution-and-queues-locked.md) | active | Single Batch 13 lock covering distribution + reliability. Browser extensions\ |
| [`drafts-queue-host`](./decisions/compute/drafts-queue-host.md) | active | Manual-post drafts queue lives in a private GitHub repo (chirag127/oriz-drafts) |
| [`github-pages-as-json-api`](./decisions/compute/github-pages-as-json-api.md) | active | Static, read-only JSON APIs live in <name>-api repos and serve via GitHub |
| [`health-check-cron-plus-uptime`](./decisions/compute/health-check-cron-plus-uptime.md) | active | Locked 2026-06-20: cron-job liveness is verified by healthchecks.io\ |
| [`hono-rpc-for-type-sharing`](./decisions/compute/hono-rpc-for-type-sharing.md) | active | Type-safe site\u2192API client built via Hono's hc<AppType>. No codegen,\ |
| [`hono-rpc-type-sharing`](./decisions/compute/hono-rpc-type-sharing.md) | active | API consumers get full type inference from the Hono Worker via the rpc |
| [`hono-worker-api-umbrella`](./decisions/compute/hono-worker-api-umbrella.md) | active | All 11+ sites and all extensions share a single Hono Worker deployed |
| [`hono-write-once-deploy-all-rails`](./decisions/compute/hono-write-once-deploy-all-rails.md) | active | Locked 2026-06-23. Every API/Worker in the family uses Hono. Same business\ |
| [`local-dev-tunneling-cf-tunnel`](./decisions/compute/local-dev-tunneling-cf-tunnel.md) | active | Locked 2026-06-20: local dev for the family runs on three substrates\ |
| [`market-data-apis`](./decisions/compute/market-data-apis.md) | active | Two India-market data APIs in the family, each in its own GitHub repo: |
| [`queue-cloudflare-native`](./decisions/compute/queue-cloudflare-native.md) | active | Cloudflare Queues is the family's primary durable queue. Picked for native |
| [`service-bindings-future`](./decisions/compute/service-bindings-future.md) | active | Cloudflare Service Bindings give zero-cost, zero-network-hop RPC between |

### Frontend (16)

| File | Status | Description |
|---|---|---|
| [`charts-echarts-lazy`](./decisions/frontend/charts-echarts-lazy.md) | active | ECharts (Apache-2.0, 50+ chart types) is the family-wide chart library. |
| [`final-per-app-visual-shared-behavior`](./decisions/frontend/final-per-app-visual-shared-behavior.md) | active | Locked 2026-06-22 evening. Resolves the multi-reversal sequence on shared-vs-divergent |
| [`footer-5-columns-responsive`](./decisions/frontend/footer-5-columns-responsive.md) | active | Each app's footer (per-app visual per FINAL decision) has 5 columns:\ |
| [`footer-per-app-with-universal-legal`](./decisions/frontend/footer-per-app-with-universal-legal.md) | active | Refines the maximalist-footer decision from earlier same day. Each app\ |
| [`four-nav-surfaces-every-app`](./decisions/frontend/four-nav-surfaces-every-app.md) | active | Every oriz app must include all 4 navigation surfaces (Header at top, |
| [`framework-astro-react-tailwind-shadcn-2026-06-25`](./decisions/frontend/framework-astro-react-tailwind-shadcn-2026-06-25.md) | active | Locked 2026-06-25. Every app starts on the default stack — Astro shell, React for interactive islands, Tailwind for styling, shadcn/ui for components. Per-repo design pass (frontend-design skill) sets the palette, typography, and signatu... |
| [`image-cdn-fallback-chain`](./decisions/frontend/image-cdn-fallback-chain.md) | active | Every image rendered through the @chirag127/oriz-kit <Image> wrapper |
| [`layer-1-static-hosting`](./decisions/frontend/layer-1-static-hosting.md) | active | Cloudflare Pages free is the primary host for all 11+ sites and the extensions |
| [`layer-2-survival-fallback`](./decisions/frontend/layer-2-survival-fallback.md) | active | Every site builds a static fallback to chirag127.github.io/<site> on\ |
| [`linkroll-raindrop-to-links-page`](./decisions/frontend/linkroll-raindrop-to-links-page.md) | active | The family's curated linkroll lives in a public Raindrop.io collection. |
| [`maximalist-footer-and-monetization-everywhere`](./decisions/frontend/maximalist-footer-and-monetization-everywhere.md) | active | Two reversals locked 2026-06-22 evening. (1) Footer = MAXIMALIST mega-sitemap |
| [`multi-engine-search-button`](./decisions/frontend/multi-engine-search-button.md) | active | Every site in the chirag127/oriz family ships a single 'Search the web |
| [`og-card-generation-satori`](./decisions/frontend/og-card-generation-satori.md) | active | Non-code posts get OG cards from Satori (@vercel/og) on a Hono Worker |
| [`pwabuilder-as-primary-converter`](./decisions/frontend/pwabuilder-as-primary-converter.md) | active | Every Astro app's PWA build is the source of truth. PWABuilder (free, |
| [`sidebar-4-tier`](./decisions/frontend/sidebar-4-tier.md) | - | Every site ships a sidebar via @chirag127/sidebar, but the sidebar config |
| [`status-banner-on-every-site`](./decisions/frontend/status-banner-on-every-site.md) | active | Every site embeds a thin, dismissible <StatusBanner /> from oriz-kit |

### Database (9)

| File | Status | Description |
|---|---|---|
| [`build-cache-gh-actions-plus-pnpm`](./decisions/database/build-cache-gh-actions-plus-pnpm.md) | active | Three-layer build cache strategy. Layer 1: pnpm content-addressable\ |
| [`canonical-store-jsonl`](./decisions/database/canonical-store-jsonl.md) | active | The chirag127/oriz-me-data git repo is the authoritative store for lifestream |
| [`cloud-dbs-as-caches`](./decisions/database/cloud-dbs-as-caches.md) | active | Firestore, Turso, and R2 are caches. They are rebuilt from the canonical |
| [`db-add-neon-postgres`](./decisions/database/db-add-neon-postgres.md) | active | Neon Postgres is added as the family's relational database. Free plan,\ |
| [`db-admin-console-only`](./decisions/database/db-admin-console-only.md) | active | Every database in the family is administered through its vendor's browser\ |
| [`events-table-schema`](./decisions/database/events-table-schema.md) | active | The SQL shape the lifestream JSONL is normalised into for the Turso\ |
| [`firebase-rest-firestore-not-admin`](./decisions/database/firebase-rest-firestore-not-admin.md) | active | The umbrella Hono Worker uses firebase-rest-firestore (REST + service-account |
| [`lifestream-jsonl-canonical`](./decisions/database/lifestream-jsonl-canonical.md) | active | The chirag127/oriz-me-data git repo holds canonical JSONL events sharded |
| [`object-storage-split`](./decisions/database/object-storage-split.md) | active | Versioned binaries live in GitHub Releases. Unversioned blobs live in |

### Apps (17)

| File | Status | Description |
|---|---|---|
| [`cards-site-scope`](./decisions/apps/cards-site-scope.md) | - | cards-site (cards.oriz.in) covers all financial cards in the Indian |
| [`content-apps-scope`](./decisions/apps/content-apps-scope.md) | active | Three Wave 3 content apps. tabs-cards-app at tabs.oriz.in (visual bookmark |
| [`cs-me-app-scope`](./decisions/apps/cs-me-app-scope.md) | active | The personal site at me.oriz.in (aliased as cs.oriz.in to the same site).\ |
| [`data-in-app-repos-not-separate`](./decisions/apps/data-in-app-repos-not-separate.md) | active | Locked 2026-06-22 evening. Reverses earlier proposal to create separate |
| [`eleven-saturated-archived-2026-06-25`](./decisions/apps/eleven-saturated-archived-2026-06-25.md) | active | Locked 2026-06-25. Eleven tool repos fail the defect-audit build-gate because the top-3 Google results already serve users well. They are archived on GitHub and removed from local disk. Two had real production code (slice-pdf, pixie-imag... |
| [`family-wide-stats-page`](./decisions/apps/family-wide-stats-page.md) | active | Locked 2026-06-20: oriz.in/stats aggregates visitor data from all 11 |
| [`finance-one-repo-ten-routes-2026-06-25`](./decisions/apps/finance-one-repo-ten-routes-2026-06-25.md) | active | Locked 2026-06-25. The ten finance calculators consolidate into a single finance repo serving finance.oriz.in/emi, /sip, /tax-80c, /hra, /ppf, /nps, /retirement, /gst, /fd, /lumpsum. Reverses the earlier 10-repo split. Shared @oriz/finan... |
| [`fleet-strategy-build-gate-2026-06-25`](./decisions/apps/fleet-strategy-build-gate-2026-06-25.md) | active | Locked 2026-06-25. A tool gets built only when the top three Google results for its core query reveal a concrete defect (paywall, broken UX, ad-spam, missing feature, data staleness). The defect is documented in the tool's README. No fix... |
| [`home-app-shape`](./decisions/apps/home-app-shape.md) | active | oriz.in is the marketing landing page for the family. Single hero + 5-section |
| [`janaushdhi-app-scope`](./decisions/apps/janaushdhi-app-scope.md) | active | janaushdhi.oriz.in scrapes the Pradhan Mantri Bhartiya Janaushadhi Pariyojana\ |
| [`ncert-app-scope`](./decisions/apps/ncert-app-scope.md) | active | ncert.oriz.in catalogs every NCERT textbook (Pre-Primary + classes 1-12),\ |
| [`ncert-combined-pdf-directory`](./decisions/apps/ncert-combined-pdf-directory.md) | active | ncert.nic.in only offers per-chapter PDFs. ncert.oriz.in's reason-to-exist\ |
| [`ncert-dual-mode-download`](./decisions/apps/ncert-dual-mode-download.md) | active | Both download modes offered: (1) Pre-merged combined PDFs as GitHub\ |
| [`omni-post-app-shape`](./decisions/apps/omni-post-app-shape.md) | active | omni-post.oriz.in wraps the @chirag127/omni-publish package with an admin |
| [`oriz-status-app`](./decisions/apps/oriz-status-app.md) | active | Locked 2026-06-22 (evening): in-house status page at status.oriz.in. |
| [`per-app-briefs-2026-06-22`](./decisions/apps/per-app-briefs-2026-06-22.md) | active | Single source of truth for what each of the 26 apps does + sections\ |
| [`per-app-contents-spec`](./decisions/apps/per-app-contents-spec.md) | active | Every app in repos/oriz/own/prod/apps/* follows this contents spec. 4-config |

### Content (9)

| File | Status | Description |
|---|---|---|
| [`blog-cross-post-strategy`](./decisions/content/blog-cross-post-strategy.md) | active | pages-blog-app posts daily to blog.oriz.in. omni-publish v0.1.1+ fans\ |
| [`book-publish-pipeline`](./decisions/content/book-publish-pipeline.md) | active | Books in the chirag127/oriz family are written as Markua-flavoured Markdown\ |
| [`books-publishing-shape`](./decisions/content/books-publishing-shape.md) | active | books.oriz.in is a static catalog showing cover + price + buy-links |
| [`feeds-rss-atom-json`](./decisions/content/feeds-rss-atom-json.md) | active | Every content-bearing site publishes three feed formats: /rss.xml (RSS |
| [`first-book-oriz-learnings`](./decisions/content/first-book-oriz-learnings.md) | active | User changed first-book pick on 2026-06-22 from Oriz Me (PWYW personal)\ |
| [`journal-photo-pipeline`](./decisions/content/journal-photo-pipeline.md) | active | oriz-roam-journal-app uploads photos to four free hosts in parallel (Cloudinary |
| [`journal-site-sources`](./decisions/content/journal-site-sources.md) | - | journal-site (journal.oriz.in) mines the best features of Day One, Bear, |
| [`newsletter-split-buttondown-emailoctopus`](./decisions/content/newsletter-split-buttondown-emailoctopus.md) | active | Two newsletter senders side by side. Buttondown handles the technical |
| [`stats-feeds-versioning-template`](./decisions/content/stats-feeds-versioning-template.md) | active | Single dashboard app `oriz-stats-app` at stats.oriz.in shows family-wide\ |

### Branding (2)

| File | Status | Description |
|---|---|---|
| [`repo-naming-drop-oriz-prefix-2026-06-25`](./branding/repo-naming-drop-oriz-prefix-2026-06-25.md) | active | Locked 2026-06-25. Repo slugs use the service name only — no oriz- prefix. The GitHub org namespace (oriz-org/<slug>) provides the brand. Existing repos migrate via gh repo rename. Type suffix (-api, -npm-pkg, -bs-ext, -ide-ext, -cli, -m... |
| [`subdomain-path-based-on-category-2026-06-25`](./branding/subdomain-path-based-on-category-2026-06-25.md) | active | Locked 2026-06-25. Per-tool function-based subdomains are abandoned. Tools live at <category>.oriz.in/<tool> (e.g. finance.oriz.in/emi, finance.oriz.in/sip). Topical SEO authority compounds on the category subdomain via internal cross-li... |

### Monetisation (1)

| File | Status | Description |
|---|---|---|
| [`donations-only-2026-06-25`](./monetisation/donations-only-2026-06-25.md) | active | Locked 2026-06-25. Monetisation reduced to three donation rails — BuyMeACoffee, GitHub Sponsors, UPI. No Pro/Max paid tier, no AdSense, no Razorpay subscription flow. Reverses the centralized oriz.in/pricing decision and the auth+billing... |

### Knowledge Bundle (1)

| File | Status | Description |
|---|---|---|
| [`depth-5-level-hierarchy`](./decisions/knowledge-bundle/depth-5-level-hierarchy.md) | - | Depth is sized to the L1 folder so any single agent read pulls the smallest possible leaf. Tiny folders stay flat; big folders deepen to 5. Supersedes the static 3-then-4-level rule. |

### General (36)

| File | Status | Description |
|---|---|---|
| [`agent-skills-monorepo`](./decisions/agent-tooling/agent-skills-monorepo.md) | active | Single source of truth for all agent skills used by both the AI agent |
| [`auto-tracking-everywhere`](./decisions/ops/auto-tracking-everywhere.md) | active | Locked 2026-06-20: every tracked metric in the chirag127/oriz family\ |
| [`bug-tracker-github-issues-only`](./decisions/ops/bug-tracker-github-issues-only.md) | active | Locked 2026-06-20: every site / extension / package / worker / data\ |
| [`chrome-config-contract`](./decisions/apps/chrome-config-contract.md) | active | Locked: generic components driven by 4 per-site config files; 3-level\ |
| [`chromium-hardware-scaling-profiles`](./decisions/compute/chromium-hardware-scaling-profiles.md) | active | Architectural guidelines for optimizing Chromium-based browsers (Chrome/Edge) across multi-vCPU cloud virtual machines, hybrid local processors, memory-constrained client systems, and mobile extension targets. |
| [`cms-markdown-in-repo-only`](./decisions/content/cms-markdown-in-repo-only.md) | active | Every site stores content as .md / .mdx files in its own repo. Decap |
| [`code-stats-everything`](./decisions/ops/code-stats-everything.md) | active | Locked 2026-06-20: every public family repo runs the full code-stats\ |
| [`cross-post-engine`](./decisions/content/cross-post-engine.md) | active | @chirag127/post-site watches the oriz-blog-site RSS feed and fans each |
| [`dynamic-family-data-registry`](./decisions/ops/dynamic-family-data-registry.md) | active | User mandate 2026-06-22 evening (final): family inventory changes constantly; |
| [`feature-flags-deferred`](./decisions/ops/feature-flags-deferred.md) | active | Locked 2026-06-23. No feature-flag system in the family right now. Reason: |
| [`forms-trio`](./decisions/content/forms-trio.md) | active | Locked 2026-06-20: contact forms ship a vendor-redundant pair (Web3Forms |
| [`geocoding-deferred`](./decisions/ops/geocoding-deferred.md) | active | No geocoding service adopted in 2026-06-20. None of the 11 current sites\ |
| [`image-host-four-tier`](./decisions/packages/image-host-four-tier.md) | active | Image origin storage uses a 4-tier chain \u2014 repo-hosted on CF Pages\ |
| [`layer-4-database-by-shape`](./decisions/database/layer-4-database-by-shape.md) | active | Different data shapes go in different free tiers, deliberately spreading |
| [`layer-5-compute`](./decisions/compute/layer-5-compute.md) | active | Compute work is split across GitHub Actions cron (build-time), Cloudflare |
| [`lifestream-auto-event-sources`](./decisions/apps/lifestream-auto-event-sources.md) | active | Locked 2026-06-20: the oriz-me JSONL canonical store is fed by THREE\ |
| [`lifestream-federation`](./decisions/content/lifestream-federation.md) | active | oriz-me lifestream JSONL stays canonical; mirrored as AT Protocol records |
| [`market-data-per-repo`](./decisions/ops/market-data-per-repo.md) | active | FII/DII activity and Tickertape MMI each live in their own GitHub repo. |
| [`master-pointer-as-production-sha`](./decisions/ops/master-pointer-as-production-sha.md) | active | The chirag127/oriz master repo's submodule pointers IS the production |
| [`maximum-libraries-policy`](./decisions/ops/maximum-libraries-policy.md) | active | User reversed the minimal-libraries decision (2026-06-22 evening): use |
| [`mit-license-all-repos`](./decisions/ops/mit-license-all-repos.md) | active | All 17 packages + 26 apps + 2 APIs relicensed from source-available-all-rights-reserved\ |
| [`modal-plus-val-town-specialized-rails`](./decisions/compute/modal-plus-val-town-specialized-rails.md) | active | Locked 2026-06-23 after fact-checking Modal Labs free tier still exists |
| [`no-firebase-functions`](./decisions/compute/no-firebase-functions.md) | active | Cloud Functions for Firebase requires the Blaze pay-as-you-go plan, |
| [`no-separate-dev-prod-projects`](./decisions/ops/no-separate-dev-prod-projects.md) | active | Locked 2026-06-23. Verdict from cited research (15+ sources, 6-prong\ |
| [`notifications-fcm-plus-knock`](./decisions/ops/notifications-fcm-plus-knock.md) | active | Two-layer notification stack: Knock owns multi-channel orchestration |
| [`oriz-me-single-site-not-split`](./decisions/apps/oriz-me-single-site-not-split.md) | active | me.oriz.in stays one Astro site with internal URL sections (/now, /uses, |
| [`per-runtime-framework`](./decisions/frontend/per-runtime-framework.md) | active | Astro 6 for all 25+ sites + companion docs; Vite+React+WXT for browser |
| [`project-mgmt-github-projects-only`](./decisions/ops/project-mgmt-github-projects-only.md) | active | Locked 2026-06-20: family-wide project / task management lives on a\ |
| [`revenue-channels-2026`](./monetisation/revenue-channels-2026.md) | active | Every product surface in the chirag127/oriz family (26 apps + 17 packages\ |
| [`shared-vs-divergent-matrix`](./decisions/ops/shared-vs-divergent-matrix.md) | active | Definitive matrix of what is shared via packages vs what diverges per-app.\ |
| [`testing-three-layer`](./decisions/ops/testing-three-layer.md) | active | Every PR runs Vitest unit, Playwright E2E, and Chromatic visual-regression |
| [`url-shortener-mitigation-tiers`](./decisions/ops/url-shortener-mitigation-tiers.md) | active | Three-tier URL shortener stack, all free, no card. Tier 1: self-hosted |
| [`url-shortener-quota-mitigation`](./decisions/ops/url-shortener-quota-mitigation.md) | active | s.oriz.in is a Cloudflare Worker. Free tier is 100K requests/day per\ |
| [`userscript-prototype-via-tweeks`](./decisions/apps/userscript-prototype-via-tweeks.md) | active | For new userscript ideas, use Tweeks (YC-backed AI browser extension |
| [`utm-attribution-strategy`](./decisions/ops/utm-attribution-strategy.md) | active | Marketing attribution rides on UTM query parameters injected into outbound |
| [`voice-sms-deferred-to-knock`](./decisions/ops/voice-sms-deferred-to-knock.md) | active | No standalone voice or SMS provider in 2026-06-20. Twilio + Vonage rejected\ |


## Branding (16 total)  �  Design (13 total)  �  Infrastructure (17 total)  �  Monetisation (13 total)  �  Policy (16 total)  �  Security (21 total)

### Branding (11)

| File | Status | Description |
|---|---|---|
| [`family-wide-privacy-page`](./branding/family-wide-privacy-page.md) | active | Locked 2026-06-20: master oriz.in publishes a single canonical /privacy that the entire family (sites + extensions + workers + CLIs) references. Per-surface addenda (extension permission lists, site-specific data flows) live as nested pa... |
| [`github-repo-naming-best-practices`](./branding/github-repo-naming-best-practices.md) | active | Single source covering every naming rule across v5 + v6 + the web-search-derived best practices. Use this file to check a proposed repo name before gh repo create. |
| [`i18n-weblate-when-ready`](./branding/i18n-weblate-when-ready.md) | active | The family stays English-only until a site or extension shows real non-English demand. When that day comes, Weblate Hosted Libre is the chosen translation-management platform. |
| [`keep-oriz-org-recruiter-via-pinning`](./branding/keep-oriz-org-recruiter-via-pinning.md) | active | The 'recruiter won't see my work because it's on oriz-org' worry is solved by PINNING oriz-org repos on chirag127's profile (they appear as your work on chirag127's page, with link to oriz-org for click-through) + cross-linking chirag127... |
| [`naming-policy-v6`](./branding/naming-policy-v6.md) | active | Repos follow oriz-<product-brand>-<category>-<suffix> format. Family brand is single, family-wide (`oriz`), Google-style. Product brand inserted per product. Existing astro-*-npm-pkg packages keep current names. Workspace umbrella keeps ... |
| [`omnipost-name`](./branding/omnipost-name.md) | active | The family's RSS-driven cross-poster is named @chirag127/oriz-omnipost — palette: omni- prefix + post; user said 'name omnipotent'. One button to broadcast every blog post to every supported platform. |
| [`oriz-me-added-to-family`](./branding/oriz-me-added-to-family.md) | active | On 2026-06-19, oriz-me (me.oriz.in — personal digital twin / lifestream) was added as a submodule under sites/, bringing the site count to 11. |
| [`oriz-org-rename-from-co`](./branding/oriz-org-rename-from-co.md) | active | The GitHub org created 2026-06-22 as oriz-co is renamed to oriz-org because oriz-org reads more naturally as 'oriz the organization' and is available. GitHub auto-redirects oriz-co/* URLs to oriz-org/*; all 23 tracked references (.gitmod... |
| [`repo-naming-suffixes`](./branding/repo-naming-suffixes.md) | active | Every site repo is named <subdomain-prefix>-site (the subdomain prefix on oriz.in, suffixed with -site). Browser extensions get -bs-ext (revised 2026-06-24 from -ext to match the bs-ext/ folder convention), VS Code extensions -vsc-ext, C... |
| [`title-case-oriz`](./branding/title-case-oriz.md) | active | User-facing brand mark is rendered Title-Case as 'Oriz'. Repo slugs, npm package names, DOM attributes, and code identifiers stay lowercase (`oriz-*`, `@chirag127/oriz-*`, `data-oriz-*`). |

#### naming (1)

| File | Status | Description |
|---|---|---|
| [`policy-family-naming-policy`](./branding/naming/policy-family-naming-policy.md) | - | GitHub repo slug = npm package name (when both exist). Subdomains are independent and shorter. Role-suffix every repo. No brand prefix on new repos. -mcp added to the suffix matrix. |

### Content (8)

| File | Status | Description |
|---|---|---|
| [`100-year-strategy-locked`](./decisions/content/100-year-strategy-locked.md) | active | The 16-point strategic contract for me.oriz.in — 50-year horizon, public archive on death, 10-min/day budget, JSONL canonical, GitHub Pages survival layer — is locked as a family-wide reference. |
| [`age-gating-policy-adopted`](./decisions/content/age-gating-policy-adopted.md) | active | Tracked items carrying adult-content metadata (movies, anime, possibly others) render behind an 18+ confirmation gate, not silently published or silently hidden. |
| [`big-website-per-extension`](./decisions/content/big-website-per-extension.md) | active | Per-extension subdomains host full marketing/docs/changelog/support sites, not single-page landings. |
| [`extensions-catalog-and-subdomains`](./decisions/content/extensions-catalog-and-subdomains.md) | active | Both surfaces exist: a central catalog at extensions.oriz.in for browsing/discovery and individual <slug>.oriz.in subdomains for each extension's deep website. |
| [`journal-stays-auth-gated`](./decisions/content/journal-stays-auth-gated.md) | active | The public site me.oriz.in surfaces only NUMERIC aggregates from the journal. Entry text lives at journal.oriz.in behind Firebase Auth — never publicly indexed. |
| [`oriz-home-cross-promos-extensions`](./decisions/content/oriz-home-cross-promos-extensions.md) | active | The oriz.in home portal renders the extensions catalog as a section so visitors arriving at the apex see both sites and extensions. |
| [`per-extension-privacy-policy`](./decisions/content/per-extension-privacy-policy.md) | active | Per-extension /privacy pages on each extension's subdomain. Common family-wide boilerplate lives once at oriz.in/privacy-base and is inlined / linked from per-extension pages. |
| [`per-extension-subdomain`](./decisions/content/per-extension-subdomain.md) | active | Every published extension gets a dedicated subdomain (e.g. <slug>.oriz.in) hosting its big website, in addition to its slot in the extensions catalog. |

### Design (12)

| File | Status | Description |
|---|---|---|
| [`_family-rules`](./design/_family-rules.md) | active | The cross-site design contract: surface distribution, typeface budget, accent colour distribution, no-compromise briefs, and universal constraints across all 11 oriz-* sites. |
| [`datasheet-dark`](./design/datasheet-dark.md) | active | Every chirag127 site, extension, and CLI doc page shares one locked dark design system — Oriz Datasheet Dark — with monospace display, ledger-paper text, burnt-sienna stamp accent, and identical 4-region chrome. |
| [`oriz-blog`](./design/oriz-blog.md) | active | An engineer's working notebook — cream paper, Fraunces drop-cap, cobalt accent, series-spine signature glyph, no card grid, no hero images. |
| [`oriz-book-lore`](./design/oriz-book-lore.md) | active | Aged-cream reading-room surface with pencil-red marginalia, bottle-green narration ribbon, brass page numbers — the 'old book that lived on a desk' metaphor. |
| [`oriz-books`](./design/oriz-books.md) | active | NCERT textbook directory rendered as a library catalogue drawer: ink-block desk, bone catalogue cards, cinnabar accent, IBM Plex Serif + Sans Devanagari. |
| [`oriz-cards`](./design/oriz-cards.md) | active | Bloomberg-terminal-for-Indian-credit-cards: cool slate surface, carbon-blue primary, vermilion only on negative numbers, wide-mono display type, CSS-rendered embossed card signature. |
| [`oriz-finance`](./design/oriz-finance.md) | active | Calculator workbench for the salaried Indian: literal printed graph-paper grid, hairline tan rules, decimal-aligned tabular numbers, graph-teal accent, Fraunces display. |
| [`oriz-home`](./design/oriz-home.md) | active | Master hub / portal route: dark leather-spine surface, monochrome until hover, mustard-yellow primary, single vermilion 'start anywhere' arrow as the affordance hint. |
| [`oriz-image-tools`](./design/oriz-image-tools.md) | active | Browser darkroom: 13 client-side image tools, dark surface, Space Grotesk display, phosphor #C8FF3C accent, the histogram is the brand. Zero uploads. |
| [`oriz-journal`](./design/oriz-journal.md) | active | Auth-gated PWA for serious journalers: dusk surface with cream entry pages, animated wax seal, seal-red accent, GT Sectra titles, libsodium client-side encryption. |
| [`oriz-me`](./design/oriz-me.md) | active | Personal site as build manifest: datasheet white, archival-blue accent, IBM Plex Sans Condensed, provenance strip with live build timestamp + 4px pulsing sync dot — the only animation on the site. |
| [`oriz-pdf-tools`](./design/oriz-pdf-tools.md) | active | Typesetter's desk for documents: cream manuscript surface, all-serif type stack (even buttons), ledger-green CTAs, vermilion reserved for redaction/destructive actions. |

### Infrastructure (11)

| File | Status | Description |
|---|---|---|
| [`chrome-extensions-as-submodules`](./infrastructure/chrome-extensions-as-submodules.md) | active | Every extension lives in its own chirag127/oriz-<name>-ext repo, added under extensions/ in the master oriz repo as a git submodule. |
| [`cloudflare-pages-for-all-sites`](./infrastructure/cloudflare-pages-for-all-sites.md) | active | Every website and every app in the family — content sites, tool apps, hub apps, personal apps, the extensions catalog — deploys to Cloudflare Pages free. No exceptions. Firebase Hosting, Vercel, Netlify, GitHub Pages-as-primary all rejec... |
| [`extension-auth-firebase-plus-license-key`](./infrastructure/extension-auth-firebase-plus-license-key.md) | active | Extensions authenticate users via Firebase Auth (chrome.identity.launchWebAuthFlow + auth.oriz.in); a license-key fallback exists for paranoid privacy users who refuse Firebase. |
| [`extensions-cross-store-publish`](./infrastructure/extensions-cross-store-publish.md) | active | Each extension repo includes an automated GitHub Actions publish workflow that submits the same artifact to Chrome Web Store, Firefox Add-ons, and Microsoft Edge Add-ons. |
| [`firebase-spark-forever`](./infrastructure/firebase-spark-forever.md) | active | Firebase usage is permanently capped to the Spark plan. Blaze is excluded by the no-card-on-file rule and documented bill-shock incidents. |
| [`flat-subdomain-pattern`](./infrastructure/flat-subdomain-pattern.md) | active | Locked 2026-06-23. Every public-facing repo in the family (apps, npm packages, books, skills, extensions) gets a flat <slug>.oriz.in custom subdomain. APIs keep their existing *.api.oriz.in shape (grandfathered, GH Pages Let's Encrypt SS... |
| [`github-pages-mirror-per-site`](./infrastructure/github-pages-mirror-per-site.md) | active | Each site's CI builds a static fallback to chirag127.github.io/<site> on every push to main, so /work + /me + /legal stay live if the primary host dies. |
| [`hookdeck-for-webhook-reliability`](./infrastructure/hookdeck-for-webhook-reliability.md) | active | Hookdeck queues Razorpay webhooks → forwards to api.oriz.in Worker, with retries + replay. 100K req/mo free, no card. |
| [`monitor-apex-only`](./infrastructure/monitor-apex-only.md) | active | SSL + uptime monitoring is configured for the apex domain only. *.oriz.in subdomains inherit via Cloudflare auto-rotation. |
| [`spaceship-registrar-cloudflare-dns`](./infrastructure/spaceship-registrar-cloudflare-dns.md) | active | Family domains stay at Spaceship (the user's existing registrar). NS records delegate DNS to Cloudflare. Cloudflare Email Routing forwards every address into a single Gmail inbox. |
| [`subdomains-under-oriz-in`](./infrastructure/subdomains-under-oriz-in.md) | active | Every site, extension, and API endpoint binds to a subdomain under oriz.in — never to a separate apex domain. |

### Monetisation (7)

| File | Status | Description |
|---|---|---|
| [`adsense-apex-application`](./monetisation/adsense-apex-application.md) | active | One AdSense application for the oriz.in apex covers every subdomain; if rejected, the fallback order is Ezoic, then Mediavine, then other ad networks. |
| [`max-payment-methods`](./monetisation/max-payment-methods.md) | active | Locked decision: every paid surface accepts the maximum viable set of payment methods — Razorpay for India, Lemon Squeezy for international, keygen.sh for license fulfilment, plus six donation rails on /support. |
| [`no-subscriptions-anywhere`](./monetisation/no-subscriptions-anywhere.md) | active | Hard constraint: every external service used across the oriz family must work indefinitely on its free tier. Subscription-walled providers are excluded at selection time. |
| [`one-subscription-unlocks-all`](./monetisation/one-subscription-unlocks-all.md) | active | Single Razorpay-driven subscription stored in Firestore as users/{uid}/subscription unlocks paid features across the entire family — sites and extensions. |
| [`per-surface-recommendations`](./monetisation/per-surface-recommendations.md) | active | Per-distribution-surface picks: which payment rail to use for Play Store AABs, Microsoft Store MSIX, Chrome/Firefox/Edge extensions, web PWAs, books, blog, newsletter. Derived from playbook-no-card-rails.md; this is the cookbook view. |
| [`playbook-no-card-rails`](./monetisation/playbook-no-card-rails.md) | active | Master matrix of every viable monetisation rail for the oriz family in 2026, filtered by the hard no-card-on-file rule. Each row marks card-required Y/N (with source URL), revenue cut, region, setup friction, and best-fit surface. Replac... |
| [`razorpay-as-primary-billing`](./monetisation/razorpay-as-primary-billing.md) | active | Razorpay is the primary billing/checkout provider; Stripe, Lemon Squeezy, and Paddle are documented fallbacks if Razorpay rejects the merchant or dies. |

### Policy (15)

| File | Status | Description |
|---|---|---|
| [`age-gating`](./policy/age-gating.md) | active | Adult-content sections across the family require an 18+ cookie attestation with 365-day expiry. Annual jurisdictional review. |
| [`archive-allowlist`](./policy/archive-allowlist.md) | active | Audit-trail allowlist of every chirag127 repo that any archive script (or any future cleanup automation) MUST refuse to touch. Built from .gitmodules + npm publications + manual hand-adds for load-bearing infrastructure. Read by scripts/... |
| [`commercial-use`](./policy/commercial-use.md) | active | What counts as commercial intent on Cloudflare Pages, GitHub Pages, and the apex; checkout flows happen on api.oriz.in or razorpay.com, never on landing pages. |
| [`data-canonical-store`](./policy/data-canonical-store.md) | active | The chirag127/oriz-me-data git repo is the authoritative store for lifestream events. Firestore / Turso / R2 are caches rebuilt from git on every deploy. |
| [`forked-extension-cws-rules`](./policy/forked-extension-cws-rules.md) | active | GPL-3.0 forks (e.g. DeArrow) can be re-shipped to the Chrome Web Store under our developer account if we (1) keep GPL-3.0, (2) state it's a modified version in listing + about, (3) use a different name + icons, (4) host our own backend O... |
| [`ingester-contract`](./policy/ingester-contract.md) | active | Every lifestream / data ingester satisfies six properties: idempotent, backfill-capable, 7-day auto-pause, status-reporting, bounded execution, no inline secrets. |
| [`journal-not-public`](./policy/journal-not-public.md) | active | me.oriz.in publishes only numeric aggregates from the journal — entry count, streak, monthly word count. The journal text itself stays auth-gated at journal.oriz.in. |
| [`monetisation-channel-matrix`](./policy/monetisation-channel-matrix.md) | active | Single canonical matrix mapping every publish/distribute channel in the oriz family to its allowed monetisation strategy. Locks where affiliate is allowed, where it is forbidden (organic-only channels, public-health apps), and where reve... |
| [`monetisation`](./policy/monetisation.md) | active | One AdSense application for the oriz.in apex; all subdomains inherit. No ad-slot divs in markup — ads inject at runtime over organic layout. |
| [`no-paid-tier`](./policy/no-paid-tier.md) | active | No service the family depends on may require a paid subscription or card on file. Free-tier walls fail closed gracefully. |
| [`privacy-policy-per-extension`](./policy/privacy-policy-per-extension.md) | active | Each Chrome extension has its own /privacy page tailored to its permissions. A family boilerplate at oriz.in/privacy-base supplies common content. |
| [`private-repos-excluded-from-mirror-cron`](./policy/private-repos-excluded-from-mirror-cron.md) | active | The .github/workflows/mirror-all.yml cron pushes every public repo from oriz-org + chirag127 to 6 mirror hosts. Private repos (oriz-org/secrets and any other isPrivate=true repo) are FILTERED OUT at discovery time via gh-list's isPrivate... |
| [`public-private-line`](./policy/public-private-line.md) | active | Four tiers govern every piece of content across the family: public, age-gated-18, aggregates-only, private. Inner-life metrics surface only as weekly aggregates. |
| [`secrets-handling`](./policy/secrets-handling.md) | active | Every secret comes from envpact. If a secret is ever pasted into chat, treat it as compromised: revoke, rotate, re-store, redeploy. |
| [`tweeks-personal-use-only`](./policy/tweeks-personal-use-only.md) | active | Tweeks (chromewebstore.google.com/detail/fmkancpjcacjodknfjcpmgkccbhedkhc) is a closed-source proprietary commercial Chrome extension by NextByte (YC-backed, tweeks.io). It has NO open-source license. Personal modification + loading as a... |

### Pricing (1)

| File | Status | Description |
|---|---|---|
| [`three-tier-free-pro-max`](./monetisation/pricing/three-tier-free-pro-max.md) | active | Replaces the two-tier (Ad-free + Pro) decision the same day. User mandate (2026-06-22): 3 tiers (Free / Pro / Max), agent decides the feature split, manual work is MINIMUM, everything controlled from a single package (`@chirag127/astro-b... |

### Process (6)

| File | Status | Description |
|---|---|---|
| [`4-level-hierarchy-for-big-dirs`](./decisions/process/4-level-hierarchy-for-big-dirs.md) | active | services/, decisions/, glossary/ adopt 4-level paths. Other dirs stay flat at 3 levels until they outgrow ~15 files. |
| [`code-quality-stack`](./decisions/process/code-quality-stack.md) | active | Layered code-quality stack across the family. Dependabot for deps, biome local + CI, CodeRabbit reviewing PRs, Sonarcloud SAST on merge. All free for OSS. |
| [`okf-as-canonical-format`](./decisions/process/okf-as-canonical-format.md) | active | Adopt the Open Knowledge Format v0.1 for every concept file in the oriz family knowledge bundles, master + per-site. |
| [`one-branch-only-rule`](./decisions/process/one-branch-only-rule.md) | active | Every repo in the family — master, sites, packages, extensions — uses only the main branch. No feature, fix, or chore branches anywhere. |
| [`per-repo-ci-workflows`](./decisions/process/per-repo-ci-workflows.md) | active | REVERSES earlier master-matrix-only CI. Each site/extension/package repo has its own .github/workflows/ci.yml running lint+typecheck+build on PR. |
| [`v2-design-implementation`](./decisions/process/v2-design-implementation.md) | active | v2 design implementations have been written, committed, and pushed for all 11 current sites — closing the long-standing 'broken cross-link' problem in the design briefs. |

### Security (12)

| File | Status | Description |
|---|---|---|
| [`anti-bot-defense-in-depth`](./security/anti-bot-defense-in-depth.md) | active | Locked 2026-06-20: three layers of bot defense, each at a different stage. (1) Cloudflare WAF + Bot Fight Mode at the edge blocks known-bad before it reaches a Worker. (2) Turnstile at the form-submit boundary gates contact + auth flows.... |
| [`captcha-turnstile-plus-hcaptcha`](./security/captcha-turnstile-plus-hcaptcha.md) | active | Cloudflare Turnstile is the family's primary CAPTCHA; hCaptcha is the auto-detected regional fallback. Single <Captcha> component in oriz-kit performs the swap transparently. |
| [`consent-management-multi-category`](./security/consent-management-multi-category.md) | active | Locks the family's multi-category consent management. Klaro defines 5 categories (necessary / analytics / marketing / functional / social) with a per-service map. EU/UK shows banner default-DENIED; US/CA shows banner default-ACCEPTED wit... |
| [`cookie-banner-policy`](./security/cookie-banner-policy.md) | active | Default posture is NO cookie banner — Cloudflare Web Analytics is cookie-less and GDPR-safe. Klaro is lazy-loaded ONLY when (a) a page loads a cookie-issuing tracker (GA4 / PostHog identified) AND (b) the visitor is in EU/UK per CF-IPCou... |
| [`domain-registrar-exception-spaceship`](./security/domain-registrar-exception-spaceship.md) | active | oriz.in is registered at Spaceship with a card-on-file for auto-renewal. This is a deliberate, documented exception to the no-card-on-file rule. Reason: .in TLD renewals at every registrar require either a card-on-file (auto-renew) or an... |
| [`env-and-secrets-single-source`](./security/env-and-secrets-single-source.md) | active | Two-track lock for managing env vars across the family. Track A: PUBLIC .env.example files synced from master templates/.env.example to every repo (no real values). Track B: PRIVATE GitHub Actions secrets set ONCE at chirag127 org level ... |
| [`env-single-source-auto-push`](./security/env-single-source-auto-push.md) | active | User mandate 2026-06-22 evening: minimum manual env-var setting. Master `c:/D/oriz/.env` is the single source of truth for every env var used by every app, package, API, extension, CLI, MCP server, skill, book pipeline, and CI workflow i... |
| [`env-three-file-split`](./security/env-three-file-split.md) | active | Single key namespace, three value files split by NODE_ENV. .env holds shared defaults + public keys; .env.development holds TEST values (Razorpay test keys, dev URLs); .env.production holds LIVE values (Razorpay live keys, prod URLs at o... |
| [`multi-provider-auth`](./security/multi-provider-auth.md) | active | The family's Firebase Auth project enables 6 sign-in providers: Email link, Google, GitHub, Anonymous, Microsoft (NEW), Passkeys/WebAuthn (NEW). Apple is deferred until the iOS app ships. |
| [`secrets-management-doppler`](./security/secrets-management-doppler.md) | active | Adopt Doppler as the single place every family secret is written, rotated, and audited. GitHub Secrets, Cloudflare Worker secrets, and Firebase config are downstream mirrors synced from Doppler. |
| [`security-headers-strategy`](./security/security-headers-strategy.md) | active | Every site ships a strict CSP / HSTS preload / Permissions-Policy preset via Cloudflare _headers, sourced from @chirag127/oriz-kit. Every PR is audited by both securityheaders.com and Mozilla Observatory; PR fails if score drops below A. |
| [`sops-plus-doppler-hybrid`](./security/sops-plus-doppler-hybrid.md) | active | Sops+age remains the source of truth for the family's 65-key .env (preserves 134 lines of section comments + ordering that Doppler's flat KV model would destroy). Doppler is added as a parallel runtime-sync layer for CI fan-out only: a l... |

### Tooling (1)

| File | Status | Description |
|---|---|---|

## Runbooks (65 total)

### Free Hosting Providers (9)

| File | Description |
|---|---|
| [`azure-student`](./runbooks/free-hosting-providers/azure-student.md) | User has an active Azure for Students subscription (offer code MS-AZR-0170P). $100/yr credit, renewable while enrolled, NO credit card required at signup (student-verified instead). Documents what's free, what's USEFUL for the family, wh... |
| [`databases`](./runbooks/free-hosting-providers/databases.md) | Provider-by-provider free-tier numbers for relational + document + edge-SQL + KV databases. Family is heavy on Firebase Firestore (default), Cloudflare D1 + KV (edge), and Neon (Postgres when we need SQL). PlanetScale + Xata dropped afte... |
| [`image-cdn`](./runbooks/free-hosting-providers/image-cdn.md) | 4-host replicate-everywhere image strategy: Cloudinary + ImageKit + imgbb + GitHub Releases. Image compressed once at upload (optimisation only — original never stored), then replicated across all 4 hosts. Client tries each in order; fir... |
| [`monitoring`](./runbooks/free-hosting-providers/monitoring.md) | Provider-by-provider free-tier numbers for uptime monitoring, error tracking, logs, and traces. Better Stack is the commercial-OK winner (UptimeRobot's free is personal/OSS only since Oct 2024). Sentry Developer + Axiom Personal cover er... |
| [`object-storage`](./runbooks/free-hosting-providers/object-storage.md) | Provider-by-provider free-tier numbers for S3-compatible object storage and IPFS pinning. Cloudflare R2 has the best zero-egress economics but REQUIRES a card to activate the R2 service. Backblaze B2 is the pure no-card winner. Storj cov... |
| [`queues-pubsub`](./runbooks/free-hosting-providers/queues-pubsub.md) | Provider-by-provider free-tier numbers for async message queues, scheduled jobs, pub-sub, and durable execution. Cloudflare Queues went GA in Workers Free on 2026-02-04 — biggest 2026 unlock. Upstash QStash + Inngest are the durable-job ... |
| [`serverless-functions`](./runbooks/free-hosting-providers/serverless-functions.md) | Provider-by-provider free-tier numbers for serverless functions and edge runtimes, adversarially verified against official pricing pages on 2026-06-23. The family's 4-rail fallback chain is CF Workers → Deno Deploy → AWS Lambda → Render.... |
| [`static-sites`](./runbooks/free-hosting-providers/static-sites.md) | Provider-by-provider free-tier numbers for static site hosting. Cloudflare Pages stays the family primary; GitHub Pages is the mirror. Verdict column distinguishes KEEP / EVALUATE / DROP for a 50+ project fleet under the no-card-on-file ... |
| [`web-services`](./runbooks/free-hosting-providers/web-services.md) | Provider-by-provider free-tier numbers for hosting always-on or sleep-tolerant web services and containers. Most providers in this category collapsed their free tiers in 2024–2026; the survivors are Render (with sleep) and Koyeb (1 nano). |

### Hosting (7)

| File | Description |
|---|---|
| [`cf-dns-add-api-subdomain`](./runbooks/platform/cf-dns-add-api-subdomain.md) | (no description) |
| [`cf-dns-audit-2026-06-23`](./runbooks/platform/cf-dns-audit-2026-06-23.md) | (no description) |
| [`cf-pages-branch-deploys`](./runbooks/platform/cf-pages-branch-deploys.md) | CF Pages caps free tier at 100 projects per account. Family has 26 apps\ |
| [`codeberg-mirror-2026-06-23`](./runbooks/platform/codeberg-mirror-2026-06-23.md) | Set up Codeberg.org as a passive read-only mirror for the 60+ oriz family |
| [`git-upstream-merge-private-fork`](./runbooks/platform/git-upstream-merge-private-fork.md) | How to clone a public Chrome extension to a private organization repository |
| [`mirror-all-hosts-setup`](./runbooks/platform/mirror-all-hosts-setup.md) | One-time setup runbook to configure the 6-host automatic git mirror |
| [`mirror-cron-prep`](./runbooks/platform/mirror-cron-prep.md) | Pre-flight checklist for the Friday 03:30 IST 4-host git mirror cron at `.github/workflows/mirror-all.yml`. Generate 4 host tokens with write+create-repo scope, pre-create 51 empty mirror repos on each host, store all tokens at chirag127... |

### Operations (22)

| File | Description |
|---|---|
| [`add-new-decision`](./runbooks/workflow/add-new-decision.md) | The OKF self-update workflow. When the user makes an architectural / |
| [`add-new-extension`](./runbooks/workflow/add-new-extension.md) | Add a new extension repo as a submodule under extensions/, set up the |
| [`add-new-site-to-family`](./runbooks/workflow/add-new-site-to-family.md) | Add a new oriz-<name> repo as a submodule under sites/, register it in |
| [`add-package-to-catalog`](./runbooks/workflow/add-package-to-catalog.md) | Auto-discovery means there's almost nothing to do \u2014 publish the\ |
| [`apply-per-site-ci`](./runbooks/workflow/apply-per-site-ci.md) | Copy the templates/per-site-ci/ scaffold into each of the 11 site submodules |
| [`build-distributable`](./runbooks/workflow/build-distributable.md) | One command per app emits all distributables \u2014 PWA on Cloudflare\ |
| [`bump-submodule-pointer`](./runbooks/workflow/bump-submodule-pointer.md) | After landing a feature inside a submodule, bump the master repo''s |
| [`clean-install`](./runbooks/workflow/clean-install.md) | One git clone --recursive + one pnpm install loop and the whole family |
| [`dependabot-notification-tuning`](./runbooks/workflow/dependabot-notification-tuning.md) | (no description) |
| [`env-management`](./runbooks/workflow/env-management.md) | Plain-English runbook for managing the single env source `c:/D/oriz/.env`.\ |
| [`github-apps-audit-2026-06-22`](./runbooks/workflow/github-apps-audit-2026-06-22.md) | One-shot audit of every GitHub App installed on the chirag127 account,\ |
| [`install-and-bootstrap`](./runbooks/workflow/install-and-bootstrap.md) | The chirag127/oriz family is one umbrella git repo that submodules every |
| [`install-github-apps`](./runbooks/workflow/install-github-apps.md) | GitHub Apps cannot be installed via API (security policy \u2014 install\ |
| [`lifestream-auto-sources-setup`](./runbooks/workflow/lifestream-auto-sources-setup.md) | One-shot deploy steps to take @chirag127/oriz-lifestream from scaffold |
| [`migrate-ci-platform`](./runbooks/workflow/migrate-ci-platform.md) | Plan-B runbook for the day GitHub Actions becomes unusable (account |
| [`migrate-okf-to-new-version`](./runbooks/workflow/migrate-okf-to-new-version.md) | Run when the OKF spec moves beyond v0.1. Read migration notes, update |
| [`publish-userscript-to-greasyfork`](./runbooks/workflow/publish-userscript-to-greasyfork.md) | How to publish a userscript from oriz-org/userscripts to greasyfork.org. Greasy Fork has NO upload API — first version requires manual paste in the in-browser editor. After the initial paste, register a webhook so subsequent git push → a... |
| [`publish-vscode-extension-to-marketplace`](./runbooks/workflow/publish-vscode-extension-to-marketplace.md) | How to ship an oriz-org/-vsc-ext repo to the VS Code Marketplace + Open VSX. One-time: create a Microsoft Publisher under your account, generate an Azure DevOps PAT with Marketplace scope, store it. Per-release: bump version, vsce packag... |
| [`rename-repo`](./runbooks/workflow/rename-repo.md) | Step-by-step procedure to rename a chirag127/oriz* repo to its correct |
| [`scaffold-a-new-site`](./runbooks/workflow/scaffold-a-new-site.md) | Step-by-step to add a new Astro site to the family in <10 minutes. Clones |
| [`sync-env-example-to-all-repos`](./runbooks/workflow/sync-env-example-to-all-repos.md) | Step-by-step procedure for adding / removing / renaming a family-wide |
| [`visual-audit-2026-06-22`](./runbooks/workflow/visual-audit-2026-06-22.md) | (no description) |

### Scaffolding (1)

#### sites (1)

| File | Description |
|---|---|
| [`scaffold-tool-site`](./runbooks/scaffolding/sites/scaffold-tool-site.md) | Bootstrap any of the 15 tool sites from stub README to deployable Astro app: package.json, astro.config, tsconfig, tailwind, biome, deploy.yml, Cloudflare Pages connect. |

### Security (10)

| File | Description |
|---|---|
| [`auth-setup`](./runbooks/security/auth-setup.md) | Every login command and dashboard URL needed to publish the @chirag127 |
| [`auth-signin-still-showing-2026-06-24`](./runbooks/security/auth-signin-still-showing-2026-06-24.md) | Diagnostic + fix runbook for the cross-domain auth-state-not-reflected |
| [`backup-metadata-to-b2`](./runbooks/security/backup-metadata-to-b2.md) | Single .github/workflows/backup-metadata-b2.yml in oriz-org/workspace\ |
| [`npm-publish-token-setup`](./runbooks/security/npm-publish-token-setup.md) | How to generate an npm Granular Access Token with publish + unpublish |
| [`razorpay-end-to-end-setup`](./runbooks/security/razorpay-end-to-end-setup.md) | Step-by-step checklist for wiring Razorpay subscriptions into the oriz |
| [`razorpay-paddle-subscriptions-setup`](./runbooks/security/razorpay-paddle-subscriptions-setup.md) | Step-by-step guide to set up Razorpay Subscriptions (India INR rail)\ |
| [`restic-backup-setup`](./runbooks/security/restic-backup-setup.md) | One-page setup for the family''s weekly encrypted backup: install restic |
| [`rotate-leaked-secret`](./runbooks/security/rotate-leaked-secret.md) | Run when a secret is suspected leaked, has entered any chat transcript, |
| [`set-github-org-level-secrets`](./runbooks/security/set-github-org-level-secrets.md) | Pull a secret value from Doppler, push it to the chirag127-org-level |

#### credentials (1)

| File | Description |
|---|---|
| [`rotate-cf-and-npm-tokens`](./runbooks/security/credentials/rotate-cf-and-npm-tokens.md) | End-to-end: rotate CLOUDFLARE_API_TOKEN and NPM_TOKEN, choose between least-privilege and max-permission scopes, store at chirag127 org level via gh secret set --org. |

## Services (218 total)

### A11Y (3)

| File | Description |
|---|---|
| [`axe-core`](./services/monitoring/a11y/axe-core.md) | Industry-standard a11y rule engine, run via @axe-core/playwright in CI. Static-rule WCAG checks on every PR. Free, OSS. |
| [`lighthouse-ci`](./services/monitoring/a11y/lighthouse-ci.md) | Lighthouse score + a11y + perf budgets enforced per PR. Free GitHub App posts the score as a PR comment. |
| [`pa11y`](./services/monitoring/a11y/pa11y.md) | Dynamic a11y test runner — different ruleset from axe (HTML_CodeSniffer + axe). Free CLI in PR CI. |

### Ads (2)

| File | Description |
|---|---|
| [`ezoic`](./services/business/ads/ezoic.md) | Fallback ad provider — no minimum traffic. |
| [`mediavine`](./services/business/ads/mediavine.md) | Fallback ad provider — higher RPM but requires 50K sessions/month. |

### Ai (3)

| File | Description |
|---|---|
| [`cloudflare-workers-ai`](./services/business/ai/cloudflare-workers-ai.md) | Native AI inference inside the umbrella Hono Worker — 10K neurons / day free, zero-egress from api.oriz.in. Pairs with browser-side Puter.js. |
| [`openrouter`](./services/business/ai/openrouter.md) | LLM API gateway — DeepSeek / Llama / Moonshot free models. Rejected 2026-06-20: we use Puter.js exclusively; OpenRouter is mentioned only because Puter.js mirrors its model IDs. |
| [`puter-js`](./services/business/ai/puter-js.md) | Browser-side AI inference — user-pays model, free unlimited from our side. |

### Analytics (5)

| File | Description |
|---|---|
| [`cloudflare-web-analytics`](./services/monitoring/monitoring/analytics/cloudflare-web-analytics.md) | Privacy-friendly pageview analytics — free, no cookie banner needed. |
| [`google-analytics`](./services/monitoring/monitoring/analytics/google-analytics.md) | Marketing-funnel analytics — acquisition / engagement / conversion against advertiser-standard definitions. Free, no card. |
| [`microsoft-clarity`](./services/monitoring/monitoring/analytics/microsoft-clarity.md) | Session recording + heatmaps — no traffic limits, free forever. |
| [`posthog`](./services/monitoring/monitoring/analytics/posthog.md) | Product analytics + feature flags + A/B — 1M events/month free. |
| [`utm-tracking`](./services/monitoring/monitoring/analytics/utm-tracking.md) | Marketing attribution via UTM query parameters on every outbound link. Captured by GA4 + PostHog. Free, no service, no extra tools. |

### Auth (8)

| File | Description |
|---|---|
| [`app-check-firebase`](./services/business/auth/app-check-firebase.md) | Bot defense layer for Firestore — required by every security rule in the family. |
| [`clerk`](./services/business/auth/clerk.md) | Fallback auth — 10K MAU free. |
| [`firebase-auth`](./services/business/auth/firebase-auth.md) | The 6 sign-in providers wired into the family's single Firebase Auth project — Email link, Google, GitHub, Anonymous, Microsoft, Passkeys. Apple deferred until the iOS app ships. |
| [`firebase-spark`](./services/business/auth/firebase-spark.md) | Auth + Firestore on the free Spark plan — never upgraded to Blaze. |
| [`microsoft-sign-in`](./services/business/auth/microsoft-sign-in.md) | Microsoft / Entra ID OAuth provider wired into Firebase Auth — free, unlimited, no card. Aligns with the family's Azure-for-Students stack. |
| [`passkeys`](./services/business/auth/passkeys.md) | Passwordless WebAuthn sign-in via Firebase Auth's passkey integration (with @simplewebauthn/server escape hatch). Free, unlimited, no card. |
| [`recaptcha-enterprise`](./services/business/auth/recaptcha-enterprise.md) | Bot-defense assessments wired into Firebase App Check — 10K/mo free, but billing-account-linked. |
| [`supabase`](./services/business/auth/supabase.md) | Fallback Auth + Postgres — 500 MB DB free. |

### Cdn (1)

| File | Description |
|---|---|
| [`jsdelivr`](./services/infra/cdn/jsdelivr.md) | npm + GitHub package CDN. Browser-side imports of @chirag127/oriz-kit served at cdn.jsdelivr.net. Free, unlimited, no card. |

### Code Embed (3)

| File | Description |
|---|---|
| [`codepen`](./services/code/code-embed/codepen.md) | CSS-heavy front-end demos embedded via script. Free unlimited public pens, no card. |
| [`github-gists`](./services/code/code-embed/github-gists.md) | Static code snippets embedded via script. Free unlimited public gists, no card. |
| [`stackblitz`](./services/code/code-embed/stackblitz.md) | Full-stack browser sandboxes — embedded in oriz-blog-site posts via iframe. Free unlimited public projects, no card. |

### Code Quality (9)

| File | Description |
|---|---|
| [`codeclimate`](./services/code/code-quality/codeclimate.md) | Maintainability scoring — Code Climate's 'A through F' grade per file, free for public repos. Catches technical-debt patterns biome / Sonarcloud surface differently. |
| [`codecov`](./services/code/code-quality/codecov.md) | Coverage tracking for every PR — uploads LCOV from Vitest, posts coverage delta as a check, free unlimited for public repos. |
| [`coderabbit`](./services/code/code-quality/coderabbit.md) | AI code review on every PR. Free forever for OSS / public repos. Catches logic bugs and security smells biome misses. |
| [`deepsource`](./services/code/code-quality/deepsource.md) | Static analysis with autofix — JS/TS/Python/Go rule set, free unlimited for public repos. Catches issues with one-click PRs. |
| [`dependabot`](./services/code/code-quality/dependabot.md) | Automated dependency security updates. GitHub-native, free for all repos public + private, opens PRs when CVEs drop. |
| [`github-insights`](./services/code/code-quality/github-insights.md) | Native repo insights — contributors, commits-over-time, code frequency, dependents, traffic. Free, native to every public repo, auto-tracked. Used as a code-stats source for the family /stats page. |
| [`lines-of-code-badge`](./services/code/code-quality/lines-of-code-badge.md) | Auto-generated `<!-- TODO: broken link, was [![Lines of Code](badge.svg) -->]` badge in every family repo's README. GitHub Action runs on push, recomputes line count, commits the badge SVG. Free, OSS, auto-tracked. |
| [`sonarcloud`](./services/code/code-quality/sonarcloud.md) | Deeper static analysis — SAST, code smells, duplication, complexity, coverage. Free for OSS. Catches issues biome can't. |
| [`tokei`](./services/code/code-quality/tokei.md) | Rust CLI that counts lines of code by language — files, lines, blanks, comments, code. Run in CI; output JSON → publish to family /stats page. OSS, no card. |

### Comments (1)

| File | Description |
|---|---|
| [`giscus`](./services/business/comments/giscus.md) | GitHub-Discussions-backed comments — free forever, no card. Click-to-load privacy posture, light/dark theme aware. |

### Compute (3)

| File | Description |
|---|---|
| [`cloudflare-r2`](./services/infra/compute/cloudflare-r2.md) | S3-compatible object storage with no egress fees — 10 GB free. |
| [`cloudflare-workers`](./services/infra/compute/cloudflare-workers.md) | Edge compute for the Hono Worker at api.oriz.in — fails-closed at the free quota. |
| [`github-actions`](./services/infra/compute/github-actions.md) | Build-time cron + CI runner — free for public repos, the family's scheduled-job substrate. |

### Cron (2)

| File | Description |
|---|---|
| [`cloudflare-cron-triggers`](./services/business/cron/cloudflare-cron-triggers.md) | In-Worker scheduled jobs — sub-second invocation, free unlimited, runs in the same runtime as api.oriz.in. |
| [`github-actions-schedule`](./services/business/cron/github-actions-schedule.md) | Build- and publish-shaped scheduled jobs on GitHub Actions — free unlimited minutes for public repos (the family runs 100% public). |

### Data Api (2)

| File | Description |
|---|---|
| [`alpha-vantage`](./services/business/data-api/alpha-vantage.md) | Free finance / market-data API. 25 requests/day + 5/minute on the free tier, no card required. API key needed (free signup). Locked as the family's market-data source for oriz-finance and any future stock / forex / crypto surface. |
| [`open-meteo`](./services/business/data-api/open-meteo.md) | Free unlimited weather API. No auth, no API key, no card. Documented as the family's locked weather data source for any future site that needs forecast / current-conditions / historical weather. |

### Database (2)

| File | Description |
|---|---|
| [`neon-postgres`](./services/data/database/neon-postgres.md) | Serverless Postgres for relational workloads — free tier confirmed no card, scale-to-zero, branching for previews. |
| [`turso`](./services/data/database/turso.md) | Read-only warm cache for lifestream events — replicas at the edge, free tier. |

### Dev Tools (2)

| File | Description |
|---|---|
| [`cloudflare-tunnel`](./services/infra/dev-tools/cloudflare-tunnel.md) | Free Cloudflare-native local-to-public tunnel. Exposes localhost on a persistent *.oriz.in hostname for webhook testing during development. No card, no quota cliff, no anonymous-session TTL. |
| [`wrangler`](./services/infra/dev-tools/wrangler.md) | Cloudflare's official CLI for Workers / Pages / KV / R2 / D1 / Queues development and deployment. Local mode runs in workerd; remote mode runs against real Cloudflare infrastructure. Free as part of the Cloudflare account. |

### Domain (4)

| File | Description |
|---|---|
| [`cloudflare-dns`](./services/infra/domain/cloudflare-dns.md) | DNS host for oriz.in and every subdomain — free, fast, and the same dashboard as everything else. |
| [`cloudflare-email-routing`](./services/infra/domain/cloudflare-email-routing.md) | Free email forwarder — *@oriz.in, *@oriz.me, and every extension subdomain forward into a single Gmail inbox. |
| [`cloudflare-registrar`](./services/infra/domain/cloudflare-registrar.md) | Domain registrar at wholesale cost — no markup, free WHOIS privacy. |
| [`spaceship`](./services/infra/domain/spaceship.md) | Existing domain registrar — chirag127 holds family domains here. NS records delegate to Cloudflare DNS; email forwards via Cloudflare Email Routing → Gmail. |

### Email (4)

| File | Description |
|---|---|
| [`buttondown`](./services/business/email/buttondown.md) | Developer-friendly newsletter — Markdown native, API-first, 100 subscribers free. Used as the technical-blog digest sender. |
| [`email-octopus`](./services/business/email/email-octopus.md) | Marketing email + newsletter — 2.5K subscribers / 10K emails per month free. Used for general / marketing audiences; Buttondown handles the technical-blog digest. |
| [`mailerlite`](./services/business/email/mailerlite.md) | Fallback marketing email / newsletter — 1K subs free. |
| [`resend`](./services/business/email/resend.md) | Transactional email API — 3K/month free, isolated behind @chirag127/email-send. |

### Extension Store (5)

| File | Description |
|---|---|
| [`chrome-web-store`](./services/business/extension-store/chrome-web-store.md) | Browser-extension distribution channel for Chrome / Edge / Brave / Opera / Vivaldi / Arc / Zen. $5 one-time developer fee (sunk cost — NOT a subscription, still meets free-forever rule). chrome-webstore-upload via GitHub Actions for CI a... |
| [`edge-add-ons`](./services/business/extension-store/edge-add-ons.md) | Microsoft's add-on store via Partner Center. Free unlimited, no developer fee, no card. CI flow uses the Edge Add-ons partner-center API. |
| [`firefox-add-ons`](./services/business/extension-store/firefox-add-ons.md) | Mozilla's add-on store. Free unlimited submissions, no registration fee, no card. CI flow uses web-ext + AMO submit API. |
| [`open-vsx-registry`](./services/business/extension-store/open-vsx-registry.md) | Eclipse Foundation's vendor-neutral VS Code extension registry. Used by VSCodium, Cursor, Theia, Gitpod, code-server. Free OSS, no card. Publish via ovsx. |
| [`vs-code-marketplace`](./services/business/extension-store/vs-code-marketplace.md) | Microsoft's official VS Code extension marketplace. Free unlimited, no developer fee. Publish via vsce. |

### Forms (4)

| File | Description |
|---|---|
| [`formspree`](./services/business/forms/formspree.md) | Fallback contact-form backend — 50 submissions/month free. |
| [`static-forms`](./services/business/forms/static-forms.md) | Form-submission backend — fallback to Web3Forms. Free unlimited submissions. No card. Different vendor + edge so a Web3Forms outage / quota cliff never takes contact forms down. |
| [`tally`](./services/business/forms/tally.md) | Rich form builder — surveys, waitlists, payment collection. Unlimited forms + submissions free. |
| [`web3forms`](./services/business/forms/web3forms.md) | Browser-only contact form backend — domain-bound access key, no server, free unlimited. |

### Hosting (11)

| File | Description |
|---|---|
| [`azure-devops-mirror`](./services/infra/hosting/azure-devops-mirror.md) | Azure DevOps Repos is mirror host #5. Microsoft-managed, unlimited private\ |
| [`bitbucket-mirror`](./services/infra/hosting/bitbucket-mirror.md) | Bitbucket Cloud (Atlassian) is mirror host #3. Free: unlimited private\ |
| [`cloudflare-pages`](./services/infra/hosting/cloudflare-pages.md) | Primary static host for every oriz site — unlimited bandwidth, free forever. |
| [`codeberg-mirror`](./services/infra/hosting/codeberg-mirror.md) | Codeberg.org (Forgejo) is mirror host #2. FOSS-mission non-profit git\ |
| [`firebase-hosting`](./services/infra/hosting/firebase-hosting.md) | REJECTED — Spark daily bandwidth cap shifted to 360 MB/day shared, too tight. |
| [`gitflic-mirror`](./services/infra/hosting/gitflic-mirror.md) | GitFlic.ru is mirror host #4. Russian-hosted git platform with free |
| [`github-pages`](./services/infra/hosting/github-pages.md) | Survival fallback static host — the second-account-equivalent every oriz site mirrors to. |
| [`gitlab-mirror`](./services/infra/hosting/gitlab-mirror.md) | GitLab.com is mirror host #1. Every repo in oriz-org and chirag127 is\ |
| [`netlify`](./services/infra/hosting/netlify.md) | Fallback static host — free starter tier. |
| [`vercel`](./services/infra/hosting/vercel.md) | Fallback static host — free hobby tier. |

### I18N (2)

| File | Description |
|---|---|
| [`tolgee`](./services/business/i18n/tolgee.md) | REJECTED — i18n deferred until a site genuinely needs it; English-only family for now. |
| [`weblate-hosted-libre`](./services/business/i18n/weblate-hosted-libre.md) | Web-based translation management platform — free for libre / open-source projects. Picked as the family's i18n tool for if/when sites or extensions add non-English audiences. |

### Image Cdn (3)

| File | Description |
|---|---|
| [`cloudflare-images`](./services/media/image-cdn/cloudflare-images.md) | Primary image CDN — first link in the 3-tier fallback chain. Free tier shipped with Cloudflare Pages, no card. |
| [`imagekit`](./services/media/image-cdn/imagekit.md) | Final link in the 3-tier image-CDN fallback chain — 20 GB/mo bandwidth + DAM features, no card. |
| [`wsrv-nl`](./services/media/image-cdn/wsrv-nl.md) | Public URL-transform image proxy — second link in the 3-tier fallback chain. No signup, no auth, no card. |

### Image Host (4)

| File | Description |
|---|---|
| [`github-user-content`](./services/media/image-host/github-user-content.md) | Tier 4 image origin — push images to a dedicated `assets` branch of any family repo and hot-link from raw.githubusercontent.com. Free unlimited; rare-use tier for > 25 MB assets and large animated GIFs. |
| [`imgbb`](./services/media/image-host/imgbb.md) | Tier 2 image origin — free unlimited image hosting + REST upload API, no card. |
| [`imgur`](./services/media/image-host/imgur.md) | Tier 3 image origin — free unlimited image hosting + REST upload API, no card. Mirror of Tier 2 ImgBB for hot-link backup. |
| [`repo-hosted-cf-pages`](./services/media/image-host/repo-hosted-cf-pages.md) | Tier 1 image origin — static image files committed to each site's repo, served from Cloudflare Pages alongside the rest of the site. |

### Legal (1)

| File | Description |
|---|---|
| [`privacy-page`](./services/business/legal/privacy-page.md) | Self-built family-wide privacy page hosted on oriz.in. Single canonical /privacy URL every site, extension, and CLI references with optional per-surface addendum. Free — runs on existing Cloudflare Pages, no third-party tool, no card. |

### Monitoring (7)

| File | Description |
|---|---|
| [`better-stack-logs`](./services/monitoring/monitoring/better-stack-logs.md) | Log aggregation + 30-day retention + searchable + alertable. 3 GB/mo free. Same Better Stack account as the family's status page + uptime monitors — three products, one account. |
| [`better-stack`](./services/monitoring/monitoring/better-stack.md) | Uptime monitoring + status page — 10 monitors free. |
| [`cloudflare-workers-tail`](./services/monitoring/monitoring/cloudflare-workers-tail.md) | Live tail of Worker console output via wrangler tail. Free, included with Cloudflare Workers. Sub-100ms request → terminal. ~5 min retention (WebSocket session) — for active debugging only. |
| [`glitchtip`](./services/monitoring/monitoring/glitchtip.md) | Error tracking — Sentry SDK compatible, 1K events/month free, self-hostable. Rejected 2026-06-20 in favour of Sentry. |
| [`healthchecks-io`](./services/monitoring/monitoring/healthchecks-io.md) | Heartbeat / dead-man's-switch monitoring for ingesters — 20 checks free. |
| [`instatus`](./services/monitoring/monitoring/instatus.md) | Redundant status page at status-backup.oriz.in — kicks in if Better Stack itself is down. Free 5 components / 25K subscribers, no card. |
| [`sentry`](./services/monitoring/monitoring/sentry.md) | Primary error tracking across the family — best-in-class integrations. 5K events/month + env-var per-site toggle to stay under quota. |

### Payment (12)

| File | Description |
|---|---|
| [`buymeacoffee`](./services/business/payment/buymeacoffee.md) | Creator donations — 5% platform fee, no monthly subscription. Sits alongside Ko-fi for donor choice. |
| [`crypto-bitcoinaddr`](./services/business/payment/crypto-bitcoinaddr.md) | Plain crypto wallet addresses for tip-style donations — no KYC, tax-reportable. |
| [`github-sponsors`](./services/business/payment/github-sponsors.md) | GitHub-native developer donations — recurring + one-off, zero platform fees. |
| [`keygen-sh`](./services/business/payment/keygen-sh.md) | License-key fulfilment service — issues + validates keys for VS Code extensions, browser extensions premium tier, npm SDK paid tier. |
| [`ko-fi`](./services/business/payment/ko-fi.md) | Creator donations — 0% platform fee on free tier; PayPal or Stripe payout. |
| [`lemon-squeezy`](./services/business/payment/lemon-squeezy.md) | Merchant-of-record checkout for non-Indian buyers — auto VAT/GST, card + Apple Pay + Google Pay. |
| [`liberapay`](./services/business/payment/liberapay.md) | Recurring-donation-only platform — weekly/monthly donations, 0% platform fee, OSS, no card. |
| [`opencollective`](./services/business/payment/opencollective.md) | Transparent fund accounting for OSS / community projects — every transaction public, fiscal-host model, free for OSS, 5% platform fee for non-OSS. |
| [`paypal-me`](./services/business/payment/paypal-me.md) | Personal PayPal payment-link — friends-and-family free, goods-and-services percent fee. |
| [`polar-sh`](./services/business/payment/polar-sh.md) | OSS-friendly checkout — Stripe-backed merchant-of-record for digital products + subscriptions + donations; lower fees than Lemon Squeezy. |
| [`razorpay`](./services/business/payment/razorpay.md) | India-first subscription provider — UPI, cards, netbanking, wallets, EMI, pay-later — webhook-driven entitlement. |
| [`upi-direct`](./services/business/payment/upi-direct.md) | Static UPI QR + handle for Indian-resident inbound — zero fees, instant settlement. |

### Perf (1)

| File | Description |
|---|---|
| [`vercel-speed-insights`](./services/monitoring/monitoring/perf/vercel-speed-insights.md) | Real-User Monitoring for Web Vitals across every site. Free tier on every site, no Vercel hosting required — works on Cloudflare Pages. |

### Productivity (2)

| File | Description |
|---|---|
| [`toggl-track`](./services/business/productivity/toggl-track.md) | REJECTED 2026-06-20 — manual time tracker. Walked back the same day it was adopted: violates the new auto-only-tracking rule. Wakatime stays as the sole time-tracking pick (auto via IDE plugin); non-coding time is intentionally NOT track... |
| [`wakatime`](./services/business/productivity/wakatime.md) | Free auto-tracking of coding time via IDE plugin. Captures language / project / file / branch breakdowns automatically. Free rolling-2-week history; recruiter-facing public dashboard at wakatime.com/@chirag127. REST API for future lifest... |

### Push (2)

| File | Description |
|---|---|
| [`fcm`](./services/business/push/fcm.md) | Web push transport — browser/PWA push notifications across the family. Free unlimited on Spark, no card. Knock layered on top for multi-channel orchestration. |
| [`knock`](./services/business/push/knock.md) | Multi-channel notification orchestration — in-app + email + SMS + web push from one workflow. Free 10K notifs/month, no card. Layered on top of FCM for delivery. |

### Pwa (1)

| File | Description |
|---|---|
| [`vite-pwa-astro`](./services/business/pwa/vite-pwa-astro.md) | Astro-native PWA integration. Generates manifest.webmanifest, service worker, install prompt, and offline cache at build. Free OSS, no backend, no card. |

### Queue (4)

| File | Description |
|---|---|
| [`cloudflare-queues`](./services/data/queue/cloudflare-queues.md) | Primary durable queue — native to Workers, 1M ops/month free, no card. |
| [`hookdeck`](./services/data/queue/hookdeck.md) | Webhook-ingress reliability layer in front of the Cloudflare Queues consumer. 50K events/mo free, no card. Same Hookdeck account documented in services/business/tooling/hookdeck.md — this file documents the queue-facing role. |
| [`inngest`](./services/data/queue/inngest.md) | Deferred queue alternative — durable workflows + step functions, generous free tier, no card. Held in reserve if Cloudflare Queues' simple model is outgrown. |
| [`upstash-qstash`](./services/data/queue/upstash-qstash.md) | Deferred queue alternative — HTTP message queue, 500 messages/day free, no card. Held in reserve if Cloudflare Queues hits a quota cliff. |

### Search (3)

| File | Description |
|---|---|
| [`algolia`](./services/data/search/algolia.md) | Hosted search index — used on the family's large-corpus sites (oriz-blog, oriz-books, oriz-book-lore). 1M docs + 10K searches/month free, no card. |
| [`orama-cloud`](./services/data/search/orama-cloud.md) | Modern in-browser vector + keyword search. Documented as a deferred future option to revisit if vector search becomes valuable. 10K docs / 5K searches/mo free, no card. |
| [`pagefind`](./services/data/search/pagefind.md) | Static-site search — runs at build, ships a tiny client, zero infra. |

### Secrets (3)

| File | Description |
|---|---|
| [`doppler`](./services/business/secrets/doppler.md) | Single source of truth for every family secret — syncs to GitHub Secrets, Cloudflare Workers, Firebase config, and local dev. Free 5 users, no card. |
| [`github-secrets`](./services/business/secrets/github-secrets.md) | Runtime secret store for GitHub Actions — written by Doppler, read by workflows. Free unlimited. |
| [`sops-age`](./services/business/secrets/sops-age.md) | Primary, file-based secrets encryption toolchain using age keys and Secrets OPerationS (SOPS) — actively maintained under CNCF. |

### Security (10)

| File | Description |
|---|---|
| [`age`](./services/business/security/age.md) | age (by FiloSottile) is the modern, minimal file-encryption tool the family uses as the master-key backend for SOPS. X25519 key exchange + ChaCha20-Poly1305 stream. Single private key file (~/.config/sops/age/keys.txt). No PGP keyring, n... |
| [`cloudflare-headers`](./services/business/security/cloudflare-headers.md) | Static security-headers config served directly from Cloudflare Pages via the `_headers` file. Free unlimited, ships in @chirag127/oriz-kit as a preset. |
| [`cloudflare-turnstile`](./services/business/security/cloudflare-turnstile.md) | Privacy-friendly CAPTCHA replacement, native to the Cloudflare stack. Free unlimited, no card. Family's primary captcha. |
| [`cloudflare-waf`](./services/business/security/cloudflare-waf.md) | Edge-layer Web Application Firewall + Bot Fight Mode — included in the Cloudflare free plan, no card. Blocks known bad IPs, common attack patterns, and obvious bot signatures before they reach the origin / Worker. |
| [`hcaptcha`](./services/business/security/hcaptcha.md) | Regional fallback CAPTCHA for users / networks where Cloudflare Turnstile is blocked. Free 1M verifications/month, no card. |
| [`hono-rate-limit`](./services/business/security/hono-rate-limit.md) | Custom rate-limit middleware in the Hono Worker, sliding-window per-IP via Cloudflare Workers KV. Free — runs on existing Worker + KV free tiers, no card. Fine-grained per-route throttling that complements the coarser zone-level WAF rate... |
| [`klaro`](./services/business/security/klaro.md) | OSS consent manager. Lazy-loaded ONLY for EU/UK visitors when a site loads a cookie-issuing tracker (GA4 / PostHog). Hosted from jsDelivr; free, no card. |
| [`mozilla-observatory`](./services/business/security/mozilla-observatory.md) | Comprehensive security auditor — headers + TLS + cookies + redirects. Free CLI run on every PR alongside securityheaders.com. |
| [`securityheaders-com`](./services/business/security/securityheaders-com.md) | External security-header auditor. Free API run in CI on every PR — fails the build if grade drops below A. |
| [`sops`](./services/business/security/sops.md) | SOPS is the family's git-native secrets encryption tool. Encrypts values inside structured files (YAML/JSON/ENV/INI) while keeping keys + structure visible for readable diffs. Originally Mozilla (2015), donated to CNCF Sandbox 2023, now ... |

### Seo (7)

| File | Description |
|---|---|
| [`astrojs-sitemap`](./services/monitoring/monitoring/seo/astrojs-sitemap.md) | Official Astro integration that generates sitemap.xml + robots.txt-compatible URL list at build time. Free, no card. |
| [`atom-feed`](./services/monitoring/monitoring/seo/atom-feed.md) | Atom 1.0 syndication feed published at /atom.xml on every site, alongside RSS 2.0 and JSON Feed. |
| [`bing-webmaster`](./services/monitoring/monitoring/seo/bing-webmaster.md) | Submit sitemaps to Bing, monitor index coverage, see search-query analytics, manage IndexNow keys. Free, no card. |
| [`google-search-console`](./services/monitoring/monitoring/seo/google-search-console.md) | Submit sitemaps to Google, monitor index coverage, see search-query analytics, get spam / manual-action notices. Free, no card. |
| [`indexnow`](./services/monitoring/monitoring/seo/indexnow.md) | Open API for instantly notifying Bing, Yandex, and partner search engines when a URL is added/changed/deleted. Submit-on-publish hook from oriz-omnipost. Free, no card. |
| [`json-feed`](./services/monitoring/monitoring/seo/json-feed.md) | Modern JSON-based syndication feed at /feed.json on every site, alongside RSS 2.0 and Atom 1.0. |
| [`json-ld-structured-data`](./services/monitoring/monitoring/seo/json-ld-structured-data.md) | Schema.org JSON-LD markup emitted via a `<JsonLd>` component in @chirag127/oriz-kit. Article + BreadcrumbList + Organization + WebSite + Person types across the family. |

### Short Link (3)

| File | Description |
|---|---|
| [`cloudflare-worker`](./services/business/short-link/cloudflare-worker.md) | Self-hosted URL shortener on a Cloudflare Worker at s.oriz.in. Free tier (100k req/day), no card. Used by oriz-omnipost when a target platform truncates blog content. |
| [`github-gist-redirect`](./services/business/short-link/github-gist-redirect.md) | Zero-infrastructure URL redirect: a GitHub gist containing a single HTML page with meta-refresh + canonical link. Tier 3 fallback in the family's three-tier short-link stack — last-resort, immutable, survives a complete Cloudflare outage. |
| [`tinyurl`](./services/business/short-link/tinyurl.md) | Truly free, unlimited, no-auth URL shortener. Tier 2 fallback in the family's three-tier short-link stack — used when the link points outside oriz.in or s.oriz.in is unreachable. |

### Social (5)

| File | Description |
|---|---|
| [`activitypub`](./services/business/social/activitypub.md) | Mirrors oriz-me's canonical lifestream JSONL events to ActivityPub-compatible federated streams (Mastodon, Pleroma, etc) via me.oriz.in/activitypub/outbox. Free, federated, no card. |
| [`atproto-firehose`](./services/business/social/atproto-firehose.md) | Mirrors oriz-me's canonical lifestream JSONL events to the AT Protocol as records under me.oriz.in.atproto. Free, federated, no card. |
| [`raindrop-io`](./services/business/social/raindrop-io.md) | Bookmarking SaaS used as the source of truth for the family's linkroll. Free unlimited bookmarks + collections + REST API. Powers blog.oriz.in/links built at deploy time. |
| [`ray-so`](./services/business/social/ray-so.md) | Generate pretty code-screenshot PNGs for Open Graph cards on code-heavy blog posts. Free, OSS, no card. |
| [`satori-og-cards`](./services/business/social/satori-og-cards.md) | Self-built Open Graph card generator using @vercel/og (Satori) on the api.oriz.in Hono Worker. Free unlimited (CF Workers free tier). Renders templated OG PNGs on demand for non-code blog posts. |

### Storage (4)

| File | Description |
|---|---|
| [`backblaze-b2`](./services/data/storage/backblaze-b2.md) | Primary blob storage — 10 GB free + 3x egress free of stored. Used for backups and large unversioned binaries that don't belong in GitHub Releases. |
| [`cloudflare-r2`](./services/data/storage/cloudflare-r2.md) | REJECTED — card-on-file requirement on the surrounding Workers Paid plan. Replaced by Backblaze B2 + GitHub Releases split. |
| [`github-releases`](./services/data/storage/github-releases.md) | Versioned-binary storage — unlimited releases per repo, 2 GB per asset, free for OSS. Used for extension and CLI binaries. |
| [`restic`](./services/data/storage/restic.md) | Encrypted, deduplicating backup CLI. Runs in a GitHub Actions weekly cron, targets a Backblaze B2 bucket. OSS, free, no card. |

### Testing (6)

| File | Description |
|---|---|
| [`chromatic`](./services/code/testing/chromatic.md) | Visual regression diff against Storybook snapshots. Free 5K snapshots/month, no card. |
| [`mockoon`](./services/code/testing/mockoon.md) | Out-of-process API mock — free OSS desktop app + headless CLI. Stands up a real HTTP server on localhost. Used for E2E tests against third-party APIs (Razorpay sandbox, Open-Meteo, Alpha Vantage when offline) and for manual dev mocking. |
| [`msw`](./services/code/testing/msw.md) | In-process API mocking for browser + Node tests. Service Worker in browser; Node interceptor in tests. Free OSS. Used for Vitest unit tests, Storybook stories, and dev-time mocking. |
| [`playwright`](./services/code/testing/playwright.md) | Cross-browser E2E test runner — Chromium + WebKit + Firefox. Free OSS. Already the substrate the a11y axe-core suite rides on. |
| [`storybook`](./services/code/testing/storybook.md) | Isolated component sandbox + interactive docs. Source of the visual-regression snapshots Chromatic diffs. |
| [`vitest`](./services/code/testing/vitest.md) | Vite-native unit + integration test runner. Free, OSS, fast in-memory. Already on Vite via Astro — no extra config. |

### Tooling (8)

| File | Description |
|---|---|
| [`axiom`](./services/business/tooling/axiom.md) | Log management — 0.5 TB ingest / 30-day retention free. |
| [`azure-for-students`](./services/business/tooling/azure-for-students.md) | Available — free Azure credits via student program, no card required. |
| [`cloudinary`](./services/business/tooling/cloudinary.md) | Image CDN + transforms fallback — 25 monthly credits free, no card. |
| [`envpact`](./services/business/tooling/envpact.md) | Secrets vault — chirag127's own tool, primary store for every cross-site secret. |
| [`hookdeck`](./services/business/tooling/hookdeck.md) | Webhook reliability layer — queues + retries + replay for Razorpay → Worker delivery. 100K requests/month free. |
| [`hypertune`](./services/business/tooling/hypertune.md) | Type-safe feature flags + A/B testing + typed config with Git-style version control. |
| [`imagekit`](./services/business/tooling/imagekit.md) | Image CDN + on-the-fly transforms — 20 GB bandwidth/month free. |
| [`readthedocs`](./services/business/tooling/readthedocs.md) | SDK + API reference docs hosting — versioned, searchable, free for open-source. |

### Video (2)

| File | Description |
|---|---|
| [`gumlet`](./services/media/video/gumlet.md) | Privacy-sensitive video hosting + streaming — 250 GB/month free, no card, no viewer tracking. |
| [`youtube`](./services/media/video/youtube.md) | Video hosting + embed primary — unlimited storage and bandwidth, free, public-content only. |

### Other (7)

| File | Description |
|---|---|
| [`aws`](./services/aws.md) | REJECTED — requires card on file at sign-up. |
| [`azure-paid-tiers`](./services/azure-paid-tiers.md) | REJECTED — requires card on file. Azure for Students is documented separately. |
| [`backblaze-b2`](./services/backblaze-b2.md) | REJECTED — excluded by user policy. |
| [`easy-free-tier`](./services/easy-free-tier.md) | Single SSoT catalog of services every chirag127/oriz* repo uses. Filters: free for public repos, no manual OSS application required, no card-on-file at signup, commercial use allowed (family monetises). Maximum 2-3 picks per concern. Tag... |
| [`family-inventory`](./services/family-inventory.md) | Single source of truth for the oriz-org family count totals. After 2026-06-25 scope-cut (33 repos archived) \u2014 6 apps, 0 in-house npm packages, 3 books, 0 in-house APIs, 4 browser-extension repos (3 forks + 1 original), 1 IDE extensi... |
| [`open-knowledge-format`](./services/open-knowledge-format.md) | Vendor-neutral, open specification (v0.1, June 2026) from Google Cloud for representing knowledge as Markdown files with YAML frontmatter — the canonical format for all family knowledge bundles. |
| [`oracle-cloud`](./services/oracle-cloud.md) | REJECTED — excluded by user policy. |

## Glossary (33 total)

### A-C (5)

| File | Description |
|---|---|
| [`app-check`](./glossary/a-c/app-check.md) | Firebase's bot-defence layer that gates every Firestore call to verified clients. |
| [`auth-domain`](./glossary/a-c/auth-domain.md) | auth.oriz.in, the custom domain that lets one Firebase project serve every *.oriz.in site. |
| [`cache-rebuild`](./glossary/a-c/cache-rebuild.md) | The GitHub Actions job that reads JSONL canonical and re-populates the Turso warm cache. |
| [`card-on-file`](./glossary/a-c/card-on-file.md) | A payment instrument linked to a service account; the family avoids this for every paid-tier-capable provider. |
| [`concept-file`](./glossary/a-c/concept-file.md) | One OKF unit — a single markdown file with YAML frontmatter representing one fact, decision, or rule. |

### D-H (7)

| File | Description |
|---|---|
| [`data-repo`](./glossary/d-h/data-repo.md) | chirag127/oriz-me-data, the authoritative JSONL store for the me.oriz.in lifestream. |
| [`digital-twin`](./glossary/d-h/digital-twin.md) | The broader concept lifestream implements: a public-facing mirror of one person's consumption and activity. |
| [`extension-suffix`](./glossary/d-h/extension-suffix.md) | The -ext suffix on Chrome extension repo names (oriz-<name>-ext). |
| [`family-anchor-site`](./glossary/d-h/family-anchor-site.md) | oriz-home, the site whose v2 design defines patterns the other 10 reuse. |
| [`family`](./glossary/d-h/family.md) | The chirag127/oriz-* family of sites + extensions + packages: 11 sites + N extensions + 6 packages + 1 API. |
| [`firestore-spark`](./glossary/d-h/firestore-spark.md) | Firebase's free tier; the family never upgrades to Blaze. |
| [`hono-rpc`](./glossary/d-h/hono-rpc.md) | The type-safe API client pattern: hc<AppType> from @hono/client. |

### I-N (2)

| File | Description |
|---|---|
| [`lifestream`](./glossary/i-n/lifestream.md) | The public daily-rebuilt event store concept that powers me.oriz.in. |
| [`master-repo`](./glossary/i-n/master-repo.md) | chirag127/oriz, the umbrella repo that holds every submodule plus knowledge/ and design/. |

### O-R (6)

| File | Description |
|---|---|
| [`okf-bundle`](./glossary/o-r/okf-bundle.md) | A directory of concept files for one organization; this knowledge/ directory is one such bundle. |
| [`omnipost`](./glossary/o-r/omnipost.md) | @chirag127/oriz-omnipost, the family's RSS-driven cross-post engine that fans each blog post out to every supported platform via the Adapter pattern. |
| [`oriz`](./glossary/o-r/oriz.md) | The family brand, the master GitHub repo name, and the apex domain (oriz.in). |
| [`package-isolation`](./glossary/o-r/package-isolation.md) | Wrapping every external service in a typed package so swapping providers is a version bump, not a rewrite. |
| [`parallel-by-default`](./glossary/o-r/parallel-by-default.md) | The family rule: any work that can be parallelised MUST be fanned out via subagents. |
| [`parallel-fan-out`](./glossary/o-r/parallel-fan-out.md) | Spawning N subagents simultaneously for independent work. |

### S-Z (7)

| File | Description |
|---|---|
| [`self-update-rule`](./glossary/s-z/self-update-rule.md) | Every chat decision lands in knowledge/ in the same conversation. |
| [`site-suffix`](./glossary/s-z/site-suffix.md) | The -site suffix on website repo names (oriz-<name>-site). |
| [`submodule-pointer`](./glossary/s-z/submodule-pointer.md) | The master oriz repo's recorded SHA for each submodule; the production state contract. |
| [`survival-fallback`](./glossary/s-z/survival-fallback.md) | The §16 layer that survives if every primary service dies (GitHub Pages mirrors + git-canonical data repo). |
| [`the-provenance-strip`](./glossary/s-z/the-provenance-strip.md) | oriz-me's signature element, the live build manifest at the top of every page. |
| [`the-seal`](./glossary/s-z/the-seal.md) | oriz-journal's signature animation (the only motion in the app), the encryption metaphor. |
| [`the-spine`](./glossary/s-z/the-spine.md) | oriz-blog's typographic series indicator (●─●─○─○). |

## Related context

- [`_okf.md`](./_okf.md) - Open Knowledge Format specification
- [`_navigation.md`](./_navigation.md) - navigation rules
- `MEMORY.md` (in user's project dir) - auto-loaded session memories
- [`../AGENTS.md`](../AGENTS.md) - comprehensive agent index

## Health

- Total markdown files in `knowledge/`: **792** (was 949 before 2026-06-25 cleanup)
- Total rules: **71**
- Total decisions: **385** (architecture: 301, other: 84)
- Total runbooks: **49**
- Total services: **171**
- Total glossary entries: **27**
- Max path depth (segments under `knowledge/`): **4** (deepest: `decisions/apps/cards-site-scope.md`)
- Anomalies flagged: **78 files with non-`active` status** (plus 55 navigational `index.md` files without a status field - expected, not flagged)

### Files with non-active status (review)


**`status: (missing)`** (55)

- [`decisions/compute/api-scraping-tos-audit.md`](./decisions/compute/api-scraping-tos-audit.md)
- [`decisions/apps/cards-site-scope.md`](./decisions/apps/cards-site-scope.md)
- [`decisions/content/journal-site-sources.md`](./decisions/content/journal-site-sources.md)
- [`decisions/frontend/sidebar-4-tier.md`](./decisions/frontend/sidebar-4-tier.md)
- [`decisions/stack/tool-categories-roadmap.md`](./decisions/stack/tool-categories-roadmap.md)
- [`decisions/stack/tools-site-15-repos.md`](./decisions/stack/tools-site-15-repos.md)
- [`decisions/knowledge-bundle/depth-5-level-hierarchy.md`](./decisions/knowledge-bundle/depth-5-level-hierarchy.md)
- [`decisions/stack/family-stack-lock.md`](./decisions/stack/family-stack-lock.md)
- [`branding/naming/policy-family-naming-policy.md`](./branding/naming/policy-family-naming-policy.md)
- [`glossary/a-c/app-check.md`](./glossary/a-c/app-check.md)
- [`glossary/a-c/auth-domain.md`](./glossary/a-c/auth-domain.md)
- [`glossary/a-c/cache-rebuild.md`](./glossary/a-c/cache-rebuild.md)
- [`glossary/a-c/card-on-file.md`](./glossary/a-c/card-on-file.md)
- [`glossary/a-c/concept-file.md`](./glossary/a-c/concept-file.md)
- [`glossary/d-h/data-repo.md`](./glossary/d-h/data-repo.md)
- [`glossary/d-h/digital-twin.md`](./glossary/d-h/digital-twin.md)
- [`glossary/d-h/extension-suffix.md`](./glossary/d-h/extension-suffix.md)
- [`glossary/d-h/family-anchor-site.md`](./glossary/d-h/family-anchor-site.md)
- [`glossary/d-h/family.md`](./glossary/d-h/family.md)
- [`glossary/d-h/firestore-spark.md`](./glossary/d-h/firestore-spark.md)
- [`glossary/d-h/hono-rpc.md`](./glossary/d-h/hono-rpc.md)
- [`glossary/i-n/lifestream.md`](./glossary/i-n/lifestream.md)
- [`glossary/i-n/master-repo.md`](./glossary/i-n/master-repo.md)
- [`glossary/o-r/okf-bundle.md`](./glossary/o-r/okf-bundle.md)
- [`glossary/o-r/omnipost.md`](./glossary/o-r/omnipost.md)
- [`glossary/o-r/oriz.md`](./glossary/o-r/oriz.md)
- [`glossary/o-r/package-isolation.md`](./glossary/o-r/package-isolation.md)
- [`glossary/o-r/parallel-by-default.md`](./glossary/o-r/parallel-by-default.md)
- [`glossary/o-r/parallel-fan-out.md`](./glossary/o-r/parallel-fan-out.md)
- [`glossary/s-z/self-update-rule.md`](./glossary/s-z/self-update-rule.md)
- [`glossary/s-z/site-suffix.md`](./glossary/s-z/site-suffix.md)
- [`glossary/s-z/submodule-pointer.md`](./glossary/s-z/submodule-pointer.md)
- [`glossary/s-z/survival-fallback.md`](./glossary/s-z/survival-fallback.md)
- [`glossary/s-z/the-provenance-strip.md`](./glossary/s-z/the-provenance-strip.md)
- [`glossary/s-z/the-seal.md`](./glossary/s-z/the-seal.md)
- [`glossary/s-z/the-spine.md`](./glossary/s-z/the-spine.md)
- [`rules/interaction/no-card-on-file.md`](./rules/interaction/no-card-on-file.md)
- [`rules/interaction/user-prefers-atomic-split.md`](./rules/interaction/user-prefers-atomic-split.md)
- [`rules/interaction/user-prefers-deletion-over-archive.md`](./rules/interaction/user-prefers-deletion-over-archive.md)
- [`rules/interaction/user-prefers-pure-tool-brand.md`](./rules/interaction/user-prefers-pure-tool-brand.md)
- [`rules/interaction/user-prefers-same-name-repo-and-npm.md`](./rules/interaction/user-prefers-same-name-repo-and-npm.md)
- [`rules/interaction/user-prefers-strict-no-toggle.md`](./rules/interaction/user-prefers-strict-no-toggle.md)
- [`rules/interaction/user-prefers-wider-coverage.md`](./rules/interaction/user-prefers-wider-coverage.md)
- [`runbooks/platform/cf-dns-add-api-subdomain.md`](./runbooks/platform/cf-dns-add-api-subdomain.md)
- [`runbooks/platform/cf-dns-audit-2026-06-23.md`](./runbooks/platform/cf-dns-audit-2026-06-23.md)
- [`runbooks/workflow/dependabot-notification-tuning.md`](./runbooks/workflow/dependabot-notification-tuning.md)
- [`runbooks/workflow/visual-audit-2026-06-22.md`](./runbooks/workflow/visual-audit-2026-06-22.md)
- [`runbooks/scaffolding/sites/scaffold-tool-site.md`](./runbooks/scaffolding/sites/scaffold-tool-site.md)
- [`runbooks/security/credentials/rotate-cf-and-npm-tokens.md`](./runbooks/security/credentials/rotate-cf-and-npm-tokens.md)

**`status: deferred`** (3)

- [`services/data/queue/inngest.md`](./services/data/queue/inngest.md)
- [`services/data/queue/upstash-qstash.md`](./services/data/queue/upstash-qstash.md)
- [`services/data/search/orama-cloud.md`](./services/data/search/orama-cloud.md)

**`status: fallback`** (8)

- [`services/business/ads/ezoic.md`](./services/business/ads/ezoic.md)
- [`services/business/ads/mediavine.md`](./services/business/ads/mediavine.md)
- [`services/business/auth/clerk.md`](./services/business/auth/clerk.md)
- [`services/business/auth/supabase.md`](./services/business/auth/supabase.md)
- [`services/business/email/mailerlite.md`](./services/business/email/mailerlite.md)
- [`services/business/forms/formspree.md`](./services/business/forms/formspree.md)
- [`services/infra/hosting/netlify.md`](./services/infra/hosting/netlify.md)
- [`services/infra/hosting/vercel.md`](./services/infra/hosting/vercel.md)

**`status: pending-manual-action`** (1)

- [`runbooks/platform/codeberg-mirror-2026-06-23.md`](./runbooks/platform/codeberg-mirror-2026-06-23.md)

**`status: redirect`** (1)

- [`decisions/packages/the-six-packages.md`](./decisions/packages/the-six-packages.md)

**`status: rejected`** (10)

- [`services/business/ai/openrouter.md`](./services/business/ai/openrouter.md)
- [`services/aws.md`](./services/aws.md)
- [`services/azure-paid-tiers.md`](./services/azure-paid-tiers.md)
- [`services/backblaze-b2.md`](./services/backblaze-b2.md)
- [`services/infra/hosting/firebase-hosting.md`](./services/infra/hosting/firebase-hosting.md)
- [`services/business/i18n/tolgee.md`](./services/business/i18n/tolgee.md)
- [`services/monitoring/monitoring/glitchtip.md`](./services/monitoring/monitoring/glitchtip.md)
- [`services/oracle-cloud.md`](./services/oracle-cloud.md)
- [`services/business/productivity/toggl-track.md`](./services/business/productivity/toggl-track.md)
- [`services/data/storage/cloudflare-r2.md`](./services/data/storage/cloudflare-r2.md)
