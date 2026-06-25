---
type: service
title: "Cloudflare Workers"
description: "Edge compute for the Hono Worker at api.oriz.in — fails-closed at the free quota."
tags: [cloudflare, edge-compute, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: edge-compute
provider: cloudflare
free_tier: "100,000 requests/day, 10ms CPU/request, 128 MiB memory"
swap_cost: medium
---

# Cloudflare Workers

## Role

The single API umbrella at `api.oriz.in`. A Hono router that fronts
Razorpay webhooks, Firestore admin actions, and any cross-site
operation that needs a server.

## Free tier

- 100,000 requests / day (rolling)
- 10ms CPU time / request
- 128 MiB memory
- Fails-closed at quota — does not auto-bill

## Card / subscription required?

**NO.** The free Workers plan requires only the same Cloudflare
account used for Pages. No payment method needed.

## Alternatives

- Deno Deploy free
- Vercel Edge Functions
- Netlify Edge Functions

## Swap cost

Medium. Hono code is portable but Workers-specific bindings (KV, R2,
D1, Service Bindings) differ from each alternative's equivalents.

## Why this is our pick

Free tier is generous, fails-closed (no surprise bill), and lives in
the same dashboard as Pages, R2, DNS. The Hono router is one binary
serving every site.

## Cross-refs

- [Layer 5 — compute](../../decisions/architecture/general/layer-5-compute.md)
- [API umbrella — Hono Worker](../../decisions/architecture/compute/api-umbrella-hono-worker.md)
- [Cloudflare Pages](../hosting/cloudflare-pages.md)
