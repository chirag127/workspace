---
type: decision
title: OKF publishing conventions for oriz bundles
description: Filenames, feeds, structure for public OKF bundles at knowledge.oriz.in / skills.oriz.in; adopts Kiso defaults + adds RSS/Atom first-mover.
tags: [okf, publishing, conventions, rss]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: high
durability: durable
related:
  - decisions/agent-tooling/cloud-publish-knowledge-2026-07-03
  - decisions/agent-tooling/cloud-publish-skills-2026-07-03
  - decisions/agent-tooling/kiso-as-okf-build-engine-2026-07-03
---

# OKF publishing conventions

## Decision

Publish oriz OKF bundles with:

### Required (Kiso defaults + Google spec)

- `llms.txt` at root — machine-readable navigation for LLMs.
- `sitemap.xml` at root — SEO + agent crawl.
- `index.md` in every folder — progressive disclosure.
- `log.md` in every folder with chronological changes.
- `<slug>.md` per concept — OKF frontmatter compliant.

### Additions (oriz first-mover)

- `feed.xml` (RSS 2.0) at root — new/updated concept files last 30 days.
- `atom.xml` at root — same content, Atom variant.
- `/schema.json` at root — machine-readable OKF version + custom fields (`confidence`, `durability`).
- `/related.json` at root — precomputed graph edges for boone-style traversal without full re-index.

### Optional (per-bundle)

- `/opensearch.xml` for Firefox/Chrome address-bar search.
- `/manifest.json` if the bundle acts as PWA-installable knowledge base.

## Why RSS/Atom

Deep-research 2026-07-02 confirmed **no OKF RSS/Atom convention exists** in the ecosystem. First-mover:

- Agents can subscribe to knowledge updates.
- Humans use standard readers.
- Drives ecosystem convergence — if adopted, becomes de-facto standard.

## Why /schema.json + /related.json

- **schema.json** — declares OKF version consumers should expect. Enables version-aware clients.
- **related.json** — cheap graph queries without needing full boone install client-side.

## Publish path

- `knowledge.oriz.in/`
- `skills.oriz.in/`
- Both same convention. Both Kiso-generated + oriz-specific post-processors for RSS/Atom + schema/related.

## Anti-patterns

- ❌ Non-standard filenames (e.g. `updates.md` instead of `log.md`) — breaks Kiso + agent expectations.
- ❌ Ship without llms.txt — the whole point of OKF is LLM-friendly.
- ❌ Ship without validator gate — bad frontmatter propagates to public site.

## Cross-refs

- [`cloud-publish-knowledge-2026-07-03`](./cloud-publish-knowledge-2026-07-03.md)
- [`kiso-as-okf-build-engine-2026-07-03`](./kiso-as-okf-build-engine-2026-07-03.md)
- [`okf-v0.2-upstream-to-google-2026-07-03`](./okf-v0.2-upstream-to-google-2026-07-03.md)
