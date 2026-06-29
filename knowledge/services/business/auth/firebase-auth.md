---
type: service
title: "Firebase Auth provider list"
description: "6 sign-in providers wired into family Firebase Auth project"
tags: [auth, firebase, providers, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: auth-provider-stack
provider: google-firebase
free_tier: "Unlimited users across all six providers; 10K phone verifications/mo (phone NOT used)"
swap_cost: high
---

# Firebase Auth provider list

This file lists every sign-in provider enabled on the family's
`oriz-app` Firebase Auth project. The auth backend itself is
documented in [`firebase-spark.md`](./firebase-spark.md); this is
the providers-and-roles view.

## The 6 active providers

| Provider | Status | Role | File |
|---|---|---|---|
| Email link (passwordless) | active | Lowest-friction sign-up — magic link to inbox | (built-in to Firebase Auth) |
| Google | active | One-tap sign-in for the largest user pool | (built-in) |
| GitHub | active | Developer-audience sites + extension publishers | (built-in) |
| Anonymous | active | Pre-account state — preserves UID across upgrade | (built-in) |
| Microsoft | active **(NEW 2026-06-20)** | Entra ID + personal accounts; Azure-stack alignment | [microsoft-sign-in.md](./microsoft-sign-in.md) |
| Passkeys / WebAuthn | active **(NEW 2026-06-20)** | Phish-resistant, passwordless | [passkeys.md](./passkeys.md) |

## Deferred / not yet enabled

| Provider | Status | When |
|---|---|---|
| Apple | deferred | Only when the family ships an iOS app — Apple's "Sign in with Apple" is a Store requirement only at that point |
| Phone | rejected | SMS costs money even on Spark; phishable; redundant with passkeys |
| Twitter / X | rejected | OAuth gates behind paid API tier (2026) |
| Facebook | rejected | Disproportionate privacy-policy work for low marginal sign-ins |

## Card / subscription required?

**NO.** All 6 active providers + Apple (when added) are native to
Firebase Auth on the Spark plan. Microsoft's Entra ID app
registration is free; passkey verification is free. No paid
provider, no SMS, no per-MAU billing.

## Why this set

- **Email link** — the universal "I don't want another account" path.
- **Google** — biggest existing-account pool; one tap.
- **GitHub** — every developer reading the family's blogs / docs / extensions already has one.
- **Anonymous** — lets users use the site before deciding to sign in; the anon UID upgrades into a real account preserving all data.
- **Microsoft** — added 2026-06-20 to align with [Azure for Students](../tooling/azure-for-students.md) usage and the chunk of users who only have a work / school Entra ID identity.
- **Passkeys** — added 2026-06-20 because passwordless + phish-resistant is now mainstream (2026), and the UX is free from the OS.
- **Apple deferred** because the only place the family is *required* to offer it is the iOS App Store — and the iOS app doesn't exist yet. Adding it earlier is dead surface area + an extra Apple Developer Program cost ($99/yr).

## Implementation notes

- Single Firebase project: `oriz-app`.
- Single auth domain: [`auth.oriz.in`](../../glossary/a-c/auth-domain.md) (Firebase Auth's hosted handler, custom-domained).
- Every site's `<AccountPanel>` reads from `[data-oriz-account-*]` hooks — adding / removing a provider only flips a feature flag, no per-site code change.
- Provider client IDs / secrets live in [Doppler](../secrets/doppler.md) under the `oriz-firebase` project, synced to Firebase config.

## Cross-refs

- [Multi-provider auth decision (2026-06-20)](../../security/multi-provider-auth.md)
- [Firebase Spark](./firebase-spark.md) — the auth + DB backend
- [microsoft-sign-in.md](./microsoft-sign-in.md)
- [passkeys.md](./passkeys.md)
- [App Check](./app-check-firebase.md) — gates Firestore behind verified clients
- [reCAPTCHA Enterprise](./recaptcha-enterprise.md) — App Check attestation provider
- [glossary/auth-domain](../../glossary/a-c/auth-domain.md)
