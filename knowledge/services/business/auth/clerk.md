---
type: service
title: "Clerk"
description: "Fallback auth — 10K MAU free"
tags: [auth, clerk, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: fallback
role: auth-fallback
provider: clerk
free_tier: "10,000 monthly active users, all social providers, multi-factor, organizations"
swap_cost: high
---

# Clerk

## Role

Auth-only fallback if Firebase Auth becomes unavailable.

## Free tier

- 10,000 monthly active users
- All social providers + MFA
- Organizations / multi-tenant
- Pre-built React components

## Card / subscription required?

**NO.** Sign-up requires email only.

## Alternatives

- [Supabase](./supabase.md) — auth + DB
- [Firebase Spark](./firebase-spark.md) — primary

## Swap cost

High — every site's `<AccountPanel>` is wired to Firebase. Swap
replaces `@chirag127/firebase-init` with a Clerk equivalent + leaves
Firestore (no longer paired) needing a new home.

## Why fallback only

Lower MAU ceiling than Firebase Auth (10K vs unlimited), and Clerk
doesn't pair with a free database.

## Cross-refs

- [Firebase Spark](./firebase-spark.md) — primary
- [Supabase](./supabase.md)
