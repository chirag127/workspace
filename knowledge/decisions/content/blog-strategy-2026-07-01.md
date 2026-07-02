---
type: decision
title: "Blog strategy 2026-07-01 — one source, multi-target cross-posting"
description: "Canonical blog format (Markdown+frontmatter) + list of platforms + API-driven cross-posting workflow"
tags: [blog, content, cross-post, mdx, markdown]
timestamp: 2026-07-01
format_version: okf-v0.1
status: active
related:
  - decisions/content/blog-cross-post-strategy
  - decisions/content/cross-post-engine
  - decisions/packages/omni-publish-package
---

# Blog strategy 2026-07-01

## Decision

Single source = **CommonMark + YAML frontmatter** (`.md`) in `pages-blog-app`. MDX reserved for the Astro build only — never the transport format. Cross-post via API to 4 write-capable platforms; canonical URL always `blog.oriz.in`.

## Source format

```md
---
title: "…"
description: "…"
date: 2026-07-01
tags: [tag1, tag2]
canonical_url: https://blog.oriz.in/posts/<slug>
cover_image: https://…
category: tech        # tech | personal | reviews
---

# Body in CommonMark GFM.
```

MDX (`.mdx`) allowed *only* in the Astro repo; the cross-post engine strips JSX before dispatch. MDsvex, MDXPortable rejected — not accepted by any target API.

## Cross-post targets

| Platform | API | Auth | Free tier | Format accepted |
|---|---|---|---|---|
| Dev.to | `POST /api/articles` [1] | api-key header | Unlimited | `body_markdown` + `canonical_url` |
| Hashnode | GraphQL `publishPost` [2] | PAT | Unlimited | `contentMarkdown` + `originalArticleURL` |
| Ghost (self-host) | `POST /admin/posts/?source=html` [3] | JWT | Self-host | HTML (Lexical internal) |
| WordPress | `POST /wp/v2/posts` [4] | App password | Self-host / .com free | HTML (MD → HTML on push) |
| Bluesky | AT Proto | app-password | Free | Plain text + link |
| Mastodon | REST `POST /api/v1/statuses` | Bearer | Free | Plain text |
| Medium | ❌ Closed to new integrations Jan 2025 [5] | — | — | — |
| Substack | ❌ No public API [6] | — | — | (unofficial libs only) |
| LinkedIn | `POST /rest/posts` [7] | OAuth2 | Rate-limited | Text + link (no article API for partners) |

Medium + Substack: skip. LinkedIn: draft-only queue to `chirag127/oriz-drafts` GH Issues per [blog-cross-post-strategy](./blog-cross-post-strategy.md).

## Category count

**Three flat categories** on one domain: `tech` / `personal` / `reviews`. Not per-app blogs. Not single-bucket. Reason: 2026 SEO consensus = topic-cluster on one domain beats micro-domains for authority [8][9]; three clusters = enough separation for feed filtering without diluting the pillar page.

## Should there be a blog website?

**Yes — `blog.oriz.in` stays canonical + public.** Cross-posts point back via `canonical_url`. `knowledge/` remains private/GitHub-only (agent memory, not blog). All three (site + cross-post + knowledge) coexist — different audiences.

## Publishing workflow

1. Author `.md` in `pages-blog-app/src/content/blog/YYYY-MM-DD-slug.md`.
2. `git push` → Astro builds → `blog.oriz.in/posts/<slug>` live + RSS updated.
3. GH Actions on tag `v*` calls `@chirag127/omni-publish`.
4. Engine reads RSS `<guid>`, diffs against `state.json`, POSTs to Dev.to + Hashnode + Bluesky + Mastodon (+ Ghost/WP if configured) with `canonical_url = blog.oriz.in/...`.
5. LinkedIn/X/Reddit → draft issues in `chirag127/oriz-drafts` for manual review.
6. `state.json` commit-back records adapter results; failures dead-letter with backoff.

## Sources

1. https://developers.forem.com/api/v1#tag/articles/operation/createArticle
2. https://apidocs.hashnode.com (2.0 GraphQL, `publishPost` mutation)
3. https://ghost.org/docs/admin-api/#creating-a-post
4. https://developer.wordpress.org/rest-api/reference/posts/
5. https://help.medium.com/hc/en-us/articles/213480228 — "will not be issuing any new integration tokens"
6. https://github.com/mvanhorn/printing-press-library — "Substack has no public API"
7. https://learn.microsoft.com/en-us/linkedin/marketing/community-management/shares/posts-api
8. https://cicero.studio/en/blog/topic-cluster-seo (2026)
9. https://vaza.ai/blog/mdx-vs-markdown-seo — "MDX and Markdown produce identical HTML"
