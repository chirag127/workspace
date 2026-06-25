---
type: service
title: "Cloudflare Turnstile"
description: "Privacy-friendly CAPTCHA replacement, native to the Cloudflare stack. Free unlimited, no card. Family's primary captcha."
tags: [security, captcha, cloudflare, turnstile, privacy, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: captcha-primary
provider: cloudflare
free_tier: "Unlimited — included in Cloudflare free plan, no separate sign-up, no per-request fee"
swap_cost: low
related:
  - services/security/hcaptcha
  - services/security/cloudflare-headers
  - services/auth/recaptcha-enterprise
  - decisions/security/captcha-turnstile-plus-hcaptcha
  - rules/no-card-on-file
---

# Cloudflare Turnstile

## Role

The family's **primary** CAPTCHA — gates contact forms, sign-up
flows, comment boxes, and any other unauthenticated POST surface
across `*.oriz.in`. Renders as an invisible / non-interactive
challenge in 95%+ of cases; falls back to a managed challenge only
when the visitor's risk score warrants it.

Pairs with [hCaptcha](./hcaptcha.md) as a regional fallback —
the [`<Captcha>` component in `@chirag127/oriz-kit`](../../decisions/security/captcha-turnstile-plus-hcaptcha.md)
auto-detects regional / network blocks and swaps Turnstile for
hCaptcha when needed. App Check + reCAPTCHA Enterprise still front
Firestore writes; Turnstile guards the public Worker API.

## Free tier

- Unlimited site keys, unlimited domains
- Unlimited verify-API calls (no per-request fee)
- Invisible / managed / non-interactive widget modes
- Privacy-friendly — no fingerprinting cookies, no cross-site
  identifiers; aligns with the family's analytics posture
- Included in the Cloudflare free plan; no card on the account

## Card / subscription required?

**NO.** Inherits the Cloudflare free plan — the same account hosts
[Cloudflare Pages](../hosting/cloudflare-pages.md),
[Workers](../compute/cloudflare-workers.md), and the Turnstile
dashboard.

## How CI / sites consume it

```tsx
// @chirag127/oriz-kit/src/Captcha.tsx (sketch)
import { Turnstile } from '@marsidev/react-turnstile';
import { useRegionalFallback } from './region';

export function Captcha({ onToken }: { onToken: (t: string) => void }) {
  const useHcaptcha = useRegionalFallback();   // see hcaptcha.md
  if (useHcaptcha) return <HCaptchaWidget onToken={onToken} />;
  return (
    <Turnstile
      siteKey={import.meta.env.PUBLIC_TURNSTILE_SITE_KEY}
      onSuccess={onToken}
    />
  );
}
```

The Worker verifies the token server-side via
`https://challenges.cloudflare.com/turnstile/v0/siteverify` before
accepting the form payload. `TURNSTILE_SECRET_KEY` lives in
[Doppler](../secrets/doppler.md) and syncs to the Worker.

## CSP coupling

The family's [`_headers` preset](./cloudflare-headers.md) already
allows `script-src https://challenges.cloudflare.com` so the
widget loads without a per-site CSP exception.

## Alternatives

- [hCaptcha](./hcaptcha.md) — regional fallback (we run **both**, see
  the [decision](../../decisions/security/captcha-turnstile-plus-hcaptcha.md)).
- [reCAPTCHA Enterprise](../auth/recaptcha-enterprise.md) — already
  in the stack as the App Check provider (Firestore-side); not used
  on public forms because v3 token quality requires the Google
  bundle on every page (privacy + perf cost).
- Friendly Captcha — paid past 1K/mo.
- Self-rolled honeypot / proof-of-work — leaks under modest bot
  pressure; documented as a last-ditch fallback only.

## Swap cost

Low — the `<Captcha>` component in
<!-- TODO: broken link, was [`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md) --> is the only
import surface. Swapping providers means re-implementing the
component body; every site picks up the change on the next kit
release.

## Why this is our pick

Same edge as Pages + Workers + the rest of the stack — no extra
vendor, no extra account, no extra card surface. Privacy-friendly
by default (no PII fingerprinting), free unlimited, invisible in
the common case so it doesn't hurt UX. The CSP allow-list already
covers it.

## Cross-refs

- [security services index](./index.md)
- [hCaptcha — fallback sibling](./hcaptcha.md)
- [Cloudflare _headers — CSP that allows challenges.cloudflare.com](./cloudflare-headers.md)
- [reCAPTCHA Enterprise — App Check provider, different role](../auth/recaptcha-enterprise.md)
- [Captcha decision — Turnstile primary + hCaptcha fallback](../../decisions/security/captcha-turnstile-plus-hcaptcha.md)
- [Doppler — secrets sync source-of-truth](../secrets/doppler.md)
- <!-- TODO: broken link, was [oriz-kit glossary](../../glossary/o-r/oriz-kit.md) -->
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
