---
type: decision
title: "oriz-ui split into 5 packages + a kit shim"
description: "The monolithic @chirag127/oriz-ui package was split into 5 focused packages, with @chirag127/oriz-kit as the convenience re-export shim."
tags: [packages, refactor, kit, oriz-ui, npm]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
supersedes: oriz-ui-monolith
related:
  - decisions/branding/oriz-kit-package-name
---

# oriz-ui split into 5 packages + a kit shim

## Decision

The previously monolithic `@chirag127/oriz-ui` package was split
into five focused packages, plus a sixth shim package that
re-exports them all:

- `@chirag127/firebase-init` — Firebase singleton (`initFirebase`, `getInitializedAuth`, `getInitializedDb`)
- `@chirag127/auth-ui` — `<AccountPanel>` + `<FinishSignIn>`
- `@chirag127/contact-form` — Web3Forms-backed `<ContactForm>` (browser-only)
- `@chirag127/sidebar` — Radix-Dialog-backed `<Sidebar>` drawer
- `@chirag127/oriz-family` — `FAMILY` + `FAMILY_SITES` constants
- `@chirag127/oriz-kit` — re-exports the 5 above (the convenience shim)

## Why

The monolith forced every site to install all components and their
transitive dependencies even when only one was used — pulling in
Firebase + Radix + Web3Forms for a site that just wanted the family
constants. Splitting the package cuts each site's bundle to exactly
the pieces it imports, and lets us version each piece independently
(e.g. bump auth-ui without re-publishing every site to pick up an
unrelated sidebar fix). The kit shim preserves the convenience of
"one import covers everything" for sites that prefer it.

## Why this is locked here as well as in [oriz-kit-package-name](../branding/oriz-kit-package-name.md)

The package rename and the monolith split are two different
decisions: rename = "the umbrella package's name", split = "the
package became 5 packages with a shim". This file documents the
split; the rename file documents the new umbrella name.

## Implications

- Each package has its own `package.json`, version, README, and CHANGELOG.
- Sites can either import from `@chirag127/oriz-kit` (one import) or from one of the 5 individual packages (smaller bundle).
- The 5 underlying packages keep their stable `[data-oriz-*]` style hook attributes — sites' CSS doesn't change on the split.
- Old `@chirag127/oriz-ui` is deprecated on npm with a pointer to `@chirag127/oriz-kit`.
- Workspace layout: `packages/firebase-init/`, `packages/auth-ui/`, `packages/contact-form/`, `packages/sidebar/`, `packages/oriz-family/`, `packages/oriz-kit/`.

## Cross-refs

- [oriz-kit package name](../branding/oriz-kit-package-name.md)
- [AGENTS.md packages section](../../../AGENTS.md)
