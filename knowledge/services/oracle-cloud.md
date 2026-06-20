---
type: service
title: "Oracle Cloud"
description: "REJECTED — excluded by user policy."
tags: [hosting, rejected]
timestamp: 2026-06-20
format_version: okf-v0.1
status: rejected
role: cloud-compute
provider: oracle
free_tier: "Always-Free tier exists (2 ARM VMs, 4 OCPU / 24 GB RAM total) but excluded by family policy"
swap_cost: n/a
rejection_reason: "Excluded by user policy. Past account-closure / quota incidents have made the user unwilling to depend on Oracle for any production workload, even on the Always-Free tier."
---

# Oracle Cloud

## Status

**REJECTED.** Documented in AGENTS.md `Hard constraints` as a
permanent exclusion.

## Why rejected

User policy. Oracle's Always-Free tier is technically generous, but
the family's hard rule is that we don't use it. This is a stable
decision; do not propose Oracle Cloud as a fallback.

## Card / subscription required?

**YES** for sign-up — Oracle requires a card for identity
verification even on the Always-Free tier. This alone would violate
the no-card-on-file rule, but the exclusion is broader than that.

## Replacement

For compute: [Cloudflare Workers](./cloudflare-workers.md) +
[GitHub Actions](./github-actions.md). For VMs: not pursued.

## Cross-refs

- [No card-on-file rule](../rules/no-card-on-file.md)
- [AGENTS.md hard constraints](../../AGENTS.md#hard-constraints-will-never-use)
