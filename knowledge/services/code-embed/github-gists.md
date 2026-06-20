---
type: service
title: "GitHub Gists"
description: "Static code snippets embedded via script. Free unlimited public gists, no card."
tags: [code-snippet, embed, static, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: code-snippet-static
provider: github
free_tier: "Unlimited public + secret gists, unlimited embeds, syntax highlighting for every language GitHub supports"
swap_cost: low
related:
  - services/code-embed/stackblitz
  - services/code-embed/codepen
  - services/social/ray-so
  - rules/no-card-on-file
---

# GitHub Gists

## Role

Hosts **static** code snippets embedded in oriz-blog-site posts —
copy-paste fragments, config blocks, one-file utilities, anything
where a runnable playground is overkill and we just want syntax-
highlighted code with a "view raw" link. Embedded via gist's
`<script src="...js">` one-liner (turns into a styled `<div>` with
GitHub's syntax theme).

## Free tier

- Unlimited public gists
- Unlimited secret (unlisted) gists
- Unlimited embeds
- Syntax highlighting for every language GitHub supports (~600)
- Git-backed — every gist is a real repo, clonable + diffable
- Comments + revisions per gist

## Card / subscription required?

**NO.** Comes with the free GitHub account we already have for
[oriz-master-repo](../../glossary/i-n/master-repo.md). No separate
sign-up, no payment method.

## Embed pattern

```html
<script src="https://gist.github.com/chirag127/abc123def456.js"></script>
```

To embed a single file from a multi-file gist:

```html
<script src="https://gist.github.com/chirag127/abc123def456.js?file=oriz-config.ts"></script>
```

Gist embeds inject their own stylesheet (gist.github.com origin) — we
let them through CSP via `style-src https://github.githubassets.com`.

## Alternatives

- [StackBlitz](./stackblitz.md) — overkill for static snippets, used for full-stack demos
- [CodePen](./codepen.md) — overkill for one-language fragments, used for CSS-heavy demos
- Carbon (carbon.now.sh) — pretty PNG, but not embeddable as live text → fails accessibility (screen readers can't read PNG code)
- Pastebin — ads, no syntax theme parity with GitHub, secret gists already cover the unlisted use case

## Swap cost

Zero — the gist source IS a git repo, `git clone https://gist.github.com/<id>.git` and re-host anywhere. The post-side coupling is one `<script>` tag.

## Why this is our pick

Already part of our GitHub account, costs nothing extra, embeds
are accessible (real text, not images), and revision history means
if we update the snippet the embed updates everywhere it's referenced.
For "screenshot-style" code blocks in social cards we use
[Ray.so](../social/ray-so.md) instead — Gists are for in-post embeds
where the reader needs to copy-paste.

## Cross-refs

- [StackBlitz](./stackblitz.md) — sibling for full-stack playgrounds
- [CodePen](./codepen.md) — sibling for CSS-heavy demos
- [Ray.so](../social/ray-so.md) — generates pretty PNG screenshots for social og:image (different role)
- [No card-on-file rule](../../rules/no-card-on-file.md)
