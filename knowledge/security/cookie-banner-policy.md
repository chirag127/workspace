---
type: decision
title: "Cookie banner policy — none by default; Klaro lazy-loaded only for EU+tracker pages"
description: No cookie banner default. Klaro only for EU/UK with trackers
tags: [security, privacy, gdpr, cookie-banner, klaro, geo, posthog, ga4]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - services/business/security/klaro
  - services/monitoring/monitoring/analytics/cloudflare-web-analytics
  - services/monitoring/monitoring/analytics/posthog
  - security/security-headers-strategy
  - rules/no-card-on-file
---

# Cookie banner policy — none by default; Klaro lazy-loaded only for EU+tracker pages

## Decision

The family runs **NO cookie banner by default** across `*.oriz.in`.
The default analytics signal —
[Cloudflare Web Analytics](../../services/monitoring/monitoring/analytics/cloudflare-web-analytics.md) —
is cookie-less, samples no PII, and falls under the GDPR
"strictly-necessary / no consent required" carve-out.

A consent banner ([Klaro](../../services/business/security/klaro.md)) loads
only when **both** conditions are true on a given pageview:

1. The page actually mounts a **cookie-issuing tracker** —
   [PostHog](../../services/monitoring/monitoring/analytics/posthog.md) in identified mode,
   GA4 (when added), or any other tracker that drops a non-strictly-necessary
   cookie.
2. The edge identifies the visitor as **EU / UK** (Cloudflare
   `CF-IPCountry` header in [EU member states] ? {GB, IS, NO, LI}).

Non-EU visitors see no banner. Pages without cookie-issuing trackers
load no banner. Klaro's bundle is fetched from
[jsDelivr](../../services/infra/cdn/jsdelivr.md) only on the small
intersection of (EU visitor) × (tracker-bearing page).

## Why

- **Most family visitors are non-EU.** A blanket banner taxes ~80% of
  pageviews that legally don't need consent. The UX cost (modal
  interrupt + click-through-fatigue) is real and avoidable.
- **Cloudflare Web Analytics is the primary signal and is cookie-less.**
  GDPR's "strictly-necessary" carve-out + ePrivacy's cookie-rule
  exemption both apply — no consent, no banner, full data.
- **Cookie-issuing trackers are the exception, not the rule.**
  PostHog runs in anonymous mode by default on the family; identified
  mode is opt-in. GA4 isn't deployed today. So most pages never trip
  condition (1).
- **Geo-gating is free.** Cloudflare's `CF-IPCountry` header on every
  request gives EU / UK detection at zero cost — no IP-database
  vendor, no SaaS geo-API.
- **Klaro is OSS, no card.** Picked per
  [`services/business/security/klaro.md`](../../services/business/security/klaro.md).
- **Banner-everywhere is a UX cost.** Banner-when-required is a
  pragmatic compromise that keeps the family compliant where it
  matters and friction-free where it doesn't.

## Implications

### Default surface
- No `klaro-config.js`, no banner script, no consent-cookie checks
  on the >90% of pages that load only Cloudflare Web Analytics.
- No "Privacy Settings" link in footers by default — only on sites
  that actually load a tracker.

### Tracker-bearing pages
- The page's `<head>` mounts an inline guard **before** the tracker
  loads. The guard reads an edge-emitted `__cfCountry` global and
  decides whether to lazy-load
  [Klaro](../../services/business/security/klaro.md) from
  [jsDelivr](../../services/infra/cdn/jsdelivr.md).
- Trackers must wait for `klaro.consent.granted` before firing. The
  shared `<ConsentBanner>` helper in `@chirag127/oriz-kit` (forward
  reference) wires this up so no site re-implements it.

### CSP delta
- The family `_headers` preset doesn't change for default pages.
- On tracker-bearing pages, the kit emits the additional CSP
  directive needed for Klaro's modal — see the CSP coupling section
  in [`services/business/security/klaro.md`](../../services/business/security/klaro.md).

### When to revisit
- If the family adds a tracker that issues cookies on EVERY page
  (e.g. GA4 site-wide), condition (1) becomes always-true and we
  re-evaluate whether the banner stays geo-gated or becomes
  global. Today's posture stays unless that change ships.

## What we don't do

- **No "consent or pay"** dark patterns.
- **No third-party SaaS consent manager** — CookieYes, Cookiebot,
  Osano all rejected per the no-subscriptions rule and (in some
  cases) card-on-file requirement.
- **No banner on Cloudflare Web Analytics-only pages** — would imply
  consent is needed where it legally isn't, training visitors to
  click-through on every site.

## Cross-refs

- [Klaro service entry](../../services/business/security/klaro.md)
- [Cloudflare Web Analytics — primary signal, cookie-less](../../services/monitoring/monitoring/analytics/cloudflare-web-analytics.md)
- [PostHog — cookie-issuing in identified mode](../../services/monitoring/monitoring/analytics/posthog.md)
- [Security headers strategy](./security-headers-strategy.md)
- [jsDelivr — Klaro bundle CDN](../../services/infra/cdn/jsdelivr.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [No subscriptions rule](../../rules/infrastructure/no-subscriptions.md)
