---
type: glossary
title: "submodule pointer"
description: Master oriz repo recorded SHA per submodule; production state contract
tags: [glossary, git, submodule]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# submodule pointer

## Definition

A submodule pointer is the exact commit SHA the master `chirag127/oriz`
repo records for each of its submodule directories — the contract for
what gets deployed to production.

## Expanded

When you commit inside `sites/<name>/`, the submodule itself moves to
a new SHA, but the master repo still points at the old SHA until you
`git add sites/<name>` and commit at the master level. The master
matrix `deploy.yml` workflow checks out the master pointers, not the
submodule tips, so the pointer bump *is* the production deploy event.

Convention: bump commits in master use the message
`chore(submodule): bump <name> to <short-sha>`.

## See also

- [master-repo](../i-n/master-repo.md)
