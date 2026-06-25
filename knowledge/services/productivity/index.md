---
type: index
title: "Productivity services"
description: "Personal-productivity services for the user — Wakatime is the sole time-tracking pick (auto via IDE plugin). Toggl Track was considered + rejected on 2026-06-20 because manual timers violate the auto-only-tracking rule."
tags: [services, productivity, time-tracking, wakatime, toggl-rejected, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Productivity services

Personal-productivity services that capture signal from the
user's day-to-day workflow. Locked decision:
[`decisions/architecture/time-tracking-wakatime-only`](../../decisions/architecture/time-tracking-wakatime-only.md).

The family adopts **automatic** capture only — what the editor
*sees* (Wakatime). Manual capture (Toggl Track) was considered
and rejected on 2026-06-20 under the new family-wide
[auto-only-tracking rule](../../rules/interaction/auto-only-tracking.md):
manual timers decay (humans forget, fudge, skip), and dishonest
data is worse than no data. Non-coding time is intentionally
**not tracked** rather than manually tracked. Untracked time
is honest signal that the user was away from the keyboard.

## Active picks

| Service | Status | Role | Free tier |
|---|---|---|---|
| [wakatime.md](./wakatime.md) | active | Auto coding-time tracking via IDE plugin (sole pick) | Auto-tracking + rolling 2-week history + public dashboard |

## Rejected

| Service | Status | Why rejected |
|---|---|---|
| [toggl-track.md](./toggl-track.md) | rejected | Manual time tracking violates the [auto-only-tracking rule](../../rules/interaction/auto-only-tracking.md) (2026-06-20). Wakatime auto-tracks coding time; non-coding time is not tracked rather than manually tracked. |

## Surface coverage

| Activity type | Captured? | How |
|---|---|---|
| Coding (any IDE-seen edit) | YES | Wakatime auto via IDE plugin heartbeat |
| Meeting / call | NO (intentional) | Untracked — not a system metric |
| Planning / design / writing | NO (intentional) | Untracked — not a system metric |
| Reading / learning | NO (intentional) | Untracked — not a system metric |

If a non-coding-time signal is ever needed, the answer is
**make it auto** (e.g. calendar-API ingest), not "add a
manual tracker". See
[`decisions/architecture/auto-tracking-everywhere`](../../decisions/architecture/auto-tracking-everywhere.md).

## Lifestream ingest path

Wakatime exposes a REST API that the daily lifestream cron
job pulls and appends to
`oriz-me-data/lifestream/YYYY-MM-DD.jsonl` per
[`lifestream-jsonl-canonical`](../../decisions/architecture/lifestream-jsonl-canonical.md):

| Source | API | JSONL `type` |
|---|---|---|
| Wakatime | `wakatime.com/api/v1/users/current/summaries` | `code-summary-wakatime` |

The JSONL archive is the durable record — sidesteps Wakatime's
2-week free-tier history cap. Every other lifestream event
source is similarly auto (GitHub commits, npm publishes, CI
events, CF Web Analytics) — see
[`auto-tracking-everywhere`](../../decisions/architecture/auto-tracking-everywhere.md).

## Why auto-only

- **Manual tracking decays.** Humans forget timers, fudge stops,
  skip days. Resulting data is dishonest, which makes it worse
  than no data.
- **Untracked time is information.** A 2-hour gap in Wakatime
  data tells the user they were away from the keyboard — that's
  a fact, not a hole.
- **Recruiter-facing surface** — `wakatime.com/@chirag127` is
  the user's public coding-time dashboard, complementing the
  family's other public surfaces (GitHub profile, sponsor
  rails per [`max-payment-methods`](../../decisions/monetisation/max-payment-methods.md)).
- **Free, no-card** — fits
  [`rules/no-card-on-file`](../../rules/interaction/no-card-on-file.md) +
  [`rules/no-subscriptions`](../../rules/infrastructure/no-subscriptions.md).

## Cross-refs

- [Time-tracking — Wakatime only (decision)](../../decisions/architecture/time-tracking-wakatime-only.md)
- [Auto-only-tracking rule](../../rules/interaction/auto-only-tracking.md)
- [Auto-tracking-everywhere decision](../../decisions/architecture/auto-tracking-everywhere.md)
- [Lifestream JSONL canonical](../../decisions/architecture/lifestream-jsonl-canonical.md) — future ingest target
- [oriz-me added to family](../../decisions/branding/oriz-me-added-to-family.md)
- [Doppler — API tokens](../secrets/doppler.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [No subscriptions rule](../../rules/infrastructure/no-subscriptions.md)
