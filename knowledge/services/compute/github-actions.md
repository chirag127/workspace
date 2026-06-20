---
type: service
title: "GitHub Actions"
description: "Build-time cron + CI runner — free for public repos, the family's scheduled-job substrate."
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

## Card / subscription required?

**NO.** Free for personal accounts on public repos with no payment
method on file.

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
- [Canonical store JSONL](../../architecture/canonical-store-jsonl.md)
- [healthchecks.io](./healthchecks-io.md)
