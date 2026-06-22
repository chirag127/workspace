# Visual Audit — 2026-06-22 (late evening)

> Live screenshots of every Oriz surface (5 local apps + 19 API subdomains), 1280×800 desktop + 375 mobile for apps, captured via Playwright/Chromium. Screenshots under `c:/D/oriz/.tmp-screenshots/audit-2026-06-22-late-evening/`. Triggered by user complaint: *"fii-dii.api.oriz.in looks very bad — no CSS."*

## TL;DR

- **Apps:** 4/5 render correctly with on-brief CSS, fonts, header/footer. `home-4321` is a dev-error overlay — runtime import failure in `@chirag127/astro-chrome`.
- **APIs:** 1/19 broken (Pages 404), 4/19 have proper styled landing pages (`mf-nav`, `pincode`, `ifsc`, `currency`), 14/19 render bare README HTML (no brand, no live data preview, no rate-limit/schema docs). User's complaint is **valid for 14 of 19 APIs**.
- **Gold standard:** `currency.api.oriz.in` (dark theme + live converter widget) is the template the other 14 should follow.

## Phase 1 — Local apps (5)

| App | URL | Status | Bg | Type stack | Signature | Header/Footer | Verdict |
|---|---|---|---|---|---|---|---|
| home | localhost:4321 | **500** | — | — | — | — | ❌ **BROKEN** — Astro dev server: `Missing "./legal/LegalFooter.astro" specifier in "@chirag127/astro-chrome" package` (Footer.astro:12:24) |
| blog | localhost:4322 | 200 | `#FAF8F2` paper | Inter Variable | sidebar nav + dot-progress rails | ✅ / ✅ | ✅ Matches brief; minor: cookie banner cuts hero on first paint, 404s for `/category/books` & `/notes` |
| ncert | localhost:4323 | 200 | `#F4EDE0` warm cream | Inter Tight (h1) + Inter | 3-step class/subject/language picker, drop-cap H1 | ✅ / ✅ | ✅ Matches brief perfectly; 0 console errors |
| janaushdhi | localhost:4324 | 200 | `#FAFAF9` off-white + teal #047857 | IBM Plex Sans | "Browse 2,439 medicines. Save 89%" stat-hero | ✅ / ✅ | ✅ Matches brief; medical-banner + search + browse-all CTA all visible |
| packages | localhost:4325 | 200 | `#1E293B` slate dark | Inter Tight + Inter Variable | install-snippet copy + category sidebar (23/11/4/8 counts) | ✅ / ✅ | ✅ Matches brief; 23 cards render in 4-col grid |

Mobile (375px) screenshots saved for all 5 — Blog/Ncert/Janaushdhi/Packages reflow cleanly; home stays broken.

## Phase 2 — API subdomains (19)

### ✅ Proper styled landing page (4)

| Slug | Verdict | Notes |
|---|---|---|
| `mf-nav` | ✅ Good | Clean white, headline + endpoints list + Playground button + footer; lacks live data preview but has source-credit callout. |
| `pincode` | ✅ Good | Full Try-It widget (6-digit input + Lookup button), card layout, endpoints + schema. |
| `ifsc` | ✅ Good | Lookup playground with bank-prefix input, endpoints listed. |
| `currency` | ✅ **Gold standard** | Dark theme `#0B1020`, live converter widget showing `100 USD = 9437.0627 INR`, "Latest rates per USD" data table, 166 currencies, 3-source aggregation note. **This is the design every API should match.** |

### ⚠️ Bare GitHub README HTML, no brand (14)

These render the docs `README.md` via GitHub Primer styles (white bg, `#24292e` text, system font) but have **none** of the Rule-13 signature elements: no Oriz wordmark, no live data preview from `latest.json`, no copy-button on endpoints, no rate-limit note, no schema visualization.

| Slug | Issue |
|---|---|
| `fii-dii` | **Worst offender** — only 2 stylesheets (one 404s), falls back to **Times New Roman**, image-alt `Oriz Flow` link broken. User's "no CSS" complaint is literally true here. |
| `holidays`, `tickers`, `rbi-rates`, `gold-silver`, `irctc`, `aqi-india`, `aqi`, `fuel`, `exams`, `rti`, `judgments`, `budget`, `so-trending` | All render GitHub-Primer-styled README only. Functional but generic — indistinguishable from any open-source repo's docs page. No Oriz identity, no live data, no API key/rate-limit info. |

### ❌ Broken (1)

| Slug | Issue |
|---|---|
| `mmi` | GitHub Pages site not provisioned → `404 Site not found`. Repo `oriz-mmi-tickertape-mmi-api` needs Pages enabled + CNAME + DNS verification. |

## NEEDS FIXING — concrete checklist

**P0 — broken surfaces (do first):**
- [ ] **`home-4321` Astro 500** — add `./legal/LegalFooter.astro` export to `@chirag127/astro-chrome` package OR change `home-app/src/components/Footer.astro:12` to import from existing path. Source of truth: `node_modules/@chirag127/astro-chrome/package.json` `exports` map.
- [ ] **`mmi.api.oriz.in` 404** — enable GitHub Pages on `oriz-mmi-tickertape-mmi-api` repo, add CNAME file, verify DNS CNAME `mmi.api.oriz.in → chirag127.github.io`.

**P1 — styled landing page for 14 API subdomains:**
- [ ] Replace bare README rendering with a styled `docs/index.html` per the `currency` template. Required elements per Rule-13 brief:
  - Oriz wordmark (top-left, matches family chrome)
  - 1-line description (already in README front-matter)
  - **Live data preview** — fetch `data/latest.json` client-side, show top 3 rows in a styled table
  - "GET `/data/latest.json`" copy-button (one-click clipboard)
  - Schema shape (already in README; render in styled code block)
  - Rate-limit note (GH Pages = no auth, but document the daily-snapshot cadence)
  - GitHub source link + npm/license badges
  - Footer matching API family (consistent `--api-bg`, `--api-fg` tokens)
- [ ] Apply to all 14 bare-README APIs in one pass — recommend a shared `apis/_template/index.html` + a build step that templates per-API metadata from each repo's `package.json` + README front-matter.

**P2 — polish:**
- [ ] `blog` cookie banner overlaps hero on first paint — defer mount until after LCP.
- [ ] `blog` 404s: `/blog/category/books/`, `/blog/category/notes/` — add category pages or remove sidebar links.
- [ ] `blog` `status.oriz.in/api/incidents` request fails (DNS) — gate the StatusBanner fetch behind `import.meta.env.PROD` or remove until status host is live.
- [ ] `fii-dii` second stylesheet 404 — find and remove the bad `<link rel="stylesheet">` in `docs/index.html`.

## Process improvements

- Re-run this audit (`c:/Users/C5420321/AppData/Local/Temp/snap-apps.mjs` + `snap-apis.mjs`) on every deploy to catch regressions visually.
- The `currency` template lives at `chirag127/oriz-currency-rates-api/docs/index.html` — copy to all other API repos as the styled-docs baseline.

## Counts

- Apps screenshotted: 5 (1 dev-error overlay captured; 10 PNGs total incl. mobile)
- APIs screenshotted: 19 (1 GH-Pages 404 captured; 18 served HTML; 1 has no CSS — `fii-dii`)
- Total screenshots: 29 PNGs in `c:/D/oriz/.tmp-screenshots/audit-2026-06-22-late-evening/`
