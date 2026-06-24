#!/bin/bash
# Emergency: recreate missing CF Pages projects after a dead agent left zone in a bad state
# Reads CLOUDFLARE_API_TOKEN from env (decrypt .env.enc first: pnpm run env:decrypt)
TOKEN="${CLOUDFLARE_API_TOKEN:?must export CLOUDFLARE_API_TOKEN}"
ACCOUNT="${CLOUDFLARE_ACCOUNT_ID:-6a6349fe1568743539433bf10f23ffeb}"
ZONE="${CLOUDFLARE_ZONE_ID:-fe8da3c9dd0cb1f1d964e3a94d6098b3}"

create_project() {
  local proj=$1
  local repo=$2
  curl -s -X POST "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT/pages/projects" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"name\": \"$proj\",
      \"production_branch\": \"main\",
      \"source\": {
        \"type\": \"github\",
        \"config\": {
          \"owner\": \"oriz-org\",
          \"repo_name\": \"$repo\",
          \"production_branch\": \"main\",
          \"pr_comments_enabled\": false,
          \"deployments_enabled\": true,
          \"preview_deployment_setting\": \"none\"
        }
      },
      \"build_config\": {
        \"build_command\": \"pnpm run build\",
        \"destination_dir\": \"dist\",
        \"root_dir\": \"\"
      },
      \"deployment_configs\": {
        \"production\": {\"env_vars\": {}, \"compatibility_date\": \"2024-09-23\"}
      }
    }" | python3 -c "
import sys,json
try:
    r=json.load(sys.stdin)
    if r.get('success'):
        print(f'  ✓ $proj created')
    else:
        errs=r.get('errors',[])
        print(f'  ✗ $proj: {errs[0].get(\"message\",\"?\") if errs else \"unknown\"}')
except: print(f'  ✗ $proj: parse error')
"
  sleep 0.4
}

bind_domain() {
  local proj=$1
  local domain=$2
  curl -s -X POST "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT/pages/repos/$proj/domains" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"$domain\"}" | python3 -c "
import sys,json
try:
    r=json.load(sys.stdin)
    if r.get('success'):
        print(f'  ✓ bound $domain → $proj')
    else:
        errs=r.get('errors',[])
        print(f'  - $domain → $proj: {errs[0].get(\"message\",\"?\") if errs else \"unknown\"}')
except: print(f'  ✗ $domain: parse error')
"
  sleep 0.3
}

upsert_cname() {
  local sub=$1
  local target=$2
  # Find existing record
  local rid=$(curl -s "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records?name=$sub.oriz.in" \
    -H "Authorization: Bearer $TOKEN" | python3 -c "
import sys,json
r=json.load(sys.stdin)
recs=r.get('result',[])
print(recs[0]['id'] if recs else '')
" 2>/dev/null)

  if [ -n "$rid" ]; then
    # Update existing
    curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records/$rid" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"type\":\"CNAME\",\"name\":\"$sub\",\"content\":\"$target\",\"proxied\":true,\"ttl\":1}" > /dev/null
    echo "  ↻ $sub.oriz.in → $target (updated)"
  else
    # Create new
    curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"type\":\"CNAME\",\"name\":\"$sub\",\"content\":\"$target\",\"proxied\":true,\"ttl\":1}" > /dev/null
    echo "  + $sub.oriz.in → $target (new)"
  fi
  sleep 0.2
}

echo "=== PHASE 1: Create missing CF Pages projects ==="
create_project oriz-app oriz-app
create_project oriz-cs-me oriz-cs-me-app
create_project oriz-financial-cards oriz-financial-cards-app
create_project oriz-janaushdhi oriz-janaushdhi-app
create_project oriz-lore oriz-lore-app
create_project oriz-ncert oriz-ncert-app
create_project oriz-omni-post oriz-omni-post-app
create_project oriz-packages-catalog oriz-packages-catalog-app
create_project oriz-pages-blog oriz-pages-blog-app
create_project oriz-roam-journal oriz-roam-journal-app
create_project oriz-cipher-crypto oriz-cipher-crypto-tools-app
create_project oriz-dice-random oriz-dice-random-tools-app
create_project oriz-echo-audio oriz-echo-audio-tools-app
create_project oriz-forge-dev oriz-forge-dev-tools-app
create_project oriz-grid-qr oriz-grid-qr-tools-app
create_project oriz-paisa-finance oriz-paisa-finance-tools-app

echo ""
echo "=== PHASE 2: Bind domains to all 26 projects ==="
bind_domain oriz-app oriz.in
bind_domain oriz-app www.oriz.in
bind_domain oriz-cs-me me.oriz.in
bind_domain oriz-financial-cards financial-cards.oriz.in
bind_domain oriz-janaushdhi janaushdhi.oriz.in
bind_domain oriz-lore book-lore.oriz.in
bind_domain oriz-ncert books.oriz.in
bind_domain oriz-omni-post omni.oriz.in
bind_domain oriz-packages-catalog packages.oriz.in
bind_domain oriz-pages-blog blog.oriz.in
bind_domain oriz-roam-journal journal.oriz.in
bind_domain oriz-cipher-crypto crypto.oriz.in
bind_domain oriz-dice-random random.oriz.in
bind_domain oriz-echo-audio audio.oriz.in
bind_domain oriz-forge-dev dev.oriz.in
bind_domain oriz-grid-qr qr.oriz.in
bind_domain oriz-paisa-finance finance.oriz.in
bind_domain oriz-paper-print print.oriz.in
bind_domain oriz-pivot-data data.oriz.in
bind_domain oriz-pixie-image image.oriz.in
bind_domain oriz-rank-seo seo.oriz.in
bind_domain oriz-reel-video video.oriz.in
bind_domain oriz-scribe-text text.oriz.in
bind_domain oriz-shift-convert convert.oriz.in
bind_domain oriz-slice-pdf pdf.oriz.in
bind_domain oriz-vitals-health health.oriz.in
bind_domain oriz-status-app status.oriz.in

echo ""
echo "=== PHASE 3: Update/create DNS CNAMEs ==="
upsert_cname "@" oriz-app.pages.dev  # root - won't work, do separately
upsert_cname www oriz-app.pages.dev
upsert_cname me oriz-cs-me.pages.dev
upsert_cname financial-cards oriz-financial-cards.pages.dev
upsert_cname janaushdhi oriz-janaushdhi.pages.dev
upsert_cname book-lore oriz-lore.pages.dev
upsert_cname books oriz-ncert.pages.dev
upsert_cname omni oriz-omni-post.pages.dev
upsert_cname packages oriz-packages-catalog.pages.dev
upsert_cname blog oriz-pages-blog.pages.dev
upsert_cname journal oriz-roam-journal.pages.dev
upsert_cname crypto oriz-cipher-crypto.pages.dev
upsert_cname random oriz-dice-random.pages.dev
upsert_cname audio oriz-echo-audio.pages.dev
upsert_cname dev oriz-forge-dev.pages.dev
upsert_cname qr oriz-grid-qr.pages.dev
upsert_cname finance oriz-paisa-finance.pages.dev
upsert_cname print oriz-paper-print.pages.dev
upsert_cname data oriz-pivot-data.pages.dev
upsert_cname image oriz-pixie-image.pages.dev
upsert_cname seo oriz-rank-seo.pages.dev
upsert_cname video oriz-reel-video.pages.dev
upsert_cname text oriz-scribe-text.pages.dev
upsert_cname convert oriz-shift-convert.pages.dev
upsert_cname pdf oriz-slice-pdf.pages.dev
upsert_cname health oriz-vitals-health.pages.dev
upsert_cname status oriz-status-app.pages.dev

# Apex separately (CNAME flattening)
echo ""
echo "=== Apex oriz.in → oriz-app.pages.dev (CNAME flattening) ==="
APEX_ID=$(curl -s "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records?name=oriz.in&type=CNAME" \
  -H "Authorization: Bearer $TOKEN" | python3 -c "import sys,json; r=json.load(sys.stdin); print(r['result'][0]['id'] if r['result'] else '')")
if [ -n "$APEX_ID" ]; then
  curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records/$APEX_ID" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"type\":\"CNAME\",\"name\":\"oriz.in\",\"content\":\"oriz-app.pages.dev\",\"proxied\":true,\"ttl\":1}" > /dev/null
  echo "  ↻ oriz.in → oriz-app.pages.dev (apex updated)"
fi

echo ""
echo "DONE"
