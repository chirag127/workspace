---
type: decision
title: "Secrets workflow: sops+age primary, Doppler ALONGSIDE for runtime sync (hybrid)"
description: Sops+age source of truth. Doppler parallel CI sync only
tags: [decision, secrets, sops, age, doppler, hybrid, env-management]
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
related:
  - security/env-single-source-auto-push
  - rules/org-level-secrets-only-no-per-repo
  - rules/no-card-on-file
  - branding/oriz-org-rename-from-co
---

# Secrets workflow — sops+age primary, Doppler for runtime sync

## Decision

Two-layer setup:

1. **Source of truth: `.env` (gitignored, local) + `.env.enc` (sops+age encrypted, committed)**
   - `.env` has 326 lines, 134 comments, grouped sections ("# === Cloudflare ===" / "# === Firebase ===" etc.). This structure has real navigational value with 65 keys.
   - Age key lives in Bitwarden CLI (`bw get item age-key`); never committed.
   - Frequent edits happen on the local `.env` directly. Periodic snapshot: `sops -e .env > .env.enc && git commit`.

2. **Runtime sync to GitHub Actions: Doppler ALONGSIDE**
   - One Doppler project, one config, one GitHub Actions sync with `sync_target=org` pointing at `oriz-org` with `visibility=all`. This stays within the free-tier 5-sync cap.
   - After a local `.env` edit, run `doppler secrets upload .env --silent` to refresh Doppler. Doppler then auto-pushes to every oriz-org/* repo's secrets.
   - Replaces the daily `sync-env-to-org-secrets.yml` workflow (one less moving piece in the umbrella).

## Why not Doppler as source of truth

Doppler's secret store is a flat key-value map. It does **not** preserve:
- Comments (134 in our .env)
- Section ordering
- Blank-line separators
- Heredoc multi-line values

For a 65-key .env with section grouping, this is a real loss. The dashboard's tag/search features partially compensate but can't recreate inline `# === Section ===` headers.

## Why not pure sops+age (status quo)

Frequent .env edits today require encrypt + commit + workflow run + 65 GitHub Actions API calls. Doppler's `doppler secrets upload` is a single command that auto-fans-out via the integration — zero extra commits, faster CI propagation, browser editing as a fallback.

## Why not delete oriz-org and run pure-personal

Doppler's GitHub integration has only `sync_target = org | repo`. No `user` target. Going personal-only would force 75 repo-level syncs ? blow past the 5-sync free-tier cap ? forced onto Team plan ($21/user/mo, $252/year) ? violates `[[no-card-on-file]]`. This is the load-bearing reason `oriz-org` stays alive. See research workflow `wf_a4581bfc-18c` (2026-06-24).

## Audit / rotation triggers (when to revisit)

This workflow stays locked unless:
1. A second human needs workspace access (Doppler free tier covers 3 users, friction lower than handing them an age key)
2. Auto-rotation matters (AWS IAM keys, DB passwords) — Doppler offers it on Team tier ($21/user/mo); evaluate when first credential gets compromised
3. Doppler's free tier changes materially (track via the pricing page)

## Cross-refs

- env single-source rule: [[security/env-single-source-auto-push]]
- Org-level secrets rule: [[rules/org-level-secrets-only-no-per-repo]]
- No-card-on-file constraint: [[rules/no-card-on-file]]
- The org we depend on: [[branding/oriz-org-rename-from-co]]
