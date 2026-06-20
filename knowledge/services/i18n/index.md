---
type: index
title: "i18n / translation services"
description: "Translation-management services for the day the family picks up a non-English audience. Today: English-only, no service active in the hot path."
tags: [services, i18n, localization, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# i18n / translation services

## Current policy — English only, today

The family runs **English-only** across every site and extension
right now. No site or extension has measurable non-English traffic,
and adding an i18n platform without a use case would be tooling
without a job.

When a site or extension shows real multilingual demand, we flip on
[Weblate Hosted Libre](./weblate-hosted-libre.md) as the
translation-management platform. The full reasoning lives in
[`decisions/branding/i18n-weblate-when-ready.md`](../../decisions/branding/i18n-weblate-when-ready.md).

| Service | Status | One-line role |
|---|---|---|
| [weblate-hosted-libre.md](./weblate-hosted-libre.md) | active | Translation management — free for libre / OSS, when-ready primary |
| [tolgee.md](./tolgee.md) | rejected | Earlier deferral — SaaS free tier could revisit, self-host ruled out by no-selfhost rule |

## Cross-refs

- [decisions/branding/i18n-weblate-when-ready.md](../../decisions/branding/i18n-weblate-when-ready.md) — the locking decision
- [No selfhost rule](../../rules/no-selfhost.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
