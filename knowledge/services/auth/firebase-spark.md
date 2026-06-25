---
type: service
title: "Firebase Spark"
description: "Auth + Firestore on the free Spark plan — never upgraded to Blaze."
tags: [firebase, auth, firestore, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: auth-and-user-database
provider: google-firebase
free_tier: "Auth: unlimited users, 10K phone verifications/mo. Firestore: 1 GiB storage, 50K reads/day, 20K writes/day, 20K deletes/day, 10 GiB egress/mo."
swap_cost: high
---

# Firebase Spark

## Role

Auth + user database for every signed-in feature in the family.
Backs the Hono Worker at `api.oriz.in` and the per-site
`<AccountPanel>`.

## Free tier

- **Auth:** unlimited Google / GitHub / email-link / anonymous users.
  10K phone verifications / month.
- **Firestore:** 1 GiB storage, 50K reads/day, 20K writes/day, 20K
  deletes/day, 10 GiB egress/month.
- **App Check:** unlimited.

## Card / subscription required?

**NO.** Spark plan does not require a billing account. Upgrading to
Blaze would, which is exactly why the family rule is **never enable
Blaze**.

## Alternatives

- [Supabase](./supabase.md) — Postgres + Auth, fallback
- [Clerk](./clerk.md) — auth-only fallback
- Stack Auth, WorkOS

## Swap cost

High. Every site's `<AccountPanel>` reads from `[data-oriz-account-*]`
hooks wired into the `@chirag127/firebase-init` package. Schemas
migrate, Firestore security rules rewrite, and auth sessions don't
transfer.

## Why this is our pick

Free tier is wide enough to never throttle if we honor the
never-hit-quotas rule. Google's auth UI works on day one. The whole
family already standardises on `auth.oriz.in`.

## Cross-refs

- [Never enable Blaze](../../decisions/infrastructure/firebase-spark-forever.md)
- [Layer 3 — Firebase Spark](../../decisions/architecture/security/layer-3-auth-firebase-spark.md)
- [App Check](./app-check-firebase.md)
- [reCAPTCHA Enterprise](./recaptcha-enterprise.md)
