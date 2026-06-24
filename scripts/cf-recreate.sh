#!/usr/bin/env bash
# Recreate one CF Pages project: create, build, deploy, bind domain, DNS
# Usage: cf-recreate.sh <proj> <local-path> <domain1> [domain2]
set -u
PROJ="$1"
LOCAL="$2"
DOM1="$3"
DOM2="${4:-}"

ACC="6a6349fe1568743539433bf10f23ffeb"
ZONE="fe8da3c9dd0cb1f1d964e3a94d6098b3"
APP_DIR="c:/D/oriz/repos/$LOCAL"
LOG_DIR="c:/D/oriz/logs/cf-recreate"
mkdir -p "$LOG_DIR"
LOG="$LOG_DIR/$PROJ.log"
: > "$LOG"

step() { echo "=== $1 ===" | tee -a "$LOG"; }
log() { echo "$*" | tee -a "$LOG"; }

CREATED="no"
BUILD="skipped"
DEPLOY="fail"
DEPLOY_URL=""
DOM_BOUND=""
DNS_DONE=""

# Step 1: Create project (Direct Upload, no source) - with retry on 8000000
step "create project $PROJ"
for attempt in 1 2 3 4 5; do
  RESP=$(curl -s -X POST \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    "https://api.cloudflare.com/client/v4/accounts/$ACC/pages/projects" \
    -d "{\"name\":\"$PROJ\",\"production_branch\":\"main\"}")
  echo "attempt=$attempt $RESP" >> "$LOG"
  if echo "$RESP" | grep -qE '"success":[[:space:]]*true'; then CREATED="yes"; break; fi
  # If error is "project exists", treat as success
  if echo "$RESP" | grep -q "already exists"; then CREATED="exists"; break; fi
  CREATED="fail"
  sleep 2
done

# Step 2: Build (if no dist) - we'll check first
step "build $APP_DIR"
if [ ! -d "$APP_DIR/dist" ] || [ -z "$(ls -A "$APP_DIR/dist" 2>/dev/null)" ]; then
  cd "$APP_DIR" || { log "MISSING DIR"; BUILD="missing-dir"; }
  if [ -f package.json ]; then
    if pnpm run build >>"$LOG" 2>&1; then
      BUILD="ok"
    else
      BUILD="fail"
      log "build failed - creating placeholder"
      mkdir -p "$APP_DIR/dist"
      cat > "$APP_DIR/dist/index.html" <<EOF
<!DOCTYPE html><html><head><title>$PROJ - Coming soon</title><meta charset="utf-8"></head>
<body><h1>Coming soon</h1><p>This app is being built. <a href="https://oriz.in">Back to oriz.in</a></p></body></html>
EOF
    fi
  fi
else
  BUILD="existing-dist"
fi

# Step 3: Deploy via wrangler
step "deploy"
if [ -d "$APP_DIR/dist" ] && [ -n "$(ls -A "$APP_DIR/dist" 2>/dev/null)" ]; then
  cd "$APP_DIR"
  DEPLOY_OUT=$(npx --yes wrangler@latest pages deploy dist --project-name="$PROJ" --branch=main --commit-dirty=true 2>&1)
  echo "$DEPLOY_OUT" >> "$LOG"
  DEPLOY_URL=$(echo "$DEPLOY_OUT" | grep -oE 'https://[a-z0-9-]+\.'"$PROJ"'\.pages\.dev' | head -1)
  if [ -z "$DEPLOY_URL" ]; then
    DEPLOY_URL=$(echo "$DEPLOY_OUT" | grep -oE 'https://[a-z0-9.-]+\.pages\.dev' | head -1)
  fi
  if [ -n "$DEPLOY_URL" ]; then DEPLOY="ok"; else DEPLOY="fail"; fi
fi

# Step 4: Bind custom domain(s)
step "bind domains"
bind_domain() {
  local DOM="$1"
  for a in 1 2 3 4 5; do
    sleep 0.4
    local R
    R=$(curl -s -X POST \
      -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
      -H "Content-Type: application/json" \
      "https://api.cloudflare.com/client/v4/accounts/$ACC/pages/repos/$PROJ/domains" \
      -d "{\"name\":\"$DOM\"}")
    echo "bind a=$a $R" >> "$LOG"
    if echo "$R" | grep -qE '"success":[[:space:]]*true'; then echo "ok"; return; fi
    if echo "$R" | grep -qiE "already (exists|associated)"; then echo "exists"; return; fi
    sleep 1
  done
  echo "fail"
}
B1=$(bind_domain "$DOM1")
DOM_BOUND="$DOM1=$B1"
if [ -n "$DOM2" ]; then
  B2=$(bind_domain "$DOM2")
  DOM_BOUND="$DOM_BOUND;$DOM2=$B2"
fi

# Step 5: Update/create DNS CNAME
step "dns"
upsert_dns() {
  local DOM="$1"
  local SUB="${DOM%.oriz.in}"
  if [ "$DOM" = "oriz.in" ]; then SUB="@"; fi
  sleep 0.3
  # Find existing
  local EX
  EX=$(curl -s -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records?name=$DOM&type=CNAME")
  echo "$EX" >> "$LOG"
  local ID
  ID=$(echo "$EX" | python -c "import sys,json; d=json.load(sys.stdin); r=d.get('result',[]); print(r[0]['id'] if r else '')" 2>/dev/null)
  local TARGET="$PROJ.pages.dev"
  sleep 0.3
  if [ -n "$ID" ]; then
    local R
    R=$(curl -s -X PATCH \
      -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
      -H "Content-Type: application/json" \
      "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records/$ID" \
      -d "{\"type\":\"CNAME\",\"name\":\"$DOM\",\"content\":\"$TARGET\",\"proxied\":true,\"ttl\":1}")
    echo "$R" >> "$LOG"
    if echo "$R" | grep -qE '"success":[[:space:]]*true'; then echo "patched"; else echo "patch-fail"; fi
  else
    local R
    R=$(curl -s -X POST \
      -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
      -H "Content-Type: application/json" \
      "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records" \
      -d "{\"type\":\"CNAME\",\"name\":\"$DOM\",\"content\":\"$TARGET\",\"proxied\":true,\"ttl\":1}")
    echo "$R" >> "$LOG"
    if echo "$R" | grep -qE '"success":[[:space:]]*true'; then echo "created"; else echo "create-fail"; fi
  fi
}
D1=$(upsert_dns "$DOM1")
DNS_DONE="$DOM1=$D1"
if [ -n "$DOM2" ]; then
  D2=$(upsert_dns "$DOM2")
  DNS_DONE="$DNS_DONE;$DOM2=$D2"
fi

# Output one CSV line for aggregation
LINE="RESULT,$PROJ,$CREATED,$BUILD,$DEPLOY,$DEPLOY_URL,$DOM_BOUND,$DNS_DONE"
echo "$LINE"
echo "$LINE" >> c:/D/oriz/logs/cf-recreate/_master.csv
