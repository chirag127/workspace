#!/usr/bin/env bash
# set-org-secrets-from-doppler.sh
#
# For every key listed in templates/.env.example, pull the value from
# Doppler and set it as a chirag127-org-level GitHub Actions secret with
# `gh secret set --org chirag127 --visibility all`. Idempotent.
#
# Locked rule: knowledge/rules/github-org-level-secrets.md
# Locked decision: knowledge/decisions/security/env-and-secrets-single-source.md
# Companion runbook: knowledge/runbooks/set-github-org-level-secrets.md
#
# Usage:
#   bash scripts/set-org-secrets-from-doppler.sh             # set all keys
#   bash scripts/set-org-secrets-from-doppler.sh --dry-run   # print what WOULD happen
#   bash scripts/set-org-secrets-from-doppler.sh --only KEY1 [--only KEY2 ...]
#
# Requires:
#   - `gh`     auth'd with admin on the chirag127 org      (gh auth status)
#   - `doppler` auth'd against the user's workplace        (doppler whoami)
#
# Bash + Windows Git Bash compatible.

set -euo pipefail

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

DRY_RUN=0
ORG="chirag127"
DOPPLER_CONFIG="${DOPPLER_CONFIG:-prd}"
ONLY_KEYS=()

while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run) DRY_RUN=1 ;;
        --only)
            shift
            [ $# -gt 0 ] || { echo "--only needs a KEY argument" >&2; exit 2; }
            ONLY_KEYS+=("$1")
            ;;
        --org)
            shift
            [ $# -gt 0 ] || { echo "--org needs a value" >&2; exit 2; }
            ORG="$1"
            ;;
        --config)
            shift
            [ $# -gt 0 ] || { echo "--config needs a value" >&2; exit 2; }
            DOPPLER_CONFIG="$1"
            ;;
        -h|--help)
            sed -n '2,21p' "$0"
            exit 0
            ;;
        *)
            echo "Unknown flag: $1" >&2
            exit 2
            ;;
    esac
    shift
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MASTER="$REPO_ROOT/templates/.env.example"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

log()  { printf '[set-org-secrets] %s\n' "$*"; }
warn() { printf '[set-org-secrets][WARN] %s\n' "$*" >&2; }
die()  { printf '[set-org-secrets][ERROR] %s\n' "$*" >&2; exit 1; }

# Is KEY in the --only list?  When --only was never passed, treat ALL as included.
in_only() {
    local k="$1"
    if [ "${#ONLY_KEYS[@]}" -eq 0 ]; then
        return 0
    fi
    local x
    for x in "${ONLY_KEYS[@]}"; do
        [ "$x" = "$k" ] && return 0
    done
    return 1
}

# ---------------------------------------------------------------------------
# Pre-flight
# ---------------------------------------------------------------------------

cd "$REPO_ROOT"

[ -f "$MASTER" ] || die "templates/.env.example not found at $MASTER"

command -v gh >/dev/null 2>&1      || die "gh CLI not found in PATH"
command -v doppler >/dev/null 2>&1 || die "doppler CLI not found in PATH"

if ! gh auth status >/dev/null 2>&1; then
    die "gh is not authenticated. Run: gh auth login"
fi

if ! doppler whoami >/dev/null 2>&1; then
    die "doppler is not authenticated. Run: doppler login"
fi

log "Repo root: $REPO_ROOT"
log "Master:    $MASTER"
log "Org:       $ORG"
log "Doppler config: $DOPPLER_CONFIG"
[ "$DRY_RUN" -eq 1 ] && log "Mode: DRY RUN (no writes)"
if [ "${#ONLY_KEYS[@]}" -gt 0 ]; then
    log "Filter (--only): ${ONLY_KEYS[*]}"
fi

# ---------------------------------------------------------------------------
# Main loop — read every KEY=  line from master, push value to org secrets.
# ---------------------------------------------------------------------------

set_count=0
skip_count=0
miss_count=0

while IFS= read -r line || [ -n "$line" ]; do
    # Tolerate blank lines (shouldn't be any; the rule says no comments either).
    line="${line%$'\r'}"   # strip CR if Windows line-endings sneak in
    [ -z "$line" ] && continue
    case "$line" in
        \#*) continue ;;   # ignore stray comment if one ever sneaks in
    esac

    # Extract KEY from "KEY=" or "KEY=value".
    key="${line%%=*}"
    [ -z "$key" ] && continue

    if ! in_only "$key"; then
        skip_count=$((skip_count + 1))
        continue
    fi

    # Pull value from Doppler. Allow miss (key may not yet be in Doppler).
    if ! value="$(doppler secrets get "$key" --plain --config "$DOPPLER_CONFIG" 2>/dev/null)"; then
        warn "Doppler has no value for $key — skipping"
        miss_count=$((miss_count + 1))
        continue
    fi

    if [ -z "$value" ]; then
        warn "Doppler value for $key is empty — skipping"
        miss_count=$((miss_count + 1))
        continue
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        printf '  DRY: gh secret set %s --org %s --visibility all  (value length=%d)\n' \
            "$key" "$ORG" "${#value}"
    else
        printf '  RUN: gh secret set %s --org %s --visibility all\n' "$key" "$ORG"
        if ! printf '%s' "$value" | gh secret set "$key" --org "$ORG" --visibility all >/dev/null; then
            warn "gh secret set failed for $key"
            miss_count=$((miss_count + 1))
            continue
        fi
    fi
    set_count=$((set_count + 1))

    # Scrub the value variable promptly.
    unset value
done < "$MASTER"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

printf '\n'
log "Summary:"
log "  set:     $set_count"
log "  skipped: $skip_count   (filtered out by --only)"
log "  missed:  $miss_count   (no value in Doppler / empty / API failure)"

if [ "$DRY_RUN" -eq 1 ]; then
    printf '\n'
    log "DRY RUN — no writes performed. Re-run without --dry-run to apply."
    exit 0
fi

printf '\n'
log "DONE. Next steps (NOT executed by this script):"
log "  1. Verify: gh secret list --org $ORG --json name,visibility,updatedAt"
log "  2. Diff that list against the keys in templates/.env.example."
log "  3. See runbook: knowledge/runbooks/set-github-org-level-secrets.md"
