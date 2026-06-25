---
type: index
title: "PWA services"
description: "Every site in the family ships as an installable Progressive Web App via @vite-pwa/astro. Native wrappers (Capacitor, Tauri) walked back."
tags: [services, pwa, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# PWA services

Every site in the family is an installable Progressive Web App.
PWA-only — no native wrapper. Decision locked at
[`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md).

| Service | Status | Role | Free tier |
|---|---|---|---|
| [vite-pwa-astro.md](./vite-pwa-astro.md) | active | pwa-builder | MIT npm package, no backend, no quota |

## Why every site

- **Installability** — desktop + mobile users get an app icon
  without a store or signing certificate.
- **Offline survival** — Workbox-generated service worker caches
  the static shell + last-N pages so the site survives transient
  network loss.
- **Faster repeat visits** — pre-cached assets skip the network
  round-trip.
- **Notification + share-target hooks** — the manifest grants
  these without native code.

The cost is one config block per site (the kit ships a preset).

## Walked back

The original Batch 13 over-selection included Capacitor and Tauri
as parallel native-wrapper layers. Both were explicitly walked
back — simplicity over coverage. PWA-only is the floor; native
wrappers stay walked back unless a feature lands that PWA APIs
can't express.

| Stack | Why walked back |
|---|---|
| Capacitor | Native wrapping; Apple Developer Program $99/yr conflicts with [`decisions/monetisation/no-subscriptions-anywhere.md`](../../decisions/monetisation/no-subscriptions-anywhere.md). Re-open only when a hardware/iOS-background-sync need lands. |
| Tauri | Native wrapping (Rust + WebView); deferred until a native-only feature requirement appears. Re-open conditions same as Capacitor. |
| TWA (Trusted Web Activity) | Android-only Play Store wrapper; deferred until Play Store presence is desired. |

PWA-only is the explicit floor: every site installable, no native
build until a native-only feature need arises.

## Cross-refs

- [Distribution + queues locked decision](../../decisions/architecture/distribution-and-queues-locked.md)
- [@vite-pwa/astro service](./vite-pwa-astro.md)
- [Cloudflare Pages for all sites](../../decisions/infrastructure/cloudflare-pages-for-all-sites.md)
- <!-- TODO: broken link, was [oriz-ui split into 5 packages](../../decisions/architecture/oriz-ui-split-into-5-packages.md) -->
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [No subscriptions anywhere](../../decisions/monetisation/no-subscriptions-anywhere.md)
