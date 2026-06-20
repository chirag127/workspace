---
type: architecture
title: Hono RPC — type-safe client across sites and extensions
description: Backend exports `type AppType = typeof app`. Frontends consume it via `hc<AppType>` re-exported from @chirag127/api-client. No codegen, no schema files — just a workspace package import.
tags: [architecture, api, hono, rpc, types]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - architecture/api-umbrella-hono-worker
  - architecture/api-routes-structure
  - architecture/the-six-packages
  - architecture/package-isolation-rule
---

# Hono RPC — type-safe client across sites and extensions

## Concept

Hono's `hc<AppType>` ships a type-safe RPC client by reusing the
backend's TypeScript types. No OpenAPI, no codegen, no `.d.ts` files
that drift. Backend changes propagate to every frontend at typecheck
time.

## How it works

- The Worker's `src/index.ts` ends with:
  ```ts
  const app = new Hono()
    .route('/contact', contact)
    .route('/recaptcha', recaptcha)
    // ...
  export type AppType = typeof app
  export default app
  ```
- A workspace package `packages/api-client/` re-exports `hc<AppType>`
  pointed at `https://api.oriz.in`
- Every site and every extension imports from `@chirag127/api-client`
  and gets fully-typed request/response shapes
- Refactoring a route signature on the Worker side breaks `tsc` in
  every consumer at the next CI run, so nothing ships partially-typed

## Why this shape

The alternatives all introduce a second source of truth:
- OpenAPI + codegen needs a generation step that humans forget to run
- Hand-written `.d.ts` drifts from the actual handler
- gRPC / tRPC + transport-specific tooling adds dependencies

Hono's `hc<AppType>` is just TypeScript — the type flows over the
workspace boundary like any other type. It is the lowest-overhead way
to keep 11+ sites in sync with one Worker.

## Cross-refs

- The Worker exporting `AppType` → [api-umbrella-hono-worker.md](api-umbrella-hono-worker.md)
- Where the client package sits in the package matrix → [the-six-packages.md](the-six-packages.md)
- Why packages, not direct imports → [package-isolation-rule.md](package-isolation-rule.md)
