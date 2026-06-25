---
type: service
title: "Cloudflare WAF + Bot Fight Mode"
description: "Edge-layer Web Application Firewall + Bot Fight Mode — included in the Cloudflare free plan, no card. Blocks known bad IPs, common attack patterns, and obvious bot signatures before they reach the origin / Worker."
tags: [security, waf, anti-bot, cloudflare, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: anti-bot-waf
provider: cloudflare
free_tier: "Included in Cloudflare free plan — managed ruleset (curated free WAF), Bot Fight Mode (basic bot blocking), unmetered DDoS protection, configurable rate-limiting (10K req/10min on free)"
swap_cost: medium
related:
  - services/security/cloudflare-turnstile
  - services/security/hono-rate-limit
  - services/security/cloudflare-headers
  - decisions/security/anti-bot-defense-in-depth
  - rules/no-card-on-file
---

# Cloudflare WAF + Bot Fight Mode

## Role

The **edge-layer** of the family's anti-bot defense-in-depth. Sits in
front of every `*.oriz.in` zone (Pages + Workers) and rejects:

- Requests matching the Cloudflare-managed free WAF ruleset (SQLi /
  XSS / RFI / common CMS exploits / known-bad user-agents).
- Requests from IPs on Cloudflare's threat-intelligence list.
- Obvious automated traffic flagged by **Bot Fight Mode** (signature
  + behavioural heuristics).
- DDoS at the network + L7 layers (unmetered, included).

Whatever survives the WAF reaches the Worker / origin and is then
gated by [Turnstile](./cloudflare-turnstile.md) (form-submit
challenge) and [Hono rate-limit middleware](./hono-rate-limit.md)
(per-IP API throttling).

## Free tier

- Managed WAF ruleset (curated free) — auto-updated by Cloudflare
- Bot Fight Mode — basic bot blocking (free tier)
- Unmetered DDoS protection (L3 / L4 / L7)
- Up to 5 custom WAF rules (free plan; more on paid plans)
- Configurable rate-limit rules (10K requests / 10 min on free, per
  zone)
- All applied at the edge — zero CPU on origin / Worker

## Card / subscription required?

**NO.** Inherits the existing Cloudflare free-plan account that hosts
[Pages](../hosting/cloudflare-pages.md), [Workers](../compute/cloudflare-workers.md),
[DNS](../domain/cloudflare-dns.md), [Turnstile](./cloudflare-turnstile.md),
[Email Routing](../domain/cloudflare-email-routing.md), and
[Cron Triggers](../cron/cloudflare-cron-triggers.md). No new account
surface, no card.

## Configured per zone via Terraform / dashboard

```toml
# WAF ruleset
[waf.managed]
ruleset = "cf_managed_free"   # auto-updated
mode    = "block"

# Bot Fight Mode
[security.bot_management]
fight_mode = "on"             # free tier

# Rate limit (free plan)
[[ratelimit.rules]]
match     = "http.request.uri.path matches \"^/api/\""
threshold = 100
period    = 60
action    = "challenge"        # serves Turnstile managed challenge
```

The threshold above is a coarse zone-level safety net; finer-grained
per-route limits live in the [Hono rate-limit middleware](./hono-rate-limit.md).

## Alternatives

- AWS WAF — requires AWS account + card; rejected by family policy.
- Sucuri / Imperva — paid past trial.
- Self-rolled IP block-list — fragile, no DDoS coverage, no managed
  ruleset.
- Bunny.net Shield — possible swap target if Cloudflare ever fails-closed
  on the family.

## Swap cost

**Medium.** WAF rules are Cloudflare-syntax; porting to AWS / Bunny
means re-authoring the rule set. Bot Fight Mode is unique to
Cloudflare. The DNS swap is straightforward; the rule-port is the
work.

## Why this is our pick

The family already runs every other layer on the same Cloudflare
account; the WAF + Bot Fight Mode are zero-incremental-config
add-ons. Combined with Turnstile (form-submit) + Hono rate-limit
(API), the family gets three layers of bot defense without paying
for a single one — locked in
[`decisions/security/anti-bot-defense-in-depth.md`](../../decisions/security/anti-bot-defense-in-depth.md).

## Cross-refs

- [Security services index](./index.md)
- [Anti-bot defense-in-depth decision](../../decisions/security/anti-bot-defense-in-depth.md)
- [Cloudflare Turnstile — form-submit captcha layer](./cloudflare-turnstile.md)
- [Hono rate-limit — API rate-limit layer](./hono-rate-limit.md)
- [Cloudflare _headers — static security headers](./cloudflare-headers.md)
- [Cloudflare Pages — host that sits behind WAF](../hosting/cloudflare-pages.md)
- [Cloudflare Workers — compute behind WAF](../compute/cloudflare-workers.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
