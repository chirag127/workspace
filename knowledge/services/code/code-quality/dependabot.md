---
type: service
title: "Dependabot"
description: "Automated dependency security updates — GitHub-native, free for all repos"
tags: [services, code-quality, security, dependencies]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: dependency-updates
provider: github
free_tier: "Free for all repos (public AND private); unlimited PRs; security + version updates"
swap_cost: low
---

# Dependabot

## Role

Automated dependency updates and security alerts for every oriz repo. Opens a PR whenever:

- A new CVE is published affecting a direct or transitive dependency
- A semver-respecting newer version exists (when version updates are enabled)

Native GitHub integration — no separate account or token required.

## Free tier

Free for all GitHub repos, public and private. No quota on PR count. Two modes:

1. **Security updates** (always on by default) — opens a PR whenever a vulnerability is published.
2. **Version updates** (opt-in via `.github/dependabot.yml`) — opens PRs on a schedule for non-security version bumps.

## Card / subscription required?

**NO.** Built into GitHub for every account.

## Alternatives

- **Renovate** — more configurable (custom grouping, auto-merge rules, broader ecosystem), self-hostable. Slight ramp; Dependabot is good enough for the family.
- **Snyk** — adds vulnerability scanning across more attack surface (containers, IaC) but the free tier is metered.

## Swap cost

**Low.** Both alternatives accept similar config and open similar PRs. Switching is a `dependabot.yml` → `renovate.json` translation.

## Why this is our pick

Zero-config security baseline. Every repo gets a `.github/dependabot.yml` enabling weekly version updates for `npm` ecosystem; security updates are on by default whether the file exists or not. PRs land at `main`, get reviewed by CodeRabbit, and merge under the same biome + CI gates as human PRs.

## Cross-refs

- [services/code/code-quality/coderabbit](./coderabbit.md)
- [rules/always-latest-deps](../../rules/development/always-latest-deps.md)
- [decisions/code-quality-stack](../../decisions/process/code-quality-stack.md)
