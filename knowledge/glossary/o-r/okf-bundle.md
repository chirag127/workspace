---
type: glossary
title: "OKF bundle"
description: "A directory of concept files for one organization; this knowledge/ directory is one such bundle."
tags: [glossary, okf, format]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# OKF bundle

## Definition

An OKF bundle is a directory tree of [concept files](./concept-file.md)
that together describe one organization's durable knowledge — rules,
decisions, services, runbooks, designs, schemas, glossary.

## Expanded

This `knowledge/` directory is the family's bundle. Per the OKF v0.1
spec, a bundle has at most a 3-level hierarchy under the root, uses
reserved filenames (`index.md`, `log.md`) at any directory level, and
contains only concept files plus those reserved index/log files.

Per-site `knowledge/` directories inside each submodule are smaller
bundles in their own right; they cross-link to the master bundle via
relative paths.

## See also

- [concept-file](./concept-file.md)
