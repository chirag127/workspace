---
type: rule
title: "No Telegram — banned in India, propose GitHub Issues instead"
description: "Telegram is BANNED in India as of mid-2024; user cannot access it reliably. Replacement for drafts queue: GitHub Issues in a private repo. Replacement for notifications: GitHub repo notifications + email digest. Do NOT propose Telegram bot integrations for India-resident users, even if Telegram appears in legacy decision files."
tags: [rule, telegram, india-banned, drafts-queue, notifications, geo-constraint]
timestamp: 2026-06-21
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/drafts-queue-host
  - decisions/architecture/revenue-channels-2026
---

# No Telegram (India-banned)

## The rule

**Telegram is banned in India** (as of mid-2024, ongoing). The user (chirag127) is India-resident and cannot reliably receive Telegram messages, bot pings, or use Telegram channels.

**Do NOT** propose Telegram-based integrations:

- No Telegram bot for notifications
- No Telegram channels for drafts queue
- No Telegram-based admin dashboards
- No Telegram OAuth

Even if a legacy decision file (e.g. earlier omni-publish revisions in [[decisions/architecture/revenue-channels-2026]]) mentions Telegram, that mention is **superseded** by this rule.

## Replacements

| Use case | Replacement |
|---|---|
| Drafts queue (manual-publish channels) | Private GitHub repo with Issues — see [[decisions/architecture/drafts-queue-host]] |
| Notifications (CI alerts, deploy fail, etc.) | GitHub repo notifications + email digest (already covered by `gh notify` + Gmail filters) |
| Real-time chat / collaboration | Not used in the family — single-developer project |

## Env-var cleanup

`TELEGRAM_DRAFTS_BOT_TOKEN` and `TELEGRAM_DRAFTS_CHAT_ID` in `templates/.env.example` are kept for audit-trail reasons but marked DEPRECATED in comments. New env-var for the replacement: `OMNI_DRAFTS_GH_PAT`.

## If user travels outside India

Telegram becomes accessible. The rule still holds — the queue stays on GitHub Issues for audit-trail consistency; we don't switch transports based on user location.

## Cross-refs

- Drafts queue replacement → [[decisions/architecture/drafts-queue-host]]
- Where Telegram appeared previously → [[decisions/architecture/revenue-channels-2026]]
