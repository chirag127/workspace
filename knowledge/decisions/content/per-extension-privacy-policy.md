---
type: decision
title: "Each extension has its own /privacy page; family boilerplate at oriz.in/privacy-base"
description: Per-extension /privacy. Boilerplate at oriz.in/privacy-base
tags: [extensions, privacy, policy, legal]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/content/per-extension-subdomain
  - decisions/content/extensions-catalog-and-subdomains
  - decisions/content/big-website-per-extension
---

# Each extension has its own /privacy page; family boilerplate at oriz.in/privacy-base

## Decision

Every extension's site at `<slug>.oriz.in` hosts its own
`/privacy` page describing the data that THAT extension collects.
The shared family-wide boilerplate (data we never collect, how
Firebase Auth works, how the license-key fallback works, contact
address, retention defaults) lives once at `oriz.in/privacy-base`
and is referenced from every per-extension privacy page.

## Why

Chrome / Firefox / Edge stores require a privacy URL per extension,
and listing the SAME apex URL for every extension fails review when
the page doesn't disclose extension-specific permission usage. Per-
extension pages keep store reviewers happy. The family boilerplate
exists so we don't repeat 500 lines of identical legalese in every
repo and so a single edit (e.g. updated retention period) propagates.

## Implications

- Each extension repo ships a `/privacy.astro` (or equivalent) listing its specific permissions, host_permissions, telemetry, third-party calls.
- That page imports / iframes / inlines the common-base content from `oriz.in/privacy-base`.
- The store listing's privacy URL points at `<slug>.oriz.in/privacy`, NEVER at `oriz.in/privacy-base` directly.
- Per-extension pages must explicitly enumerate every Chrome permission the manifest requests and the user-facing reason for each — this is the part that fails review when missing.
- When the family boilerplate changes, the per-extension pages don't need redeploy — they fetch / iframe live.

## Cross-refs

- [Per-extension subdomain](./per-extension-subdomain.md)
- [Extensions catalog AND per-extension subdomains](./extensions-catalog-and-subdomains.md)
- [Big website per extension](./big-website-per-extension.md)
- [Extensions cross-store publish](../infrastructure/extensions-cross-store-publish.md)
