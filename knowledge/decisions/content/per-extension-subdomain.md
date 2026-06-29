---
type: decision
title: "Each Chrome extension gets its own subdomain on oriz.in"
description: Each extension gets dedicated *.oriz.in subdomain + catalog slot
tags: [extensions, dns, hosting, subdomain]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/content/extensions-catalog-and-subdomains
  - decisions/content/big-website-per-extension
  - decisions/content/per-extension-privacy-policy
  - infrastructure/subdomains-under-oriz-in
---

# Each Chrome extension gets its own subdomain on oriz.in

## Decision

Every extension published to the Chrome / Firefox / Edge stores gets
its own subdomain at `<slug>.oriz.in` hosting the extension's full
website (features, docs, changelog, privacy, support).

## Why

Per the no-subscriptions and impress-recruiters mission, every
extension is a publicly indexable product surface. A dedicated
subdomain lets each one rank for its own brand and feature keywords,
own its own AdSense surface (apex application covers all subdomains
per AdSense 2026 rules), and present a complete narrative without
fighting catalog navigation. Subdomain-per-extension is also the
natural unit for per-extension privacy URLs the stores require.

## Implications

- Each extension repo deploys its site to Cloudflare Pages with a custom domain `<slug>.oriz.in`.
- DNS: one CNAME / `CNAME` flattening record per extension under the `oriz.in` zone.
- The catalog at `extensions.oriz.in` remains separate (see [extensions-catalog-and-subdomains](./extensions-catalog-and-subdomains.md)) and links INTO each extension subdomain.
- Per-extension `/privacy` pages live on the subdomain, satisfying store requirements.
- Cloudflare Pages free tier gives 100 custom domains per project, so even 50+ extensions stay under the cap.

## Cross-refs

- [Extensions catalog AND per-extension subdomains](./extensions-catalog-and-subdomains.md)
- [Big website per extension](./big-website-per-extension.md)
- [Per-extension privacy policy](./per-extension-privacy-policy.md)
- [Subdomains under oriz.in](../infrastructure/subdomains-under-oriz-in.md)
- [Cloudflare Pages for all sites](../infrastructure/cloudflare-pages-for-all-sites.md)
