---
type: rule
title: "Per-batch grill log granularity"
description: Grill sessions logged at batch granularity — one log per session. Lives in knowledge/log/grills/
tags: [agent-behavior, knowledge, log, grill, granularity]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - agent-rules/keep-knowledge-fresh
  - decisions/knowledge-bundle/hierarchy-add-log-concepts-playbooks-2026-06-26
---

# Per-batch grill log granularity

## Rule

One grill session = one log file. A "grill session" = the contiguous batch of related questions answered in one sitting (could be 4 questions or 24). Not per-question (too granular). Not per-day (too coarse if multiple unrelated grills happen).

## How to apply

- Path: `knowledge/log/grills/<YYYY-MM-DD>-<topic-slug>.md`.
- Frontmatter: `type: log`, `title`, `description`, `tags`, `timestamp`, `format_version`, `status`.
- Body: 1 paragraph context + bulleted list of locked decisions (with links to the actual rule/decision files).
- Do NOT paste the Q&A transcript — see [`keep-knowledge-fresh`](./keep-knowledge-fresh.md) §4 current-truth-only.
- If two unrelated grills happen the same day, two files: `<date>-<topic-a>.md` and `<date>-<topic-b>.md`.
- If a grill spans two sessions (resumed next day), one file dated by start date with a note about resumption.

## Why

User locked this on 2026-06-26 (Q15). Per-question = noise; per-day = collisions; per-batch = matches how grills actually map to decisions.

## Captured

2026-06-26 session, Q15 of 24-question grill.

## Related

- [`keep-knowledge-fresh`](./keep-knowledge-fresh.md)
- [`hierarchy-add-log-concepts-playbooks-2026-06-26`](../../decisions/knowledge-bundle/hierarchy-add-log-concepts-playbooks-2026-06-26.md)
