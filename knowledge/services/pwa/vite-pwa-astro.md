---
type: service
title: "@vite-pwa/astro"
description: "Astro-native PWA integration. Generates manifest.webmanifest, service worker, install prompt, and offline cache at build. Free OSS, no backend, no card."
tags: [services, pwa, astro, vite, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: pwa-builder
provider: vite-pwa
free_tier: "MIT-licensed npm package, no backend, no quota; Workbox-powered service worker generation at astro build"
swap_cost: low
related:
  - services/pwa/index
  - services/hosting/cloudflare-pages
  - decisions/architecture/distribution-and-queues-locked
  - decisions/infrastructure/cloudflare-pages-for-all-sites
  - rules/no-card-on-file
---

# @vite-pwa/astro

## Role

Turns every site in the family into an installable Progressive Web
App at build time. Produces:

- `manifest.webmanifest` (name, icons, theme color, display mode,
  start URL, share target where relevant).
- Workbox-generated service worker (`sw.js`) with offline cache
  strategy.
- `<link rel="manifest">` injection.
- Install-prompt component glue (the kit's `<InstallPrompt />`
  forward reference handles the UX).

Locked as the family-wide PWA layer in
[`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md).

## Free tier

- MIT-licensed npm package.
- No backend, no API, no quota.
- Generates artifacts at `astro build` time, dropped into `dist/`.

## Card / subscription required?

**NO.** Pure build-time tool. No service backend, no account.

## Configuration

```ts
// astro.config.mjs
import AstroPWA from "@vite-pwa/astro";

export default {
  site: "https://blog.oriz.in",
  integrations: [
    AstroPWA({
      registerType: "autoUpdate",
      manifest: {
        name: "oriz-blog",
        short_name: "blog",
        theme_color: "#0b0f17",
        icons: [
          { src: "/icon-192.png", sizes: "192x192", type: "image/png" },
          { src: "/icon-512.png", sizes: "512x512", type: "image/png" },
          { src: "/icon-maskable.png", sizes: "512x512", type: "image/png", purpose: "maskable" },
        ],
      },
      workbox: {
        globPatterns: ["**/*.{js,css,html,svg,png,webp,woff2}"],
        runtimeCaching: [
          {
            urlPattern: /^https:\/\/api\.oriz\.in\//,
            handler: "NetworkFirst",
            options: { cacheName: "api-cache", expiration: { maxAgeSeconds: 86400 } },
          },
        ],
      },
    }),
  ],
};
```

The kit ships a default config preset; sites only override `name` /
`short_name` / icons.

## Alternatives

- Hand-rolled service worker — every site reimplements the same
  Workbox boilerplate.
- `next-pwa` / `nuxt-pwa` — wrong framework. The family is
  Astro-only per
  [`decisions/architecture/oriz-ui-split-into-5-packages.md`](../../decisions/architecture/oriz-ui-split-into-5-packages.md).
- Capacitor / Tauri native wrappers — **walked back** per
  [`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md).
  PWA-only is the explicit floor. Re-open only if a native-only
  feature need arises (e.g. iOS background sync, hardware sensor
  access).

## Swap cost

Low — output is the standard `manifest.webmanifest` + `sw.js`
contract any browser reads. Replacing the integration is one config
swap inside one site repo.

## Why this is our pick

Native to the framework every site already uses. Wraps Workbox so
the offline + caching primitives are battle-tested. MIT, no
backend, no card. Adds installability + offline survival to every
site for the cost of one config block.

## Cross-refs

- [Distribution + queues locked decision](../../decisions/architecture/distribution-and-queues-locked.md)
- [PWA bucket index](./index.md)
- [Cloudflare Pages for all sites](../../decisions/infrastructure/cloudflare-pages-for-all-sites.md)
- [oriz-kit glossary entry](../../glossary/o-r/oriz-kit.md) — `<InstallPrompt />` forward reference
- [No card-on-file rule](../../rules/no-card-on-file.md)
