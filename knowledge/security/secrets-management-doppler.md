---
type: decision
title: "Doppler is the source of truth for secrets; GitHub / Cloudflare / Firebase are runtime mirrors"
description: Doppler single source for secrets. GH/CF/Firebase synced downstream
tags: [decisions, security, secrets, doppler, github, cloudflare, firebase]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - services/business/secrets/doppler
  - services/business/secrets/github-secrets
  - services/business/tooling/envpact
  - rules/no-hardcoded-secrets
  - policy/secrets-handling
  - runbooks/rotate-leaked-secret
---

# Doppler is the source of truth for secrets; GitHub / Cloudflare / Firebase are runtime mirrors

## Decision

[Doppler](../../services/business/secrets/doppler.md) is the **single source
of truth** for every secret used across the chirag127/oriz family.
Every other place a secret can live — [GitHub Secrets](../../services/business/secrets/github-secrets.md),
Cloudflare Worker vars + secrets, Firebase functions config, and
local `.env` files via `doppler run` — is a **downstream mirror**
populated by Doppler's sync integrations. Humans only ever write
secrets at Doppler.

The user's home-grown [envpact](../../services/business/tooling/envpact.md)
vault stays around for personal / non-family secrets but is no
longer the family-stack source of truth.

## Why

User asked the agent to choose between GitHub Secrets, Doppler, and
Infisical (1Password's automation product was a fourth candidate).
The agent picked **Doppler** for these concrete reasons:

- **Free 5 users** is permanent on the free tier. The family uses 1; the 4-user buffer covers any future contributor without ever needing to upgrade.
- **Best integration coverage** of the modern free options — covers GitHub Actions + Cloudflare + Firebase out of the box, which is exactly the family's runtime triangle. Infisical is newer with rougher edges; 1Password's automation is a local-signing-model, not a sync-out model.
- **Built-in rotation** for supported integrations — turns the [rotate-leaked-secret runbook](../../runbooks/security/rotate-leaked-secret.md) into "click rotate in Doppler, integrations re-sync within seconds".
- **Audit log** — every read / write / sync is timestamped + attributed; satisfies the family's [secrets-handling policy](../policy/secrets-handling.md).
- **Best DX** — `doppler run -- pnpm dev` is the simplest possible local-dev story, and beats every alternative we tried.

## Implications

### Architecture

```
        Doppler (source of truth)
           +-- ? GitHub Secrets   (org / repo / env scope)
           +-- ? Cloudflare       (Worker vars + secrets)
           +-- ? Firebase config  (functions:config + Auth provider creds)
           +-- ? Local dev        (via `doppler run -- pnpm dev`)
```

- All secrets originate at Doppler. Humans never `gh secret set` or `wrangler secret put` by hand for production secrets — Doppler does it automatically.
- Bootstrap secret: `DOPPLER_SERVICE_TOKEN` itself is the one credential that has to be planted into each runtime by hand (it's the credential that does the syncing). It's also the only secret whose rotation requires a tiny manual touch.
- Local dev: `doppler run` injects secrets at process start. No `.env` file is ever committed (per [`no-hardcoded-secrets.md`](../../rules/security/no-hardcoded-secrets.md)).
- envpact stays for the user's personal secrets (cross-machine creds outside the family stack). It is not deprecated — its scope just narrows.

### Project layout in Doppler

| Doppler project | Environments | What lives there |
|---|---|---|
| `oriz-firebase` | `dev`, `prod` | Microsoft OAuth client ID/secret, reCAPTCHA Enterprise key, Firebase service account JSON, Auth provider creds |
| `oriz-worker` | `dev`, `prod` | `HOOKDECK_SIGNING_SECRET`, Razorpay key + secret, Resend API key, Sentry DSN |
| `oriz-omnipost` | `prod` | Per-adapter platform tokens (`OMNIPOST_DEVTO_TOKEN`, `OMNIPOST_HASHNODE_TOKEN`, …), GH bot PAT for repo writeback |
| `oriz-monitoring` | `prod` | Sentry DSN, Axiom token, Better Stack token, healthchecks.io ping URLs |
| `oriz-cli` | `dev` | local-only CLI auth tokens |

### Operational

- **Rotation runbook** ([`rotate-leaked-secret.md`](../../runbooks/security/rotate-leaked-secret.md)) gains a Doppler step: revoke at provider ? reissue ? write at Doppler (NOT at GH / CF / Firebase) ? wait for sync (seconds) ? run sanity check. Direct writes to runtime mirrors are forbidden because they're overwritten on the next sync.
- **Audit reviews** quarterly — read Doppler's audit log for unexpected `read` events; cross-check against expected workflow runs.
- **Access** — only the user's identity has Doppler access today. Adding a contributor uses one of the 4 free seats.
- **Backup** — Doppler exports JSON / dotenv on demand; quarterly export committed (encrypted, age-recipient under user's key) to a private repo as cold-storage fallback.

### What we don't do

- **No secret pasted into chat**, ever — this is the [no-hardcoded-secrets rule](../../rules/security/no-hardcoded-secrets.md), unchanged.
- **No `.env` files committed to git**, ever — `doppler run` is the only way local dev sees secrets.
- **No production secrets written by hand to GH / CF / Firebase UIs** — only Doppler writes them.
- **No two source-of-truth stores** — envpact and Doppler do not race. Family-stack secrets are Doppler-only.

## Cross-refs

- [Doppler service entry](../../services/business/secrets/doppler.md)
- [GitHub Secrets — runtime mirror](../../services/business/secrets/github-secrets.md)
- [envpact — narrowed to personal use](../../services/business/tooling/envpact.md)
- [No hardcoded secrets rule](../../rules/security/no-hardcoded-secrets.md)
- [Secrets handling policy](../policy/secrets-handling.md)
- [Rotate leaked secret runbook](../../runbooks/security/rotate-leaked-secret.md)
- [Multi-provider auth decision](./multi-provider-auth.md) — provider creds land in `oriz-firebase` Doppler project
- [Cron split decision](../architecture/cron-split-cf-vs-gh.md) — both substrates pull from Doppler
