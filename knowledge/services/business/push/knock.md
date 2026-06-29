---
type: service
title: "Knock"
description: "Multi-channel notification orchestration — 10K notifs/mo free, on top of FCM"
tags: [notifications, multi-channel, knock, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: notifications-multi-channel
provider: knock
free_tier: "10,000 notifications/month, unlimited workflows, all channels (in-app, email, SMS, web push, Slack), 30-day retention"
swap_cost: medium
related:
  - services/business/push/fcm
  - services/business/email/resend
  - decisions/architecture/notifications-fcm-plus-knock
---

# Knock

## Role

Notification **orchestration** — the family's single workflow engine
for cross-channel notifications. One Knock workflow per event type
(billing receipt, password change, comment reply, feature rollout)
fans out to the right channels in the right order, dedupes within a
window, and surfaces in-app + email + SMS + web push from one place.

Knock does not replace [FCM](./fcm.md) — FCM stays as the
**transport** for the web-push channel. Knock's web-push provider
config points at our Firebase project. Knock owns scheduling,
batching, channel selection, and per-user preference; FCM owns
"actually push to the browser." Same split for email
([Resend](../email/resend.md) is the SMTP transport behind Knock's
email channel).

## Free tier

- 10,000 notifications/month
- Unlimited workflows + recipients
- All channels — in-app, email, SMS, web push, Slack, Microsoft
  Teams, Discord
- 30-day notification log retention
- Branch-based environments (dev / staging / prod)
- Per-user preference center, quiet hours, digest windows

## Card / subscription required?

**NO.** Free-tier sign-up is email-only. No payment method requested.
Stays free as long as monthly volume stays under 10K notifications
across all channels.

## What runs through Knock

- **Billing receipts** — Razorpay / Lemon Squeezy webhook → Hono
  Worker → Knock workflow → email + in-app + (optional) SMS
- **Password / passkey changes** — Firebase Auth event → Worker →
  Knock workflow → email + SMS + web push
- **Comment-reply notifications** — Firestore trigger → Worker →
  Knock workflow → web push (FCM) + in-app
- **Feature rollout pings** — Hypertune flag flip → Knock workflow →
  in-app + opted-in web push

## Channel mapping

| Channel | Transport | Why Knock + transport split |
|---|---|---|
| Web push | [FCM](./fcm.md) | FCM is free unlimited on Spark + iOS PWA support |
| Email | [Resend](../email/resend.md) | Resend already wired for transactional |
| SMS | Knock-bundled (Twilio / MessageBird) | Pay-per-SMS only, no monthly fee |
| In-app feed | Knock-hosted | Drop-in `<KnockFeed />` component |
| Slack | Knock direct | Used for ops alerts only |

## Alternatives

- Courier — free 10K notifs/mo, similar model
- Novu — open-source, self-hostable; rejected per <!-- TODO: broken link, was [no-self-host](../../rules/no-self-host.md) -->
- Customer.io — paid only past 200 contacts
- Building it ourselves on Workers — re-implementing dedupe, digest,
  preference center, channel routing is months of work

## Swap cost

Medium — Knock workflow definitions live as YAML in the Knock
dashboard; export-to-JSON is supported. Swapping means recreating
workflows in Courier or similar. Channel transports (FCM, Resend) do
not change, so the Worker-side code stays the same.

## Why this is our pick

Free 10K/month is generous — the family's combined notification
volume across 11+ sites is well under that. The orchestration model
fits how we think about notifications (one event → many channels),
and it leaves FCM and Resend doing what they're best at. The
in-app feed component drops in as `<KnockFeed />` — saves us
building a notification center in `@chirag127/oriz-kit`.

## Cross-refs

- [FCM — web-push transport behind Knock](./fcm.md)
- [push services index](./index.md)
- [Resend — email transport behind Knock](../email/resend.md)
- [Notifications: FCM + Knock decision](../../decisions/architecture/notifications-fcm-plus-knock.md)
- [Hookdeck — webhook reliability for Razorpay → Knock](../tooling/hookdeck.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
