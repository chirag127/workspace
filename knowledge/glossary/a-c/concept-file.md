---
type: glossary
title: "concept file"
description: "One OKF unit — a single markdown file with YAML frontmatter representing one fact, decision, or rule."
tags: [glossary, okf, format]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# concept file

## Definition

A concept file is the atomic unit of an OKF bundle: one kebab-case
markdown file, with YAML frontmatter and a plain-prose body,
representing exactly one concept (rule, decision, service, glossary
term, runbook, etc.).

## Expanded

The path IS the identity — `knowledge/rules/no-card-on-file.md` is a
stable reference. Required frontmatter on every concept file: `type`,
`title`, `description`, `tags`, `timestamp`. Optional fields:
`resource`, `supersedes`, `superseded_by`, `status`, `format_version`,
`related`. Body is plain markdown; cross-links are relative paths.

The whole `knowledge/` directory is composed of concept files. See
[`_okf.md`](../_okf.md) for the full contract.

## See also

- [okf-bundle](./okf-bundle.md)
