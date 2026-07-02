---
type: rule
title: "Profile README must cross-link chirag127 \u2194 chirag127"
description: "chirag127 ↔ chirag127 cross-link in profile READMEs"
tags:
- rule
- branding
- recruiter
- github
- readme
- profile
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
related:
- rules/interaction/recruiter-strategy
- branding/chirag127-rename-from-co
- decisions/architecture/general/projects-owner-own-forks-layout
---



# Profile README must cross-link chirag127 ↔ chirag127

## Rule

Both GitHub profile README surfaces must cross-link to the other so a
visitor (recruiter or otherwise) who lands on either page reaches the
other in one click.

### On `github.com/chirag127` (personal profile README)

Required line in the README header section:

```markdown
Hi, I'm Chirag — I build [oriz.in](https://oriz.in) ([@chirag127](https://github.com/chirag127)).
```

The pinned-repo gallery on the personal profile may include repos
from `chirag127/*` (pinning org repos is allowed and they DO appear on
the personal profile — recruiters skim pinned repos, see
[`recruiter-strategy`](./recruiter-strategy.md)).

### On `github.com/chirag127` (org profile README via `.github/profile/README.md` in `chirag127/.github`)

Required line in the README footer section:

```markdown
Founded and built by [Chirag Singhal](https://github.com/chirag127).
```

## Why both directions

Recruiters arrive from either entry point. LinkedIn → personal
GitHub. A search for `oriz.in` → org GitHub. Either route must
surface "this is one person's work + this is a real shipping product"
in under 10 seconds.

A recruiter scrolling chirag127 sees pinned org repos and "I build
oriz.in." A recruiter scrolling chirag127 sees real repos and
"Founded by Chirag Singhal." Both reads land the same conclusion.

## When to update

- On any org rename (e.g. when `oriz-co` became `chirag127` on
  2026-06-24, both READMEs needed sed-replace)
- When the brand name itself changes (rare)
- When new pinned repos are added/removed
- When the founder/maintainer changes (currently never — solo)

## Anti-rule (do NOT do)

- Do NOT hide that the org is one person's work — recruiters
  research backgrounds; pretending to be a team backfires
- Do NOT list "Engineers: 5" or other padding on the org page
- Do NOT remove the personal-account cross-link "to make the org
  look bigger" — the personal account is the resume signal
