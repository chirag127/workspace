---
type: service
title: "securityheaders.com"
description: "External security-header auditor. Free API run in CI on every PR — fails the build if grade drops below A."
tags: [security, audit, headers, ci, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: security-audit-headers
provider: scott-helme
free_tier: "Unlimited public scans via web UI; free API key for programmatic / CI access"
swap_cost: low
related:
  - services/security/cloudflare-headers
  - services/security/mozilla-observatory
  - decisions/security/security-headers-strategy
---

# securityheaders.com

## Role

External audit of HTTP response security headers — runs Scott
Helme's grading rubric (CSP, HSTS, X-Frame-Options, etc.) and
returns A+ → F. Used as a **CI gate** on every PR: if the grade
drops below A, the PR fails.

## Free tier

- Unlimited public scans via web UI
- Free API key (sign-up email-only) for programmatic / CI access
- JSON output suitable for parsing in GitHub Actions

## Card / subscription required?

**NO.** Email sign-up for an API key. No payment method requested.

## How CI consumes it

The per-site `ci.yml` runs after the Cloudflare Pages preview deploy
lands. A small step posts the preview URL to securityheaders.com's
API and parses the JSON response:

```yaml
- name: Audit security headers (securityheaders.com)
  run: |
    grade=$(curl -s "https://securityheaders.com/?q=$PREVIEW_URL&hide=on&followRedirects=on" \
      -H "x-api-key: $SECURITYHEADERS_API_KEY" \
      -H "Accept: application/json" | jq -r '.grade')
    echo "Grade: $grade"
    case "$grade" in A+|A) echo "ok";; *) exit 1;; esac
```

`SECURITYHEADERS_API_KEY` lives in [Doppler](../secrets/doppler.md)
and syncs to GitHub Actions as a secret.

## What it grades

- CSP presence + strictness (no `unsafe-eval`, no wildcard origins)
- HSTS (`max-age` ≥ 6 months, `includeSubDomains`, `preload`)
- X-Frame-Options or `frame-ancestors`
- X-Content-Type-Options: nosniff
- Referrer-Policy
- Permissions-Policy / Feature-Policy presence
- Cookie flags (Secure, HttpOnly, SameSite)

## Alternatives

- [Mozilla Observatory](./mozilla-observatory.md) — runs alongside
  this; broader checks (TLS, redirects, cookies). We use both.
- Hardenize — paid past 1 domain.
- Self-rolled — re-implements the rubric; not worth it.

## Swap cost

Low — Mozilla Observatory's CLI grades the same headers slightly
differently. Already running both, so dropping one keeps coverage.

## Why this is our pick

Free, well-known industry rubric, simple JSON API, runs in CI in
under 5 seconds. Pairs with Mozilla Observatory for double coverage.

## Cross-refs

- [security services index](./index.md)
- [Cloudflare _headers — what we're auditing](./cloudflare-headers.md)
- [Mozilla Observatory — sibling auditor](./mozilla-observatory.md)
- [Security headers strategy decision](../../decisions/security/security-headers-strategy.md)
- [Doppler — secrets sync](../secrets/doppler.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
