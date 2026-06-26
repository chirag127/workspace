---
type: decision
title: "Headroom → hai SAP proxy chain"
description: "Headroom (Hr) on :8787 is the single agent-facing proxy. It forwards SAP-routed requests to hai (:6655) which handles the actual SAP provider routing. Agents and userscripts only ever talk to Hr."
tags: [decision, agent-tooling, headroom, hai, proxy, sap, routing]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/agent-tooling/headroom-always-on-proxy-2026-06-26
  - rules/agent/single-claude-config-always-hr
  - rules/agent/keep-hr-port-8787
---

# Headroom → hai SAP proxy chain

## Decision

Headroom (Hr) on `localhost:8787` is the single agent-facing proxy. Hr does not implement SAP routing itself — it forwards SAP-routed requests to hai on `localhost:6655`, which owns provider routing, model fan-out, and SAP-specific transforms. Agents, userscripts, and Claude Code never talk to hai directly.

## Why

User locked this on 2026-06-27 (Q6). Two-layer split keeps Hr stable as the public surface (one port, one config, easy to swap clients) while hai absorbs the churn of SAP provider changes. Lets us upgrade hai independently without rewiring every client.

## How to apply

- All client config (Claude Code, userscripts, agents) points to `http://localhost:8787` — never `:6655`.
- Hr routes SAP-tagged requests via internal forward to hai on `:6655`; non-SAP traffic is handled in Hr.
- hai listens on loopback only; not exposed to other clients.
- When debugging a SAP-routing failure, check Hr logs first (request shape), then hai logs (provider response). Hr is the entry point.
- If hai is down, Hr must return a clear upstream-failure error, not crash.

## Captured

2026-06-27 session, Q6 of the rules-lock grill round.

## Related

- [`headroom-always-on-proxy-2026-06-26`](./headroom-always-on-proxy-2026-06-26.md)
- [`single-claude-config-always-hr`](../../../rules/agent/single-claude-config-always-hr.md)
- [`keep-hr-port-8787`](../../../rules/agent/keep-hr-port-8787.md)
