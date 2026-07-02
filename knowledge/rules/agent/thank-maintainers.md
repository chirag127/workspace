---
type: rule
title: "Thank maintainers on every upstream issue/PR/comment"
description: "Every upstream contribution ends with a one-line thanks to the maintainer for their work on the project."
tags: [rules, agent, github, issues, community]
timestamp: 2026-07-01
format_version: okf-v0.1
status: active
related:
  - rules/agent/terse-issues-less-hallucination
  - rules/agent/caveman
---

# Thank maintainers on every upstream contribution

## Rule

Every GitHub issue, PR, or comment we file at an upstream repo ends with a one-line thanks. No exceptions.

## Format

Last line of the body:
```
Thanks for the great work on <project>!
```

Or, if we've filed multiple issues at same repo in same session, vary the phrasing:
- "Thanks for maintaining <project>."
- "Great tool — appreciate the work you put in."
- "Thanks for the excellent <project>."

## Why

- Maintainers do this for free. Acknowledgement costs nothing and softens the landing.
- Signals we are contributing in good faith, not dumping demands.
- Distinguishes our reports from bot-generated / low-effort issue spam.

## When to skip

- Never. Even bug reports get the thanks.
- Even security disclosures — the thanks becomes: "Thanks for the responsible-disclosure channel. Reporting: ..."

## Anti-patterns

- ❌ Bullet the thanks at the top → feels performative. Put it at the end.
- ❌ Skip it because "the issue is critical" → then it's still critical + polite.
- ❌ "Thanks in advance for looking into this!" → begging shape. Use past tense: "Thanks for the great work."

## Cross-refs

- [`terse-issues-less-hallucination`](./terse-issues-less-hallucination.md) — the thanks line does not violate the word cap; it's the last line, not the body.
