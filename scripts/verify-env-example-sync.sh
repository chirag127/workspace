#!/usr/bin/env bash
# verify-env-example-sync.sh
#
# Verify that every submodule's .env.example matches templates/.env.example
# at the master chirag127/oriz repo. Used by master CI to fail PRs that
# would land .env.example drift.
#
# Locked rule: knowledge/rules/env-example-synced-from-master.md
# Locked decision: knowledge/decisions/security/env-and-secrets-single-source.md
# Sibling: scripts/sync-env-example.sh
#
# Usage:
#   bash scripts/verify-env-example-sync.sh
#
# Exits 0 if every repo's .env.example matches master; non-zero otherwise.
# Prints the drifting paths + diff hunks on failure.
#
# Bash + Windows Git Bash compatible.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MASTER="$REPO_ROOT/templates/.env.example"
GITMODULES="$REPO_ROOT/.gitmodules"

log()  { printf '[verify-env-example] %s\n' "$*"; }
warn() { printf '[verify-env-example][WARN] %s\n' "$*" >&2; }
die()  { printf '[verify-env-example][ERROR] %s\n' "$*" >&2; exit 1; }

cd "$REPO_ROOT"

[ -f "$MASTER" ]     || die "templates/.env.example not found at $MASTER"
[ -f "$GITMODULES" ] || die ".gitmodules not found at $GITMODULES"

# Reject empty master as a footgun safeguard.
if ! [ -s "$MASTER" ]; then
    die "Master file is empty: $MASTER"
fi

SUBMODULE_PATHS="$(git config --file "$GITMODULES" --get-regexp 'submodule\..*\.path' \
    | awk '{print $2}')"

if [ -z "$SUBMODULE_PATHS" ]; then
    die "No submodule paths found in $GITMODULES"
fi

TARGETS=()

# Master repo root — only included if it has a .env.example file at all.
if [ -f "$REPO_ROOT/.env.example" ]; then
    TARGETS+=("$REPO_ROOT")
fi

while IFS= read -r p; do
    [ -z "$p" ] && continue
    full="$REPO_ROOT/$p"
    [ -d "$full" ] || continue
    [ -f "$full/.env.example" ] || {
        warn "Missing .env.example: $p"
        continue
    }
    TARGETS+=("$full")
done <<EOF
$SUBMODULE_PATHS
EOF

log "Verifying ${#TARGETS[@]} target(s) against $MASTER"

drifted=0
missing=0
ok=0

for tgt_dir in "${TARGETS[@]}"; do
    tgt_file="$tgt_dir/.env.example"
    rel="${tgt_dir#$REPO_ROOT/}"
    [ "$rel" = "$tgt_dir" ] && rel="."

    if [ ! -f "$tgt_file" ]; then
        printf '  MISSING: %s/.env.example\n' "$rel"
        missing=$((missing + 1))
        continue
    fi

    if cmp -s "$MASTER" "$tgt_file"; then
        ok=$((ok + 1))
        continue
    fi

    printf '  DRIFT:   %s/.env.example\n' "$rel"
    drifted=$((drifted + 1))
    diff -u "$MASTER" "$tgt_file" || true
    printf '\n'
done

# Also flag every submodule that has no .env.example at all (separate failure).
while IFS= read -r p; do
    [ -z "$p" ] && continue
    full="$REPO_ROOT/$p"
    [ -d "$full" ] || continue
    if [ ! -f "$full/.env.example" ]; then
        printf '  MISSING: %s/.env.example (file does not exist)\n' "$p"
        missing=$((missing + 1))
    fi
done <<EOF
$SUBMODULE_PATHS
EOF

printf '\n'
log "Summary:"
log "  ok:      $ok"
log "  drifted: $drifted"
log "  missing: $missing"

if [ "$drifted" -eq 0 ] && [ "$missing" -eq 0 ]; then
    log "PASS — every .env.example matches master."
    exit 0
fi

printf '\n'
warn "FAIL — run: bash scripts/sync-env-example.sh"
warn "Then commit + push each touched submodule + bump master pointers."
warn "See: knowledge/runbooks/sync-env-example-to-all-repos.md"
exit 1
