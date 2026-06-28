---
type: decision
title: "Flat subdomain pattern: <slug>.oriz.in for every public-facing repo"
description: "Locked 2026-06-23. Every public-facing repo in the family (apps, npm packages, books, skills, extensions) gets a flat <slug>.oriz.in custom subdomain. APIs keep their existing *.api.oriz.in shape (grandfathered, GH Pages Let's Encrypt SSL). New work uses one-level subdomains only per Rule 16. Total estimated: ~85 subdomains (26 apps + 23 packages + 5 books + 10 skills + 1 extension + 19 APIs + ~5 misc)."
tags: [decision, subdomains, dns, naming, flat-namespace]
timestamp: 2026-06-23
format_version: okf-v0.1
status: active
related:
  - rules/one-level-subdomain-only
  - rules/hosting-split-cf-and-github-pages
  - decisions/infrastructure/subdomains-under-oriz-in
  - decisions/architecture/api-hosting-triple-rail
---

# Flat subdomain pattern

## Rule

Every repo with a public landing page gets `<slug>.oriz.in` where `<slug>` is its short identifier (no `oriz-` prefix, no `-pkg` / `-app` suffix). All one level deep so CF Universal SSL covers them without paid plan.

## Examples

| Type | Repo | Subdomain |
|---|---|---|
| App | oriz-roam-journal-app | journal.oriz.in |
| App | oriz-paisa-finance-tools-app | finance.oriz.in |
| npm package | astro-shell-npm-pkg | astro-shell.oriz.in |
| npm package | auth-core-npm-pkg | auth-core.oriz.in |
| npm package | oriz-ui-npm-pkg | oriz-ui.oriz.in |
| Book | learn-frugality | learn-frugality.oriz.in |
| Book | warren-buffett-essays | buffett.oriz.in |
| Skill | playwright-cli | playwright-cli.oriz.in |
| Skill | grill-me | grill-me.oriz.in |
| Extension fork | Ai-rewrite | ai-rewrite.oriz.in |
| API | oriz-flow-fii-dii-activity-api | fii-dii.api.oriz.in (grandfathered 2-level) |

## Why flat

1. **CF SSL** — Free Universal SSL covers `*.oriz.in` (one level only). Paid Advanced Cert needed for `*.<sub>.oriz.in`.
2. **Memorability** — `journal.oriz.in` reads better than `pkg.journal.oriz.in` or `app.journal.oriz.in`.
3. **No type prefix needed** — the URL doesn't need to encode whether it's an app, package, or book. The landing page does.

## Why not grouped (pkg.<slug>.oriz.in)

- Violates Rule 16 (one-level subdomain only)
- Requires Advanced Cert ($10/mo per zone) — kills no-card rule
- 19 APIs are already 2-level (`<sub>.api.oriz.in`) as a grandfathered exception via GH Pages Let's Encrypt — those work because GH Pages, not CF, terminates SSL there

## What this kills

- Type-prefixed subdomains like `pkg.astro-shell.oriz.in`
- Long-form like `package-astro-shell.oriz.in` — too noisy

## Risk: namespace pollution

We'll have ~85 entries in DNS. CF allows unlimited records on a free plan. Risk = readability of `dig oriz.in any` output, which is solvable by sorting + categorizing in knowledge docs.

## Cross-refs

- One-level subdomain rule → [[rules/one-level-subdomain-only]]
- CF Pages apps-only → [[rules/hosting-split-cf-and-github-pages]]
- API triple-rail → [[decisions/architecture/api-hosting-triple-rail]]
