---
type: service
title: "Google Analytics 4 (GA4)"
description: "Marketing-funnel analytics — acquisition/engagement/conversion, free, no card"
tags: [analytics, ga4, google, marketing, funnel, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: analytics-marketing
provider: google
free_tier: "Standard GA4 property — free, no monthly cap; events sampled past ~10M/mo (well above family scale)"
swap_cost: medium
related:
  - services/monitoring/monitoring/analytics/cloudflare-web-analytics
  - services/monitoring/monitoring/analytics/posthog
  - services/monitoring/monitoring/analytics/microsoft-clarity
  - services/monitoring/monitoring/analytics/utm-tracking
  - services/business/security/klaro
  - decisions/architecture/analytics-five-tier-stack
  - security/consent-management-multi-category
  - rules/no-card-on-file
---

# Google Analytics 4 (GA4)

## Role

Marketing funnel — acquisition / engagement / conversion measured
against the same definitions advertisers, recruiters, and SEO tools
already speak. GA4 is layer **2** of the
[5-tier analytics stack](../../decisions/architecture/analytics-five-tier-stack.md):
shipped on **every site** in the family because the recruiter-facing
metric ("did the post on `oriz.in/blog/...` actually convert to a
sign-up / link-click / GitHub star?") is the only one expressed in
GA4's vocabulary.

## Free tier

- Standard GA4 property — free, no monthly cap
- Events sampled only past ~10M / month (family scale is well below)
- Unlimited properties / streams / dashboards
- 14-month default retention (configurable to 2-month or 38-month
  with `Google signals` off — we use 14)

## Card / subscription required?

**NO.** Sign-in with the same Google account; GA360 is the paid tier
and we never approach its threshold.

## Honest cookie banner is required

GA4 is cookie-based and reads/writes `_ga*` cookies, so it is gated
behind explicit consent in every region the family ships to. The
consent surface is locked at
[`security/consent-management-multi-category.md`](../../security/consent-management-multi-category.md):

- **EU / UK visitors** — [Klaro](../security/klaro.md) lazy-loads
  banner default-DENIED. GA4 boots in **Consent Mode v2 `denied`**
  state; if the user accepts the `analytics` category, Klaro fires
  `gtag('consent', 'update', { analytics_storage: 'granted' })` and
  the previously-buffered hits flush.
- **US / CA visitors** — banner default-ACCEPTED with `Sec-GPC`
  honoured (CCPA opt-out model); GA4 boots in `granted` and downgrades
  to `denied` if `Sec-GPC: 1` is observed.
- **Rest of world** — no banner; GA4 boots in `granted`.

Per the [consent decision](../../security/consent-management-multi-category.md),
Klaro itself lazy-loads ONLY when `CF-IPCountry` lands in the EU / UK
/ CCPA list — non-banner-region visitors never download Klaro bytes.

## Consent Mode v2 — the load contract

GA4 always boots with the **`denied` default** so the script is safe
to load before the consent answer is known:

```js
// in <Analytics /> from @chirag127/oriz-kit, before gtag.js
gtag('consent', 'default', {
  ad_storage: 'denied',
  ad_user_data: 'denied',
  ad_personalization: 'denied',
  analytics_storage: 'denied',
  functionality_storage: 'granted',  // strictly necessary
  security_storage: 'granted',       // strictly necessary
  wait_for_update: 500
});
```

Klaro then calls `gtag('consent', 'update', ...)` once the user
answers, per
[`services/business/security/klaro.md`](../security/klaro.md). Hits made
before consent are stored client-side and replayed on update — no
data is sent until consent lands.

## Per-site env-var toggle

Per the [never-hit-quotas rule](../../rules/interaction/never-hit-quotas.md), GA4
is one of the five layers covered by an env-var kill-switch:

```bash
ENABLE_GA4=true|false
```

The `<Analytics />` component in
<!-- TODO: broken link, was [`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md) --> reads this at
build time; setting `false` tree-shakes the GA4 script entirely
(zero bytes shipped, not just blocked at runtime).

Each site additionally carries its own GA4 measurement ID (`G-...`)
in [Doppler](../secrets/doppler.md) under `GA4_MEASUREMENT_ID` so a
single property never mixes traffic from multiple sites.

## Alternatives

- Plausible Cloud (paid)
- Fathom Analytics (paid)
- Matomo Cloud (paid past trial)
- Plausible / Umami / GoatCounter self-hosted (no funnel parity with
  advertiser-standard definitions)

GA4 is the only free tool that speaks the same vocabulary as Google
Ads, Search Console, recruiter analytics, and most SEO tooling — that
shared definition is the value, not the feature surface.

## Swap cost

Medium — every event call site uses `gtag('event', ...)` directly;
swap = re-map event names + dimensions to the replacement vendor's
schema. The `<Analytics />` component isolates the script-load surface
but not the per-event call sites.

## Why this is our pick

GA4 is the only free analytics tool that produces metrics in the
exact vocabulary recruiters, advertisers, and SEO consoles already
read. The other layers
([CFWA](./cloudflare-web-analytics.md),
[PostHog](./posthog.md), [Clarity](./microsoft-clarity.md),
[UTM](./utm-tracking.md)) cover engineering / product / replay /
attribution questions GA4 can't, but none of them produce
"acquisition channel × conversion rate" in the format an outside
reader expects.

## Cross-refs

- [Cloudflare Web Analytics](./cloudflare-web-analytics.md)
- [PostHog](./posthog.md)
- [Microsoft Clarity](./microsoft-clarity.md)
- [UTM tracking](./utm-tracking.md)
- [5-tier analytics stack decision](../../decisions/architecture/analytics-five-tier-stack.md)
- [Consent management multi-category decision](../../security/consent-management-multi-category.md)
- [Klaro service](../security/klaro.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
