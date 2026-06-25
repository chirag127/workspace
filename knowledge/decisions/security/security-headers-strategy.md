---
type: decision
title: "Security headers — strict CSP via _headers + dual CI audit"
description: "Every site ships a strict CSP / HSTS preload / Permissions-Policy preset via Cloudflare _headers, sourced from @chirag127/oriz-kit. Every PR is audited by both securityheaders.com and Mozilla Observatory; PR fails if score drops below A."
tags: [decisions, security, headers, csp, hsts]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - services/security/cloudflare-headers
  - services/security/securityheaders-com
  - services/security/mozilla-observatory
  - services/hosting/cloudflare-pages
  - decisions/process/code-quality-stack
---

# Security headers — strict CSP via `_headers` + dual CI audit

## Decision

Every family site ships a **strict security-headers preset** via a
[`_headers` file](../../services/security/cloudflare-headers.md) at
the project root, sourced from `@chirag127/oriz-kit`. Cloudflare
Pages reads the file at deploy and applies the rules at the edge.

Every PR runs **two** auditors in parallel:

1. [securityheaders.com](../../services/security/securityheaders-com.md) — Scott Helme's rubric (headers grade)
2. [Mozilla Observatory](../../services/security/mozilla-observatory.md) — TLS + cookies + redirects + headers (comprehensive)

PR fails if either score drops below A.

## Why

- **Default-deny is the only safe stance.** A strict CSP without
  `unsafe-eval` or wildcard origins is the single most effective
  XSS mitigation; it has to ship by default, not as an opt-in per
  site.
- **Config-as-code via `_headers`** — auditable in git, no
  Cloudflare UI clicks, ships in the kit. Every site copies the
  preset; per-site additions allowed but never weakening.
- **Dual audit catches drift.** securityheaders.com grades headers
  alone; Mozilla Observatory adds TLS + cookies + redirect chains.
  Either alone leaves a category unchecked.
- **Both are free, no card.** Aligns with
  [no-card-on-file](../../rules/interaction/no-card-on-file.md).
- **Layered with the [code-quality stack](../process/code-quality-stack.md)** — same philosophy: defensive
  layering, fail loud, no silent drift.

## The locked preset

The kit's `_headers` template:

```text
/*
  Content-Security-Policy: default-src 'self'; script-src 'self' 'wasm-unsafe-eval' https://challenges.cloudflare.com; style-src 'self' 'unsafe-inline'; img-src 'self' data: https://*.imagekit.io https://*.cloudinary.com; connect-src 'self' https://api.oriz.in https://*.firebaseio.com https://firestore.googleapis.com https://*.knock.app https://vitals.vercel-insights.com; frame-ancestors 'none'; base-uri 'self'; form-action 'self'
  Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(self), usb=()
  Cross-Origin-Opener-Policy: same-origin
  Cross-Origin-Resource-Policy: same-site
```

`connect-src` includes the family's known endpoints:
[`api.oriz.in`](../architecture/compute/api-umbrella-hono-worker.md),
Firestore, [Knock](../../services/push/knock.md), and
[Vercel Speed Insights](../../services/perf/vercel-speed-insights.md).
Per-site additions are allowed but must be reviewed.

## Implications

### Architecture

- `@chirag127/oriz-kit` ships the `_headers` preset under
  `templates/_headers`. Each site's CI either copies the file or
  extends it via per-site `_headers.append`.
- The preset registers HSTS preload (`max-age=63072000` =
  2 years, `includeSubDomains`, `preload`) — **`oriz.in` apex must
  be submitted to <https://hstspreload.org/>** once across the
  family (it covers all subdomains).
- Permissions-Policy whitelist is minimal: only `payment=(self)`
  for Razorpay flows. Camera / mic / geolocation / accelerometer
  are off everywhere — sites that need them flip the relevant
  directive in their per-site `_headers`.

### CI gate

- Per-repo `ci.yml` adds two jobs after the Cloudflare Pages preview
  deploy:
  - `security-headers-grade` — calls securityheaders.com API,
    parses JSON for grade, fails if not `A` or `A+`.
  - `mozilla-observatory` — runs `npx @mdn/mdn-http-observatory`
    against the preview hostname, fails if score < 85.
- API key for securityheaders.com lives in
  [Doppler](../../services/secrets/doppler.md) and syncs to GitHub
  Actions; Mozilla Observatory CLI needs no key.

### What "below A" means

- securityheaders.com grade = A or A+ → pass; any other grade fails.
- Mozilla Observatory score ≥ 85 (= grade A) → pass; below fails.
- Score *drops* — i.e. a PR is blocked only if it makes things
  worse. Pre-existing site state is the floor; PRs cannot weaken
  it. (Lifting all sites to A is a one-time push, not a per-PR
  blocker.)

### What we don't do

- **No `unsafe-eval`** anywhere in CSP. Sites that need eval-style
  patterns (e.g. live MDX preview) sandbox them in an iframe.
- **No `*` wildcard origins** in `connect-src` / `img-src`. Specific
  hosts only.
- **No paid auditors** — Hardenize, Probely, Detectify all paid.
- **No Cloudflare Transform Rules UI** — config-as-code via `_headers`
  is auditable; UI clicks drift silently.
- **No HSTS rollback path** — preload list removal takes weeks; a
  site that breaks HTTPS stays broken. The kit's preset is reviewed
  before family-wide adoption.

## Cross-refs

- [Cloudflare _headers service entry](../../services/security/cloudflare-headers.md)
- [securityheaders.com service entry](../../services/security/securityheaders-com.md)
- [Mozilla Observatory service entry](../../services/security/mozilla-observatory.md)
- [security services index](../../services/security/index.md)
- [Cloudflare Pages — host that reads `_headers`](../../services/hosting/cloudflare-pages.md)
- [Code-quality stack decision](../process/code-quality-stack.md)
- [Per-repo CI workflows decision](../process/per-repo-ci-workflows.md)
- [Multi-provider auth — App Check + reCAPTCHA also gate Firestore](./multi-provider-auth.md)
- [Doppler — secrets sync](../../services/secrets/doppler.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
