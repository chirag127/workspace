---
type: policy
title: "Per-extension privacy policy with shared boilerplate"
description: "Each Chrome extension has its own /privacy page tailored to its permissions. A family boilerplate at oriz.in/privacy-base supplies common content."
tags: [policy, privacy, extensions, compliance]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
annual_review: true
related:
  - policy/secrets-handling
  - policy/public-private-line
---

# Per-extension privacy policy with shared boilerplate

## The policy

Every Chrome / Firefox / Edge extension ships its own `/privacy` page
that enumerates the permissions that extension actually requests and
the data flows it actually performs; common content (operator
identity, contact email, never-collected data, complaint process)
lives in a single `oriz.in/privacy-base` page that each extension's
privacy page references.

## Scope

- Every extension submodule under `extensions/<name>/`.
- The catalog at `extensions.oriz.in` and the cross-promo route at
  `oriz.in/extensions`.
- The shared boilerplate at `oriz.in/privacy-base`.

## Rules

- **One privacy page per extension.** Each extension repo owns
  `/privacy` (or `/privacy-policy/`) on its landing page. The store
  listing's privacy URL points at this page.
- **Permissions-specific content.** The extension's privacy page
  enumerates ONLY the permissions that extension actually requests in
  its `manifest.json` — `host_permissions`, `storage`, `activeTab`,
  `identity`, etc. — and the user-visible behaviour each enables.
  Listing permissions the extension does not use is misleading; not
  listing requested permissions is a Chrome Web Store rejection
  trigger.
- **Family boilerplate at `oriz.in/privacy-base`.** The shared page
  carries:
  - Operator identity (Chirag Singhal, India).
  - Contact email for privacy questions.
  - Categorical "never collected" list — full browsing history,
    keystrokes, payment details, government IDs.
  - GDPR / DPDP / CCPA data-subject request process and timeline.
  - Complaint / takedown process.
  - Effective date + revision log.
- **Cross-link, don't copy.** Each extension privacy page links to the
  base page rather than inlining the boilerplate. When the boilerplate
  changes, every extension picks up the change without a re-publish.
- **Material changes trigger an extension re-publish.** A change that
  affects what an extension specifically collects (e.g. adding a new
  host permission) requires updating that extension's own privacy
  page AND submitting an updated build to the store.
- **Auth flow disclosure.** Extensions using Firebase Auth via
  `chrome.identity.launchWebAuthFlow()` disclose: the redirect to
  `auth.oriz.in`, the ID token stored in `chrome.storage.local`, the
  account scope (email + display name), and that the same Firebase
  user works across the family.
- **License-key extensions.** Extensions using the license-key
  fallback disclose: the key value is stored in `chrome.storage.local`,
  no email or account is collected.

## Exceptions

- **Extensions with zero data flow.** A purely-local extension that
  never makes a network request and stores nothing may use only the
  family boilerplate plus a single line stating "this extension makes
  no network requests and stores no data" — no per-extension page
  required.

## Annual review

Each year, re-read the Chrome Web Store, Firefox Add-ons, and Edge
Add-ons developer policies for changes to required disclosure fields.
Re-read GDPR / DPDP / CCPA for changes to the DSR process. Update the
boilerplate in the same review session.

## Cross-refs

- [`./secrets-handling.md`](./secrets-handling.md) — how the disclosed credential storage actually works
- [`./public-private-line.md`](./public-private-line.md) — visibility tiers that govern what an extension may even attempt to collect
- `../../AGENTS.md` § Chrome extensions — auth flow and license-key fallback details
