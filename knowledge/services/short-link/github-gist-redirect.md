---
type: service
title: "GitHub Gist redirect (HTML meta-refresh)"
description: "Zero-infrastructure URL redirect: a GitHub gist containing a single HTML page with meta-refresh + canonical link. Tier 3 fallback in the family's three-tier short-link stack — last-resort, immutable, survives a complete Cloudflare outage."
tags: [short-link, github, gist, meta-refresh, zero-infra, fallback, immutable]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: url-shortener-zero-infra
provider: github
free_tier: "Unlimited public gists on GitHub free tier. No card, no quota cliff at family scale."
swap_cost: low
related:
  - services/short-link/cloudflare-worker
  - services/short-link/tinyurl
  - decisions/architecture/url-shortener-mitigation-tiers
  - services/storage/github-releases
  - rules/no-card-on-file
---

# GitHub Gist redirect (HTML meta-refresh)

## Role

**Tier 3 zero-infrastructure fallback** in the family's three-tier
URL-shortener stack (see
[`decisions/architecture/url-shortener-mitigation-tiers.md`](../../decisions/architecture/url-shortener-mitigation-tiers.md)).
Tier 1 is the [s.oriz.in CF Worker](./cloudflare-worker.md), Tier 2
is [TinyURL](./tinyurl.md), Tier 3 is this service.

Used when:

- **Both Tier 1 and Tier 2 are unreachable** simultaneously (~never
  in practice — would require Cloudflare AND TinyURL down at once).
- The family wants a **permanent, immutable redirect** for a critical
  link (a talk URL, a conference QR code, a paper citation) where
  even the small risk of a third-party shortener disappearing is too
  much.
- An **archival redirect** that must outlive the family's Cloudflare
  account if that ever transfers, and must outlive `tinyurl.com`'s
  corporate continuity.

## Free tier

- **Unlimited public gists** on GitHub free tier.
- No card-on-file required.
- No quota cliff observed at family scale.
- Hosted by GitHub, served via `gist.githubusercontent.com/.../raw/<file>.html`
  with `Content-Type: text/html` (auto-detected from `.html`
  extension), so browsers render the meta-refresh page.

## Card / subscription required?

**NO.** GitHub Free covers unlimited public gists. The family already
runs a free GitHub account for source hosting; no extra signup.

## How the redirect works

Each redirect is a single HTML file in a public gist:

```html
<!doctype html>
<meta charset="utf-8">
<title>Redirecting…</title>
<meta http-equiv="refresh" content="0; url=<TARGET>">
<link rel="canonical" href="<TARGET>">
<meta name="robots" content="noindex">
<script>location.replace('<TARGET>')</script>
<p>Redirecting to <a href="<TARGET>"><TARGET></a>…</p>
```

Three-layer redirect logic:

1. **`<meta http-equiv="refresh" content="0; url=…">`** — works even
   without JavaScript; standards-compliant since HTML 2.0.
2. **`location.replace(…)`** — instant client-side replace when JS
   runs; avoids adding the gist URL to history.
3. **Visible link** — final fallback for hostile JS-blocked
   environments.

Plus:

- **`<link rel="canonical">`** — search engines treat the canonical
  URL as the indexable surface, not the gist URL.
- **`<meta name="robots" content="noindex">`** — explicit instruction
  not to index the gist itself.

## Mint surface (manual only)

Tier 3 is **manual-mint only by design** — the family explicitly
does not automate gist creation:

1. Create a new gist at `https://gist.github.com/` under the
   `chirag127` account.
2. Filename: `<short-name>.html` (e.g. `talk-2026-knowledge.html`).
3. Paste the template above with `<TARGET>` substituted.
4. Save as **public** gist.
5. Copy the raw URL: `https://gist.githubusercontent.com/chirag127/<hash>/raw/<short-name>.html`.

Automation would create a write-frequent path against the gist API
and risk noisy gist-list churn against the user's profile. Keep it
manual; mint volume is single-digit per year.

## Why three layers and no automation?

- **Survives JS disabled** — the meta refresh fires regardless.
- **Survives `<noscript>`-aware crawlers** — the `<a>` link is
  followed.
- **Survives a complete Cloudflare outage** — GitHub is on AWS, no
  shared infrastructure with our Tier 1.
- **Survives the family's Cloudflare account closing** — hypothetical,
  but the gist account is independently owned.
- **No CI noise** — manual mint = no daily Action runs, no API key
  to rotate, no quota to monitor.

## Alternatives

- **GitHub Pages on a `redirects.oriz.in` repo** — viable, but pulls
  the redirect surface back into the Cloudflare-DNS dependency
  (defeats the "Tier 3 must survive a Cloudflare outage" goal).
- **A tiny static-site generator that writes redirect HTML** — over-
  engineered for the single-digit mint volume.
- **Netlify-style `_redirects` file** — requires hosting on Netlify or
  similar; introduces another vendor without a free-tier-survivable
  fallback story.
- **A `.well-known/redirects.json` on every site** — requires every
  site to be online, which is exactly what Tier 3 exists to bypass.

## Swap cost

**Low.** Each redirect is a single static HTML file. Migrating to
another zero-infra hosting (e.g. Codeberg pages, Sourcehut paste) is
copy-paste-with-find-replace.

## Why this is our pick (for Tier 3)

- **Truly zero infra** — no DNS, no Worker, no Cloudflare account in
  the path.
- **Genuinely free, no card** — GitHub Free covers the entire surface.
- **Immutable + auditable** — gist history shows every change with a
  commit hash.
- **Permanent in practice** — gists from 2008 still resolve.
- **No third-party shortener dependency** — TinyURL is a separate
  vendor; gist redirects are family-controlled.

## Cross-refs

- [Three-tier URL shortener stack decision](../../decisions/architecture/url-shortener-mitigation-tiers.md)
- [Tier 1 — s.oriz.in CF Worker](./cloudflare-worker.md)
- [Tier 2 — TinyURL](./tinyurl.md)
- [GitHub Releases — sibling free zero-infra storage](../storage/github-releases.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
