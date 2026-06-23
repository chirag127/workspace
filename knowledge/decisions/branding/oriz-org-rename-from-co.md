---
type: decision
title: "Rename oriz-co → oriz-org (GitHub organization)"
description: "The GitHub org created 2026-06-22 as oriz-co is renamed to oriz-org because oriz-org reads more naturally as 'oriz the organization' and is available. GitHub auto-redirects oriz-co/* URLs to oriz-org/*; all 23 tracked references (.gitmodules, workflows, knowledge docs) are sed-rewritten in the same commit."
tags: [branding, github, org, rename, identity]
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
supersedes:
  - decisions/branding/keep-oriz-co-not-oriz-in
related:
  - decisions/architecture/projects-owner-own-forks-layout
  - rules/github-org-level-secrets
  - rules/profile-readme-cross-link
  - runbooks/migrate-to-oriz-org
---

# Rename oriz-co → oriz-org

## Decision

The GitHub org `oriz-co` is renamed to `oriz-org`. Both `oriz` (real
user since 2010) and `oriz-in` (squatted 2020) remain unavailable;
`oriz-org` was confirmed available on 2026-06-24 and chosen for its
clearer 'oriz the organization' read.

## Why now (only 2 days after creating oriz-co)

The cost of correcting the name is small and shrinks fast:

- GitHub auto-redirects old org URLs forever after rename
- `git remote set-url` is one `sed` over `.gitmodules`
- 23 tracked references update in one commit
- Postponing means more references to rewrite later, not fewer

## What GitHub redirects (automatic)

- `github.com/oriz-co/*` → `github.com/oriz-org/*`
- API URLs `api.github.com/orgs/oriz-co/*` → `oriz-org/*`
- `git clone https://github.com/oriz-co/<repo>.git` still works

## What GitHub does NOT redirect

- **Git remotes in already-cloned repos** must be updated locally
  (`git remote set-url`). The umbrella's `.gitmodules` is the source
  of truth — once that's sed-rewritten and committed, fresh clones
  pick up the new URL.
- **GitHub Actions org-level secrets** belong to the org, so they
  follow the rename automatically — no re-push of 61 secrets needed.
- **Membership invitations** issued before the rename may show the
  old name in pending state; resend if needed.

## Files updated in this rename

23 tracked files reference `oriz-co`:

- `.gitmodules` (74 submodule URLs)
- `.github/workflows/codeberg-mirror.yml`
- `.github/workflows/sync-env-to-org-secrets.yml`
- `README.md`
- 13 files under `knowledge/`
- 2 files under `scripts/`

## What's NOT renamed

- Repo slugs themselves — `oriz-co/oriz-cipher-crypto-tools-app`
  becomes `oriz-org/oriz-cipher-crypto-tools-app`. Repo slugs keep
  the `oriz-` prefix because the *brand* didn't change; only the
  org-name suffix did.
- npm scope — packages stay scoped `@chirag127/*` per
  [`repo-naming-suffixes`](repo-naming-suffixes.md). No move to
  `@oriz/*` or `@oriz-org/*` in this change.
- The `oriz-cs-me-app` repo is moved separately to `chirag127/cs-me-app`
  (see [`cs-me-app-moved-to-chirag127`](cs-me-app-moved-to-chirag127.md))
  because it's personal-only with puter.js auth, not brand auth.

## Recruiter angle

Renaming to `oriz-org` makes the org name read as a brand-plus-suffix
(`oriz` is the brand; `-org` clarifies it's the GitHub organization).
Combined with the cross-link from chirag127's profile README (see
[`rules/profile-readme-cross-link`](../../rules/profile-readme-cross-link.md)),
a recruiter who lands on either surface sees both.

## Rollback path

If the rename causes downstream breakage, `oriz-co` can be reclaimed
within 90 days (GitHub holds renamed org names) — re-rename in the
UI. Re-sed the 23 references. ~10 min total.
