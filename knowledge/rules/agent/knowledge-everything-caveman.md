---
type: rule
title: "All durable knowledge in knowledge/ — caveman style, no exceptions"
description: "Everything worth remembering lives in knowledge/ as an OKF file. Caveman style: terse, dense, no filler. README/AGENTS.md stay lean."
tags: [rules, agent, knowledge, documentation, caveman]
timestamp: 2026-07-01
format_version: okf-v0.1
status: active
related:
  - rules/agent/self-update-rule
  - rules/agent/okf-lookup-before-acting
  - rules/agent/caveman
  - rules/agent/knowledge-deletion-not-supersession
  - _okf
---

# All durable knowledge in knowledge/ — caveman style

## Rule

Every durable fact — decisions, constraints, service details, runbook steps, architectural choices — lands in `knowledge/` as an OKF concept file. **No exceptions.** Not in chat. Not in memory. Not inline in README. Not in AGENTS.md body text.

## Caveman style mandate

Every `knowledge/` file uses caveman style:

- Drop articles (a/an/the)
- Drop filler (basically/really/just/very)
- Fragments over sentences
- Short synonyms (big not extensive, use not utilise)
- Tables over prose for comparisons
- Bullet lists over paragraphs
- No preamble — lead with the fact

Bad:
```
The reason we chose to use Cloudflare Pages as our primary hosting platform
is that it provides a number of advantages including generous free tier limits
and excellent performance characteristics for static sites.
```

Good:
```
CF Pages. Primary static host. 500 builds/mo free, unlimited bandwidth.
Why: fastest free CDN + Workers integration + no card required.
```

## What counts as "durable"

| Counts | Does not count |
|---|---|
| Decision between distinct options | Current task details |
| Service: free tier numbers, URL, auth method | Git history / commit messages |
| Rule: taste, constraint, hard limit | In-progress work state |
| Runbook: step-by-step procedure | Ephemeral debugging notes |
| Architecture: why X not Y | Conversational clarifications |

## Format every concept file gets

```yaml
---
type: decision | rule | runbook | service | glossary
title: "Terse title"
description: "One sentence — goes into the index"
tags: [keyword1, keyword2]
timestamp: YYYY-MM-DD
format_version: okf-v0.1
status: active
---
```

Then body in caveman style. No intro paragraph. Start with the fact.

## How agents use this

1. Before answering anything non-trivial: `python scripts/okf-prompt-lookup.py "<prompt>" --limit 3` (or hook fires automatically in CC)
2. After any decision lands in chat: write concept file + commit `docs(knowledge): <summary>`
3. Cite `knowledge/path/file.md` inline when answer depends on it
4. When existing file is wrong/stale: hard-delete + rewrite (no `status: superseded` flag — see [`knowledge-deletion-not-supersession`](./knowledge-deletion-not-supersession.md))

## Cross-refs

- [`self-update-rule`](./self-update-rule.md) — the protocol for writing concept files
- [`okf-lookup-before-acting`](./okf-lookup-before-acting.md) — the lookup hook
- [`caveman`](./caveman.md) — style guide this rule requires
- [`knowledge-deletion-not-supersession`](./knowledge-deletion-not-supersession.md) — no status flags; delete stale files
