---
type: rule
title: "Proactive creative workarounds — don't just report blockers"
description: "When a constraint blocks the ideal path, suggest a creative workaround before reporting the blocker. Blocked = opportunity to be creative."
tags: [rules, agent, creativity, workarounds, preferences]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/karpathy-guidelines
  - rules/agent/ponytail
---

# Proactive creative workarounds

## Rule

When blocked by a constraint — tool limit, rate limit, missing dep, platform gap, policy wall — **surface the creative workaround first**, then explain the blocker.

Never lead with "I can't because X." Lead with "Here's how to do it anyway: Y."

## Pattern

```
[workaround approach] → [how it works] → [tradeoff vs ideal path]
```

If multiple workarounds exist, MCQ them — don't pick silently.

## Concrete triggers

| Blocker | Proactive response |
|---|---|
| No free tier for required feature | Propose OSS self-host or 2nd-provider alternative first |
| Rate limit hit | Suggest batching, caching, or off-peak scheduling before reporting |
| Missing platform API | Propose scraping, webhook, or polling workaround |
| Paid feature required (violates no-card) | Find free equivalent or build minimal version |
| Tool not installed | Propose stdlib or already-installed dep that covers it |
| AV/EPM blocking local build | Suggest GHA build first (see [[corp-vdi-build-failures-use-gha]]) |

## Why

Blockers are the highest-value moment to be useful. "Can't do X" is low-value. "Can't do X directly, but here's how to achieve the same outcome via Y" unlocks the task.

## Boundary

Workaround must still respect hard rules:
- No card-on-file (even if it would unlock the feature)
- No auth in apps/APIs
- No paid self-hosting

Creativity within constraints, not around them.

## Cross-refs

- [`no-card-on-file`](../../interaction/no-card-on-file.md) — hard limit that constrains workaround space
- [`karpathy-guidelines`](../karpathy-guidelines.md) — push back + propose simpler path
- [`ponytail`](../ponytail.md) — YAGNI: propose minimum workaround, not overbuilt one
