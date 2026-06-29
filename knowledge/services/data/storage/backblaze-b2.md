---
type: service
title: "Backblaze B2"
description: "REJECTED — excluded by user policy"
tags: [storage, rejected]
timestamp: 2026-06-20
format_version: okf-v0.1
status: rejected
role: object-storage
provider: backblaze
free_tier: "10 GB free, S3-compatible. Excluded regardless."
swap_cost: n/a
rejection_reason: "Excluded by user policy. The family uses Cloudflare R2 instead — same 10 GB free, plus zero egress fees and one-account integration with Pages/Workers/DNS."
---

# Backblaze B2

## Status

**REJECTED.** Documented in AGENTS.md `Hard constraints` as a
permanent exclusion.

## Why rejected

User policy. Even though Backblaze B2's free tier (10 GB, S3-compatible)
is technically usable and doesn't require a card on file at sign-up,
the family's hard rule excludes it.

## Card / subscription required?

**NO** at sign-up. But the exclusion is broader than the card rule.

## Replacement

[Cloudflare R2](compute/cloudflare-r2.md) — same 10 GB free, zero egress
fees, one dashboard with Pages and Workers.

## Cross-refs

- [Cloudflare R2](compute/cloudflare-r2.md) — replacement
- [AGENTS.md hard constraints](../../AGENTS.md#hard-constraints-will-never-use)
