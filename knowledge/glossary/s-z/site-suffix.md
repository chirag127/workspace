---
type: glossary
title: "-site suffix"
description: "The -site suffix on website repo names (oriz-<name>-site)."
tags: [glossary, naming, sites]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# -site suffix

## Definition

The `-site` suffix is the family naming convention for website
repositories: `oriz-<name>-site` (e.g. `oriz-blog-site`).

## Expanded

Like the `-ext` suffix, this disambiguates sites from extensions and
packages in GitHub listings. The submodule directory under
`sites/oriz-<name>/` drops the `-site` because the parent path
already makes it unambiguous, but the GitHub repo keeps the full
suffixed name.

The 11 current sites all follow this convention; the `apps/api/`
Hono Worker is the deliberate exception (it is not a site and not a
submodule).

## See also

- [extension-suffix](./extension-suffix.md)
- [family](./family.md)
