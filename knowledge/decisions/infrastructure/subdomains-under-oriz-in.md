---
type: decision
title: "Custom-domain strategy is *.oriz.in subdomains"
description: "Every site, extension, and API endpoint binds to a subdomain under oriz.in — never to a separate apex domain."
tags: [dns, domains, subdomain, oriz-in]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/content/per-extension-subdomain
  - decisions/monetisation/adsense-apex-application
  - decisions/infrastructure/cloudflare-pages-for-all-sites
---

# Custom-domain strategy is *.oriz.in subdomains

## Decision

Every site, every extension, and the umbrella API all bind to
subdomains under `oriz.in`. The family does not own or use any
other apex domain. Examples: `blog.oriz.in`, `journal.oriz.in`,
`books.oriz.in`, `me.oriz.in`, `api.oriz.in`, `auth.oriz.in`,
`extensions.oriz.in`, `<ext-slug>.oriz.in`.

## Why

A single apex domain unifies brand identity across the family,
gives a single AdSense application surface (per AdSense 2026 rules,
all subdomains inherit), and concentrates DNS / DDoS / WAF
configuration in one Cloudflare zone. Spreading across multiple
apex domains would require duplicate AdSense applications, separate
Cloudflare zones, separate DNS records, separate domain renewal
tracking — all without a brand benefit since the family is already
tightly themed.

## Implications

- DNS lives in one Cloudflare zone (`oriz.in`); sub-records added per site/extension/service.
- Cloudflare WAF rules apply uniformly to `*.oriz.in`.
- AdSense apex application at `oriz.in` covers every subdomain (see [adsense-apex-application](../monetisation/adsense-apex-application.md)).
- Auth domain is `auth.oriz.in` so Firebase Auth's hosted handlers are first-party from every site's perspective — no third-party-cookie issues.
- The domain is registered with Cloudflare Registrar at-cost, in 10-year increments where supported (per the 100-year strategy).
- Sub-subdomains are allowed where useful (e.g. `staging.api.oriz.in`) but discouraged for production routes.

## Cross-refs

- [Per-extension subdomain](../content/per-extension-subdomain.md)
- [AdSense apex application](../monetisation/adsense-apex-application.md)
- [Cloudflare Pages for all sites](./cloudflare-pages-for-all-sites.md)
- [100-year strategy locked](../content/100-year-strategy-locked.md)
