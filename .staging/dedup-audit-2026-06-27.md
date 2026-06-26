# Dedup audit — knowledge/ + AGENTS.md + CLAUDE.md

> Date: 2026-06-27
> Scope: structural duplicates, status:superseded leftovers, title/body drift.
> Method: see "Method" section. Output is **report-only** — no auto-deletes.

## Headline numbers

| Finding | Count |
|---|---|
| Duplicate titles (verbatim, ≥2 files share one title) | **7** |
| Files still on disk with `status: superseded` (violates [knowledge-deletion-not-supersession](../knowledge/rules/agent/preferences/knowledge-deletion-not-supersession.md)) | **24** |
| Duplicate descriptions (verbatim) | **3 description strings, 9 files** |

## 1. Duplicate titles (file-pair list)

### 1a. Index/landing collisions — LIKELY OK (different directories)

These are `index.md` landing pages — each directory has its own. Same-title is structural and probably intentional, but worth verifying body divergence.

| Title | Paths |
|---|---|
| `Security` | `knowledge/decisions/architecture/security/index.md`, `knowledge/rules/security/index.md`, `knowledge/runbooks/security/index.md` |
| `Design` | `knowledge/decisions/design/index.md`, `knowledge/rules/design/index.md` |

**Recommendation:** keep — these are area landings. But rename to disambiguate: `Security decisions`, `Security rules`, `Security runbooks`. Same for Design.

### 1b. Real duplicates — SHOULD MERGE/DELETE

| Title | Path A | Path B | Diff status |
|---|---|---|---|
| `"Backblaze B2"` | `knowledge/services/backblaze-b2.md` (status: rejected) | `knowledge/services/storage/backblaze-b2.md` (status: active) | **Contradicts** — one says rejected, other active. The rejected one at top level looks stale. |
| `"Cloudflare R2"` | `knowledge/services/storage/cloudflare-r2.md` (status: rejected) | `knowledge/services/compute/cloudflare-r2.md` (status: active) | **Contradicts** — same product, conflicting status. compute/ is the active spot; storage/ holds the rejected note. |
| `"ImageKit"` | `knowledge/services/image-cdn/imagekit.md` (CDN-fallback) | `knowledge/services/tooling/imagekit.md` (DAM tooling) | **Different roles, but cross-reference exists.** Could merge to one file with two role sections; current dual-file pattern is workable. |
| `"..."` (literal `...` as title — placeholder leak) | `knowledge/decisions/architecture/general/image-host-four-tier.md` | `knowledge/decisions/architecture/image-host-four-tier.md` | **Frontmatter title is literally `"..."`** — YAML serialization corruption in the title field. Body content differs only in trivial backticks/escapes. **Pick one path** (probably keep `general/`, delete the bare one) AND fix the title. |
| `Alternative free-forever backup channels for GitHub code and metadata` | `knowledge/decisions/architecture/ops/alternative-free-backup-channels.md` | `knowledge/decisions/architecture/ops/backup-channels-alternative.md` | **Same content, just trivially reworded.** One should be deleted. Keep `alternative-free-backup-channels.md` (more descriptive slug). |

## 2. Files with `status: superseded` still on disk (24)

Per [`rules/agent/preferences/knowledge-deletion-not-supersession.md`](../knowledge/rules/agent/preferences/knowledge-deletion-not-supersession.md): "When a decision is superseded, git rm the old file in the same commit that adds the new one. Audit trail lives in git history." These violate that rule.

```
knowledge/_okf.md
knowledge/decisions/architecture/infrastructure/cloudflare-pages-apps-only.md
knowledge/decisions/architecture/infrastructure/cloudflare-pages-hosts-every-website-and-app.md
knowledge/decisions/architecture/monetisation/monetization-centralized-on-oriz-in.md
knowledge/decisions/architecture/packaging/one-package-only-analytics.md
knowledge/decisions/architecture/packaging/twenty-two-packages-on-npm.md
knowledge/decisions/architecture/security/auth-clerk-with-emergency-migrate.md
knowledge/decisions/architecture/security/auth-firebase-login-and-account-subdomains.md
knowledge/decisions/branding/naming-policy-v6.md
knowledge/decisions/index.md
knowledge/glossary/s-z/self-update-rule.md
knowledge/rules/agent/agents-md-2025-discipline.md
knowledge/rules/agent/confirm-knowledge-deltas.md
knowledge/rules/agent/keep-knowledge-fresh.md
knowledge/rules/agent/knowledge-deletion-not-supersession.md   ← ironic: the rule itself
knowledge/rules/agent/preferences/env-example-mirrors-env-with-steps.md
knowledge/rules/agent/preferences/fs-flat-always.md
knowledge/rules/agent/preferences/fs-nested-when-large-flat-when-small.md
knowledge/rules/agent/preferences/knowledge-deletion-not-supersession.md
knowledge/rules/infrastructure/aws-lambda-exception.md
knowledge/rules/infrastructure/free-tier-with-cost-controls.md
knowledge/rules/interaction/fs-flat-over-nested.md
knowledge/rules/interaction/future-overrides-past.md
knowledge/runbooks/operations/add-new-decision.md
```

**Suggested action:**
1. **First**, check if `status: superseded` here actually means "deprecated, not deleted" by design (some of these files may be `_okf.md` or index files that legitimately track supersession state metadata, not lifecycle status).
2. For real superseded content: `git rm` and let history serve as the audit trail.
3. For index/glossary files that need a `superseded` lifecycle state: rename the field (e.g. `lifecycle: deprecated`) to avoid colliding with the deletion rule's trigger condition.

**Note:** `knowledge/rules/agent/knowledge-deletion-not-supersession.md` AND `knowledge/rules/agent/preferences/knowledge-deletion-not-supersession.md` both exist — itself a structural duplication. One should be the canonical home.

## 3. Duplicate descriptions

| Description (truncated) | Files |
|---|---|
| `"REJECTED — excluded by user policy."` | `knowledge/services/backblaze-b2.md`, plus one more (see §1b) |
| `Documents alternative free-forever backup channels to protect GitHub…` | both files in §1b row 5 |
| `The absolute best, most minimalist, and fastest stack, frameworks, libraries,…` | 6 files under `knowledge/decisions/architecture/stack/`: `automation.md`, `cli-tools.md`, `extensions.md`, `go.md`, `javascript-typescript.md`, `python.md` |

**The 6 stack files** all share the same boilerplate description but legitimately cover different stacks. Recommendation: customise each description (`Stack — Python (Astral, ruff, uv)`, etc.) so they show distinct cards in any future indexer.

## 4. Title-vs-body contradictions

| File | Title says | Body says |
|---|---|---|
| `knowledge/services/backblaze-b2.md` | "Backblaze B2" (neutral) | "REJECTED — excluded by user policy" — title doesn't telegraph the rejected status |
| `knowledge/services/storage/cloudflare-r2.md` | "Cloudflare R2" (neutral) | "REJECTED — card-on-file requirement" — same issue |
| `knowledge/decisions/architecture/general/image-host-four-tier.md` AND `…/image-host-four-tier.md` | literal `"..."` (placeholder) | Real body about a 4-tier image-host chain — title field broke during YAML serialization |

**Recommendation:** for any service in REJECTED state, prefix the title (e.g. `"Backblaze B2 (rejected)"`) so list-views show the status without opening the file.

## Method (for repeatability)

```bash
cd c:/D/oriz

# 1. Duplicate titles
grep -rh '^title:' knowledge/ AGENTS.md CLAUDE.md 2>/dev/null \
  | sort | uniq -c | sort -rn | head -25

# 2. Files still flagged superseded
grep -lr 'status: superseded' knowledge/ 2>/dev/null

# 3. Duplicate descriptions
grep -rh '^description:' knowledge/ 2>/dev/null \
  | sort | uniq -c | sort -rn | head -15

# 4. For each dup-title pair, diff the bodies
diff <fileA> <fileB>
```

## Summary

- **7 duplicate titles** (3 are intentional area-landings; 5 are real dups or contradictions).
- **24 files** still on disk with `status: superseded` — violates the deletion rule. Some may be legitimately metadata-only and need their YAML field renamed.
- **3 duplicate description strings** spanning **9 files**; 6 are the stack-family boilerplate (low-risk), 3 are real dups.
- **3 title-vs-body contradictions** (two rejected-service files with neutral titles; one with a `"..."` placeholder title from YAML breakage).

**Action items deferred to user** — no auto-deletes performed per the prompt.
