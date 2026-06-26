---
type: rule
title: "Log decisions only, not the grill trail"
description: "knowledge/ captures the *locked* decision, not the full Q&A transcript that led there. The grill conversation lives in chat history and (optionally) knowledge/log/grills/ as a per-batch summary — never inline in the decision file."
tags: [agent-behavior, knowledge, logging, decisions]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - rules/agent/per-batch-grill-log
  - rules/agent/write-commit-per-decision
  - rules/agent/self-update-rule
---

# Log decisions only, not the grill trail

## Rule

Decision files in `knowledge/decisions/` and rule files in `knowledge/rules/` capture the *locked output* of a grill — not the back-and-forth that produced it. The 24 options weighed, the dead-ends, the reversals: all live in chat history. Optional per-batch summary lives in `knowledge/log/grills/` (see [`per-batch-grill-log`](./per-batch-grill-log.md)).

## How to apply

- Decision/rule body: state the locked choice, the rationale in 1-2 sentences, how to apply, why.
- Do NOT include: "we first considered X, then Y, then Z, then user said..."
- Do NOT paste the AskUserQuestion options into the decision file.
- Per-batch grill summary (optional): `knowledge/log/grills/<date>-<topic>.md` — 1 paragraph summarising the session, NOT a transcript.
- Audit trail = git log + chat history; knowledge/ stays clean.

## Why

User locked this on 2026-06-26 (Q13). Knowledge files are read by agents at session start — they need the conclusion, not the deliberation. Trail-as-prose bloats retrieval.

## Captured

2026-06-26 session, Q13 of 24-question grill.

## Related

- [`per-batch-grill-log`](./per-batch-grill-log.md)
- [`write-commit-per-decision`](./write-commit-per-decision.md)
- [`self-update-rule`](./self-update-rule.md)
