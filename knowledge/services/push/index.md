---
type: index
title: "Push + notifications services"
description: "Web push transport (FCM) + multi-channel notification orchestration (Knock). Together they cover every notification surface across the family."
tags: [services, push, notifications, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Push + notifications services

The family runs a **two-layer notification stack**: orchestration on
top, transport underneath.

- [Knock](./knock.md) — orchestration. Owns workflows, channel
  selection, dedupe, digest windows, per-user preferences, and the
  in-app feed component.
- [FCM](./fcm.md) — web-push transport. Knock's web-push channel
  dispatches to FCM, which delivers to the browser. FCM is free
  unlimited on Firebase Spark + has first-class iOS PWA support.

Email transport behind Knock's email channel is
[Resend](../email/resend.md); SMS transport is Knock-bundled
(Twilio / MessageBird, pay-per-SMS only).

| Service | Status | One-line role |
|---|---|---|
| [knock.md](./knock.md) | active | Multi-channel notification orchestration — 10K notifs/mo free |
| [fcm.md](./fcm.md) | active | Web-push transport on Firebase Spark — free unlimited |

## Why split orchestration from transport?

- **Knock owns workflows** — one workflow definition per event type,
  fans to the right channels in the right order, with dedupe and
  preference handling. Building this on Workers is months of work.
- **FCM owns delivery** — free unlimited on Spark, iOS PWA support,
  tokens already live on Firebase Auth user records. No reason to
  let Knock re-do delivery.
- **Swap cost stays low at both layers** — switching orchestrators
  doesn't force us to re-issue browser push tokens; switching
  transports doesn't break workflows.

## Cross-refs

- [Notifications FCM + Knock decision](../../decisions/architecture/notifications-fcm-plus-knock.md)
- [Resend — email transport](../email/resend.md)
- [Firebase Spark — auth + free tier](../auth/firebase-spark.md)
- [Hookdeck — webhook reliability fronting Knock](../tooling/hookdeck.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
- [Never hit quotas rule](../../rules/never-hit-quotas.md)
