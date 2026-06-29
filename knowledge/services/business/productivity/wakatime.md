---
type: service
title: "Wakatime"
description: "Free auto-tracking via IDE plugin — sole pick, auto-only, 2-week history"
tags: [services, productivity, time-tracking, wakatime, auto, ide-plugin, recruiter-facing, primary, sole-pick]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: time-tracking-coding
provider: wakatime
free_tier: "Auto-tracking via IDE plugin, daily / weekly / monthly charts, rolling 2-week history, public profile dashboard, REST API access"
swap_cost: low
related:
  - decisions/architecture/time-tracking-wakatime-only
  - decisions/architecture/auto-tracking-everywhere
  - rules/auto-only-tracking
  - services/business/productivity/toggl-track
  - rules/no-card-on-file
---

# Wakatime

## Role

The family's **automatic** coding-time tracker — and after the
2026-06-20 walk-back of [Toggl Track](./toggl-track.md), the **sole
time-tracking pick** family-wide. An IDE plugin
sends heartbeats on file activity to `wakatime.com`, which
classifies them by language / project / file / branch and
surfaces daily / weekly / monthly charts. Zero manual timers —
if the editor sees the user typing or scrolling, Wakatime
captures it. If the editor doesn't see it, it's untracked, and
that's intentional.

**Sole time-tracking pick.**
[Toggl Track was considered + rejected](./toggl-track.md) because
it requires manual timer start/stop, which violates the family-wide
[auto-only-tracking rule](../../rules/interaction/auto-only-tracking.md) locked
2026-06-20. Non-coding time (meetings, planning, calls) is
**intentionally not tracked** rather than manually tracked — manual
data decays, and untracked time is honest signal that the user was
away from the keyboard. See
[`decisions/architecture/time-tracking-wakatime-only`](../../decisions/architecture/time-tracking-wakatime-only.md)
for the walk-back narrative and
[`decisions/architecture/auto-tracking-everywhere`](../../decisions/architecture/auto-tracking-everywhere.md)
for the family-wide auto-only principle.

## Free tier

- **Auto-tracking** via IDE plugin (VS Code, Cursor, Sublime,
  JetBrains family, Vim, Emacs, Neovim, Visual Studio, Xcode,
  Atom — 50+ editors)
- **Daily / weekly / monthly charts** — language / project /
  editor / OS / file breakdowns
- **Rolling 2-week history** on the free tier (longer history
  needs Premium + card; the family solves this by daily
  lifestream export to JSONL — see below)
- **Public dashboard** at `wakatime.com/@<username>` (recruiter-
  facing) — the user's `@chirag127` profile is already public
- **REST API** access (`wakatime.com/api/v1`) for the future
  lifestream ingest job
- **Browser plugins** (Chrome / Firefox) optional for
  research / browsing-time tracking; opt-in.

## Card / subscription required?

**NO.** Free tier sign-up is email or GitHub sign-in. No
payment method requested. The 2-week history limitation is
mitigated by daily lifestream export to JSONL — the API
provides the funnel; JSONL is the durable archive.

## Setup (one-time per machine)

```bash
# VS Code / Cursor
code --install-extension WakaTime.vscode-wakatime

# JetBrains: Settings → Plugins → Marketplace → "WakaTime"

# API key from wakatime.com/settings/account, written to:
#   ~/.wakatime.cfg     (Linux / macOS / Windows %USERPROFILE%)
```

API key originates at
[Doppler](../secrets/doppler.md) per
[`secrets-management-doppler`](../../security/secrets-management-doppler.md);
distributed via `doppler run` or manual one-time write to the
config file.

## Lifestream ingest (future)

Per [`oriz-me-added-to-family`](../../branding/oriz-me-added-to-family.md)
+ [`lifestream-jsonl-canonical`](../../decisions/architecture/lifestream-jsonl-canonical.md):

```ts
// Daily cron — pull yesterday's summary, append to JSONL
const r = await fetch(
  'https://wakatime.com/api/v1/users/current/summaries' +
  '?start=' + yesterday + '&end=' + yesterday,
  { headers: { Authorization: 'Basic ' + btoa(API_KEY) } },
);
const { data } = await r.json();
// → { type: "code-summary-wakatime", ts, duration_s, language, project, editor }
```

This pattern also **side-steps the 2-week history limit** on
the free tier — the JSONL archive is the durable record;
Wakatime's UI is the live dashboard.

## Why this is our pick

- **Auto-tracking** removes the "did I forget to start the
  timer" failure mode for the surface (coding) where the user
  spends most of their time.
- **Public dashboard at `wakatime.com/@chirag127`** is a
  recruiter-facing artifact that documents "what the user
  actually uses day-to-day." Pairs with the
  everything-public-OSS posture per
  [`repos-work-independently`](../../rules/development/repos-work-independently.md)
  and the donation rails per
  [`max-payment-methods`](../../monetisation/max-payment-methods.md).
- **No card** — fits
  [`rules/no-card-on-file`](../../rules/interaction/no-card-on-file.md)
  + [`rules/no-subscriptions`](../../rules/infrastructure/no-subscriptions.md).
- **REST API** is well-documented; daily JSONL export pattern
  works around the 2-week history cap on the free tier.
- **IDE-plugin universe** covers every editor the family uses
  (VS Code, Cursor, JetBrains).

## Alternatives

- **[Toggl Track](./toggl-track.md)** — REJECTED 2026-06-20.
  Different surface (manual timers for non-coding work) but
  manual tracking is the rejection axis: violates the
  [auto-only-tracking rule](../../rules/interaction/auto-only-tracking.md).
- **RescueTime** — broader auto-tracker (browser, app,
  category) but full reports require Premium + card; overlaps
  Wakatime's coding scope without the IDE-classification depth.
- **Code::Stats** — similar shape, smaller community, fewer IDE
  plugins.
- **GitHub commit / push activity** — already tracked
  separately by GitHub's own profile graph; doesn't capture
  in-progress edits.
- **WakaPI** (self-host Wakatime-compatible) — fights the
  no-self-host posture; the family runs only managed
  serverless.

## Swap cost

Low — Wakatime's plugin is an IDE-side concern; swapping the
upstream means swapping the API key. Per-tool data is
exportable via API; the JSONL archive is provider-agnostic.

## Privacy posture

- Heartbeat payload includes file path, language, project
  name, branch, IDE, OS — no file *content*.
- Default project visibility is private; the user explicitly
  opts in to public dashboard for `@chirag127`.
- Per-project privacy can be flipped via `wakatime.com/settings`
  for any sensitive repo (none expected given the
  everything-public-OSS posture, but documented for
  completeness).

## Cross-refs

- [Time-tracking — Wakatime only (decision)](../../decisions/architecture/time-tracking-wakatime-only.md) — walk-back narrative for the original Toggl + Wakatime split
- [Auto-only-tracking rule](../../rules/interaction/auto-only-tracking.md) — why this is the sole pick
- [Auto-tracking-everywhere decision](../../decisions/architecture/auto-tracking-everywhere.md) — family-wide auto-only principle
- [Toggl Track — REJECTED counterpart](./toggl-track.md)
- [Productivity services index](./index.md)
- [Lifestream JSONL canonical](../../decisions/architecture/lifestream-jsonl-canonical.md) — future ingest target
- [oriz-me added to family](../../branding/oriz-me-added-to-family.md) — public surface for the dashboard
- [Doppler — API key vault](../secrets/doppler.md)
- [Repos work independently rule](../../rules/development/repos-work-independently.md) — public dashboard fits OSS posture
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
