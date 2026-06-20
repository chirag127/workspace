---
type: service
title: "Cloudflare R2"
description: "REJECTED — card-on-file requirement on the surrounding Workers Paid plan. Replaced by Backblaze B2 + GitHub Releases split."
tags: [storage, cloudflare, r2, rejected]
timestamp: 2026-06-20
format_version: okf-v0.1
status: rejected
role: object-storage
provider: cloudflare
free_tier: "10 GB stored, 1M Class-A ops/mo, 10M Class-B ops/mo, zero egress — but adjacent paid features pull in card-on-file"
swap_cost: low
rejection_reason: "Adjacent paid Workers/R2 features require a billing method on file. Family hard rule [no-card-on-file] excludes the whole product even when the free tier itself does not request a card. Replaced by the Backblaze B2 + GitHub Releases split locked 2026-06-20."
related:
  - services/storage/backblaze-b2
  - services/storage/github-releases
  - services/compute/cloudflare-r2
  - decisions/architecture/object-storage-split
  - rules/no-card-on-file
---

# Cloudflare R2

## Status

**REJECTED** as of 2026-06-20. Replaced by the
[Backblaze B2](./backblaze-b2.md) + [GitHub Releases](./github-releases.md)
split documented in
[`decisions/architecture/object-storage-split.md`](../../decisions/architecture/object-storage-split.md).

## Why rejected

Although R2's free tier sign-up does not itself prompt for a card,
adjacent Cloudflare Workers Paid features that we'd realistically
want (higher CPU time, larger queue cliffs, R2 add-ons) pull in a
billing method on the same account. The family's
[no-card-on-file](../../rules/no-card-on-file.md) hard rule excludes
the whole surface, not just the free-tier door.

## Predecessor record

A prior entry at [services/compute/cloudflare-r2.md](../compute/cloudflare-r2.md)
documents R2 in the **compute** subdir as `status: active`. That file
is now stale and should be flipped to `status: rejected` in a
follow-up sweep, with a pointer to this entry. (Out of scope for the
batch that introduced this file — left as a documented inconsistency.)

## Replacement

| Use case | New home |
|---|---|
| Versioned binaries (`.crx`, `.vsix`, `.zip`, CLI bins) | [GitHub Releases](./github-releases.md) |
| Unversioned blobs (backups, raw originals, archives) | [Backblaze B2](./backblaze-b2.md) |

## Cross-refs

- [Object storage split decision](../../decisions/architecture/object-storage-split.md)
- [Backblaze B2](./backblaze-b2.md) — replacement (blobs)
- [GitHub Releases](./github-releases.md) — replacement (binaries)
- [services/compute/cloudflare-r2](../compute/cloudflare-r2.md) — stale active entry, to be flipped
- [No card-on-file rule](../../rules/no-card-on-file.md)
