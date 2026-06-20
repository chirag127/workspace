---
type: service
title: "CodePen"
description: "CSS-heavy front-end demos embedded via script. Free unlimited public pens, no card."
tags: [code-playground, embed, css, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: code-playground-css
provider: codepen
free_tier: "Unlimited public pens, unlimited embeds, all front-end preprocessors (Sass, Less, Stylus, Babel, TypeScript-via-Babel)"
swap_cost: low
related:
  - services/code-embed/stackblitz
  - services/code-embed/github-gists
  - services/social/ray-so
  - rules/no-card-on-file
---

# CodePen

## Role

Hosts the **CSS-heavy** demos embedded in oriz-blog-site posts —
CSS animation walkthroughs, layout primitives, gradient experiments,
SVG art, anything where the front-end is the point and a Node
backend would be overkill. Embedded via CodePen's `<script>`
embed (turns a `<p data-pen-slug="...">` into a live preview).

## Free tier

- Unlimited public pens
- Unlimited public embeds
- All front-end preprocessors: Sass, Less, Stylus, PostCSS, Babel, TypeScript via Babel
- External CSS / JS asset URLs (jsDelivr, unpkg) for every pen
- Asset uploads gated on Pro — we don't use them; jsDelivr serves anything we'd upload

## Card / subscription required?

**NO.** Free-tier sign-up is email or GitHub OAuth. No payment method requested.

## Embed pattern

```html
<p
  class="codepen"
  data-height="400"
  data-default-tab="result"
  data-slug-hash="abcXYZ"
  data-user="chirag127"
  style="height:400px;border:1px solid #ddd;border-radius:8px"
></p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>
```

The script is one-time per page (CodePen dedupes), so multiple pens
on the same post share one `<script>` tag.

## Alternatives

- [StackBlitz](./stackblitz.md) — used for full-stack / Node-runtime demos
- [GitHub Gists](./github-gists.md) — used for static snippets
- JSFiddle — comparable but slower CDN, ad-blocker-prone embeds
- JSBin — abandoned, free tier degraded
- Plunker — comparable but used less in the wild → fewer copy-paste reference posts

## Swap cost

Low — pens are exportable via CodePen's "Export ZIP" (free).
Re-host as static HTML on Cloudflare Pages or migrate to a JSFiddle.
The blog post's `data-slug-hash` is the only site-side coupling.

## Why this is our pick

For pure-front-end demos, CodePen has the lowest friction (no GitHub
account required for visitors to fork) and the most stable embed
script. The community is also where most copy-pasteable CSS demos
already live, so linking out to a CodePen-hosted reference fits
how readers already think.

## Cross-refs

- [StackBlitz](./stackblitz.md) — sibling for full-stack demos
- [GitHub Gists](./github-gists.md) — sibling for static snippets
- [Ray.so](../social/ray-so.md) — generates the og:image for posts embedding pens
- [No card-on-file rule](../../rules/no-card-on-file.md)
