# API scraping ToS audit

**Status:** active. **Locked:** 2026-06-22. **Posture:** ToS-conservative — when an upstream's terms forbid or restrict redistribution, we either (a) proxy a free *official* feed instead (lowest risk), (b) classify as `amber` and proceed with strict rate limits + attribution + ready-to-pivot mitigation, or (c) `red` → don't scaffold.

All scrapers run with:
- **User-Agent:** `oriz-api-bot/0.1 (+https://oriz.in/about; contact: privacy@oriz.in)`
- **Rate:** ≤1 fetch per upstream per day per GitHub Action run.
- **Cache:** 24 h TTL minimum (last `data/latest.json` served until next successful scrape).
- **robots.txt:** respected — blocked paths skipped.
- **Failure mode:** on HTTP 403 / CAPTCHA / network error → log + serve last-good data + Telegram ops alert (where India-permitted; otherwise GH Issue alert).
- **README footer:** `Source: <upstream>. Attribution required. Non-commercial public-data redistribution.`

## Status legend

- `green` — official free API or public-domain dataset; redistribution explicitly OK.
- `amber` — public web data, ToS ambiguous or restrictive on commercial use; non-commercial redistribution generally tolerated but ready to pivot/stop.
- `red` — ToS explicitly forbids scraping or redistribution; do NOT scaffold (or defer pending re-verification).

## Audit table

| API repo | Upstream(s) | License / ToS link | Status | Our rate | Mitigation if banned |
|---|---|---|---|---|---|
| `oriz-flow-fii-dii-activity-api` | nseindia.com `/api/fiidii`; moneycontrol fallback | https://www.nseindia.com/cms/terms-conditions; https://www.moneycontrol.com/terms_conditions.php | amber | 1/weekday | Pivot to BSE public PDFs; freeze + serve last-good |
| `oriz-mmi-tickertape-mmi-api` | tickertape.in market-mood-index | https://www.tickertape.in/terms-and-conditions | amber | 1/day | Pivot to manual VIX-derived proxy; freeze last-good |
| `oriz-nse-bse-tickers-api` | nseindia.com indices API; bseindia.com `/IndianMarket` | https://www.nseindia.com/cms/terms-conditions; https://www.bseindia.com/static/about/Disclaimer.html | amber | 1/day | Pivot to Yahoo Finance free; freeze last-good |
| `oriz-rbi-rates-api` | rbi.org.in `/Scripts/BS_PressReleaseDisplay.aspx` | https://www.rbi.org.in/Scripts/Copyright.aspx (Govt of India, public domain factual rates) | green | 1/day (or on-policy-change) | n/a — public data |
| `oriz-gold-silver-rates-api` | mcxindia.com bullion close; tanishq.co.in/rates | https://www.mcxindia.com/Footer/disclaimer; https://www.tanishq.co.in/terms-and-conditions | amber | 1/day | Pivot to GoodReturns or PaisaBazaar feed; freeze last-good |
| `oriz-irctc-train-pnr-api` | indianrail.gov.in/enquiry train-schedule (public lookup) | https://www.indianrail.gov.in/enquiry/StaticPages/StaticTermsCondition.jsp | amber | 1/day per route | Schedule data only (PNR needs user auth = NOT scraped); pivot to ConfirmTkt mirror |
| `oriz-air-quality-india-api` | cpcb.nic.in `/IndiaAirQuality` (Govt of India) | https://cpcb.nic.in/copyright/ (public domain factual) | green | 1/day | n/a — public data |
| `oriz-aqi-cities-api` | openaq.org `/v3/latest` (official free API, registered) | https://openaq.org/about/terms/ (CC-BY 4.0) | green | 1/day batched | n/a — official free API |
| `oriz-india-petrol-diesel-api` | iocl.com fuel-prices; hpcl.co.in fuel-prices | https://iocl.com/disclaimer; https://www.hindustanpetroleum.com/disclaimer | amber | 1/day | Pivot to Goodreturns aggregator; freeze last-good |
| `oriz-india-exam-portal-status-api` | HEAD pings to neet.nta.nic.in / jeemain.nta.nic.in / gate.iitb.ac.in / upsc.gov.in / npscra.nsdl.co.in / epfindia.gov.in | n/a (HEAD ping = no content fetch, well within fair use) | green | 1 HEAD/portal/day | n/a — only up/down status published |
| `oriz-india-rti-api` | One-time public dataset (CIC.gov.in commissioner list + RTI template text) | https://cic.gov.in (Govt of India, public domain) | green | One-time + 1/month refresh | n/a — public data |
| `oriz-india-court-judgments-api` | indiakanoon.org search index | https://indiankanoon.org/terms (commercial scraping prohibited; non-commercial linking OK) | **amber → DEFERRED** | 1/day | **Do NOT auto-deploy.** Re-verify ToS before enabling. Pivot path: link out to official SC/HC RSS feeds instead of indexing |
| `oriz-india-budget-numbers-api` | indiabudget.gov.in budget-at-a-glance PDFs | https://www.indiabudget.gov.in/glance.php (Govt of India, public domain) | green | 1/year (budget season) + 1/month refresh | n/a — public data |
| `oriz-stackoverflow-trending-api` | api.stackexchange.com `/2.3/questions` (official free API, CC-BY-SA) | https://stackoverflow.com/legal/api-terms-of-use | green | 1/day (300 req/day quota — way under) | n/a — official free API |

## Amber-flagged repos (require manual re-verify before auto-deploy)

These repos are scaffolded but **MUST NOT** have their scrape workflow enabled on schedule until upstream ToS is re-checked manually:

1. **`oriz-india-court-judgments-api`** — indiakanoon.org explicitly forbids commercial scraping; current build seeds placeholder data only and the `scrape.yml` cron is **disabled** (commented out). Re-verify post-MIT-relicense whether the source is even viable, or pivot to direct SC/HC RSS.
2. **`oriz-irctc-train-pnr-api`** — IRCTC terms are restrictive; we scrape **schedule** (non-personal) only, never PNR (which needs user OAuth). Cron enabled at 1/day. Pivot ready: ConfirmTkt public mirror.

The remaining `amber` rows are scaffolded with cron enabled because non-commercial factual-data redistribution with attribution + low rate is the common-practice posture; we freeze and pivot if any upstream sends a takedown.

## 2026-06-22 addendum — 5 SAFE APIs scaffolded today

Scaffolded as a parallel "SAFE-only" batch (no NSE / Moneycontrol / IRCTC scraping). All are `green` status.

| API repo | Upstream(s) | License / ToS | Status | Our rate | Mitigation |
|---|---|---|---|---|---|
| `oriz-mf-nav-api` | `https://api.mfapi.in/mf` (which republishes AMFI's free daily NAV file) | mfapi.in is an explicitly-free public API; AMFI NAV data is statutory public disclosure (SEBI). Factual data → uncopyrightable under §13(1)(b), Copyright Act 1957. | green | 1/day @ 06:30 IST | Stop cron + drop `data/latest.json`; pivot directly to AMFI's daily NAV text file at `https://www.amfiindia.com/spages/NAVAll.txt`. |
| `oriz-pincode-api` | `https://data.gov.in/resource/all-india-pincode-directory` (CSV) | Government Open Data License – India (GODL-India) → free redistribution with attribution. | green | 1/month (first Mon) | Stop cron + remove cached `data/pincodes.json`. Currently hits HTTP 403 on the direct CSV; fallback to 20 hand-picked rows until we swap to an authed `data.gov.in` API key. |
| `oriz-ifsc-api` | `https://raw.githubusercontent.com/razorpay/ifsc/master/src/IFSC.json` | Razorpay `ifsc` repo is MIT-licensed; RBI IFSC list is statutory public utility data. | green | 1/month (first Mon) | Stop cron + remove cached `data/ifsc.json`. Pivot: parse RBI's official IFSC Excel sheet directly. Live seed succeeded — 7,364 codes × 260 banks. |
| `oriz-india-holidays-api` | `https://date.nager.at/api/v3/PublicHolidays/{year}/IN` | Nager.Date API is explicitly free; source code MIT (`nager/Nager.Date`); holiday dates are uncopyrightable. | green | 2/year (Jan 5: current + next year) | Stop cron; pivot to scraping the India Gazette holiday PDF (Govt public domain). |
| `oriz-currency-rates-api` | aggregate of 3: `api.frankfurter.app` (ECB mirror, MIT source), `api.exchangerate.host` (free tier, currently degraded — needs `access_key`), `open.er-api.com` (free non-commercial w/ attribution, 1,500/month quota) | All 3 explicitly free for the access pattern we use. FX rates are uncopyrightable factual data. | green | 1/day per upstream (3 calls/day total) | Per-upstream: remove from `UPSTREAMS` array. Live: 2-of-3 OK (frankfurter + open.er-api). If all 3 break, fallback table + "stale" notice. |

### GitHub-side compute / storage envelope (all 5 combined)

- Total workflow time: < 1 minute/day across all 5 services. Free-tier limit is 2,000 min/month → we're at < 1%.
- Total data committed: < 30 MB/year aggregate (all snapshots). Far under repo size guidance.
- Pages bandwidth: even 1,000 daily users × 5 services × ~10 KB latest.json = ~50 MB/month. Free-tier soft limit is 100 GB/month.
- **Verdict:** comfortably under every GitHub free-tier limit; no headroom concerns.

### Re-audit cadence

These 5 rows are re-checked annually on Jan 5 (same day as the `oriz-india-holidays-api` cron) — or immediately if any upstream sends a complaint/takedown. Update each row's License/ToS column with the new finding.

## 2026-06-22 addendum — 12 SCRAPING APIs scaffolded today (this batch)

Scaffolded as a parallel "scraping" batch (the 14 rows above the SAFE addendum already covered most of these conceptually; this is the **realised scaffold** with code + repos). All `green` rows are auto-deploying with cron; all `amber` rows are auto-deploying with last-good fallback **except** `oriz-india-court-judgments-api` which has its cron commented out pending ToS re-verify.

| Repo | Live first-fetch result | Status |
|---|---|---|
| `oriz-nse-bse-tickers-api` | placeholder (no session cookie / blocked) — seed served | amber, auto-deploying with fallback |
| `oriz-rbi-rates-api` | live: `source=rbi` | green |
| `oriz-gold-silver-rates-api` | MCX 403 — placeholder seed served | amber, freeze last-good |
| `oriz-irctc-train-pnr-api` | indianrailapi empty (needs real API key) — placeholder seed served | amber, schedule-only (never PNR) |
| `oriz-air-quality-india-api` | network fail — placeholder seed served | green (Govt PD), freeze last-good |
| `oriz-aqi-cities-api` | OpenAQ 401 (needs `OPENAQ_KEY`) — placeholder seed served | green, needs key in GH secret |
| `oriz-india-petrol-diesel-api` | live: `source=goodreturns` | amber |
| `oriz-india-exam-portal-status-api` | live: 6 portal HEAD-pings done | green |
| `oriz-india-rti-api` | live: `source=cic` | green |
| `oriz-india-court-judgments-api` | placeholder (cron disabled — ToS deferred) | **amber → DEFERRED — DO NOT auto-deploy** |
| `oriz-india-budget-numbers-api` | indiabudget 403 — placeholder seed served | green (Govt PD), freeze last-good |
| `oriz-stackoverflow-trending-api` | live: `source=stackexchange`, 20 trending Qs | green |

### Required GH secrets (to flip live)

- `OPENAQ_KEY` on `oriz-aqi-cities-api` (free key from openaq.org).
- `INDIANRAIL_KEY` on `oriz-irctc-train-pnr-api` (or pivot to ConfirmTkt scrape).

### Action items before any of these go production-noisy

1. **`oriz-india-court-judgments-api`**: re-verify indiakanoon ToS or pivot to direct SC/HC RSS before un-commenting cron.
2. **NSE / MCX / IRCTC**: if any single failed run produces a 403/CAPTCHA two days in a row, flip the repo to amber-frozen and serve last-good only; consider pivoting to mirror sources.
3. **OpenAQ**: add `OPENAQ_KEY` to repo secret to unlock the global AQI feed.
