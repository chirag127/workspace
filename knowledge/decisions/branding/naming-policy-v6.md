---
type: decision
title: "Naming policy v6 — brand + category + suffix per repo, with family exceptions"
description: "Sixth-pass naming. Repos follow <brand>-<category>-<suffix> format where the brand is a unique product word (e.g. slice, pixie). Existing astro-*-npm-pkg packages keep their current names as the family convention — astro- is their brand prefix. Workspace umbrella keeps its bare name as apex exception. Forks always exempt."
tags: [naming, repo, suffix, family, branding, v6, brand-prefix]
timestamp: 2026-06-21
format_version: okf-v0.1
status: active
supersedes: [decisions/branding/naming-policy-v5]
related: [decisions/architecture/multi-target-build, decisions/architecture/per-runtime-framework]
---

# Naming policy v6

## Decision

Repo slugs are `<brand>-<category>-<suffix>` where:
- **brand** = a unique short word identifying the product (e.g. `slice` for PDF tools, `pixie` for image tools)
- **category** = the function or domain (e.g. `pdf-tools`, `image-tools`, `chrome`, `forms`)
- **suffix** = the runtime / role / language category (per the v5 suffix matrix: `-app`, `-game`, `-kids-game`, `-npm-pkg`, `-py-pkg`, `-rs-crate`, `-go-mod`, `-npm-cli`, `-py-cli`, `-rs-cli`, `-browser-ext`, `-vsc-ext`, `-mcp-server`, `-worker`, `-fn`, `-data`, `-skill`, `-rules`)

This replaces the v5 "no brand prefix in slug" rule. Recruiter scanning gets a memorable brand on every repo while still seeing the function + runtime from the rest of the slug.

## Exceptions (locked 2026-06-21 audit pass)

Three exceptions to the format:

### 1. Apex umbrella keeps bare name

`chirag127/workspace` stays as `workspace` (no brand prefix, no suffix). It's the meta umbrella that holds everything else; adding a brand prefix would be circular. Decided via per-repo MCQ in the 100-most-recent audit.

### 2. Existing astro-*-npm-pkg packages keep current names

The 8 shipped Astro packages keep their `astro-<role>-npm-pkg` form rather than getting a unique brand word prefixed:

| Repo | Status |
|---|---|
| `astro-shell-npm-pkg` | kept |
| `astro-chrome-npm-pkg` | kept |
| `astro-tools-npm-pkg` | kept |
| `astro-config-npm-pkg` | kept |
| `astro-icons-npm-pkg` | kept |
| `astro-ai-npm-pkg` | kept |
| `astro-forms-npm-pkg` | kept |
| `astro-data-npm-pkg` | kept |

Rationale: `astro-` IS their brand prefix — they're a tightly-coupled family of Astro framework packages, and that consistency reads better than `slice-shell-npm-pkg` / `pixie-chrome-npm-pkg` mismatches. The brand is the framework they're built for. Decided per-repo via MCQ in the 100-most-recent audit (repos #2-#8).

### 3. Forks always keep upstream slug

Forks of upstream repos keep their original GitHub name. No `-fork` suffix. No brand prefix. Per `naming-policy-v5.md` § Fork exception (carried forward).

## The audit

A 100-most-recently-pushed audit is in progress on `chirag127/*` (non-forks). Each repo gets a per-repo MCQ asking: keep current name / rename per v6 / private / archive / delete. Audit done serial, 10 repos per turn, ~10 turns to cover 100 repos. Remaining 400 repos deferred to a later pass.

| Repo # | Slug | Decision |
|---|---|---|
| 1 | workspace | KEEP (apex exception) |
| 2 | astro-chrome-npm-pkg | KEEP (astro-* family) |
| 3 | astro-forms-npm-pkg | KEEP (astro-* family) |
| 4 | astro-shell-npm-pkg | KEEP (astro-* family) |
| 5 | astro-ai-npm-pkg | KEEP (astro-* family) |
| 6 | astro-data-npm-pkg | KEEP (astro-* family) |
| 7 | astro-tools-npm-pkg | KEEP (astro-* family) |
| 8 | astro-config-npm-pkg | KEEP (astro-* family) |
| 9-100 | ... | (audit in progress) |

## Format details

For new repos that DO take the full `<brand>-<category>-<suffix>` form:

- **Brand**: short (4-8 letters), unique per product, real-word or near-real-word per the frontend-design skill's writing guidance.
- **Category**: kebab-case, names the function. May include compound words (`pdf-tools`, `kids-game`).
- **Suffix**: from the locked role-suffix matrix in `naming-policy-v5.md` (carried forward).

Example mappings (for repos that will be renamed in the audit):

| Current | New (proposed) |
|---|---|
| `pdf-tools-app` | `slice-pdf-tools-app` |
| `image-tools-app` | `pixie-image-tools-app` |
| `finance-tools-app` | `tally-finance-tools-app` |

Final brand picks happen via MCQ in the audit.

## What changed from v5

- v5: "no brand prefix in slug, the chirag127/ org is the prefix"
- v6: brand prefix REQUIRED in slug (with the 3 exceptions above)

The v5 rationale (org slug carries the brand) holds for SHORT repo listings where readers see `chirag127/<slug>` together. But in `gh repo list` output, search results, social shares, recruiter scanning, the slug appears alone. v6 adds visible brand identity to each slug.

## Cross-refs

- [naming-policy-v5](./naming-policy-v5.md) — predecessor (status: superseded by v6)
- [multi-target-build](../architecture/multi-target-build.md) — release cadence, deploy gating, sentry, sitemap, dashboard locks
- [per-runtime-framework](../architecture/per-runtime-framework.md) — framework matrix per runtime
- [keep-knowledge-fresh](../../rules/keep-knowledge-fresh.md) — meta-rule that triggered writing this file before continuing the audit
