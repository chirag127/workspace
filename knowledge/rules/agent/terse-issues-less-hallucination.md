---
type: rule
title: "Terse upstream issues + comments — less is less hallucination"
description: "GitHub issues and comments: short, factual, no filler. Every unverified claim is a potential hallucination. Min words = min risk."
tags: [rules, agent, issues, github, caveman, hallucination]
timestamp: 2026-07-01
format_version: okf-v0.1
status: active
related:
  - rules/agent/caveman
  - rules/agent/knowledge-everything-caveman
  - rules/agent/ponytail
---

# Terse upstream issues + comments

## Rule

When filing GitHub issues or comments: **shorter = better**. Every extra sentence is a sentence that could be wrong.

## Why

- Hallucinations scale with word count. One wrong sentence in a 20-line issue poisons the whole report.
- Maintainers read terse issues faster. Long issues get dismissed.
- Unverified claims (guessed API names, assumed version numbers, speculative "maybe this is caused by X") are worse than silence.

## Hard limits

| Surface | Max |
|---|---|
| Bug report body | 150 words |
| Feature request body | 100 words |
| Comment response | 50 words |
| Apology/acknowledgement | 1-2 sentences |

## What to include

- **Bug:** what happened, what expected, environment (OS, version, exact error). Nothing else.
- **Feature request:** one-line description, one-line use case, one-line existing-art reference if any.
- **Comment:** answer the specific question asked. No elaboration.

## What to cut

- "I think this might be because…" (speculation without proof → cut)
- "You could also consider…" (suggestions beyond the ask → cut)
- Long reproduction steps that aren't verified on this machine
- Version numbers you haven't confirmed
- Library/API names you haven't looked up
- "Hope this helps!" / "Thanks for the great app!" (noise)

## Pattern

```
## Problem
<one sentence>

## Steps
1. <exact step>
2. <exact step>

## Expected
<one sentence>

## Actual
<one sentence>

## Env
OS: Windows 11 26200, App: v1.2.3
```

No more. If you don't know a field — omit it, don't guess.
