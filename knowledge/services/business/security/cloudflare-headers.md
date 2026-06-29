---
type: service
title: "Cloudflare _headers (security headers)"
description: "Static security-headers via CF Pages `_headers` — ships in oriz-kit"
tags: [security, headers, csp, hsts, cloudflare, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: security-headers-static
provider: cloudflare
free_tier: "Unlimited — included in Cloudflare Pages free tier, no separate sign-up"
swap_cost: low
related:
  - services/infra/hosting/cloudflare-pages
  - services/business/security/securityheaders-com
  - services/business/security/mozilla-observatory
  - security/security-headers-strategy
---

# Cloudflare `_headers`

## Role

Every site under `*.oriz.in` ships a strict security-headers
configuration via a `_headers` file at the project root. Cloudflare
Pages reads the file at deploy time and applies the rules at the
edge — no Worker, no CDN config UI, no per-site secret. The same
preset ships in <!-- TODO: broken link, was [`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md) -->;
every site `imports`/copies it.

## Free tier

- Unlimited — bundled with [Cloudflare Pages](../hosting/cloudflare-pages.md) free tier
- No separate sign-up, no per-request fee
- Edge-applied — adds ~zero latency

## Card / subscription required?

**NO.** Inherits Cloudflare Pages free tier — no card on file.

## What ships in the oriz-kit preset

Locked by the
[security-headers-strategy decision](../../security/security-headers-strategy.md):

```text
/*
  Content-Security-Policy: default-src 'self'; script-src 'self' 'wasm-unsafe-eval' https://challenges.cloudflare.com; style-src 'self' 'unsafe-inline'; img-src 'self' data: https://*.imagekit.io https://*.cloudinary.com; connect-src 'self' https://api.oriz.in https://*.firebaseio.com https://firestore.googleapis.com https://*.knock.app; frame-ancestors 'none'; base-uri 'self'; form-action 'self'
  Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(self), usb=()
  Cross-Origin-Opener-Policy: same-origin
  Cross-Origin-Resource-Policy: same-site
```

Per-site overrides allowed only via the `_headers` file in that
site's repo — the kit ships defaults, sites can extend (never
weaken).

## Verified by CI

Every PR runs against [securityheaders.com](./securityheaders-com.md)
and [Mozilla Observatory](./mozilla-observatory.md). PR fails if the
score drops below A. See
[security-headers-strategy](../../security/security-headers-strategy.md).

## Alternatives

- **Cloudflare Transform Rules** (UI) — per-site clicks, drifts
  silently. Rejected — config-as-code in `_headers` is auditable.
- **Worker middleware** — re-implements what Pages does for free,
  adds latency.
- **Netlify `_headers`** — same syntax, only relevant if we move
  hosts.

## Swap cost

Low — the `_headers` file is portable; Netlify uses the exact same
syntax. Vercel uses `vercel.json` `headers` array — mechanical
translation.

## Why this is our pick

Edge-applied, free, config-as-code, ships once in oriz-kit and
applies family-wide. Pairs with the two CI auditors below to keep
us honest.

## Cross-refs

- [security services index](./index.md)
- [securityheaders.com — CI auditor](./securityheaders-com.md)
- [Mozilla Observatory — CI auditor](./mozilla-observatory.md)
- [Cloudflare Pages — host that reads `_headers`](../hosting/cloudflare-pages.md)
- [Security headers strategy decision](../../security/security-headers-strategy.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
