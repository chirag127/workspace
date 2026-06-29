---
type: glossary
title: "card on file"
description: Payment instrument linked to service account; family avoids for paid-tier providers
tags: [glossary, billing, rule]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# card on file

## Definition

"Card on file" means a credit or debit card stored on a service
account so the provider can charge it automatically. The family's
non-negotiable rule is to never put a card on file with any
pay-as-you-go provider.

## Expanded

The reasoning is failure-mode asymmetry. The failure mode of
"card not on file" is "service stops at quota" — acceptable. The
failure mode of "card on file" is "card gets charged thousands when
quota is exceeded by a bug or attacker" — unacceptable. Documented
2025-2026 incidents include simmer.io ~$98K, Tamara ~$70K, a €54K
Gemini key.

This is why the family stays on Firebase Spark forever (never Blaze),
Cloudflare free (never paid plans), and why every service in the
catalog is pinned to its free tier with explicit "we never hit this
because…" justifications.

## See also

- [firestore-spark](../d-h/firestore-spark.md)
