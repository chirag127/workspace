---
type: architecture
title: Subscription flow — Razorpay → webhook → Firestore → every site
description: One subscription unlocks everything. User pays via Razorpay, webhook lands at api.oriz.in, Worker writes users/{uid}/subscription, every site and extension reads that doc to gate features.
tags: [architecture, subscription, razorpay, firestore, webhook]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - architecture/api-routes-structure
  - architecture/api-umbrella-hono-worker
  - architecture/cross-site-auth-via-auth-oriz-in
  - architecture/layer-3-auth-firebase-spark
  - architecture/service-bindings-future
---

# Subscription flow — Razorpay → webhook → Firestore → every site

## Concept

ONE subscription unlocks everything: every site, every extension, one
account, one payment. Razorpay is the primary provider (Indian-first,
supports UPI which Stripe still doesn't). The flow uses the same
webhook-to-Firestore pattern Stripe popularised.

## How it works

1. **Checkout** — user clicks Subscribe on any site, Razorpay Checkout
   opens client-side, payment completes
2. **Webhook** — Razorpay POSTs to `api.oriz.in/razorpay/webhook` (one
   of the routes under [api-routes-structure.md](api-routes-structure.md))
3. **Verify** — the Worker validates the webhook signature against the
   Razorpay webhook secret (held in Cloudflare Secrets)
4. **Write** — the Worker writes to `users/{uid}/subscription` in
   Firestore via `firebase-rest-firestore` (NOT firebase-admin —
   Workers gRPC limitation)
5. **Gate** — every site and every extension reads
   `users/{uid}/subscription` via the Firebase web SDK, gated by App
   Check + Firestore security rules

## Why this shape

Three properties matter:
- **One source of truth.** All subscription state lives at
  `users/{uid}/subscription` in `oriz-app`. No site has its own DB.
- **Atomic provider swap.** Replacing Razorpay with Stripe / Lemon
  Squeezy / Paddle is a webhook-handler change in `routes/razorpay/`,
  not a 50-file rewrite.
- **No cross-site coordination.** Sites don't ping each other when a
  subscription changes; they all read Firestore on demand.

If the privileged-blast-radius of holding the Razorpay webhook secret
in the same Worker as everything else gets uncomfortable, the
`razorpay/` folder moves to a privileged Worker behind a Service
Binding — see [service-bindings-future.md](service-bindings-future.md).

## Cross-refs

- The webhook route → [api-routes-structure.md](api-routes-structure.md)
- The auth that gives `{uid}` → [cross-site-auth-via-auth-oriz-in.md](cross-site-auth-via-auth-oriz-in.md)
- The Firestore tier the doc lives on → [layer-3-auth-firebase-spark.md](layer-3-auth-firebase-spark.md)
