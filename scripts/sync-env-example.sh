#!/usr/bin/env bash
# sync-env-example.sh
#
# Sync templates/.env.example from the master chirag127/oriz repo into
# every submodule's .env.example. Master is the single source of truth
# per knowledge/rules/env-example-synced-from-master.md.
#
# Locked decision: knowledge/decisions/security/env-and-secrets-single-source.md
# Companion runbook: knowledge/runbooks/sync-env-example-to-all-repos.md
# Sibling: scripts/verify-env-example-sync.sh
#
# Usage:
#   bash scripts/sync-env-example.sh             # write
#   bash scripts/sync-env-example.sh --dry-run   # print what WOULD happen, change nothing
#
# Exits non-zero on the first error.
#
# Bash + Windows Git Bash compatible. No realpath, no GNU-only flags.

set -euo pipefail

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

DRY_RUN=0

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
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

# Resolve repo root from the script's location (no realpath needed).
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MASTER="$REPO_ROOT/templates/.env.example"
GITMODULES="$REPO_ROOT/.gitmodules"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

log()  { printf '[sync-env-example] %s\n' "$*"; }
warn() { printf '[sync-env-example][WARN] %s\n' "$*" >&2; }
die()  { printf '[sync-env-example][ERROR] %s\n' "$*" >&2; exit 1; }

run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '  DRY: %s\n' "$*"
    else
        printf '  RUN: %s\n' "$*"
        eval "$@"
    fi
}

# ---------------------------------------------------------------------------
# Pre-flight
# ---------------------------------------------------------------------------

cd "$REPO_ROOT"

log "Repo root: $REPO_ROOT"
log "Master:    $MASTER"
[ "$DRY_RUN" -eq 1 ] && log "Mode: DRY RUN (no writes)"

[ -f "$MASTER" ]     || die "templates/.env.example not found at $MASTER"
[ -f "$GITMODULES" ] || die ".gitmodules not found at $GITMODULES"

command -v git >/dev/null 2>&1 || die "git not found in PATH"

# Reject empty master file as a footgun safeguard.
if ! [ -s "$MASTER" ]; then
    die "Master file is empty: $MASTER  (refusing to wipe child .env.example files)"
fi

# ---------------------------------------------------------------------------
# Build the target list — every submodule path + the master repo's own root.
# ---------------------------------------------------------------------------

# Read submodule paths from .gitmodules. Use git config (not sed/awk) so
# Windows Git Bash quoting stays sane.
SUBMODULE_PATHS="$(git config --file "$GITMODULES" --get-regexp 'submodule\..*\.path' \
    | awk '{print $2}')"

if [ -z "$SUBMODULE_PATHS" ]; then
    die "No submodule paths found in $GITMODULES"
fi

TARGETS=()

# Master repo root — keep its own .env.example in sync too. (The master
# is the source, but the file at repo root may also exist for local-dev
# convenience; if so, it's overwritten with the master template, which
# is a no-op when in sync.)
if [ -f "$REPO_ROOT/.env.example" ]; then
    TARGETS+=("$REPO_ROOT")
fi

# Each submodule path.
while IFS= read -r p; do
    [ -z "$p" ] && continue
    full="$REPO_ROOT/$p"
    if [ ! -d "$full" ]; then
        warn "Submodule path missing on disk (not initialised?): $p — skipping"
        continue
    fi
    TARGETS+=("$full")
done <<EOF
$SUBMODULE_PATHS
EOF

log "Targets: ${#TARGETS[@]}"

# ---------------------------------------------------------------------------
# Copy loop
# ---------------------------------------------------------------------------

written=0
unchanged=0
created=0

for tgt_dir in "${TARGETS[@]}"; do
    tgt_file="$tgt_dir/.env.example"
    rel="${tgt_dir#$REPO_ROOT/}"
    [ "$rel" = "$tgt_dir" ] && rel="."

    if [ -f "$tgt_file" ]; then
        if cmp -s "$MASTER" "$tgt_file"; then
            log "  unchanged: $rel/.env.example"
            unchanged=$((unchanged + 1))
            continue
        fi
        log "  updating:  $rel/.env.example"
        run "cp \"$MASTER\" \"$tgt_file\""
        written=$((written + 1))
    else
        log "  creating:  $rel/.env.example"
        run "cp \"$MASTER\" \"$tgt_file\""
        created=$((created + 1))
    fi
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

printf '\n'
log "Summary:"
log "  unchanged: $unchanged"
log "  updated:   $written"
log "  created:   $created"

if [ "$DRY_RUN" -eq 1 ]; then
    printf '\n'
    log "DRY RUN — no files written. Re-run without --dry-run to apply."
    exit 0
fi

printf '\n'
log "DONE. Next steps (NOT executed by this script):"
log "  1. Review each touched submodule:  git submodule foreach 'git diff -- .env.example'"
log "  2. Commit + push each submodule:   git submodule foreach '[ -n \"\$(git status --porcelain -- .env.example)\" ] && git add .env.example && git commit -m \"chore: sync .env.example from master\" && git push origin main || true'"
log "  3. Bump master pointers:           git add sites/* packages/* .gitmodules templates/.env.example && git commit -m 'chore(env): sync .env.example' && git push origin main"
log "  4. Verify:                         bash scripts/verify-env-example-sync.sh"
log "  5. See runbook:                    knowledge/runbooks/sync-env-example-to-all-repos.md"
