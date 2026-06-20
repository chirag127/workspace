---
type: decision
title: "Spaceship is the registrar; Cloudflare hosts DNS + email routing"
description: "Family domains stay at Spaceship (the user's existing registrar). NS records delegate DNS to Cloudflare. Cloudflare Email Routing forwards every address into a single Gmail inbox."
tags: [decisions, infrastructure, dns, email, spaceship, cloudflare]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - services/domain/spaceship
  - services/domain/cloudflare-dns
  - services/domain/cloudflare-email-routing
  - services/domain/cloudflare-registrar
  - decisions/infrastructure/cloudflare-pages-for-all-sites
  - decisions/infrastructure/subdomains-under-oriz-in
---

# Spaceship is the registrar; Cloudflare hosts DNS + email routing

## Decision

Three roles, three places, one inbox:

- **Registrar** = [Spaceship](../../services/domain/spaceship.md). The user's existing registrar holds `oriz.in`, `oriz.me`, and any future family domains. WHOIS privacy is on, auto-renew enabled.
- **DNS host** = [Cloudflare DNS](../../services/domain/cloudflare-dns.md). Spaceship NS records point at Cloudflare's nameservers. All A / AAAA / CNAME / MX / TXT records are managed at Cloudflare.
- **Inbound email** = [Cloudflare Email Routing](../../services/domain/cloudflare-email-routing.md) → forwards `*@oriz.in`, `*@oriz.me`, and every per-extension / per-site subdomain into one Gmail inbox. The family does not host mailboxes.

This **supersedes** the earlier "use Cloudflare Registrar everywhere"
direction — Cloudflare Registrar stays documented as a swap target
in [`services/domain/cloudflare-registrar.md`](../../services/domain/cloudflare-registrar.md)
but is not the active pick.

## Why

- The user already runs Spaceship as their existing registrar across personal domains. Consolidating the new `oriz*` domains there keeps renewal management in one place — fewer dashboards, fewer payment methods to track, one set of renewal alerts in Gmail.
- DNS at Cloudflare is non-negotiable: it integrates Pages / Workers / R2 / DNS / Email Routing in one dashboard, and is free at any scale the family hits. Spaceship's bundled DNS is fine but doesn't have the integration surface.
- Cloudflare Email Routing is free up to 200 routing addresses per zone with unlimited forwarding volume — far more than the family will ever need. Pairs with [Resend](../../services/email/resend.md) for outbound, so receive ↔ send both stay free.
- One Gmail inbox is the simplest possible mail surface — all routing rules live at Cloudflare; per-purpose labels live at Gmail; no additional inbox to monitor.
- Domain renewal at Spaceship is the **same narrow card-on-file exception** the family already accepts for any registrar (see [`no-card-on-file.md`](../../rules/no-card-on-file.md)) — it's not a new exception.

## Implications

### DNS / domain plumbing

- At Spaceship: NS records for each zone set to the pair Cloudflare assigns (`xxx.ns.cloudflare.com`). Verify with `dig NS oriz.in`.
- Cloudflare DNS holds all other records:
  - Apex `oriz.in` → Cloudflare Pages project for the home site
  - `*.oriz.in` subdomains → individual Cloudflare Pages projects (per [`subdomains-under-oriz-in.md`](./subdomains-under-oriz-in.md), [`cloudflare-pages-for-all-sites.md`](./cloudflare-pages-for-all-sites.md))
  - `auth.oriz.in` → Firebase Auth's hosted handler
  - `api.oriz.in` → Hono Worker
  - `s.oriz.in` → short-link Worker
  - `status.oriz.in` → Better Stack status page
  - `status-backup.oriz.in` → Instatus mirror
  - MX → Cloudflare Email Routing's three MX hosts

### Email plumbing

- Cloudflare Email Routing: catch-all `*@oriz.in → <user>@gmail.com`, plus curated rules for `support@`, `security@`, `dmarc@`, `noreply@` (drop).
- SPF: `v=spf1 include:_spf.mx.cloudflare.net include:<resend-spf-host> -all` — verify the merged SPF stays inside the 10-lookup limit.
- DMARC: `v=DMARC1; p=quarantine; rua=mailto:dmarc@oriz.in;` (forwards to Gmail).
- DKIM: Resend's keys for outbound; Email Routing preserves original DKIM state on inbound forwards.
- Gmail filters apply per-purpose labels (`oriz/support`, `oriz/security`, …) so a single inbox stays navigable.

### Operational

- Renewal notifications route to the same Gmail inbox via the catch-all → starred + labelled by Gmail filters.
- Adding a new `oriz*` domain: register at Spaceship → add zone at Cloudflare → flip NS at Spaceship → enable Email Routing at Cloudflare → add catch-all rule. ~10 minutes.
- Migrating an existing domain TO Spaceship: 5-7 day registrar transfer. DNS stays put on Cloudflare throughout — zero resolution downtime.

## What we don't do

- **No Spaceship DNS** — even though it's free, NS-delegating to Cloudflare gets us the integrated dashboard and free DDoS / Pages auto-wire.
- **No Spaceship email forwarder** — Cloudflare Email Routing is the only forwarder used.
- **No mailbox hosting** — the family neither runs Postfix nor pays for Google Workspace / Fastmail / Migadu. Inbound forwards to one Gmail; outbound goes through Resend.
- **No Cloudflare Registrar** for new domains — Spaceship is now the active registrar. Cloudflare Registrar stays documented as a swap target only.

## Cross-refs

- [Spaceship registrar service entry](../../services/domain/spaceship.md)
- [Cloudflare DNS service entry](../../services/domain/cloudflare-dns.md)
- [Cloudflare Email Routing service entry](../../services/domain/cloudflare-email-routing.md)
- [Cloudflare Registrar — documented swap target](../../services/domain/cloudflare-registrar.md)
- [Cloudflare Pages for all sites](./cloudflare-pages-for-all-sites.md)
- [Subdomains under oriz.in](./subdomains-under-oriz-in.md)
- [Resend — outbound transactional](../../services/email/resend.md)
- [No card-on-file rule — domain-renewal exception](../../rules/no-card-on-file.md)
