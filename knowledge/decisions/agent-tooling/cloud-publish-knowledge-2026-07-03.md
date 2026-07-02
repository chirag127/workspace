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

## Build engine — Kiso

Kiso announced 2026-06-27 ([HN via headlinesbriefing](https://headlinesbriefing.com/dev/hacker-news/kiso-open-source-engine-transforms-knowledge-bundles-into-static-sites-a6f251ae)). Zero-config OKF → static site. Ships `llms.txt` + `sitemap.xml` per emerging convention.

Community-first per `no-rebuilding-free-software`. Custom Astro build rejected — Kiso does exactly this job.

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

1. Add Kiso as submodule OR install as pnpm dep (evaluate at build time).
2. Wire `.github/workflows/publish-knowledge.yml`: on push to `main`, build via Kiso, deploy to CF Pages.
3. CF DNS: `knowledge.oriz.in` → CF Pages project.
4. witscode validator step BEFORE build step.
5. RSS/Atom generator step AFTER build (custom, small — Kiso doesn't ship this).

## Anti-patterns

- ❌ Ship auth-walled — violates `no-auth-in-apps-or-apis`.
- ❌ Add analytics scripts that block content load — CF Web Analytics only.
- ❌ Custom domain via CF Registrar (card) — Spaceship registrar per `services/domain/spaceship`.

## Cross-refs

- [`kiso-as-okf-build-engine-2026-07-03`](./kiso-as-okf-build-engine-2026-07-03.md)
- [`cloud-publish-skills-2026-07-03`](./cloud-publish-skills-2026-07-03.md)
- [`okf-publishing-conventions-2026-07-03`](./okf-publishing-conventions-2026-07-03.md)
