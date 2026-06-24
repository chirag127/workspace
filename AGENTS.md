# AGENTS.md

> **Read [`README.md`](./README.md) first.** It is the canonical entry point — repo layout, tech stack, hard-rule shortlist, env management, domain map, license, and the standing authorization that govern every action you take here.

After `README.md`, the next files to load in order are:

1. [`knowledge/index.md`](./knowledge/index.md) — the canonical brain (58 rules + 181 decisions + 43 runbooks)
2. [`knowledge/_navigation.md`](./knowledge/_navigation.md) — "where to look" map
3. [`knowledge/_okf.md`](./knowledge/_okf.md) — the file-format spec for `knowledge/`

When a rule and any other file conflict, the file in [`knowledge/rules/`](./knowledge/rules/) wins. When a decision is locked in chat, follow [`knowledge/rules/self-update-rule.md`](./knowledge/rules/agent/self-update-rule.md) immediately.

---

## Disaster Recovery & Mirror Strategy
- **6-Host Mirroring Strategy**: See [`decisions/architecture/mirror-to-6-git-hosts.md`](./knowledge/decisions/architecture/ops/mirror-to-6-git-hosts.md) for the architecture and [`runbooks/mirror-all-hosts-setup.md`](./knowledge/runbooks/hosting/mirror-all-hosts-setup.md) for the setup runbook.

---

## The Open Knowledge Format (OKF v0.1)

This repository structures its durable developer context using the **Open Knowledge Format (OKF)**, an open, vendor-neutral specification published by Google Cloud to standardize agent context and solve the "context problem" — where schemas, metric definitions, runbooks, and rules are scattered across wikis, docs, and repos, invisible to agents.

> Official spec: [GoogleCloudPlatform/knowledge-catalog — okf/SPEC.md](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)

### 1. How It Works

OKF is intentionally minimal: **a directory of Markdown files with YAML frontmatter**. No SDK, no schema registry, no proprietary runtime. If you can `cat` a file you can read OKF; if you can `git clone` a repo you can ship it.

Key properties from the official spec:
- **Readable** by humans without tooling
- **Parseable** by agents without bespoke SDKs
- **Diffable** in version control
- **Portable** across tools, organizations, and time

A **Knowledge Bundle** is a self-contained, hierarchical collection of Markdown documents. Each `.md` file is a **Concept** — one unit of knowledge. A concept's **Concept ID** is its file path with `.md` stripped (e.g., `rules/never-hit-quotas`).

Standard Markdown links between concepts form an implicit **knowledge graph** that agents can traverse without special tooling.

### 2. How Specs Are Made (Frontmatter)

Every concept file starts with a YAML frontmatter block delimited by `---`:

```yaml
---
type: <Type name>                  # REQUIRED — routes, filters, and classifies the concept
title: <Human-readable display name>
description: <One-line summary — used by index.md generators, search, and agent retrieval>
resource: <Canonical URI for the underlying asset, when applicable>
tags: [<tag>, <tag>, …]
timestamp: <ISO 8601 last-modified datetime>
# …other producer-defined key/value pairs allowed
---
```

**Required:** only `type`. Consumers must tolerate unknown types gracefully.

**Recommended (in priority order):** `title` → `description` → `resource` → `tags` → `timestamp`.

**Family extension** (this repo adds these as also-required because they improve agent retrieval significantly):

```yaml
---
type: rule                         # one of the allowed family types below
title: "Human-readable title"
description: "One-line summary for index snippets and agent retrieval"
tags: [rule, topic, subtopic]
timestamp: 2026-06-23              # ISO-8601, date of last meaningful change
format_version: okf-v0.1          # bump when adopting a new OKF version
status: active                     # active | deprecated | superseded | draft
related:                           # cross-refs for graph navigation
  - rules/some-related-rule
  - decisions/some-decision
---
```

**Family-allowed `type` values** (keep this list short and stable):

| Type | What it is |
|---|---|
| `convention` | Meta-rules about how the bundle itself works |
| `rule` | A non-negotiable constraint the family follows |
| `decision` | A specific architectural / naming / stack decision locked in chat |
| `service` | Description of one external service: role, free tier, alternative, swap cost |
| `runbook` | A sequence of human-actionable commands |
| `design-brief` | One site's v2 design specification |
| `architecture` | A description of one piece of the stack |
| `policy` | Rules about content / privacy / monetisation / age-gating |
| `schema` | Data model / type definition that lives outside code |
| `process` | Multi-step internal process |
| `glossary` | Definition of a term used across the family |
| `index` | Per-OKF spec: an `index.md` overview file at any directory level |
| `log` | Per-OKF spec: chronological history of changes |

### 3. How It Should Be Done (Organization)

**File naming:** every concept file is `kebab-case.md`. The path **is** the stable identity — `knowledge/rules/never-hit-quotas.md` is a permanent, citable reference.

**Hierarchy depth** scales with folder size (max ceiling: 5 levels):

| L1 file count | Depth | Path shape |
|---|---|---|
| ≤15 | 2 | `knowledge/<L1>/<file>.md` |
| 16–50 | 3 | `knowledge/<L1>/<L2>/<file>.md` |
| 51–150 | 4 | `knowledge/<L1>/<L2>/<L3>/<file>.md` |
| 151+ | 5 | `knowledge/<L1>/<L2>/<L3>/<L4>/<file>.md` |

### 3.1. Knowledge Base Directory Hierarchy

To ensure any AI agent can navigate the repository correctly, the canonical `knowledge/` directory is structured as follows:
- `rules/`: Non-negotiable constraints, split into: `agent/` (regulation), `design/` (UI/styling), `development/` (git/deps), `infrastructure/` (hosting/limits), `interaction/` (preferences), `security/` (secrets).
- `decisions/`: Historic architectural/naming decisions. `decisions/architecture/` contains subcategories: `apps/`, `compute/`, `content/`, `database/`, `frontend/`, `ops/`, `packages/`, `security/`, `stack/`, and `general/`.
- `architecture/`: Current design layouts, categorized into: `compute/`, `database/`, `frontend/`, `ops/`, `packages/`, `security/`, and `stack/`.
- `services/`: Third-party tools (CDN, DB, email, analytics) split by functionality (hosting/, payment/, storage/, testing/, etc.).
- `runbooks/`: Operational instructions, split into: `hosting/`, `operations/`, `security/`.
- `policy/`: Age-gating, payment, and content rules.
- `design/`: UI site briefs.
- `glossary/`: Term definitions.

**Reserved filenames** (per OKF spec — must NOT be used for concept documents):

| Filename | Purpose |
|---|---|
| `index.md` | Directory listing for progressive disclosure. Agents read this first at each level. |
| `log.md` | Chronological update history for that bundle. Every new concept appends one line. |

**`_okf.md`** — underscore prefix marks it as meta/convention, not a concept document.

**Cross-linking:** use plain relative Markdown links. This builds the implicit knowledge graph:

```markdown
This service follows the [no-card-on-file rule](./knowledge/knowledge/rules/interaction/no-card-on-file.md).
```

### 4. How It Is Transformed (Agent Context Loading)

Per OKF's **producer/consumer independence** principle — any agent can read any OKF bundle without needing the producer's tooling:

**Enrichment agents (producers):** write/update concept files, keeping the wiki in lockstep with decisions. This includes you (the AI agent) when a decision is made in chat.

**Consumption agents (consumers):**
1. Start at `knowledge/index.md` — read the bundle overview and directory table
2. Follow links to relevant subdirectory `index.md` files for progressive disclosure
3. Open specific concept files for detailed content
4. Use `related` frontmatter and inline links to traverse the knowledge graph
5. Use `tags` for cross-cutting filtering across concept types

**Never** read files ad-hoc by scanning directories blindly. Always start at `knowledge/index.md`, then navigate via the graph.

### 5. How to Use OKF When Editing Code

Before modifying **any** code in this repo:

1. **Check `knowledge/rules/`** — is there a rule that constrains this change? If yes, that rule wins.
2. **Check `knowledge/decisions/`** — has this architectural choice already been locked? If yes, follow the locked decision.
3. **Check `knowledge/services/`** — are you adding a third-party service? Check the free-tier evaluation file first.
4. **After making a locked decision** — immediately write or update the concept file in `knowledge/`, append to `knowledge/log.md`, commit with `docs(knowledge): <summary>`.

Code without a matching knowledge file is a smell. The test: *"would a future agent need this to make a similar decision?"* If yes → write the concept file.

---

## Agent Self-Regulation Guidelines (Sideline)

To maintain context hygiene and prevent repository rot, every AI agent MUST adhere to these self-regulation guidelines:

1. **No Duplication — ever.** Every piece of durable information must exist in exactly **one** location. Before writing anything new, search `knowledge/` for an existing concept. If it exists, update it. Do not create a second file with overlapping content.

2. **Knowledge-First.** All durable decisions, architectural details, rules, and service choices belong in `knowledge/`, not in `README.md`, `AGENTS.md`, or individual code comments. `AGENTS.md` and `CLAUDE.md` are thin pointers only.

3. **Self-Update Immediately.** When a decision is reached in chat, update the relevant concept file in the **same conversation session**. The agent with the decision context is the best agent to capture it. Deferring loses the rationale.

4. **Append `knowledge/log.md` on every write.** Every new or updated concept file gets a one-line entry: `<date> — <path> — <one-line summary>`.

5. **No Code-Drafting Drift.** Always read relevant rule files in `knowledge/rules/` before writing code. Never assume or guess patterns — look them up in the knowledge graph.

6. **Supersede, don't delete.** When a concept is replaced, set `status: superseded` and `superseded_by: <path>` on the old file; set `supersedes: <path>` on the new one. Git history is the durable backup; stale files marked `superseded` can be deleted after 30 days.

7. **AGENTS.md stays ≤200 lines.** If it grows beyond that, extract the content to `knowledge/`. Every line here is loaded into every agent's context on every invocation across 60+ repos — treat it as expensive.

8. **Every repo README carries a `[⭐ Star this Repo ⭐]` badge near the top.** See [`rules/development/readme-star-badge-required.md`](./knowledge/rules/development/readme-star-badge-required.md).
