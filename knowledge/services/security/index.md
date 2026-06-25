---
type: index
title: "Security services"
description: "Static security-header config (Cloudflare _headers) plus two complementary CI auditors (securityheaders.com + Mozilla Observatory) plus a two-provider captcha pair (Turnstile + hCaptcha)."
tags: [services, security, headers, audit, captcha, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Security services

The family runs a **strict-headers + double-audit + two-captcha**
pattern:

- **Headers themselves** —
  [Cloudflare `_headers`](./cloudflare-headers.md). Static
  config-as-code, edge-applied, ships in `@chirag127/oriz-kit` as a
  preset every site copies.
- **CI auditor #1** — [securityheaders.com](./securityheaders-com.md).
  Scott Helme's rubric. Headers-focused.
- **CI auditor #2** — [Mozilla Observatory](./mozilla-observatory.md).
  Mozilla's rubric. Headers + TLS + cookies + redirects.
- **Captcha primary** — [Cloudflare Turnstile](./cloudflare-turnstile.md).
  Privacy-friendly, native to the Cloudflare stack, free unlimited.
- **Captcha fallback** — [hCaptcha](./hcaptcha.md). Different
  operator + edge; auto-swapped in by `<Captcha>` when Turnstile is
  blocked by region or network.

Both auditors run on every PR. PR fails if either score drops below
A. The full strategy is locked in
[decisions/security/security-headers-strategy.md](../../decisions/security/security-headers-strategy.md).
The captcha pair is locked in
[decisions/security/captcha-turnstile-plus-hcaptcha.md](../../decisions/security/captcha-turnstile-plus-hcaptcha.md).

| Service | Status | One-line role |
|---|---|---|
| [cloudflare-headers.md](./cloudflare-headers.md) | active | Strict CSP / HSTS preload / Permissions-Policy via `_headers` file |
| [securityheaders.com](./securityheaders-com.md) | active | CI auditor — headers grade rubric |
| [mozilla-observatory.md](./mozilla-observatory.md) | active | CI auditor — comprehensive (TLS + cookies + redirects + headers) |
| [cloudflare-turnstile.md](./cloudflare-turnstile.md) | active | Captcha primary — privacy-friendly, native to Cloudflare stack |
| [hcaptcha.md](./hcaptcha.md) | active | Captcha fallback — different edge, auto-swapped on Turnstile block |
| [klaro.md](./klaro.md) | active | Cookie consent manager (OSS); lazy-loaded only on EU + tracker pages |
| [cloudflare-waf.md](./cloudflare-waf.md) | active | WAF + Bot Fight Mode at the edge — managed ruleset, DDoS, free tier |
| [hono-rate-limit.md](./hono-rate-limit.md) | active | Per-route per-IP rate-limit middleware in api.oriz.in Worker (KV-backed) |

## Why two auditors?

Each grades the same input differently. securityheaders.com is
header-focused; Mozilla Observatory adds TLS + cookies + redirect
chains. Running both means an A on both is unambiguous; running
either alone leaves a category unchecked.

## Why two captchas?

Different operators on different infrastructure means a
Cloudflare-edge incident or a regional / network block on
Turnstile doesn't take public-form submission down with it. The
shared `<Captcha>` component in
<!-- TODO: broken link, was [`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md) --> probes
reachability on mount and swaps providers transparently.

## Anti-bot defense in depth (3 layers)

Locked at
[`decisions/security/anti-bot-defense-in-depth.md`](../../decisions/security/anti-bot-defense-in-depth.md).
Three layers, each at a different stage of the request lifecycle:

1. **Edge / zone-wide** — [Cloudflare WAF + Bot Fight Mode](./cloudflare-waf.md)
   blocks known-bad IPs, common attack patterns, and DDoS before
   anything reaches a Worker.
2. **Form-submit boundary** — [Turnstile + hCaptcha](./cloudflare-turnstile.md)
   pair gates contact / sign-up / comment forms.
3. **API per-route throttle** — [Hono rate-limit middleware](./hono-rate-limit.md)
   in the api.oriz.in Worker throttles per-IP per-route.

All three free, run on existing Cloudflare account, no card.

## Cross-refs

- [Security headers strategy decision](../../decisions/security/security-headers-strategy.md)
- [Captcha decision — Turnstile primary + hCaptcha fallback](../../decisions/security/captcha-turnstile-plus-hcaptcha.md)
- [Anti-bot defense-in-depth decision](../../decisions/security/anti-bot-defense-in-depth.md)
- [Cookie banner policy decision](../../decisions/security/cookie-banner-policy.md)
- [CF Worker quota mitigation playbook](../../decisions/architecture/cf-worker-quota-mitigation.md)
- [Cloudflare Pages — host that reads `_headers`](../hosting/cloudflare-pages.md)
- [App Check — Firestore bot defense](../auth/app-check-firebase.md)
- [reCAPTCHA Enterprise — risk assessments](../auth/recaptcha-enterprise.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [No hardcoded secrets rule](../../rules/security/no-hardcoded-secrets.md)
