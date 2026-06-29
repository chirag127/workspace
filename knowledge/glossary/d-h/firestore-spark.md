---
type: glossary
title: "Firestore Spark"
description: Firebase free tier; family never upgrades to Blaze
tags: [glossary, firebase, billing, rule]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Firestore Spark

## Definition

Spark is Firebase's free tier — the no-card-on-file plan with hard
quotas that fail-closed at the limit. The family stays on Spark
forever for the single project `oriz-app`, and never upgrades to
Blaze (the pay-as-you-go plan).

## Expanded

Spark caps the family never hits: 50K MAU auth, 50K Firestore
reads/day, 20K writes/day, 1 GB Firestore storage. Spread across 11+
sites and N extensions, those numbers are still wide headroom. App
Check + Cloudflare WAF defend against bot abuse that could otherwise
burn the read quota.

Why never Blaze: documented 2025-2026 bill-shock incidents
(simmer.io ~$98K, Tamara ~$70K, €54K Gemini key). Cloud Spend Caps
from Cloud Next '26 are private preview and don't cover Firestore /
Storage / Hosting. Spark's "stop at quota" is the only failure mode
with no cost ceiling.

## See also

- [card-on-file](../a-c/card-on-file.md)
- [app-check](../a-c/app-check.md)
- [auth-domain](../a-c/auth-domain.md)
