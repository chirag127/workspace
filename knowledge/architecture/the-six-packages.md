---
type: architecture
title: The six packages — @chirag127/oriz-kit + the five it re-exports
description: oriz-kit is the umbrella package; it re-exports the five focused packages — firebase-init, auth-ui, contact-form, sidebar, oriz-family. Sites depend on oriz-kit; only the kit knows the underlying split.
tags: [architecture, packages, oriz-kit, npm]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - architecture/package-isolation-rule
  - architecture/cross-site-auth-via-auth-oriz-in
  - architecture/repo-layout
---

# The six packages — @chirag127/oriz-kit + the five it re-exports

## Concept

The shared client-side surface area of the family is split into six
packages. Five do one thing each. The sixth — `oriz-kit` — is the
umbrella that re-exports the other five. Sites depend on
`@chirag127/oriz-kit` and import everything from there; only the kit
knows the underlying split, so we can re-organise the five without
touching every site.

## How it works

| Package | Purpose |
|---|---|
| `@chirag127/oriz-kit` | The kit. Re-exports the five below. Sites only depend on this. |
| `@chirag127/firebase-init` | Firebase singleton. `initFirebase` / `getInitializedAuth` / `getInitializedDb`. |
| `@chirag127/auth-ui` | `<AccountPanel>` + `<FinishSignIn>`. Auth UI surface. |
| `@chirag127/contact-form` | Web3Forms-backed form. Browser-side only (Web3Forms server calls require their paid plan). |
| `@chirag127/sidebar` | Radix-Dialog-backed drawer. |
| `@chirag127/oriz-family` | `FAMILY` + `FAMILY_SITES` constants. The single list of every site, used for cross-promo. |

- Each shared primitive exposes stable `[data-oriz-*]` attribute hooks.
  Sites style via these hooks. **oriz-kit ships no styles** — design
  diversity across sites is a family rule.
- Each package is a separate GitHub repo at `chirag127/<name>`, added
  as a submodule under `packages/<name>/` in the master oriz repo.

## Why this shape

The split-but-re-export pattern decouples reorganisation from churn:
- A site only ever imports from `oriz-kit`. The site's package.json
  has one shared dependency.
- We can split or merge the five focused packages over time without
  modifying any site, because the kit's re-export surface stays
  stable.
- Each focused package is small enough to version, audit, and swap
  independently — matching the [package-isolation-rule.md](package-isolation-rule.md).

The rule "the kit ships no styles" enforces the family design
philosophy: every site has its own visual identity per its v2 brief.
Shared logic, shared accessibility hooks, zero shared CSS.

## Cross-refs

- The rule that drives this split → [package-isolation-rule.md](package-isolation-rule.md)
- The auth flow these packages plug into → [cross-site-auth-via-auth-oriz-in.md](cross-site-auth-via-auth-oriz-in.md)
- Where packages sit in the repo → [repo-layout.md](repo-layout.md)
