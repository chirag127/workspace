---
type: service
title: "UTM tracking"
description: "Marketing attribution via UTM query parameters on every outbound link. Captured by GA4 + PostHog. Free, no service, no extra tools."
tags: [analytics, marketing, attribution, utm, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: marketing-attribution
provider: convention-utm-spec
free_tier: "Free convention; no service, no quota. Captured by existing analytics services."
swap_cost: low
related:
  - services/analytics/posthog
  - services/analytics/cloudflare-web-analytics
  - services/analytics/microsoft-clarity
  - decisions/architecture/utm-attribution-strategy
---

# UTM tracking

## Role

The family's only marketing-attribution mechanism. UTM query
parameters are appended to every outbound campaign / share / referral
link; on the destination site, the `utm_*` params land in the URL
querystring, are read by [PostHog](./posthog.md) (and Google
Analytics 4 if added later) as referral-source dimensions, and then
dropped from the URL after the first pageview event so the canonical
path stays clean.

No paid attribution tool, no SaaS click-tracker, no bounce-redirect
domain — UTMs ride on the real link, the real analytics service
captures them.

## Free tier

- Free convention — no service to sign up for
- Capture cost is borne by [PostHog](./posthog.md) (1M events / mo
  free) and [Cloudflare Web Analytics](./cloudflare-web-analytics.md)
  (free)

## Card / subscription required?

**NO.** It's a URL convention.

## Standard UTM keys (the only five we use)

| Param | Required? | Meaning | Example |
|---|---|---|---|
| `utm_source` | required | Where the link is | `twitter`, `dev-to`, `newsletter`, `oriz-extension-foo` |
| `utm_medium` | required | What kind of link | `social`, `email`, `cross-post`, `referral`, `cpc` |
| `utm_campaign` | required | Why we shipped this | `2026-q2-launch`, `oriz-finance-beta`, `weekly-2026-06-20` |
| `utm_term` | optional | Paid keywords (rare for us) | `personal-finance` |
| `utm_content` | optional | A/B variant or link position | `header`, `footer-cta`, `variant-b` |

Values are kebab-case, lower-case, ASCII only. No spaces. No
underscores in values (param names use underscores per spec). No
PII — never an email or user ID.

## `<UtmLink>` helper in oriz-kit

`@chirag127/oriz-kit` exports a `<UtmLink>` component + a
`buildUtmUrl()` helper that enforce the convention at compile time:

```tsx
import { UtmLink } from "@chirag127/oriz-kit";

<UtmLink
  href="https://oriz.in/finance"
  source="twitter"
  medium="social"
  campaign="2026-q2-launch"
  content="thread-1"
>
  Try oriz-finance
</UtmLink>;
// → renders <a href="https://oriz.in/finance?utm_source=twitter&utm_medium=social&utm_campaign=2026-q2-launch&utm_content=thread-1">
```

`buildUtmUrl()` is the same logic for non-React contexts (CLI
scripts, omnipost adapters, Worker-side replies).

## Capture pipeline

1. Visitor lands on `*.oriz.in/...?utm_source=...&utm_medium=...`
2. PostHog `$pageview` event captures all `utm_*` params as event
   properties.
3. Cloudflare Web Analytics records the referrer + path (UTMs are
   visible inline since CFWA reads the full URL).
4. A small client script in `oriz-kit` rewrites
   `window.history.replaceState` to drop `utm_*` from the URL bar
   after the first event, so the canonical path is what's bookmarked
   / shared next.

## Alternatives

- Bitly / Rebrandly — paid past tiny tier, adds redirect hop
- Branch.io — overkill for our scale, paid past trial
- Custom click-tracker subdomain — adds latency + a service to
  maintain
- No attribution at all — common but blind to which channels work

## Swap cost

Low — UTM is a URL convention. If we ever swap PostHog for another
product analytics, the new tool also reads `utm_*` (every analytics
tool does).

## Why this is our pick

- Free, universal, captured by tools we already pay nothing for.
- No card, no quota, no extra service.
- Compatible with any future analytics swap.
- The `<UtmLink>` helper enforces the naming convention so attribution
  data stays clean automatically.

## Cross-refs

- [UTM attribution strategy decision](../../decisions/architecture/utm-attribution-strategy.md)
- [PostHog](./posthog.md) — primary capture
- [Cloudflare Web Analytics](./cloudflare-web-analytics.md) — secondary capture
- [Analytics services index](./index.md)
- <!-- TODO: broken link, was [oriz-kit glossary](../../glossary/o-r/oriz-kit.md) --> — `<UtmLink>` helper lives here
- [Cross-post engine](../../decisions/architecture/cross-post-engine.md) — omnipost adapters auto-tag cross-posts with `utm_source=<platform>&utm_medium=cross-post`
