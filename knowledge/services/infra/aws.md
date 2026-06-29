---
type: service
title: "AWS"
description: "REJECTED — card required at sign-up"
tags: [cloud, aws, rejected]
timestamp: 2026-06-20
format_version: okf-v0.1
status: rejected
role: cloud-platform
provider: amazon
free_tier: "12-month free tier for new accounts + always-free services (Lambda 1M req/mo, DynamoDB 25 GB, etc.)"
swap_cost: n/a
rejection_reason: "AWS requires a credit/debit card on file at sign-up, even to access the always-free services. This violates the family's no-card-on-file rule."
---

# AWS

## Status

**REJECTED.** Violates the [no-card-on-file rule](../rules/interaction/no-card-on-file.md).

## Why rejected

AWS account creation requires a valid credit or debit card to be
attached at sign-up — there is no card-free path. Once attached, AWS
auto-charges any usage above the free tier without a hard quota
cut-off. Both properties violate the family's rules.

## Card / subscription required?

**YES.** Card required at sign-up. Free-tier "available" but requires
the card on file regardless. Auto-billing is the default behavior.

## Replacement

- Compute: [Cloudflare Workers](compute/cloudflare-workers.md)
- Storage: [Cloudflare R2](compute/cloudflare-r2.md)
- DB: [Firebase Spark](auth/firebase-spark.md), [Turso](database/turso.md), [Supabase](auth/supabase.md)

## Cross-refs

- [No card-on-file rule](../rules/interaction/no-card-on-file.md)
- [Cloudflare Workers](compute/cloudflare-workers.md) — Lambda replacement
