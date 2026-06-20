---
type: service
title: "Backblaze B2"
description: "Primary blob storage — 10 GB free + 3x egress free of stored. Used for backups and large unversioned binaries that don't belong in GitHub Releases."
tags: [storage, backblaze, b2, blob, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: storage-blob
provider: backblaze
free_tier: "10 GB stored, 1 GB/day egress free + 3x stored bytes/month egress free, S3-compatible API"
swap_cost: low
related:
  - services/storage/github-releases
  - decisions/architecture/object-storage-split
  - rules/no-card-on-file
---

# Backblaze B2

## Role

Primary blob storage for **unversioned** large objects: database
backups, asset archives, raw photo / video originals that don't fit
the per-release GitHub model. Pairs with
[GitHub Releases](./github-releases.md) — Releases for versioned
binaries, B2 for everything else. Documented in
[`decisions/architecture/object-storage-split.md`](../../decisions/architecture/object-storage-split.md).

This entry **supersedes** the older [`services/backblaze-b2.md`](../backblaze-b2.md)
flat-level rejection — that file remains in place as a historical
note, but the live status is here.

## Free tier

- 10 GB stored
- 1 GB / day egress free, **plus** 3x stored bytes / month egress free
  via the Bandwidth Alliance / standard free egress allotment
- S3-compatible API
- App keys per bucket (least-privilege uploads)
- Lifecycle rules + versioning

## Card / subscription required?

**NO.** Free tier sign-up is email-only. No payment method requested.

## Alternatives

- [GitHub Releases](./github-releases.md) — sibling, used for versioned binaries
- [Cloudflare R2](./cloudflare-r2.md) — REJECTED (card-on-file required for Workers Paid features tied to it)
- AWS S3 — rejected (card)
- iDrive E2 — alternative S3-compat, smaller free tier

## Swap cost

Low — S3-compatible API. Wrap behind a thin upload helper in the
api.oriz.in Worker; swap endpoint URL + credentials.

## Why this is our pick

Backblaze B2's free tier is the most generous no-card S3-compatible
blob storage. Egress allowance covers our backup-restore-and-test
workflow without surprises. Cloudflare R2 was the obvious option but
its quota-cliff behaviour and the recently-locked R2 rejection (see
[`object-storage-split`](../../decisions/architecture/object-storage-split.md))
ruled it out.

## Reversal of prior rejection

Earlier knowledge (see [`services/backblaze-b2.md`](../backblaze-b2.md))
listed Backblaze B2 as `status: rejected — user policy`. That status
was **reversed** on 2026-06-20 when Cloudflare R2 itself was
rejected on card-on-file grounds. The file at `services/backblaze-b2.md`
keeps its old text for the historical record; the active service
entry is **this file**.

## Cross-refs

- [Object storage split decision](../../decisions/architecture/object-storage-split.md)
- [GitHub Releases](./github-releases.md) — sibling, versioned binaries
- [Cloudflare R2](./cloudflare-r2.md) — rejected
- [services/backblaze-b2.md](../backblaze-b2.md) — historical rejection record
- [No card-on-file rule](../../rules/no-card-on-file.md)
