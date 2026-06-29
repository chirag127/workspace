---
type: service
title: "Firebase Cloud Messaging (FCM)"
description: "Web push transport — free unlimited on Spark, Knock on top for multi-channel"
tags: [push, fcm, firebase, web-push, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: web-push-transport
provider: firebase
free_tier: "Unlimited push notifications on Spark — no per-message cost, no daily cap"
swap_cost: low
related:
  - services/business/push/knock
  - services/business/auth/firebase-spark
  - decisions/architecture/notifications-fcm-plus-knock
  - infrastructure/firebase-spark-forever
---

# Firebase Cloud Messaging (FCM)

## Role

Web push transport for every family site + PWA. When a user opts in,
the browser registers a Service Worker, requests a token from FCM,
and we store the token on the user's Firebase Auth profile. Worker
endpoints (and [Knock](./knock.md), see below) deliver to those
tokens via the FCM HTTP v1 API.

## Free tier

- Unlimited push notifications — no per-message fee on Firebase Spark
- No daily cap, no monthly cap
- HTTP v1 API for server-side send (works from a Cloudflare Worker
  using OAuth-via-service-account; see
  [`services/business/auth/firebase-spark.md`](../auth/firebase-spark.md))
- iOS PWA support landed in iOS 16.4 — covered for free.

## Card / subscription required?

**NO.** Spark tier — the family's
[firebase-spark-forever decision](../../infrastructure/firebase-spark-forever.md)
locks Spark forever. No Blaze upgrade.

## Knock layered on top

FCM is the **transport** for browser push. As of 2026-06-20, every
notification is *orchestrated* by [Knock](./knock.md) — Knock owns
the workflow (which channels fire, in what order, with what dedupe
window), then dispatches to FCM for the web-push channel and to
Resend / SMS providers for email + SMS. The split is documented in
the [notifications-fcm-plus-knock decision](../../decisions/architecture/notifications-fcm-plus-knock.md).

Why we keep FCM as the transport instead of letting Knock send web
push directly: FCM is free unlimited on Spark, integrates natively
with our Firebase Auth user records (token storage on the user
profile), and ships first-class iOS PWA support. Knock's role is
orchestration only.

## Use cases (transport channel only — Knock owns orchestration)

- Comment-reply notifications (browser push when the user is offline)
- Billing receipts and renewal alerts (web-push channel — email +
  in-app via Knock as well)
- Password / passkey-change alerts (web-push channel — also email
  + SMS via Knock)
- Feature-flag rollout pings to opted-in users

## Alternatives

- OneSignal — free 10K subscribers, requires card past that
- Pusher Beams — free 1K concurrent, paid past that
- Web Push direct (no service) — works but no analytics, no token
  rotation handling, no batching

## Swap cost

Low — FCM HTTP v1 API is a thin wrapper over the W3C Web Push
protocol; swapping means rewriting the Worker's send function and
re-issuing tokens. Knock's web-push channel can also be pointed at
OneSignal or direct Web Push as a backup.

## Why this is our pick

Free unlimited on Spark. First-class web-push + iOS PWA support.
Native to the family's existing Firebase Auth project — no new
account, no new SDK, tokens live on the user profile. Knock layers
on top for multi-channel orchestration without forcing us to leave
Firebase for the actual delivery.

## Cross-refs

- [Knock — multi-channel orchestration on top](./knock.md)
- [push services index](./index.md)
- [Firebase Spark — auth + free tier](../auth/firebase-spark.md)
- [Notifications: FCM + Knock decision](../../decisions/architecture/notifications-fcm-plus-knock.md)
- [Firebase Spark forever](../../infrastructure/firebase-spark-forever.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
