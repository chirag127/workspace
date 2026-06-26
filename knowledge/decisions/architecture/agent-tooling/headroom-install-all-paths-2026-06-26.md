---
type: decision
title: "Headroom install: all paths (Claude Code + ScriptCat + standalone)"
description: "Headroom proxy is installed for all 3 access paths simultaneously: Claude Code (CLI), ScriptCat (browser userscript bridge), and standalone (direct local proxy). One binary, three entry points — no per-path forking."
tags: [decision, agent-tooling, headroom, proxy, install]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/agent-tooling/headroom-always-on-proxy-2026-06-26
  - decisions/architecture/agent-tooling/task-scheduler-at-login-2026-06-26
---

# Headroom install: all paths

## Decision

Install Headroom proxy with all 3 access paths active: Claude Code (CLI), ScriptCat (browser bridge), and standalone (direct local proxy on a fixed port). Same binary, three entry surfaces.

## Why

User locked this on 2026-06-26 (Q6). No per-path forking — one config file, three transports. Avoids version drift between Claude-only and browser-only installs.

## How to apply

- One install command brings up all 3 paths.
- Config lives in a single TOML/JSON; transports are toggles, not separate processes.
- ScriptCat path uses a userscript that calls the local proxy (per [`develop-userscripts`](file://~/.claude/skills/develop-userscripts/SKILL.md) skill conventions).
- Claude Code path uses MCP wire format on stdio or local socket.
- Standalone path = direct HTTP on fixed loopback port for ad-hoc curl/scripts.

## Captured

2026-06-26 session, Q6 of 24-question grill.

## Related

- [`headroom-always-on-proxy-2026-06-26`](./headroom-always-on-proxy-2026-06-26.md)
- [`task-scheduler-at-login-2026-06-26`](./task-scheduler-at-login-2026-06-26.md)
