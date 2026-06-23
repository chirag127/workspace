#!/usr/bin/env bash
# Run remaining 23 apps. Each line: PROJ|LOCAL|DOM1
# Reads CLOUDFLARE_API_TOKEN + CLOUDFLARE_ACCOUNT_ID from env (decrypt .env.enc first)
: "${CLOUDFLARE_API_TOKEN:?must export CLOUDFLARE_API_TOKEN}"
: "${CLOUDFLARE_ACCOUNT_ID:?must export CLOUDFLARE_ACCOUNT_ID}"

APPS=(
  "oriz-janaushdhi|apps/content/oriz-janaushdhi-app|janaushdhi.oriz.in"
  "oriz-roam-journal|apps/content/oriz-roam-journal-app|journal.oriz.in"
  "oriz-cs-me|apps/personal/oriz-cs-me-app|me.oriz.in"
  "oriz-financial-cards|apps/content/oriz-financial-cards-app|financial-cards.oriz.in"
  "oriz-lore|apps/content/oriz-lore-app|book-lore.oriz.in"
  "oriz-ncert|apps/content/oriz-ncert-app|books.oriz.in"
  "oriz-omni-post|apps/content/oriz-omni-post-app|omni.oriz.in"
  "oriz-packages-catalog|apps/content/oriz-packages-catalog-app|packages.oriz.in"
  "oriz-cipher-crypto|apps/tools/oriz-cipher-crypto-tools-app|crypto.oriz.in"
  "oriz-dice-random|apps/tools/oriz-dice-random-tools-app|random.oriz.in"
  "oriz-echo-audio|apps/tools/oriz-echo-audio-tools-app|audio.oriz.in"
  "oriz-forge-dev|apps/tools/oriz-forge-dev-tools-app|dev.oriz.in"
  "oriz-grid-qr|apps/tools/oriz-grid-qr-tools-app|qr.oriz.in"
  "oriz-paisa-finance|apps/tools/oriz-paisa-finance-tools-app|finance.oriz.in"
  "oriz-paper-print|apps/tools/oriz-paper-print-tools-app|print.oriz.in"
  "oriz-pivot-data|apps/tools/oriz-pivot-data-tools-app|data.oriz.in"
  "oriz-pixie-image|apps/tools/oriz-pixie-image-tools-app|image.oriz.in"
  "oriz-rank-seo|apps/tools/oriz-rank-seo-tools-app|seo.oriz.in"
  "oriz-reel-video|apps/tools/oriz-reel-video-tools-app|video.oriz.in"
  "oriz-scribe-text|apps/tools/oriz-scribe-text-tools-app|text.oriz.in"
  "oriz-shift-convert|apps/tools/oriz-shift-convert-tools-app|convert.oriz.in"
  "oriz-slice-pdf|apps/tools/oriz-slice-pdf-tools-app|pdf.oriz.in"
  "oriz-vitals-health|apps/tools/oriz-vitals-health-tools-app|health.oriz.in"
)

BATCH_SIZE=5
i=0
for entry in "${APPS[@]}"; do
  IFS="|" read -r P L D <<< "$entry"
  bash c:/D/oriz/scripts/cf-recreate.sh "$P" "$L" "$D" > "c:/D/oriz/logs/cf-recreate/$P.out" 2>&1 &
  i=$((i+1))
  if [ $((i % BATCH_SIZE)) -eq 0 ]; then
    wait
    echo "batch done, total=$i"
    sleep 2
  fi
done
wait
echo "ALL DONE"
