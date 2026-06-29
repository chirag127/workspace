---
type: service
title: "Passkeys / WebAuthn"
description: "Passwordless WebAuthn sign-in via Firebase Auth passkey integration"
tags: [auth, passkeys, webauthn, passwordless, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: auth-passwordless-webauthn
provider: firebase-auth-or-simplewebauthn
free_tier: "Unlimited passkey registrations + assertions"
swap_cost: medium
---

# Passkeys / WebAuthn

## Role

Phish-resistant, passwordless sign-in. The user's device (Touch ID,
Face ID, Windows Hello, Android biometric, hardware key) is the
authenticator; the family never holds a password.

Used as a first-class sign-in option on every site's
`<AccountPanel>` and as the **strongly recommended** second factor
for high-trust actions (subscription cancel, data export, journal
unlock).

## Free tier

- Unlimited registrations + assertions.
- No per-user / per-event cap on Firebase Spark.
- If we fall back to a self-hosted [`@simplewebauthn/server`](https://simplewebauthn.dev)
  flow on the Hono Worker, the only cost is Worker / Firestore quota
  (already free).

## Card / subscription required?

**NO.** Passkeys are an open W3C standard (WebAuthn level 2 / 3).
Firebase's passkey integration is part of Auth — Spark plan covers
it. SimpleWebAuthn is MIT-licensed.

## Implementation path

1. **Primary path — Firebase Auth's passkey support.** Enable
   passkeys in Firebase Console → Authentication → Sign-in method.
   Wire the JS SDK's passkey APIs into `@chirag127/firebase-init`
   so every site's `<AccountPanel>` shows a "Sign in with passkey"
   button.
2. **Escape hatch — `@simplewebauthn/server` on the Hono Worker.**
   If Firebase's passkey support is incomplete for our needs (e.g.
   missing conditional UI, missing username-less flow, or an
   uncovered platform), fall back to a Worker-side WebAuthn flow:
   - `/auth/passkey/register/options` — issue
     `PublicKeyCredentialCreationOptions`.
   - `/auth/passkey/register/verify` — verify + persist credential
     ID + public key in Firestore under `users/{uid}/passkeys/{id}`.
   - `/auth/passkey/authenticate/options` + `.../verify` — the
     authentication side.
   - On success, mint a Firebase custom token via Firebase Admin's
     REST endpoint (per [`firebase-rest-firestore-not-admin.md`](../../decisions/architecture/firebase-rest-firestore-not-admin.md))
     and `signInWithCustomToken` on the client.

   Verify Firebase's native support before adopting the escape hatch.

## Alternatives

- Email link only (loses phish resistance)
- TOTP / SMS as second factor (SMS is paid + phishable)
- Passwords (rejected family-wide — never store or accept passwords)

## Swap cost

Medium — credential records persisted under
`users/{uid}/passkeys/{id}` would migrate if we changed the verifier
(Firebase native ↔ SimpleWebAuthn). Public-key material is portable;
the wire format is the same in both directions.

## Why this is our pick

Phish-resistant, hardware-backed, no shared secret. Modern browsers
+ OSes ship the UX for free. Passkey adoption is mainstream now
(2026), so showing it in the sign-in dialog raises perceived
security without any extra dev cost.

## Cross-refs

- [Firebase Auth provider list](./firebase-auth.md)
- [Firebase Spark](./firebase-spark.md)
- [App Check](./app-check-firebase.md)
- [Multi-provider auth decision](../../security/multi-provider-auth.md)
- [firebase-rest-firestore-not-admin](../../decisions/architecture/firebase-rest-firestore-not-admin.md)
