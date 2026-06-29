---
type: index
title: "Comments services"
description: "Blog comment systems used on long-form content sites (oriz-blog-site, oriz-book-lore-site). One pick — Giscus — with click-to-load privacy gating per the consent decision. App sites carry no comments."
tags: [services, comments, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Comments services

Comments live ONLY on long-form content sites in the family —
[`oriz-blog-site`](../../branding/repo-naming-suffixes.md)
and `oriz-book-lore-site`. App sites
(`oriz-finance-site` / `oriz-image-tools-site` / `oriz-home-site` /
`oriz-me-site`) intentionally ship without a comments surface — they
are utility apps, not discussion venues, and skipping comments removes
a moderation surface and a third-party iframe from each app build.

| Service | Status | Role | Tier / fee |
|---|---|---|---|
| [giscus.md](./giscus.md) | active | GitHub-Discussions-backed comments on blog + book-lore | Free forever, no card; auth via GitHub login |

## Click-to-load privacy posture

Per [`security/consent-management-multi-category.md`](../../security/consent-management-multi-category.md),
Giscus is **NOT** auto-loaded on first paint. The post page renders a
`<button>Load comments</button>` placeholder; clicking it lazy-injects
the Giscus iframe. This:

- saves bandwidth on the ~80% of readers who never read comments,
- skips a third-party iframe + GitHub session cookie until the user
  asks for it,
- removes Giscus from the consent banner surface entirely (no
  pre-consent third-party load = no banner gate needed for it).

## Cross-refs

- [Giscus](./giscus.md)
- [Consent management multi-category decision](../../security/consent-management-multi-category.md)
- [Repo naming suffixes decision](../../branding/repo-naming-suffixes.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
