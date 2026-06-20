---
type: glossary
title: "oriz-kit"
description: "@chirag127/oriz-kit, the package re-exporting Firebase init + auth UI + contact form + sidebar + family config."
tags: [glossary, package, kit]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# oriz-kit

## Definition

`@chirag127/oriz-kit` is the umbrella package that re-exports the five
shared primitives every site in the family depends on, plus the family
constants.

## Expanded

The kit re-exports `@chirag127/firebase-init` (Firebase singleton),
`@chirag127/auth-ui` (`<AccountPanel>` + `<FinishSignIn>`),
`@chirag127/contact-form` (browser-only Web3Forms), `@chirag127/sidebar`
(Radix-Dialog drawer), and `@chirag127/oriz-family` (`FAMILY` +
`FAMILY_SITES` constants). It ships **no styles** — every primitive
exposes `[data-oriz-*]` attribute hooks that each site styles to its
own visual identity.

The kit was renamed from `oriz-ui` on 2026-06-20.

## See also

- [package-isolation](./package-isolation.md)
- [family](./family.md)
