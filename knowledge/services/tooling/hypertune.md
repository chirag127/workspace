---
type: service
title: "Hypertune"
description: "Type-safe feature flags + A/B testing + typed config with Git-style version control."
tags: [feature-flags, ab-testing, config, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: feature-flags-and-config
provider: hypertune
free_tier: "Unlimited feature flags, unlimited A/B tests, 5 team members, type-safe SDK, Git-style version control"
swap_cost: medium
---

# Hypertune

## Role

Feature flags, A/B tests, and typed runtime config across the family.
Type-safe SDK means flag and config keys become TypeScript types, so
a typo at the call site is a compile error. Synchronous in-memory
local flag evaluation means flag reads have no network cost on the
hot path.

## Free tier

- Unlimited feature flags
- Unlimited A/B tests
- 5 team members
- Type-safe SDK with full TypeScript types
- Git-style version control (branches, diffs, history) on flag config
- Synchronous in-memory local flag evaluation
- Unlimited environments

## Card / subscription required?

**NO.** Sign-up via GitHub or email. No payment method required for
the free tier.

## Alternatives

- LaunchDarkly (paid only — rejected)
- PostHog feature flags ([already in stack](../analytics/posthog.md))
- Statsig (free tier exists)
- GrowthBook (open source, but self-host violates the no-selfhost rule)
- Unleash (open source, same issue)

## Swap cost

Medium — flag-key surface is hidden behind a thin internal helper, but
the type-safe codegen ties tightly to Hypertune's CLI. Swapping would
mean regenerating types from another provider and rewiring evaluation.

## Why this is our pick

Three things competitors don't do together: typed flags as a compiled
artifact, in-memory synchronous evaluation (no `await flag()`), and
Git-style branching on the flag config itself. PostHog's flags are
fine for product analytics integration but lack the type generation;
LaunchDarkly is paid-only.

## Cross-refs

- [API umbrella Hono Worker architecture](../../decisions/architecture/compute/api-umbrella-hono-worker.md)
- [Use pnpm rule](../../rules/development/use-pnpm.md)
- [PostHog](../analytics/posthog.md) — product analytics, not the primary flag store
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
