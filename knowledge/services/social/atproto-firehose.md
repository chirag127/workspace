---
type: service
title: "AT Protocol firehose mirror (Bluesky)"
description: "Mirrors oriz-me's canonical lifestream JSONL events to the AT Protocol as records under me.oriz.in.atproto. Free, federated, no card."
tags: [social, lifestream, atproto, bluesky, federation, mirror, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: lifestream-mirror-bsky
provider: bluesky-pds
free_tier: "Free PDS hosting on bsky.social, or self-host @atproto/pds on Cloudflare Workers; unlimited records under family DID"
swap_cost: medium
related:
  - services/social/activitypub
  - services/database/turso
  - decisions/architecture/lifestream-federation
  - decisions/architecture/lifestream-jsonl-canonical
  - decisions/content/100-year-strategy-locked
  - rules/no-card-on-file
---

# AT Protocol firehose mirror (Bluesky)

## Role

Mirrors the canonical
[lifestream JSONL](../../decisions/architecture/lifestream-jsonl-canonical.md)
events from `chirag127/oriz-me-data` to the AT Protocol — the
federated stack Bluesky runs on. Each event is published as an
AT Protocol record under the family lexicon
`me.oriz.in.atproto.lifestream.event`. Bluesky and any other
AT Protocol consumer can subscribe via the firehose; readers can
follow `@chirag127.oriz.in` (DID-handle on the family domain) and
see the stream natively.

The mirror is a **read** of the canonical JSONL — it never
originates events. If the AT Protocol mirror is wiped, the next
ingest cycle rehydrates it from
`chirag127/oriz-me-data/events-YYYY.jsonl`.

## Free tier

- **bsky.social PDS** — free unlimited records for personal
  accounts; rate-limited at the firehose ingress side, well above
  the family's events/day rate.
- **Self-hosted PDS** — `@atproto/pds` runs on a free Cloudflare
  Worker + R2-equivalent storage path; the family already has
  the substrate.
- DID custody: family DID (`did:plc:...`) bound to the handle
  `chirag127.oriz.in` via DNS TXT record at
  `_atproto.chirag127.oriz.in`.

## Card / subscription required?

**NO.** The hosted PDS at bsky.social is free; the self-host path
runs on infrastructure already paid for ($0).

## How CI / cron consumes it

```ts
// scripts/mirror-to-atproto.ts (sketch)
import { AtpAgent } from '@atproto/api';

const agent = new AtpAgent({ service: 'https://bsky.social' });
await agent.login({
  identifier: 'chirag127.oriz.in',
  password: process.env.ATPROTO_APP_PASSWORD,
});

for (const event of unmirroredEvents()) {
  await agent.com.atproto.repo.createRecord({
    repo: agent.session!.did,
    collection: 'me.oriz.in.atproto.lifestream.event',
    record: {
      $type: 'me.oriz.in.atproto.lifestream.event',
      jsonl_id: event.id,
      occurred_at: event.occurred_at,
      kind: event.kind,
      summary: event.summary,
      canonical_url: event.canonical_url,
      createdAt: new Date().toISOString(),
    },
  });
  markMirrored(event.id);
}
```

Runs hourly via [Cloudflare Cron Triggers](../cron/cloudflare-cron-triggers.md).
Idempotent on the JSONL `id` — repeated runs no-op.
`ATPROTO_APP_PASSWORD` lives in [Doppler](../secrets/doppler.md).

## What gets mirrored

- All public-tagged lifestream events from
  `chirag127/oriz-me-data` per the
  [public/private line policy](../../decisions/policy/public-private-line.md).
- Journal entries are **not** mirrored — gated by the
  [journal-stays-auth-gated decision](../../decisions/content/journal-stays-auth-gated.md).
- Age-gated content **not** mirrored federated — handled per
  [age-gating policy](../../decisions/policy/age-gating.md).

## Alternatives

- [ActivityPub](./activitypub.md) — sibling federation; we run
  **both** (see
  [lifestream-federation decision](../../decisions/architecture/lifestream-federation.md)).
- Nostr — alternative federated protocol; deferred.
- RSS only — already produced; federation gives discoverability
  RSS doesn't.

## Swap cost

Medium — the mirror script is decoupled from the canonical store,
and the AT Protocol records are derived data. Swapping PDS
providers (e.g. bsky.social → self-host) requires re-binding the
DID document and re-publishing records; no canonical data is at
risk.

## Why this is our pick

Federated, free, and the protocol underlying Bluesky — which is
where readers expect to find a "lifestream" in 2026. AT Protocol's
custom-record model fits the family lexicon
(`me.oriz.in.atproto.lifestream.event`) cleanly. Pairs with
ActivityPub for the Mastodon-flavoured federated audience —
[two protocols, one canonical source](../../decisions/architecture/lifestream-federation.md).

## Cross-refs

- [social services index](./index.md)
- [ActivityPub mirror — sibling protocol](./activitypub.md)
- [Lifestream federation decision](../../decisions/architecture/lifestream-federation.md)
- [Lifestream JSONL is canonical decision](../../decisions/architecture/lifestream-jsonl-canonical.md)
- [100-year strategy locked](../../decisions/content/100-year-strategy-locked.md)
- [Cloudflare Cron Triggers — runs the mirror](../cron/cloudflare-cron-triggers.md)
- [Doppler — secrets source-of-truth](../secrets/doppler.md)
- [Public/private line policy](../../decisions/policy/public-private-line.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
