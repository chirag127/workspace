---
type: glossary
title: "Hono RPC"
description: "The type-safe API client pattern: hc<AppType> from @hono/client."
tags: [glossary, hono, api, types]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Hono RPC

## Definition

Hono RPC is the type-safe client pattern where the backend exports
`type AppType = typeof app` and frontends instantiate
`hc<AppType>(url)` from `@hono/client` — getting full type inference
on every route, no codegen and no schema files.

## Expanded

The family's single Hono Worker at `apps/api/` exports `AppType`
through the `@chirag127/api-client` workspace package, which
re-exports `hc<AppType>`. All 11+ sites and every Chrome extension
import the same client; route paths, params, request bodies, and
response shapes are all type-checked at consumer build time.

This is why the API is one Worker rather than per-site Pages
Functions: type inference flows through one source of truth, and
splitting it would require schema files (or codegen) to bridge
boundaries.

## See also

- [package-isolation](../o-r/package-isolation.md)
