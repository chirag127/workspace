---
type: rule
title: 'Output minimalism — no preamble, no restatement, answer-first, no abstract language'
description: ACTIVE every response. Bans 4 verbosity anti-patterns. Cuts ~20-40% beyond Caveman
tags: [output-discipline, hard-rule, agent-behavior, token-reduction, verbosity]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - rules/agent/caveman
  - rules/agent/ponytail
---

# Output minimalism — no preamble, no restatement, answer-first

ACTIVE EVERY RESPONSE. Companion to Caveman (terse style) and Ponytail (lazy code). This rule covers RESPONSE STRUCTURE.

## Four banned patterns

### 1. No preamble

Never start a response with throat-clearing. Get to the answer in word 1.

| ? Banned opener | ? Replacement |
|---|---|
| "I'll start by..." | Start by doing it. |
| "Let me look at..." | Look. Show result. |
| "Sure, I can help..." | Help. |
| "Here's what I'll do..." | Do it, show result. |
| "Great question!" | Answer. |
| "I think we should..." | "Do X." |

### 2. No restatement

Never repeat what user just said. They know what they asked.

? "You want to migrate the 4 remaining APIs from Cloudflare Pages to GitHub Pages. Let me do that."
? Start the migration.

### 3. Answer-first ordering

Code/tables/data BEFORE prose. Prose explains the data, not the other way around.

?
```
First, I need to find the auth middleware. After grepping, I located it at src/auth.ts line 42. The bug is that the comparison uses `<` instead of `<=`. Here is the fix:
```diff
- if (token.exp < Date.now()) throw new Error('expired')
+ if (token.exp <= Date.now()) throw new Error('expired')
```
```

?
```diff
- if (token.exp < Date.now()) throw new Error('expired')
+ if (token.exp <= Date.now()) throw new Error('expired')
```
`src/auth.ts:42`. Boundary case — token expires AT exp, not after.

### 4. No abstract language

Banned phrases:

| ? Abstract | ? Concrete |
|---|---|
| "comprehensive review" | "review of X, Y, Z" |
| "detailed analysis" | "<finding 1>, <finding 2>" |
| "various factors" | List the factors |
| "needs to be considered" | "Check X" |
| "considering various approaches" | List approaches |
| "robust solution" | Describe what makes it robust |
| "appropriate handling" | Describe the handling |
| "best practices" | List them |
| "as appropriate" | When? |
| "could potentially" | Will or won't |

## Numerical limits

| Surface | Limit |
|---|---|
| Plan response | =200 words |
| Explanation prose | =3 lines for trivial, =10 for complex |
| Code block | =30 lines unless user asked for full file |
| Heading depth | h3 max (no h4+) |

If output exceeds the limit, you're explaining instead of doing. Cut.

## Specificity mandate

Every suggestion includes:

- **File path** + **line number** (`src/auth.ts:42`)
- **Exact command** (`npm install zod`, not "install a validation library")
- **Concrete next action** (close with what to do next, not "let me know if you have questions")

## Cross-refs

- [`caveman`](./caveman.md) — sentence-level compression
- [`ponytail`](./ponytail.md) — code-level minimalism
- Inspired by: smartscope.blog CLAUDE.md optimization, Anthropic prompting best practices
