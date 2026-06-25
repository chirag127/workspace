---
type: service
title: "Doppler"
description: "Single source of truth for every family secret — syncs to GitHub Secrets, Cloudflare Workers, Firebase config, and local dev. Free 5 users, no card."
tags: [secrets, doppler, sync, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: secrets-sync-source-of-truth
provider: doppler
free_tier: "5 users (we use 1), unlimited projects, unlimited environments, unlimited secrets, sync integrations included"
swap_cost: medium
---

# Doppler

## Role

The single place every family secret is written, rotated, and
audited. Doppler then **syncs** each secret out to the runtime
mirrors that actually need it — GitHub Secrets for Actions, Worker
vars / secrets for Cloudflare, Firebase Auth provider credentials,
local dev via `doppler run`.

## Free tier

- **5 users** (the family uses 1).
- Unlimited projects, environments, secrets.
- Sync integrations included on free: GitHub Actions, Cloudflare,
  Vercel, AWS Parameter Store, GCP Secret Manager, Kubernetes,
  Heroku, Render, Fly.io, Netlify, and webhooks.
- Built-in **secret rotation** on supported integrations.
- Audit log of every read / write / sync.
- CLI: `doppler` for local dev (`doppler run -- pnpm dev`).

## Card / subscription required?

**NO.** Free tier doesn't ask for a card. Free Team plan limits
seats to 5 and excludes some enterprise features (SAML, granular
access policies) — none of which the family needs.

## What lives in Doppler

| Project | Environments | Examples |
|---|---|---|
| `oriz-firebase` | `dev`, `prod` | `MICROSOFT_OAUTH_CLIENT_ID`, `MICROSOFT_OAUTH_CLIENT_SECRET`, `RECAPTCHA_ENTERPRISE_KEY`, Firebase service account JSON |
| `oriz-worker` | `dev`, `prod` | `HOOKDECK_SIGNING_SECRET`, `RAZORPAY_KEY_ID`, `RAZORPAY_SECRET`, `RESEND_API_KEY` |
| `oriz-omnipost` | `prod` | `OMNIPOST_DEVTO_TOKEN`, `OMNIPOST_HASHNODE_TOKEN`, GH bot PAT for repo writeback |
| `oriz-monitoring` | `prod` | `SENTRY_DSN`, `AXIOM_TOKEN`, `BETTER_STACK_TOKEN` |
| `oriz-cli` | `dev` | local-only CLI auth tokens |

## Alternatives

- [GitHub Secrets only](./github-secrets.md) — current state pre-Doppler; loses cross-repo + cross-runtime sync, no audit log, no built-in rotation
- Infisical — newer, OSS, similar shape; Doppler has the better DX + integration coverage in 2026
- 1Password Secrets Automation — local-only signing model, no Worker / Firebase sync
- HashiCorp Vault — enterprise; too much for the family
- [envpact](../tooling/envpact.md) — the user's home-grown vault, still kept around for personal use; Doppler covers the family-stack secrets

## Swap cost

Medium — every site / Worker / GH workflow reads from Doppler. Swap
means re-pointing each integration target. The secrets themselves
are portable (Doppler exports JSON / .env). Most pain is in the
rotation runbook + the per-runtime sync config.

## Why this is our pick

- Best **integration coverage** of the three modern free options (Doppler / Infisical / 1Password) — covers GitHub Actions + Cloudflare + Firebase out of the box, which is exactly the family's runtime triangle.
- **Built-in rotation** for supported integrations — turns the [rotate-leaked-secret runbook](../../runbooks/security/rotate-leaked-secret.md) into "click rotate in Doppler, integrations update automatically".
- **Audit log** — every read / write / sync is timestamped + attributed; satisfies the family's [secrets-handling policy](../../decisions/policy/secrets-handling.md).
- **Best DX** of the three (Infisical is newer with rougher edges; 1Password's automation is local-signing-model only).
- **Free 5 users** is permanent — we use 1; 4-user buffer for any future contributor.

## Implementation notes

- Sign up at <https://doppler.com> with the user's GitHub identity. No card.
- Install CLI: `doppler login`.
- Create projects + environments per the table above.
- Wire integrations:
  - GitHub Actions: install Doppler GitHub App → org / repo scope → Doppler pushes secrets to GH Secrets on every change.
  - Cloudflare Workers: Doppler → Cloudflare integration writes Worker secrets via API.
  - Firebase: `doppler run -- firebase functions:config:set` in the deploy step (or via Cloud Build trigger when we move there).
- Local dev: `doppler run -- pnpm dev` (per project) — no `.env` files committed, ever (per [`no-hardcoded-secrets.md`](../../rules/security/no-hardcoded-secrets.md)).
- Rotation: Doppler dashboard → secret → Rotate → integrations re-sync within seconds.

## Cross-refs

- [Secrets management decision](../../decisions/security/secrets-management-doppler.md)
- [GitHub Secrets — runtime mirror](./github-secrets.md)
- [No hardcoded secrets rule](../../rules/security/no-hardcoded-secrets.md)
- [Secrets handling policy](../../decisions/policy/secrets-handling.md)
- [Rotate leaked secret runbook](../../runbooks/security/rotate-leaked-secret.md)
- [envpact — home-grown vault](../tooling/envpact.md)
