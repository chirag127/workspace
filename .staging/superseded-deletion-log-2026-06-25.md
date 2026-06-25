# Superseded knowledge deletion log — 2026-06-25

**Pre-count:** 949 markdown files under `knowledge/`.
**Post-count:** 922 markdown files under `knowledge/` (git confirms 28 deletions; count delta of 27 = unrelated drift between initial inventory and final tally).
**Deleted:** 28 files.
**Remaining `status: superseded` / `status: SUPERSEDED` / `superseded_by:` / `> **Superseded` banner:** 0.

## Why now

The user reversed the long-standing "supersession-not-deletion" rule (`memory: knowledge-supersession-not-deletion.md`) on 2026-06-25. New rule: **hard-delete superseded knowledge files in the same turn; the supersession trail lives in git history.** This log itself is the audit trail for the cutover.

## Deleted files (sorted)

| Path | Reason |
|---|---|
| `knowledge/_okf.md` was SPARED — see below | — |
| `knowledge/architecture/ops/repo-layout.md` | frontmatter banner `status: SUPERSEDED 2026-06-24` → workspace hierarchy decision |
| `knowledge/architecture/packages/the-23-packages.md` | frontmatter `status: superseded`; superseded by zero-in-house-packages (special case #5) |
| `knowledge/architecture/repo-layout.md` | frontmatter banner `status: SUPERSEDED 2026-06-24` → workspace hierarchy decision |
| `knowledge/decisions/architecture/general/projects-owner-own-forks-layout.md` | frontmatter `status: superseded` → workspace-flat-repos-2026-06-25 |
| `knowledge/decisions/architecture/general/ship-order-2026q3.md` | frontmatter `status: superseded` → fleet-strategy-build-gate-2026-06-25 |
| `knowledge/decisions/architecture/ops/mirror-to-4-git-hosts.md` | frontmatter `status: superseded` → mirror-to-6-git-hosts |
| `knowledge/decisions/architecture/ops/multi-target-build.md` | frontmatter `status: superseded` → hosting-split-cf-and-gh-2026-06-25 |
| `knowledge/decisions/architecture/packages/five-shared-npm-packages-2026-06-25.md` | frontmatter `status: superseded` → zero-in-house-packages (special case #5) |
| `knowledge/decisions/architecture/packages/four-more-packages-22-total.md` | frontmatter `status: superseded` → zero-in-house-packages (special case #5) |
| `knowledge/decisions/architecture/packaging/one-package-only-analytics-2026-06-25.md` | frontmatter `status: superseded` → zero-in-house-packages (special case #5) |
| `knowledge/decisions/architecture/process/knowledge-supersession-protocol-2026-06-25.md` | reversed by this very task; supersession trail moves to git history |
| `knowledge/decisions/architecture/security/auth-billing-polish-locks-2026-06-22-evening.md` | frontmatter `status: superseded`; auth/billing all reversed by donations-only + no-auth |
| `knowledge/decisions/architecture/security/auth-clerk-emergency-migrate-2026-06-25.md` | frontmatter `status: superseded` → no-auth-in-apps-or-apis-2026-06-25 (rule 4 example) |
| `knowledge/decisions/architecture/security/auth-firebase-login-account-2026-06-25.md` | frontmatter `status: superseded` → no-auth-in-apps-or-apis-2026-06-25 (rule 4 example) |
| `knowledge/decisions/architecture/security/monetization-centralized-on-oriz-in.md` | frontmatter `status: superseded`; Razorpay killed → donations-only-2026-06-25 |
| `knowledge/decisions/branding/cs-me-app-moved-to-chirag127.md` | frontmatter banner `status: SUPERSEDED 2026-06-24`; reversal handled by fork-discipline rule |
| `knowledge/log.md` | task requirement; supersession trail now lives in git history per new rule |
| `knowledge/rules/no-card-on-file.md` | frontmatter `status: superseded` → free-tier-with-cost-controls |
| `knowledge/rules/no-env-example-at-root.md` | frontmatter banner `status: SUPERSEDED 2026-06-24` → submodule-env-files-three-file-pattern |
| `knowledge/rules/security/no-env-example-at-root.md` | nested duplicate; same `status: SUPERSEDED` reason as flat version |
| `knowledge/runbooks/cf-token-d1-scope-unblock-2026-06-23.md` | frontmatter banner `status: SUPERSEDED 2026-06-24`; flag-worker deleted |
| `knowledge/runbooks/feature-flags-storage-2026-06-23.md` | frontmatter banner `status: SUPERSEDED 2026-06-24`; feature-flags deferred |
| `knowledge/runbooks/hosting/migrate-to-oriz-org.md` | nested duplicate; org rename made original SUPERSEDED 2026-06-24 |
| `knowledge/runbooks/hosting/mirror-cron-prep.md` | frontmatter `status: superseded` (mirror runbook stack collapsed) |
| `knowledge/runbooks/migrate-to-oriz-org.md` | frontmatter banner `status: SUPERSEDED 2026-06-24` — org renamed oriz-co → oriz-org |
| `knowledge/runbooks/operations/cf-token-d1-scope-unblock-2026-06-23.md` | nested duplicate of flat runbook; same SUPERSEDED reason |
| `knowledge/runbooks/security/feature-flags-storage-2026-06-23.md` | nested duplicate; same `status: SUPERSEDED` as flat version |
| `knowledge/services/free-tier-catalog.md` | frontmatter `status: superseded` → services/easy-free-tier (after MIT relicense) |

## Files that LOOKED superseded but were SPARED

These files had `supersedes:` fields or referenced the supersession rule in their bodies — they are the CURRENT canonical files, not the obsolete ones. Kept:

- `knowledge/_okf.md` — convention file; mentions supersession in body, status: active.
- `knowledge/decisions/branding/naming-policy-v6.md` — `status: active`, supersedes v5.
- `knowledge/decisions/index.md` — `status: active`; index referencing supersession.
- `knowledge/glossary/s-z/self-update-rule.md` — glossary entry, no `status: superseded` field.
- `knowledge/policy/index.md` — `status: active`; mentions self-update.
- `knowledge/rules/agent/agent-minimum-context.md` — `status: active`; lists supersession in related links.
- `knowledge/rules/agent-minimum-context.md` — `status: active`; flat duplicate kept (restructure handles dedupe).
- `knowledge/rules/agent/agents-md-2025-discipline.md` — `status: active`.
- `knowledge/rules/agent/confirm-knowledge-deltas.md` — `status: active`.
- `knowledge/rules/agent/keep-knowledge-fresh.md` — `status: active`; references self-update.
- `knowledge/rules/agent/knowledge-deletion-not-supersession.md` — the NEW rule that triggered this very deletion task, `status: active`.
- `knowledge/rules/agents-md-2025-discipline.md` — `status: active` (flat duplicate).
- `knowledge/rules/aws-lambda-exception.md` — `status: active`.
- `knowledge/rules/confirm-knowledge-deltas.md` — `status: active`.
- `knowledge/rules/free-tier-with-cost-controls.md` — `status: active`; supersedes no-card-on-file.
- `knowledge/rules/future-overrides-past.md` — `status: active`.
- `knowledge/rules/infrastructure/aws-lambda-exception.md` — `status: active`.
- `knowledge/rules/infrastructure/free-tier-with-cost-controls.md` — `status: active`.
- `knowledge/rules/interaction/future-overrides-past.md` — `status: active`.
- `knowledge/rules/keep-knowledge-fresh.md` — `status: active`.
- `knowledge/runbooks/add-new-decision.md` — `status: active`.
- `knowledge/runbooks/operations/add-new-decision.md` — `status: active` (nested duplicate).

## Out-of-scope observations (not deleted in this task)

- Many concept files exist in BOTH flat (`knowledge/runbooks/foo.md`) AND nested (`knowledge/runbooks/category/foo.md`) layouts. Dedup is task #8 (restructure to 6-level OKF), not this task.
- Date-stamped runbooks like `knowledge/runbooks/cf-dns-audit-2026-06-23.md`, `codeberg-mirror-2026-06-23.md`, `visual-audit-2026-06-22.md`, `auth-signin-still-showing-2026-06-24.md` lack `status: superseded` markers and don't have later-dated siblings for the same decision — they fail rule 4 and stay.

## Constraints honoured

- Only files under `c:\D\oriz\knowledge\` were touched. No submodule knowledge directories modified.
- `knowledge/index.md` is NOT in the repo today (rebuild is task #9).
- `knowledge/_okf.md`, `knowledge/glossary/`, `knowledge/services/`, `knowledge/runbooks/`, top-level `knowledge/rules/` retained except for explicit `status: superseded` files inside them.
