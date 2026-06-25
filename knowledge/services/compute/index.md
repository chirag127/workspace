---
type: index
title: "Compute services"
description: "Edge compute, object storage, and build-time cron services."
tags: [services, compute, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Compute services

Cloudflare Workers is the entire runtime API surface (one Hono Worker at `api.oriz.in`). R2 is object storage. GitHub Actions runs build-time cron and CI.

| Service | Status | One-line role |
|---|---|---|
| [cloudflare-workers.md](./cloudflare-workers.md) | active | Edge compute — the Hono API umbrella |
| [cloudflare-r2.md](./cloudflare-r2.md) | active | S3-compatible object storage with no egress fees |
| [github-actions.md](./github-actions.md) | active | Build, deploy, and cron (matrix workflow per repo) |

## Cross-refs

- [Layer 5 — compute](../../decisions/architecture/general/layer-5-compute.md)
- [architecture/api-umbrella-hono-worker](../../decisions/architecture/compute/api-umbrella-hono-worker.md)
- [decisions/hono-worker-api-umbrella](../../decisions/architecture/hono-worker-api-umbrella.md)
- [decisions/per-repo-ci-workflows](../../decisions/process/per-repo-ci-workflows.md)
