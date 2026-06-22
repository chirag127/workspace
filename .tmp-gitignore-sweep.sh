#!/usr/bin/env bash
# Sweep all submodules to ensure .gitignore has env patterns.
set -u

MASTER="c:/D/oriz"
LOG_DIR="$MASTER/.tmp-sweep-logs"
mkdir -p "$LOG_DIR"

CREATED_LOG="$LOG_DIR/created.txt"
APPENDED_LOG="$LOG_DIR/appended.txt"
SKIPPED_DIRTY_LOG="$LOG_DIR/skipped-dirty.txt"
ALREADY_LOG="$LOG_DIR/already.txt"
SHA_LOG="$LOG_DIR/shas.txt"
ERROR_LOG="$LOG_DIR/errors.txt"
TOUCHED_LOG="$LOG_DIR/touched-paths.txt"

: > "$CREATED_LOG"
: > "$APPENDED_LOG"
: > "$SKIPPED_DIRTY_LOG"
: > "$ALREADY_LOG"
: > "$SHA_LOG"
: > "$ERROR_LOG"
: > "$TOUCHED_LOG"

PATTERNS=(".env" ".env.local" ".env.*.local" ".sops-age-key.txt")

PATHS=$(grep -E "^\s*path = " "$MASTER/.gitmodules" | sed 's/.*path = //')

while IFS= read -r submod; do
  [ -z "$submod" ] && continue
  full="$MASTER/$submod"
  if [ ! -d "$full" ]; then
    echo "MISSING_DIR: $submod" >> "$ERROR_LOG"
    continue
  fi

  gitignore="$full/.gitignore"

  # Check for uncommitted changes (excluding our pending .gitignore change)
  dirty=$(git -C "$full" status --porcelain 2>/dev/null)
  if [ -n "$dirty" ]; then
    echo "$submod :: $dirty" >> "$SKIPPED_DIRTY_LOG"
    echo "SKIP_DIRTY: $submod"
    continue
  fi

  if [ ! -f "$gitignore" ]; then
    # Create new .gitignore with env patterns + standard Node patterns
    cat > "$gitignore" <<'EOF'
node_modules/
dist/
.astro/

# env (synced from master c:/D/oriz/.env via sops + age)
.env
.env.local
.env.*.local
.sops-age-key.txt
EOF
    echo "$submod" >> "$CREATED_LOG"
    echo "CREATED: $submod"
  else
    # Check which patterns are missing
    missing=()
    for p in "${PATTERNS[@]}"; do
      # Use fixed-string grep on whole-line match
      if ! grep -Fxq "$p" "$gitignore"; then
        missing+=("$p")
      fi
    done

    if [ ${#missing[@]} -eq 0 ]; then
      echo "$submod" >> "$ALREADY_LOG"
      echo "ALREADY: $submod"
      continue
    fi

    # Ensure file ends with newline
    if [ -s "$gitignore" ] && [ "$(tail -c1 "$gitignore" | wc -l)" -eq 0 ]; then
      printf '\n' >> "$gitignore"
    fi

    {
      printf '\n# env (synced via sops + age)\n'
      for p in "${missing[@]}"; do
        printf '%s\n' "$p"
      done
    } >> "$gitignore"

    echo "$submod (missing: ${missing[*]})" >> "$APPENDED_LOG"
    echo "APPENDED: $submod"
  fi

  # Commit & push
  git -C "$full" add .gitignore 2>/dev/null
  if git -C "$full" diff --cached --quiet; then
    # No staged changes (shouldn't happen)
    echo "NO_STAGED_AFTER_ADD: $submod" >> "$ERROR_LOG"
    continue
  fi

  if ! git -C "$full" commit -m "chore: ensure .env + .sops-age-key gitignore" >/dev/null 2>>"$ERROR_LOG"; then
    echo "COMMIT_FAIL: $submod" >> "$ERROR_LOG"
    continue
  fi

  sha=$(git -C "$full" rev-parse HEAD)
  echo "$submod $sha" >> "$SHA_LOG"
  echo "$submod" >> "$TOUCHED_LOG"

  # Determine current branch
  branch=$(git -C "$full" rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
    branch="main"
  fi

  if ! git -C "$full" push origin "$branch" >/dev/null 2>>"$ERROR_LOG"; then
    echo "PUSH_FAIL: $submod (branch=$branch)" >> "$ERROR_LOG"
  fi

done <<< "$PATHS"

echo "=== DONE ==="
echo "Created:        $(wc -l < "$CREATED_LOG")"
echo "Appended:       $(wc -l < "$APPENDED_LOG")"
echo "Already:        $(wc -l < "$ALREADY_LOG")"
echo "Skipped dirty:  $(wc -l < "$SKIPPED_DIRTY_LOG")"
echo "Touched total:  $(wc -l < "$TOUCHED_LOG")"
echo "Errors:         $(wc -l < "$ERROR_LOG")"
