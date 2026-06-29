---
type: service
title: "Azure (paid tiers)"
description: "REJECTED — card required; Azure for Students documented separately"
tags: [cloud, azure, rejected]
timestamp: 2026-06-20
format_version: okf-v0.1
status: rejected
role: cloud-platform
provider: microsoft
free_tier: "12-month free + always-free services (App Service F1, Functions 1M req/mo, etc.) — but card required at sign-up."
swap_cost: n/a
rejection_reason: "Standard Azure account creation requires a credit/debit card at sign-up, violating the no-card-on-file rule. Azure for Students is a separate program that does not require a card and is documented in azure-for-students.md."
---

# Azure (paid tiers)

## Status

**REJECTED.** Violates the [no-card-on-file rule](../rules/interaction/no-card-on-file.md).

This entry covers the standard / commercial / pay-as-you-go Azure
sign-up. The student program is separate — see
[azure-for-students.md](tooling/azure-for-students.md).

## Why rejected

Standard Azure sign-up requires a valid credit/debit card for identity
verification, even to access always-free services. Auto-billing is the
default for any usage above the free tier.

## Card / subscription required?

**YES.** Card required at sign-up.

## Replacement

- Compute: [Cloudflare Workers](compute/cloudflare-workers.md)
- Storage: [Cloudflare R2](compute/cloudflare-r2.md)
- For specific student-eligible workloads: [Azure for Students](tooling/azure-for-students.md)

## Cross-refs

- [Azure for Students](tooling/azure-for-students.md) — the card-free student variant
- [No card-on-file rule](../rules/interaction/no-card-on-file.md)
