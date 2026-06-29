---
type: service
title: "Klaro"
description: "OSS consent manager — lazy-loaded for EU/UK visitors, hosted on jsDelivr"
tags: [security, consent, cookie-banner, klaro, oss, privacy, gdpr]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: consent-manager
provider: kiprotect
free_tier: "OSS (BSD-3-Clause). Zero licence cost. Delivered from jsDelivr (free CDN per services/infra/cdn/jsdelivr.md)."
swap_cost: low
related:
  - services/monitoring/monitoring/analytics/cloudflare-web-analytics
  - services/monitoring/monitoring/analytics/posthog
  - services/infra/cdn/jsdelivr
  - security/cookie-banner-policy
  - rules/no-card-on-file
---

# Klaro

## Role

The family's **on-demand cookie consent manager**. Default posture
is **no banner at all** — see
[`security/cookie-banner-policy.md`](../../security/cookie-banner-policy.md) —
because the primary analytics signal,
[Cloudflare Web Analytics](../analytics/cloudflare-web-analytics.md),
is cookie-less and GDPR-safe.

Klaro engages only when:

1. A site loads a cookie-issuing tracker (e.g.
   [GA4](../analytics/index.md), [PostHog](../analytics/posthog.md)
   in identified mode), AND
2. The visitor is in the EU / UK (geo-detected via the Cloudflare
   `CF-IPCountry` header or equivalent edge signal).

Both conditions must be true. Non-EU visitors loading the same page
see no banner. Pages without cookie-issuing trackers never load
Klaro at all.

## Free tier

- **OSS — BSD-3-Clause.** Zero licence fee, no signup.
- Delivered from [jsDelivr](../cdn/jsdelivr.md) using the upstream
  unpkg manifest — no self-hosting, no S3 bucket, no Cloudflare R2
  cost.
- Embed is a single `<script>` tag + a `klaro-config.js` shape.

## Card / subscription required?

**NO.** Klaro is published by KIProtect under BSD-3 on
[GitHub: kiprotect/klaro](https://github.com/kiprotect/klaro) and on
npm as `klaro`. The hosted "Klaro Cloud" SaaS exists but is not used
by the family — we ship the OSS bundle from jsDelivr.

## How sites consume it

```html
<!-- Loaded only when both: (a) cookie-issuing tracker on this page,
     and (b) edge says CF-IPCountry is in [EU + UK + Iceland + Norway + Liechtenstein].
     The condition runs in the page's <head> before the tracker. -->
<script>
  if (window.__needsConsentBanner) {
    const s = document.createElement('script');
    s.src = 'https://cdn.jsdelivr.net/npm/klaro@latest/dist/klaro.js';
    s.defer = true;
    document.head.appendChild(s);
  }
</script>
```

The `__needsConsentBanner` flag is set by an inline edge-emitted
snippet that reads `CF-IPCountry`. The shared `<ConsentBanner>`
helper ships from `@chirag127/oriz-kit` (forward reference) so no
site re-implements the gate logic.

## CSP coupling

The family's [`_headers` preset](./cloudflare-headers.md) needs
`script-src` extended with `https://cdn.jsdelivr.net` (already
present for [jsDelivr](../cdn/jsdelivr.md) consumption) and
`style-src` extended with `'unsafe-inline'` for the modal's inline
styles **only on pages where Klaro is loaded** — the kit emits the
delta header conditionally.

## Alternatives

- **CookieYes** — freemium, cookie-banners-as-a-service. Free tier
  has watermark; paid tier requires card. Rejected.
- **Cookiebot** — paid past 100 subpages. Rejected.
- **Osano free** — 10K monthly visitors cap, attribution required.
  Rejected for visitor cap.
- **Tarteaucitron.js** — OSS alternative, similar feature set; Klaro
  picked for the cleaner config schema and the active KIProtect
  maintainer presence.
- **No banner ever** — what we do today by default; this service
  exists so we have a documented escape hatch for the EU+tracker
  case without taking a UX hit on the rest of the audience.

## Swap cost

Low — Klaro is invoked from one helper in
`@chirag127/oriz-kit`. Swapping to Tarteaucitron is a script-tag +
config-shape change.

## Why this is our pick

- **OSS, no card, no SaaS dependency** — fits the family rules.
- **Lazy-loadable** — costs zero bytes on the >90% of pageviews that
  don't need it (no EU visitor, or no cookie-issuing tracker on the
  page).
- **Geo-gated by Cloudflare's free `CF-IPCountry` header** — no
  third-party geo SaaS, no IP database to maintain.
- **Active OSS project** — last release recent, security advisories
  promptly addressed.

## Cross-refs

- [Cookie banner policy decision](../../security/cookie-banner-policy.md)
- [Cloudflare Web Analytics — primary signal, cookie-less](../analytics/cloudflare-web-analytics.md)
- [PostHog — cookie-issuing in identified mode](../analytics/posthog.md)
- [jsDelivr — bundle CDN](../cdn/jsdelivr.md)
- [Cloudflare `_headers` — CSP coupling](./cloudflare-headers.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
