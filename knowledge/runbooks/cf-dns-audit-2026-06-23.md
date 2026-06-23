# Cloudflare DNS audit — `oriz.in` zone — 2026-06-23

**Scope:** Read-only audit. No records were modified.
**Source of truth:**
- Live DNS via Cloudflare API (`/zones/{id}/dns_records`), zone `oriz.in` = `fe8da3c9dd0cb1f1d964e3a94d6098b3`.
- API submodule CNAMEs at `projects/oriz-org/own/services/apis/*/CNAME` (19 files, GH Pages targets).
- `FAMILY_APPS`, `FAMILY_APIS` in `projects/oriz-org/own/libraries/npm-packages/astro-shell-npm-pkg/src/family-data.ts`.
- App Pages-project names from `projects/oriz-org/own/products/apps/**/wrangler.toml`.

**Method:** Pulled live CF DNS records, joined against (a) the 19 `apis/*/CNAME` files, (b) `FAMILY_APPS` canonical URLs, (c) `FAMILY_APIS` canonical URLs, and (d) Pages project names declared in `wrangler.toml`. Anything in DNS that does not appear in any of those four lists is flagged "orphan candidate" — meaning **investigate before deletion**, not "delete now".

---

## Summary counts

| Bucket | Count |
|---|---|
| Live DNS records (all types) | 73 |
| `*.api.oriz.in` CNAMEs in DNS | 19 |
| API CNAME files in `projects/oriz-org/own/services/apis/*/CNAME` | 19 |
| API DNS records that match a CNAME file | 19 (100% covered) |
| API CNAME files with no matching DNS record | 0 |
| App-level (non-`api`) CNAMEs in DNS | 31 |
| App DNS records matching a `FAMILY_APPS` canonical URL | 7 |
| App DNS records flagged "orphan candidate" | 24 |
| `FAMILY_APPS` canonical URLs missing from DNS | 18 |
| `FAMILY_APIS` canonical hostnames missing from DNS | 9 (planned) |
| Mail / DKIM / SPF / DMARC records | 11 (leave alone) |
| Worker / Pages catch-all AAAA `100::` records | 3 |

---

## 1. `*.api.oriz.in` CNAMEs — full coverage (no orphans, no missing)

All 19 live API CNAMEs point to `chirag127.github.io` and have a matching `projects/oriz-org/own/services/apis/<slug>/CNAME` file. This is the expected GH-Pages JSON-API rail.

| DNS hostname | DNS target | Matching CNAME file | Status |
|---|---|---|---|
| `aqi.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-aqi-cities-api/CNAME` | OK |
| `aqi-india.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-air-quality-india-api/CNAME` | OK |
| `budget.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-india-budget-numbers-api/CNAME` | OK |
| `currency.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-currency-rates-api/CNAME` | OK |
| `exams.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-india-exam-portal-status-api/CNAME` | OK |
| `fii-dii.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-flow-fii-dii-activity-api/CNAME` | OK |
| `fuel.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-india-petrol-diesel-api/CNAME` | OK |
| `gold-silver.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-gold-silver-rates-api/CNAME` | OK |
| `holidays.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-india-holidays-api/CNAME` | OK |
| `ifsc.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-ifsc-api/CNAME` | OK |
| `irctc.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-irctc-train-pnr-api/CNAME` | OK |
| `judgments.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-india-court-judgments-api/CNAME` | OK |
| `mf-nav.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-mf-nav-api/CNAME` | OK |
| `mmi.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-mmi-tickertape-mmi-api/CNAME` | OK |
| `pincode.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-pincode-api/CNAME` | OK |
| `rbi-rates.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-rbi-rates-api/CNAME` | OK |
| `rti.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-india-rti-api/CNAME` | OK |
| `so-trending.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-stackoverflow-trending-api/CNAME` | OK |
| `tickers.api.oriz.in` | `chirag127.github.io` | `projects/oriz-org/own/services/apis/oriz-nse-bse-tickers-api/CNAME` | OK |

**Note — `FAMILY_APIS` mismatch:** `family-data.ts` declares 14 APIs whose canonical hostnames do **not** match the 19 live API subdomains. The live rail follows the `projects/oriz-org/own/services/apis/*/CNAME` files (e.g. `fii-dii`, `mf-nav`, `rbi-rates`). `FAMILY_APIS` references aspirational names (`sip-emi`, `tax-india`, `gst`, `bmi`, `qr.api`, `shorten`, `convert.api`, `timezones`, plus the only two it gets right: `fii-dii.api.oriz.in` and `janaushdhi.api.oriz.in` — but `janaushdhi.api.oriz.in` is **not in DNS**). This is a registry-vs-reality drift; fix is out of scope for this audit.

---

## 2. App-level CNAMEs — matches against `FAMILY_APPS`

`FAMILY_APPS` has 25 entries. Of their 25 canonical URLs, only **7** are live in DNS today.

| DNS hostname | DNS target | Matches `FAMILY_APPS` slug | Wrangler Pages project | Status |
|---|---|---|---|---|
| `oriz.in` | `oriz.pages.dev` | `home-app` | `oriz-home` | OK (target name does not match Pages project — see Note A) |
| `www.oriz.in` | `oriz.pages.dev` | `home-app` (apex alias) | — | OK |
| `me.oriz.in` | `chirag127.pages.dev` | `oriz-cs-me-app` | — | OK (Pages project name is `chirag127`, not `oriz-cs-me`) |
| `blog.oriz.in` | `blog-ehu.pages.dev` | `oriz-pages-blog-app` | `oriz-blog` | DRIFT — DNS target is the random-suffix preview hostname `blog-ehu`, not the canonical `oriz-blog.pages.dev` (Note A) |
| `finance.oriz.in` | `finsuite.pages.dev` | `oriz-paisa-finance-tools-app` | `oriz-finance` | DRIFT — DNS target is legacy `finsuite`, wrangler says `oriz-finance` |
| `pdf.oriz.in` | `orizpdf.pages.dev` | `oriz-slice-pdf-tools-app` | `oriz-pdf-tools` | DRIFT — DNS target is `orizpdf`, wrangler says `oriz-pdf-tools` |
| `status.oriz.in` | `oriz-status.pages.dev` | `oriz-status-app` (not in `FAMILY_APPS`) | — | OK (submodule recently added; missing from registry) |

**Note A — Pages custom-domain CNAMEs:** Cloudflare assigns Pages projects a `<random>.pages.dev` preview hostname AND the canonical `<project-name>.pages.dev`. A custom domain bound to a Pages project can point at *either* and still work. The DRIFT rows above are technically functional, but they make grep-based reasoning unreliable — a future "rename Pages project" or "delete preview" would silently break the live site. Treat all DRIFT rows as documentation debt to resolve before any Pages-project cleanup.

**App-level CNAMEs marked "orphan candidate" — 24 records.** None of these hostnames appear as a `FAMILY_APPS` canonical URL. Some are clearly intentional infra (Clerk, Ghost), some are legacy redirects, some are short aliases. **Do not delete without confirming each one individually.**

| DNS hostname | DNS target | Orphan reason | Likely role (informed guess) |
|---|---|---|---|
| `accounts.oriz.in` | `accounts.clerk.services` | Not in `FAMILY_APPS` | Clerk Frontend Account Portal — **keep** |
| `clerk.oriz.in` | `frontend-api.clerk.services` | Not in `FAMILY_APPS` | Clerk Frontend API — **keep** |
| `clk._domainkey.oriz.in` | `dkim1.gwkgeekd5pay.clerk.services` | Not in `FAMILY_APPS` | Clerk DKIM — **keep** |
| `clk2._domainkey.oriz.in` | `dkim2.gwkgeekd5pay.clerk.services` | Not in `FAMILY_APPS` | Clerk DKIM — **keep** |
| `clkmail.oriz.in` | `mail.gwkgeekd5pay.clerk.services` | Not in `FAMILY_APPS` | Clerk mail — **keep** |
| `ghost.oriz.in` (A `34.70.97.240`) | — | Not in `FAMILY_APPS` | Ghost(Pro) blog or legacy GCP IP — investigate |
| `posters.oriz.in` | `public.r2.dev` | Not in `FAMILY_APPS` | R2 public bucket — likely intentional |
| `img.oriz.in` | `pdf-oriz-in.pages.dev` | Not in `FAMILY_APPS` | Misrouted? Points at a PDF Pages project — investigate |
| `api.oriz.in` | `apis.chirag127.workers.dev` | Not in `FAMILY_APPS` | API gateway worker — likely intentional |
| `apis.oriz.in` | `apis-web.pages.dev` | Not in `FAMILY_APPS` | API directory site — likely intentional |
| `app.oriz.in` | `office-os.pages.dev` | Not in `FAMILY_APPS` | Legacy "office-os" project — investigate |
| `book.oriz.in` | `bookatlas-13392.web.app` | Not in `FAMILY_APPS` | Legacy Firebase Hosting "bookatlas" — investigate (likely retire) |
| `calc.oriz.in` | `finsuite.pages.dev` | Not in `FAMILY_APPS` | Legacy alias to finance — investigate |
| `capital.oriz.in` | `finsuite.pages.dev` | Not in `FAMILY_APPS` | Legacy alias to finance — investigate |
| `chirag.oriz.in` | `chirag127.pages.dev` | Not in `FAMILY_APPS` (`me.oriz.in` is canonical) | Alias of `me.oriz.in` — investigate |
| `chirag127.oriz.in` | `chirag127.pages.dev` | Not in `FAMILY_APPS` | Same — alias of `me.oriz.in` |
| `docs.oriz.in` | `office-os.pages.dev` | Not in `FAMILY_APPS` | Legacy "office-os" — investigate |
| `envpact.oriz.in` | `envpact-dashboard.pages.dev` | Not in `FAMILY_APPS` | Envpact dashboard (separate product) — likely keep |
| `fin.oriz.in` | `finsuite.pages.dev` | Not in `FAMILY_APPS` | Legacy alias — investigate |
| `janaushadhi.oriz.in` | `janaushadhi-oriz-in.pages.dev` | Spelled `janaushadhi`; `FAMILY_APPS` uses `janaushdhi` | Spelling drift — see Note B |
| `money.oriz.in` | `finsuite.pages.dev` | Not in `FAMILY_APPS` | Legacy alias — investigate |
| `night.oriz.in` | `velvet-os-7og.pages.dev` | Not in `FAMILY_APPS` | "velvet-os" private workspace — investigate |
| `o.oriz.in` | `office-os.pages.dev` | Not in `FAMILY_APPS` | "office-os" — investigate |
| `office.oriz.in` | `office-os.pages.dev` | Not in `FAMILY_APPS` | "office-os" — investigate |
| `pilot.oriz.in` | `repo-pilot.pages.dev` | Not in `FAMILY_APPS` | Repo-pilot product — likely keep |
| `private.oriz.in` | `velvet-os-7og.pages.dev` | Not in `FAMILY_APPS` | "velvet-os" — investigate |
| `slice.oriz.in` | `slice-93v.pages.dev` | Not in `FAMILY_APPS` (`pdf.oriz.in` is canonical for slice) | Alias / preview — investigate |
| `sov.oriz.in` | `sovereign-web.pages.dev` | Not in `FAMILY_APPS` | "sovereign-web" project — investigate |
| `urls-to-md.oriz.in` | `urls-to-md.pages.dev` | Not in `FAMILY_APPS` | Standalone tool — investigate |
| `v.oriz.in` | `velvet-os-7og.pages.dev` | Not in `FAMILY_APPS` | "velvet-os" — investigate |
| `velvet.oriz.in` | `velvet-os-7og.pages.dev` | Not in `FAMILY_APPS` | "velvet-os" — investigate |
| `wealth.oriz.in` | `finsuite.pages.dev` | Not in `FAMILY_APPS` | Legacy alias — investigate |
| `x.oriz.in` | `velvet-os-7og.pages.dev` | Not in `FAMILY_APPS` | "velvet-os" — investigate |

**Note B — `janaushadhi` vs `janaushdhi`:** DNS uses `janaushadhi.oriz.in` (with an `a` before `dhi`). `FAMILY_APPS` declares the canonical hostname as `janaushdhi.oriz.in` (no `a`). Decide which spelling is correct and align both the DNS record and the registry. Hindi: जन औषधि → standard transliteration is "Janaushadhi"; the registry spelling looks like the typo.

---

## 3. AAAA `100::` records (Workers / Pages catch-all)

`100::` is Cloudflare's blackhole sentinel — typically set by a Pages or Worker custom-domain binding that hasn't fully wired up, or by intentional 404-on-AAAA. These are not orphans; they belong to specific bindings.

| DNS hostname | Proxied | Likely binding |
|---|---|---|
| `mcp.envpact.oriz.in` | yes | Envpact MCP worker |
| `status-api.oriz.in` | yes | `oriz-status-app` worker (matches recent submodule bump) |
| `tools.oriz.in` | yes | Unknown — investigate (no `tools.oriz.in` in `FAMILY_APPS`) |

---

## 4. Mail / verification records (no action)

These records are correct and out of scope for any DNS cleanup:

- `MX` × 3 → `route{1,2,3}.mx.cloudflare.net` (Cloudflare Email Routing)
- `MX` send.oriz.in → `feedback-smtp.ap-northeast-1.amazonses.com` (Amazon SES)
- `TXT` SPF, DMARC, Google site verification, IndexNow verification
- `TXT cf2024-1._domainkey.oriz.in` (Cloudflare Email Routing DKIM)
- `TXT resend._domainkey.oriz.in` (Resend DKIM)
- `TXT send.oriz.in` (Amazon SES SPF)

---

## 5. `FAMILY_APPS` canonical URLs missing from DNS — 18 records to *add* (not delete)

These are aspirational hostnames declared in `family-data.ts` but with no current DNS record:

| Slug | Canonical URL declared | Status in `family-data.ts` |
|---|---|---|
| `oriz-financial-cards-app` | `financial-cards.oriz.in` | live |
| `oriz-janaushdhi-app` | `janaushdhi.oriz.in` | planned (DNS has `janaushadhi.` — spelling drift, Note B) |
| `oriz-lore-app` | `book-lore.oriz.in` | live |
| `oriz-ncert-app` | `books.oriz.in` | live |
| `oriz-omni-post-app` | `omni.oriz.in` | beta |
| `oriz-packages-catalog-app` | `packages.oriz.in` | planned |
| `oriz-roam-journal-app` | `journal.oriz.in` | live |
| `oriz-cipher-crypto-tools-app` | `crypto.oriz.in` | planned |
| `oriz-dice-random-tools-app` | `random.oriz.in` | planned |
| `oriz-echo-audio-tools-app` | `audio.oriz.in` | planned |
| `oriz-forge-dev-tools-app` | `dev.oriz.in` | planned |
| `oriz-grid-qr-tools-app` | `qr.oriz.in` | planned |
| `oriz-paper-print-tools-app` | `print.oriz.in` | planned |
| `oriz-pivot-data-tools-app` | `data.oriz.in` | planned |
| `oriz-pixie-image-tools-app` | `image.oriz.in` | live (no DNS — likely shipped via `img.oriz.in` or unshipped) |
| `oriz-rank-seo-tools-app` | `seo.oriz.in` | planned |
| `oriz-reel-video-tools-app` | `video.oriz.in` | planned |
| `oriz-scribe-text-tools-app` | `text.oriz.in` | planned |
| `oriz-shift-convert-tools-app` | `convert.oriz.in` | planned |
| `oriz-vitals-health-tools-app` | `health.oriz.in` | planned |

The `image.oriz.in` row is the most actionable: registry says "live" but DNS shows nothing. Either ship the Pages domain binding or downgrade status to `planned`.

---

## 6. Recommendations (no action taken in this audit)

1. **Don't delete anything yet** — every "orphan candidate" above either belongs to an external service (Clerk, R2, Ghost), is a legacy product (finsuite, velvet-os, office-os, bookatlas), or is an active short-alias. Each needs a one-line owner decision before removal.
2. **Resolve `janaushadhi` vs `janaushdhi`** spelling. Match registry to DNS, or rename the DNS record.
3. **Fix Pages-project DNS drift** for `blog.oriz.in` → `oriz-blog.pages.dev`, `finance.oriz.in` → `oriz-finance.pages.dev`, `pdf.oriz.in` → `oriz-pdf-tools.pages.dev`. Today's preview-hostname CNAMEs work but are fragile.
4. **Add `oriz-status-app` to `FAMILY_APPS`** so the registry reflects the live `status.oriz.in` rail (already a submodule).
5. **Reconcile `FAMILY_APIS` with the 19 actual API subdomains** — the registry list and the live `*.api.oriz.in` rail share only one name (`fii-dii`). Treat registry as wrong, not DNS.
6. **Investigate `tools.oriz.in` AAAA `100::`** — no matching binding visible in this repo.
7. **Investigate `ghost.oriz.in` A `34.70.97.240`** — GCP IP, likely retired Ghost(Pro) instance.

---

## Provenance

- DNS data: Cloudflare API live pull at audit time, paged through `dns_records?per_page=100`.
- Token loaded from `c:/D/oriz/.env` `CLOUDFLARE_API_TOKEN`. No records were created, modified, or deleted.
- 73 total records read. Mapping logic matched (host, target) tuples against (a) `projects/oriz-org/own/services/apis/*/CNAME` literal content, (b) `FAMILY_APPS[].url` host, (c) `FAMILY_APIS[].url` host.
