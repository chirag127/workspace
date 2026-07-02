---
type: decision
title: Boone as OKF search engine — replaces stdlib prompt-lookup
description: Community boone CLI (BM25 + graph) adopted for OKF search; swap into UserPromptSubmit hook; stdlib script kept as fallback.
tags: [okf, boone, search, bm25, hook]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: medium
durability: durable
related:
  - rules/agent/okf-lookup-before-acting
  - decisions/agent-tooling/kiso-as-okf-build-engine-2026-07-03
  - decisions/architecture/agent-tooling/okf-auto-lookup-hook-2026-06-29
---

# Boone — OKF search adopted

## Decision

Adopt [boone CLI](https://diurnalproductions.com/blog/introducing-boone-cli-your-terminal-knowledge-assistant) (announced 2026-06-21) as OKF search engine. Ships BM25 + graph traversal + terminal UI.

Swap into existing Claude Code UserPromptSubmit hook — replaces `scripts/okf-prompt-lookup.py`.

Keep the python stdlib script as **fallback**: if boone binary missing/broken, hook falls back to stdlib.

## Why boone

- **Better retrieval** — BM25 + graph vs our token-overlap Python stdlib. Higher precision + related-concept surfacing.
- **Community-first** per `no-rebuilding-free-software`.
- **Terminal-native** — matches CC hook context.
- **Cross-agent portable** — OpenCode / others could invoke same CLI manually per `okf-lookup-before-acting`.

## Confidence: medium

- boone is **≤2 weeks old**. Same caveats as Kiso.
- Fallback ensures zero-downtime — script never removed.

## Hook wiring

Modify `scripts/okf-prompt-hook.sh` (or `.ps1`):

```bash
if command -v boone >/dev/null 2>&1; then
  boone search --limit 3 --format markdown "$USER_PROMPT"
else
  python C:/d/oriz/scripts/okf-prompt-lookup.py "$USER_PROMPT" --limit 3
fi
```

Idempotent, graceful degradation.

## Contribute back

Per grill lock — contribute `search` module upstream to boone that reads OKF conventions (type/tags naming). Own maintenance surface + gives community.

## Anti-patterns

- ❌ Remove stdlib script — losing fallback breaks bootstrap on machines without boone.
- ❌ Depend on paid features — boone must stay free per `no-card-on-file`.
- ❌ Ship indexes to repo — boone rebuilds locally; keep repo clean.

## Cross-refs

- [`okf-lookup-before-acting`](../../rules/agent/okf-lookup-before-acting.md)
- [`kiso-as-okf-build-engine-2026-07-03`](./kiso-as-okf-build-engine-2026-07-03.md)
- [`okf-auto-lookup-hook-2026-06-29`](../architecture/agent-tooling/okf-auto-lookup-hook-2026-06-29.md)
