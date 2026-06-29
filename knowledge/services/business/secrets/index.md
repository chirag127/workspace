---
type: index
title: "Secrets management services"
description: "Doppler is the single source of truth; GitHub Secrets / Cloudflare / Firebase config are runtime mirrors synced from it."
tags: [services, secrets, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Secrets management services

The family's secrets architecture is locked at
[`security/secrets-management-doppler.md`](../../security/secrets-management-doppler.md).

| Service | Status | One-line role |
|---|---|---|
| [doppler.md](./doppler.md) | active | Source of truth — every secret originates here, syncs out to runtime mirrors |
| [github-secrets.md](./github-secrets.md) | active | Runtime mirror for GitHub Actions; written by Doppler's GH integration |

The earlier [envpact](../tooling/envpact.md) entry stays documented
as the user's home-grown vault — see the Doppler decision for why
we picked Doppler for this batch.

## Sync direction

```
Doppler (source of truth)
  ├── → GitHub Secrets (org / repo / environment)
  ├── → Cloudflare Workers (vars + secrets)
  ├── → Firebase config (functions:config + Auth provider creds)
  └── → Local .env via `doppler run` (never commit a .env file)
```

## Cross-refs

- [Secrets management decision](../../security/secrets-management-doppler.md)
- [No hardcoded secrets rule](../../rules/security/no-hardcoded-secrets.md)
- [Secrets handling policy](../../policy/secrets-handling.md)
- [Rotate leaked secret runbook](../../runbooks/security/rotate-leaked-secret.md)
- [envpact (user's home-grown vault, still around)](../tooling/envpact.md)
