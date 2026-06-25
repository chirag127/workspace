---
type: service
title: "envpact"
description: "Secrets vault — chirag127's own tool, primary store for every cross-site secret."
tags: [secrets, envpact, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: secrets-vault
provider: chirag127
free_tier: "Self-hosted / personal use — no quota"
swap_cost: high
---

# envpact

## Role

Single source of truth for environment secrets across the family.
Every site / Worker / GitHub Action reads from envpact at deploy.

## Free tier

- Self-hosted / personal use, no quota
- Owner: the user (`chirag127/envpact` repo)

## Card / subscription required?

**NO.** It's the user's own tool.

## Alternatives

- Doppler free (5 users)
- Infisical (5 users)
- GitHub Secrets only (loses cross-repo)

## Swap cost

High — every site reads via the envpact client. Swap means
rewriting the secret-pull step in every site's deploy and every
Worker's startup.

## Why this is our pick

Owned by the user, fits the family's trust model, and the secret
shape is already aligned to it.

## Cross-refs

- [GitHub Actions](../compute/github-actions.md) — pulls secrets at deploy
- [Cloudflare Workers](../compute/cloudflare-workers.md)
