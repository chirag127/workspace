---
type: rule
title: "Single Claude config, always-Hr"
description: "Claude Code uses one settings.json that always routes through Headroom on :8787. No second config, no direct-to-Anthropic fallback, no profile-switching."
tags: [rules, agent-harness, claude-code, headroom, proxy, config]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/keep-hr-port-8787
  - decisions/architecture/agent-tooling/hr-hai-chain-2026-06-27
  - decisions/architecture/agent-tooling/headroom-always-on-proxy-2026-06-26
---

# Single Claude config, always-Hr

## Rule

Claude Code runs from a single `settings.json` whose API base URL is `http://localhost:8787` (Headroom). There is no second config, no toggle, no direct-to-Anthropic fallback path. If Hr is down, Claude Code stays down — that's the signal to fix Hr, not to bypass it.

## How to apply

- One `~/.claude/settings.json` (and `settings.local.json` overlay) — both point at Hr.
- No `ANTHROPIC_BASE_URL` env-var dance for "production vs dev" — same URL always.
- When Claude Code errors out with a connection refused on :8787, fix Headroom (check Task Scheduler, restart the process); don't reroute Claude Code.
- New machines: install Headroom first, then install Claude Code — config is identical on every box.
- See [`keep-hr-port-8787`](./keep-hr-port-8787.md) for why the port is also frozen.

## Why

User locked this on 2026-06-27 (Q14). Config-switching is the single biggest source of "wait, which provider am I talking to" confusion; collapse it to one path.

## Captured

2026-06-27 session, Q14 of the rules-lock grill round.

## Related

- [`keep-hr-port-8787`](./keep-hr-port-8787.md)
- [`hr-hai-chain-2026-06-27`](../../decisions/architecture/agent-tooling/hr-hai-chain-2026-06-27.md)
- [`headroom-always-on-proxy-2026-06-26`](../../decisions/architecture/agent-tooling/headroom-always-on-proxy-2026-06-26.md)
