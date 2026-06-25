---
type: service
title: "TinyURL"
description: "Truly free, unlimited, no-auth URL shortener. Tier 2 fallback in the family's three-tier short-link stack — used when the link points outside oriz.in or s.oriz.in is unreachable."
tags: [short-link, tinyurl, fallback, free, no-auth]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: url-shortener-fallback
provider: tinyurl
free_tier: "Unlimited shortens via the public api-create.php endpoint. No account, no API key, no documented rate limit at family scale."
swap_cost: low
related:
  - services/short-link/cloudflare-worker
  - services/short-link/github-gist-redirect
  - decisions/architecture/url-shortener-mitigation-tiers
  - rules/no-card-on-file
  - rules/no-subscriptions
---

# TinyURL

## Role

**Tier 2 fallback** in the family's three-tier URL-shortener stack
(see
[`decisions/architecture/url-shortener-mitigation-tiers.md`](../../decisions/architecture/url-shortener-mitigation-tiers.md)).
Tier 1 is the self-hosted
[s.oriz.in Cloudflare Worker](./cloudflare-worker.md). TinyURL fills
two specific gaps:

1. **Cross-domain mints** — when the destination is NOT a family URL
   (e.g. a tweet that points at a third-party article), branding the
   short link as `s.oriz.in/<slug>` would mislead. TinyURL's
   `tinyurl.com/<slug>` is neutral.
2. **Outage fallback** — if `s.oriz.in` Worker is unreachable
   (Cloudflare Workers down — historically 4-nines+ uptime, so this
   is rare), TinyURL keeps the family's mint capability online.

## Free tier

- **Unlimited shortens** via the public endpoint.
- **No account.** No API key. No card. No signup wall.
- Endpoint: `https://tinyurl.com/api-create.php?url=<urlencoded-target>`
  — returns the short URL as a plain-text response body.

Example:

```bash
curl 'https://tinyurl.com/api-create.php?url=https%3A%2F%2Fblog.oriz.in%2Fa-post'
# → https://tinyurl.com/2abc34d
```

The `https://tinyurl.com/app/dashboard` paid product (custom slugs,
analytics, branded domains) is **not used by the family** — that
tier requires a subscription, which violates
[`rules/infrastructure/no-subscriptions.md`](../../rules/infrastructure/no-subscriptions.md).

## Card / subscription required?

**NO.** The public `api-create.php` endpoint is free and
key-less. Card-on-file is not requested. No subscription nag.

## How the family consumes it

From the [`api.oriz.in` Hono Worker](../../decisions/architecture/hono-worker-api-umbrella.md),
server-to-server only:

```ts
async function tinyUrl(target: string): Promise<string> {
  const r = await fetch(
    `https://tinyurl.com/api-create.php?url=${encodeURIComponent(target)}`,
    { headers: { 'User-Agent': 'oriz-omnipost/1.0' } }
  );
  return (await r.text()).trim();
}
```

Server-side keeps `tinyurl.com` out of the family's CSP `connect-src`
on every page that ships the
[security headers preset](../../decisions/security/security-headers-strategy.md).

## Alternatives

- **is.gd** — free, no account, similar shape; rejected as Tier 2
  because TinyURL's brand recognition + multi-decade uptime is
  better, and the API contract is identical complexity.
- **Bit.ly free** — 100 links/month soft cap, requires account.
  Rejected.
- **Rebrandly free** — 250 links/month, requires account. Rejected.
- **T.ly free** — 30 links/month. Rejected.
- **`v.gd`** — `is.gd`'s sister service for verbose/transparent
  short URLs. Acceptable swap target.

## Swap cost

**Low.** One helper function in the
[`api.oriz.in`](../../decisions/architecture/hono-worker-api-umbrella.md)
Worker. Swapping to `is.gd` or `v.gd` is a URL change.

## Why this is our pick (for Tier 2)

- **No card, no subscription, no account** — the only Tier 2 candidate
  that requires literally zero configuration.
- **Multi-decade uptime track record** — TinyURL has run since 2002.
- **Plain-text response** — no JSON parser needed, error handling is
  trivially "did we get back a URL or not".
- **Brand-neutral** — appropriate for non-oriz.in destinations.
- **Documented as Tier 2, not Tier 1** — the decision is about
  WHEN to use it, not WHETHER. Tier 1 stays default.

## Cross-refs

- [Three-tier URL shortener stack decision](../../decisions/architecture/url-shortener-mitigation-tiers.md)
- [Tier 1 — s.oriz.in CF Worker](./cloudflare-worker.md)
- [Tier 3 — GitHub Gist redirect](./github-gist-redirect.md)
- [URL shortener quota mitigation (Tier 1 detail)](../../decisions/architecture/url-shortener-quota-mitigation.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [No subscriptions rule](../../rules/infrastructure/no-subscriptions.md)
