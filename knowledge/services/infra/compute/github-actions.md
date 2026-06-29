---
type: service
title: "GitHub Actions"
description: "Build-time cron + CI runner — free for public repos"
tags: [github, ci, cron, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: ci-and-cron
provider: github
free_tier: "Unlimited minutes for public repos, 2,000 min/mo for private"
swap_cost: low
---

# GitHub Actions

## Role

CI on every PR + cron-triggered ingesters that produce JSONL into
`oriz-me-data` + matrix deploys to Cloudflare Pages.

## Free tier

- **Public repos:** unlimited minutes
- **Private repos:** 2,000 minutes/month
- 500 MB Actions storage

### Organization Quotas & Pools

- **Pool Separation:** Free-tier limits are tied to the specific owning account (personal vs. organization). A personal account and an organization do not share or pool their Actions minutes; they have separate billing and independent 2,000-minute quotas.
- **Combined Limit:** The 2,000 free minutes quota is a combined total across all private repositories in that organization, not per repository. Public repositories remain free and unlimited.

## Card / subscription required?

**NO.** Free for personal and organization accounts on public repos with no payment method on file.


## Alternatives

- Cloudflare Workers Cron Triggers
- GitLab CI

## Swap cost

Low — workflow YAML is mostly portable. `cron:` triggers move to
`schedule:` on most runners.

## Why this is our pick

Already integrated with the GitHub Issues / repo source of truth, and
free at our scale. Cron, matrix, and artifact upload all in one.

## Cross-refs

- [Per-repo CI workflows](../../decisions/process/per-repo-ci-workflows.md)
- [Canonical store JSONL](../../decisions/database/canonical-store-jsonl.md)
- [healthchecks.io](../monitoring/healthchecks-io.md)
