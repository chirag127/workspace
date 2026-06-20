---
type: glossary
title: "App Check"
description: "Firebase's bot-defence layer that gates every Firestore call to verified clients."
tags: [glossary, firebase, security]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# App Check

## Definition

Firebase App Check is the bot-defence layer that issues an
attestation token to verified client apps and lets Firestore security
rules require `request.app != null` on every read and write — gating
the database to legitimate clients only.

## Expanded

The family enforces App Check on every Firestore call, with reCAPTCHA
Enterprise as the underlying provider (10K assessments/month free;
7-day token TTL minimises consumption). Default-deny on
`match /{document=**}`; the only allow rules also assert
`appChecked()`.

App Check is free; it is the cheapest way to defend the Spark plan
from automated abuse that would otherwise burn the 50K/day read
quota. Combined with Cloudflare WAF in front of `*.oriz.in`, it gives
a two-layer rate-limit and bot-fight defense.

## See also

- [firestore-spark](./firestore-spark.md)
