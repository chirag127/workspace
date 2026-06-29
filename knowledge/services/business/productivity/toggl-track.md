---
type: service
title: "Toggl Track (REJECTED)"
description: "REJECTED — manual tracking violates auto-only rule, kept for audit"
tags: [services, productivity, time-tracking, toggl, manual, rejected]
timestamp: 2026-06-20
format_version: okf-v0.1
status: rejected
role: time-tracking-manual
provider: toggl
free_tier: "Up to 5 users, unlimited time entries, unlimited projects, unlimited clients, basic reports, REST API access"
swap_cost: low
rejection_reason: "Manual time tracking violates the auto-only-tracking rule (2026-06-20). Wakatime auto-tracks coding time; non-coding time is not tracked rather than manually tracked."
related:
  - decisions/architecture/time-tracking-wakatime-only
  - decisions/architecture/auto-tracking-everywhere
  - rules/auto-only-tracking
  - services/business/productivity/wakatime
  - rules/no-card-on-file
---

# Toggl Track (REJECTED)

> **Why rejected (2026-06-20):** Manual time tracking violates the
> family-wide [auto-only-tracking rule](../../rules/interaction/auto-only-tracking.md)
> locked the same day this service was originally adopted. Wakatime
> auto-tracks coding time; non-coding time is intentionally **not
> tracked at all** rather than manually tracked. Manual timers decay
> — humans forget to start, fudge stops, skip days — and the resulting
> data is dishonest, which makes it worse than no data. File kept for
> audit trail per the family pattern of "flip status, never delete".

## Role (was)

The family's **manual** time tracker for non-coding work — meetings,
calls, planning, design reviews, deep-work blocks, learning sessions,
admin. Adopted 2026-06-20 (Batch 19) as the manual half of a
Toggl + Wakatime split; walked back the same day later in 2026-06-20
when the auto-only-tracking rule was locked. See
[`decisions/architecture/time-tracking-wakatime-only`](../../decisions/architecture/time-tracking-wakatime-only.md)
for the walk-back narrative.

## What replaces it

Nothing. Non-coding time is not a system metric in the family. The
[auto-only-tracking rule](../../rules/interaction/auto-only-tracking.md) explicitly
distinguishes **metrics** (must auto) from **content** (manual writing
is fine — that's what the journal is). Time spent on meetings /
planning / calls is not a metric the family captures.

[Wakatime](./wakatime.md) remains the sole time-tracking pick — it
captures coding time automatically via IDE plugin heartbeat, no
manual start / stop required.

## Free tier (still valid, kept for record)

- Up to 5 users (would have used 1)
- Unlimited time entries
- Unlimited projects + clients + tags
- Basic reports + CSV export
- REST API access (`api.track.toggl.com/api/v9`)
- Cross-platform clients + Pomodoro timer + idle detection

## Card / subscription required?

**NO.** Free tier sign-up was email or Google sign-in. No payment
method requested. Free tier is permanent, not a trial. (Card-on-file
posture was fine — the rejection is on the manual-tracking dimension,
not the billing dimension.)

## Why this was originally picked (then walked back)

When Toggl was adopted earlier in 2026-06-20, the reasoning was:

- Manual timers capture **intent + context** (what the user *meant*
  to spend time on); auto-tracking captures actuals.
- Free unlimited entries with API access is rare among manual
  trackers.
- 5-user free tier with no card.

The walk-back logic: **manual capture decays.** The honest read of
"what was I doing during this 2-hour gap in Wakatime data?" is
"untracked", not "I should manually fill it in later." Untracked
time is a feature, not a bug — it tells the user they were away from
the keyboard, which is information.

## What this means concretely going forward

- **No Toggl Track account is created.** If one was created during
  the brief Batch 19 adoption window earlier today, it stays unused
  and will be deleted at next account-cleanup pass.
- **No `TOGGL_API_TOKEN`** in [Doppler](../secrets/doppler.md) or any
  runtime secret store.
- **No lifestream ingest** of Toggl data — the future
  [lifestream](../../decisions/architecture/lifestream-jsonl-canonical.md)
  pulls from auto sources only (Wakatime API, GitHub commits, npm
  publishes, CI events, CF Web Analytics — see
  [`auto-tracking-everywhere`](../../decisions/architecture/auto-tracking-everywhere.md)).
- **No manual-tracking surface** anywhere in the family (no
  Clockify, no Harvest, no spreadsheet, no app).

## Cross-refs

- [Auto-only-tracking rule (2026-06-20)](../../rules/interaction/auto-only-tracking.md) — the rule that rejects this service
- [Auto-tracking-everywhere decision](../../decisions/architecture/auto-tracking-everywhere.md) — the family-wide principle
- [Time-tracking — Wakatime only (decision, walk-back)](../../decisions/architecture/time-tracking-wakatime-only.md) — the rename of the original Batch 19 decision after the walk-back
- [Wakatime — sole time-tracking pick](./wakatime.md)
- [Productivity services index](./index.md)
- [Lifestream JSONL canonical](../../decisions/architecture/lifestream-jsonl-canonical.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md) — separate concern; Toggl was fine on this axis
