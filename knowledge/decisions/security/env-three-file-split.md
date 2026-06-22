---
type: decision
title: "Three-env file split — .env / .env.development / .env.production"
description: "Single key namespace, three value files split by NODE_ENV. .env holds shared defaults + public keys; .env.development holds TEST values (Razorpay test keys, dev URLs); .env.production holds LIVE values (Razorpay live keys, prod URLs at oriz.in). All three sops-encrypted. Apps load via Vite/Astro's automatic dotenv chain."
tags: [decision, env, secrets, sops, razorpay, vite, astro]
timestamp: 2026-06-22
format_version: okf-v0.1
status: active
related:
  - decisions/security/env-and-secrets-single-source
  - decisions/security/secrets-management-doppler
  - rules/org-level-secrets-only-no-per-repo
  - rules/no-hardcoded-secrets
---

# Three-env file split

## Decision

Replace single `.env` with a three-file split keyed off `NODE_ENV`.
Key NAMES stay identical across files; only VALUES differ. Apps read
the same `process.env.RAZORPAY_KEY_ID` in either env.

## The three files

| File | Loaded when | Contents |
|---|---|---|
| `.env` | always (defaults) | Shared defaults + non-environment-specific values + public keys (`PUBLIC_FIREBASE_API_KEY`, `PUBLIC_FIREBASE_AUTH_DOMAIN`, etc.) |
| `.env.development` | `NODE_ENV=development` | Razorpay **TEST** keys, Razorpay **TEST** plan IDs, dev URLs (`http://localhost:4321`, `dev.oriz.in`), `NODE_ENV=development` |
| `.env.production` | `NODE_ENV=production` | Razorpay **LIVE** keys, **LIVE** plan IDs, prod URLs (`https://oriz.in`), `NODE_ENV=production` |

## SOPS encryption

All three files are encrypted at rest:

```
.env             → .env.enc
.env.development → .env.development.enc
.env.production  → .env.production.enc
```

The `.enc` variants are committed to git. The `.env*` plain files are
gitignored. Decrypt with `sops -d .env.enc > .env` before local dev.

## Loading chain

Vite (Astro / SvelteKit / etc.) and Next.js both implement dotenv-chain:

1. `.env` loaded first
2. `.env.<NODE_ENV>` loaded second (overrides keys from step 1)
3. `.env.local` loaded third (gitignored, per-developer overrides — optional)

No app code changes needed; Vite/Astro/Next do this automatically.

## Sync to org secrets

`sync-env-to-org-secrets.yml` workflow pushes ALL THREE to org level
with a naming convention so apps can key-resolve at CI time:

| Source file | Org secret name |
|---|---|
| `.env` (shared key `FOO`) | `FOO` |
| `.env.development` key `FOO` | `FOO` (same — development is the default) |
| `.env.production` key `FOO` | `FOO_PROD` (production override) |

CI workflows reading secrets at build time pick the right one based on
deployment target:

```yaml
env:
  RAZORPAY_KEY_ID: ${{ github.ref == 'refs/heads/main' && secrets.RAZORPAY_KEY_ID_PROD || secrets.RAZORPAY_KEY_ID }}
```

## Why the split

- **Single namespace** — apps don't branch on env names; same `process.env.X` works
- **Clear test vs. live separation** — no risk of pushing test Razorpay keys to prod
- **SOPS-friendly** — each file encrypted independently; rotate one env without re-encrypting the others
- **CI-friendly** — `NODE_ENV` is the only switch CI needs to flip

## Cross-refs

- [[decisions/security/env-and-secrets-single-source]] — the upstream "two-track" decision
- [[decisions/security/secrets-management-doppler]] — Doppler is upstream of all .env files
- [[rules/org-level-secrets-only-no-per-repo]] — org-level sync target
