---
type: decision
title: "Monitor only oriz.in apex, not subdomains"
description: SSL + uptime on apex only. Subdomains inherit via CF
tags: [monitoring, ssl, decision]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related: [services/monitoring/monitoring/better-stack, rules/never-hit-quotas]
---

# Monitor only oriz.in apex, not subdomains

## Decision

SSL + uptime monitoring (Better Stack and/or Otterwatch) is configured
only for the top-level apex domain `oriz.in` — never per subdomain.

## Why

Cloudflare auto-rotates the SSL certificate for every `*.oriz.in`
subdomain whenever the apex zone's cert renews, so a single apex
monitor catches the failure mode that actually matters (cert
provisioning / DNS / origin reachability at the zone level).
Free-tier monitor slots are scarce — Better Stack gives 10 and
Otterwatch gives 5 — and burning them on subdomains that share the
apex zone's fate is wasted capacity. One apex monitor preserves slots
for genuinely independent endpoints we may add later.

## Implications

- Exactly **1 monitor** is configured in Better Stack, pointing at
  `https://oriz.in`.
- New subdomains (`books.oriz.in`, `finance.oriz.in`, `me.oriz.in`,
  etc.) do **not** get added to the monitor list when they ship.
- If a future subdomain has a genuinely independent cert path — custom
  CA, a different Cloudflare zone, an external CNAME flatten target,
  or an origin not fronted by Cloudflare — record a separate decision
  before adding a monitor for it. Default remains apex-only.
- Status page on `status.oriz.in` reflects the apex check only;
  per-subdomain status is not surfaced.

## Cross-refs

- [`services/monitoring/monitoring/better-stack.md`](../../services/monitoring/monitoring/better-stack.md)
- [`services/monitoring/monitoring/healthchecks-io.md`](../../services/monitoring/monitoring/healthchecks-io.md)
- [`services/infra/domain/cloudflare-dns.md`](../../services/infra/domain/cloudflare-dns.md)
- [`rules/interaction/never-hit-quotas.md`](../../rules/interaction/never-hit-quotas.md)
