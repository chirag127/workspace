---
type: index
title: "Dev-tools services"
description: "Local development substrates — Wrangler for Workers, Astro dev for sites, Cloudflare Tunnel for webhook testing. All free, no card, all native to the existing Cloudflare stack."
tags: [services, dev-tools, index, wrangler, cloudflare-tunnel]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Dev-tools services

Local development substrates that the family uses to build,
run, and expose work-in-progress before deploy. Locked decision:
[`decisions/architecture/local-dev-tunneling-cf-tunnel`](../../decisions/architecture/local-dev-tunneling-cf-tunnel.md).

Three substrates picked by surface — Wrangler for Cloudflare
Workers, Astro dev (built into every site repo, no separate
service file) for sites, Cloudflare Tunnel for exposing
`localhost` on a persistent `*.oriz.in` hostname for webhook
testing.

## Active picks

| Service | Status | Role | Free tier |
|---|---|---|---|
| [wrangler.md](./wrangler.md) | active | CLI for Worker local + remote dev + deploy | Unlimited as part of CF free Workers plan |
| [cloudflare-tunnel.md](./cloudflare-tunnel.md) | active | Public hostname tunnel for webhook testing | Unlimited tunnels + bandwidth on CF account |

Astro dev is the third leg of the trio — it ships with every
site's `pnpm dev` script, so it doesn't have a service file
of its own (no third-party surface to track).

## Per-session local dev shape

```bash
# Terminal 1 — Worker
pnpm wrangler dev --port 8787

# Terminal 2 — Site (one of the 11)
pnpm dev   # Astro on :3000

# Terminal 3 — public hostname pointing at one of the above
cloudflared tunnel run --url http://localhost:8787 dev-oriz
# now https://dev.oriz.in tunnels to localhost:8787
```

## Webhook testing surfaces

- **[Razorpay](../payment/razorpay.md)** — point dashboard
  webhook at `https://dev.oriz.in/webhooks/razorpay`; production
  goes through [Hookdeck](../tooling/hookdeck.md) per
  [`hookdeck-for-webhook-reliability`](../../decisions/infrastructure/hookdeck-for-webhook-reliability.md).
- **GitHub** webhooks (PR-checks / push events for
  [`oriz-omnipost`](../../glossary/o-r/omnipost.md)).
- **Bluesky AT Protocol firehose** — for the
  [`lifestream-federation`](../../decisions/architecture/lifestream-federation.md)
  consumer.
- **EmailOctopus / Buttondown** webhooks for newsletter signup
  acknowledgements.

## Why all three

- **Wrangler** — only CLI with first-class Cloudflare Worker
  runtime parity (workerd local, real edge remote).
- **Astro dev** — Vite-native HMR + MDX + Astro plugins; same
  build path as production deploy.
- **Cloudflare Tunnel** — persistent `*.oriz.in` hostname,
  free, no card, no anonymous-session TTL. ngrok rejected.

All three free, all three CF-native (or Astro-native, sharing
the same `pnpm` toolchain), no new vendor surface, no card.

## Cross-refs

- [Local dev tunneling decision](../../decisions/architecture/local-dev-tunneling-cf-tunnel.md)
- [Hono Worker API umbrella decision](../../decisions/architecture/hono-worker-api-umbrella.md)
- [Cloudflare Pages for all sites](../../decisions/infrastructure/cloudflare-pages-for-all-sites.md)
- [Hookdeck — production webhook ingress](../tooling/hookdeck.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
- [No subscriptions rule](../../rules/no-subscriptions.md)
