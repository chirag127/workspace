---
type: service
title: "Supabase"
description: "Fallback Auth + Postgres — 500 MB DB free"
tags: [auth, database, supabase, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: fallback
role: auth-and-db-fallback
provider: supabase
free_tier: "500 MB Postgres, 1 GB file storage, 50K monthly active users, 2 GB egress, 2 free projects"
swap_cost: high
---

# Supabase

## Role

Documented fallback for [Firebase Spark](./firebase-spark.md) — auth +
relational DB if Firebase ever becomes untenable.

## Free tier

- 500 MB Postgres
- 1 GB file storage
- 50,000 monthly active users (Auth)
- 2 GB egress
- 2 free projects (paused after 7 days inactivity on free)

## Card / subscription required?

**NO.** Free tier is sign-up-only. Note: free projects are paused
after 7 days of inactivity — that's a quirk, not a billing trigger.

## Alternatives

- [Clerk](./clerk.md) — auth-only
- Stack Auth, WorkOS

## Swap cost

High — Firestore schemas would be re-modeled to relational Postgres,
security rules rewrite into RLS policies, the `firebase-init` package
replaces with a `supabase-init` equivalent.

## Why fallback only

Firebase's free tier is wider on auth (unlimited MAU) and Firestore
fits document data better than relational. Supabase wins on SQL
ergonomics, which we don't need yet.

## Cross-refs

- [Firebase Spark](./firebase-spark.md) — primary
- [Clerk](./clerk.md)
