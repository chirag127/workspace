---
type: service
title: "Microsoft sign-in (Firebase OAuth provider)"
description: "Microsoft / Entra ID OAuth provider wired into Firebase Auth — free, unlimited, no card. Aligns with the family's Azure-for-Students stack."
tags: [auth, microsoft, oauth, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: auth-microsoft
provider: microsoft-via-firebase
free_tier: "Unlimited sign-ins. Microsoft personal + work/school accounts (Entra ID multi-tenant)."
swap_cost: low
---

# Microsoft sign-in (Firebase OAuth provider)

## Role

Lets a user sign in with a Microsoft personal account (`outlook.com`,
`live.com`, `hotmail.com`) or a work / school Entra ID tenant, against
the same `oriz-app` Firebase Auth project as every other provider.

## Free tier

- Unlimited Microsoft sign-ins through Firebase's `OAuthProvider('microsoft.com')`.
- Multi-tenant Entra ID app registration (so any Microsoft tenant works).
- No Microsoft / Azure billing required for the OAuth login flow.

## Card / subscription required?

**NO.** Native to Firebase Auth — Spark plan covers it. The
Azure-side app registration (Entra ID) is free under the standard
Microsoft account; it doesn't require an Azure subscription.

## Alternatives

- [Clerk](./clerk.md) — Microsoft is a one-click social provider there too
- [Supabase](./supabase.md) — Microsoft via OIDC
- Skip it (only Email link / Google / GitHub / Anonymous + Passkeys)

## Swap cost

Low — single `<AccountPanel>` button. Disabling Microsoft means
removing the OAuth provider config in Firebase Console + the button;
no schema changes.

## Why this is our pick

User runs Azure for Students for free Azure credits — adding a
Microsoft sign-in button keeps the auth UX aligned with where their
work / classroom identity already lives. Costs nothing on top of
[Firebase Spark](./firebase-spark.md). Native to Firebase Auth, so
it pairs cleanly with App Check + the same Firestore rules.

## Implementation notes

- Firebase Console → Authentication → Sign-in method → enable Microsoft.
- Register an Entra ID app at <https://entra.microsoft.com/> as
  multi-tenant + personal accounts (`AzureADandPersonalMicrosoftAccount`).
- Redirect URI: `https://oriz-app.firebaseapp.com/__/auth/handler`.
- Store `MICROSOFT_OAUTH_CLIENT_ID` + `MICROSOFT_OAUTH_CLIENT_SECRET`
  in [Doppler](../secrets/doppler.md), synced to Firebase config.

## Cross-refs

- [Firebase Auth provider list](./firebase-auth.md)
- [Firebase Spark](./firebase-spark.md)
- [Multi-provider auth decision](../../decisions/security/multi-provider-auth.md)
- [Azure for Students](../tooling/azure-for-students.md)
