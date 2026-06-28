---
type: rule
title: 'User prefers features-on when cost is small'
description: When grilled with a Recommended "disable feature X" vs 2nd-choice "enable feature X", and the cost of enabling is small (Qdrant container, telemetry data, etc.), user systematically picks Enable. Underlying preference is maximum-features-on, even when reversing a prior explicit decision.
tags: [user-identity, preference, defaults, feedback, learn-from-answers]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - rules/interaction/future-overrides-past
---

# User prefers features-on when cost is small

## Observation 2026-06-28

When asked "Hr Memory: keep disabled (Recommended, your prior decision) vs enable (2nd choice, adds Qdrant)" — user picked **enable**, reversing the prior "no memory/Qdrant/TOIN/learn features" decision.

When asked "Hr Telemetry: keep disabled (Recommended) vs enable (2nd choice, sends anonymized usage)" — user picked **enable**.

Pattern in same turn: maximum-features-on. Prior "minimalist" decisions are not load-bearing; they were tactical at the time. User updates them freely when shown the upside.

## The rule

When proposing on/off toggles to user, default the Recommended option to **enable the feature** when:
- Cost of enabling is small (one container, low GB, no $)
- Feature provides cross-session benefit (memory, telemetry that helps the upstream project, learn modes)
- No card-on-file required

Only default to **disable** when:
- Card-on-file required (hard veto)
- Feature is a real anti-pattern (auth in apps per `no-auth-in-apps-or-apis`)
- Mission-level non-negotiable (per `future-overrides-past` exceptions)

## Examples of the pattern

- Hr Memory (Qdrant) — was off, now on
- Hr Telemetry — was off, now on
- Hr Code-Aware — was on, stays on
- Hr Output Shaper — was off, now on
- Maximum-libraries policy (already in knowledge) — user reversed "minimal libraries" to "use libraries freely"

## See also

- [[future-overrides-past]] — chat reversals are allowed
- [[maximum-libraries-policy]] — same pattern, applied to deps
