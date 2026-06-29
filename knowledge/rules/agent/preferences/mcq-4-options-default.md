---
type: rule
title: "4 options per MCQ (default)"
description: MCQs: exactly 4 ranked options (Recommended + 2nd choice + 2 others). Never 3 or 2
tags: [agent-behavior, preferences, mcq, askuserquestion]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - rules/agent/grill-me-default
  - rules/agent/auto-grill-on-architectural-decisions
---

# 4 options per MCQ (default)

## Rule

Every multi-choice question prompt MCQ ships exactly 4 ranked options. Option 1 = Recommended (suffix `(Recommended)`). Option 2 = 2nd choice (suffix `(2nd choice)`). Options 3-4 = other viable shapes. Never fewer than 4.

## How to apply

- Always 4 options. If you can't think of 4 viable shapes, you're not ready to ask — research first or grill at a different granularity.
- Rank explicitly: Recommended must be your honest top pick, not a "balanced" middle.
- Suffix `(Recommended)` and `(2nd choice)` are mandatory labels.
- Keep option labels short — long labels overlay decision-critical prose on Windows Git Bash TUI (known harness bug).
- Up to 4 questions per call (SDK limit); each question still gets its own 4 options.

## Why

User locked this on 2026-06-26 (Q5) — picked "4 options always" over "2-4 depending on fork width."

## Captured

2026-06-26 session, Q5 of 24-question grill.

## Related

- [`grill-me-default`](../grill-me-default.md)
- [`auto-grill-on-architectural-decisions`](../auto-grill-on-architectural-decisions.md)
