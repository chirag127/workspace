---
type: index
title: "Code embed services"
description: "Code playgrounds and snippet hosts embedded in oriz-blog-site posts. Three-tier picks: full-stack, CSS-heavy, static."
tags: [services, code-embed, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Code embed services

Three roles, three providers — we don't pick one because the right
choice depends on what the snippet is. All three are free with no
card required.

| Service | Status | One-line role |
|---|---|---|
| [stackblitz.md](./stackblitz.md) | active | Full-stack playgrounds (Vue/React/Svelte/Astro + Node-in-browser) |
| [codepen.md](./codepen.md) | active | CSS-heavy / front-end-only demos |
| [github-gists.md](./github-gists.md) | active | Static snippets, copy-paste fragments |

## When to use which

- **Reader needs to run + edit** → StackBlitz (WebContainers Node runtime)
- **Reader needs to see a CSS / SVG / animation effect** → CodePen
- **Reader needs to copy-paste a config or one-file utility** → GitHub Gist

## Cross-refs

- [services/business/social/ray-so](../social/ray-so.md) — generates the og:image card for blog posts that embed any of these
- [decisions/architecture/multi-engine-search-button](../../decisions/architecture/multi-engine-search-button.md) — screenshots from these embeds travel through the multi-search popover as og:image when shared
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
