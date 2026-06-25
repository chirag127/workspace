---
type: glossary
title: "self-update rule"
description: "Every chat decision lands in knowledge/ in the same conversation."
tags: [glossary, rule, knowledge]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# self-update rule

## Definition

The self-update rule is the family's hard rule that every
architectural / naming / stack decision the user makes in chat MUST
be reflected in `AGENTS.md` (or a relevant `knowledge/` concept file)
before the conversation ends.

## Expanded

If `AGENTS.md` and a recent chat contradict, the chat wins and
`AGENTS.md` is wrong — update it in the same turn. The protocol when
a new decision lands: pick the right directory under `knowledge/`,
choose a kebab-case filename, write the file with full frontmatter,
append a one-line entry to `knowledge/log.md`, mark any superseded
concept with `superseded_by`, and commit with
`docs(knowledge): <one-line summary>` (no push without say-so).

If the agent fails to update, the agent has failed. Outdated concepts
get marked `status: superseded`, never deleted.

## See also

- [parallel-by-default](../o-r/parallel-by-default.md)
- [concept-file](../a-c/concept-file.md)
