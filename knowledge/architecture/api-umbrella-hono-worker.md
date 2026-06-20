---
type: architecture
title: API umbrella — one Hono Worker at api.oriz.in
description: A single Hono Worker (apps/api/) at api.oriz.in serves every site and every extension. Per Cloudflare's own guidance, when logic is shared by more than one app, Pages Functions is the wrong shape.
tags: [architecture, api, hono, cloudflare-workers, umbrella]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - architecture/api-routes-structure
  - architecture/hono-rpc-type-sharing
  - architecture/service-bindings-future
  - architecture/layer-5-compute
  - architecture/master-pointer-as-production-sha
---

# API umbrella — one Hono Worker at api.oriz.in

## Concept

`apps/api/` is the single Hono Worker deployed at `api.oriz.in`. All
11+ sites and all extensions hit it. It is NOT a submodule — it lives
inline in the master `chirag127/oriz` repo so the Worker deploy ships
in lockstep with master pointer bumps.

## How it works

- Lives at `apps/api/` in the master repo (inline, not a submodule)
- `wrangler.jsonc` declares `custom_domain: api.oriz.in`
- Hono app exports `type AppType = typeof app` from `src/index.ts`
- Routes split into per-concern folders under `src/routes/` — see
  [api-routes-structure.md](api-routes-structure.md)
- Frontends consume it via the typed `hc<AppType>` client re-exported
  from `@chirag127/api-client` — see [hono-rpc-type-sharing.md](hono-rpc-type-sharing.md)
- Edge integrations that work inside the Worker:
  - Firestore: `firebase-rest-firestore` (REST + service-account JWT).
    Do NOT use `firebase-admin` — it requires gRPC, only partially
    supported by `workerd`.
  - Turso: `@tursodatabase/serverless` (preferred 2026)
  - Firebase Auth verify: `firebase-auth-cloudflare-workers` + `@hono/firebase-auth`
  - reCAPTCHA verify: plain `fetch` to Google's verify endpoint
  - Web3Forms: browser only (server-side requires paid plan + IP whitelist)

## Why this shape

Cloudflare's own docs: "if the logic is used by more than one
application, Pages Functions would not be a good use case". Concretely:
- Pages Functions can't use Cloudflare Secrets Store
- Splitting the API across 11 sites' Functions = 11× the duplication of
  auth / CORS / reCAPTCHA verification
- 100K req/day quota is per-account anyway, so splitting doesn't help
- Service Bindings (zero-cost zero-network-hop Worker→Worker RPC) keep
  the door open to splitting off privileged Workers later — see
  [service-bindings-future.md](service-bindings-future.md)

## Cross-refs

- Routes layout → [api-routes-structure.md](api-routes-structure.md)
- Type sharing → [hono-rpc-type-sharing.md](hono-rpc-type-sharing.md)
- Why the Worker ships with master not its own submodule → [master-pointer-as-production-sha.md](master-pointer-as-production-sha.md)
