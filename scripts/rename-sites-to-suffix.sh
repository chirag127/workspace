#!/usr/bin/env bash
# rename-sites-to-suffix.sh
#
# Rename every chirag127/oriz-<name> site repo to chirag127/oriz-<name>-site,
# update .gitmodules, sync submodules, and fix each submodule's `origin` URL.
#
# Locked decision: knowledge/decisions/branding/repo-naming-suffixes.md
# Companion runbook: knowledge/runbooks/rename-all-sites-to-suffix.md
#
# Usage:
#   bash scripts/rename-sites-to-suffix.sh            # interactive (pauses between sites)
#   bash scripts/rename-sites-to-suffix.sh --dry-run  # print what WOULD happen, change nothing
#   bash scripts/rename-sites-to-suffix.sh --yes      # skip per-site confirmation prompt
#
# Exits non-zero on the first error. Re-runnable: rename steps that have
# already happened are detected (gh repo view of new name succeeds; old
# URL no longer resolves) and skipped.
#
# Bash + Windows Git Bash compatible. No realpath, no GNU-only flags.

set -euo pipefail

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

DRY_RUN=0
ASSUME_YES=0

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --yes|-y)  ASSUME_YES=1 ;;
        -h|--help)
            sed -n '2,18p' "$0"
            exit 0
            ;;
        *)
            echo "Unknown flag: $arg" >&2
            exit 2
            ;;
    esac
done

OWNER="chirag127"

# Each entry: "<submodule-path>|<old-repo-name>|<new-repo-name>"
# Paths stay as-is (sites/oriz-<name>) per the locked decision; only the
# GitHub remote slug flips.
RENAMES=(
    "sites/oriz-home|oriz-home|oriz-home-site"
    "sites/oriz-blog|oriz-blog|oriz-blog-site"
    "sites/oriz-books|oriz-books|oriz-books-site"
    "sites/oriz-book-lore|oriz-book-lore|oriz-book-lore-site"
    "sites/oriz-cards|oriz-cards|oriz-cards-site"
    "sites/oriz-finance|oriz-finance|oriz-finance-site"
    "sites/oriz-journal|oriz-journal|oriz-journal-site"
    "sites/oriz-urls-to-md|oriz-urls-to-md|oriz-urls-to-md-site"
    "sites/oriz-image-tools|oriz-image-tools|oriz-image-tools-site"
    "sites/oriz-pdf-tools|oriz-pdf-tools|oriz-pdf-tools-site"
    "sites/oriz-me|oriz-me|oriz-me-site"
)

# Resolve repo root from the script's location (no realpath needed).
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GITMODULES="$REPO_ROOT/.gitmodules"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

log()  { printf '[rename-sites] %s\n' "$*"; }
warn() { printf '[rename-sites][WARN] %s\n' "$*" >&2; }
die()  { printf '[rename-sites][ERROR] %s\n' "$*" >&2; exit 1; }

run() {
    # Echo + execute (or echo-only in dry-run).
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '  DRY: %s\n' "$*"
    else
        printf '  RUN: %s\n' "$*"
        eval "$@"
    fi
}

confirm() {
    # $1 = prompt
    if [ "$ASSUME_YES" -eq 1 ] || [ "$DRY_RUN" -eq 1 ]; then
        return 0
    fi
    printf '%s [y/N] ' "$1"
    read -r reply
    case "$reply" in
        y|Y|yes|YES) return 0 ;;
        *)           return 1 ;;
    esac
}

# Already renamed? Detect by checking whether the NEW repo exists
# under chirag127/. Returns 0 if already renamed, 1 otherwise.
already_renamed() {
    local new_name="$1"
    if gh repo view "$OWNER/$new_name" >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

# ---------------------------------------------------------------------------
# Pre-flight
# ---------------------------------------------------------------------------

cd "$REPO_ROOT"

log "Repo root: $REPO_ROOT"
[ "$DRY_RUN" -eq 1 ] && log "Mode: DRY RUN (no changes)"
[ "$ASSUME_YES" -eq 1 ] && log "Mode: --yes (skip per-site prompts)"

[ -f "$GITMODULES" ] || die ".gitmodules not found at $GITMODULES"

command -v gh >/dev/null 2>&1 || die "gh CLI not found in PATH"
command -v git >/dev/null 2>&1 || die "git not found in PATH"

if ! gh auth status >/dev/null 2>&1; then
    die "gh is not authenticated. Run: gh auth login"
fi

# Refuse to run with a dirty master working tree (excluding submodule SHA drift,
# which we'll touch on purpose). `--ignore-submodules=all` keeps untouched
# submodule pointer movement out of the dirty check.
if [ "$DRY_RUN" -eq 0 ]; then
    if ! git -C "$REPO_ROOT" diff-index --quiet --ignore-submodules=all HEAD --; then
        die "Master working tree is dirty. Commit or stash before running."
    fi
fi

log "Pre-flight OK. Will process ${#RENAMES[@]} site repos."

# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------

for entry in "${RENAMES[@]}"; do
    sub_path="${entry%%|*}"
    rest="${entry#*|}"
    old_name="${rest%%|*}"
    new_name="${rest##*|}"

    old_url="https://github.com/$OWNER/$old_name.git"
    new_url="https://github.com/$OWNER/$new_name.git"

    printf '\n'
    log "==== $old_name  ->  $new_name ===="
    log "  path:    $sub_path"
    log "  old URL: $old_url"
    log "  new URL: $new_url"

    # Skip if target name already in use (idempotency).
    if already_renamed "$new_name"; then
        log "  $new_name already exists on GitHub — skipping rename, will only fix URLs."
        SKIP_GH_RENAME=1
    else
        SKIP_GH_RENAME=0
    fi

    if ! confirm "Proceed with $old_name -> $new_name ?"; then
        warn "Skipped by user: $old_name"
        continue
    fi

    # 1. Rename the GitHub repo (creates an automatic redirect for clones).
    if [ "$SKIP_GH_RENAME" -eq 0 ]; then
        run "gh repo rename --repo \"$OWNER/$old_name\" \"$new_name\" --yes"
    fi

    # 2. Update .gitmodules — flip the URL for this submodule path.
    #    Use `git config --file` (not sed) to avoid quoting issues on Windows.
    run "git config --file \"$GITMODULES\" \"submodule.$sub_path.url\" \"$new_url\""

    # 3. Sync submodule config from .gitmodules into .git/config and each subrepo.
    run "git submodule sync -- \"$sub_path\""

    # 4. Update the submodule's local `origin` remote (if cloned).
    if [ -d "$REPO_ROOT/$sub_path/.git" ] || [ -f "$REPO_ROOT/$sub_path/.git" ]; then
        run "git -C \"$REPO_ROOT/$sub_path\" remote set-url origin \"$new_url\""
    else
        warn "  Submodule $sub_path not initialised yet — skipping local remote update."
    fi

    log "  done: $new_name"
done

# ---------------------------------------------------------------------------
# Final sync
# ---------------------------------------------------------------------------

printf '\n'
log "All renames processed. Running full submodule sync + update."
run "git submodule sync --recursive"
run "git submodule update --init --recursive"

log "Stage .gitmodules so the URL flip can be committed:"
run "git add .gitmodules"

printf '\n'
log "DONE. Next steps (NOT executed by this script):"
log "  1. Review:  git diff --cached .gitmodules"
log "  2. Commit:  git commit -m 'chore(submodule): rename all site repos to -site suffix'"
log "  3. Push only after explicit user authorisation."
log "  4. Verify Cloudflare Pages production URLs still resolve (redirects + Pages git binding)."
log "  5. See runbook: knowledge/runbooks/rename-all-sites-to-suffix.md"
