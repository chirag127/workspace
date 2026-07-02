---
type: index
title: "OKF (Open Knowledge Format) — spec v0.2"
description: "Canonical frontmatter + file-shape spec for every concept file under knowledge/."
tags: [okf, spec, knowledge, format]
timestamp: 2026-07-02
format_version: okf-v0.2
status: active
---

# OKF — Open Knowledge Format (v0.2)

Every file under `knowledge/` is a **concept file**. Concept files carry OKF frontmatter + a caveman-style body. Agents read them; humans read them; the family evolves them.

Parent spec: [Google Cloud OKF announcement](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing) — GCP's Open Knowledge Format proposal for portable, self-describing knowledge artifacts. This workspace uses OKF as the shape; the family layer adds retrieval-focused required fields (`title`, `description`, `tags`) and confidence/durability metadata (v0.2).

Prior-art shapes that motivated the v0.2 additions:
- [tekmemo](https://github.com/tekmemo/tekmemo) — per-entry confidence scoring for LLM memory stores.
- [jayzeng/agentmemory](https://github.com/jayzeng/agentmemory) — durability/volatility split (durable facts vs time-sensitive readings) for agent memory.

---

## Allowed `type` values

- `decision` — a locked choice between distinct options + reason
- `rule` — a taste, constraint, or hard limit that governs future behavior
- `runbook` — step-by-step procedure
- `service` — third-party service description (free tier, URL, auth, swap cost)
- `glossary` — vocabulary entry
- `index` — an index/catalog file

---

## Required frontmatter on every concept file

```yaml
---
type: <one of the allowed types — see above>
title: <human-readable title>
description: <one-line summary, used by agents during retrieval>
tags: [<topic tag>, <topic tag>, ...]
timestamp: <ISO-8601, last meaningful update>
format_version: okf-v0.2
status: active | deprecated | superseded | draft
---
```

Per OKF v0.2 (unchanged from v0.1), only `type` is strictly required by the parent spec. The family adds `title`, `description`, and `tags` as also-required because they make agent retrieval significantly better. `timestamp`, `format_version`, and `status` appear in every template and are treated as required in practice, though not strictly enforced.

---

## Optional frontmatter fields

```yaml
resource: <canonical URL the concept points at, when applicable>
supersedes: <slug or path of an older concept this replaces>
superseded_by: <slug or path of a newer concept that replaces this>
related: [<slug>, <slug>]
confidence: high | medium | low       # NEW in v0.2 — default: high
durability: durable | volatile        # NEW in v0.2 — default: durable
```

### `confidence` (new in v0.2)

How strongly the writer holds this claim.

| Value | Meaning |
|---|---|
| `high` | Direct evidence, first-hand verification, or an unambiguous source. Default when omitted. |
| `medium` | Reasoned from partial evidence; likely-but-not-verified; single-source claim. |
| `low` | Speculative, second-hand, or extrapolated. Reader should re-verify before acting. |

Default: `high`. Omit the field when confidence is high; set it explicitly for `medium`/`low`.

### `durability` (new in v0.2)

Whether the fact is expected to remain true across product/tool changes.

| Value | Meaning |
|---|---|
| `durable` | Architectural choice, taste rule, or fact that persists across vendor changes. Default when omitted. |
| `volatile` | Time-sensitive fact — free-tier quotas, prices, service status, version numbers, availability. Expected to drift; re-verify on read. |

Default: `durable`. Set `volatile` explicitly for pricing, quota numbers, service-status fields, or anything a vendor could change without notice.

### Combined example

```yaml
---
type: service
title: "Cloudflare Pages"
description: "Primary static-site host — 500 builds/mo free, unlimited bandwidth."
tags: [hosting, static, cloudflare]
timestamp: 2026-07-02
format_version: okf-v0.2
status: active
confidence: high
durability: volatile
---
```

Quota numbers are `volatile` (Cloudflare can change them); the choice to use CF Pages is a separate `decision` file that's `durable`.

---

## Migration from v0.1

**No bulk migration needed.** v0.2 is additive-only.

- (a) Existing files remain valid at `format_version: okf-v0.1`. They are not stale; they do not need rewriting.
- (b) New files should use `format_version: okf-v0.2` and MAY set `confidence`/`durability` when useful.
- (c) When editing a v0.1 file for reasons unrelated to v0.2 (fixing a fact, adding a `related` link), bump to `okf-v0.2` opportunistically — but don't touch files solely to bump the version.

Retrieval tools and the `okf-prompt-lookup.py` scorer treat both versions identically; the new fields are consumed when present and ignored when absent.

---

## Update protocol

1. Durable info arrives in chat.
2. Pick the concept type (`decision`, `rule`, `runbook`, `service`, `glossary`).
3. Write `knowledge/<area>/<slug>.md` with the frontmatter above + caveman-style body.
4. If replacing an older concept, delete the older file (per `knowledge-deletion-not-supersession`) — do not use `status: superseded` as a soft-delete.
5. Commit `docs(knowledge): <one-liner>` in the same turn.

---

## Cross-refs

- [`rules/agent/self-update-rule.md`](./rules/agent/self-update-rule.md) — when to write a concept file
- [`rules/agent/knowledge-everything-caveman.md`](./rules/agent/knowledge-everything-caveman.md) — style mandate for the body
- [`rules/agent/knowledge-deletion-not-supersession.md`](./rules/agent/knowledge-deletion-not-supersession.md) — no soft-delete via status flags
- [`rules/agent/okf-lookup-before-acting.md`](./rules/agent/okf-lookup-before-acting.md) — retrieval mechanism that consumes this frontmatter
- Parent spec: [Google Cloud OKF](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing)
- Prior art for v0.2 extensions: [tekmemo](https://github.com/tekmemo/tekmemo) (confidence), [jayzeng/agentmemory](https://github.com/jayzeng/agentmemory) (durability)