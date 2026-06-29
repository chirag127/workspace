---
type: index
title: "Tooling / utility services"
description: "Cross-cutting utility services — secrets, image CDN, logs, feature flags, webhook reliability, free credits."
tags: [services, tooling, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Tooling / utility services

Cross-cutting services that don't fit a single role bucket.

| Service | Status | One-line role |
|---|---|---|
| [envpact.md](./envpact.md) | active | Encrypted env-var secrets vault, OSS-friendly |
| [imagekit.md](./imagekit.md) | active | Image CDN with on-the-fly transforms (primary) |
| [cloudinary.md](./cloudinary.md) | active | Image CDN fallback — 25 monthly credits free |
| [axiom.md](./axiom.md) | active | Log management — 0.5 TB/mo ingest free |
| [hypertune.md](./hypertune.md) | active | Typed feature flags + A/B + Git-style config, unlimited free |
| [hookdeck.md](./hookdeck.md) | active | Webhook reliability layer — queues, retries, replay (100K req/mo free) |
| [readthedocs.md](./readthedocs.md) | active | SDK / API reference docs hosting — free for open-source |
| [azure-for-students.md](./azure-for-students.md) | conditional | Free Azure credits via student plan (no card required) |

## Cross-refs

- [rules/no-hardcoded-secrets](../../rules/security/no-hardcoded-secrets.md)
