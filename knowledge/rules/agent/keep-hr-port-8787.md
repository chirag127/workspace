---
type: rule
title: "Keep Headroom on :8787"
description: "Headroom listens on localhost:8787, permanently. No port migration, no env-override. Every client (Claude Code, userscripts, agents) hard-codes 8787."
tags: [rules, agent-tooling, headroom, proxy, port, config]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/single-claude-config-always-hr
  - decisions/architecture/agent-tooling/hr-hai-chain-2026-06-27
  - decisions/architecture/agent-tooling/headroom-always-on-proxy-2026-06-26
---

# Keep Headroom on :8787

## Rule

Headroom listens on `localhost:8787` and nowhere else. The port is frozen — no migration, no per-machine override, no env-var fallback. Every client config hard-codes 8787.

## How to apply

- Hr config: `port: 8787`, never read from env.
- Client configs (Claude Code, userscripts, agents): literal `http://localhost:8787`, no template variable.
- If 8787 is occupied on a new machine, kill the occupant — do not move Hr.
- Conflicts with another tool also wanting 8787 are resolved by moving the other tool. Hr is the anchor.
- Listed in `knowledge/services/` if/when a services index lands; clients can grep for `8787` to find every dependent.

## Why

User locked this on 2026-06-27 (Q13). Moving the port creates a config diff between machines and breaks any hard-coded client; the small cost of "what if 8787 is taken" is dwarfed by the churn cost.

## Captured

2026-06-27 session, Q13 of the rules-lock grill round.

## Related

- [`single-claude-config-always-hr`](./single-claude-config-always-hr.md)
- [`hr-hai-chain-2026-06-27`](../../decisions/architecture/agent-tooling/hr-hai-chain-2026-06-27.md)
- [`headroom-always-on-proxy-2026-06-26`](../../decisions/architecture/agent-tooling/headroom-always-on-proxy-2026-06-26.md)
