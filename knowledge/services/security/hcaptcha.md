---
type: service
title: "hCaptcha"
description: "Regional fallback CAPTCHA for users / networks where Cloudflare Turnstile is blocked. Free 1M verifications/month, no card."
tags: [security, captcha, hcaptcha, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: captcha-fallback
provider: hcaptcha
free_tier: "1,000,000 verifications/month, unlimited site keys, no card required"
swap_cost: low
related:
  - services/security/cloudflare-turnstile
  - services/security/cloudflare-headers
  - decisions/security/captcha-turnstile-plus-hcaptcha
  - rules/no-card-on-file
---

# hCaptcha

## Role

**Fallback** CAPTCHA — runs when [Cloudflare Turnstile](./cloudflare-turnstile.md)
is blocked by the visitor's network, region, or browser
configuration. The shared
[`<Captcha>` component in `@chirag127/oriz-kit`](../../decisions/security/captcha-turnstile-plus-hcaptcha.md)
performs a one-shot reachability probe against
`challenges.cloudflare.com` on mount; if the probe fails (corporate
proxy, regional block, ad-blocker), it transparently swaps in
hCaptcha. Visitors never see the swap.

Different operator (Intuition Machines, not Cloudflare) on
different infrastructure means a Cloudflare-edge incident doesn't
take both captchas down at once.

## Free tier

- 1,000,000 verifications / month on the **Publisher** free plan
- Unlimited site keys + unlimited domains
- Invisible mode + accessibility mode included free
- No card required at sign-up
- Privacy posture: optional cookie-less mode; complies with EU
  data-handling expectations out of the box

## Card / subscription required?

**NO.** Sign-up is email-only on the Publisher plan. The paid
"Enterprise" tier exists but is irrelevant — 1M/mo is far above
family traffic.

## How sites consume it

```tsx
// @chirag127/oriz-kit/src/HCaptchaWidget.tsx (sketch)
import HCaptcha from '@hcaptcha/react-hcaptcha';

export function HCaptchaWidget({ onToken }: { onToken: (t: string) => void }) {
  return (
    <HCaptcha
      sitekey={import.meta.env.PUBLIC_HCAPTCHA_SITE_KEY}
      onVerify={onToken}
      size="invisible"
    />
  );
}
```

The Worker verifies the token at
`https://api.hcaptcha.com/siteverify`; `HCAPTCHA_SECRET_KEY` lives
in [Doppler](../secrets/doppler.md). The Worker dispatches to the
correct verifier based on which provider issued the token (each
token carries a provider tag from the kit).

## CSP coupling

The family's [`_headers` preset](./cloudflare-headers.md) needs
`script-src` extended with `https://*.hcaptcha.com` to load the
widget. This is the only CSP delta from the Turnstile-only
baseline; the kit ships the extended directive by default since
hCaptcha may load on any visit.

## Alternatives

- [Cloudflare Turnstile](./cloudflare-turnstile.md) — primary; we
  fall back from Turnstile, not the other way around.
- Friendly Captcha — paid past 1K/mo.
- reCAPTCHA v2 — Google fingerprinting; rejected for public-form
  use on privacy grounds.

## Swap cost

Low — same `<Captcha>` component in
[`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md). If hCaptcha
ever loses the no-card stance, the slot can be filled by Friendly
Captcha (paid) or by routing 100% of traffic through Turnstile and
accepting the failure rate in blocked regions.

## Why this is our pick

The most generous free tier among CAPTCHA providers that **don't**
share infrastructure with Cloudflare. 1M verifications/mo is far
above family-scale traffic. Different operator + different
edge means an incident at one provider doesn't take the other
down. No card.

## Cross-refs

- [security services index](./index.md)
- [Cloudflare Turnstile — primary sibling](./cloudflare-turnstile.md)
- [Cloudflare _headers — CSP that allows hCaptcha](./cloudflare-headers.md)
- [Captcha decision — Turnstile primary + hCaptcha fallback](../../decisions/security/captcha-turnstile-plus-hcaptcha.md)
- [Doppler — secrets sync](../secrets/doppler.md)
- [oriz-kit glossary](../../glossary/o-r/oriz-kit.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
