---
type: service
title: "Cloudflare Tunnel (cloudflared)"
description: "Free Cloudflare-native local-to-public tunnel. Exposes localhost on a persistent *.oriz.in hostname for webhook testing during development. No card, no quota cliff, no anonymous-session TTL."
tags: [services, dev-tools, tunnel, cloudflare, webhook-testing, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: dev-tunnel
provider: cloudflare
free_tier: "Unlimited tunnels per account, persistent hostnames bound to any zone on the account, unlimited bandwidth + connections for personal / dev use"
swap_cost: low
related:
  - decisions/architecture/local-dev-tunneling-cf-tunnel
  - services/dev-tools/wrangler
  - rules/no-card-on-file
---

# Cloudflare Tunnel (cloudflared)

## Role

Exposes a `localhost:<port>` server on the user's machine to a
persistent **public `*.oriz.in` hostname** so that external
webhook senders ([Razorpay](../payment/razorpay.md), GitHub,
Bluesky AT Protocol firehose, EmailOctopus, etc.) can reach
the in-flight Worker / site during development.

Picked over ngrok / localtunnel / serveo on free-tier persistent
hostname + same-vendor + zero-card grounds — see
[`decisions/architecture/local-dev-tunneling-cf-tunnel`](../../decisions/architecture/local-dev-tunneling-cf-tunnel.md).

## Free tier

- **Unlimited tunnels** per Cloudflare account
- **Persistent hostnames** bound to any zone on the account
  (`dev.oriz.in`, `dev-blog.oriz.in`, etc.) via
  `cloudflared tunnel route dns`
- **Unlimited bandwidth + connections** for personal / dev use
- **No anonymous-session TTL** — `cloudflared tunnel run dev-oriz`
  survives laptop reboots; reconnects automatically after
  network blips
- **Cross-platform** binary: Windows (winget / scoop / direct
  download), macOS (brew), Linux (apt / yum / direct), Docker

## Card / subscription required?

**NO.** Free as part of any Cloudflare account. The family
already has a Cloudflare account for
[Cloudflare Pages](../../decisions/infrastructure/cloudflare-pages-for-all-sites.md),
[Workers](../compute/cloudflare-workers.md),
[DNS](../domain/cloudflare-dns.md),
[Email Routing](../domain/cloudflare-email-routing.md),
and [WAF](../security/cloudflare-waf.md) — `cloudflared` adds
zero new vendor surface.

## Use shape

```bash
# One-time setup per developer machine
winget install cloudflare.cloudflared          # Windows
brew install cloudflared                        # macOS
cloudflared tunnel login                        # browser-auths into the CF account
cloudflared tunnel create dev-oriz              # mints tunnel UUID + creds.json
cloudflared tunnel route dns dev-oriz dev.oriz.in   # binds hostname

# Per-session — point dev.oriz.in at whichever local port
cloudflared tunnel run --url http://localhost:8787 dev-oriz
```

Or via `~/.cloudflared/config.yml` for multi-route ingress:

```yaml
tunnel: dev-oriz
credentials-file: ~/.cloudflared/<UUID>.json
ingress:
  - hostname: dev.oriz.in
    service: http://localhost:8787    # Worker dev
  - hostname: dev-blog.oriz.in
    service: http://localhost:3000    # Astro site dev
  - service: http_status:404
```

`cloudflared tunnel run dev-oriz` then routes both hostnames in
parallel.

## Why this is our pick

- **Same vendor as the rest of the stack** — Cloudflare account
  already exists for Pages / Workers / DNS / Email / WAF; one
  more daemon, no new vendor surface.
- **Free + no card** — fits
  [`rules/no-card-on-file`](../../rules/interaction/no-card-on-file.md) and
  [`rules/no-subscriptions`](../../rules/infrastructure/no-subscriptions.md).
- **Persistent hostnames** — `dev.oriz.in` survives laptop
  reboots, network changes, and IP changes. ngrok's free tier
  rotates hostnames every session, forcing webhook
  re-registration every dev day.
- **No anonymous-session TTL.** Sessions are bound to the
  account-credentials file, not throttled.
- **CDN-edge encryption** — traffic flows over Cloudflare's
  edge to the local daemon; no ngrok-style public-tunnel
  inspection layer.
- **OSS** — `cloudflared` source at
  [`cloudflare/cloudflared`](https://github.com/cloudflare/cloudflared);
  Apache-2.0.

## Alternatives

- **ngrok** — free tier rotates hostname every session;
  persistent hostnames require paid plan + card. Anonymous use
  throttled. Rejected per
  [`local-dev-tunneling-cf-tunnel`](../../decisions/architecture/local-dev-tunneling-cf-tunnel.md).
- **localtunnel** — random `loca.lt` subdomain, no `*.oriz.in`
  binding, OSS but unmaintained.
- **serveo** — SSH-tunnel-shaped; no `*.oriz.in` binding;
  reliability uneven.
- **bore** / **frp** / **pagekite** — self-host or paid past
  tiny envelope; the family runs only managed serverless.
- **Tailscale Funnel** — fits internal collaboration (receiving
  party needs Tailscale installed); doesn't fit public-internet
  webhook senders.

## Swap cost

Low — `cloudflared` is one binary + one config file. Swapping
to a hypothetical alternative is changing the `start` script
in each repo's `package.json`. Webhook URL re-registration
cost depends on the sender (Razorpay UI, GitHub repo settings)
but is a one-time per-sender lift.

## Quota / failure modes

- **No request quota** for personal / dev use — Cloudflare's
  free Tunnel tier doesn't cap bandwidth or connections.
- **Daemon crash** — `cloudflared` restarts; tunnel UUID and
  DNS binding are durable on the CF side.
- **Account-level limits** — large numbers of named tunnels
  (>1000) may attract a soft cap; family scale uses one
  named tunnel per developer machine.
- **Production traffic stays off tunnels** — production hits
  Cloudflare's edge directly via Pages / Workers; tunnels are
  exclusively a local-dev surface.

## Security posture

- Credentials file (`~/.cloudflared/<UUID>.json`) is the bearer
  secret — never committed, never shared. If leaked, run
  `cloudflared tunnel delete dev-oriz` and recreate.
- Tunnel hostname is publicly resolvable — but only your
  daemon serves it. When the daemon is offline, the hostname
  returns a CF "tunnel offline" page.
- Don't tunnel anything you wouldn't want hit from the
  public internet. Treat `dev.oriz.in` as if it were
  production while the tunnel is up.

## Cross-refs

- [Local dev tunneling decision](../../decisions/architecture/local-dev-tunneling-cf-tunnel.md)
- [Wrangler — local Worker dev](./wrangler.md)
- [Dev-tools index](./index.md)
- [Cloudflare DNS — hosts the *.oriz.in zones bound to tunnels](../domain/cloudflare-dns.md)
- [Cloudflare Workers — primary tunnel target during dev](../compute/cloudflare-workers.md)
- [Hookdeck — production webhook ingress, used after dev verification](../tooling/hookdeck.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
