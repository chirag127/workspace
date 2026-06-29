---
type: service
title: "Tolgee"
description: "REJECTED — i18n deferred, English-only family"
tags: [i18n, localization, rejected]
timestamp: 2026-06-20
format_version: okf-v0.1
status: rejected
role: i18n-platform
provider: tolgee
free_tier: "SaaS free tier exists (limited string keys + 1 project); self-hosted is fully free but ruled out"
swap_cost: n/a
rejection_reason: "User decision 2026-06-20 — defer i18n until a site genuinely needs it. English-only family for now. The 'no selfhost' rule rules out the self-hosted option; the SaaS free tier may eventually be revisited."
---

# Tolgee

## Status

**REJECTED for now.** Stub kept for future revisit.

## Why rejected

User decision on 2026-06-20: defer internationalization until a site
in the family genuinely needs a non-English audience. The whole
family runs English-only today, and adding an i18n platform now would
be tooling without a use case.

The self-hosted option is ruled out by the family's no-selfhost rule.
The Tolgee SaaS free tier remains an option to revisit if and when a
site picks up a multilingual audience.

## Card / subscription required?

The Tolgee SaaS free tier does not require a card. Self-hosted is
free but excluded by policy.

## Replacement

None today. English-only across the family. When i18n is needed:
re-evaluate Tolgee SaaS, Lokalise, Crowdin, and the
`next-intl` / `react-intl` library-only path.

## Cross-refs

- <!-- TODO: broken link, was [No selfhost rule](../rules/no-selfhost.md) -->
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
