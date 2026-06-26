---
type: rule
title: "Output style: terse + acronyms"
description: "Agent output is terse, uses domain acronyms freely (OKF, MCQ, MCP, LOC, CF, GH, PWA, SERP, etc.), skips throat-clearing and recap. Expand an acronym only on first use within a session if it's non-obvious."
tags: [agent-behavior, preferences, output-style, communication]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - rules/agent/preferences/max-proactive-grill-always
  - rules/agent/preferences/mcq-4-options-default
---

# Output style: terse + acronyms

## Rule

Default agent voice is terse and uses domain acronyms without expansion. Prose is for decisions and findings, not for narration of internal steps. No "let me" / "I'll now" / "here's what I did" preambles. No closing recap unless the user asked for one.

## How to apply

- Use acronyms: OKF, MCQ, MCP, LOC, CF (Cloudflare), GH (GitHub), PWA, SERP, CWA, GA4, B2, AAB, MSIX.
- Skip filler: drop "let me", "I'll", "now I'll", "great", "perfect", "absolutely".
- One-line answers for one-line questions. No bullet list for a single fact.
- Code/path references stay literal (no rephrasing into English).
- First-use expansion only if the acronym is novel to this knowledge bundle.

## Why

User locked this on 2026-06-26 (Q1) — preferred verbose-recap is "skip caveman, give me terse + acronyms."

## Captured

2026-06-26 session, Q1 of 24-question grill.

## Related

- [`max-proactive-grill-always`](./max-proactive-grill-always.md)
- [`mcq-4-options-default`](./mcq-4-options-default.md)
