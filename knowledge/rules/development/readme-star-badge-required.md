---
type: rule
title: "Every repo README must carry a star-this-repo badge near the top"
description: "Family-wide convention: each repo's README places a `[⭐ Star this Repo ⭐](<repo-url>)` link/badge near the top of the file, above the BLUF/overview section. Promotes discoverability across the 80+ repo family."
tags: [rule, readme, branding, family-convention]
timestamp: 2026-06-25
format_version: okf-v0.1
status: active
related:
  - rules/development/repo-naming
  - services/family-inventory
---

# Star-this-repo badge required in every README

## Rule

Every repo in the family — apps, packages, APIs, books, browser extensions, VS Code extensions, userscripts, forks — places this near the top of `README.md`, above any BLUF / overview prose:

```markdown
[⭐ Star this Repo ⭐](https://github.com/<owner>/<repo>)
```

It MAY be styled as a shields.io badge instead, but the literal `⭐ Star this Repo ⭐` text-link is the canonical form (renders consistently across GitHub web, mobile, raw, and forked mirrors).

## Why

- **Discoverability.** Family has 80+ public repos; the only organic-traffic lever is GitHub search → recommended-repos panel, which weights stars heavily.
- **Cross-repo consistency.** A reader landing on any oriz family repo via a search hit knows the rest of the family exists and how to engage with it.
- **Zero cost.** Adds one line; no rendered overhead; no CI required.

## Placement

```markdown
# <repo-name>

[⭐ Star this Repo ⭐](https://github.com/<owner>/<repo>)

> One-line BLUF
...
```

For forks, the badge points at the fork's own URL (oriz-org's copy), not the upstream — the family wants stars on the family's mirror.

## Enforcement

When auditing or creating a new repo, check for this badge. Missing → add in the same commit as any other README work. Don't open a one-line PR just for this; piggyback on the next README edit.

## Cross-refs

- Naming convention this rule applies to → [[rules/development/repo-naming]]
- Family inventory of repos this applies to → [[services/family-inventory]]
