---
type: index
title: "Infrastructure decisions"
description: "Locked decisions on hosting, DNS, auth, submodule shape, and webhook reliability."
tags: [decisions, infrastructure, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Infrastructure decisions

| Decision | One-line summary |
|---|---|
| [cloudflare-pages-for-all-sites.md](./cloudflare-pages-for-all-sites.md) | Cloudflare Pages free for all 11+ sites; Firebase Hosting dropped |
| [github-pages-mirror-per-site.md](./github-pages-mirror-per-site.md) | Every site builds a static GitHub Pages mirror per §16 |
| [subdomains-under-oriz-in.md](./subdomains-under-oriz-in.md) | Custom-domain strategy is `*.oriz.in` subdomains |
| [firebase-spark-forever.md](./firebase-spark-forever.md) | Never enable Firebase Blaze |
| [chrome-extensions-as-submodules.md](./chrome-extensions-as-submodules.md) | Each extension is its own repo, added as a submodule |
| [extensions-cross-store-publish.md](./extensions-cross-store-publish.md) | Every extension publishes to Chrome + Firefox + Edge |
| [extension-auth-firebase-plus-license-key.md](./extension-auth-firebase-plus-license-key.md) | Firebase Auth primary in extensions, license-key fallback |
| [hookdeck-for-webhook-reliability.md](./hookdeck-for-webhook-reliability.md) | Hookdeck queues Razorpay → Worker, with retries + replay |
| [spaceship-registrar-cloudflare-dns.md](./spaceship-registrar-cloudflare-dns.md) | Spaceship is registrar; Cloudflare hosts DNS + email routing; one Gmail inbox |
