---
type: rule
title: "OKF graph discipline (inspired by okf-mcp)"
description: Validate cross-links, prefer index-scan over directory-scan, propose-first authoring, structured graph queries
tags: [agent-behavior, knowledge, okf, graph, discipline]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - rules/agent/keep-knowledge-fresh
  - rules/agent/self-update-rule
  - rules/agent/knowledge-deletion-not-supersession
  - rules/agent/agent-minimum-context
---

# OKF graph discipline

Operate over `knowledge/` like okf-mcp would, without the MCP runtime.

## The 5 contracts

### 1. Index-first navigation
NEVER grep/find/scan the full `knowledge/` tree. ALWAYS query `knowledge/index.md` first (1285 lines, 792 files indexed) OR `scripts/okf-index-lookup.py <term>` to find the precise concept file. Read targeted; don't bulk-load.

### 2. Validate cross-links on write
Every relative `[text](path.md)` and `[[wiki-link]]` you add to a knowledge file must resolve to an EXISTING file. Run:
```bash
py scripts/okf-index-lookup.py --validate-links <path>
```
before commit. Broken-link tolerance: 0.

### 3. Propose-first authoring (mental model, not tooling)
When the user gives a decision in chat, draft the OKF concept file as a "proposal" — show me the path + frontmatter + 3-line body BEFORE writing. If the user wants edits, edit before write. This is the manual equivalent of `okf_propose_concept` ? `okf_accept_proposal`. For grill-locked decisions where the user already approved, skip the proposal step (auto-accept).

### 4. Graph-aware writes
Every new concept file MUST have:
- `type` (required)
- `description` (one sentence — extracted into `index.md` next regen)
- `related` array pointing at =1 existing concept (creates graph edges)
- `tags` (3-5 keywords for search)

### 5. Reserved files
- `index.md` — not a concept, regenerated
- `_okf.md`, `_navigation.md` — spec/nav files, not concepts
- `glossary/` entries are concepts but have type `glossary`

## Why we don't install okf-mcp itself

Per Q8 (2026-06-26 grill): the rule captures the discipline. Installing okf-mcp adds an MCP server dep + a JSON-RPC stdio process + a graph builder we'd never query at runtime — most of our agent reads happen through the Read tool directly. The okf-mcp PROTOCOL of "validate, propose-first, graph-link" is the value; the runtime is overhead at our size.

If knowledge/ grows past ~5000 files OR multiple agents need parallel structured queries, revisit the install decision.

## Cross-refs
- okf-mcp repo: https://github.com/mfdaves/okf-mcp (inspiration)
- Our index: `knowledge/index.md`
- Our lookup script: `scripts/okf-index-lookup.py`
- OKF spec: `knowledge/_okf.md`
