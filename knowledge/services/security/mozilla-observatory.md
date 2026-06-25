---
type: service
title: "Mozilla Observatory"
description: "Comprehensive security auditor — headers + TLS + cookies + redirects. Free CLI run on every PR alongside securityheaders.com."
tags: [security, audit, mozilla, ci, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: security-audit-comprehensive
provider: mozilla
free_tier: "Unlimited — free CLI tool (`@mdn/mdn-http-observatory`), free hosted UI, no rate limit on CI usage"
swap_cost: low
related:
  - services/security/cloudflare-headers
  - services/security/securityheaders-com
  - decisions/security/security-headers-strategy
---

# Mozilla Observatory

## Role

Broader security audit than securityheaders.com — alongside header
grading, it checks TLS configuration, redirect chains, cookie
flags, and HTTPS-redirection. Run as a **CI gate** on every PR; PR
fails if Observatory score drops below A (85+).

## Free tier

- Free CLI (`@mdn/mdn-http-observatory` on npm)
- Free hosted UI at <https://observatory.mozilla.org/>
- No rate limit for CI use (the CLI runs locally; no API call
  required)
- Open-source (MPL-2.0) — self-host fallback if Mozilla shuts the
  hosted UI

## Card / subscription required?

**NO.** Mozilla project, no sign-up, no card.

## How CI consumes it

```yaml
- name: Audit (Mozilla Observatory)
  run: |
    npx @mdn/mdn-http-observatory "$PREVIEW_HOST" --format=json > obs.json
    score=$(jq -r '.scan.score' obs.json)
    grade=$(jq -r '.scan.grade' obs.json)
    echo "Observatory: $grade ($score)"
    [ "$score" -ge 85 ] || exit 1
```

`$PREVIEW_HOST` is the Cloudflare Pages preview hostname (no
scheme — Observatory adds its own probes).

## What it checks (beyond headers)

- TLS cipher suites + Forward Secrecy
- HTTPS redirection (`http://` → `https://` chain length)
- HSTS preload eligibility
- Subresource Integrity for inline scripts (warning, not failing)
- Cookie flags (Secure / HttpOnly / SameSite)
- Cross-origin / referrer policies
- Public-Key-Pinning (deprecated; scored neutral)

## Alternatives

- [securityheaders.com](./securityheaders-com.md) — sibling, headers-
  only. We run both.
- Hardenize — paid past 1 domain.
- testssl.sh — TLS-only, not header-aware.
- ssllabs.com — TLS-only, slow scans, no JSON API.

## Swap cost

Low — both Mozilla Observatory and securityheaders.com grade the
same input. Already running both for redundancy; dropping one
preserves the gate.

## Why this is our pick

Broader than securityheaders.com (TLS + redirects + cookies in one
run), free CLI runs in CI without an API key, open-source so no
vendor lock-in. Mozilla's rubric tends to be stricter than
securityheaders.com's — running both means a PR that scores A on
both is unambiguously well-configured.

## Cross-refs

- [security services index](./index.md)
- [Cloudflare _headers — what we're auditing](./cloudflare-headers.md)
- [securityheaders.com — sibling auditor](./securityheaders-com.md)
- [Security headers strategy decision](../../decisions/security/security-headers-strategy.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
