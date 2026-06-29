---
type: index
title: "Cron services"
description: "Two cron substrates with different jobs — Cloudflare Cron Triggers for in-Worker low-latency jobs, GitHub Actions schedule for build / publish jobs."
tags: [services, cron, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Cron services

The family runs a deliberate **two-substrate cron split** locked at
[`decisions/architecture/cron-split-cf-vs-gh.md`](../../decisions/architecture/cron-split-cf-vs-gh.md).
Pick the substrate by the job's shape, not by convenience.

| Service | Status | One-line role |
|---|---|---|
| [cloudflare-cron-triggers.md](./cloudflare-cron-triggers.md) | active | Low-latency in-Worker jobs (RSS poll, cache rebuild, idempotency sweeps) |
| [github-actions-schedule.md](./github-actions-schedule.md) | active | Build / publish / ops jobs (deploy matrix, npm publish, Dependabot, omnipost cron) |

## When to use which

| Job shape | Substrate | Why |
|---|---|---|
| Runs *inside* the Hono Worker, needs Worker bindings (KV, R2, D1, Queues, Service Bindings) | CF Cron Triggers | Same runtime, no token shuffle, sub-second cold start |
| Touches only first-party state (Firestore, Turso, R2) on a 1–60 min cadence | CF Cron Triggers | No GH Actions minutes burn |
| Needs to run `pnpm build` / `pnpm publish` / `wrangler deploy` / `gh release create` | GH Actions schedule | Has the toolchain + secrets + repo checkout for free |
| Reads from external HTTP APIs and writes commits back to a repo (e.g. oriz-omnipost state.json) | GH Actions schedule | Repo write access via the bot token |
| Must fail loudly into a CI dashboard humans already watch | GH Actions schedule | Built-in failure UX |

## Cross-refs

- [Cron split decision](../../decisions/architecture/cron-split-cf-vs-gh.md)
- [Cloudflare Workers service entry](../compute/cloudflare-workers.md)
- [GitHub Actions service entry](../compute/github-actions.md)
- [Cross-post engine — uses both substrates](../../decisions/architecture/cross-post-engine.md)
