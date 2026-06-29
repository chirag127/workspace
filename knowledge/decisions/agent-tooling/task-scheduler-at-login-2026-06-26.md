---
type: decision
title: "Headroom proxy auto-start via Windows Task Scheduler at login"
description: Headroom launches at logon via Task Scheduler. Runs as logged-in user with env + creds
tags: [decision, agent-tooling, headroom, autostart, windows, task-scheduler]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - decisions/agent-tooling/headroom-always-on-proxy-2026-06-26
  - decisions/agent-tooling/headroom-install-all-paths-2026-06-26
---

# Headroom autostart via Task Scheduler at login

## Decision

Headroom proxy is launched by a Windows Task Scheduler task triggered on user logon. Not a Windows Service (no SYSTEM-account env-var hassles, no LSA-secrets path). Not a Startup folder shortcut (no failure handling, no restart-on-crash).

## Why

User locked this on 2026-06-26 (Q11). Task Scheduler gets the user's HKCU env vars, has built-in restart-on-failure, and survives Windows updates better than service installs.

## How to apply

- Task name: `Headroom Proxy (oriz)`.
- Trigger: "At log on of <user>".
- Action: `wt.exe` (or hidden cmd) invoking the Headroom binary with `--persistent` flag.
- Settings: "If the task fails, restart every 1 minute" — up to 3 restarts.
- Run only when logged on (no need for SYSTEM execution).
- Install script lives in the Headroom repo's `scripts/install-windows.ps1`.

## Captured

2026-06-26 session, Q11 of 24-question grill.

## Related

- [`headroom-always-on-proxy-2026-06-26`](./headroom-always-on-proxy-2026-06-26.md)
- [`headroom-install-all-paths-2026-06-26`](./headroom-install-all-paths-2026-06-26.md)
