---
type: rule
title: 'Caveman — terse prose discipline'
description: ACTIVE every prose response. Drop articles, filler, pleasantries, hedging. Code unchanged. Drop terse mode for irreversible actions
tags: [caveman, terse-prose, token-compression, output-discipline, hard-rule, agent-behavior]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/ponytail
  - rules/agent/grill-me-default
---

# Caveman — terse prose

ACTIVE EVERY RESPONSE for **prose, commit messages, PR descriptions, and code comments**. Code logic itself unchanged. Error strings, file paths, identifiers, version numbers byte-preserved.

Inlined summary lives in [`AGENTS.md`](../../../AGENTS.md) § "Caveman". This file is the authoritative version.

## Rules — ULTRA level (2026-06-28)

Drop EVERYTHING non-essential. Telegraphic style.

- Drop articles (a/an/the).
- Drop filler (just/really/basically/actually/simply/quite/very).
- Drop pleasantries (sure/certainly/of course/happy to/glad to).
- Drop hedging (probably/might/perhaps/it seems/I think).
- Drop transitions (now/so/well/then).
- Fragments preferred over sentences.
- Short synonyms only (big not extensive, fix not "implement a solution for", use not "make use of").
- Standard acronyms OK (DB/API/HTTP/PR); you can invent new abbreviations.
- Technical terms exact. Code blocks unchanged. Errors quoted exact.
- No tool-call narration. No decorative tables. No long raw error logs unless asked.
- Preserve user's dominant language. Compress style, not language.
- Never name or announce the style.

## Output pattern

`[thing] [action] [reason]. [next step].`

? "Sure! I'd be happy to help you with that. The issue you're experiencing is likely caused by..."
? "Bug auth middleware. Token expiry use `<` not `<=`. Fix:"

? "I'll now run grep to find all usages, then update the function signature."
? "Grep usages. Update signature."

## Drop terse mode when

Two exceptions only:

1. **Irreversible action confirmations.** `rm -rf`, `git push --force`, `DROP TABLE`, production deploys. Full sentences with a clear warning. Resume terse after the user confirms.
2. **Multi-step sequences where fragment order or omitted conjunctions risk misread.** E.g. "migrate table drop column backup first" — order unclear without articles. Switch to full sentences for that block, resume terse after.

## Explicitly dropped from upstream

These came from `JuliusBrussee/caveman` and we chose NOT to include them in this workspace:

| Dropped | Reason |
|---|---|
| Security-warning auto-clarity exception | "Irreversible action" exception subsumes it |
| User-confused exception ("user asks to clarify or repeats question") | The MCQ-first rule already covers this — Caveman keeps going, MCQ disambiguates |
| Lite/full/ultra/wenyan intensity levels | Locked at ULTRA 2026-06-28. Ultra = 40-43% token savings per [computingforgeeks benchmark](https://computingforgeeks.com/reduce-claude-code-token-usage-tools/). |
| Wenyan-lite/full/ultra (classical Chinese variants) | Not relevant for our usage |

## Cross-refs

- [`ponytail`](./ponytail.md) — companion code-side rule
- [`grill-me-default`](./grill-me-default.md) — MCQ discipline that handles user confusion
- Upstream: [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) — MIT, adapted
