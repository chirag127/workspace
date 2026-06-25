---
type: rule
title: "Knowledge — hard-delete superseded files"
description: When a decision is superseded, git rm the old file in the same commit that adds the new one. Audit trail lives in git history.
tags: [knowledge, okf, supersession, deletion, agent-rule]
timestamp: 2026-06-25
format_version: okf-v0.1
status: active
---

# Knowledge — hard-delete superseded files

When a knowledge decision is superseded:
1. `git rm` the old file
2. Create the new decision file in the same commit
3. List the deleted path(s) in the new file's `supersedes:` frontmatter array
4. Cross-link to the new file from any other knowledge that referenced the old one

The git history is the audit trail. `git log --follow --diff-filter=D -- <path>` recovers any deleted file. `git log --all -- <path>` shows the full lifecycle including renames.

## Why not keep superseded files on disk?

- A graveyard of dead files makes it harder to know what's current.
- `status: superseded` files clutter grep results.
- Pointer lines like `> SUPERSEDED 2026-06-25 by [X]` create dangling references when X itself gets superseded.

## Reversal note

Reverses the earlier (2026-06-25 morning) rule `knowledge-supersession-not-deletion`. Same day, opposite direction. Both decisions captured in memory + git history.
