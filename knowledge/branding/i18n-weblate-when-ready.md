---
type: decision
title: "i18n — English-only today, Weblate Hosted Libre when ready"
description: English-only until non-English demand; then Weblate
tags: [decisions, branding, i18n, weblate, deferred-then-locked]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - services/business/i18n/weblate-hosted-libre
  - services/business/i18n/tolgee
  - rules/no-card-on-file
  - rules/no-selfhost
---

# i18n — English-only today, Weblate Hosted Libre when ready

## Decision

The chirag127/oriz family is **English-only across every site and
extension today**. No translation-management platform is in the hot
path. When a site or extension picks up real non-English audience
demand, the family flips on
[Weblate Hosted Libre](../../services/business/i18n/weblate-hosted-libre.md)
as the chosen tool.

This **revisits and refines** the earlier deferral at
[`services/business/i18n/tolgee.md`](../../services/business/i18n/tolgee.md): the
"defer i18n" call still holds, but the *which tool when ready* is
now answered — Weblate, not Tolgee.

## Why

- **No use case today.** No site has measurable non-English
  traffic. Tooling without a job is dead weight; pre-translating
  English copy nobody asked for is also dead weight.
- **When demand arrives, we want a free / OSS / no-card option
  ready.** Weblate Hosted Libre is free for libre projects on a
  public git repo — fits every family rule
  ([no card-on-file](../../rules/interaction/no-card-on-file.md),
  <!-- TODO: broken link, was [no selfhost](../../rules/no-selfhost.md) -->, no paid tiers).
- **Why Weblate over Tolgee:** Hosted Libre is a public-good tier
  with no quota cliff at family scale. Tolgee's SaaS free tier
  exists but has lower limits, and its self-hosted option is ruled
  out by the <!-- TODO: broken link, was [no-selfhost rule](../../rules/no-selfhost.md) -->. The
  Weblate self-host option is excluded by the same rule — Hosted
  Libre is the rule-compliant variant.
- **PR-back-to-the-repo workflow** matches how every other content
  change in the family already flows. Translators land PRs in
  GitHub; the same review surface covers code and copy.

## Implications

- **No i18n integration in any site or extension today.** Sites
  ship English copy as plain literals. No `messages.json`, no
  locale switcher, no `lang=` selector logic in oriz-kit.
- **When the first site needs i18n** (a future judgment call,
  *not* a scheduled milestone):
  1. Extract that site's user-visible strings into a single
     `src/locales/en.json` (or `.po`).
  2. Apply for Hosted Libre under that public repo's slug.
  3. Wire Weblate's GitHub integration; translations land as PRs.
  4. Add a locale switcher to the site (component lives in
     `@chirag127/oriz-kit` once shape is clear; first site eats
     the temporary in-repo version).
- **No site-wide locale switcher in oriz-kit yet** — the component
  lands when the first site needs it, not pre-emptively.
- **Tolgee stays `rejected`** in the service catalog. The
  `services/business/i18n/tolgee.md` page cross-links to weblate as the
  picked replacement.
- **No URL changes today.** When i18n flips on for a given site,
  the locale strategy (`/en/` prefix vs `lang.site.tld` vs cookie)
  is decided per-site at flip-on time — not pre-emptively here.

## Cross-refs

- [services/business/i18n/weblate-hosted-libre.md](../../services/business/i18n/weblate-hosted-libre.md) — the picked service
- [services/business/i18n/tolgee.md](../../services/business/i18n/tolgee.md) — earlier deferral, kept rejected
- [services/business/i18n/index.md](../../services/business/i18n/index.md) — bucket policy
- <!-- TODO: broken link, was [No selfhost rule](../../rules/no-selfhost.md) -->
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
