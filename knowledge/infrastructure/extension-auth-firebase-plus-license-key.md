---
type: decision
title: "Extension auth: Firebase primary, license-key fallback"
description: 'Extensions: Firebase Auth + license-key fallback'
tags: [extensions, auth, firebase, license-key]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - infrastructure/firebase-spark-forever
  - monetisation/one-subscription-unlocks-all
  - infrastructure/chrome-extensions-as-submodules
  - architecture/layer-3-auth-firebase-spark
---

# Extension auth: Firebase primary, license-key fallback

## Decision

Extensions authenticate users via Firebase Auth as the primary path.
A license-key fallback exists for users who refuse Firebase
(privacy-paranoid users, regions where Google services are blocked):
they pay once, receive a license key, paste it into the extension,
and the extension verifies the key against the umbrella Hono Worker.

## Why

Firebase Auth via `chrome.identity.launchWebAuthFlow()` bouncing
through `auth.oriz.in` is the cheapest, fastest, most-recognized
auth pattern for extensions, and reuses the family's single Firebase
project. But some users explicitly reject Google-tied auth or live
where the auth domain doesn't reliably resolve. A license-key
fallback removes Firebase as a hard dependency for paying users
without compromising the primary path.

## Implications

- Primary path: `chrome.identity.launchWebAuthFlow()` opens `auth.oriz.in`, ID token returned to extension, stored in `chrome.storage.local`. Same Firebase user works on every site and every extension.
- License-key path: user pays via Razorpay (or whichever billing provider), receives a key by email, pastes into the extension settings. Extension calls `apps/api/routes/auth/verify-license` to validate.
- Firestore stores both: `users/{uid}/subscription` for Firebase users, and `licenses/{key}` for license-key holders. Same entitlement check covers both via the API.
- The license-key flow does NOT support cross-device sync (no Firestore user attached) — paranoid users accept that trade-off.
- Extension UI shows both options at sign-in: "Sign in with Google" (default) and "Use license key" (advanced).

## Cross-refs

- [Firebase Spark forever](./firebase-spark-forever.md)
- [ONE subscription unlocks everything](../monetisation/one-subscription-unlocks-all.md)
- [Chrome extensions as submodules](./chrome-extensions-as-submodules.md)
- [Layer 3 — Firebase Spark architecture](../architecture/security/layer-3-auth-firebase-spark.md)
