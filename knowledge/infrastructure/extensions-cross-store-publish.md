---
type: decision
title: "Every extension publishes to Chrome + Firefox + Edge stores"
description: 'Each extension: GH Actions publishes to Chrome, Firefox, Edge'
tags: [extensions, publishing, ci, github-actions]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - infrastructure/chrome-extensions-as-submodules
  - decisions/process/per-repo-ci-workflows
  - decisions/content/per-extension-privacy-policy
---

# Every extension publishes to Chrome + Firefox + Edge stores

## Decision

Every extension's GitHub repo includes an automated publish
workflow that releases the same packaged artifact to the Chrome Web
Store, Firefox Add-ons (AMO), and Microsoft Edge Add-ons store.
Single-store releases are not allowed.

## Why

The three stores collectively cover Chrome / Edge / Brave / Opera /
Firefox / Vivaldi / Arc / Zen and most other Chromium-based browsers
through the Chrome and Edge stores' policies. Skipping any one store
loses the user base that prefers it without saving meaningful work
once the publish workflow is templated. Publishing to all three on
the same release also keeps version numbers in sync, which matters
for support — a user reporting a bug on Edge isn't running a
month-old build vs Chrome.

## Implications

- Each extension repo carries a `.github/workflows/publish.yml` that runs on tag push, builds the artifact once, and submits to all 3 stores via their respective APIs.
- Store API credentials live in envpact and are pulled into the workflow via `chirag127/envpact-action@v0` with `ENVPACT_VAULT_TOKEN`.
- Manifest must be MV3-compatible across all 3 stores (Firefox MV3 is now stable). When a manifest change conflicts between stores, build a per-store variant in the workflow rather than dropping a store.
- Per-extension `/privacy` page (see [per-extension-privacy-policy](../content/per-extension-privacy-policy.md)) is required by all 3 stores' review processes.
- Failed-publish in any one store doesn't block the others — the workflow continues, surfaces the failure on the family status page.

## Cross-refs

- [Chrome extensions as submodules](./chrome-extensions-as-submodules.md)
- [Per-repo CI workflows](../process/per-repo-ci-workflows.md)
- [Per-extension privacy policy](../content/per-extension-privacy-policy.md)
- [Extension auth: Firebase + license-key fallback](./extension-auth-firebase-plus-license-key.md)
