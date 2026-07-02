---
type: decision
title: Publish knowledge/ to knowledge.oriz.in via Kiso + CF Pages
description: OKF bundle mirrored to public URL; Kiso as build engine; CF Pages host; llms.txt + sitemap.xml + RSS/Atom on top.
tags: [okf, publishing, cloudflare-pages, kiso, knowledge]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: high
durability: durable
related:
  - decisions/agent-tooling/kiso-as-okf-build-engine-2026-07-03
  - decisions/agent-tooling/cloud-publish-skills-2026-07-03
  - services/infra/hosting/cloudflare-pages
  - rules/infrastructure/one-level-subdomain-only
---

# Publish knowledge/ to knowledge.oriz.in

## Decision

Mirror `knowledge/` OKF bundle to `https://knowledge.oriz.in`. Cloudflare Pages host. Kiso build engine. GH Action deploy on push to `main`.

## Why

- **Discoverability** — 793 concept files invisible unless public.
- **Backup** — third copy (workspace + 6 mirror hosts + cloud site).
- **Ecosystem contribution** — one of first OKF-in-the-wild public bundles.
- **Agent reach** — external agents can fetch via URL, not just local read.

## Build engine — Astro custom (Kiso deferred)

Fresh verification 2026-07-03 found Kiso is HN-post-only (no installable software). Fallback: custom Astro on `api-fleet-template` pattern. See [`okf-build-engine-astro-2026-07-03`](./okf-build-engine-astro-2026-07-03.md).

Astro Integration ships: OKF Zod schema, `llms.txt` auto-gen, `@astrojs/sitemap`, `@astrojs/rss`, FlexSearch client-side, `related.json` precompute.

Reject: 11ty (no family precedent), Hugo/Zola (Go/Rust — heavier).

## Host — Cloudflare Pages

Per locked `cloudflare-pages-only`. 500 builds/mo free, unlimited bandwidth, no card. Aligns with `no-card-on-file`.

## Path — knowledge.oriz.in

Per `one-level-subdomain-only` + subdomain-name-content-type convention. Not `docs.oriz.in` (mixed content) or `brain.oriz.in` (breaks naming).

## Additions on top

- **llms.txt + sitemap.xml** at root (Kiso default).
- **RSS/Atom feed** on `/feed.xml` — no OKF convention exists yet; first-mover. Content = new/updated concept files last 30 days.
- **witscode validator** as CI gate — blocks bad frontmatter before deploy.
- **OKF conformance badge** on README.

## Sequence

1. Extend `repos/own/infra/api-fleet-template` with OKF-content-collection support (Zod schema for v0.2 frontmatter, related.json compute).
2. New repo `chirag127/knowledge-site` (or Astro app inside workspace) consumes `knowledge/` via symlink or submodule of umbrella.
3. Wire `.github/workflows/publish-knowledge.yml`: on push to `main`, build via Astro, deploy to CF Pages.
4. CF DNS: `knowledge.oriz.in` → CF Pages project.
5. witscode validator step BEFORE build step (adopt as workspace CI gate).
6. RSS/Atom generator baked into Astro build (`@astrojs/rss`).

## Anti-patterns

- ❌ Ship auth-walled — violates `no-auth-in-apps-or-apis`.
- ❌ Add analytics scripts that block content load — CF Web Analytics only.
- ❌ Custom domain via CF Registrar (card) — Spaceship registrar per `services/domain/spaceship`.

## Cross-refs

- [`kiso-as-okf-build-engine-2026-07-03`](./kiso-as-okf-build-engine-2026-07-03.md)
- [`cloud-publish-skills-2026-07-03`](./cloud-publish-skills-2026-07-03.md)
- [`okf-publishing-conventions-2026-07-03`](./okf-publishing-conventions-2026-07-03.md)
