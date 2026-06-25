---
type: index
title: "Security decisions"
description: "Locked decisions about auth providers, secrets management, bot defense, and security posture across the oriz family."
tags: [decisions, security, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Security decisions

| Decision | One-line summary |
|---|---|
| [multi-provider-auth.md](./multi-provider-auth.md) | 6-provider Firebase Auth stack: Email link + Google + GitHub + Anonymous + Microsoft + Passkeys; Apple deferred |
| [secrets-management-doppler.md](./secrets-management-doppler.md) | Doppler is the single source of truth for secrets; GitHub Secrets / Cloudflare / Firebase are runtime mirrors synced from it |
| [security-headers-strategy.md](./security-headers-strategy.md) | Strict CSP / HSTS preload / Permissions-Policy via Cloudflare `_headers`; every PR audited by securityheaders.com + Mozilla Observatory; PR fails below A |
| [captcha-turnstile-plus-hcaptcha.md](./captcha-turnstile-plus-hcaptcha.md) | Cloudflare Turnstile primary + hCaptcha fallback; single `<Captcha>` component in oriz-kit auto-swaps on regional / network block; both free, no card |
| [cookie-banner-policy.md](./cookie-banner-policy.md) | No banner by default — Cloudflare Web Analytics is cookie-less; Klaro lazy-loaded only when (a) page loads cookie-issuing tracker AND (b) visitor is in EU/UK per CF-IPCountry |
| [consent-management-multi-category.md](./consent-management-multi-category.md) | Klaro 5-category × N-services config + GA4 Consent Mode v2 + geo-routed defaults (EU default-DENIED, US/CA default-ACCEPTED honouring Sec-GPC, ROW no banner) + lazy-load Klaro itself + cookie-less defaults |
| [anti-bot-defense-in-depth.md](./anti-bot-defense-in-depth.md) | Three-layer anti-bot defense: Cloudflare WAF + Bot Fight Mode (edge) + Turnstile/hCaptcha (form-submit) + Hono rate-limit middleware (API per-route per-IP); all three free, no card |
| [env-and-secrets-single-source.md](./env-and-secrets-single-source.md) | Two-track env management: Track A `.env.example` synced from master `templates/.env.example` to every repo (CI fails on drift); Track B GitHub Actions secrets set ONCE at `chirag127` org level (`--visibility all`). Doppler stays upstream source of truth |

## Cross-refs

- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [No hardcoded secrets rule](../../rules/security/no-hardcoded-secrets.md)
- [Secrets handling policy](../policy/secrets-handling.md)
- [Rotate leaked secret runbook](../../runbooks/security/rotate-leaked-secret.md)
