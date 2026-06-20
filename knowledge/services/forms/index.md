---
type: index
title: "Form services"
description: "Form submission backends used by the family."
tags: [services, forms, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Form services

Three roles, locked at [`decisions/architecture/forms-trio.md`](../../decisions/architecture/forms-trio.md): Web3Forms + Static Forms cover contact-form HA (vendor-redundant pair); Tally handles rich / multi-step / conditional forms. All three free, no card.

| Service | Status | One-line role |
|---|---|---|
| [web3forms.md](./web3forms.md) | active | Contact form — primary (browser-only, domain-bound key, unlimited free) |
| [static-forms.md](./static-forms.md) | active | Contact form — fallback (different vendor + edge; auto-swapped on Web3Forms failure) |
| [tally.md](./tally.md) | active | Rich form builder — multi-step, conditional logic, integrations |
| [formspree.md](./formspree.md) | fallback | Second documented swap target |

## Why two contact backends?

Single-vendor risk. If Web3Forms quotas tighten or the service has
an outage, every contact form on every site goes dark unless we have
a sibling on different infrastructure. Same pattern as the
[two-captcha pair](../security/cloudflare-turnstile.md) and the
[double security-headers audit](../security/index.md).

## Cross-refs

- [Forms trio decision](../../decisions/architecture/forms-trio.md)
- [rules/no-web3forms-server-side](../../rules/no-web3forms-server-side.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
