---
type: decision
title: "Stay on Firebase Spark forever — never enable Blaze"
description: "Firebase usage is permanently capped to the Spark plan. Blaze is excluded by the no-card-on-file rule and documented bill-shock incidents."
tags: [firebase, billing, free-tier, constraint]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - rules/never-hit-quotas
  - rules/no-card-on-file
  - decisions/monetisation/no-subscriptions-anywhere
  - services/auth/firebase-spark
  - architecture/layer-3-auth-firebase-spark
---

# Stay on Firebase Spark forever — never enable Blaze

## Decision

The single Firebase project (`oriz-app`) stays on the Spark plan
forever. Blaze is never enabled — not for a feature, not as a
"temporary upgrade", not as an experiment.

## Why

Documented 2025–2026 bill-shock incidents (simmer.io ~$98K,
Tamara ~$70K, €54K Gemini key) prove the Blaze failure mode is
catastrophic. Cloud Spend Caps from Cloud Next '26 are private
preview AND don't cover Firestore / Storage / Hosting. The
Cyclenerd Terraform killswitch is the only real defense and even
it lags hours-to-days behind actual spend. Spark's failure mode —
"service stops at quota" — is the only one with no cost ceiling.
This is the highest-stakes specific application of the
no-card-on-file rule.

## Implications

- Architect for Spark headroom: 50K Firestore reads/day, 20K writes/day, 1 GB storage, 50K MAU.
- Spread load to other layers (GitHub-as-DB, Turso, browser localStorage) so Firestore reads/writes stay well under the cap.
- Defend Spark from bot abuse with App Check + reCAPTCHA Enterprise + Firestore security rules requiring `request.app != null`.
- If a feature genuinely needs Blaze, the feature is wrong — redesign it onto the rest of the free stack.
- The runbook at `knowledge/runbooks/blaze-without-paying.md` (planned) exists ONLY as the 30-min "what to do if accidentally enabled" recovery, not as an upgrade path.

## Cross-refs

- [Never hit free-tier quotas](../../rules/interaction/never-hit-quotas.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [No subscriptions anywhere](../monetisation/no-subscriptions-anywhere.md)
- [Firebase Spark service entry](../../services/auth/firebase-spark.md)
- [Layer 3 — Firebase Spark architecture](../architecture/security/layer-3-auth-firebase-spark.md)
