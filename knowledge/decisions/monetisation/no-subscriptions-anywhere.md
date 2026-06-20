---
type: decision
title: "No service in the stack may require a paid subscription"
description: "Hard constraint: every external service used across the oriz family must work indefinitely on its free tier. Subscription-walled providers are excluded at selection time."
tags: [budget, free-tier, services, constraint]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - rules/never-hit-quotas
  - rules/no-card-on-file
  - decisions/infrastructure/firebase-spark-forever
  - decisions/infrastructure/cloudflare-pages-for-all-sites
---

# No service in the stack may require a paid subscription

## Decision

Every service we depend on must have a free tier sufficient for the
family's expected usage. Services that gate core functionality
behind a recurring subscription are excluded at selection time, even
if they otherwise look superior.

## Why

The mission's third non-negotiable is "cost zero to host and run,
forever." A subscription is a recurring liability with cancellation
risk and price-hike risk; its failure mode is "the family stops
working when the card expires." Free tiers fail closed at quota,
which is the acceptable failure mode. This rule complements the
no-card-on-file rule — together they make the stack's cost ceiling
zero by construction.

## Implications

- Service catalog entries must state the free-tier limit and the "we never hit this because…" justification.
- New services that don't have a free tier are rejected during selection, period — no pilots, no "we'll downgrade later".
- Services that move FROM free to paid get replaced via the package-isolation rule (e.g. swap `@chirag127/email-send` from Resend to AhaSend with a package version bump).
- Build-time GitHub Actions cron and browser-side compute become the preferred placement for any heavy work, since both are free.
- This rule applies to AI inference too: only OpenRouter free models, Pollinations.AI, Puter.js, etc. — never paid OpenAI/Anthropic API direct.

## Cross-refs

- [Never hit free-tier quotas](../../rules/never-hit-quotas.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
- [Firebase Spark forever](../infrastructure/firebase-spark-forever.md)
- [Cloudflare Pages for all sites](../infrastructure/cloudflare-pages-for-all-sites.md)
- [AGENTS.md service catalog](../../../AGENTS.md)
