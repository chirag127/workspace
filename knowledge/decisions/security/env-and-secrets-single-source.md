---
type: decision
title: "Env keys + GH Actions secrets — single source of truth, two delivery tracks"
description: "Two-track lock for managing env vars across the family. Track A: PUBLIC .env.example files synced from master templates/.env.example to every repo (no real values). Track B: PRIVATE GitHub Actions secrets set ONCE at chirag127 org level (real values, runtime mirror of Doppler). One source per track, drift caught by CI."
tags: [decisions, security, env, dotenv, secrets, doppler, github, org-level, sync, drift]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - rules/env-example-synced-from-master
  - rules/github-org-level-secrets
  - rules/single-env-example-per-repo
  - rules/no-hardcoded-secrets
  - rules/never-hit-quotas
  - services/secrets/doppler
  - services/secrets/github-secrets
  - decisions/security/secrets-management-doppler
  - runbooks/sync-env-example-to-all-repos
  - runbooks/set-github-org-level-secrets
  - runbooks/rotate-leaked-secret
---

# Env keys + GH Actions secrets — single source of truth, two delivery tracks

## Decision

Manage every environment-variable surface in the family on a
**two-track model**, each with a single source of truth. Per-repo
hand-edits are forbidden on both tracks; CI catches drift.

- **Track A — `.env.example` files (public key surface, no values).**
  The canonical file is
  [`templates/.env.example`](../../../templates/.env.example) at the
  master `chirag127/oriz` repo. Every other repo's `.env.example`
  (sites, packages, extensions, `oriz-omnipost`, `oriz-lifestream`,
  workers, CLIs) is a verbatim copy synced from master via
  [`scripts/sync-env-example.sh`](../../../scripts/sync-env-example.sh).
  Local dev runs `cp .env.example .env` then fills in values from
  [Doppler](../../services/secrets/doppler.md). Locked by
  [`rules/env-example-synced-from-master.md`](../../rules/env-example-synced-from-master.md).
- **Track B — GitHub Actions runtime secrets (private, real values).**
  Set ONCE at the `chirag127` ORG level with
  `gh secret set <NAME> --org chirag127 --visibility all`. Every
  repo's CI inherits them automatically. Doppler stays the canonical
  upstream source per
  [`decisions/security/secrets-management-doppler.md`](./secrets-management-doppler.md);
  org-level GH secrets are the runtime mirror for CI. Locked by
  [`rules/github-org-level-secrets.md`](../../rules/github-org-level-secrets.md).

## Why

User direction on 2026-06-20 (verbatim): *"write the all teh env
example files in the .env.example also so everything is managed from
one project and we set the github action secret on org chirag127
level."* Two locks land in the same conversation:

- **Per-repo `.env.example` drift was inevitable** under the prior
  rule ([`rules/single-env-example-per-repo.md`](../../rules/single-env-example-per-repo.md)).
  Hand-editing 20+ children every time a new key (e.g.
  `WAKATIME_API_KEY` for the lifestream pipeline,
  `LIFESTREAM_INGEST_SECRET` for HMAC, `LIBERAPAY_USERNAME`,
  `OPEN_COLLECTIVE_SLUG`, `POLAR_ACCESS_TOKEN`, `RAINDROP_TOKEN`)
  enters the vocabulary is mechanical drudgery and a guaranteed
  source of "site A knows this key, site B doesn't" bugs. The new
  rule keeps the prior posture (every repo ships a full superset)
  but replaces hand-edits with a sync script + CI diff.
- **Per-repo GH secrets drift was the same pattern.** Setting
  `RAZORPAY_KEY_SECRET` repo-by-repo means a rotation is N writes;
  miss any one and that repo's CI silently fails on next run.
  Org-level `--visibility all` collapses N writes to one.
- **Two tracks because two trust boundaries.** Track A is public
  (key names, no values, committed to public repos). Track B is
  private (real values, never committed). Conflating them was never
  the rule, but stating it as a single two-track decision makes the
  separation explicit.
- **Doppler stays upstream.** Track B's "real values" still live in
  Doppler; the org-level GH secret list is just the runtime mirror
  for the CI substrate. Cloudflare Worker secrets and Firebase
  config remain runtime mirrors per the existing
  [Doppler decision](./secrets-management-doppler.md).

## Implications

### Architecture

```
                    .env.example (PUBLIC, key names only)
                              │
templates/.env.example  ──────▶  sync-env-example.sh  ──────▶  every repo's .env.example
   (master, edited here)              (sync)                     (verbatim copy)
                                                                       │
                                                                       │ cp .env.example .env
                                                                       ▼
                                                              local dev .env (gitignored)
                                                              filled from Doppler

                    GitHub Actions secrets (PRIVATE, real values)
                              │
Doppler (source of truth)  ──▶  set-org-secrets-from-doppler.sh  ──▶  chirag127 org-level GH secrets
   (humans write here)              (sync)                            (visibility: all)
                                                                            │
                                                                            ▼
                                                                  every repo's CI
                                                                  reads via secrets.<NAME>
```

### Drift safeguards

- **Track A drift (repo-level).** Every PR runs
  [`scripts/verify-env-example-sync.sh`](../../../scripts/verify-env-example-sync.sh)
  (or its CI workflow equivalent) which `diff`s the repo's
  `.env.example` against `templates/.env.example` from master. Any
  non-empty diff fails the PR. The same script runs on master CI,
  diffing every submodule's `.env.example` against the master
  template — single source of truth, validated bidirectionally.
- **Track B drift (org-level).** Quarterly cron-job runbook (script
  TBD, lives at `scripts/audit-org-secrets-vs-doppler.sh` when
  written) diffs Doppler's secret list against `gh secret list
  --org chirag127 --json name,visibility,updatedAt`, reports
  mismatches. Drift modes:
    - Key in `templates/.env.example` but missing from org secrets → CI will fail next time the key is referenced. Fix: run [`runbooks/set-github-org-level-secrets.md`](../../runbooks/set-github-org-level-secrets.md) for that key.
    - Key in org secrets but missing from `templates/.env.example` → orphan, possibly stale; audit who set it, remove if unused.
    - Key in both but values differ between Doppler and org secret → re-run the sync script.

### Operational

- **Adding a new key.** Edit `templates/.env.example` on master →
  run sync-env-example script → commit + push every touched repo →
  add the value at Doppler → run the org-secrets sync script →
  verify with `gh secret list --org chirag127`. Two runbooks,
  one keystroke each.
- **Removing a key.** Symmetric: drop from
  `templates/.env.example`, sync, then
  `gh secret delete <NAME> --org chirag127` (with care — make sure
  no in-flight CI run still references it).
- **Rotation.** Per
  [`runbooks/rotate-leaked-secret.md`](../../runbooks/rotate-leaked-secret.md),
  augmented: revoke at provider → reissue → write at Doppler →
  `set-org-secrets-from-doppler.sh <NAME>` (or full run) → verify
  with one CI run per affected repo. Direct writes to per-repo
  secrets are forbidden, same as before.
- **Bootstrap.** The one credential that gets planted by hand is
  `DOPPLER_SERVICE_TOKEN` — it's the token the sync script uses to
  read from Doppler. Set it at org level via
  `gh secret set DOPPLER_SERVICE_TOKEN --org chirag127 --visibility
  all` once, rotate carefully.

### What this decision does NOT do

- **Doesn't replace Doppler.** Doppler stays canonical for **values**;
  org-level GH secrets are runtime-CI mirrors. The other runtime
  mirrors (Cloudflare Worker secrets, Firebase functions config)
  continue to be Doppler-fed per the existing
  [Doppler decision](./secrets-management-doppler.md).
- **Doesn't introduce environment-scoped repo secrets.** No
  `gh secret set --env`. If a `staging` vs `prod` need ever lands,
  it's a new decision.
- **Doesn't make any secret visible in source.** Per
  [`rules/no-hardcoded-secrets.md`](../../rules/no-hardcoded-secrets.md),
  unchanged.
- **Doesn't supersede [`rules/single-env-example-per-repo.md`](../../rules/single-env-example-per-repo.md)
  in spirit** — every repo still ships its own `.env.example` with
  the full family superset. It supersedes the **mechanism**: hand
  edits per repo → sync from master.

## Cross-refs

- [`../../rules/env-example-synced-from-master.md`](../../rules/env-example-synced-from-master.md) — Track A rule
- [`../../rules/github-org-level-secrets.md`](../../rules/github-org-level-secrets.md) — Track B rule
- [`../../rules/single-env-example-per-repo.md`](../../rules/single-env-example-per-repo.md) — superseded prior rule (kept, status flipped)
- [`../../rules/no-hardcoded-secrets.md`](../../rules/no-hardcoded-secrets.md) — values never in source
- [`../../rules/never-hit-quotas.md`](../../rules/never-hit-quotas.md) — drift = silent CI failure class we refuse to ship into
- [`../../services/secrets/doppler.md`](../../services/secrets/doppler.md) — upstream source of truth for values
- [`../../services/secrets/github-secrets.md`](../../services/secrets/github-secrets.md) — runtime mirror service entry
- [`./secrets-management-doppler.md`](./secrets-management-doppler.md) — earlier decision this builds on
- [`../../runbooks/sync-env-example-to-all-repos.md`](../../runbooks/sync-env-example-to-all-repos.md) — Track A runbook
- [`../../runbooks/set-github-org-level-secrets.md`](../../runbooks/set-github-org-level-secrets.md) — Track B runbook
- [`../../runbooks/rotate-leaked-secret.md`](../../runbooks/rotate-leaked-secret.md) — rotation flow uses Track B sync
- [`../../../templates/.env.example`](../../../templates/.env.example) — the master superset

## Naming conventions

When per-app `.env.example` files drifted historically, the same logical key
appeared under multiple names. This is the canonical-name policy enforced by
the master template (`templates/.env.example`). Drift variants in the right
column must NEVER be re-introduced; CI greps for them.

| Canonical (use this) | Banned drift variant |
| --- | --- |
| `CLOUDFLARE_ACCOUNT_ID` | `CF_ACCOUNT_ID` |
| `CLOUDFLARE_API_TOKEN` | `CF_API_TOKEN` |
| `CLOUDFLARE_ZONE_ID` | `CF_ZONE_ID` |
| `CF_TURNSTILE_SECRET` | `CF_TURNSTILE_SECRET_KEY` |
| `PUBLIC_CF_TURNSTILE_SITE_KEY` | `CF_TURNSTILE_SITE_KEY` |
| `HCAPTCHA_SECRET` | `HCAPTCHA_SECRET_KEY` |
| `PUBLIC_HCAPTCHA_SITE_KEY` | `HCAPTCHA_SITE_KEY` |
| `LEMONSQUEEZY_API_KEY` | `LEMON_SQUEEZY_API_KEY` |
| `EMAILOCTOPUS_API_KEY` | `EMAIL_OCTOPUS_API_KEY` |
| `DEVTO_API_KEY` | `DEV_TO_API_KEY` |
| `PUBLIC_GA4_MEASUREMENT_ID` | `PUBLIC_GA4_ID` |
| `POSTHOG_API_KEY` / `PUBLIC_POSTHOG_KEY` | `POSTHOG_KEY` |
| `PUBLIC_WEB3FORMS_KEY` | `WEB3FORMS_KEY` |
| `DOPPLER_SERVICE_TOKEN` | `DOPPLER_TOKEN` |
| `WORDPRESS_APP_PASSWORD` | `WORDPRESS_API_TOKEN` |

### Rules of thumb

- **Prefix Cloudflare service keys with `CLOUDFLARE_`** for account/zone/API
  resources. The exception is `CF_TURNSTILE_*` — Turnstile is a discrete
  product surface and its keys have always shipped under the `CF_` short
  form upstream (matches Cloudflare's own dashboard/SDK conventions).
- **No underscores inside vendor names** that ship as a single word in
  their own docs: `LEMONSQUEEZY_`, `EMAILOCTOPUS_`, `DEVTO_`,
  `WEB3FORMS_` — match the vendor's branding, not English spacing.
- **`PUBLIC_` prefix is reserved for browser-shipped keys** read via
  `import.meta.env` / Vite/Astro/Next public env. Server-only secrets
  never carry it. When both a browser-side and a server-side variant
  legitimately exist (e.g. Firebase, GA4 Measurement ID, Algolia index
  name), ship both as separate keys — never overload one name.
- **Distinguish API-key vs ingestion-token** for services that ship both
  (e.g. `BETTER_STACK_TOKEN` ingests logs; `BETTER_STACK_API_KEY` drives
  the management API). They hit different endpoints; one name is wrong.
- **App-specific keys do not belong in the master.** Per-app proxy URLs,
  app-local toggles, and aliases that duplicate a master key (e.g.
  `B2_KEY_ID` for `B2_APPLICATION_KEY_ID`) stay out. The master is the
  family superset, not a kitchen sink.
