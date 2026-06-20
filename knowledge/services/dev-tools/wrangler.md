---
type: service
title: "Wrangler"
description: "Cloudflare's official CLI for Workers / Pages / KV / R2 / D1 / Queues development and deployment. Local mode runs in workerd; remote mode runs against real Cloudflare infrastructure. Free as part of the Cloudflare account."
tags: [services, dev-tools, cloudflare, workers, cli, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: dev-tunnel-worker
provider: cloudflare
free_tier: "Unlimited usage as the official CLI for the Cloudflare free Workers / Pages / KV / R2 plan"
swap_cost: high
related:
  - decisions/architecture/local-dev-tunneling-cf-tunnel
  - decisions/architecture/hono-worker-api-umbrella
  - services/dev-tools/cloudflare-tunnel
  - services/compute/cloudflare-workers
---

# Wrangler

## Role

Cloudflare's **official CLI** for every Worker in the family —
the umbrella `api.oriz.in` Hono Worker per
[`hono-worker-api-umbrella`](../../decisions/architecture/hono-worker-api-umbrella.md),
the `s.oriz.in` shortener Worker, the `og.oriz.in` Satori
endpoint, plus per-site Pages Functions where used.

Two modes:

- **Local mode** (`wrangler dev`) — runs the Worker in a local
  workerd instance with miniflare-emulated bindings (KV / R2 /
  D1 / Queues / Durable Objects). HMR on file change.
- **Remote mode** (`wrangler dev --remote`) — runs the Worker on
  real Cloudflare infrastructure with the actual production
  bindings. Required for behaviour-parity testing against real
  KV / R2 / Queues semantics.

Plus deploy (`wrangler deploy`), tail (`wrangler tail`), secret
management (`wrangler secret put`), KV / R2 / D1 / Queues admin
sub-commands.

## Free tier

- **Unlimited CLI usage** as part of the Cloudflare free Workers
  plan (100,000 requests/day) — Wrangler itself doesn't bill;
  it's the operator surface for the underlying Worker plan.
- **Local mode** uses zero Cloudflare-side quota; runs entirely
  on the developer machine.
- **Remote mode** consumes the same 100K/day Worker request
  envelope as production traffic — covered by the
  [CF Worker quota mitigation playbook](../../decisions/architecture/cf-worker-quota-mitigation.md).

## Card / subscription required?

**NO.** Free as part of the Cloudflare account.
[Cloudflare R2](../../decisions/architecture/object-storage-split.md)
remains rejected on adjacent-paid-feature card-on-file grounds —
Wrangler the CLI is fine; the Workers Paid plan it can also
deploy to is what's avoided.

## Install + use

```bash
pnpm add -D wrangler@latest
pnpm wrangler login          # browser-auth into the CF account

# Local dev (workerd)
pnpm wrangler dev --port 8787

# Remote dev (real Cloudflare)
pnpm wrangler dev --remote

# Deploy
pnpm wrangler deploy

# Tail production logs
pnpm wrangler tail

# Secrets — pulled from Doppler per secrets-management-doppler
doppler secrets download --no-file --format env | \
  while IFS='=' read -r k v; do
    echo "$v" | pnpm wrangler secret put "$k"
  done
```

Pinned major version per
[`rules/always-latest-deps`](../../rules/always-latest-deps.md);
upgraded by Dependabot per
[`code-quality-five-tools`](../../decisions/architecture/code-quality-five-tools.md).

## Why this is our pick

- **Official.** No third-party Worker CLI is as well-supported
  for the actual edge runtime; alternatives (denoflare,
  cloudflare-cli) lag behind Cloudflare's own platform releases.
- **Local + remote parity** in one tool — no separate "test
  against real bindings" workflow.
- **Free + no card** — fits the family's
  [`no-card-on-file`](../../rules/no-card-on-file.md) and
  [`no-subscriptions`](../../rules/no-subscriptions.md) rules.
- **Composes with [Cloudflare Tunnel](./cloudflare-tunnel.md)** —
  `wrangler dev --port 8787` + `cloudflared tunnel run --url
  http://localhost:8787 dev-oriz` exposes the in-flight Worker
  on `dev.oriz.in` for webhook senders.

## Alternatives

- **Miniflare** (standalone) — lower-level emulator that
  Wrangler now embeds; no reason to use directly when
  Wrangler is the same engine plus the deploy surface.
- **denoflare** — Deno-based Cloudflare Worker CLI; trails the
  platform on new bindings. Rejected.
- **wrangler v1** — legacy; Cloudflare deprecated it. Wrangler v3+
  is mandatory.

## Swap cost

High — Wrangler is tightly coupled to the Cloudflare Workers
runtime + binding API. Swapping the CLI without swapping the
runtime is impossible; swapping the runtime would mean
abandoning Cloudflare Workers entirely (Vercel Edge / Deno
Deploy / fly.io) which fights
[`hono-worker-api-umbrella`](../../decisions/architecture/hono-worker-api-umbrella.md)
and the broader CF stack lock.

## Configuration files

- **`wrangler.toml`** (or `wrangler.jsonc`) — per-Worker config
  with `name`, `main`, `compatibility_date`,
  `[vars]`, `[[kv_namespaces]]`, `[[r2_buckets]]`,
  `[[queues.producers]]` / `[[queues.consumers]]`, etc.
- **`.dev.vars`** — local-dev secrets (gitignored). Production
  secrets go via `wrangler secret put` from
  [Doppler](../secrets/doppler.md) per
  [`secrets-management-doppler`](../../decisions/security/secrets-management-doppler.md).

## Cross-refs

- [Local dev tunneling decision](../../decisions/architecture/local-dev-tunneling-cf-tunnel.md)
- [Cloudflare Tunnel — pairs with Wrangler for webhook testing](./cloudflare-tunnel.md)
- [Dev-tools index](./index.md)
- [Cloudflare Workers — runtime Wrangler deploys to](../compute/cloudflare-workers.md)
- [Hono Worker API umbrella](../../decisions/architecture/hono-worker-api-umbrella.md)
- [CF Worker quota mitigation playbook](../../decisions/architecture/cf-worker-quota-mitigation.md)
- [Secrets management — Doppler](../../decisions/security/secrets-management-doppler.md)
- [Use pnpm rule](../../rules/use-pnpm.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
