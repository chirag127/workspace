---
type: rule
title: Future decisions override past decisions
description: "Chat contradicts file → chat wins, update same turn"
tags: [rules, agent, knowledge, authority]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - rules/agent/self-update-rule
---

# Future decisions override past decisions

Chat says X, knowledge says Y → **X wins**. Update file same turn.

## Why

Knowledge bundle = snapshot of last agreed. New chat = newer decision. Bundle encodes preferences, doesn't constrain them. Don't argue from bundle.

## How

1. Acknowledge new decision
2. Find contradicting file(s)
3. Update same turn (per [`self-update-rule`](../agent/self-update-rule.md))
4. Old worth keeping? Mark `status: superseded` + `superseded_by:` instead of delete

## Exceptions

Four mission-level non-negotiables (recruiter-impressing, lifelong archive, zero hosting cost, no card-on-file) need explicit confirmation before override.

## See also

- [`self-update-rule.md`](../agent/self-update-rule.md) — paired rule
- AGENTS.md "Authority order"
