---
type: decision
title: Triple-fanout skills publishing — skills.oriz.in + registry + GH Pages
description: agent-skills submodule published to CF Pages branded site + skillshare/openskills registry + GH Pages default. Maximum reach.
tags: [skills, publishing, cloudflare-pages, registry]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: high
durability: durable
related:
  - decisions/agent-tooling/cloud-publish-knowledge-2026-07-03
  - decisions/agent-tooling/agent-skills-monorepo
  - decisions/architecture/general/agent-skills-monorepo
---

# Publish skills — triple fanout

## Decision

`repos/own/infra/agent-skills` published to **three** targets on every commit:

1. **`skills.oriz.in`** — CF Pages branded site. Auto-gen page per SKILL.md. Search + RSS.
2. **skillshare/openskills registry** — npm-style. External CLI install.
3. **GH Pages on repo** — `chirag127.github.io/agent-skills` default. Survival mirror.

## Why triple

Max reach per user pick. Each target hits different discovery path:
- Branded site → search engines, humans looking for tools.
- Registry → `skillshare install <name>` CLI users, other agents wiring skills.
- GH Pages → developer browsing repos on GitHub, GH search.

## Build

- **skills.oriz.in** — Kiso (same engine as knowledge site). Each `SKILL.md` = page.
- **Registry** — `skillshare publish` or `openskills publish` from CI.
- **GH Pages** — GH Action from `agent-skills` repo itself, minimal build.

## RSS + search

- RSS at `/feed.xml` — new/updated skills. Same first-mover as knowledge site.
- Search — client-side FlexSearch or Kiso built-in. No server needed.

## Sequence

1. Wire `.github/workflows/publish-skills.yml` in `agent-skills` repo.
2. Three jobs: Kiso→CF Pages, `skillshare publish`, GH Pages deploy.
3. CF DNS: `skills.oriz.in` → CF Pages project.
4. Registry auth token in `oriz-org/workspace` secrets (per `github-org-level-secrets` — org-level via chirag127 personal secrets now).

## Anti-patterns

- ❌ Publish only to registry — humans lose branded discovery path.
- ❌ Skip GH Pages — loses survival mirror.
- ❌ Card-required registry — must be free per `no-card-on-file`.

## Cross-refs

- [`cloud-publish-knowledge-2026-07-03`](./cloud-publish-knowledge-2026-07-03.md)
- [`agent-skills-monorepo`](./agent-skills-monorepo.md)
