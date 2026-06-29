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
- **Rules** - non-negotiable invariants. Read these first.
- **Decisions** - architecture + product decisions with rationale. Date-stamped, latest-only.
- **Runbooks** - step-by-step procedures.
- **Services** - one entry per service we depend on (free tier, swap cost, role).
- **Glossary** - term definitions.

## Rules (72 total)

### Agent behaviour (12)

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

## Decisions - Architecture (301 total)

### Security (7)

| File | Status | Description |
|---|---|---|
| [`cross-site-auth-via-auth-oriz-in`](./decisions/architecture/security/cross-site-auth-via-auth-oriz-in.md) | active | Firebase Auth's custom domain auth.oriz.in is shared by every *.oriz.in |
| [`data-hub-and-central-auth`](./decisions/architecture/security/data-hub-and-central-auth.md) | active | Locked 2026-06-22 evening. (1) New CF Pages app `oriz-data-aggregator-app`\ |
| [`layer-3-auth-firebase-spark`](./decisions/architecture/security/layer-3-auth-firebase-spark.md) | active | One Firebase project (oriz-app) on the Spark plan, never Blaze. Custom |
| [`no-auth-in-apps-or-apis-2026-06-25`](./decisions/architecture/security/no-auth-in-apps-or-apis-2026-06-25.md) | active | Apps and APIs are 100% public. Login moves to a dedicated login-manager project; apps/APIs that need authenticated users redirect to it, never embed. |
| [`package-isolation-rule`](./decisions/architecture/security/package-isolation-rule.md) | active | Every external service must be wrapped in a typed @chirag127 package |
| [`payment-architecture-direct-links`](./decisions/architecture/security/payment-architecture-direct-links.md) | active | Definition: 'direct platform link' = a button on our site that redirects\ |
| [`razorpay-donation-button`](./decisions/architecture/security/razorpay-donation-button.md) | active | Razorpay-hosted donation button (button ID pl_T4iEPIDcALKLPk) mounted |

### Packaging (1)

| File | Status | Description |
|---|---|---|
| [`atomic-packages-lazy`](./rules/agent/preferences/atomic-packages-lazy.md) | active | Community-first; extract atomic `@oriz/*` packages only when ≥2 apps need the same logic. Analytics stays inline in `BaseLayout.astro`. Supersedes the prior "zero in-house packages" blanket rule. |

### Packages (9)

| File | Status | Description |
|---|---|---|
| [`legal-pages-package-in-domain`](./decisions/architecture/packages/legal-pages-package-in-domain.md) | active | 8+ legal pages (/privacy /terms /contact /about /refunds /disclaimer |
| [`omni-publish-package`](./decisions/architecture/packages/omni-publish-package.md) | active | New npm package @chirag127/omni-publish handles auto-publishing release\ |
| [`omni-publish-v0-1-2-followups`](./decisions/architecture/packages/omni-publish-v0-1-2-followups.md) | active | Five follow-ups deferred from @chirag127/omni-publish v0.1.1 \u2192\ |
| [`oriz-ai-providers-package`](./decisions/architecture/packages/oriz-ai-providers-package.md) | active | New family package `@chirag127/oriz-ai-providers` aggregates EVERY free\ |
| [`packages-catalog-shape`](./decisions/architecture/packages/packages-catalog-shape.md) | active | packages.oriz.in is the auto-discovery Starlight catalog. A GitHub Action |
| [`packages-oriz-in-catalog`](./decisions/architecture/packages/packages-oriz-in-catalog.md) | active | Packages are surfaced in TWO places: (1) oriz.in renders an /apps + |
| [`single-pricing-page-package`](./decisions/architecture/packages/single-pricing-page-package.md) | active | One pricing page shared across all oriz apps, served from a package\ |
| [`the-23-packages`](./decisions/architecture/packages/the-23-packages.md) | active | The chirag127/oriz family ships 23 npm packages — 10 Astro (shell, chrome, tools, content, data, forms, billing, pwa, distribute, widgets) + 1 shared test fixtures (astro-test-utils) + 4 cross-surface auth (auth-core, auth-wxt, auth-vsc,... |
| [`the-six-packages`](./decisions/architecture/packages/the-six-packages.md) | redirect | Legacy filename. The canonical package set now lives in the-23-packages.md |

### Infrastructure (3)

| File | Status | Description |
|---|---|---|
| [`hosting-split-cf-and-gh-2026-06-25`](./decisions/architecture/infrastructure/hosting-split-cf-and-gh-2026-06-25.md) | active | Locked 2026-06-25. Apps, PWAs, and end-user websites deploy to Cloudflare Pages on custom subdomains. Software-package landing pages (npm, CLI, extension, MCP-server homes) deploy to GitHub Pages. Both targets are compatible with the don... |
| [`umbrella-as-clone-entrypoint-2026-06-25`](./decisions/architecture/infrastructure/umbrella-as-clone-entrypoint-2026-06-25.md) | active | Locked 2026-06-25. The oriz-org/oriz umbrella holds knowledge/, apps.ts registry, and every fleet repo as a git submodule. A single git clone --recurse-submodules pulls the entire fleet. No separate workspace repo, no manifest, no subtree. |
| [`workspace-flat-repos-2026-06-25`](./decisions/architecture/infrastructure/workspace-flat-repos-2026-06-25.md) | active | Locked 2026-06-25. Workspace umbrella holds every submodule under a single flat repos/<slug>/ directory. Type information is encoded in the slug suffix (-api, -npm-pkg, -bs-ext, -ide-ext, -cli, -mcp-server, -app). Forks marked by a singl... |

### Fleet (1)

| File | Status | Description |
|---|---|---|
| [`scope-cut-2026-06-25`](./decisions/architecture/fleet/scope-cut-2026-06-25.md) | active | Build-gate applied at repo level. 33 in-progress / scaffold / hub repos archived to oriz-archive. ~20 production-content repos survive. |

### Ops (17)

| File | Status | Description |
|---|---|---|
| [`alternative-free-backup-channels`](./decisions/architecture/ops/alternative-free-backup-channels.md) | active | Documents alternative free-forever backup channels to protect GitHub |
| [`analytics-five-tier-stack`](./decisions/architecture/ops/analytics-five-tier-stack.md) | active | Locked 2026-06-20: every site runs five analytics layers in parallel\ |
| [`backup-channels-alternative`](./decisions/architecture/ops/backup-channels-alternative.md) | active | Documents alternative free-forever backup channels to protect GitHub |
| [`backup-everywhere-weekly`](./decisions/architecture/ops/backup-everywhere-weekly.md) | active | Weekly cron backs up to multiple destinations simultaneously: 4-host |
| [`backup-restic-to-b2`](./decisions/architecture/ops/backup-restic-to-b2.md) | active | Weekly encrypted, deduplicated backups via restic running on a GitHub |
| [`cf-web-analytics-family-wide`](./decisions/architecture/ops/cf-web-analytics-family-wide.md) | active | Locked 2026-06-23. The existing CF_WEB_ANALYTICS_SITE_TAG (4c365cb8a8b3498b90238196fdfcb7ef) |
| [`disk-image-windows-builtin-2026-06-25`](./decisions/architecture/ops/disk-image-windows-builtin-2026-06-25.md) | active | Locked 2026-06-25. Macrium Reflect Free is discontinued (Jan 2024) and is no longer available. Replace with Windows built-in Backup-and-Restore (Windows 7-era tool, still present in Windows 11) for full-disk images. Restic to Backblaze B... |
| [`extension-distribution`](./decisions/architecture/ops/extension-distribution.md) | active | Every extension is its own GitHub repo, submoduled under extensions/. |
| [`logs-better-stack-plus-cf-tail`](./decisions/architecture/ops/logs-better-stack-plus-cf-tail.md) | active | Two-layer log strategy. Cloudflare Workers Tail for live in-Worker debugging |
| [`mirror-to-9-popular-alternatives-2026-06-28`](./decisions/architecture/ops/mirror-to-9-popular-alternatives-2026-06-28.md) | active | Mirror repos/own/* to 9 free, no-self-host GitHub alternatives (GitLab, Codeberg, Bitbucket, GitFlic, Azure DevOps, NotABug, GitGud, RocketGit, Radicle) driven from the umbrella repo's GitHub Actions. |
| [`perf-monitoring-vercel-speed-insights`](./decisions/architecture/ops/perf-monitoring-vercel-speed-insights.md) | active | Vercel Speed Insights captures Real-User Monitoring Web Vitals on every |
| [`release-cadence`](./decisions/architecture/ops/release-cadence.md) | active | Every app rides a weekly release train on Wednesday 9 AM IST via a workspace-level |
| [`seo-a11y-cdn-ssl`](./decisions/architecture/ops/seo-a11y-cdn-ssl.md) | active | Multi-engine SEO (Google + Bing + Yandex + IndexNow auto-submission)\ |
| [`seo-three-pillars`](./decisions/architecture/ops/seo-three-pillars.md) | active | Every family site ships all three SEO pillars: @astrojs/sitemap (discovery), |
| [`submodule-pattern`](./decisions/architecture/ops/submodule-pattern.md) | active | Every site, every package, and every extension is a standalone GitHub |
| [`subscription-flow`](./decisions/architecture/ops/subscription-flow.md) | active | One subscription unlocks everything. User pays via Razorpay, webhook |
| [`time-tracking-wakatime-only`](./decisions/architecture/ops/time-tracking-wakatime-only.md) | active | Locked 2026-06-20 (walked back same day): time tracking is Wakatime |

### Stack (22)

| File | Status | Description |
|---|---|---|
| [`a11y-three-tools`](./decisions/architecture/stack/a11y-three-tools.md) | active | Every PR runs axe-core, Pa11y, and Lighthouse CI in parallel. PR fails |
| [`automation`](./decisions/architecture/stack/automation.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for end-to-end automation and testing. |
| [`cli-tools`](./decisions/architecture/stack/cli-tools.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for building command-line interfaces. |
| [`code-quality-five-tools`](./decisions/architecture/stack/code-quality-five-tools.md) | active | Locked 2026-06-20: every public repo runs five complementary code-quality\ |
| [`cpp`](./decisions/architecture/stack/cpp.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for C++. |
| [`csharp`](./decisions/architecture/stack/csharp.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for C#. |
| [`databases`](./decisions/architecture/stack/databases.md) | active | The absolute best, most minimalist, and fastest database stack, including serverless SQL, edge-native SQL, key-value, and object storage. |
| [`extensions`](./decisions/architecture/stack/extensions.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for browser and editor extensions. |
| [`family-stack-lock`](./decisions/architecture/stack/family-stack-lock.md) | - | Same stack on every site (longform / catalog / hub / tool). Static output. CF Pages for monetised sites; GH Pages for info-only sites where the product is monetised elsewhere. |
| [`go`](./decisions/architecture/stack/go.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, |
| [`hosting`](./decisions/architecture/stack/hosting.md) | active | The absolute best, most minimalist, and fastest hosting solutions for static frontend applications, edge workers, and containerized microservices. |
| [`java`](./decisions/architecture/stack/java.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for Java. |
| [`javascript-typescript`](./decisions/architecture/stack/javascript-typescript.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, |
| [`newsletter-substack`](./decisions/architecture/stack/newsletter-substack.md) | active | Single newsletter for the whole oriz family at chirag127.substack.com |
| [`public-image-upload-tool`](./decisions/architecture/stack/public-image-upload-tool.md) | active | Locked 2026-06-23. oriz-pixie-image-tools-app gets a public /upload\ |
| [`python`](./decisions/architecture/stack/python.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, |
| [`rust`](./decisions/architecture/stack/rust.md) | active | The absolute best, most minimalist, and fastest stack, frameworks, libraries, and dev tools for Rust. |
| [`stack-picks-2026-06-22`](./decisions/architecture/stack/stack-picks-2026-06-22.md) | active | Cross-cutting service picks locked on 2026-06-22. AI: `@chirag127/oriz-ai-providers`\ |
| [`tool-categories-roadmap`](./decisions/architecture/stack/tool-categories-roadmap.md) | - | The locked list of 15 tool subdomains: 8 Tier 1 (ship working day 1) |
| [`tool-feature-scopes-2026-06-22`](./decisions/architecture/stack/tool-feature-scopes-2026-06-22.md) | active | Final feature scope per tool app. All tools are 100% client-side (no |
| [`tools-shape-and-priority`](./decisions/architecture/stack/tools-shape-and-priority.md) | active | 16 tool apps, each at its own *.oriz.in subdomain (paisa, slice, scribe, |
| [`tools-site-15-repos`](./decisions/architecture/stack/tools-site-15-repos.md) | - | Each tool category is its own GitHub repo (pdf-site, image-site, ...) |

### Compute (22)

| File | Status | Description |
|---|---|---|
| [`ai-puter-plus-cf-workers-ai`](./decisions/architecture/compute/ai-puter-plus-cf-workers-ai.md) | active | Two AI providers, picked by surface. Puter.js for browser-side calls |
| [`api-hosting-triple-rail`](./decisions/architecture/compute/api-hosting-triple-rail.md) | active | Every oriz API repo serves data via THREE rails simultaneously. (1)\ |
| [`api-mocks-msw-plus-mockoon`](./decisions/architecture/compute/api-mocks-msw-plus-mockoon.md) | active | Two API-mock tools, one per surface. MSW handles in-browser + in-Node |
| [`api-routes-structure`](./decisions/architecture/compute/api-routes-structure.md) | active | The Hono Worker splits routes by concern under apps/api/src/routes/\ |
| [`api-scraping-tos-audit`](./decisions/architecture/compute/api-scraping-tos-audit.md) | - | (no description) |
| [`api-umbrella-hono-worker`](./decisions/architecture/compute/api-umbrella-hono-worker.md) | active | Single Hono Worker at api.oriz.in serves every API route for the family. |
| [`billing-webhook-cf-pages-function`](./decisions/architecture/compute/billing-webhook-cf-pages-function.md) | active | Razorpay (INR) + Paddle (ROW) + Play Billing (Android) + MS Store (Windows)\ |
| [`cf-worker-quota-mitigation`](./decisions/architecture/compute/cf-worker-quota-mitigation.md) | active | Locked 2026-06-20: 8-step playbook for staying under the CF Workers |
| [`cron-split-cf-vs-gh`](./decisions/architecture/compute/cron-split-cf-vs-gh.md) | active | Run cron on BOTH substrates. CF Cron Triggers for in-Worker low-latency |
| [`data-apis-open-meteo-alpha-vantage`](./decisions/architecture/compute/data-apis-open-meteo-alpha-vantage.md) | active | Locked 2026-06-20: Open-Meteo for weather data, Alpha Vantage for finance |
| [`distribution-and-queues-locked`](./decisions/architecture/compute/distribution-and-queues-locked.md) | active | Single Batch 13 lock covering distribution + reliability. Browser extensions\ |
| [`drafts-queue-host`](./decisions/architecture/compute/drafts-queue-host.md) | active | Manual-post drafts queue lives in a private GitHub repo (chirag127/oriz-drafts) |
| [`github-pages-as-json-api`](./decisions/architecture/compute/github-pages-as-json-api.md) | active | Static, read-only JSON APIs live in <name>-api repos and serve via GitHub |
| [`health-check-cron-plus-uptime`](./decisions/architecture/compute/health-check-cron-plus-uptime.md) | active | Locked 2026-06-20: cron-job liveness is verified by healthchecks.io\ |
| [`hono-rpc-for-type-sharing`](./decisions/architecture/compute/hono-rpc-for-type-sharing.md) | active | Type-safe site\u2192API client built via Hono's hc<AppType>. No codegen,\ |
| [`hono-rpc-type-sharing`](./decisions/architecture/compute/hono-rpc-type-sharing.md) | active | API consumers get full type inference from the Hono Worker via the rpc |
| [`hono-worker-api-umbrella`](./decisions/architecture/compute/hono-worker-api-umbrella.md) | active | All 11+ sites and all extensions share a single Hono Worker deployed |
| [`hono-write-once-deploy-all-rails`](./decisions/architecture/compute/hono-write-once-deploy-all-rails.md) | active | Locked 2026-06-23. Every API/Worker in the family uses Hono. Same business\ |
| [`local-dev-tunneling-cf-tunnel`](./decisions/architecture/compute/local-dev-tunneling-cf-tunnel.md) | active | Locked 2026-06-20: local dev for the family runs on three substrates\ |
| [`market-data-apis`](./decisions/architecture/compute/market-data-apis.md) | active | Two India-market data APIs in the family, each in its own GitHub repo: |
| [`queue-cloudflare-native`](./decisions/architecture/compute/queue-cloudflare-native.md) | active | Cloudflare Queues is the family's primary durable queue. Picked for native |
| [`service-bindings-future`](./decisions/architecture/compute/service-bindings-future.md) | active | Cloudflare Service Bindings give zero-cost, zero-network-hop RPC between |

### Frontend (16)

| File | Status | Description |
|---|---|---|
| [`charts-echarts-lazy`](./decisions/architecture/frontend/charts-echarts-lazy.md) | active | ECharts (Apache-2.0, 50+ chart types) is the family-wide chart library. |
| [`final-per-app-visual-shared-behavior`](./decisions/architecture/frontend/final-per-app-visual-shared-behavior.md) | active | Locked 2026-06-22 evening. Resolves the multi-reversal sequence on shared-vs-divergent |
| [`footer-5-columns-responsive`](./decisions/architecture/frontend/footer-5-columns-responsive.md) | active | Each app's footer (per-app visual per FINAL decision) has 5 columns:\ |
| [`footer-per-app-with-universal-legal`](./decisions/architecture/frontend/footer-per-app-with-universal-legal.md) | active | Refines the maximalist-footer decision from earlier same day. Each app\ |
| [`four-nav-surfaces-every-app`](./decisions/architecture/frontend/four-nav-surfaces-every-app.md) | active | Every oriz app must include all 4 navigation surfaces (Header at top, |
| [`framework-astro-react-tailwind-shadcn-2026-06-25`](./decisions/architecture/frontend/framework-astro-react-tailwind-shadcn-2026-06-25.md) | active | Locked 2026-06-25. Every app starts on the default stack — Astro shell, React for interactive islands, Tailwind for styling, shadcn/ui for components. Per-repo design pass (frontend-design skill) sets the palette, typography, and signatu... |
| [`image-cdn-fallback-chain`](./decisions/architecture/frontend/image-cdn-fallback-chain.md) | active | Every image rendered through the @chirag127/oriz-kit <Image> wrapper |
| [`layer-1-static-hosting`](./decisions/architecture/frontend/layer-1-static-hosting.md) | active | Cloudflare Pages free is the primary host for all 11+ sites and the extensions |
| [`layer-2-survival-fallback`](./decisions/architecture/frontend/layer-2-survival-fallback.md) | active | Every site builds a static fallback to chirag127.github.io/<site> on\ |
| [`linkroll-raindrop-to-links-page`](./decisions/architecture/frontend/linkroll-raindrop-to-links-page.md) | active | The family's curated linkroll lives in a public Raindrop.io collection. |
| [`maximalist-footer-and-monetization-everywhere`](./decisions/architecture/frontend/maximalist-footer-and-monetization-everywhere.md) | active | Two reversals locked 2026-06-22 evening. (1) Footer = MAXIMALIST mega-sitemap |
| [`multi-engine-search-button`](./decisions/architecture/frontend/multi-engine-search-button.md) | active | Every site in the chirag127/oriz family ships a single 'Search the web |
| [`og-card-generation-satori`](./decisions/architecture/frontend/og-card-generation-satori.md) | active | Non-code posts get OG cards from Satori (@vercel/og) on a Hono Worker |
| [`pwabuilder-as-primary-converter`](./decisions/architecture/frontend/pwabuilder-as-primary-converter.md) | active | Every Astro app's PWA build is the source of truth. PWABuilder (free, |
| [`sidebar-4-tier`](./decisions/architecture/frontend/sidebar-4-tier.md) | - | Every site ships a sidebar via @chirag127/sidebar, but the sidebar config |
| [`status-banner-on-every-site`](./decisions/architecture/frontend/status-banner-on-every-site.md) | active | Every site embeds a thin, dismissible <StatusBanner /> from oriz-kit |

### Database (9)

| File | Status | Description |
|---|---|---|
| [`build-cache-gh-actions-plus-pnpm`](./decisions/architecture/database/build-cache-gh-actions-plus-pnpm.md) | active | Three-layer build cache strategy. Layer 1: pnpm content-addressable\ |
| [`canonical-store-jsonl`](./decisions/architecture/database/canonical-store-jsonl.md) | active | The chirag127/oriz-me-data git repo is the authoritative store for lifestream |
| [`cloud-dbs-as-caches`](./decisions/architecture/database/cloud-dbs-as-caches.md) | active | Firestore, Turso, and R2 are caches. They are rebuilt from the canonical |
| [`db-add-neon-postgres`](./decisions/architecture/database/db-add-neon-postgres.md) | active | Neon Postgres is added as the family's relational database. Free plan,\ |
| [`db-admin-console-only`](./decisions/architecture/database/db-admin-console-only.md) | active | Every database in the family is administered through its vendor's browser\ |
| [`events-table-schema`](./decisions/architecture/database/events-table-schema.md) | active | The SQL shape the lifestream JSONL is normalised into for the Turso\ |
| [`firebase-rest-firestore-not-admin`](./decisions/architecture/database/firebase-rest-firestore-not-admin.md) | active | The umbrella Hono Worker uses firebase-rest-firestore (REST + service-account |
| [`lifestream-jsonl-canonical`](./decisions/architecture/database/lifestream-jsonl-canonical.md) | active | The chirag127/oriz-me-data git repo holds canonical JSONL events sharded |
| [`object-storage-split`](./decisions/architecture/database/object-storage-split.md) | active | Versioned binaries live in GitHub Releases. Unversioned blobs live in |

### Apps (17)

| File | Status | Description |
|---|---|---|
| [`cards-site-scope`](./decisions/architecture/apps/cards-site-scope.md) | - | cards-site (cards.oriz.in) covers all financial cards in the Indian |
| [`content-apps-scope`](./decisions/architecture/apps/content-apps-scope.md) | active | Three Wave 3 content apps. tabs-cards-app at tabs.oriz.in (visual bookmark |
| [`cs-me-app-scope`](./decisions/architecture/apps/cs-me-app-scope.md) | active | The personal site at me.oriz.in (aliased as cs.oriz.in to the same site).\ |
| [`data-in-app-repos-not-separate`](./decisions/architecture/apps/data-in-app-repos-not-separate.md) | active | Locked 2026-06-22 evening. Reverses earlier proposal to create separate |
| [`eleven-saturated-archived-2026-06-25`](./decisions/architecture/apps/eleven-saturated-archived-2026-06-25.md) | active | Locked 2026-06-25. Eleven tool repos fail the defect-audit build-gate because the top-3 Google results already serve users well. They are archived on GitHub and removed from local disk. Two had real production code (slice-pdf, pixie-imag... |
| [`family-wide-stats-page`](./decisions/architecture/apps/family-wide-stats-page.md) | active | Locked 2026-06-20: oriz.in/stats aggregates visitor data from all 11 |
| [`finance-one-repo-ten-routes-2026-06-25`](./decisions/architecture/apps/finance-one-repo-ten-routes-2026-06-25.md) | active | Locked 2026-06-25. The ten finance calculators consolidate into a single finance repo serving finance.oriz.in/emi, /sip, /tax-80c, /hra, /ppf, /nps, /retirement, /gst, /fd, /lumpsum. Reverses the earlier 10-repo split. Shared @oriz/finan... |
| [`fleet-strategy-build-gate-2026-06-25`](./decisions/architecture/apps/fleet-strategy-build-gate-2026-06-25.md) | active | Locked 2026-06-25. A tool gets built only when the top three Google results for its core query reveal a concrete defect (paywall, broken UX, ad-spam, missing feature, data staleness). The defect is documented in the tool's README. No fix... |
| [`home-app-shape`](./decisions/architecture/apps/home-app-shape.md) | active | oriz.in is the marketing landing page for the family. Single hero + 5-section |
| [`janaushdhi-app-scope`](./decisions/architecture/apps/janaushdhi-app-scope.md) | active | janaushdhi.oriz.in scrapes the Pradhan Mantri Bhartiya Janaushadhi Pariyojana\ |
| [`ncert-app-scope`](./decisions/architecture/apps/ncert-app-scope.md) | active | ncert.oriz.in catalogs every NCERT textbook (Pre-Primary + classes 1-12),\ |
| [`ncert-combined-pdf-directory`](./decisions/architecture/apps/ncert-combined-pdf-directory.md) | active | ncert.nic.in only offers per-chapter PDFs. ncert.oriz.in's reason-to-exist\ |
| [`ncert-dual-mode-download`](./decisions/architecture/apps/ncert-dual-mode-download.md) | active | Both download modes offered: (1) Pre-merged combined PDFs as GitHub\ |
| [`omni-post-app-shape`](./decisions/architecture/apps/omni-post-app-shape.md) | active | omni-post.oriz.in wraps the @chirag127/omni-publish package with an admin |
| [`oriz-status-app`](./decisions/architecture/apps/oriz-status-app.md) | active | Locked 2026-06-22 (evening): in-house status page at status.oriz.in. |
| [`per-app-briefs-2026-06-22`](./decisions/architecture/apps/per-app-briefs-2026-06-22.md) | active | Single source of truth for what each of the 26 apps does + sections\ |
| [`per-app-contents-spec`](./decisions/architecture/apps/per-app-contents-spec.md) | active | Every app in repos/oriz/own/prod/apps/* follows this contents spec. 4-config |

### Content (9)

| File | Status | Description |
|---|---|---|
| [`blog-cross-post-strategy`](./decisions/architecture/content/blog-cross-post-strategy.md) | active | pages-blog-app posts daily to blog.oriz.in. omni-publish v0.1.1+ fans\ |
| [`book-publish-pipeline`](./decisions/architecture/content/book-publish-pipeline.md) | active | Books in the chirag127/oriz family are written as Markua-flavoured Markdown\ |
| [`books-publishing-shape`](./decisions/architecture/content/books-publishing-shape.md) | active | books.oriz.in is a static catalog showing cover + price + buy-links |
| [`feeds-rss-atom-json`](./decisions/architecture/content/feeds-rss-atom-json.md) | active | Every content-bearing site publishes three feed formats: /rss.xml (RSS |
| [`first-book-oriz-learnings`](./decisions/architecture/content/first-book-oriz-learnings.md) | active | User changed first-book pick on 2026-06-22 from Oriz Me (PWYW personal)\ |
| [`journal-photo-pipeline`](./decisions/architecture/content/journal-photo-pipeline.md) | active | oriz-roam-journal-app uploads photos to four free hosts in parallel (Cloudinary |
| [`journal-site-sources`](./decisions/architecture/content/journal-site-sources.md) | - | journal-site (journal.oriz.in) mines the best features of Day One, Bear, |
| [`newsletter-split-buttondown-emailoctopus`](./decisions/architecture/content/newsletter-split-buttondown-emailoctopus.md) | active | Two newsletter senders side by side. Buttondown handles the technical |
| [`stats-feeds-versioning-template`](./decisions/architecture/content/stats-feeds-versioning-template.md) | active | Single dashboard app `oriz-stats-app` at stats.oriz.in shows family-wide\ |

### Branding (2)

| File | Status | Description |
|---|---|---|
| [`repo-naming-drop-oriz-prefix-2026-06-25`](./decisions/architecture/branding/repo-naming-drop-oriz-prefix-2026-06-25.md) | active | Locked 2026-06-25. Repo slugs use the service name only — no oriz- prefix. The GitHub org namespace (oriz-org/<slug>) provides the brand. Existing repos migrate via gh repo rename. Type suffix (-api, -npm-pkg, -bs-ext, -ide-ext, -cli, -m... |
| [`subdomain-path-based-on-category-2026-06-25`](./decisions/architecture/branding/subdomain-path-based-on-category-2026-06-25.md) | active | Locked 2026-06-25. Per-tool function-based subdomains are abandoned. Tools live at <category>.oriz.in/<tool> (e.g. finance.oriz.in/emi, finance.oriz.in/sip). Topical SEO authority compounds on the category subdomain via internal cross-li... |

### Monetisation (1)

| File | Status | Description |
|---|---|---|
| [`donations-only-2026-06-25`](./decisions/architecture/monetisation/donations-only-2026-06-25.md) | active | Locked 2026-06-25. Monetisation reduced to three donation rails — BuyMeACoffee, GitHub Sponsors, UPI. No Pro/Max paid tier, no AdSense, no Razorpay subscription flow. Reverses the centralized oriz.in/pricing decision and the auth+billing... |

### Knowledge Bundle (1)

| File | Status | Description |
|---|---|---|
| [`depth-5-level-hierarchy`](./decisions/architecture/knowledge-bundle/depth-5-level-hierarchy.md) | - | Depth is sized to the L1 folder so any single agent read pulls the smallest possible leaf. Tiny folders stay flat; big folders deepen to 5. Supersedes the static 3-then-4-level rule. |

### General (36)

| File | Status | Description |
|---|---|---|
| [`agent-skills-monorepo`](./decisions/architecture/general/agent-skills-monorepo.md) | active | Single source of truth for all agent skills used by both the AI agent |
| [`auto-tracking-everywhere`](./decisions/architecture/general/auto-tracking-everywhere.md) | active | Locked 2026-06-20: every tracked metric in the chirag127/oriz family\ |
| [`bug-tracker-github-issues-only`](./decisions/architecture/general/bug-tracker-github-issues-only.md) | active | Locked 2026-06-20: every site / extension / package / worker / data\ |
| [`chrome-config-contract`](./decisions/architecture/general/chrome-config-contract.md) | active | Locked: generic components driven by 4 per-site config files; 3-level\ |
| [`chromium-hardware-scaling-profiles`](./decisions/architecture/general/chromium-hardware-scaling-profiles.md) | active | Architectural guidelines for optimizing Chromium-based browsers (Chrome/Edge) across multi-vCPU cloud virtual machines, hybrid local processors, memory-constrained client systems, and mobile extension targets. |
| [`cms-markdown-in-repo-only`](./decisions/architecture/general/cms-markdown-in-repo-only.md) | active | Every site stores content as .md / .mdx files in its own repo. Decap |
| [`code-stats-everything`](./decisions/architecture/general/code-stats-everything.md) | active | Locked 2026-06-20: every public family repo runs the full code-stats\ |
| [`cross-post-engine`](./decisions/architecture/general/cross-post-engine.md) | active | @chirag127/post-site watches the oriz-blog-site RSS feed and fans each |
| [`dynamic-family-data-registry`](./decisions/architecture/general/dynamic-family-data-registry.md) | active | User mandate 2026-06-22 evening (final): family inventory changes constantly; |
| [`feature-flags-deferred`](./decisions/architecture/general/feature-flags-deferred.md) | active | Locked 2026-06-23. No feature-flag system in the family right now. Reason: |
| [`forms-trio`](./decisions/architecture/general/forms-trio.md) | active | Locked 2026-06-20: contact forms ship a vendor-redundant pair (Web3Forms |
| [`geocoding-deferred`](./decisions/architecture/general/geocoding-deferred.md) | active | No geocoding service adopted in 2026-06-20. None of the 11 current sites\ |
| [`image-host-four-tier`](./decisions/architecture/general/image-host-four-tier.md) | active | Image origin storage uses a 4-tier chain \u2014 repo-hosted on CF Pages\ |
| [`layer-4-database-by-shape`](./decisions/architecture/general/layer-4-database-by-shape.md) | active | Different data shapes go in different free tiers, deliberately spreading |
| [`layer-5-compute`](./decisions/architecture/general/layer-5-compute.md) | active | Compute work is split across GitHub Actions cron (build-time), Cloudflare |
| [`lifestream-auto-event-sources`](./decisions/architecture/general/lifestream-auto-event-sources.md) | active | Locked 2026-06-20: the oriz-me JSONL canonical store is fed by THREE\ |
| [`lifestream-federation`](./decisions/architecture/general/lifestream-federation.md) | active | oriz-me lifestream JSONL stays canonical; mirrored as AT Protocol records |
| [`market-data-per-repo`](./decisions/architecture/general/market-data-per-repo.md) | active | FII/DII activity and Tickertape MMI each live in their own GitHub repo. |
| [`master-pointer-as-production-sha`](./decisions/architecture/general/master-pointer-as-production-sha.md) | active | The chirag127/oriz master repo's submodule pointers IS the production |
| [`maximum-libraries-policy`](./decisions/architecture/general/maximum-libraries-policy.md) | active | User reversed the minimal-libraries decision (2026-06-22 evening): use |
| [`mit-license-all-repos`](./decisions/architecture/general/mit-license-all-repos.md) | active | All 17 packages + 26 apps + 2 APIs relicensed from source-available-all-rights-reserved\ |
| [`modal-plus-val-town-specialized-rails`](./decisions/architecture/general/modal-plus-val-town-specialized-rails.md) | active | Locked 2026-06-23 after fact-checking Modal Labs free tier still exists |
| [`no-firebase-functions`](./decisions/architecture/general/no-firebase-functions.md) | active | Cloud Functions for Firebase requires the Blaze pay-as-you-go plan, |
| [`no-separate-dev-prod-projects`](./decisions/architecture/general/no-separate-dev-prod-projects.md) | active | Locked 2026-06-23. Verdict from cited research (15+ sources, 6-prong\ |
| [`notifications-fcm-plus-knock`](./decisions/architecture/general/notifications-fcm-plus-knock.md) | active | Two-layer notification stack: Knock owns multi-channel orchestration |
| [`oriz-me-single-site-not-split`](./decisions/architecture/general/oriz-me-single-site-not-split.md) | active | me.oriz.in stays one Astro site with internal URL sections (/now, /uses, |
| [`per-runtime-framework`](./decisions/architecture/general/per-runtime-framework.md) | active | Astro 6 for all 25+ sites + companion docs; Vite+React+WXT for browser |
| [`project-mgmt-github-projects-only`](./decisions/architecture/general/project-mgmt-github-projects-only.md) | active | Locked 2026-06-20: family-wide project / task management lives on a\ |
| [`revenue-channels-2026`](./decisions/architecture/general/revenue-channels-2026.md) | active | Every product surface in the chirag127/oriz family (26 apps + 17 packages\ |
| [`shared-vs-divergent-matrix`](./decisions/architecture/general/shared-vs-divergent-matrix.md) | active | Definitive matrix of what is shared via packages vs what diverges per-app.\ |
| [`testing-three-layer`](./decisions/architecture/general/testing-three-layer.md) | active | Every PR runs Vitest unit, Playwright E2E, and Chromatic visual-regression |
| [`url-shortener-mitigation-tiers`](./decisions/architecture/general/url-shortener-mitigation-tiers.md) | active | Three-tier URL shortener stack, all free, no card. Tier 1: self-hosted |
| [`url-shortener-quota-mitigation`](./decisions/architecture/general/url-shortener-quota-mitigation.md) | active | s.oriz.in is a Cloudflare Worker. Free tier is 100K requests/day per\ |
| [`userscript-prototype-via-tweeks`](./decisions/architecture/general/userscript-prototype-via-tweeks.md) | active | For new userscript ideas, use Tweeks (YC-backed AI browser extension |
| [`utm-attribution-strategy`](./decisions/architecture/general/utm-attribution-strategy.md) | active | Marketing attribution rides on UTM query parameters injected into outbound |
| [`voice-sms-deferred-to-knock`](./decisions/architecture/general/voice-sms-deferred-to-knock.md) | active | No standalone voice or SMS provider in 2026-06-20. Twilio + Vonage rejected\ |

### Uncategorised architecture (128)

| File | Status | Description |
|---|---|---|
| [`a11y-three-tools`](./decisions/architecture/a11y-three-tools.md) | active | Every PR runs axe-core, Pa11y, and Lighthouse CI in parallel. PR fails on any new a11y violation in any tool. Each tool catches a different category. |
| [`ai-puter-plus-cf-workers-ai`](./decisions/architecture/ai-puter-plus-cf-workers-ai.md) | active | Two AI providers, picked by surface. Puter.js for browser-side calls (user-pays, no API key client-side). Cloudflare Workers AI for server-side calls inside the Hono Worker (10K neurons/day, zero-egress, native binding). Different surfac... |
| [`analytics-five-tier-stack`](./decisions/architecture/analytics-five-tier-stack.md) | active | Locked 2026-06-20: every site runs five analytics layers in parallel — Cloudflare Web Analytics (raw load), Google Analytics 4 (marketing funnel), PostHog (product + session replay + flags), Microsoft Clarity (heatmaps + Microsoft-side s... |
| [`api-hosting-triple-rail`](./decisions/architecture/api-hosting-triple-rail.md) | active | Every oriz API repo serves data via THREE rails simultaneously. (1) GitHub Pages per API with custom domain `<name>.api.oriz.in` (CNAME). (2) RapidAPI marketplace listing (free + paid tiers for monetization). (3) Single `data.oriz.in` ag... |
| [`api-mocks-msw-plus-mockoon`](./decisions/architecture/api-mocks-msw-plus-mockoon.md) | active | Two API-mock tools, one per surface. MSW handles in-browser + in-Node test mocks (unit / Vitest, component stories, Playwright dev). Mockoon handles E2E + manual dev mocks of third-party APIs (Razorpay sandbox, Open-Meteo, Alpha Vantage ... |
| [`api-scraping-tos-audit`](./decisions/architecture/api-scraping-tos-audit.md) | - | (no description) |
| [`auth-billing-polish-locks-2026-06-22-evening`](./decisions/architecture/auth-billing-polish-locks-2026-06-22-evening.md) | active | Final locks across auth providers (Google + GitHub + Email-link + Phone OTP + Apple + Twitter), Razorpay TEST mode first, wrangler dev for local webhooks, all polish items required (mobile-responsive + dark+light toggle + PWA + SEO + OG)... |
| [`auto-tracking-everywhere`](./decisions/architecture/auto-tracking-everywhere.md) | active | Locked 2026-06-20: every tracked metric in the chirag127/oriz family is auto-captured. The oriz-me lifestream specifically pulls from auto sources only — GitHub commits via webhook, npm publishes via post-publish hook, VS Code coding ses... |
| [`backup-channels-alternative`](./decisions/architecture/backup-channels-alternative.md) | active | Documents alternative free-forever backup channels to protect GitHub repositories and their metadata (issues, PRs, wikis, releases) using Cloudflare R2, Backblaze B2, Hugging Face Datasets (with caveats), and the native GitHub Migration ... |
| [`backup-everywhere-weekly`](./decisions/architecture/backup-everywhere-weekly.md) | active | Weekly cron backs up to multiple destinations simultaneously: 4-host git mirror (already running), Firestore exports to CF R2, Restic snapshots of master to Backblaze B2. New post-MVP app `oriz-backup-status-app` provides a dashboard at ... |
| [`backup-restic-to-b2`](./decisions/architecture/backup-restic-to-b2.md) | active | Weekly encrypted, deduplicated backups via restic running on a GitHub Actions schedule, targeting a Backblaze B2 bucket. Locks the restic + B2 + GH Actions triple. |
| [`billing-webhook-cf-pages-function`](./decisions/architecture/billing-webhook-cf-pages-function.md) | active | Razorpay (INR) + Paddle (ROW) + Play Billing (Android) + MS Store (Windows) webhook handlers all land on a single CF Pages Function endpoint per provider (4 endpoints total). The function (1) verifies the provider's webhook signature, (2... |
| [`blog-cross-post-strategy`](./decisions/architecture/blog-cross-post-strategy.md) | active | pages-blog-app posts daily to blog.oriz.in. omni-publish v0.1.1+ fans out automatically to dev.to + Hashnode + Bluesky + Mastodon + Threads. Drafts for manual channels (X, Reddit, LinkedIn, Medium) queue to GitHub Issues in private chira... |
| [`book-publish-pipeline`](./decisions/architecture/book-publish-pipeline.md) | active | Books in the chirag127/oriz family are written as Markua-flavoured Markdown (Leanpub-compatible), built by the new @chirag127/oriz-book-build npm package (17th family package) which wraps Pandoc to emit EPUB3 + PDF + MOBI artefacts. omni... |
| [`books-publishing-shape`](./decisions/architecture/books-publishing-shape.md) | active | books.oriz.in is a static catalog showing cover + price + buy-links per book. First book to draft fully: Oriz Me (PWYW $9, personal essays, biographical). Other 4 (Oriz Stack, Oriz Paisa, Oriz PDF, Oriz Janaushdhi) get chapter outlines i... |
| [`bug-tracker-github-issues-only`](./decisions/architecture/bug-tracker-github-issues-only.md) | active | Locked 2026-06-20: every site / extension / package / worker / data repo uses its own GitHub Issues as the sole bug tracker. Linear, Trello, Jira, Plane.so, Asana, Height — all REJECTED. Cross-repo triage via repo:org searches. Free unli... |
| [`build-cache-gh-actions-plus-pnpm`](./decisions/architecture/build-cache-gh-actions-plus-pnpm.md) | active | Three-layer build cache strategy. Layer 1: pnpm content-addressable global store dedupes deps cross-repo locally. Layer 2: GitHub Actions cache (10 GB/repo free) keyed by pnpm-lock.yaml hash + Astro build cache keyed by source hash. Laye... |
| [`cards-site-scope`](./decisions/architecture/cards-site-scope.md) | - | cards-site (cards.oriz.in) covers all financial cards in the Indian market: credit + debit + forex + prepaid + travel. Inspired by CardInsider / TechnoFino / Paisabazaar / BookMyForex. Reviews + comparisons + calculators + guides + offer... |
| [`cf-web-analytics-family-wide`](./decisions/architecture/cf-web-analytics-family-wide.md) | active | Locked 2026-06-23. The existing CF_WEB_ANALYTICS_SITE_TAG (4c365cb8a8b3498b90238196fdfcb7ef) covers ALL family domains: the 26 apps on CF Pages, the 19 APIs' docs/HTML landing pages on GitHub Pages, and any package/book/skill landing pag... |
| [`cf-worker-quota-mitigation`](./decisions/architecture/cf-worker-quota-mitigation.md) | active | Locked 2026-06-20: 8-step playbook for staying under the CF Workers free-tier quota (100K req/day per Worker, 10ms CPU/req). Cache aggressively at the edge, split Workers by domain, and prefer `_headers`/`_redirects` over Worker logic wh... |
| [`charts-echarts-lazy`](./decisions/architecture/charts-echarts-lazy.md) | active | ECharts (Apache-2.0, 50+ chart types) is the family-wide chart library. ~300 KB gzip but lazy-loaded ONLY on pages with charts (zero hit on non-chart pages). Apps that load ECharts: paisa-finance + janaushdhi + stats.oriz.in + blog post ... |
| [`chrome-config-contract`](./decisions/architecture/chrome-config-contract.md) | active | Locked: generic components driven by 4 per-site config files; 3-level sidebar (Section → Group → Leaf); shared Datasheet Dark tokens across every site (no per-site accent); Iosevka wordmark stamp (slug-only, no ORIZ prefix); 24 auto-gene... |
| [`cms-markdown-in-repo-only`](./decisions/architecture/cms-markdown-in-repo-only.md) | active | Every site stores content as .md / .mdx files in its own repo. Decap CMS, TinaCMS, Strapi, Sanity, Contentful, Storyblok and every other headless CMS are explicitly REJECTED. |
| [`code-quality-five-tools`](./decisions/architecture/code-quality-five-tools.md) | active | Locked 2026-06-20: every public repo runs five complementary code-quality tools. Sonarcloud (SAST + smells), CodeRabbit (LLM PR review), Codecov (coverage delta), Code Climate (A — F maintainability), DeepSource (autofix). All five free ... |
| [`code-stats-everything`](./decisions/architecture/code-stats-everything.md) | active | Locked 2026-06-20: every public family repo runs the full code-stats stack — Sonarcloud + CodeRabbit + Codecov + CodeClimate + DeepSource + biome + GitHub Insights + Tokei + Lines-of-Code badge. All free for OSS. Auto-tracked per the aut... |
| [`content-apps-scope`](./decisions/architecture/content-apps-scope.md) | active | Three Wave 3 content apps. tabs-cards-app at tabs.oriz.in (visual bookmark cards, Notion/Tabby style). roam-journal-app at journal.oriz.in (networked daily journal, Roam-style backlinks). lore-book-summaries-app at lore.oriz.in (book + m... |
| [`cron-split-cf-vs-gh`](./decisions/architecture/cron-split-cf-vs-gh.md) | active | Run cron on BOTH substrates. CF Cron Triggers for in-Worker low-latency jobs; GH Actions schedule for build / publish jobs that need a runner. Pick by the job's shape, not by convenience. |
| [`cross-post-engine`](./decisions/architecture/cross-post-engine.md) | active | @chirag127/post-site watches the oriz-blog-site RSS feed and fans each new entry out to every blogging platform that exposes a public API. Adapter pattern; idempotent; canonical URL preserved; short-link fallback when the target truncate... |
| [`cs-me-app-scope`](./decisions/architecture/cs-me-app-scope.md) | active | The personal site at me.oriz.in (aliased as cs.oriz.in to the same site). Maximal personal canon: resume + project portfolio + writing + contact + reading log + music + books-read + photo dump + movies/watch list. Pulls from knowledge/ w... |
| [`data-apis-open-meteo-alpha-vantage`](./decisions/architecture/data-apis-open-meteo-alpha-vantage.md) | active | Locked 2026-06-20: Open-Meteo for weather data, Alpha Vantage for finance / market data. Both free, no card. Both fronted by the umbrella Hono Worker with KV-backed cache (1h TTL on weather, 1d TTL on finance EOD) per the CF Worker quota... |
| [`data-hub-and-central-auth`](./decisions/architecture/data-hub-and-central-auth.md) | active | Locked 2026-06-22 evening. (1) New CF Pages app `oriz-data-aggregator-app` at `data.oriz.in` renders ECharts dashboards + JSON browser for all 14+ API repos (separate from per-API GH Pages). (2) `auth.oriz.in` is the central Firebase Aut... |
| [`data-in-app-repos-not-separate`](./decisions/architecture/data-in-app-repos-not-separate.md) | active | Locked 2026-06-22 evening. Reverses earlier proposal to create separate `oriz-*-data` repos for data-driven apps. Reason: 'I don't want to increase the number of repositories just for the sake of it.' Each app's `data/` dir holds its own... |
| [`db-add-neon-postgres`](./decisions/architecture/db-add-neon-postgres.md) | active | Neon Postgres is added as the family's relational database. Free plan, no card, scale-to-zero, branching for previews. Sits alongside Firestore (documents/auth), Turso libSQL (warm cache), and JSONL canonical (archive) — the 4-tier DB st... |
| [`db-admin-console-only`](./decisions/architecture/db-admin-console-only.md) | active | Every database in the family is administered through its vendor's browser console (Firebase Console, Neon Console) or its first-party CLI (Turso CLI, libSQL CLI). NO desktop DB tool — Drizzle Studio / Outerbase / Beekeeper Studio / Table... |
| [`distribution-and-queues-locked`](./decisions/architecture/distribution-and-queues-locked.md) | active | Single Batch 13 lock covering distribution + reliability. Browser extensions publish to Chrome + Firefox + Edge. VS Code extensions publish to VS Code Marketplace + Open VSX (JetBrains walked back). Every site is a PWA via @vite-pwa/astr... |
| [`drafts-queue-host`](./decisions/architecture/drafts-queue-host.md) | active | Manual-post drafts queue lives in a private GitHub repo (chirag127/oriz-drafts) using GitHub Issues. omni-publish creates one issue per draft per platform with platform-labelled tags. Issue body is ready-to-paste copy + canonical URL + c... |
| [`dynamic-family-data-registry`](./decisions/architecture/dynamic-family-data-registry.md) | active | User mandate 2026-06-22 evening (final): family inventory changes constantly; every app must read from a SINGLE dynamic registry instead of hardcoding the list. Registry lives in `@chirag127/astro-shell/family-data.ts` (TS module). A dai... |
| [`family-wide-stats-page`](./decisions/architecture/family-wide-stats-page.md) | active | Locked 2026-06-20: oriz.in/stats aggregates visitor data from all 11 sites + code-stats data from all family repos, build-time fetched from CF Web Analytics + GitHub Insights + Wakatime + Tokei. Public, transparent, auto-refreshed via da... |
| [`feature-flags-deferred`](./decisions/architecture/feature-flags-deferred.md) | active | Locked 2026-06-23. No feature-flag system in the family right now. Reason: every concrete need we have today is solved by something else (tier checks via Firebase Auth claims for Pro/Max gating; git push for incident response; A/B testin... |
| [`feeds-rss-atom-json`](./decisions/architecture/feeds-rss-atom-json.md) | active | Every content-bearing site publishes three feed formats: /rss.xml (RSS 2.0, source-of-truth for oriz-omnipost), /atom.xml (Atom 1.0), /feed.json (JSON Feed v1.1). oriz-kit ships <FeedDiscovery /> + generators. |
| [`final-per-app-visual-shared-behavior`](./decisions/architecture/final-per-app-visual-shared-behavior.md) | active | Locked 2026-06-22 evening. Resolves the multi-reversal sequence on shared-vs-divergent chrome. FINAL POLICY: every VISUAL surface (Header / Footer / Sidebar / BottomBar / Wordmark / token CSS variable NAMES) is FULLY per-app. NOTHING vis... |
| [`firebase-rest-firestore-not-admin`](./decisions/architecture/firebase-rest-firestore-not-admin.md) | active | The umbrella Hono Worker uses firebase-rest-firestore (REST + service-account JWT). The firebase-admin SDK is excluded because workerd only partially supports gRPC. |
| [`first-book-oriz-learnings`](./decisions/architecture/first-book-oriz-learnings.md) | active | User changed first-book pick on 2026-06-22 from Oriz Me (PWYW personal) to 'My Learnings from the Oriz Project family' — a memoir + manual hybrid documenting building the oriz family. Quality bar: 'good books, not bad books'. Minimum pub... |
| [`footer-5-columns-responsive`](./decisions/architecture/footer-5-columns-responsive.md) | active | Each app's footer (per-app visual per FINAL decision) has 5 columns: 4 standard (Legal / Family / Connect / Brand) + 1 per-app-specific. Desktop ≥1024px = 5-column grid. Tablet 768-1023px = 2-column grid (pairs of 2-3 cols stacked). Mobi... |
| [`footer-per-app-with-universal-legal`](./decisions/architecture/footer-per-app-with-universal-legal.md) | active | Refines the maximalist-footer decision from earlier same day. Each app draws its own footer (per-app visual design, per-app content links related to that app's surface area) BUT every footer INCLUDES the universal legal section (links to... |
| [`forms-trio`](./decisions/architecture/forms-trio.md) | active | Locked 2026-06-20: contact forms ship a vendor-redundant pair (Web3Forms primary, Static Forms fallback, both browser-only, both free unlimited). Tally handles rich / multi-step / conditional forms. Three roles, no overlap. |
| [`four-more-packages-22-total`](./decisions/architecture/four-more-packages-22-total.md) | active | Grilled 2026-06-22. Family expands from 18 to 22 packages. New packages: (1) oriz-rate-limit — Free/Pro/Max tier usage caps across apps (10/100/unlimited PDF merges etc.); (2) oriz-analytics — single wrapper around CF Web Analytics + GA4... |
| [`four-nav-surfaces-every-app`](./decisions/architecture/four-nav-surfaces-every-app.md) | active | Every oriz app must include all 4 navigation surfaces (Header at top, Footer at bottom, Sidebar at side, BottomBar mobile-tab-bar at bottom-fixed) so users have maximum navigation options. The 4 surfaces share a family-wide STRUCTURE (CS... |
| [`geocoding-deferred`](./decisions/architecture/geocoding-deferred.md) | active | No geocoding service adopted in 2026-06-20. None of the 11 current sites need address↔coordinate translation. Cloudflare's free `CF-IPCountry` request header covers all current geo-routing needs (consent banner geo, payment-route geo). W... |
| [`github-pages-as-json-api`](./decisions/architecture/github-pages-as-json-api.md) | active | Static, read-only JSON APIs live in <name>-api repos and serve via GitHub Pages with a custom subdomain. GH Actions cron updates the JSON. Cloudflare Worker only for dynamic / write / auth-gated endpoints. APIs are publishable to RapidAP... |
| [`health-check-cron-plus-uptime`](./decisions/architecture/health-check-cron-plus-uptime.md) | active | Locked 2026-06-20: cron-job liveness is verified by healthchecks.io heartbeat pings (dead-man-switch on 20 free checks), HTTP endpoint uptime is verified by Better Stack monitors (10 free monitors). Two distinct surfaces, two free tools,... |
| [`home-app-shape`](./decisions/architecture/home-app-shape.md) | active | oriz.in is the marketing landing page for the family. Single hero + 5-section grid linking to /apps, /tools, /books, /packages, /me. Minimal copy. Designed for first impression and discovery. NOT a logged-in dashboard, NOT a personal hom... |
| [`hono-rpc-for-type-sharing`](./decisions/architecture/hono-rpc-for-type-sharing.md) | active | Type-safe site→API client built via Hono's hc<AppType>. No codegen, no schema files — backend types flow to N frontends through a workspace package. |
| [`hono-worker-api-umbrella`](./decisions/architecture/hono-worker-api-umbrella.md) | active | All 11+ sites and all extensions share a single Hono Worker deployed at api.oriz.in, NOT per-site Pages Functions. |
| [`hono-write-once-deploy-all-rails`](./decisions/architecture/hono-write-once-deploy-all-rails.md) | active | Locked 2026-06-23. Every API/Worker in the family uses Hono. Same business logic compiles to CF Workers, Deno Deploy, AWS Lambda, and Render Node — via 4 thin adapter shims (~10 LOC each). Removes per-rail rewrites when failover requires... |
| [`image-cdn-fallback-chain`](./decisions/architecture/image-cdn-fallback-chain.md) | active | Every image rendered through the @chirag127/oriz-kit <Image> wrapper resolves through a 3-tier fallback: Cloudflare Images first, wsrv.nl on 5xx, ImageKit on 5xx. |
| [`image-host-four-tier`](./decisions/architecture/image-host-four-tier.md) | active | Image origin storage uses a 4-tier chain — repo-hosted on CF Pages → ImgBB → Imgur → GitHub user-content. Composes alongside the 3-tier image-CDN chain in the oriz-kit <Image> wrapper. |
| [`janaushdhi-app-scope`](./decisions/architecture/janaushdhi-app-scope.md) | active | janaushdhi.oriz.in scrapes the Pradhan Mantri Bhartiya Janaushadhi Pariyojana product portfolio daily via GH Action, commits CSV + JSON snapshots, renders per-product price-history graphs, brand → generic substitute finder, per-state sto... |
| [`journal-photo-pipeline`](./decisions/architecture/journal-photo-pipeline.md) | active | oriz-roam-journal-app uploads photos to four free hosts in parallel (Cloudinary + ImageKit + imgbb + GitHub Releases) with client-side WebP compression, sha256-dedup on GH Releases, and first-200-wins HEAD race on read. Replaces the lega... |
| [`journal-site-sources`](./decisions/architecture/journal-site-sources.md) | - | journal-site (journal.oriz.in) mines the best features of Day One, Bear, Notion, Obsidian, and Logseq into one journaling experience. Big scope chosen knowingly; flagship-grade polish target. |
| [`legal-pages-package-in-domain`](./decisions/architecture/legal-pages-package-in-domain.md) | active | 8+ legal pages (/privacy /terms /contact /about /refunds /disclaimer /sitemap /security.txt) shipped as Astro page components in `@chirag127/astro-chrome/legal/`. Every app mounts them at its own domain (not external legal.oriz.in) so Ad... |
| [`lifestream-auto-event-sources`](./decisions/architecture/lifestream-auto-event-sources.md) | active | Locked 2026-06-20: the oriz-me JSONL canonical store is fed by THREE auto-tracked event sources only — GitHub webhooks via Hookdeck, Wakatime daily-summary cron, and Cloudflare Web Analytics daily-summary cron. No manual entry, no minute... |
| [`lifestream-federation`](./decisions/architecture/lifestream-federation.md) | active | oriz-me lifestream JSONL stays canonical; mirrored as AT Protocol records under me.oriz.in.atproto AND ActivityPub outbox at me.oriz.in/activitypub/outbox. Single source, two protocols. |
| [`lifestream-jsonl-canonical`](./decisions/architecture/lifestream-jsonl-canonical.md) | active | The chirag127/oriz-me-data git repo holds canonical JSONL events sharded by year. Turso libSQL is a rebuilt warm cache for live edge reads, not a source of truth. |
| [`linkroll-raindrop-to-links-page`](./decisions/architecture/linkroll-raindrop-to-links-page.md) | active | The family's curated linkroll lives in a public Raindrop.io collection. blog.oriz.in/links is built at deploy time from the Raindrop REST API. Cached via the Cloudflare edge with a 1-hour TTL on the build artifact; nightly cron re-deploy... |
| [`local-dev-tunneling-cf-tunnel`](./decisions/architecture/local-dev-tunneling-cf-tunnel.md) | active | Locked 2026-06-20: local dev for the family runs on three substrates picked by surface — Wrangler dev for Cloudflare Workers, Astro dev for sites, Cloudflare Tunnel (cloudflared) for exposing localhost to the public internet for webhook ... |
| [`logs-better-stack-plus-cf-tail`](./decisions/architecture/logs-better-stack-plus-cf-tail.md) | active | Two-layer log strategy. Cloudflare Workers Tail for live in-Worker debugging (5-min retention, 0 cost, wrangler tail). Better Stack Logs for cross-Worker aggregation + alerts + searchable retention (3 GB/mo free, same vendor as our statu... |
| [`market-data-apis`](./decisions/architecture/market-data-apis.md) | active | Two India-market data APIs in the family, each in its own GitHub repo: oriz-flow-fii-dii-activity-api (NSE/Moneycontrol FII/DII net activity) + oriz-mmi-tickertape-mmi-api (Tickertape Market Mood Index). GH Actions cron scrapes; GH Pages... |
| [`market-data-per-repo`](./decisions/architecture/market-data-per-repo.md) | active | FII/DII activity and Tickertape MMI each live in their own GitHub repo. GH Actions scrapes (weekdays post-NSE-close for FII/DII, hourly for MMI) and commits JSON back into the repo's data/ directory. GitHub Pages + raw.githubusercontent.... |
| [`maximalist-footer-and-monetization-everywhere`](./decisions/architecture/maximalist-footer-and-monetization-everywhere.md) | active | Two reversals locked 2026-06-22 evening. (1) Footer = MAXIMALIST mega-sitemap on every app (reverses per-app-divergent footer from shared-vs-divergent-matrix). Reason: AdSense + Play Store + MS Store + Razorpay approval gates all require... |
| [`maximum-libraries-policy`](./decisions/architecture/maximum-libraries-policy.md) | active | User reversed the minimal-libraries decision (2026-06-22 evening): use MAXIMUM number of community libraries so we write less code ourselves. Every `@chirag127/oriz-*` and `@chirag127/astro-*` package internally uses community libraries ... |
| [`mirror-to-4-git-hosts`](./decisions/architecture/mirror-to-4-git-hosts.md) | active | Insurance against GitHub becoming unusable. Master umbrella runs a Friday-4am-IST cron that pushes every submodule's HEAD to GitLab.com + Codeberg.org + Bitbucket + GitFlic.ru. Each mirror is push-only (read-from-GH-write-to-mirror). If ... |
| [`mit-license-all-repos`](./decisions/architecture/mit-license-all-repos.md) | active | All 17 packages + 26 apps + 2 APIs relicensed from source-available-all-rights-reserved to MIT on 2026-06-21. Unlocks every free-for-OSS perk (Sentry for OSS, Crowdin for OSS, BrowserStack OSS, FOSSA, etc.) and clarifies commercial use i... |
| [`modal-plus-val-town-specialized-rails`](./decisions/architecture/modal-plus-val-town-specialized-rails.md) | active | Locked 2026-06-23 after fact-checking Modal Labs free tier still exists (verified). Modal handles GPU-heavy batch jobs ($30/mo recurring credits = ~50 T4-hours, no card at signup, hard Workspace budget cap). Val.town handles utility scri... |
| [`monetization-centralized-on-oriz-in`](./decisions/architecture/monetization-centralized-on-oriz-in.md) | active | Locked 2026-06-23. Razorpay checkout lives ONLY on oriz.in/pricing. Every app subdomain that shows an Upgrade CTA redirects to oriz.in/pricing?app=<slug>&return=<url>. Single domain for payment gateway compliance + zero manual work setti... |
| [`multi-engine-search-button`](./decisions/architecture/multi-engine-search-button.md) | active | Every site in the chirag127/oriz family ships a single 'Search the web' button (in the header or footer) that opens a popover with multiple search engines. Component lives in @chirag127/oriz-kit as <MultiSearch />. |
| [`multi-target-build`](./decisions/architecture/multi-target-build.md) | active | Per-app GH Actions workflow: main → prod, PR → preview subdomain, tags → APK + EXE. DNS auto-provisioned on first deploy. Single Sentry project tagged by site. Per-app sitemaps + apex sitemap-of-sitemaps. Allow-all robots.txt with /admin... |
| [`ncert-app-scope`](./decisions/architecture/ncert-app-scope.md) | active | ncert.oriz.in catalogs every NCERT textbook (Pre-Primary + classes 1-12), all subjects, English + Hindi. Daily GH Action URL-merges per-chapter PDFs from ncert.nic.in into one PDF per book using qpdf/pdftk, publishes as GH Release artefa... |
| [`ncert-combined-pdf-directory`](./decisions/architecture/ncert-combined-pdf-directory.md) | active | ncert.nic.in only offers per-chapter PDFs. ncert.oriz.in's reason-to-exist is to provide COMBINED whole-book PDFs that don't exist anywhere else. GH Action scrapes https://ncert.nic.in/textbook.php via Playwright (using the playwright-cl... |
| [`ncert-dual-mode-download`](./decisions/architecture/ncert-dual-mode-download.md) | active | Both download modes offered: (1) Pre-merged combined PDFs as GitHub Release artefacts (free GH bandwidth + CDN); (2) Client-side on-the-fly merger using pdf-lib in browser — user clicks 'Build my book', browser fetches all chapter PDFs f... |
| [`newsletter-split-buttondown-emailoctopus`](./decisions/architecture/newsletter-split-buttondown-emailoctopus.md) | active | Two newsletter senders side by side. Buttondown handles the technical / dev audience (Markdown + API). EmailOctopus handles general marketing (visual editor, larger free tier). |
| [`newsletter-substack`](./decisions/architecture/newsletter-substack.md) | active | Single newsletter for the whole oriz family at chirag127.substack.com (or brand-aligned name). Free tier; Substack takes 10% if a paid tier ever ships. ONE newsletter, NOT per-app. Daily blog feed + weekly digest + book drop announcement... |
| [`no-firebase-functions`](./decisions/architecture/no-firebase-functions.md) | active | Cloud Functions for Firebase requires the Blaze pay-as-you-go plan, which requires a card on file with no real spend cap. Per the no-card-on-file rule, Functions are excluded. Replaces with: GitHub Actions cron (free for public repos), C... |
| [`no-separate-dev-prod-projects`](./decisions/architecture/no-separate-dev-prod-projects.md) | active | Locked 2026-06-23. Verdict from cited research (15+ sources, 6-prong fan-out): a separate dev Firebase project is net-negative at oriz scale today (Spark plan, no paying users, solo founder, mostly stub apps). Emulator + one prod + 5 che... |
| [`notifications-fcm-plus-knock`](./decisions/architecture/notifications-fcm-plus-knock.md) | active | Two-layer notification stack: Knock owns multi-channel orchestration (in-app + email + SMS + web push); FCM stays as the web-push transport. Free 10K notifs/mo on Knock, free unlimited on FCM. |
| [`object-storage-split`](./decisions/architecture/object-storage-split.md) | active | Versioned binaries live in GitHub Releases. Unversioned blobs live in Backblaze B2. Cloudflare R2 is rejected because adjacent paid features pull in a card-on-file requirement. |
| [`og-card-generation-satori`](./decisions/architecture/og-card-generation-satori.md) | active | Non-code posts get OG cards from Satori (@vercel/og) on a Hono Worker route at api.oriz.in/og. Code-heavy posts continue on ray.so. Static-cached via CF edge cache headers, no per-post PNGs in any site repo. |
| [`omni-post-app-shape`](./decisions/architecture/omni-post-app-shape.md) | active | omni-post.oriz.in wraps the @chirag127/omni-publish package with an admin dashboard. /admin shows the pending GH Issues drafts queue, cross-post history per platform, retry-per-platform controls, and edit-before-publish UI. Public root (... |
| [`omni-publish-package`](./decisions/architecture/omni-publish-package.md) | active | New npm package @chirag127/omni-publish handles auto-publishing release notes / blog posts to dev.to + hashnode + medium + X + LinkedIn + Bluesky + Mastodon + Reddit on tag push or release create. Triggered by GitHub Actions reusable wor... |
| [`omni-publish-v0-1-2-followups`](./decisions/architecture/omni-publish-v0-1-2-followups.md) | active | Five follow-ups deferred from @chirag127/omni-publish v0.1.1 → v0.1.2: per-repo per-day rate-limit cache (high), retry on transient 5xx (medium), compile TS → dist/ for non-bundler consumers (medium), Hashnode tag _id resolution (low), T... |
| [`oriz-ai-providers-package`](./decisions/architecture/oriz-ai-providers-package.md) | active | New family package `@chirag127/oriz-ai-providers` aggregates EVERY free LLM API (Cerebras, Groq, Cohere, NVIDIA NIM, GitHub Models, Cloudflare Workers AI, HuggingFace, Mistral, SambaNova, OpenRouter, LLM7, OVHcloud, Pollinations, Kilo Co... |
| [`oriz-me-single-site-not-split`](./decisions/architecture/oriz-me-single-site-not-split.md) | active | me.oriz.in stays one Astro site with internal URL sections (/now, /uses, /gear, /reading, /coding, /lifestream, /cv, /contact). Not split into now.oriz.in, uses.oriz.in, gear.oriz.in, etc. |
| [`oriz-status-app`](./decisions/architecture/oriz-status-app.md) | active | Locked 2026-06-22 (evening): in-house status page at status.oriz.in. CF Worker cron every 5 min probes every URL in FAMILY_* registries, writes to KV, served by sibling read-only Worker behind 60-sec edge cache. Replaces UptimeRobot (com... |
| [`packages-catalog-shape`](./decisions/architecture/packages-catalog-shape.md) | active | packages.oriz.in is the auto-discovery Starlight catalog. A GitHub Action lists every chirag127/*-npm-pkg repo, fetches README + version + bundle metadata, and renders per-package showcase pages with live demo iframe, copy-paste install ... |
| [`packages-oriz-in-catalog`](./decisions/architecture/packages-oriz-in-catalog.md) | active | Packages are surfaced in TWO places: (1) oriz.in renders an /apps + /packages + /mobile + /desktop + /extensions overview with cards per app + store/channel badges (Play Store, Microsoft Store, Chrome Web Store, etc.) with 'Coming soon' ... |
| [`payment-architecture-direct-links`](./decisions/architecture/payment-architecture-direct-links.md) | active | Definition: 'direct platform link' = a button on our site that redirects to a provider's hosted checkout (Razorpay Payment Page, Gumroad URL, Paddle checkout link, Substack subscribe URL). Provider hosts the checkout; we host the button.... |
| [`per-app-briefs-2026-06-22`](./decisions/architecture/per-app-briefs-2026-06-22.md) | active | Single source of truth for what each of the 26 apps does + sections + features. Locked via grill 2026-06-22 (Q-APP-* + Q-NCERT-* + Q-TOOLS-*). Supersedes per-app scope files where they conflict. Renames: oriz-lore-app → oriz-lore-app (br... |
| [`per-app-contents-spec`](./decisions/architecture/per-app-contents-spec.md) | active | Every app in repos/oriz/own/prod/apps/* follows this contents spec. 4-config split (site/nav/sidebar/footer) lives in src/config/. Common pages (landing, about, changelog, admin) + per-tool pages + 24 legal pages from astro-chrome. CI/CD... |
| [`per-runtime-framework`](./decisions/architecture/per-runtime-framework.md) | active | Astro 6 for all 25+ sites + companion docs; Vite+React+WXT for browser extensions; esbuild+TS for VS Code extensions; tsup+Node 22 for CLIs and MCP servers. Each runtime gets the framework that ships best to its target. |
| [`perf-monitoring-vercel-speed-insights`](./decisions/architecture/perf-monitoring-vercel-speed-insights.md) | active | Vercel Speed Insights captures Real-User Monitoring Web Vitals on every site, complementing Cloudflare's edge-measured metrics and Sentry's API traces. Free, no Vercel hosting required. |
| [`project-mgmt-github-projects-only`](./decisions/architecture/project-mgmt-github-projects-only.md) | active | Locked 2026-06-20: family-wide project / task management lives on a single GitHub Projects board on chirag127/oriz master, with kanban + table + roadmap views. Notion, Obsidian Tasks, Linear, ClickUp, Asana, Trello — all REJECTED. The kn... |
| [`projects-owner-own-forks-layout`](./decisions/architecture/projects-owner-own-forks-layout.md) | active | The workspace umbrella organizes submodules in a 5-level hierarchy: GitHub owner (oriz/ for oriz-org or c127/ for chirag127) → own/ vs forks/ → 4 artifact-type buckets (prod, svc, lib, content) → category folder → repo. Shape B grouping ... |
| [`public-image-upload-tool`](./decisions/architecture/public-image-upload-tool.md) | active | Locked 2026-06-23. oriz-pixie-image-tools-app gets a public /upload page using the 9-host replicate pipeline (Cloudinary + ImageKit + imgbb + freeimage + GH Releases). Free tier: 5 uploads/day, requires sign-in + reCAPTCHA v3. Pro tier: ... |
| [`pwabuilder-as-primary-converter`](./decisions/architecture/pwabuilder-as-primary-converter.md) | active | Every Astro app's PWA build is the source of truth. PWABuilder (free, Microsoft-hosted, CLI available) converts the PWA into Android AAB + Windows MSIX without per-app native code. Tauri stays available as opt-in for apps that want auto-... |
| [`queue-cloudflare-native`](./decisions/architecture/queue-cloudflare-native.md) | active | Cloudflare Queues is the family's primary durable queue. Picked for native Worker bindings + same-account billing surface, not for feature richness. Upstash QStash + Inngest documented as deferred alternatives. |
| [`razorpay-donation-button`](./decisions/architecture/razorpay-donation-button.md) | active | Razorpay-hosted donation button (button ID pl_T4iEPIDcALKLPk) mounted on every app's /sponsors route + oriz-cs-me-app footer. One-click: opens Razorpay-hosted donation page; user picks amount; payment received. Separate from subscription... |
| [`release-cadence`](./decisions/architecture/release-cadence.md) | active | Every app rides a weekly release train on Wednesday 9 AM IST via a workspace-level cron that tags + releases each app that has commits since its last tag. Versioning is CalVer per app (v2026.06.21). Hot-fixes bypass the train via [hotfix... |
| [`revenue-channels-2026`](./decisions/architecture/revenue-channels-2026.md) | active | Every product surface in the chirag127/oriz family (26 apps + 17 packages + 5 books + future browser-/VS-Code-extensions + CLIs + MCP servers) auto-publishes to as many revenue channels as 2026's API reality allows. Orchestrated by @chir... |
| [`seo-a11y-cdn-ssl`](./decisions/architecture/seo-a11y-cdn-ssl.md) | active | Multi-engine SEO (Google + Bing + Yandex + IndexNow auto-submission) + JSON-LD structured data per page + WCAG 2.2 AA + Pa11y CI gate + Lighthouse a11y ≥95 required + CF Pages tight cache rules (HTML 1h, assets 1yr, API 0) + Brotli + HTT... |
| [`seo-three-pillars`](./decisions/architecture/seo-three-pillars.md) | active | Every family site ships all three SEO pillars: @astrojs/sitemap (discovery), IndexNow (instant indexing), and JSON-LD structured data (semantic). Submitted to Google Search Console + Bing Webmaster Tools. All free, all no-card. |
| [`shared-vs-divergent-matrix`](./decisions/architecture/shared-vs-divergent-matrix.md) | active | Definitive matrix of what is shared via packages vs what diverges per-app. Auth FULLY shared. Pricing FULLY shared. Theme tokens API shared, but hex colors + type stack PER-APP. Footer DATA shared (FAMILY_APPS/BOOKS/PACKAGES from astro-s... |
| [`ship-order-2026q3`](./decisions/architecture/ship-order-2026q3.md) | active | Priority order for shipping the oriz family across Q3 2026. Home-app + janaushdhi-app + ncert-app + pages-blog-app land FIRST. All 16 tool subdomains ship in a locked priority sequence behind them. 5 books drafted in parallel (Oriz Me fi... |
| [`sidebar-4-tier`](./decisions/architecture/sidebar-4-tier.md) | - | Every site ships a sidebar via @chirag127/sidebar, but the sidebar config differs by site type. Four tiers: A) auto-generated for tools, B) curated TOC for longform, C) browse + search for catalogs, D) family directory for the brand hub. |
| [`single-pricing-page-package`](./decisions/architecture/single-pricing-page-package.md) | active | One pricing page shared across all oriz apps, served from a package so it's identical everywhere. The ONLY paid feature family-wide is 'ad-free' — remove AdSense + AdMob. Same price tier across web + Play + MS Store. Single Razorpay/Padd... |
| [`stack-picks-2026-06-22`](./decisions/architecture/stack-picks-2026-06-22.md) | active | Cross-cutting service picks locked on 2026-06-22. AI: `@chirag127/oriz-ai-providers` (20-provider fallback chain — OVHcloud / LLM7 / Pollinations anonymous first, then Cerebras / Groq / NIM / OpenRouter / etc keyed) — see decisions/archi... |
| [`stats-feeds-versioning-template`](./decisions/architecture/stats-feeds-versioning-template.md) | active | Single dashboard app `oriz-stats-app` at stats.oriz.in shows family-wide aggregate metrics (visits, npm downloads, GitHub stars, books sold, Sentry errors). RSS published from blog app only (not all 26 apps — too noisy). Package versioni... |
| [`status-banner-on-every-site`](./decisions/architecture/status-banner-on-every-site.md) | active | Every site embeds a thin, dismissible <StatusBanner /> from oriz-kit that consumes Better Stack's RSS incident feed; visible only when an incident is live, with severity + link to status.oriz.in. |
| [`testing-three-layer`](./decisions/architecture/testing-three-layer.md) | active | Every PR runs Vitest unit, Playwright E2E, and Chromatic visual-regression against Storybook in parallel. PR fails on any failure in any layer. All free, no card. |
| [`time-tracking-wakatime-only`](./decisions/architecture/time-tracking-wakatime-only.md) | active | Locked 2026-06-20 (walked back same day): time tracking is Wakatime ONLY. Wakatime auto-tracks coding time via IDE plugin (VS Code + JetBrains). Toggl Track was originally adopted alongside it for manual non-coding tracking, then walked ... |
| [`tool-categories-roadmap`](./decisions/architecture/tool-categories-roadmap.md) | - | The locked list of 15 tool subdomains: 8 Tier 1 (ship working day 1) + 7 Tier 2 (stub day 1, fill in later). Tier 3 is explicitly skipped. Anti-list captures categories deliberately rejected (URL shorteners, AI image gen, etc.). |
| [`tool-feature-scopes-2026-06-22`](./decisions/architecture/tool-feature-scopes-2026-06-22.md) | active | Final feature scope per tool app. All tools are 100% client-side (no server, no upload). Heavy features deferred to v1+ where bundle size would blow budget. Per-app feature list grilled and locked 2026-06-22. |
| [`tools-shape-and-priority`](./decisions/architecture/tools-shape-and-priority.md) | active | 16 tool apps, each at its own *.oriz.in subdomain (paisa, slice, scribe, pixie, grid, forge, shift, dice, cipher, paper, vitals, rank, reel, echo, pivot + remainder). Anonymous-first auth. Free + opt-in sponsor footer. Affiliate allowed ... |
| [`tools-site-15-repos`](./decisions/architecture/tools-site-15-repos.md) | - | Each tool category is its own GitHub repo (pdf-site, image-site, ...) deployed to its own Cloudflare Pages project at <category>.oriz.in. No tools-site monorepo. Picked over 'one repo, 15 subdomain builds' for portfolio framing and SEO c... |
| [`url-shortener-mitigation-tiers`](./decisions/architecture/url-shortener-mitigation-tiers.md) | active | Three-tier URL shortener stack, all free, no card. Tier 1: self-hosted s.oriz.in CF Worker (primary, edge-cached 301s). Tier 2: TinyURL API (fallback, unlimited free, no auth, no card). Tier 3: GitHub Gist HTML meta-refresh redirect (zer... |
| [`url-shortener-quota-mitigation`](./decisions/architecture/url-shortener-quota-mitigation.md) | active | s.oriz.in is a Cloudflare Worker. Free tier is 100K requests/day per script. We send `Cache-Control: public, max-age=31536000, immutable` on every 301 redirect so CF's edge caches the redirect itself; subsequent visitors hit the cache, n... |
| [`userscript-prototype-via-tweeks`](./decisions/architecture/userscript-prototype-via-tweeks.md) | active | For new userscript ideas, use Tweeks (YC-backed AI browser extension at tweeks.io that generates per-site JS from plain English) as a fast in-browser PROTOTYPE. If the result is keepable, copy the generated JS, port to a proper Tampermon... |
| [`utm-attribution-strategy`](./decisions/architecture/utm-attribution-strategy.md) | active | Marketing attribution rides on UTM query parameters injected into outbound links, captured by PostHog + Cloudflare Web Analytics. No paid attribution tool, no SaaS click-tracker, no bounce-redirect domain. oriz-kit ships <UtmLink> to enf... |
| [`voice-sms-deferred-to-knock`](./decisions/architecture/voice-sms-deferred-to-knock.md) | active | No standalone voice or SMS provider in 2026-06-20. Twilio + Vonage rejected on card-on-file grounds. If/when SMS becomes needed, the family routes it through Knock's bundled SMS channel — already locked as the multi-channel notification ... |

## Decisions - Other (84 total)

### Branding (11)

| File | Status | Description |
|---|---|---|
| [`family-wide-privacy-page`](./decisions/branding/family-wide-privacy-page.md) | active | Locked 2026-06-20: master oriz.in publishes a single canonical /privacy that the entire family (sites + extensions + workers + CLIs) references. Per-surface addenda (extension permission lists, site-specific data flows) live as nested pa... |
| [`github-repo-naming-best-practices`](./decisions/branding/github-repo-naming-best-practices.md) | active | Single source covering every naming rule across v5 + v6 + the web-search-derived best practices. Use this file to check a proposed repo name before gh repo create. |
| [`i18n-weblate-when-ready`](./decisions/branding/i18n-weblate-when-ready.md) | active | The family stays English-only until a site or extension shows real non-English demand. When that day comes, Weblate Hosted Libre is the chosen translation-management platform. |
| [`keep-oriz-org-recruiter-via-pinning`](./decisions/branding/keep-oriz-org-recruiter-via-pinning.md) | active | The 'recruiter won't see my work because it's on oriz-org' worry is solved by PINNING oriz-org repos on chirag127's profile (they appear as your work on chirag127's page, with link to oriz-org for click-through) + cross-linking chirag127... |
| [`naming-policy-v6`](./decisions/branding/naming-policy-v6.md) | active | Repos follow oriz-<product-brand>-<category>-<suffix> format. Family brand is single, family-wide (`oriz`), Google-style. Product brand inserted per product. Existing astro-*-npm-pkg packages keep current names. Workspace umbrella keeps ... |
| [`omnipost-name`](./decisions/branding/omnipost-name.md) | active | The family's RSS-driven cross-poster is named @chirag127/oriz-omnipost — palette: omni- prefix + post; user said 'name omnipotent'. One button to broadcast every blog post to every supported platform. |
| [`oriz-me-added-to-family`](./decisions/branding/oriz-me-added-to-family.md) | active | On 2026-06-19, oriz-me (me.oriz.in — personal digital twin / lifestream) was added as a submodule under sites/, bringing the site count to 11. |
| [`oriz-org-rename-from-co`](./decisions/branding/oriz-org-rename-from-co.md) | active | The GitHub org created 2026-06-22 as oriz-co is renamed to oriz-org because oriz-org reads more naturally as 'oriz the organization' and is available. GitHub auto-redirects oriz-co/* URLs to oriz-org/*; all 23 tracked references (.gitmod... |
| [`repo-naming-suffixes`](./decisions/branding/repo-naming-suffixes.md) | active | Every site repo is named <subdomain-prefix>-site (the subdomain prefix on oriz.in, suffixed with -site). Browser extensions get -bs-ext (revised 2026-06-24 from -ext to match the bs-ext/ folder convention), VS Code extensions -vsc-ext, C... |
| [`title-case-oriz`](./decisions/branding/title-case-oriz.md) | active | User-facing brand mark is rendered Title-Case as 'Oriz'. Repo slugs, npm package names, DOM attributes, and code identifiers stay lowercase (`oriz-*`, `@chirag127/oriz-*`, `data-oriz-*`). |

#### naming (1)

| File | Status | Description |
|---|---|---|
| [`policy-family-naming-policy`](./decisions/branding/naming/policy-family-naming-policy.md) | - | GitHub repo slug = npm package name (when both exist). Subdomains are independent and shorter. Role-suffix every repo. No brand prefix on new repos. -mcp added to the suffix matrix. |

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
| [`_family-rules`](./decisions/design/_family-rules.md) | active | The cross-site design contract: surface distribution, typeface budget, accent colour distribution, no-compromise briefs, and universal constraints across all 11 oriz-* sites. |
| [`datasheet-dark`](./decisions/design/datasheet-dark.md) | active | Every chirag127 site, extension, and CLI doc page shares one locked dark design system — Oriz Datasheet Dark — with monospace display, ledger-paper text, burnt-sienna stamp accent, and identical 4-region chrome. |
| [`oriz-blog`](./decisions/design/oriz-blog.md) | active | An engineer's working notebook — cream paper, Fraunces drop-cap, cobalt accent, series-spine signature glyph, no card grid, no hero images. |
| [`oriz-book-lore`](./decisions/design/oriz-book-lore.md) | active | Aged-cream reading-room surface with pencil-red marginalia, bottle-green narration ribbon, brass page numbers — the 'old book that lived on a desk' metaphor. |
| [`oriz-books`](./decisions/design/oriz-books.md) | active | NCERT textbook directory rendered as a library catalogue drawer: ink-block desk, bone catalogue cards, cinnabar accent, IBM Plex Serif + Sans Devanagari. |
| [`oriz-cards`](./decisions/design/oriz-cards.md) | active | Bloomberg-terminal-for-Indian-credit-cards: cool slate surface, carbon-blue primary, vermilion only on negative numbers, wide-mono display type, CSS-rendered embossed card signature. |
| [`oriz-finance`](./decisions/design/oriz-finance.md) | active | Calculator workbench for the salaried Indian: literal printed graph-paper grid, hairline tan rules, decimal-aligned tabular numbers, graph-teal accent, Fraunces display. |
| [`oriz-home`](./decisions/design/oriz-home.md) | active | Master hub / portal route: dark leather-spine surface, monochrome until hover, mustard-yellow primary, single vermilion 'start anywhere' arrow as the affordance hint. |
| [`oriz-image-tools`](./decisions/design/oriz-image-tools.md) | active | Browser darkroom: 13 client-side image tools, dark surface, Space Grotesk display, phosphor #C8FF3C accent, the histogram is the brand. Zero uploads. |
| [`oriz-journal`](./decisions/design/oriz-journal.md) | active | Auth-gated PWA for serious journalers: dusk surface with cream entry pages, animated wax seal, seal-red accent, GT Sectra titles, libsodium client-side encryption. |
| [`oriz-me`](./decisions/design/oriz-me.md) | active | Personal site as build manifest: datasheet white, archival-blue accent, IBM Plex Sans Condensed, provenance strip with live build timestamp + 4px pulsing sync dot — the only animation on the site. |
| [`oriz-pdf-tools`](./decisions/design/oriz-pdf-tools.md) | active | Typesetter's desk for documents: cream manuscript surface, all-serif type stack (even buttons), ledger-green CTAs, vermilion reserved for redaction/destructive actions. |

### Infrastructure (11)

| File | Status | Description |
|---|---|---|
| [`chrome-extensions-as-submodules`](./decisions/infrastructure/chrome-extensions-as-submodules.md) | active | Every extension lives in its own chirag127/oriz-<name>-ext repo, added under extensions/ in the master oriz repo as a git submodule. |
| [`cloudflare-pages-for-all-sites`](./decisions/infrastructure/cloudflare-pages-for-all-sites.md) | active | Every website and every app in the family — content sites, tool apps, hub apps, personal apps, the extensions catalog — deploys to Cloudflare Pages free. No exceptions. Firebase Hosting, Vercel, Netlify, GitHub Pages-as-primary all rejec... |
| [`extension-auth-firebase-plus-license-key`](./decisions/infrastructure/extension-auth-firebase-plus-license-key.md) | active | Extensions authenticate users via Firebase Auth (chrome.identity.launchWebAuthFlow + auth.oriz.in); a license-key fallback exists for paranoid privacy users who refuse Firebase. |
| [`extensions-cross-store-publish`](./decisions/infrastructure/extensions-cross-store-publish.md) | active | Each extension repo includes an automated GitHub Actions publish workflow that submits the same artifact to Chrome Web Store, Firefox Add-ons, and Microsoft Edge Add-ons. |
| [`firebase-spark-forever`](./decisions/infrastructure/firebase-spark-forever.md) | active | Firebase usage is permanently capped to the Spark plan. Blaze is excluded by the no-card-on-file rule and documented bill-shock incidents. |
| [`flat-subdomain-pattern`](./decisions/infrastructure/flat-subdomain-pattern.md) | active | Locked 2026-06-23. Every public-facing repo in the family (apps, npm packages, books, skills, extensions) gets a flat <slug>.oriz.in custom subdomain. APIs keep their existing *.api.oriz.in shape (grandfathered, GH Pages Let's Encrypt SS... |
| [`github-pages-mirror-per-site`](./decisions/infrastructure/github-pages-mirror-per-site.md) | active | Each site's CI builds a static fallback to chirag127.github.io/<site> on every push to main, so /work + /me + /legal stay live if the primary host dies. |
| [`hookdeck-for-webhook-reliability`](./decisions/infrastructure/hookdeck-for-webhook-reliability.md) | active | Hookdeck queues Razorpay webhooks → forwards to api.oriz.in Worker, with retries + replay. 100K req/mo free, no card. |
| [`monitor-apex-only`](./decisions/infrastructure/monitor-apex-only.md) | active | SSL + uptime monitoring is configured for the apex domain only. *.oriz.in subdomains inherit via Cloudflare auto-rotation. |
| [`spaceship-registrar-cloudflare-dns`](./decisions/infrastructure/spaceship-registrar-cloudflare-dns.md) | active | Family domains stay at Spaceship (the user's existing registrar). NS records delegate DNS to Cloudflare. Cloudflare Email Routing forwards every address into a single Gmail inbox. |
| [`subdomains-under-oriz-in`](./decisions/infrastructure/subdomains-under-oriz-in.md) | active | Every site, extension, and API endpoint binds to a subdomain under oriz.in — never to a separate apex domain. |

### Monetisation (7)

| File | Status | Description |
|---|---|---|
| [`adsense-apex-application`](./decisions/monetisation/adsense-apex-application.md) | active | One AdSense application for the oriz.in apex covers every subdomain; if rejected, the fallback order is Ezoic, then Mediavine, then other ad networks. |
| [`max-payment-methods`](./decisions/monetisation/max-payment-methods.md) | active | Locked decision: every paid surface accepts the maximum viable set of payment methods — Razorpay for India, Lemon Squeezy for international, keygen.sh for license fulfilment, plus six donation rails on /support. |
| [`no-subscriptions-anywhere`](./decisions/monetisation/no-subscriptions-anywhere.md) | active | Hard constraint: every external service used across the oriz family must work indefinitely on its free tier. Subscription-walled providers are excluded at selection time. |
| [`one-subscription-unlocks-all`](./decisions/monetisation/one-subscription-unlocks-all.md) | active | Single Razorpay-driven subscription stored in Firestore as users/{uid}/subscription unlocks paid features across the entire family — sites and extensions. |
| [`per-surface-recommendations`](./decisions/monetisation/per-surface-recommendations.md) | active | Per-distribution-surface picks: which payment rail to use for Play Store AABs, Microsoft Store MSIX, Chrome/Firefox/Edge extensions, web PWAs, books, blog, newsletter. Derived from playbook-no-card-rails.md; this is the cookbook view. |
| [`playbook-no-card-rails`](./decisions/monetisation/playbook-no-card-rails.md) | active | Master matrix of every viable monetisation rail for the oriz family in 2026, filtered by the hard no-card-on-file rule. Each row marks card-required Y/N (with source URL), revenue cut, region, setup friction, and best-fit surface. Replac... |
| [`razorpay-as-primary-billing`](./decisions/monetisation/razorpay-as-primary-billing.md) | active | Razorpay is the primary billing/checkout provider; Stripe, Lemon Squeezy, and Paddle are documented fallbacks if Razorpay rejects the merchant or dies. |

### Policy (15)

| File | Status | Description |
|---|---|---|
| [`age-gating`](./decisions/policy/age-gating.md) | active | Adult-content sections across the family require an 18+ cookie attestation with 365-day expiry. Annual jurisdictional review. |
| [`archive-allowlist`](./decisions/policy/archive-allowlist.md) | active | Audit-trail allowlist of every chirag127 repo that any archive script (or any future cleanup automation) MUST refuse to touch. Built from .gitmodules + npm publications + manual hand-adds for load-bearing infrastructure. Read by scripts/... |
| [`commercial-use`](./decisions/policy/commercial-use.md) | active | What counts as commercial intent on Cloudflare Pages, GitHub Pages, and the apex; checkout flows happen on api.oriz.in or razorpay.com, never on landing pages. |
| [`data-canonical-store`](./decisions/policy/data-canonical-store.md) | active | The chirag127/oriz-me-data git repo is the authoritative store for lifestream events. Firestore / Turso / R2 are caches rebuilt from git on every deploy. |
| [`forked-extension-cws-rules`](./decisions/policy/forked-extension-cws-rules.md) | active | GPL-3.0 forks (e.g. DeArrow) can be re-shipped to the Chrome Web Store under our developer account if we (1) keep GPL-3.0, (2) state it's a modified version in listing + about, (3) use a different name + icons, (4) host our own backend O... |
| [`ingester-contract`](./decisions/policy/ingester-contract.md) | active | Every lifestream / data ingester satisfies six properties: idempotent, backfill-capable, 7-day auto-pause, status-reporting, bounded execution, no inline secrets. |
| [`journal-not-public`](./decisions/policy/journal-not-public.md) | active | me.oriz.in publishes only numeric aggregates from the journal — entry count, streak, monthly word count. The journal text itself stays auth-gated at journal.oriz.in. |
| [`monetisation-channel-matrix`](./decisions/policy/monetisation-channel-matrix.md) | active | Single canonical matrix mapping every publish/distribute channel in the oriz family to its allowed monetisation strategy. Locks where affiliate is allowed, where it is forbidden (organic-only channels, public-health apps), and where reve... |
| [`monetisation`](./decisions/policy/monetisation.md) | active | One AdSense application for the oriz.in apex; all subdomains inherit. No ad-slot divs in markup — ads inject at runtime over organic layout. |
| [`no-paid-tier`](./decisions/policy/no-paid-tier.md) | active | No service the family depends on may require a paid subscription or card on file. Free-tier walls fail closed gracefully. |
| [`privacy-policy-per-extension`](./decisions/policy/privacy-policy-per-extension.md) | active | Each Chrome extension has its own /privacy page tailored to its permissions. A family boilerplate at oriz.in/privacy-base supplies common content. |
| [`private-repos-excluded-from-mirror-cron`](./decisions/policy/private-repos-excluded-from-mirror-cron.md) | active | The .github/workflows/mirror-all.yml cron pushes every public repo from oriz-org + chirag127 to 6 mirror hosts. Private repos (oriz-org/secrets and any other isPrivate=true repo) are FILTERED OUT at discovery time via gh-list's isPrivate... |
| [`public-private-line`](./decisions/policy/public-private-line.md) | active | Four tiers govern every piece of content across the family: public, age-gated-18, aggregates-only, private. Inner-life metrics surface only as weekly aggregates. |
| [`secrets-handling`](./decisions/policy/secrets-handling.md) | active | Every secret comes from envpact. If a secret is ever pasted into chat, treat it as compromised: revoke, rotate, re-store, redeploy. |
| [`tweeks-personal-use-only`](./decisions/policy/tweeks-personal-use-only.md) | active | Tweeks (chromewebstore.google.com/detail/fmkancpjcacjodknfjcpmgkccbhedkhc) is a closed-source proprietary commercial Chrome extension by NextByte (YC-backed, tweeks.io). It has NO open-source license. Personal modification + loading as a... |

### Pricing (1)

| File | Status | Description |
|---|---|---|
| [`three-tier-free-pro-max`](./decisions/pricing/three-tier-free-pro-max.md) | active | Replaces the two-tier (Ad-free + Pro) decision the same day. User mandate (2026-06-22): 3 tiers (Free / Pro / Max), agent decides the feature split, manual work is MINIMUM, everything controlled from a single package (`@chirag127/astro-b... |

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
| [`anti-bot-defense-in-depth`](./decisions/security/anti-bot-defense-in-depth.md) | active | Locked 2026-06-20: three layers of bot defense, each at a different stage. (1) Cloudflare WAF + Bot Fight Mode at the edge blocks known-bad before it reaches a Worker. (2) Turnstile at the form-submit boundary gates contact + auth flows.... |
| [`captcha-turnstile-plus-hcaptcha`](./decisions/security/captcha-turnstile-plus-hcaptcha.md) | active | Cloudflare Turnstile is the family's primary CAPTCHA; hCaptcha is the auto-detected regional fallback. Single <Captcha> component in oriz-kit performs the swap transparently. |
| [`consent-management-multi-category`](./decisions/security/consent-management-multi-category.md) | active | Locks the family's multi-category consent management. Klaro defines 5 categories (necessary / analytics / marketing / functional / social) with a per-service map. EU/UK shows banner default-DENIED; US/CA shows banner default-ACCEPTED wit... |
| [`cookie-banner-policy`](./decisions/security/cookie-banner-policy.md) | active | Default posture is NO cookie banner — Cloudflare Web Analytics is cookie-less and GDPR-safe. Klaro is lazy-loaded ONLY when (a) a page loads a cookie-issuing tracker (GA4 / PostHog identified) AND (b) the visitor is in EU/UK per CF-IPCou... |
| [`domain-registrar-exception-spaceship`](./decisions/security/domain-registrar-exception-spaceship.md) | active | oriz.in is registered at Spaceship with a card-on-file for auto-renewal. This is a deliberate, documented exception to the no-card-on-file rule. Reason: .in TLD renewals at every registrar require either a card-on-file (auto-renew) or an... |
| [`env-and-secrets-single-source`](./decisions/security/env-and-secrets-single-source.md) | active | Two-track lock for managing env vars across the family. Track A: PUBLIC .env.example files synced from master templates/.env.example to every repo (no real values). Track B: PRIVATE GitHub Actions secrets set ONCE at chirag127 org level ... |
| [`env-single-source-auto-push`](./decisions/security/env-single-source-auto-push.md) | active | User mandate 2026-06-22 evening: minimum manual env-var setting. Master `c:/D/oriz/.env` is the single source of truth for every env var used by every app, package, API, extension, CLI, MCP server, skill, book pipeline, and CI workflow i... |
| [`env-three-file-split`](./decisions/security/env-three-file-split.md) | active | Single key namespace, three value files split by NODE_ENV. .env holds shared defaults + public keys; .env.development holds TEST values (Razorpay test keys, dev URLs); .env.production holds LIVE values (Razorpay live keys, prod URLs at o... |
| [`multi-provider-auth`](./decisions/security/multi-provider-auth.md) | active | The family's Firebase Auth project enables 6 sign-in providers: Email link, Google, GitHub, Anonymous, Microsoft (NEW), Passkeys/WebAuthn (NEW). Apple is deferred until the iOS app ships. |
| [`secrets-management-doppler`](./decisions/security/secrets-management-doppler.md) | active | Adopt Doppler as the single place every family secret is written, rotated, and audited. GitHub Secrets, Cloudflare Worker secrets, and Firebase config are downstream mirrors synced from Doppler. |
| [`security-headers-strategy`](./decisions/security/security-headers-strategy.md) | active | Every site ships a strict CSP / HSTS preload / Permissions-Policy preset via Cloudflare _headers, sourced from @chirag127/oriz-kit. Every PR is audited by both securityheaders.com and Mozilla Observatory; PR fails if score drops below A. |
| [`sops-plus-doppler-hybrid`](./decisions/security/sops-plus-doppler-hybrid.md) | active | Sops+age remains the source of truth for the family's 65-key .env (preserves 134 lines of section comments + ordering that Doppler's flat KV model would destroy). Doppler is added as a parallel runtime-sync layer for CI fan-out only: a l... |

### Tooling (1)

| File | Status | Description |
|---|---|---|

## Runbooks (49 total)

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
| [`cf-dns-add-api-subdomain`](./runbooks/hosting/cf-dns-add-api-subdomain.md) | (no description) |
| [`cf-dns-audit-2026-06-23`](./runbooks/hosting/cf-dns-audit-2026-06-23.md) | (no description) |
| [`cf-pages-branch-deploys`](./runbooks/hosting/cf-pages-branch-deploys.md) | CF Pages caps free tier at 100 projects per account. Family has 26 apps\ |
| [`codeberg-mirror-2026-06-23`](./runbooks/hosting/codeberg-mirror-2026-06-23.md) | Set up Codeberg.org as a passive read-only mirror for the 60+ oriz family |
| [`git-upstream-merge-private-fork`](./runbooks/hosting/git-upstream-merge-private-fork.md) | How to clone a public Chrome extension to a private organization repository |
| [`mirror-all-hosts-setup`](./runbooks/hosting/mirror-all-hosts-setup.md) | One-time setup runbook to configure the 6-host automatic git mirror |
| [`mirror-cron-prep`](./runbooks/hosting/mirror-cron-prep.md) | Pre-flight checklist for the Friday 03:30 IST 4-host git mirror cron at `.github/workflows/mirror-all.yml`. Generate 4 host tokens with write+create-repo scope, pre-create 51 empty mirror repos on each host, store all tokens at chirag127... |

### Operations (22)

| File | Description |
|---|---|
| [`add-new-decision`](./runbooks/operations/add-new-decision.md) | The OKF self-update workflow. When the user makes an architectural / |
| [`add-new-extension`](./runbooks/operations/add-new-extension.md) | Add a new extension repo as a submodule under extensions/, set up the |
| [`add-new-site-to-family`](./runbooks/operations/add-new-site-to-family.md) | Add a new oriz-<name> repo as a submodule under sites/, register it in |
| [`add-package-to-catalog`](./runbooks/operations/add-package-to-catalog.md) | Auto-discovery means there's almost nothing to do \u2014 publish the\ |
| [`apply-per-site-ci`](./runbooks/operations/apply-per-site-ci.md) | Copy the templates/per-site-ci/ scaffold into each of the 11 site submodules |
| [`build-distributable`](./runbooks/operations/build-distributable.md) | One command per app emits all distributables \u2014 PWA on Cloudflare\ |
| [`bump-submodule-pointer`](./runbooks/operations/bump-submodule-pointer.md) | After landing a feature inside a submodule, bump the master repo''s |
| [`clean-install`](./runbooks/operations/clean-install.md) | One git clone --recursive + one pnpm install loop and the whole family |
| [`dependabot-notification-tuning`](./runbooks/operations/dependabot-notification-tuning.md) | (no description) |
| [`env-management`](./runbooks/operations/env-management.md) | Plain-English runbook for managing the single env source `c:/D/oriz/.env`.\ |
| [`github-apps-audit-2026-06-22`](./runbooks/operations/github-apps-audit-2026-06-22.md) | One-shot audit of every GitHub App installed on the chirag127 account,\ |
| [`install-and-bootstrap`](./runbooks/operations/install-and-bootstrap.md) | The chirag127/oriz family is one umbrella git repo that submodules every |
| [`install-github-apps`](./runbooks/operations/install-github-apps.md) | GitHub Apps cannot be installed via API (security policy \u2014 install\ |
| [`lifestream-auto-sources-setup`](./runbooks/operations/lifestream-auto-sources-setup.md) | One-shot deploy steps to take @chirag127/oriz-lifestream from scaffold |
| [`migrate-ci-platform`](./runbooks/operations/migrate-ci-platform.md) | Plan-B runbook for the day GitHub Actions becomes unusable (account |
| [`migrate-okf-to-new-version`](./runbooks/operations/migrate-okf-to-new-version.md) | Run when the OKF spec moves beyond v0.1. Read migration notes, update |
| [`publish-userscript-to-greasyfork`](./runbooks/operations/publish-userscript-to-greasyfork.md) | How to publish a userscript from oriz-org/userscripts to greasyfork.org. Greasy Fork has NO upload API — first version requires manual paste in the in-browser editor. After the initial paste, register a webhook so subsequent git push → a... |
| [`publish-vscode-extension-to-marketplace`](./runbooks/operations/publish-vscode-extension-to-marketplace.md) | How to ship an oriz-org/-vsc-ext repo to the VS Code Marketplace + Open VSX. One-time: create a Microsoft Publisher under your account, generate an Azure DevOps PAT with Marketplace scope, store it. Per-release: bump version, vsce packag... |
| [`rename-repo`](./runbooks/operations/rename-repo.md) | Step-by-step procedure to rename a chirag127/oriz* repo to its correct |
| [`scaffold-a-new-site`](./runbooks/operations/scaffold-a-new-site.md) | Step-by-step to add a new Astro site to the family in <10 minutes. Clones |
| [`sync-env-example-to-all-repos`](./runbooks/operations/sync-env-example-to-all-repos.md) | Step-by-step procedure for adding / removing / renaming a family-wide |
| [`visual-audit-2026-06-22`](./runbooks/operations/visual-audit-2026-06-22.md) | (no description) |

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

## Services (171 total)

### A11Y (3)

| File | Description |
|---|---|
| [`axe-core`](./services/a11y/axe-core.md) | Industry-standard a11y rule engine, run via @axe-core/playwright in CI. Static-rule WCAG checks on every PR. Free, OSS. |
| [`lighthouse-ci`](./services/a11y/lighthouse-ci.md) | Lighthouse score + a11y + perf budgets enforced per PR. Free GitHub App posts the score as a PR comment. |
| [`pa11y`](./services/a11y/pa11y.md) | Dynamic a11y test runner — different ruleset from axe (HTML_CodeSniffer + axe). Free CLI in PR CI. |

### Ads (2)

| File | Description |
|---|---|
| [`ezoic`](./services/ads/ezoic.md) | Fallback ad provider — no minimum traffic. |
| [`mediavine`](./services/ads/mediavine.md) | Fallback ad provider — higher RPM but requires 50K sessions/month. |

### Ai (3)

| File | Description |
|---|---|
| [`cloudflare-workers-ai`](./services/ai/cloudflare-workers-ai.md) | Native AI inference inside the umbrella Hono Worker — 10K neurons / day free, zero-egress from api.oriz.in. Pairs with browser-side Puter.js. |
| [`openrouter`](./services/ai/openrouter.md) | LLM API gateway — DeepSeek / Llama / Moonshot free models. Rejected 2026-06-20: we use Puter.js exclusively; OpenRouter is mentioned only because Puter.js mirrors its model IDs. |
| [`puter-js`](./services/ai/puter-js.md) | Browser-side AI inference — user-pays model, free unlimited from our side. |

### Analytics (5)

| File | Description |
|---|---|
| [`cloudflare-web-analytics`](./services/analytics/cloudflare-web-analytics.md) | Privacy-friendly pageview analytics — free, no cookie banner needed. |
| [`google-analytics`](./services/analytics/google-analytics.md) | Marketing-funnel analytics — acquisition / engagement / conversion against advertiser-standard definitions. Free, no card. |
| [`microsoft-clarity`](./services/analytics/microsoft-clarity.md) | Session recording + heatmaps — no traffic limits, free forever. |
| [`posthog`](./services/analytics/posthog.md) | Product analytics + feature flags + A/B — 1M events/month free. |
| [`utm-tracking`](./services/analytics/utm-tracking.md) | Marketing attribution via UTM query parameters on every outbound link. Captured by GA4 + PostHog. Free, no service, no extra tools. |

### Auth (8)

| File | Description |
|---|---|
| [`app-check-firebase`](./services/auth/app-check-firebase.md) | Bot defense layer for Firestore — required by every security rule in the family. |
| [`clerk`](./services/auth/clerk.md) | Fallback auth — 10K MAU free. |
| [`firebase-auth`](./services/auth/firebase-auth.md) | The 6 sign-in providers wired into the family's single Firebase Auth project — Email link, Google, GitHub, Anonymous, Microsoft, Passkeys. Apple deferred until the iOS app ships. |
| [`firebase-spark`](./services/auth/firebase-spark.md) | Auth + Firestore on the free Spark plan — never upgraded to Blaze. |
| [`microsoft-sign-in`](./services/auth/microsoft-sign-in.md) | Microsoft / Entra ID OAuth provider wired into Firebase Auth — free, unlimited, no card. Aligns with the family's Azure-for-Students stack. |
| [`passkeys`](./services/auth/passkeys.md) | Passwordless WebAuthn sign-in via Firebase Auth's passkey integration (with @simplewebauthn/server escape hatch). Free, unlimited, no card. |
| [`recaptcha-enterprise`](./services/auth/recaptcha-enterprise.md) | Bot-defense assessments wired into Firebase App Check — 10K/mo free, but billing-account-linked. |
| [`supabase`](./services/auth/supabase.md) | Fallback Auth + Postgres — 500 MB DB free. |

### Cdn (1)

| File | Description |
|---|---|
| [`jsdelivr`](./services/cdn/jsdelivr.md) | npm + GitHub package CDN. Browser-side imports of @chirag127/oriz-kit served at cdn.jsdelivr.net. Free, unlimited, no card. |

### Code Embed (3)

| File | Description |
|---|---|
| [`codepen`](./services/code-embed/codepen.md) | CSS-heavy front-end demos embedded via script. Free unlimited public pens, no card. |
| [`github-gists`](./services/code-embed/github-gists.md) | Static code snippets embedded via script. Free unlimited public gists, no card. |
| [`stackblitz`](./services/code-embed/stackblitz.md) | Full-stack browser sandboxes — embedded in oriz-blog-site posts via iframe. Free unlimited public projects, no card. |

### Code Quality (9)

| File | Description |
|---|---|
| [`codeclimate`](./services/code-quality/codeclimate.md) | Maintainability scoring — Code Climate's 'A through F' grade per file, free for public repos. Catches technical-debt patterns biome / Sonarcloud surface differently. |
| [`codecov`](./services/code-quality/codecov.md) | Coverage tracking for every PR — uploads LCOV from Vitest, posts coverage delta as a check, free unlimited for public repos. |
| [`coderabbit`](./services/code-quality/coderabbit.md) | AI code review on every PR. Free forever for OSS / public repos. Catches logic bugs and security smells biome misses. |
| [`deepsource`](./services/code-quality/deepsource.md) | Static analysis with autofix — JS/TS/Python/Go rule set, free unlimited for public repos. Catches issues with one-click PRs. |
| [`dependabot`](./services/code-quality/dependabot.md) | Automated dependency security updates. GitHub-native, free for all repos public + private, opens PRs when CVEs drop. |
| [`github-insights`](./services/code-quality/github-insights.md) | Native repo insights — contributors, commits-over-time, code frequency, dependents, traffic. Free, native to every public repo, auto-tracked. Used as a code-stats source for the family /stats page. |
| [`lines-of-code-badge`](./services/code-quality/lines-of-code-badge.md) | Auto-generated `<!-- TODO: broken link, was [![Lines of Code](badge.svg) -->]` badge in every family repo's README. GitHub Action runs on push, recomputes line count, commits the badge SVG. Free, OSS, auto-tracked. |
| [`sonarcloud`](./services/code-quality/sonarcloud.md) | Deeper static analysis — SAST, code smells, duplication, complexity, coverage. Free for OSS. Catches issues biome can't. |
| [`tokei`](./services/code-quality/tokei.md) | Rust CLI that counts lines of code by language — files, lines, blanks, comments, code. Run in CI; output JSON → publish to family /stats page. OSS, no card. |

### Comments (1)

| File | Description |
|---|---|
| [`giscus`](./services/comments/giscus.md) | GitHub-Discussions-backed comments — free forever, no card. Click-to-load privacy posture, light/dark theme aware. |

### Compute (3)

| File | Description |
|---|---|
| [`cloudflare-r2`](./services/compute/cloudflare-r2.md) | S3-compatible object storage with no egress fees — 10 GB free. |
| [`cloudflare-workers`](./services/compute/cloudflare-workers.md) | Edge compute for the Hono Worker at api.oriz.in — fails-closed at the free quota. |
| [`github-actions`](./services/compute/github-actions.md) | Build-time cron + CI runner — free for public repos, the family's scheduled-job substrate. |

### Cron (2)

| File | Description |
|---|---|
| [`cloudflare-cron-triggers`](./services/cron/cloudflare-cron-triggers.md) | In-Worker scheduled jobs — sub-second invocation, free unlimited, runs in the same runtime as api.oriz.in. |
| [`github-actions-schedule`](./services/cron/github-actions-schedule.md) | Build- and publish-shaped scheduled jobs on GitHub Actions — free unlimited minutes for public repos (the family runs 100% public). |

### Data Api (2)

| File | Description |
|---|---|
| [`alpha-vantage`](./services/data-api/alpha-vantage.md) | Free finance / market-data API. 25 requests/day + 5/minute on the free tier, no card required. API key needed (free signup). Locked as the family's market-data source for oriz-finance and any future stock / forex / crypto surface. |
| [`open-meteo`](./services/data-api/open-meteo.md) | Free unlimited weather API. No auth, no API key, no card. Documented as the family's locked weather data source for any future site that needs forecast / current-conditions / historical weather. |

### Database (2)

| File | Description |
|---|---|
| [`neon-postgres`](./services/database/neon-postgres.md) | Serverless Postgres for relational workloads — free tier confirmed no card, scale-to-zero, branching for previews. |
| [`turso`](./services/database/turso.md) | Read-only warm cache for lifestream events — replicas at the edge, free tier. |

### Dev Tools (2)

| File | Description |
|---|---|
| [`cloudflare-tunnel`](./services/dev-tools/cloudflare-tunnel.md) | Free Cloudflare-native local-to-public tunnel. Exposes localhost on a persistent *.oriz.in hostname for webhook testing during development. No card, no quota cliff, no anonymous-session TTL. |
| [`wrangler`](./services/dev-tools/wrangler.md) | Cloudflare's official CLI for Workers / Pages / KV / R2 / D1 / Queues development and deployment. Local mode runs in workerd; remote mode runs against real Cloudflare infrastructure. Free as part of the Cloudflare account. |

### Domain (4)

| File | Description |
|---|---|
| [`cloudflare-dns`](./services/domain/cloudflare-dns.md) | DNS host for oriz.in and every subdomain — free, fast, and the same dashboard as everything else. |
| [`cloudflare-email-routing`](./services/domain/cloudflare-email-routing.md) | Free email forwarder — *@oriz.in, *@oriz.me, and every extension subdomain forward into a single Gmail inbox. |
| [`cloudflare-registrar`](./services/domain/cloudflare-registrar.md) | Domain registrar at wholesale cost — no markup, free WHOIS privacy. |
| [`spaceship`](./services/domain/spaceship.md) | Existing domain registrar — chirag127 holds family domains here. NS records delegate to Cloudflare DNS; email forwards via Cloudflare Email Routing → Gmail. |

### Email (4)

| File | Description |
|---|---|
| [`buttondown`](./services/email/buttondown.md) | Developer-friendly newsletter — Markdown native, API-first, 100 subscribers free. Used as the technical-blog digest sender. |
| [`email-octopus`](./services/email/email-octopus.md) | Marketing email + newsletter — 2.5K subscribers / 10K emails per month free. Used for general / marketing audiences; Buttondown handles the technical-blog digest. |
| [`mailerlite`](./services/email/mailerlite.md) | Fallback marketing email / newsletter — 1K subs free. |
| [`resend`](./services/email/resend.md) | Transactional email API — 3K/month free, isolated behind @chirag127/email-send. |

### Extension Store (5)

| File | Description |
|---|---|
| [`chrome-web-store`](./services/extension-store/chrome-web-store.md) | Browser-extension distribution channel for Chrome / Edge / Brave / Opera / Vivaldi / Arc / Zen. $5 one-time developer fee (sunk cost — NOT a subscription, still meets free-forever rule). chrome-webstore-upload via GitHub Actions for CI a... |
| [`edge-add-ons`](./services/extension-store/edge-add-ons.md) | Microsoft's add-on store via Partner Center. Free unlimited, no developer fee, no card. CI flow uses the Edge Add-ons partner-center API. |
| [`firefox-add-ons`](./services/extension-store/firefox-add-ons.md) | Mozilla's add-on store. Free unlimited submissions, no registration fee, no card. CI flow uses web-ext + AMO submit API. |
| [`open-vsx-registry`](./services/extension-store/open-vsx-registry.md) | Eclipse Foundation's vendor-neutral VS Code extension registry. Used by VSCodium, Cursor, Theia, Gitpod, code-server. Free OSS, no card. Publish via ovsx. |
| [`vs-code-marketplace`](./services/extension-store/vs-code-marketplace.md) | Microsoft's official VS Code extension marketplace. Free unlimited, no developer fee. Publish via vsce. |

### Forms (4)

| File | Description |
|---|---|
| [`formspree`](./services/forms/formspree.md) | Fallback contact-form backend — 50 submissions/month free. |
| [`static-forms`](./services/forms/static-forms.md) | Form-submission backend — fallback to Web3Forms. Free unlimited submissions. No card. Different vendor + edge so a Web3Forms outage / quota cliff never takes contact forms down. |
| [`tally`](./services/forms/tally.md) | Rich form builder — surveys, waitlists, payment collection. Unlimited forms + submissions free. |
| [`web3forms`](./services/forms/web3forms.md) | Browser-only contact form backend — domain-bound access key, no server, free unlimited. |

### Hosting (11)

| File | Description |
|---|---|
| [`azure-devops-mirror`](./services/hosting/azure-devops-mirror.md) | Azure DevOps Repos is mirror host #5. Microsoft-managed, unlimited private\ |
| [`bitbucket-mirror`](./services/hosting/bitbucket-mirror.md) | Bitbucket Cloud (Atlassian) is mirror host #3. Free: unlimited private\ |
| [`cloudflare-pages`](./services/hosting/cloudflare-pages.md) | Primary static host for every oriz site — unlimited bandwidth, free forever. |
| [`codeberg-mirror`](./services/hosting/codeberg-mirror.md) | Codeberg.org (Forgejo) is mirror host #2. FOSS-mission non-profit git\ |
| [`firebase-hosting`](./services/hosting/firebase-hosting.md) | REJECTED — Spark daily bandwidth cap shifted to 360 MB/day shared, too tight. |
| [`gitflic-mirror`](./services/hosting/gitflic-mirror.md) | GitFlic.ru is mirror host #4. Russian-hosted git platform with free |
| [`github-pages`](./services/hosting/github-pages.md) | Survival fallback static host — the second-account-equivalent every oriz site mirrors to. |
| [`gitlab-mirror`](./services/hosting/gitlab-mirror.md) | GitLab.com is mirror host #1. Every repo in oriz-org and chirag127 is\ |
| [`netlify`](./services/hosting/netlify.md) | Fallback static host — free starter tier. |
| [`vercel`](./services/hosting/vercel.md) | Fallback static host — free hobby tier. |

### I18N (2)

| File | Description |
|---|---|
| [`tolgee`](./services/i18n/tolgee.md) | REJECTED — i18n deferred until a site genuinely needs it; English-only family for now. |
| [`weblate-hosted-libre`](./services/i18n/weblate-hosted-libre.md) | Web-based translation management platform — free for libre / open-source projects. Picked as the family's i18n tool for if/when sites or extensions add non-English audiences. |

### Image Cdn (3)

| File | Description |
|---|---|
| [`cloudflare-images`](./services/image-cdn/cloudflare-images.md) | Primary image CDN — first link in the 3-tier fallback chain. Free tier shipped with Cloudflare Pages, no card. |
| [`imagekit`](./services/image-cdn/imagekit.md) | Final link in the 3-tier image-CDN fallback chain — 20 GB/mo bandwidth + DAM features, no card. |
| [`wsrv-nl`](./services/image-cdn/wsrv-nl.md) | Public URL-transform image proxy — second link in the 3-tier fallback chain. No signup, no auth, no card. |

### Image Host (4)

| File | Description |
|---|---|
| [`github-user-content`](./services/image-host/github-user-content.md) | Tier 4 image origin — push images to a dedicated `assets` branch of any family repo and hot-link from raw.githubusercontent.com. Free unlimited; rare-use tier for > 25 MB assets and large animated GIFs. |
| [`imgbb`](./services/image-host/imgbb.md) | Tier 2 image origin — free unlimited image hosting + REST upload API, no card. |
| [`imgur`](./services/image-host/imgur.md) | Tier 3 image origin — free unlimited image hosting + REST upload API, no card. Mirror of Tier 2 ImgBB for hot-link backup. |
| [`repo-hosted-cf-pages`](./services/image-host/repo-hosted-cf-pages.md) | Tier 1 image origin — static image files committed to each site's repo, served from Cloudflare Pages alongside the rest of the site. |

### Legal (1)

| File | Description |
|---|---|
| [`privacy-page`](./services/legal/privacy-page.md) | Self-built family-wide privacy page hosted on oriz.in. Single canonical /privacy URL every site, extension, and CLI references with optional per-surface addendum. Free — runs on existing Cloudflare Pages, no third-party tool, no card. |

### Monitoring (7)

| File | Description |
|---|---|
| [`better-stack-logs`](./services/monitoring/better-stack-logs.md) | Log aggregation + 30-day retention + searchable + alertable. 3 GB/mo free. Same Better Stack account as the family's status page + uptime monitors — three products, one account. |
| [`better-stack`](./services/monitoring/better-stack.md) | Uptime monitoring + status page — 10 monitors free. |
| [`cloudflare-workers-tail`](./services/monitoring/cloudflare-workers-tail.md) | Live tail of Worker console output via wrangler tail. Free, included with Cloudflare Workers. Sub-100ms request → terminal. ~5 min retention (WebSocket session) — for active debugging only. |
| [`glitchtip`](./services/monitoring/glitchtip.md) | Error tracking — Sentry SDK compatible, 1K events/month free, self-hostable. Rejected 2026-06-20 in favour of Sentry. |
| [`healthchecks-io`](./services/monitoring/healthchecks-io.md) | Heartbeat / dead-man's-switch monitoring for ingesters — 20 checks free. |
| [`instatus`](./services/monitoring/instatus.md) | Redundant status page at status-backup.oriz.in — kicks in if Better Stack itself is down. Free 5 components / 25K subscribers, no card. |
| [`sentry`](./services/monitoring/sentry.md) | Primary error tracking across the family — best-in-class integrations. 5K events/month + env-var per-site toggle to stay under quota. |

### Payment (12)

| File | Description |
|---|---|
| [`buymeacoffee`](./services/payment/buymeacoffee.md) | Creator donations — 5% platform fee, no monthly subscription. Sits alongside Ko-fi for donor choice. |
| [`crypto-bitcoinaddr`](./services/payment/crypto-bitcoinaddr.md) | Plain crypto wallet addresses for tip-style donations — no KYC, tax-reportable. |
| [`github-sponsors`](./services/payment/github-sponsors.md) | GitHub-native developer donations — recurring + one-off, zero platform fees. |
| [`keygen-sh`](./services/payment/keygen-sh.md) | License-key fulfilment service — issues + validates keys for VS Code extensions, browser extensions premium tier, npm SDK paid tier. |
| [`ko-fi`](./services/payment/ko-fi.md) | Creator donations — 0% platform fee on free tier; PayPal or Stripe payout. |
| [`lemon-squeezy`](./services/payment/lemon-squeezy.md) | Merchant-of-record checkout for non-Indian buyers — auto VAT/GST, card + Apple Pay + Google Pay. |
| [`liberapay`](./services/payment/liberapay.md) | Recurring-donation-only platform — weekly/monthly donations, 0% platform fee, OSS, no card. |
| [`opencollective`](./services/payment/opencollective.md) | Transparent fund accounting for OSS / community projects — every transaction public, fiscal-host model, free for OSS, 5% platform fee for non-OSS. |
| [`paypal-me`](./services/payment/paypal-me.md) | Personal PayPal payment-link — friends-and-family free, goods-and-services percent fee. |
| [`polar-sh`](./services/payment/polar-sh.md) | OSS-friendly checkout — Stripe-backed merchant-of-record for digital products + subscriptions + donations; lower fees than Lemon Squeezy. |
| [`razorpay`](./services/payment/razorpay.md) | India-first subscription provider — UPI, cards, netbanking, wallets, EMI, pay-later — webhook-driven entitlement. |
| [`upi-direct`](./services/payment/upi-direct.md) | Static UPI QR + handle for Indian-resident inbound — zero fees, instant settlement. |

### Perf (1)

| File | Description |
|---|---|
| [`vercel-speed-insights`](./services/perf/vercel-speed-insights.md) | Real-User Monitoring for Web Vitals across every site. Free tier on every site, no Vercel hosting required — works on Cloudflare Pages. |

### Productivity (2)

| File | Description |
|---|---|
| [`toggl-track`](./services/productivity/toggl-track.md) | REJECTED 2026-06-20 — manual time tracker. Walked back the same day it was adopted: violates the new auto-only-tracking rule. Wakatime stays as the sole time-tracking pick (auto via IDE plugin); non-coding time is intentionally NOT track... |
| [`wakatime`](./services/productivity/wakatime.md) | Free auto-tracking of coding time via IDE plugin. Captures language / project / file / branch breakdowns automatically. Free rolling-2-week history; recruiter-facing public dashboard at wakatime.com/@chirag127. REST API for future lifest... |

### Push (2)

| File | Description |
|---|---|
| [`fcm`](./services/push/fcm.md) | Web push transport — browser/PWA push notifications across the family. Free unlimited on Spark, no card. Knock layered on top for multi-channel orchestration. |
| [`knock`](./services/push/knock.md) | Multi-channel notification orchestration — in-app + email + SMS + web push from one workflow. Free 10K notifs/month, no card. Layered on top of FCM for delivery. |

### Pwa (1)

| File | Description |
|---|---|
| [`vite-pwa-astro`](./services/pwa/vite-pwa-astro.md) | Astro-native PWA integration. Generates manifest.webmanifest, service worker, install prompt, and offline cache at build. Free OSS, no backend, no card. |

### Queue (4)

| File | Description |
|---|---|
| [`cloudflare-queues`](./services/queue/cloudflare-queues.md) | Primary durable queue — native to Workers, 1M ops/month free, no card. |
| [`hookdeck`](./services/queue/hookdeck.md) | Webhook-ingress reliability layer in front of the Cloudflare Queues consumer. 50K events/mo free, no card. Same Hookdeck account documented in services/tooling/hookdeck.md — this file documents the queue-facing role. |
| [`inngest`](./services/queue/inngest.md) | Deferred queue alternative — durable workflows + step functions, generous free tier, no card. Held in reserve if Cloudflare Queues' simple model is outgrown. |
| [`upstash-qstash`](./services/queue/upstash-qstash.md) | Deferred queue alternative — HTTP message queue, 500 messages/day free, no card. Held in reserve if Cloudflare Queues hits a quota cliff. |

### Search (3)

| File | Description |
|---|---|
| [`algolia`](./services/search/algolia.md) | Hosted search index — used on the family's large-corpus sites (oriz-blog, oriz-books, oriz-book-lore). 1M docs + 10K searches/month free, no card. |
| [`orama-cloud`](./services/search/orama-cloud.md) | Modern in-browser vector + keyword search. Documented as a deferred future option to revisit if vector search becomes valuable. 10K docs / 5K searches/mo free, no card. |
| [`pagefind`](./services/search/pagefind.md) | Static-site search — runs at build, ships a tiny client, zero infra. |

### Secrets (3)

| File | Description |
|---|---|
| [`doppler`](./services/secrets/doppler.md) | Single source of truth for every family secret — syncs to GitHub Secrets, Cloudflare Workers, Firebase config, and local dev. Free 5 users, no card. |
| [`github-secrets`](./services/secrets/github-secrets.md) | Runtime secret store for GitHub Actions — written by Doppler, read by workflows. Free unlimited. |
| [`sops-age`](./services/secrets/sops-age.md) | Primary, file-based secrets encryption toolchain using age keys and Secrets OPerationS (SOPS) — actively maintained under CNCF. |

### Security (10)

| File | Description |
|---|---|
| [`age`](./services/security/age.md) | age (by FiloSottile) is the modern, minimal file-encryption tool the family uses as the master-key backend for SOPS. X25519 key exchange + ChaCha20-Poly1305 stream. Single private key file (~/.config/sops/age/keys.txt). No PGP keyring, n... |
| [`cloudflare-headers`](./services/security/cloudflare-headers.md) | Static security-headers config served directly from Cloudflare Pages via the `_headers` file. Free unlimited, ships in @chirag127/oriz-kit as a preset. |
| [`cloudflare-turnstile`](./services/security/cloudflare-turnstile.md) | Privacy-friendly CAPTCHA replacement, native to the Cloudflare stack. Free unlimited, no card. Family's primary captcha. |
| [`cloudflare-waf`](./services/security/cloudflare-waf.md) | Edge-layer Web Application Firewall + Bot Fight Mode — included in the Cloudflare free plan, no card. Blocks known bad IPs, common attack patterns, and obvious bot signatures before they reach the origin / Worker. |
| [`hcaptcha`](./services/security/hcaptcha.md) | Regional fallback CAPTCHA for users / networks where Cloudflare Turnstile is blocked. Free 1M verifications/month, no card. |
| [`hono-rate-limit`](./services/security/hono-rate-limit.md) | Custom rate-limit middleware in the Hono Worker, sliding-window per-IP via Cloudflare Workers KV. Free — runs on existing Worker + KV free tiers, no card. Fine-grained per-route throttling that complements the coarser zone-level WAF rate... |
| [`klaro`](./services/security/klaro.md) | OSS consent manager. Lazy-loaded ONLY for EU/UK visitors when a site loads a cookie-issuing tracker (GA4 / PostHog). Hosted from jsDelivr; free, no card. |
| [`mozilla-observatory`](./services/security/mozilla-observatory.md) | Comprehensive security auditor — headers + TLS + cookies + redirects. Free CLI run on every PR alongside securityheaders.com. |
| [`securityheaders-com`](./services/security/securityheaders-com.md) | External security-header auditor. Free API run in CI on every PR — fails the build if grade drops below A. |
| [`sops`](./services/security/sops.md) | SOPS is the family's git-native secrets encryption tool. Encrypts values inside structured files (YAML/JSON/ENV/INI) while keeping keys + structure visible for readable diffs. Originally Mozilla (2015), donated to CNCF Sandbox 2023, now ... |

### Seo (7)

| File | Description |
|---|---|
| [`astrojs-sitemap`](./services/seo/astrojs-sitemap.md) | Official Astro integration that generates sitemap.xml + robots.txt-compatible URL list at build time. Free, no card. |
| [`atom-feed`](./services/seo/atom-feed.md) | Atom 1.0 syndication feed published at /atom.xml on every site, alongside RSS 2.0 and JSON Feed. |
| [`bing-webmaster`](./services/seo/bing-webmaster.md) | Submit sitemaps to Bing, monitor index coverage, see search-query analytics, manage IndexNow keys. Free, no card. |
| [`google-search-console`](./services/seo/google-search-console.md) | Submit sitemaps to Google, monitor index coverage, see search-query analytics, get spam / manual-action notices. Free, no card. |
| [`indexnow`](./services/seo/indexnow.md) | Open API for instantly notifying Bing, Yandex, and partner search engines when a URL is added/changed/deleted. Submit-on-publish hook from oriz-omnipost. Free, no card. |
| [`json-feed`](./services/seo/json-feed.md) | Modern JSON-based syndication feed at /feed.json on every site, alongside RSS 2.0 and Atom 1.0. |
| [`json-ld-structured-data`](./services/seo/json-ld-structured-data.md) | Schema.org JSON-LD markup emitted via a `<JsonLd>` component in @chirag127/oriz-kit. Article + BreadcrumbList + Organization + WebSite + Person types across the family. |

### Short Link (3)

| File | Description |
|---|---|
| [`cloudflare-worker`](./services/short-link/cloudflare-worker.md) | Self-hosted URL shortener on a Cloudflare Worker at s.oriz.in. Free tier (100k req/day), no card. Used by oriz-omnipost when a target platform truncates blog content. |
| [`github-gist-redirect`](./services/short-link/github-gist-redirect.md) | Zero-infrastructure URL redirect: a GitHub gist containing a single HTML page with meta-refresh + canonical link. Tier 3 fallback in the family's three-tier short-link stack — last-resort, immutable, survives a complete Cloudflare outage. |
| [`tinyurl`](./services/short-link/tinyurl.md) | Truly free, unlimited, no-auth URL shortener. Tier 2 fallback in the family's three-tier short-link stack — used when the link points outside oriz.in or s.oriz.in is unreachable. |

### Social (5)

| File | Description |
|---|---|
| [`activitypub`](./services/social/activitypub.md) | Mirrors oriz-me's canonical lifestream JSONL events to ActivityPub-compatible federated streams (Mastodon, Pleroma, etc) via me.oriz.in/activitypub/outbox. Free, federated, no card. |
| [`atproto-firehose`](./services/social/atproto-firehose.md) | Mirrors oriz-me's canonical lifestream JSONL events to the AT Protocol as records under me.oriz.in.atproto. Free, federated, no card. |
| [`raindrop-io`](./services/social/raindrop-io.md) | Bookmarking SaaS used as the source of truth for the family's linkroll. Free unlimited bookmarks + collections + REST API. Powers blog.oriz.in/links built at deploy time. |
| [`ray-so`](./services/social/ray-so.md) | Generate pretty code-screenshot PNGs for Open Graph cards on code-heavy blog posts. Free, OSS, no card. |
| [`satori-og-cards`](./services/social/satori-og-cards.md) | Self-built Open Graph card generator using @vercel/og (Satori) on the api.oriz.in Hono Worker. Free unlimited (CF Workers free tier). Renders templated OG PNGs on demand for non-code blog posts. |

### Storage (4)

| File | Description |
|---|---|
| [`backblaze-b2`](./services/storage/backblaze-b2.md) | Primary blob storage — 10 GB free + 3x egress free of stored. Used for backups and large unversioned binaries that don't belong in GitHub Releases. |
| [`cloudflare-r2`](./services/storage/cloudflare-r2.md) | REJECTED — card-on-file requirement on the surrounding Workers Paid plan. Replaced by Backblaze B2 + GitHub Releases split. |
| [`github-releases`](./services/storage/github-releases.md) | Versioned-binary storage — unlimited releases per repo, 2 GB per asset, free for OSS. Used for extension and CLI binaries. |
| [`restic`](./services/storage/restic.md) | Encrypted, deduplicating backup CLI. Runs in a GitHub Actions weekly cron, targets a Backblaze B2 bucket. OSS, free, no card. |

### Testing (6)

| File | Description |
|---|---|
| [`chromatic`](./services/testing/chromatic.md) | Visual regression diff against Storybook snapshots. Free 5K snapshots/month, no card. |
| [`mockoon`](./services/testing/mockoon.md) | Out-of-process API mock — free OSS desktop app + headless CLI. Stands up a real HTTP server on localhost. Used for E2E tests against third-party APIs (Razorpay sandbox, Open-Meteo, Alpha Vantage when offline) and for manual dev mocking. |
| [`msw`](./services/testing/msw.md) | In-process API mocking for browser + Node tests. Service Worker in browser; Node interceptor in tests. Free OSS. Used for Vitest unit tests, Storybook stories, and dev-time mocking. |
| [`playwright`](./services/testing/playwright.md) | Cross-browser E2E test runner — Chromium + WebKit + Firefox. Free OSS. Already the substrate the a11y axe-core suite rides on. |
| [`storybook`](./services/testing/storybook.md) | Isolated component sandbox + interactive docs. Source of the visual-regression snapshots Chromatic diffs. |
| [`vitest`](./services/testing/vitest.md) | Vite-native unit + integration test runner. Free, OSS, fast in-memory. Already on Vite via Astro — no extra config. |

### Tooling (8)

| File | Description |
|---|---|
| [`axiom`](./services/tooling/axiom.md) | Log management — 0.5 TB ingest / 30-day retention free. |
| [`azure-for-students`](./services/tooling/azure-for-students.md) | Available — free Azure credits via student program, no card required. |
| [`cloudinary`](./services/tooling/cloudinary.md) | Image CDN + transforms fallback — 25 monthly credits free, no card. |
| [`envpact`](./services/tooling/envpact.md) | Secrets vault — chirag127's own tool, primary store for every cross-site secret. |
| [`hookdeck`](./services/tooling/hookdeck.md) | Webhook reliability layer — queues + retries + replay for Razorpay → Worker delivery. 100K requests/month free. |
| [`hypertune`](./services/tooling/hypertune.md) | Type-safe feature flags + A/B testing + typed config with Git-style version control. |
| [`imagekit`](./services/tooling/imagekit.md) | Image CDN + on-the-fly transforms — 20 GB bandwidth/month free. |
| [`readthedocs`](./services/tooling/readthedocs.md) | SDK + API reference docs hosting — versioned, searchable, free for open-source. |

### Video (2)

| File | Description |
|---|---|
| [`gumlet`](./services/video/gumlet.md) | Privacy-sensitive video hosting + streaming — 250 GB/month free, no card, no viewer tracking. |
| [`youtube`](./services/video/youtube.md) | Video hosting + embed primary — unlimited storage and bandwidth, free, public-content only. |

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

## Glossary (27 total)

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
- Max path depth (segments under `knowledge/`): **4** (deepest: `decisions/architecture/apps/cards-site-scope.md`)
- Anomalies flagged: **78 files with non-`active` status** (plus 55 navigational `index.md` files without a status field - expected, not flagged)

### Files with non-active status (review)


**`status: (missing)`** (55)

- [`decisions/architecture/api-scraping-tos-audit.md`](./decisions/architecture/api-scraping-tos-audit.md)
- [`decisions/architecture/apps/cards-site-scope.md`](./decisions/architecture/apps/cards-site-scope.md)
- [`decisions/architecture/cards-site-scope.md`](./decisions/architecture/cards-site-scope.md)
- [`decisions/architecture/compute/api-scraping-tos-audit.md`](./decisions/architecture/compute/api-scraping-tos-audit.md)
- [`decisions/architecture/content/journal-site-sources.md`](./decisions/architecture/content/journal-site-sources.md)
- [`decisions/architecture/frontend/sidebar-4-tier.md`](./decisions/architecture/frontend/sidebar-4-tier.md)
- [`decisions/architecture/journal-site-sources.md`](./decisions/architecture/journal-site-sources.md)
- [`decisions/architecture/knowledge-bundle/depth-5-level-hierarchy.md`](./decisions/architecture/knowledge-bundle/depth-5-level-hierarchy.md)
- [`decisions/architecture/sidebar-4-tier.md`](./decisions/architecture/sidebar-4-tier.md)
- [`decisions/architecture/stack/family-stack-lock.md`](./decisions/architecture/stack/family-stack-lock.md)
- [`decisions/architecture/stack/tool-categories-roadmap.md`](./decisions/architecture/stack/tool-categories-roadmap.md)
- [`decisions/architecture/stack/tools-site-15-repos.md`](./decisions/architecture/stack/tools-site-15-repos.md)
- [`decisions/architecture/tool-categories-roadmap.md`](./decisions/architecture/tool-categories-roadmap.md)
- [`decisions/architecture/tools-site-15-repos.md`](./decisions/architecture/tools-site-15-repos.md)
- [`decisions/branding/naming/policy-family-naming-policy.md`](./decisions/branding/naming/policy-family-naming-policy.md)
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
- [`runbooks/hosting/cf-dns-add-api-subdomain.md`](./runbooks/hosting/cf-dns-add-api-subdomain.md)
- [`runbooks/hosting/cf-dns-audit-2026-06-23.md`](./runbooks/hosting/cf-dns-audit-2026-06-23.md)
- [`runbooks/operations/dependabot-notification-tuning.md`](./runbooks/operations/dependabot-notification-tuning.md)
- [`runbooks/operations/visual-audit-2026-06-22.md`](./runbooks/operations/visual-audit-2026-06-22.md)
- [`runbooks/scaffolding/sites/scaffold-tool-site.md`](./runbooks/scaffolding/sites/scaffold-tool-site.md)
- [`runbooks/security/credentials/rotate-cf-and-npm-tokens.md`](./runbooks/security/credentials/rotate-cf-and-npm-tokens.md)

**`status: deferred`** (3)

- [`services/queue/inngest.md`](./services/queue/inngest.md)
- [`services/queue/upstash-qstash.md`](./services/queue/upstash-qstash.md)
- [`services/search/orama-cloud.md`](./services/search/orama-cloud.md)

**`status: fallback`** (8)

- [`services/ads/ezoic.md`](./services/ads/ezoic.md)
- [`services/ads/mediavine.md`](./services/ads/mediavine.md)
- [`services/auth/clerk.md`](./services/auth/clerk.md)
- [`services/auth/supabase.md`](./services/auth/supabase.md)
- [`services/email/mailerlite.md`](./services/email/mailerlite.md)
- [`services/forms/formspree.md`](./services/forms/formspree.md)
- [`services/hosting/netlify.md`](./services/hosting/netlify.md)
- [`services/hosting/vercel.md`](./services/hosting/vercel.md)

**`status: pending-manual-action`** (1)

- [`runbooks/hosting/codeberg-mirror-2026-06-23.md`](./runbooks/hosting/codeberg-mirror-2026-06-23.md)

**`status: redirect`** (1)

- [`decisions/architecture/packages/the-six-packages.md`](./decisions/architecture/packages/the-six-packages.md)

**`status: rejected`** (10)

- [`services/ai/openrouter.md`](./services/ai/openrouter.md)
- [`services/aws.md`](./services/aws.md)
- [`services/azure-paid-tiers.md`](./services/azure-paid-tiers.md)
- [`services/backblaze-b2.md`](./services/backblaze-b2.md)
- [`services/hosting/firebase-hosting.md`](./services/hosting/firebase-hosting.md)
- [`services/i18n/tolgee.md`](./services/i18n/tolgee.md)
- [`services/monitoring/glitchtip.md`](./services/monitoring/glitchtip.md)
- [`services/oracle-cloud.md`](./services/oracle-cloud.md)
- [`services/productivity/toggl-track.md`](./services/productivity/toggl-track.md)
- [`services/storage/cloudflare-r2.md`](./services/storage/cloudflare-r2.md)
