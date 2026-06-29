---
type: decision
title: "Headroom: always-on proxy (not on-demand)"
description: Headroom persistent background proxy. Idle RAM for zero cold-start. Starts at login
tags: [decision, agent-tooling, headroom, proxy, lifecycle]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - decisions/agent-tooling/headroom-install-all-paths-2026-06-26
  - decisions/agent-tooling/task-scheduler-at-login-2026-06-26
---

# Headroom: always-on proxy

## Decision

Headroom runs as a long-lived background process, started at user login and kept alive. Not on-demand spawned per invocation. Idle RAM cost (~30-60 MB) is accepted in exchange for zero cold-start on every call.

## Why

User locked this on 2026-06-26 (Q7). Cold-start latency compounds badly across the high-frequency call paths (every userscript HTTP call, every Claude tool call). Persistent process is cheaper net even with idle RAM.

## How to apply

- Single supervised process; restart on crash (Task Scheduler "restart on failure" or PM2-style supervisor).
- Listens on fixed loopback port + named pipe for MCP.
- No per-invocation fork/exec for the proxy itself — only the upstream backend may be lazy.
- Health endpoint at `/healthz` for monitoring.
- See [`task-scheduler-at-login-2026-06-26`](./task-scheduler-at-login-2026-06-26.md) for autostart wiring.

## Captured

2026-06-26 session, Q7 of 24-question grill.

## Related

- [`headroom-install-all-paths-2026-06-26`](./headroom-install-all-paths-2026-06-26.md)
- [`task-scheduler-at-login-2026-06-26`](./task-scheduler-at-login-2026-06-26.md)
