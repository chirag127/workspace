---
type: runbook
title: "Rename all 11 site repos to the -site suffix"
description: "One-shot migration: flip every chirag127/oriz-<name> site repo to chirag127/oriz-<name>-site, update .gitmodules, fix each submodule's origin remote, and bump the master pointer. Driven by scripts/rename-sites-to-suffix.sh."
tags: [runbook, rename, repo, submodule, migration, branding]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/branding/repo-naming-suffixes
  - decisions/branding/keep-oriz-add-site-suffix
  - rules/repo-naming
  - runbooks/bump-submodule-pointer
  - runbooks/add-new-site-to-family
  - rules/no-push-without-say-so
---

# Rename all 11 site repos to the `-site` suffix

> One-time migration after the 2026-06-20 lock of
> [`decisions/branding/repo-naming-suffixes.md`](../decisions/branding/repo-naming-suffixes.md).
> Every existing site repo (`chirag127/oriz-<name>`) flips to its new
> `-site` form (`chirag127/oriz-<name>-site`). Submodule **paths** stay
> as `sites/oriz-<name>` for ergonomics — only the remote URL flips.

The work is driven by [`scripts/rename-sites-to-suffix.sh`](../../scripts/rename-sites-to-suffix.sh).
Run from the master repo root (`/c/D/oriz`).

## Repos in scope (11)

| # | Current | Target |
|---|---|---|
| 1 | `chirag127/oriz-home` | `chirag127/oriz-home-site` |
| 2 | `chirag127/oriz-blog` | `chirag127/oriz-blog-site` |
| 3 | `chirag127/oriz-books` | `chirag127/oriz-books-site` |
| 4 | `chirag127/oriz-book-lore` | `chirag127/oriz-book-lore-site` |
| 5 | `chirag127/oriz-cards` | `chirag127/oriz-cards-site` |
| 6 | `chirag127/oriz-finance` | `chirag127/oriz-finance-site` |
| 7 | `chirag127/oriz-journal` | `chirag127/oriz-journal-site` |
| 8 | `chirag127/oriz-urls-to-md` | `chirag127/oriz-urls-to-md-site` |
| 9 | `chirag127/oriz-image-tools` | `chirag127/oriz-image-tools-site` |
| 10 | `chirag127/oriz-pdf-tools` | `chirag127/oriz-pdf-tools-site` |
| 11 | `chirag127/oriz-me` | `chirag127/oriz-me-site` |

Package submodules (`oriz-ui`, `firebase-init`, `auth-ui`, `contact-form`,
`sidebar`, `oriz-family`) are **not** in scope — npm packages stay clean
per the suffix decision.

## Pre-flight checks

Run these before invoking the script.

1. **Clean working tree** in master.

    ```bash
    cd /c/D/oriz
    git status --ignore-submodules=all   # must be clean
    ```

2. **`gh` is authenticated** and has `delete_repo`/`repo` scopes (rename
    requires the `repo` scope; org renames require admin — these are
    user repos so `repo` is enough).

    ```bash
    gh auth status
    ```

3. **Every site submodule is on `main` with a clean tree.** The script
    only touches the remote URL, so dirty trees won't break the rename
    itself, but you don't want to be juggling work-in-progress while
    URLs change.

    ```bash
    for d in sites/oriz-*; do
      printf '== %s ==\n' "$d"
      git -C "$d" status --short
      git -C "$d" rev-parse --abbrev-ref HEAD
    done
    ```

4. **Cloudflare Pages git bindings noted.** `gh repo rename` sets up
    GitHub-side redirects automatically, but Cloudflare Pages stores the
    repo slug at the time the binding was created. Capture each Pages
    project's current binding so you know what to re-bind if a deploy
    fails post-rename.

    ```bash
    wrangler pages project list
    ```

## What the script does (per-site loop, 11 iterations)

For each entry in the rename table the script:

1. Calls `gh repo rename --repo chirag127/<old> <new> --yes`.
   GitHub creates an automatic redirect from the old slug, so existing
   clones, Cloudflare bindings, and external links keep working.
2. Updates `.gitmodules` via `git config --file .gitmodules submodule.<path>.url <new-url>`
   — `git config` rather than `sed` to avoid Windows quoting traps.
3. Runs `git submodule sync -- <path>` to push the new URL into
   `.git/config` and the submodule's own config.
4. In the submodule subdir, runs `git remote set-url origin <new-url>`
   so future pushes go to the new slug rather than relying on GitHub's
   redirect.
5. Echoes progress and pauses for `[y/N]` confirmation between sites
   (suppress with `--yes`).

After the loop the script runs:

- `git submodule sync --recursive`
- `git submodule update --init --recursive`
- `git add .gitmodules` (staged, **not committed**)

The script exits non-zero on the first error (`set -euo pipefail`).
It is **idempotent**: if a target slug already exists on GitHub the
script skips the rename step but still rewrites `.gitmodules` and the
local remote URL.

## How to run

1. **Dry run first.** Prints every command without executing.

    ```bash
    bash /c/D/oriz/scripts/rename-sites-to-suffix.sh --dry-run
    ```

2. **Interactive run.** Pauses between sites for `y/N` confirmation.

    ```bash
    bash /c/D/oriz/scripts/rename-sites-to-suffix.sh
    ```

3. **One-shot run** (skips per-site prompts; pre-flight checks still
   run). Use only after a clean dry run.

    ```bash
    bash /c/D/oriz/scripts/rename-sites-to-suffix.sh --yes
    ```

## Post-rename checklist

1. **Review the staged `.gitmodules` diff.**

    ```bash
    git diff --cached .gitmodules
    ```

2. **Commit the master pointer bump** with a single
   `chore(submodule)` commit — see
   [`bump-submodule-pointer.md`](./bump-submodule-pointer.md).

    ```bash
    git commit -m "chore(submodule): rename all site repos to -site suffix"
    ```

3. **Push master** — only after explicit user authorisation per
   [`rules/no-push-without-say-so.md`](../rules/no-push-without-say-so.md).

    ```bash
    git push origin main
    ```

4. **Verify each Cloudflare Pages production URL still resolves.**

    ```bash
    for sub in oriz-home oriz-blog oriz-books oriz-book-lore oriz-cards \
               oriz-finance oriz-journal oriz-urls-to-md oriz-image-tools \
               oriz-pdf-tools oriz-me; do
      printf '%-25s ' "$sub.oriz.in"
      curl -sS -o /dev/null -w '%{http_code}\n' "https://$sub.oriz.in/"
    done
    ```

    All should return `200`. A `404` here means the Pages git binding
    needs re-attaching to the new repo slug.

5. **Re-attach Cloudflare Pages bindings** if any 404'd. In the
   Cloudflare dashboard for the affected Pages project: Settings →
   Builds & deployments → "Manage" the GitHub binding → re-select the
   new `oriz-<name>-site` repo. Trigger a fresh deploy.

6. **Verify GitHub-side redirects.** A bare `git clone` of the old slug
   should still work and warn about the redirect.

    ```bash
    git ls-remote https://github.com/chirag127/oriz-blog.git | head -n 1
    ```

7. **Update the family list in AGENTS.md** if it pins repo slugs (the
   suffix decision has the canonical table; AGENTS.md should link to
   it rather than duplicate).

## Rollback

`gh repo rename` is reversible — the new slug can be renamed back to
the old slug and GitHub re-establishes redirects in the opposite
direction. Per-site rollback:

```bash
gh repo rename --repo chirag127/oriz-<name>-site oriz-<name> --yes
git config --file .gitmodules \
    submodule.sites/oriz-<name>.url \
    https://github.com/chirag127/oriz-<name>.git
git submodule sync -- sites/oriz-<name>
git -C sites/oriz-<name> remote set-url origin \
    https://github.com/chirag127/oriz-<name>.git
```

Mass rollback: re-run the script with the rename table reversed (edit
the `RENAMES` array so old/new are swapped). Cloudflare Pages bindings
need the same dashboard re-bind treatment in reverse.

## Risks & mitigations

| Risk | Mitigation |
|---|---|
| Cloudflare Pages binding breaks on deploy | Pre-flight notes the current binding; post-rename verification curls each site; re-bind in the dashboard if 404 |
| External link rot | GitHub auto-redirects from old slug; only links that hard-code `raw.githubusercontent.com` blob URLs with a SHA may need rewriting |
| In-flight PRs against the old slug | GitHub auto-migrates open PRs to the new slug; force-push targets unchanged |
| npm package referencing GitHub URL (`@chirag127/oriz-kit` etc.) | Packages aren't being renamed; check `package.json#repository.url` if it points at any of the 11 site repos (it shouldn't) |
| Forgotten Actions secrets / OIDC subjects scoped to old slug | Audit `gh secret list -R` for each new repo after rename; OIDC `sub` claims update automatically since the repo node ID is preserved |

## See also

- [`../decisions/branding/repo-naming-suffixes.md`](../decisions/branding/repo-naming-suffixes.md) — the locking decision
- [`../decisions/branding/keep-oriz-add-site-suffix.md`](../decisions/branding/keep-oriz-add-site-suffix.md) — earlier two-suffix decision this extends
- [`./bump-submodule-pointer.md`](./bump-submodule-pointer.md) — the `chore(submodule)` commit pattern used in step 2
- [`./add-new-site-to-family.md`](./add-new-site-to-family.md) — adding a brand-new `-site` repo (already uses the suffix)
- [`../rules/no-push-without-say-so.md`](../rules/no-push-without-say-so.md)
