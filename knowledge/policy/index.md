---
type: index
title: "Family-wide policies"
description: "Index of policy concept files governing content, privacy, monetisation, secrets, and commercial-use boundaries across the oriz family."
tags: [index, policy]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
---

# Family-wide policies

Each policy here applies across every site, extension, and shared
package in the `chirag127/oriz*` family. Site-scoped overrides live in
the relevant submodule's `knowledge/policy/`. When a policy file
contradicts a recent chat decision, the chat wins and the file is
updated in the same conversation (per the
[self-update rule](../rules/self-update-rule.md)).

## The policies

| File | One-liner |
|---|---|
| [`age-gating.md`](./age-gating.md) | Adult-content sections require an 18+ cookie attestation; reviewed annually against UK / EU / IN / AU law. |
| [`public-private-line.md`](./public-private-line.md) | Four visibility tiers — public, age-gated-18, aggregates-only, private. Inner-life metrics surface only as weekly aggregates. |
| [`monetisation.md`](./monetisation.md) | Single AdSense apex application for `oriz.in`; no ad-slot divs in markup; Ezoic / Mediavine as fallback. |
| [`ingester-contract.md`](./ingester-contract.md) | Six properties every lifestream ingester must satisfy (idempotent, backfill-capable, 7-day auto-pause, status-reporting, bounded, no inline secrets). |
| [`journal-not-public.md`](./journal-not-public.md) | `me.oriz.in` never publishes journal text — only numeric aggregates. The journal stays auth-gated at `journal.oriz.in`. |
| [`secrets-handling.md`](./secrets-handling.md) | Every secret comes from envpact; if a secret enters chat, revoke + reissue immediately. |
| [`no-paid-tier.md`](./no-paid-tier.md) | No service in the stack may require a paid subscription or card on file. Free-tier walls fail closed gracefully. |
| [`commercial-use.md`](./commercial-use.md) | Where each host's "commercial intent" line falls; checkout never happens on the landing pages themselves. |
| [`privacy-policy-per-extension.md`](./privacy-policy-per-extension.md) | Each Chrome extension has its own `/privacy` page; family boilerplate at `oriz.in/privacy-base` supplies common content. |
| [`data-canonical-store.md`](./data-canonical-store.md) | The `chirag127/oriz-me-data` git repo is the authoritative store for lifestream events; cloud DBs are caches. |
| [`archive-allowlist.md`](./archive-allowlist.md) | Audit-trail list of every `chirag127` repo that archive scripts MUST refuse to touch — submodules, npm-published packages, MCP servers, and the master. Built from `.gitmodules` + npm + manual hand-adds; double-covered by an `oriz-*` prefix check in the script. |

## Annual review

Policies tagged `annual_review: true` in their frontmatter get
re-evaluated each year on Chirag's birthday alongside the
[100-year strategy](../decisions/content/100-year-strategy-locked.md) re-read. The
review either bumps `timestamp` (no substantive change), edits the
rules, or marks the file `status: superseded` and links to its
replacement.

## Cross-refs

- [`../rules/self-update-rule.md`](../rules/self-update-rule.md) — why these files keep up with chat
- [`../rules/no-card-on-file.md`](../rules/no-card-on-file.md) — the rule that drives [`no-paid-tier.md`](./no-paid-tier.md)
- [`../decisions/content/100-year-strategy-locked.md`](../decisions/content/100-year-strategy-locked.md) — the strategy these policies operationalise
