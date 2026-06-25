---
type: service
title: "ActivityPub federation mirror"
description: "Mirrors oriz-me's canonical lifestream JSONL events to ActivityPub-compatible federated streams (Mastodon, Pleroma, etc) via me.oriz.in/activitypub/outbox. Free, federated, no card."
tags: [social, lifestream, activitypub, fediverse, mastodon, federation, mirror, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: lifestream-mirror-fediverse
provider: self-hosted
free_tier: "Self-hosted on Cloudflare Worker — already paid-for substrate, $0 marginal cost"
swap_cost: medium
related:
  - services/social/atproto-firehose
  - services/compute/cloudflare-workers
  - decisions/architecture/lifestream-federation
  - decisions/architecture/lifestream-jsonl-canonical
  - decisions/content/100-year-strategy-locked
  - rules/no-card-on-file
---

# ActivityPub federation mirror

## Role

Mirrors the canonical
[lifestream JSONL](../../decisions/architecture/lifestream-jsonl-canonical.md)
events from `chirag127/oriz-me-data` to **ActivityPub** — the W3C
federation protocol Mastodon, Pleroma, Misskey, and the wider
Fediverse run on. The family hosts a minimal ActivityPub actor at
`me.oriz.in/activitypub/actor` with an outbox at
`me.oriz.in/activitypub/outbox`; remote Fediverse users follow
`@chirag@me.oriz.in` and see the stream natively.

Like the [AT Protocol mirror](./atproto-firehose.md), this is a
**read** of the canonical JSONL — never an origin. If the outbox
is wiped, the next rehydrate cycle replays the JSONL into it.

## Free tier

- Self-hosted on a [Cloudflare Worker](../compute/cloudflare-workers.md)
  at `me.oriz.in/activitypub/*` — already paid-for substrate, $0
  marginal cost.
- Outbox JSON-LD documents stored in `oriz-me`'s static `dist/` and
  served from Cloudflare Pages where possible (cheap, cacheable);
  inbox / signature verification handled by the Worker.
- WebFinger at `me.oriz.in/.well-known/webfinger?resource=acct:chirag@me.oriz.in`
  resolves the actor.

## Card / subscription required?

**NO.** Self-hosted on infrastructure already covered by the
[Cloudflare-Pages-for-all-sites](../../decisions/infrastructure/cloudflare-pages-for-all-sites.md)
+ [Workers](../compute/cloudflare-workers.md) decisions.

## How CI / cron consumes it

```ts
// scripts/mirror-to-activitypub.ts (sketch)
import { signAndDeliver } from './ap-signing'; // HTTP Signatures (RFC 9421)

for (const event of unmirroredEvents()) {
  const note = {
    '@context': 'https://www.w3.org/ns/activitystreams',
    id: `https://me.oriz.in/activitypub/notes/${event.id}`,
    type: 'Note',
    attributedTo: 'https://me.oriz.in/activitypub/actor',
    content: event.summary,
    published: event.occurred_at,
    url: event.canonical_url,
    to: ['https://www.w3.org/ns/activitystreams#Public'],
  };
  await signAndDeliver(note, followers());
  markMirrored(event.id);
}
```

Runs hourly via [Cloudflare Cron Triggers](../cron/cloudflare-cron-triggers.md).
HTTP-Signature key pair lives in [Doppler](../secrets/doppler.md);
public key embedded in the actor document.

## What gets mirrored

- All public-tagged lifestream events from
  `chirag127/oriz-me-data` per the
  [public/private line policy](../../decisions/policy/public-private-line.md).
- Journal entries **not** mirrored — gated by the
  [journal-stays-auth-gated decision](../../decisions/content/journal-stays-auth-gated.md).
- Age-gated content **not** mirrored federated.

## Alternatives

- [AT Protocol mirror](./atproto-firehose.md) — sibling federation;
  we run **both** (see
  [lifestream-federation decision](../../decisions/architecture/lifestream-federation.md)).
- Hosted ActivityPub services (e.g. micro.blog) — paid past free
  trial.
- Nostr — alternative federated protocol; deferred.
- Don't federate — leaves Fediverse readers unable to follow
  natively; rejected.

## Swap cost

Medium — outbox documents are derived data; the canonical JSONL is
untouched by an ActivityPub redesign. Swapping the self-hosted
implementation for a hosted service (e.g. micro.blog) is a Worker
swap + DNS rebind; mirrored notes are content-addressed by the
JSONL `id`, so a clean re-publish keeps reader follows intact.

## Why this is our pick

Federation reaches a different audience from AT Protocol —
Mastodon and the wider Fediverse aren't on Bluesky and won't
follow an AT Protocol-only mirror. Self-hosting on Workers costs
nothing marginal and keeps the family in control of the actor's
domain identity (`@chirag@me.oriz.in` is permanent; a hosted
service URL would not be). Pairs with the
[AT Protocol mirror](./atproto-firehose.md) — two protocols, one
canonical source — per the
[lifestream-federation decision](../../decisions/architecture/lifestream-federation.md).

## Cross-refs

- [social services index](./index.md)
- [AT Protocol mirror — sibling protocol](./atproto-firehose.md)
- [Lifestream federation decision](../../decisions/architecture/lifestream-federation.md)
- [Lifestream JSONL is canonical decision](../../decisions/architecture/lifestream-jsonl-canonical.md)
- [100-year strategy locked](../../decisions/content/100-year-strategy-locked.md)
- [Cloudflare Workers — runs the actor](../compute/cloudflare-workers.md)
- [Cloudflare Cron Triggers — runs the mirror](../cron/cloudflare-cron-triggers.md)
- [Doppler — secrets source-of-truth](../secrets/doppler.md)
- [Public/private line policy](../../decisions/policy/public-private-line.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
