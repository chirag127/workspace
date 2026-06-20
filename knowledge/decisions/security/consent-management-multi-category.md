---
type: decision
title: "Consent management for many categories — Klaro config + GA4 Consent Mode v2 + geo routing + cookie-less default"
description: "Locks the family's multi-category consent management. Klaro defines 5 categories (necessary / analytics / marketing / functional / social) with a per-service map. EU/UK shows banner default-DENIED; US/CA shows banner default-ACCEPTED with Sec-GPC honoured (CCPA opt-out model); rest of world: no banner. Klaro itself lazy-loads only when needed. Cookie-less modes used by default."
tags: [security, privacy, consent, klaro, gdpr, ccpa, gpc, cookies, multi-category, geo]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - services/security/klaro
  - services/analytics/cloudflare-web-analytics
  - services/analytics/posthog
  - services/analytics/microsoft-clarity
  - services/push/knock
  - services/push/fcm
  - decisions/security/cookie-banner-policy
  - decisions/security/security-headers-strategy
  - rules/no-card-on-file
  - rules/never-hit-quotas
---

# Consent management for many categories — Klaro config + GA4 Consent Mode v2 + geo routing + cookie-less default

## Decision

The family's consent surface uses **5 categories × N services** via
[Klaro](../../services/security/klaro.md), with three orthogonal
levers stacked on top:

1. **Geo-routed defaults** — EU/UK gets default-DENIED banner;
   US/CA gets default-ACCEPTED with `Sec-GPC` honoured; rest of world
   gets NO banner.
2. **Lazy-loaded Klaro itself** — Klaro JS ships ONLY to visitors
   whose `CF-IPCountry` is in the EU/UK/CCPA list. Other visitors get
   zero CLS, zero render-block, zero Klaro bytes.
3. **Cookie-less defaults** — every service that has a cookie-less
   mode uses it by default, so the consent surface stays small.

This **refines, not supersedes**,
[`decisions/security/cookie-banner-policy.md`](./cookie-banner-policy.md)
— that policy stated "no banner unless EU + tracker"; this decision
adds the explicit category map, the US/CA + GPC handling, the lazy-
load rule, and the cookie-less default rule.

## Categories (Klaro `purposes` array)

| Category | What it covers | Default consent |
|---|---|---|
| `necessary` | Auth session (Firebase Auth), CSRF tokens, session cookies, transactional notification routing | Always on, no consent UI shown |
| `analytics` | GA4, PostHog (autocapture mode), Microsoft Clarity, Sentry user-context, Algolia Insights | Geo-default (see Geo-routing below) |
| `marketing` | UTM persistence cookie, email-marketing UTM tracking, Razorpay cart UUID | Geo-default |
| `functional` | Theme preference, language preference, font-size preference, FCM push opt-in | Geo-default |
| `social` | Giscus comment cookie, Bluesky / AT Protocol auth tokens for lifestream embed | Off until user-clicked |

## Services map (Klaro `services` array)

| Service | Category | Pre-consent posture | Notes |
|---|---|---|---|
| [Cloudflare Web Analytics](../../services/analytics/cloudflare-web-analytics.md) | `necessary` | Loaded always | Cookie-less by design; documented under necessary for legal clarity |
| [Sentry](../../services/monitoring/sentry.md) | `necessary` (default) → `analytics` if user-PII captured | Loaded with PII off by default | Default Sentry config does NOT capture PII; if a site flips on user-context, the entry moves to `analytics` for that site |
| [Google Analytics 4](../../services/analytics/index.md) | `analytics` | Loaded in `denied` mode via GA4 Consent Mode v2 | Script loads, but tags fire only after `gtag('consent', 'update', { analytics_storage: 'granted' })` |
| [PostHog](../../services/analytics/posthog.md) | `analytics` | `capture_pageview: false`, `persistence: 'memory'` until consent | After consent, persistence flips to `localStorage`; PostHog keeps anonymous mode by default per its service file |
| [Microsoft Clarity](../../services/analytics/microsoft-clarity.md) | `analytics` + `marketing` | Blocked until consent | Session-recording is the most sensitive surface; gated to both categories so denying either suppresses Clarity entirely |
| [Knock](../../services/push/knock.md) | `necessary` | Loaded always | Server-side transactional notifications; no client cookies |
| [FCM (web push)](../../services/push/fcm.md) | `functional` | Browser permission prompt only after user clicks "Enable notifications" | Consent for FCM is the OS-level Notifications permission, not a Klaro toggle; the toggle just shows the in-app prompt button |
| [Giscus](../../services/code-embed/index.md) | `social` | Loaded only after consent OR user-click on a "Load comments" placeholder | Lazy-loaded iframe; placeholder visible until clicked |
| [Algolia Insights](../../services/search/algolia.md) | `analytics` | Disabled until consent | Algolia search itself is `necessary`; the Insights events client is gated separately |
| UTM persistence cookie | `marketing` | Set only after consent (EU); set immediately (US/CA pre-GPC); never set (rest, falls through to URL-only) | Documented in [`utm-attribution-strategy.md`](../architecture/utm-attribution-strategy.md) |
| Razorpay cart UUID | `marketing` | Set on checkout-page entry; outside Klaro scope (necessary for the checkout flow) but flagged for legal clarity | Razorpay's own SDK manages this; the family doesn't override |
| Theme / language / font-size prefs | `functional` | Set immediately, anywhere (low-sensitivity preferences) | Pre-existing user expectation that prefs persist; falls under "strictly necessary for the requested feature" |

## Geo-routing rule

The CF edge reads `CF-IPCountry` on every request and emits a tiny
inline `<script>` that sets `window.__consentRegime` before any
tracker loads:

| Visitor region | `__consentRegime` | Banner shown? | Default consent | Auto-honour |
|---|---|---|---|---|
| EU member state, UK, IS, NO, LI, CH | `'eu'` | Yes | **DENIED** for analytics / marketing / functional / social | — |
| US, CA | `'ccpa'` | Yes (CCPA "Do Not Sell" link required) | **ACCEPTED** | `Sec-GPC: 1` request header → auto-DENY analytics + marketing |
| Rest of world | `'rest'` | **No banner** | Trackers load if locally lawful (cookie-less default services always; cookie-issuing services per local law) | — |

**`Sec-GPC: 1` (Global Privacy Control)** is honoured on every CCPA-
region request: when the header is present, Klaro pre-fills the
banner with analytics + marketing toggles OFF, equivalent to a CCPA
"Do Not Sell or Share" opt-out. The visitor can still re-enable via
the banner — GPC is the default, not a hard gate.

## Lazy-load rule

Klaro's JS bundle (~17 KB gzipped from
[jsDelivr](../../services/cdn/jsdelivr.md)) ships **only** to
visitors whose `CF-IPCountry` is in the union of EU + UK + Iceland +
Norway + Liechtenstein + Switzerland + US + CA. Other visitors:

- **No Klaro JS download** → zero render-block.
- **No banner DOM** → zero CLS.
- **No `klaro-config.js`** → zero parse cost.

The CF edge emits a tiny inline `<script>` that conditionally injects
the Klaro `<script>` tag. The shared `<ConsentBanner>` helper in
`@chirag127/oriz-kit` (forward reference) ships this gate so no site
re-implements it.

This refines [`cookie-banner-policy.md`](./cookie-banner-policy.md):
that policy gated Klaro on (EU visitor) × (cookie-issuing tracker on
this page); this decision widens the visitor list to cover CCPA
regions and codifies the lazy-load JS-loading rule.

## Cookie-less default rule

For services that have a cookie-less mode, USE IT by default:

| Service | Cookie-less mode | Default? |
|---|---|---|
| [Cloudflare Web Analytics](../../services/analytics/cloudflare-web-analytics.md) | Cookie-less by design | Yes |
| [Sentry](../../services/monitoring/sentry.md) | `sendDefaultPii: false` (default) | Yes |
| Cloudflare Pages basic auth (where used) | Token-based, no cookie | Yes |
| [PostHog](../../services/analytics/posthog.md) | `persistence: 'memory'` pre-consent | Yes (until consent flips it) |
| [reCAPTCHA Enterprise](../../services/auth/recaptcha-enterprise.md) | Cookie-less assessment mode | Yes (Firestore-write surface only) |
| [Cloudflare Turnstile](../../services/security/cloudflare-turnstile.md) | Cookie-less by design | Yes |

The smaller the cookie-issuing surface, the smaller the consent UI
the family ever has to ship.

## Why

- **Many categories + many cookies** is exactly Klaro's design point;
  it scales N-services × N-purposes without re-architecting.
- **GA4 Consent Mode v2** is Google's official answer to "load the
  script, defer the firing" — pragmatic, doesn't require GA4 to
  fight the family's consent flow.
- **Geo-routed defaults** match law: EU is opt-in (GDPR), US/CA is
  opt-out (CCPA); ROW currently has no broad cookie-consent law that
  the family must defensively honour. This avoids the "banner-fatigue
  tax" on ~80% of visitors who legally don't need a banner.
- **Lazy-loading Klaro itself** means most pageviews ship zero
  consent JS — keeps Web Vitals high, keeps CLS at zero.
- **Cookie-less by default** means the categories the user has to
  consider are smaller in the first place; the more cookie-less
  services we use, the less work the consent surface does.
- **All services in this map are free, no card** — the family's
  rules continue to hold; consent management adds no cost surface.

## Implications

- **Single Klaro config lives in `@chirag127/oriz-kit`** (forward
  reference). Every site imports the shared `purposes[]` and
  `services[]` arrays + a per-site override for which services
  actually load on that site.
- **GA4 Consent Mode v2 must be wired in** the moment GA4 first
  ships on any site. Today GA4 isn't deployed; when it lands, the
  service file gets updated to reflect the consent-mode posture.
- **`Sec-GPC` parsing** lives in the same edge inline script as the
  geo-routing logic — the CF edge passes it through; the inline
  script reads `navigator.globalPrivacyControl` (the JS surface) +
  the response of a tiny header-echo Worker if needed.
- **Per-site rendering of the "Privacy Settings" footer link** —
  shown ONLY when at least one cookie-issuing service in
  analytics/marketing/social is in the per-site service list AND the
  visitor's `__consentRegime !== 'rest'`. Sites with only
  `necessary` services (e.g. a static doc page) get no link.
- **CSP delta on Klaro pages** — already documented in
  [`services/security/klaro.md`](../../services/security/klaro.md);
  the kit emits the additional `style-src 'unsafe-inline'` only on
  pages where Klaro loads.
- **Microsoft Clarity is dual-categoried** — denying either analytics
  OR marketing suppresses it; this is intentional caution given
  session-recording is the most sensitive class of capture.
- **Giscus loads on user click** even before consent if the visitor
  taps the "Load comments" placeholder — consent is implicit from the
  click; documented in the Giscus per-site placement.
- **No third-party SaaS consent manager** — CookieYes / Cookiebot /
  Osano / OneTrust all rejected per
  [`rules/no-subscriptions.md`](../../rules/no-subscriptions.md) and
  (in some cases) card-on-file requirement.

## Cross-refs

- [Klaro service entry](../../services/security/klaro.md)
- [Cookie banner policy (refined by this decision)](./cookie-banner-policy.md)
- [Cloudflare Web Analytics — cookie-less primary signal](../../services/analytics/cloudflare-web-analytics.md)
- [PostHog — cookie-issuing in identified mode](../../services/analytics/posthog.md)
- [Microsoft Clarity — session recording](../../services/analytics/microsoft-clarity.md)
- [Knock — transactional notifications, server-side](../../services/push/knock.md)
- [FCM — web push, functional category](../../services/push/fcm.md)
- [Security headers strategy — CSP coupling](./security-headers-strategy.md)
- [UTM attribution strategy — marketing-cookie context](../architecture/utm-attribution-strategy.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
- [No subscriptions rule](../../rules/no-subscriptions.md)
- [Never hit quotas rule](../../rules/never-hit-quotas.md)
