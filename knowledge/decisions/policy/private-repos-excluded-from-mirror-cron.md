---
type: decision
title: "Private repos are excluded from the 5-host mirror cron"
description: "The .github/workflows/mirror-all.yml cron pushes every public repo from oriz-org + chirag127 to 6 mirror hosts. Private repos (oriz-org/secrets and any other isPrivate=true repo) are FILTERED OUT at discovery time via gh-list's isPrivate filter PLUS an explicit name-based exclusion list. Defense in depth: if GitHub ever wrongly reports a private repo as public, the name-list still drops it. Adding a new private repo to the family means: (1) create it as private, (2) verify the discover step filters it, (3) optionally add its name to the explicit EXCLUDE list, (4) only THEN add as a submodule to the umbrella."
tags: [decision, policy, mirror, private, secrets, security]
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/ops/mirror-to-5-popular-alternatives-2026-06-28
  - rules/submodule-env-files-three-file-pattern
  - decisions/security/sops-plus-doppler-hybrid
---

# Private repos excluded from mirror cron

## Decision

The 5-host mirror cron in `.github/workflows/mirror-all.yml` MUST NOT push private repos to public mirror hosts. Two filters in series:

1. **gh list `isPrivate` filter** — the `gh repo list` calls in the discover step filter by `isPrivate == false`. Public repos only.
2. **Explicit name EXCLUDE list** — even if a repo is mis-flagged as public, its name in this hardcoded list drops it. Defense in depth.

The current exclude list (in `mirror-all.yml`):

```json
["secrets", "Recovery-codes", "recovery-codes", "envpact-secrets"]
```

## What's covered by this exclusion

| Repo | Owner | Why excluded |
|---|---|---|
| `oriz-org/secrets` | oriz-org | Brand-family secrets store (env files, recovery codes, backups). Private. |
| `chirag127/secrets` | chirag127 | Personal secrets store. Private. |
| `chirag127/Recovery-codes` | chirag127 | Personal 2FA codes. Private + air-gapped from secrets. |
| `chirag127/envpact-secrets` | chirag127 | envpact per-project vault. Private. |

## Adding a new private repo to the family

Order matters:

1. Create the repo as `private` on GitHub.
2. Verify the discover step's `isPrivate == false` filter catches it (it should — automatic).
3. Add the repo's NAME to the `EXCLUDE` array in `mirror-all.yml` even though step 2 already handles it. Belt-and-suspenders.
4. THEN add as a submodule to the umbrella if desired.

Reversing step 3 + step 4 is the most likely way to leak. Always exclude FIRST, submodule SECOND.

## Why filter + exclude both

Single-layer filtering breaks if:
- A repo's `private` flag is accidentally toggled to public via the GitHub UI
- `gh repo list` API output schema changes (unlikely but possible)
- The discover step's jq filter has a typo

The name-list catches all three. Cost of maintaining two filters: 0 (just add the name when creating). Cost of a leak: catastrophic.

## What's NOT in scope of this rule

- Per-repo `.github/workflows/*.yml` workflows — those run inside their own repo's context and can't accidentally leak it (GitHub Actions in a private repo can't push the repo's code to a public destination unless the workflow explicitly does so).
- B2 metadata backup — that pushes to a private B2 bucket, not a public mirror, so privacy is preserved regardless.

## Cross-refs

- The mirror decision: [[decisions/architecture/ops/mirror-to-5-popular-alternatives-2026-06-28]]
- The mirror workflow itself: `.github/workflows/mirror-all.yml` (umbrella root)
- The secrets repo this rule primarily protects: [oriz-org/secrets](https://github.com/oriz-org/secrets) (private)
