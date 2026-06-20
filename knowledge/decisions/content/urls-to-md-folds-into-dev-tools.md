---
type: decision
title: "urls-to-md folds into a future oriz-dev-tools site"
description: "The standalone oriz-urls-to-md site is planned to migrate into a broader oriz-dev-tools site bundling URL→Markdown plus future dev utilities."
tags: [sites, migration, dev-tools, planning]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - design/oriz-urls-to-md
---

# urls-to-md folds into a future oriz-dev-tools site

## Decision

The current standalone `oriz-urls-to-md` site (urls-to-md.oriz.in)
is planned to migrate into a broader `oriz-dev-tools` site that
bundles URL→Markdown conversion alongside future dev utilities
(regex tester, JSON formatter, color picker, cron-expression
inspector, base64 encoder, etc.).

## Why

A single-utility site under-leverages a subdomain and forces every
new dev utility to choose between (a) starting its own site or (b)
fighting urls-to-md's branding to fit in. A bundled `oriz-dev-tools`
site amortises the chrome/header/footer/auth/SEO across all
utilities and lets each new utility ship as a sub-route on a site
that already has authority. URL→Markdown becomes one utility among
many rather than the site's whole identity.

## Implications

- `oriz-urls-to-md` continues to operate at urls-to-md.oriz.in until the migration lands; nothing changes for current users yet.
- New `oriz-dev-tools` site will be bootstrapped as a 12th submodule under `sites/oriz-dev-tools/`.
- After migration: urls-to-md.oriz.in 301-redirects to `dev-tools.oriz.in/urls-to-md`. Old URLs preserved.
- The repo `chirag127/oriz-urls-to-md-site` either rebrands to `oriz-dev-tools-site` or gets archived after the new site supersedes it — decision deferred to migration time.
- Future utilities live as routes inside `oriz-dev-tools`: `/regex`, `/json`, `/color`, `/cron`, `/base64`, etc.
- This is a planned migration, not an immediate one — no work scheduled yet.

## Cross-refs

- [oriz-urls-to-md design brief](../../design/oriz-urls-to-md.md)
- [AGENTS.md future sites section](../../../AGENTS.md)
