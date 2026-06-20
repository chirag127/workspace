---
type: decision
title: "@chirag127/oriz-kit is the canonical kit package name"
description: "The shared kit package is named @chirag127/oriz-kit, replacing the earlier @chirag127/oriz-ui name."
tags: [packages, naming, kit, npm]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/oriz-ui-split-into-5-packages
  - decisions/branding/keep-oriz-add-site-suffix
---

# @chirag127/oriz-kit is the canonical kit package name

## Decision

The shared family kit package is published as
`@chirag127/oriz-kit`. It re-exports the 5 split packages
(`firebase-init`, `auth-ui`, `contact-form`, `sidebar`,
`oriz-family`) so each site can import everything from one place.

## Why

"Kit" is a more accurate semantic label than "ui" — the package
contains React components AND non-UI helpers (Firebase singleton,
family constants, type-safe API client re-exports). The older name
`@chirag127/oriz-ui` predated the split and stayed pointing at the
monolithic library. Renaming on the split keeps consumers from
having to think about the legacy name.

## Implications

- The 5 underlying packages keep their own scoped names: `@chirag127/firebase-init`, `@chirag127/auth-ui`, `@chirag127/contact-form`, `@chirag127/sidebar`, `@chirag127/oriz-family`.
- Sites can either import from `@chirag127/oriz-kit` (convenience) or from one of the 5 directly (smaller bundle when only one is needed).
- The directory inside the master repo is `packages/oriz-kit/` matching the published name.
- Old `@chirag127/oriz-ui` is deprecated on npm with a pointer to `@chirag127/oriz-kit`; sites migrate at next dependency bump.
- All `[data-oriz-*]` style hook attributes stay unchanged across the rename — sites' CSS doesn't churn.

## Cross-refs

- [oriz-ui split into 5 packages](../architecture/oriz-ui-split-into-5-packages.md)
- [Repo naming: oriz-<name>-site / -ext](./keep-oriz-add-site-suffix.md)
- [AGENTS.md packages section](../../../AGENTS.md)
