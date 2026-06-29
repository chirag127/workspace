---
type: glossary
title: "-ext suffix"
description: -ext suffix on Chrome extension repo names (oriz-<name>-ext)
tags: [glossary, naming, extensions]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# -ext suffix

## Definition

The `-ext` suffix is the family naming convention for browser
extension repositories: `oriz-<name>-ext` (e.g. `oriz-foo-ext`).

## Expanded

The suffix makes extensions immediately distinguishable from sites in
GitHub listings and in the master repo's submodule tree. Each
extension lives at `extensions/<name>/` (the directory drops the
`oriz-` prefix and `-ext` suffix because the parent path already
disambiguates) but the underlying repo keeps the full
`oriz-<name>-ext` name.

Every extension is published to Chrome, Firefox, and Edge stores via
its own GitHub Actions workflow.

## See also

- [site-suffix](../s-z/site-suffix.md)
- [family](./family.md)
