---
type: decision
title: "Multi-provider auth — 6 providers on Firebase Auth, Apple deferred"
description: "The family's Firebase Auth project enables 6 sign-in providers: Email link, Google, GitHub, Anonymous, Microsoft (NEW), Passkeys/WebAuthn (NEW). Apple is deferred until the iOS app ships."
tags: [decisions, security, auth, firebase, microsoft, passkeys]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - services/auth/firebase-auth
  - services/auth/firebase-spark
  - services/auth/microsoft-sign-in
  - services/auth/passkeys
  - decisions/infrastructure/firebase-spark-forever
---

# Multi-provider auth — 6 providers on Firebase Auth, Apple deferred

## Decision

The family's single Firebase Auth project (`oriz-app`) enables
exactly **six** sign-in providers, in this order in the
`<AccountPanel>` UI:

1. **Email link** (passwordless magic-link)
2. **Google** (one-tap)
3. **GitHub**
4. **Anonymous**
5. **Microsoft** — NEW 2026-06-20
6. **Passkeys / WebAuthn** — NEW 2026-06-20

**Apple is deferred** — added only when the family ships its first
iOS app (Apple Store policy makes it mandatory only there). Phone,
Twitter / X, and Facebook are explicitly rejected.

## Why

- **Microsoft (Entra ID + personal MS accounts)** aligns with the user's [Azure for Students](../../services/tooling/azure-for-students.md) credit usage, and covers users whose only modern identity is a work / school Entra ID. Native to Firebase Auth via `OAuthProvider('microsoft.com')` — free, no extra service to integrate.
- **Passkeys** are now mainstream (2026); the OS provides the UX for free; phish-resistant + hardware-backed; no shared secret to leak. Recommended as the primary second factor for high-trust actions.
- **Apple deferred** because adding it requires a $99/yr Apple Developer Program membership (a paid subscription — fights the [no-paid-tier rule](../monetisation/no-subscriptions-anywhere.md)) and the family has no iOS surface yet. The cost only becomes worth it the moment iOS is shipping.

## Implications

- Firebase Console → Authentication → Sign-in method enables the 6 providers above; Apple is left disabled with a note explaining the deferral.
- New env vars: `MICROSOFT_OAUTH_CLIENT_ID`, `MICROSOFT_OAUTH_CLIENT_SECRET`, plus a passkey-specific RP ID set to `oriz.in` (covers every subdomain).
- Secrets land in [Doppler](../../services/secrets/doppler.md) and sync to Firebase config + the Hono Worker.
- `@chirag127/firebase-init` (the family's auth init package) gains two new buttons:
  - `<MicrosoftButton />` — uses `signInWithPopup(new OAuthProvider('microsoft.com'))`.
  - `<PasskeyButton />` — uses Firebase's passkey API; falls back to a `@simplewebauthn/server` flow on the Hono Worker if Firebase's native support is incomplete (verify before adoption — see [`services/auth/passkeys.md`](../../services/auth/passkeys.md)).
- Every site's `<AccountPanel>` automatically gets all 6 providers via the kit; per-site overrides via feature flags ([Hypertune](../../services/tooling/hypertune.md)) only.
- App Check + reCAPTCHA Enterprise stay in front of all 6 — bot defense is provider-agnostic.
- Apple is **not** stubbed — adding it later is a one-line config flip + button. No code is written for it now.

## What we don't do

- No phone / SMS auth — costs money even on Spark, phishable, redundant with passkeys.
- No Twitter / X — OAuth gates behind paid API tier (2026).
- No Facebook — privacy-policy / app-review work disproportionate to expected sign-ins.
- No password-based auth, ever — the family never accepts or stores a password.

## Cross-refs

- [Firebase Auth provider list service entry](../../services/auth/firebase-auth.md)
- [Firebase Spark service entry](../../services/auth/firebase-spark.md)
- [Microsoft sign-in service entry](../../services/auth/microsoft-sign-in.md)
- [Passkeys service entry](../../services/auth/passkeys.md)
- [Firebase Spark forever decision](../infrastructure/firebase-spark-forever.md)
- [Doppler — secrets sync source-of-truth](../../services/secrets/doppler.md)
- [No subscriptions anywhere](../monetisation/no-subscriptions-anywhere.md)
- [auth-domain glossary](../../glossary/a-c/auth-domain.md)
