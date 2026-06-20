---
type: index
title: "Glossary — family-specific terms"
description: "Alphabetical index of family-specific terms used across the chirag127/oriz* repos. Grouped into 5 alphabetical subdirs."
tags: [glossary, index, meta]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Glossary

Family-specific vocabulary. Each term has its own short concept file.
Terms are grouped into 5 alphabetical subdirectories for navigation.

This directory now runs at **4-level hierarchy** — see [`../_okf.md`](../_okf.md#hierarchy-depth--3-levels-by-default-4-levels-for-big-dirs) and [`../decisions/process/4-level-hierarchy-for-big-dirs.md`](../decisions/process/4-level-hierarchy-for-big-dirs.md) for why.

## Subdirectories

| Range | Subdir |
|---|---|
| A–C | [a-c/](./a-c/index.md) |
| D–H | [d-h/](./d-h/index.md) |
| I–N | [i-n/](./i-n/index.md) |
| O–R | [o-r/](./o-r/index.md) |
| S–Z | [s-z/](./s-z/index.md) |

## All terms (flat view)

| Term | One-line definition |
|---|---|
| [app-check](./a-c/app-check.md) | Firebase's bot-defence layer that gates every Firestore call to verified clients. |
| [auth-domain](./a-c/auth-domain.md) | `auth.oriz.in`, the custom domain that lets one Firebase project serve every `*.oriz.in` site. |
| [cache-rebuild](./a-c/cache-rebuild.md) | The GitHub Actions job that reads JSONL canonical and re-populates the Turso warm cache. |
| [card-on-file](./a-c/card-on-file.md) | A payment instrument linked to a service account; the family avoids this for every paid-tier-capable provider. |
| [concept-file](./a-c/concept-file.md) | One OKF unit — a single markdown file with YAML frontmatter representing one fact, decision, or rule. |
| [data-repo](./d-h/data-repo.md) | `chirag127/oriz-me-data`, the authoritative JSONL store for the `me.oriz.in` lifestream. |
| [digital-twin](./d-h/digital-twin.md) | The broader concept lifestream implements: a public-facing mirror of one person's consumption + activity. |
| [extension-suffix](./d-h/extension-suffix.md) | The `-ext` suffix on Chrome extension repo names (`oriz-<name>-ext`). |
| [family](./d-h/family.md) | The `chirag127/oriz-*` family of sites + extensions + packages. |
| [family-anchor-site](./d-h/family-anchor-site.md) | `oriz-home`, the site whose v2 design defines patterns the other 10 reuse. |
| [firestore-spark](./d-h/firestore-spark.md) | Firebase's free tier; the family never upgrades to Blaze. |
| [hono-rpc](./d-h/hono-rpc.md) | The type-safe API client pattern: `hc<AppType>` from `@hono/client`. |
| [lifestream](./i-n/lifestream.md) | The public daily-rebuilt event store concept that powers `me.oriz.in`. |
| [master-repo](./i-n/master-repo.md) | `chirag127/oriz`, the umbrella repo that holds every submodule plus `knowledge/` and `design/`. |
| [okf-bundle](./o-r/okf-bundle.md) | A directory of concept files for one organization (this `knowledge/` directory is one). |
| [omnipost](./o-r/omnipost.md) | `@chirag127/oriz-omnipost`, the family's RSS-driven cross-post engine — fans each blog post out to every supported platform via the Adapter pattern. |
| [oriz](./o-r/oriz.md) | The family brand, the master GitHub repo name, and the apex domain `oriz.in`. |
| [oriz-kit](./o-r/oriz-kit.md) | `@chirag127/oriz-kit`, the package re-exporting Firebase init + auth UI + contact form + sidebar + family config. |
| [package-isolation](./o-r/package-isolation.md) | Wrapping every external service in a typed package so swapping providers is a version bump. |
| [parallel-by-default](./o-r/parallel-by-default.md) | The family rule: any work that can be parallelised MUST be fanned out via subagents. |
| [parallel-fan-out](./o-r/parallel-fan-out.md) | Spawning N subagents simultaneously for independent work. |
| [self-update-rule](./s-z/self-update-rule.md) | Every chat decision lands in `knowledge/` in the same conversation. |
| [site-suffix](./s-z/site-suffix.md) | The `-site` suffix on website repo names (`oriz-<name>-site`). |
| [submodule-pointer](./s-z/submodule-pointer.md) | The master oriz repo's recorded SHA for each submodule; the production state contract. |
| [survival-fallback](./s-z/survival-fallback.md) | The §16 layer that survives if every primary service dies. |
| [the-provenance-strip](./s-z/the-provenance-strip.md) | `oriz-me`'s signature element, the live build manifest at the top of every page. |
| [the-seal](./s-z/the-seal.md) | `oriz-journal`'s signature animation, the encryption metaphor. |
| [the-spine](./s-z/the-spine.md) | `oriz-blog`'s typographic series indicator (`●─●─○─○`). |
