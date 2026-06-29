---
type: service
title: "Weblate — Hosted Libre"
description: "Translation management — free for OSS, picked for future i18n"
tags: [i18n, localization, translation, weblate, when-ready]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: i18n-translation-mgmt
provider: weblate
free_tier: "Hosted Libre tier — free for libre / OSS projects on a public git repo. Unlimited components / strings / languages, real-time translation memory, machine-translation suggestions, auto-PR back to the repo."
swap_cost: low
related:
  - services/business/i18n/tolgee
  - branding/i18n-weblate-when-ready
  - rules/no-card-on-file
  - rules/no-selfhost
---

# Weblate — Hosted Libre

## Role

The family's chosen translation-management platform for the day a
site or extension picks up a non-English audience. Weblate sits
between source files (`*.json` / `*.po` / `*.ftl` in the repo) and
human / machine translators, opening pull requests back to the repo
when translations are reviewed and approved. **Not in active use
today** — the family is English-only per
[`branding/i18n-weblate-when-ready.md`](../../branding/i18n-weblate-when-ready.md).

## Free tier

- **Hosted Libre** at `hosted.weblate.org` is free for libre / OSS
  projects on a public git repo
- Unlimited components, strings, and languages
- Real-time translation memory shared across the public Hosted Libre tenant
- Machine-translation suggestions (DeepL, Google, etc., where
  Weblate has community keys)
- GitHub / GitLab integration — translations land as PRs
- Glossary, screenshots, comments per string
- Web UI + API for scripted ingest

## Card / subscription required?

**NO.** The Hosted Libre tier is free for libre projects — no card,
no quota cliff. Approval is via a short application that confirms
the repo is public and OSS-licensed.

## Alternatives

- [Tolgee](./tolgee.md) — earlier deferral; SaaS free tier exists,
  self-hosted ruled out by the no-selfhost rule. Kept in the bucket
  as a documented swap target if Hosted Libre ever rejects the
  family's application.
- Lokalise — paid past the free trial
- Crowdin — free for OSS but smaller free tier
- `next-intl` / `react-intl` library-only path — no translation
  management UI, translators commit raw JSON

## Swap cost

Low — Weblate stores nothing the repo doesn't already own. Source
files (`messages.json`, `*.po`, etc.) live in the consuming repo;
Weblate only operates on them. Switching providers means
disconnecting Hosted Libre and pointing another tool at the same
files.

## Why this is our pick

Three reasons:

1. **Free for libre forever** on a public git repo — fits the
   [no-card-on-file rule](../../rules/interaction/no-card-on-file.md) and the
   no-paid-tier rule.
2. **Hosted, not self-hosted** — Hosted Libre satisfies the
   <!-- TODO: broken link, was [no-selfhost rule](../../rules/no-selfhost.md) -->. The self-hosted
   Weblate Docker image is OSS but excluded by policy, same as the
   Tolgee self-host option.
3. **PR-back-to-the-repo workflow** matches how every other content
   change in the family already flows — translations get reviewed
   in GitHub like any other PR, no separate approval surface.

## When to flip on

Per [`branding/i18n-weblate-when-ready.md`](../../branding/i18n-weblate-when-ready.md):
not until a site has measurable non-English traffic or a real
multilingual audience request. Tooling without a use case is
deferred indefinitely.

## Cross-refs

- [branding/i18n-weblate-when-ready.md](../../branding/i18n-weblate-when-ready.md) — the locking decision
- [services/business/i18n/tolgee.md](./tolgee.md) — earlier deferred i18n option
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- <!-- TODO: broken link, was [No selfhost rule](../../rules/no-selfhost.md) -->
