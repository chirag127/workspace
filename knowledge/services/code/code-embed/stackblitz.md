---
type: service
title: "StackBlitz"
description: "Full-stack browser sandboxes embedded as iframes — free unlimited public projects"
tags: [code-playground, embed, fullstack, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: code-playground-fullstack
provider: stackblitz
free_tier: "Unlimited public projects, WebContainers (Node-in-browser), all major frameworks (Vue, React, Svelte, Astro, Next.js, Nuxt)"
swap_cost: low
related:
  - services/code/code-embed/codepen
  - services/code/code-embed/github-gists
  - services/business/social/ray-so
  - rules/no-card-on-file
---

# StackBlitz

## Role

Hosts the **full-stack** runnable demos embedded in
[oriz-blog-site](../../glossary/i-n/master-repo.md) posts and any
tutorial pages that need a real Node runtime in the browser. Vue,
React, Svelte, Astro, Next.js, Nuxt — anything that needs `npm
install` working in-page lands here. Embedded via `<iframe>` with
StackBlitz's URL params (`?embed=1&file=...&view=preview`).

## Free tier

- Unlimited public projects
- Unlimited public embeds
- WebContainers — Node.js + npm running entirely in the browser tab
- All major framework templates
- GitHub import (open any public repo as a sandbox)
- Custom domain on shared sandboxes (`stackblitz.com/edit/<slug>`)

## Card / subscription required?

**NO.** Free-tier sign-up is GitHub OAuth. No payment method requested.

## Embed pattern

```html
<iframe
  src="https://stackblitz.com/edit/oriz-demo-vue-router?embed=1&file=src/App.vue&view=preview"
  style="width:100%;height:500px;border:0;border-radius:8px"
  allow="cross-origin-isolated"
  loading="lazy"
></iframe>
```

Lazy-loaded by default — won't bloat first contentful paint on
listing pages, only fires when scrolled into view.

## Alternatives

- [CodePen](./codepen.md) — used for CSS-only / front-end-only demos where WebContainers are overkill
- [GitHub Gists](./github-gists.md) — used for static snippets (no playground)
- CodeSandbox — comparable feature set, but free tier now caps private projects and the free public embed limit changes more often than StackBlitz's
- Replit — pivoted to a paid-first model; free tier no longer reliable for embeds
- Glitch — sleeps after 5 min on free tier, breaks embedded demos

## Swap cost

Low — the embedded `<iframe src>` URL is the only site-side coupling.
Sandboxes are versioned in their own StackBlitz accounts; if we ever
move, the source files come down via `stackblitz.com/edit/<slug>` →
"Download Project" and re-upload to CodeSandbox / a self-hosted
WebContainer page.

## Why this is our pick

WebContainers is the only browser-native Node runtime that works
without server round-trips, which matters for blog posts where we
don't want to pay for a backend. Free public projects are unlimited
forever, GitHub OAuth is the only sign-up step, and the iframe embed
is the most stable across ad-blockers we've tested.

## Cross-refs

- [CodePen](./codepen.md) — sibling for CSS-heavy demos
- [GitHub Gists](./github-gists.md) — sibling for static snippets
- [Ray.so](../social/ray-so.md) — generates the og:image card for blog posts that embed StackBlitz
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
