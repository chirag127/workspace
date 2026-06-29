---
type: decision
title: "Anti-bot — defense in depth (CF WAF + Turnstile + Hono rate-limit)"
description: 'Bot defense: CF WAF + Turnstile + Hono rate-limit. All free'
tags: [security, anti-bot, decisions, defense-in-depth, cloudflare, turnstile, hono]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - services/business/security/cloudflare-waf
  - services/business/security/cloudflare-turnstile
  - services/business/security/hono-rate-limit
  - services/business/security/hcaptcha
  - security/captcha-turnstile-plus-hcaptcha
  - decisions/architecture/hono-worker-api-umbrella
  - decisions/architecture/cf-worker-quota-mitigation
  - rules/no-card-on-file
---

# Anti-bot — defense in depth (CF WAF + Turnstile + Hono rate-limit)

## Decision

The family runs **three** anti-bot layers, each at a different stage
of the request lifecycle. A request must pass all three to reach a
route handler. All three are free, no card, and run on infrastructure
the family is already using.

| Layer | Stage | Service | What it blocks |
|---|---|---|---|
| 1 | Edge (zone-wide) | [Cloudflare WAF + Bot Fight Mode](../../services/business/security/cloudflare-waf.md) | Known-bad IPs, common attack patterns (SQLi/XSS/RFI), obvious bot signatures, DDoS |
| 2 | Form-submit boundary | [Cloudflare Turnstile](../../services/business/security/cloudflare-turnstile.md) (with [hCaptcha](../../services/business/security/hcaptcha.md) fallback) | Automated form submissions on contact / sign-up / comment forms |
| 3 | API per-route throttle | [Hono rate-limit middleware](../../services/business/security/hono-rate-limit.md) | Per-IP per-route abuse on the api.oriz.in Worker |

## Why three layers (not one)

The user's direction was *"+ Turnstile (already locked)"*. The two
sibling layers (WAF + rate-limit) ride alongside because:

- **Each catches what the other misses** — WAF can't see per-route
  intent (everything looks like the same zone); Turnstile only fires
  on form-submit (most API endpoints aren't form-submits); Hono
  rate-limit can't see traffic the WAF already dropped at the edge.
- **Each is on different substrate** — a misconfiguration / outage /
  quota cliff on one layer is recoverable from the other two:
  WAF down ? Turnstile + rate-limit still gate; Turnstile rejected
  by region ? hCaptcha takes over; Worker over-quota ? WAF still
  drops the floor.
- **All three are free** on the family's existing Cloudflare account
  — zero incremental cost, zero new vendors.

This is the same defense-in-depth pattern as the
[double security-headers audit](./security-headers-strategy.md)
(securityheaders.com + Mozilla Observatory) and the
[two-captcha pair](./captcha-turnstile-plus-hcaptcha.md) (Turnstile
primary + hCaptcha fallback).

## Layer detail

### 1. Cloudflare WAF + Bot Fight Mode (edge)

- Configured per zone (`oriz.in`, `*.oriz.in`).
- Free managed ruleset; auto-updated by Cloudflare.
- Bot Fight Mode flags + challenges signature-known bots.
- Coarse zone-wide rate-limit rule (10K req/10min) as DDoS safety net.
- Runs **before** any Worker / Pages serve; zero CPU on origin.

### 2. Turnstile + hCaptcha fallback (form-submit)

- The shared `<Captcha>` component in
  <!-- TODO: broken link, was [`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md) --> gates every
  unauthenticated POST surface — `<ContactForm>`, sign-up, comment
  boxes — per the locked
  [Turnstile + hCaptcha pair decision](./captcha-turnstile-plus-hcaptcha.md).
- The Worker verifies the token server-side via
  `challenges.cloudflare.com/turnstile/v0/siteverify` (or hCaptcha's
  equivalent) before reading the form payload.
- App Check + reCAPTCHA Enterprise still front Firestore writes —
  different attack surface, different layer; not affected by this
  decision.

### 3. Hono rate-limit middleware (API per-route)

- Fine-grained per-route, per-IP, sliding-window throttle.
- Lives in `@chirag127/oriz-kit/server` so every Worker route
  imports the same middleware.
- Backed by Workers KV — runs on existing Worker + KV free tier per
  the [worker quota mitigation playbook](../architecture/cf-worker-quota-mitigation.md).
- Each route declares its own budget (`10/min` for contact,
  `100/min` for OG, `1000/min` for feed reads).

## Implications

- **Every site** inherits all three layers automatically — they ride
  on shared infrastructure (Cloudflare zone, oriz-kit, api.oriz.in
  Worker), no per-site configuration beyond mounting `<Captcha>` in
  forms.
- **CSP allow-list** in
  [`_headers` preset](../../services/business/security/cloudflare-headers.md)
  already permits `challenges.cloudflare.com` (Turnstile) and
  hCaptcha origin; no per-site CSP exception.
- **Observability** — the api.oriz.in Worker logs rate-limit
  trip events to [Axiom](../../services/business/tooling/axiom.md); Cloudflare
  WAF event log is queryable in the dashboard. PR-time alarms not
  yet wired (TODO).
- **Incident playbook** — if a flood breaks through (bypasses all
  three layers), the response is:
  1. Tighten Hono rate-limit on the affected route in oriz-kit, ship.
  2. Add a Cloudflare custom WAF rule (free plan: up to 5) for the
     observed pattern.
  3. Flip the affected form's `<Captcha>` to `interactive` mode
     (Turnstile interactive challenge) instead of invisible.
- **No card-on-file** — none of the three layers requires the
  Cloudflare Workers Paid plan, Cloudflare Pro plan, or any other
  paid Cloudflare product. The family stays on the
  [free-plan posture](../../rules/interaction/no-card-on-file.md).

## Cross-refs

- [Cloudflare WAF service](../../services/business/security/cloudflare-waf.md)
- [Cloudflare Turnstile service](../../services/business/security/cloudflare-turnstile.md)
- [hCaptcha service — Turnstile fallback](../../services/business/security/hcaptcha.md)
- [Hono rate-limit service](../../services/business/security/hono-rate-limit.md)
- [Captcha pair decision (Turnstile + hCaptcha)](./captcha-turnstile-plus-hcaptcha.md) — sibling
- [Security headers strategy decision](./security-headers-strategy.md) — adjacent layer
- [Umbrella Hono Worker decision](../architecture/hono-worker-api-umbrella.md)
- [CF Worker quota mitigation playbook](../architecture/cf-worker-quota-mitigation.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
