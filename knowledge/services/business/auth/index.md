---
type: index
title: "Auth + bot defense services"
description: "User auth, bot defense, and account-management services for the oriz family."
tags: [services, auth, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Auth + bot defense services

Firebase Spark is the single auth backend for every site (and for extensions, paired with a license-key fallback). The provider list is locked at 6 active sign-in providers — see [`firebase-auth.md`](./firebase-auth.md) for the full table. App Check + reCAPTCHA Enterprise sit in front of Firestore.

| Service | Status | One-line role |
|---|---|---|
| [firebase-spark.md](./firebase-spark.md) | active | Auth + user DB (Firestore) on the free Spark tier |
| [firebase-auth.md](./firebase-auth.md) | active | The 6-provider sign-in stack wired into the Firebase Auth project |
| [microsoft-sign-in.md](./microsoft-sign-in.md) | active | Microsoft / Entra ID OAuth provider (NEW 2026-06-20) |
| [passkeys.md](./passkeys.md) | active | Passkeys / WebAuthn — passwordless, phish-resistant (NEW 2026-06-20) |
| [app-check-firebase.md](./app-check-firebase.md) | active | Gates Firestore calls to verified clients |
| [recaptcha-enterprise.md](./recaptcha-enterprise.md) | active | Bot risk assessments at sensitive endpoints |
| [supabase.md](./supabase.md) | fallback | Auth + Postgres swap target if Firebase Spark dies |
| [clerk.md](./clerk.md) | fallback | Auth-only swap target |

## Cross-refs

- [Layer 3 — auth (Firebase Spark)](../../security/layer-3-auth-firebase-spark.md)
- [security/multi-provider-auth](../../security/multi-provider-auth.md) — locks the 6-provider stack
- [infrastructure/firebase-spark-forever](../../infrastructure/firebase-spark-forever.md)
- [infrastructure/extension-auth-firebase-plus-license-key](../../infrastructure/extension-auth-firebase-plus-license-key.md)
- [glossary/a-c/app-check](../../glossary/a-c/app-check.md)
