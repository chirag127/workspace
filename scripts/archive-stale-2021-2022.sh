#!/usr/bin/env bash
# archive-stale-2021-2022.sh
#
# Archive chirag127 repos created in 2021/2022 with 0 stars and no push since 18 months ago.
# Reads knowledge/policy/archive-allowlist.md to skip load-bearing repos.
#
# User-locked filter (do not relax without an explicit chat decision):
#   - createdAt in [2021-01-01, 2023-01-01)
#   - stargazerCount == 0
#   - pushedAt < 2024-12-20  (i.e. no push in the last 18 months from 2026-06-20)
#   - not a fork
#   - not already archived
#
# Defense in depth: any repo whose name starts with `oriz-` is hard-skipped
# regardless of whether it's in the allowlist. See policy file for rationale.
#
# Usage:
#   bash scripts/archive-stale-2021-2022.sh --dry-run   # print what WOULD happen
#   bash scripts/archive-stale-2021-2022.sh             # interactive confirm
#   bash scripts/archive-stale-2021-2022.sh --yes       # skip confirm prompt
#
# `gh repo archive` is reversible (gh repo unarchive). `gh repo delete` is
# forbidden by this script.

set -euo pipefail

DRY_RUN=0
ASSUME_YES=0
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --yes|-y)  ASSUME_YES=1 ;;
        -h|--help)
            sed -n '2,22p' "$0"
            exit 0
            ;;
        *) echo "Unknown flag: $arg" >&2; exit 2 ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ALLOWLIST="$REPO_ROOT/knowledge/policy/archive-allowlist.md"

[ -f "$ALLOWLIST" ] || { echo "ERROR: allowlist not found at $ALLOWLIST" >&2; exit 1; }
command -v gh >/dev/null 2>&1 || { echo "ERROR: gh CLI not found" >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "ERROR: gh not authenticated" >&2; exit 1; }

# Build allowlist set: every `chirag127/<name>` mentioned as a bullet in the file.
ALLOWED=$(grep -oE 'chirag127/[a-zA-Z0-9._-]+' "$ALLOWLIST" | sort -u)

echo "Allowlist loaded: $(echo "$ALLOWED" | wc -l | tr -d ' ') entries from $ALLOWLIST"

# Get candidate list: created 2021-01-01..2022-12-31, 0 stars, pushed before 2024-12-20.
echo "Querying gh repo list chirag127 (limit 500)..."
CANDIDATES=$(gh repo list chirag127 --limit 500 \
    --json name,stargazerCount,createdAt,pushedAt,isArchived,isFork \
    --jq '.[] |
        select(.isArchived == false) |
        select(.isFork == false) |
        select(.stargazerCount == 0) |
        select(.createdAt >= "2021-01-01" and .createdAt < "2023-01-01") |
        select(.pushedAt < "2024-12-20") |
        .name')

CAND_COUNT=$(echo "$CANDIDATES" | grep -c . || true)
echo "Raw candidates from gh: $CAND_COUNT"

# Filter against allowlist + oriz- defense-in-depth
FILTERED=()
SKIPPED_ALLOW=0
SKIPPED_ORIZ=0
for repo in $CANDIDATES; do
    full="chirag127/$repo"
    if echo "$ALLOWED" | grep -qx "$full"; then
        echo "[skip-allowlist] $full"
        SKIPPED_ALLOW=$((SKIPPED_ALLOW+1))
        continue
    fi
    case "$repo" in
        oriz-*)
            echo "[skip-oriz-prefix] $full"
            SKIPPED_ORIZ=$((SKIPPED_ORIZ+1))
            continue
            ;;
    esac
    FILTERED+=("$full")
done

echo
echo "Summary:"
echo "  raw candidates:        $CAND_COUNT"
echo "  skipped (allowlist):   $SKIPPED_ALLOW"
echo "  skipped (oriz- prefix):$SKIPPED_ORIZ"
echo "  to archive:            ${#FILTERED[@]}"
echo

if [ "${#FILTERED[@]}" -eq 0 ]; then
    echo "Nothing to archive."
    exit 0
fi

# Show what will be archived
echo "Repos that WILL be archived:"
for r in "${FILTERED[@]}"; do
    echo "  archive: $r"
done

# Confirm unless --yes or --dry-run
if [ "$DRY_RUN" -eq 0 ] && [ "$ASSUME_YES" -eq 0 ]; then
    printf 'Archive %d repos? [y/N] ' "${#FILTERED[@]}"
    read -r ans
    case "$ans" in
        y|Y|yes|YES) ;;
        *) echo "Aborted."; exit 0 ;;
    esac
fi

# Archive
ARCHIVED=0
FAILED=0
for r in "${FILTERED[@]}"; do
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "  DRY: gh repo archive --yes $r"
    else
        echo "  archiving $r..."
        if gh repo archive --yes "$r"; then
            ARCHIVED=$((ARCHIVED+1))
        else
            echo "    FAILED on $r (continuing)"
            FAILED=$((FAILED+1))
        fi
    fi
done

echo
if [ "$DRY_RUN" -eq 1 ]; then
    echo "Dry-run done. Would have archived ${#FILTERED[@]} repos."
else
    echo "Done. Archived: $ARCHIVED  Failed: $FAILED  Skipped (allowlist+oriz-): $((SKIPPED_ALLOW+SKIPPED_ORIZ))"
fi
