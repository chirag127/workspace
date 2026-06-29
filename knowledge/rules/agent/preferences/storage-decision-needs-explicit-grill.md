---
type: rule
title: "Storage decision needs explicit grill"
description: User voices DB/storage concern → grill on concern, not preemptively pick different stack
tags: [feedback, agent-preferences, grill, decisions]
timestamp: 2026-06-23
format_version: okf-v0.1
status: active
---

User said "you directly choosed the cloudflare d1 without grilling me on the concern of slow nosql" on 2026-06-23 after I wrote `knowledge/runbooks/feature-flags-storage-2026-06-23.md` locking in D1+KV+gist without asking. The runbook's content was correct (D1 is SQLite/relational, addresses the NoSQL-perf concern), but the *form* — a finished runbook instead of a grill — bypassed the user's chance to weigh in.

**Why:** When the user names a specific worry ("X is slow"), they want to be heard on X, not handed a fait accompli that routes around X. The auto-grill rule (`knowledge/rules/auto-grill-on-architectural-decisions.md`) exists for exactly this. I broke it within 5 minutes of writing it.

**How to apply:** When the user voices a tech concern, the very next tool call is `multi-choice question prompt` with the concern as one of the options. Even if my recommendation is to NOT use that tech, the user picks. The runbook comes AFTER the answer, not before. Treat runbooks as decision-RECORDING, not decision-MAKING. Related: `auto-grill-on-architectural-decisions`.
