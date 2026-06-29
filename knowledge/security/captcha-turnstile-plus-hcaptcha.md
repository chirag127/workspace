---
type: decision
title: "Captcha — Turnstile primary + hCaptcha fallback (both, regional auto-detect)"
description: Turnstile primary, hCaptcha fallback. Single Captcha component
tags: [decisions, security, captcha, turnstile, hcaptcha]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - services/business/security/cloudflare-turnstile
  - services/business/security/hcaptcha
  - services/business/security/cloudflare-headers
  - services/business/auth/recaptcha-enterprise
  - security/multi-provider-auth
---

# Captcha — Turnstile primary + hCaptcha fallback (both, regional auto-detect)

## Decision

Every public POST surface across `*.oriz.in` (contact forms,
sign-up, comment, support) goes through **one** captcha component
shipped from <!-- TODO: broken link, was [`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md) -->:
`<Captcha>`. The component:

1. Probes `challenges.cloudflare.com` on mount.
2. If reachable ? renders [Cloudflare Turnstile](../../services/business/security/cloudflare-turnstile.md) (the **primary**).
3. If blocked (corporate proxy / region / ad-blocker / Cloudflare-edge incident) ? renders [hCaptcha](../../services/business/security/hcaptcha.md) (the **fallback**).
4. Tags the issued token with its provider so the Worker dispatches to the correct verify endpoint.

Both are free, no card. Turnstile carries the bulk; hCaptcha is the
documented swap target the kit reaches for automatically.

## Why

- **Two providers, two edges, two operators.** A Turnstile-only
  posture leaves us captcha-down whenever Cloudflare's challenge
  edge has an incident; a hCaptcha-only posture re-introduces a
  vendor without the same-stack benefits. Running both keeps the
  primary-on-failure pattern the family uses for image CDN, status
  pages, and DNS resolvers.
- **No paid tier touched.** Turnstile is unlimited free; hCaptcha
  Publisher is 1M/mo free — well above family traffic.
- **Regional / network failure modes are real.** Turnstile is
  occasionally blocked by corporate proxies and a few national
  network filters; hCaptcha's different edge keeps the form
  submittable.
- **One component, one decision, no per-site work.** Sites import
  `<Captcha>` and never know which provider issued the token.

## Implications

### Architecture

- New component
  `@chirag127/oriz-kit/src/Captcha.tsx` exports `<Captcha>` and the
  matching server-side `verifyCaptchaToken(token, provider)` helper.
- Worker verify route accepts `{ token, provider: 'turnstile' | 'hcaptcha' }`
  and POSTs to the matching `siteverify` endpoint with the right
  secret key.
- Two new secrets in [Doppler](../../services/business/secrets/doppler.md):
  `TURNSTILE_SECRET_KEY` and `HCAPTCHA_SECRET_KEY`. Two new public
  site keys: `PUBLIC_TURNSTILE_SITE_KEY`, `PUBLIC_HCAPTCHA_SITE_KEY`.
- The probe runs **once** per session and caches the result in
  `sessionStorage` to avoid per-mount latency. The cache key flips
  on a 24h TTL.

### CSP

The family's [`_headers` preset](../../services/business/security/cloudflare-headers.md)
must allow:

```text
script-src ... https://challenges.cloudflare.com https://*.hcaptcha.com
connect-src ... https://challenges.cloudflare.com https://*.hcaptcha.com
frame-src https://challenges.cloudflare.com https://*.hcaptcha.com
```

This is the CSP delta this decision introduces; the kit ships the
extended directive by default.

### Coexistence with App Check + reCAPTCHA Enterprise

[App Check](../../services/business/auth/app-check-firebase.md) +
[reCAPTCHA Enterprise](../../services/business/auth/recaptcha-enterprise.md)
continue to gate Firestore writes (provider-agnostic, server-side
attestation). The Turnstile + hCaptcha pair gates the **public
Worker API** — different attack surfaces, different providers, no
overlap. Bot defense remains layered.

### What we don't do

- **No reCAPTCHA v2/v3 on public forms** — Google fingerprinting
  cookies fight the family's privacy-friendly analytics posture and
  add a render-blocking script to every page.
- **No honeypot-only or proof-of-work-only captcha** — leaks under
  modest bot pressure; documented only as last-ditch escape hatch.
- **No paid Friendly Captcha / Cap.js** — adequately covered by the
  free tiers above.
- **No per-site overrides** that disable the captcha — feature
  flags can swap providers but cannot turn off captcha on a public
  POST surface.

## Cross-refs

- [Cloudflare Turnstile service entry](../../services/business/security/cloudflare-turnstile.md)
- [hCaptcha service entry](../../services/business/security/hcaptcha.md)
- [security services index](../../services/business/security/index.md)
- [Cloudflare _headers — CSP coupling](../../services/business/security/cloudflare-headers.md)
- [App Check — Firestore bot defense, complementary layer](../../services/business/auth/app-check-firebase.md)
- [reCAPTCHA Enterprise — App Check provider, different role](../../services/business/auth/recaptcha-enterprise.md)
- [Multi-provider auth decision](./multi-provider-auth.md)
- [Doppler — secrets source-of-truth](../../services/business/secrets/doppler.md)
- <!-- TODO: broken link, was [oriz-kit glossary](../../glossary/o-r/oriz-kit.md) -->
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
