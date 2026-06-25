---
type: design-brief
title: "oriz-me v2 design brief"
description: "Personal site as build manifest: datasheet white, archival-blue accent, IBM Plex Sans Condensed, provenance strip with live build timestamp + 4px pulsing sync dot — the only animation on the site."
tags: [design, oriz-me, v2]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - design/_family-rules
  - decisions/process/v2-design-implementation
---

# oriz-me — v2 spec

A personal site that proves its own work. Every datum bears the timestamp it was scraped, every list bears the API it came from. The site IS the build manifest.

## Subject pin

**oriz-me at https://me.oriz.in is Chirag Singhal's digital identity datasheet, not a portfolio.** It is a daily-rebuilt static site whose entire content is a build-time scrape of 40+ external APIs (GitHub, Lichess, Last.fm, AniList, Letterboxd, Trakt, Steam, Speedrun.com, …) into JSON, then rendered as static HTML. Audience, in order: engineers vetting a hire, technical collaborators evaluating taste, his own future self skimming an archive. The home page's single job is **answer "what does this person actually do?" in three glances** — career snapshot, what was synced this morning, three pieces of work to scrutinise. Per-section pages (`/me`, `/work`, `/code`, `/library`, `/gaming`, `/connect`, `/system`) drill into one dimension each. The non-templated thesis: data sovereignty is the brand. Every API, every count, every timestamp shows its work. The site reads like a printed engineering datasheet, not a personal landing page.

## Surface + tokens

Datasheet white. Not the warm cream of blog/pdf-tools/book-lore/urls-to-md, not the pure white of generic SaaS. The cool, slightly grey-blue archival white of a printed engineering report or a Bloomberg terminal printout. Single accent is archival blue (the colour of mechanical-drafting blueprints, of ThinkPad cyan, of an IBM Selectric carbon ribbon's blue copy). Diverges from finance graph-paper green and cards slate.

| Token | Hex | Role |
|---|---|---|
| `--paper` | `#FAFBFC` | Page surface — cool grey-white, ≈3% blue cast. Reads as datasheet, not dashboard. |
| `--ink` | `#0E1318` | Body text + headings. Near-black with a cool blue undertone, never `#000`. |
| `--ink-soft` | `#5A6470` | Provenance lines, captions, footnote text. The graphite-on-paper tone of a margin annotation. |
| `--rule` | `#C8CFD6` | Hairlines, table borders, the section-start graph grid. Visible on print, quiet on screen. |
| `--archival` | `#0B5394` | THE accent. Drafting-blueprint blue. Used on links, section labels, the live-sync dot, the timestamp marker. The only saturated colour on the page. |
| `--archival-wash` | `#E6EDF6` | A 6%-saturation tint of `--archival`. Used only as a hairline-bordered fill behind data tables, never as a CTA wash. |

Dark variant: `--paper #0B0F14`, `--ink #E8ECEF`, `--archival #6CA8E8`. Same hierarchy, inverted.

This is the family's seventh distinct surface (cream ×4, dark ×4, graph-paper teal, slate, datasheet-white). A user surfing oriz.in → cards.oriz.in → me.oriz.in sees three different surfaces in a row.

## Type

- **Display: IBM Plex Sans Condensed** (Google Fonts, OFL) at weight 700 with negative tracking `-0.01em`. Used for the wordmark, h1 + h2, and the big numerals on the homepage stat blocks. Condensed (not regular) is the deliberate divergence from books' Plex Sans + Devanagari pairing — same family lineage, different cut, so the visual relationship to oriz-books reads as kinship, not duplication.
- **Body: IBM Plex Sans** (Google Fonts, OFL) at 400/500. 16px body, 1.6 line-height, measure capped at 64ch on prose pages, 84ch on data pages.
- **Utility / data: JetBrains Mono** (Google Fonts, OFL) at 400/500/700. **The load-bearing typographic decision.** Every timestamp (`2026-06-18T03:07Z`), every count (`247 events`), every API name (`github · lichess · last.fm`), every file size, every chess rating, every commit count is set in Plex Mono with `font-feature-settings: "tnum", "zero"` always on. Tabular figures so a column of 47 vs 247 vs 2,847 dot-aligns. Slashed zero so a `0` in `0xff` doesn't read as `O`. Ligatures off (`calt 0`) — we want `=>` to look like the two characters it is, not a single arrow glyph.

No serif anywhere. The display-face budget is conserved: this is the only site using Plex Sans Condensed. Type scale: `12 / 14 / 16 / 20 / 28 / 44 / 72`. Body 16, provenance 12 mono, data labels 14 mono, h2 28 condensed, h1 44 condensed, hero numerals 72 condensed.

## Layout — home

The home page is a stratified spec sheet, not a hero-with-stats-cards composition. Five horizontal bands on a single 980px column, separated by 1px `--rule` hairlines:

```
┌────────────────────────────────────────────────────────────────┐
│  oriz / me                                  ⌘K  · sign in      │  ← header (§7)
├────────────────────────────────────────────────────────────────┤
│  ── synced 2026-06-19T03:07Z · 41 sources · 12,847 records ──  │  ← provenance strip (signature §5)
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  CHIRAG SINGHAL                                                │  ← Plex Sans Condensed 72
│  Software engineer, Bhubaneswar.                               │     muted Plex Sans 20
│  Building privacy-first tools at TCS and oriz.in.              │
│                                                                │
│  available for ─ backend · ai/ml · full-stack engagements      │  ← single-line, mono labels
│                                                                │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  TODAY'S SYNC                                                  │  ← section eyebrow, mono caps
│                                                                │
│   github     ·····  247 events  ·  17 repos       03:07Z       │  ← leader-dotted rows (§5)
│   lichess    ·····  blitz 1842 (+12)  ·  43 games  03:07Z       │
│   last.fm    ·····  1,847 scrobbles  ·  18 artists 03:07Z       │
│   anilist    ·····  2 episodes new   ·  47 ongoing 03:07Z       │
│   letterboxd ·····  1 film logged    ·  237 total  03:07Z       │
│   …                                                  3 more →  │
│                                                                │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  WORK                                                          │
│  ┌──────────────┬──────────────┬──────────────┐                │
│  │ envpact-cli  │ oriz-journal │ oriz-pdf-    │                │
│  │              │              │ tools        │                │
│  │ open-source  │ pwa journal  │ 23 tools     │                │
│  │ secrets cli  │ libsodium    │ pdf-lib +    │                │
│  │ — 2026       │ — 2026       │ tesseract    │                │
│  │              │              │ — 2026       │                │
│  └──────────────┴──────────────┴──────────────┘                │
│                                                                │
│  CAREER                                                        │
│  ─ 2026 ── Engineer, TCS                                       │  ← timeline as horizontal rules
│  ─ 2025 ── B.Tech, AKTU (Rank 1)                              │
│  ─ 2022 ── JEE Advanced, AIR 11870                             │
│                                                                │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  /me · /work · /code · /library · /gaming · /connect · /system │  ← inline section nav, no cards
│                                                                │
├────────────────────────────────────────────────────────────────┤
│  ── this page was built 2026-06-19T03:07Z from 41 APIs ──     │  ← footer provenance line
│  source on github · MIT · ₹0 to host                           │
└────────────────────────────────────────────────────────────────┘
```

Mobile collapses all bands but keeps the provenance strip and the leader-dotted sync table — those are the brand. Project tiles stack vertically. Career timeline keeps the year + em-dash markers.

## Layout — mobile (≤640px)

The desktop composition narrows directly. Specifics:

- Provenance strip stays full-width but truncates to `synced 03:07Z · 41 sources` with the record count moved to a long-press tooltip
- Hero numerals scale 72 → 44 (still IBM Plex Sans Condensed)
- TODAY'S SYNC table keeps mono columns; long API names truncate with ellipsis, leader dots auto-shorten
- WORK 3-column tile grid stacks to single column with thin `--rule` between each
- CAREER timeline keeps `─ 2026 ── role` shape, no rotation, no marker
- Section nav `/me · /work · /code …` wraps to two lines with same dot separator
- Header collapses `oriz / me` + `⌘K` only; `sign in` and theme toggle move into a `⋯` dropdown that opens a bottom sheet
- All `tnum` mono columns retain decimal alignment — never replaced with reflowed prose
- The 4px sync dot stays the same size (4px reads correctly at any DPR)

The mobile design is not a different design — it is the same datasheet, set narrower. No mobile-specific component, no hamburger drawer mega-menu, no bottom-tab bar.

## Layout — section page (e.g. `/library`)

```
┌────────────────────────────────────────────────────────────────┐
│  oriz / me                                  ⌘K  · sign in      │
├────────────────────────────────────────────────────────────────┤
│  ── /library · synced 03:07Z · letterboxd + anilist + last.fm ─│  ← per-section provenance
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  LIBRARY                                                       │
│  237 films · 45 books · 52 anime · 1,847 scrobbles             │  ← mono tabular counts
│                                                                │
│  ── FILMS ───────────────────────────────────────────────────  │
│   01  Past Lives             2023  ★★★★½    logged 2026-06-15 │  ← ranked list, mono columns
│   02  La Chimera             2024  ★★★★½    logged 2026-06-08 │
│   …                                                            │
│                                                                │
│  ── BOOKS ───────────────────────────────────────────────────  │
│   01  Patterns of Software   1996  ★★★★      finished 2026-04 │
│   …                                                            │
└────────────────────────────────────────────────────────────────┘
```

Every section page repeats the structure: per-section provenance line → counts in mono → leader-dotted ranked tables. No grids of cover images, no carousels.

## Signature — the provenance strip

A single line of mono text, set in `--ink-soft` 12px JetBrains Mono, sits **below the header on every page** and reads:

```
── synced 2026-06-19T03:07Z · 41 sources · 12,847 records ──
```

The two `──` em-dashes flanking the line are real `U+2500` characters, not borders. The middle dots are real `U+00B7`. The timestamp is **rendered at build time** from the GitHub Actions cron run that produced the deploy, so it is the literal moment the data was scraped. Hovering the strip reveals a tooltip listing each API queried with its individual record count. On `/library`, `/code`, `/gaming` etc., the strip narrows to the APIs that fed *that* page.

A pulsing `--archival` blue dot (4px, `box-shadow` glow at 0.3 opacity, 1.5s ease-in-out infinite — **the only animation on the entire site**) sits to the left of the timestamp. It is the heartbeat: alive, syncing, real.

This signature does six jobs at once:
1. Communicates the thesis (data sovereignty, your-data-belongs-to-you) in 80 characters
2. Is functionally honest — the timestamp is the actual build time, and clicking it goes to the GitHub Actions run that built the page
3. Replaces the GitHub-contribution-graph cliche with something more truthful (a real build receipt vs a stylised activity heatmap)
4. Scales: the same primitive renders on every page, every section, the footer, even the 404
5. Distinguishes the site at 200ms — no other personal site shows its scrape receipts
6. Makes the daily build *visible*, which makes "this person ships every day" provable rather than performed

The supporting motif — **leader-dotted rows** in every data table on every page (`github  ·····  247 events  ·  17 repos`) — is the same visual primitive as oriz-finance's leader-dotted TOC, used here at table-row scale instead of section-list scale. Same vocabulary, different application.

## One aesthetic risk — no animation, no images, no gradient

**Zero animations except the 4px sync dot.** No reveal-on-scroll, no staggered fade-in, no parallax, no hover-lift on tiles, no transitions on the theme switcher. **Zero images on the home page, including no avatar, no project thumbnails, no flag-of-India hero, no Lichess board screenshot.** **Zero gradients anywhere — no ambient teal/violet glow, no glassmorphism, no `backdrop-filter`.**

The risk: a generation of devs looking at this page expecting Vercel-template visual ornament will read it as "unfinished" for two seconds.

The justification: this site's competitive advantage over every other dev portfolio is that **it shows real, verifiable, daily-synced data**. Visual ornament steals attention from that data. The 1996-engineering-report aesthetic — IBM Plex Sans Condensed at 72px, hairline rules, leader dots, mono tabular numerals, archival blue accent — is precisely the visual register that says "this person makes data legible and trusts you to read it." Every other portfolio in the AI-generated 2026 cohort opens with a gradient and a `</>` glyph. This one opens with a build manifest.

The single sync dot animation is enough motion. One accessory; everything else removed before leaving the house.

## Header

A 56px single-line bar in `--ink` on `--paper`, with a 1px `--rule` baseline. Wordmark left: **`oriz / me`** set in IBM Plex Sans Condensed 700, with the `oriz` half tracked +0.05em and the `/ me` half in `--archival`, no italic, no lowercase. The forward slash is the canonical family separator (also used in `oriz / pdf-tools`). Right of the wordmark, on tool/section pages, a breadcrumb in mono caps tracked +0.15em: `LIBRARY · FILMS`. Far right, three text-only affordances in mono: **`⌘K`** (command palette trigger), **`sign in`** (the only auth surface — opens `<AccountPanel>` from the trimmed oriz-ui), and a one-character **`☼` / `☾`** for theme toggle. No mega-nav, no logo lockup, no avatar.

## Footer

A two-line mono block in `--ink-soft` 12px:

```
── this page was built 2026-06-19T03:07Z from 41 APIs ────────────
oriz/me · MIT · ₹0 to host · source on github · part of oriz.in
```

The first line is the same provenance primitive as the header strip, but for the build (not the data sync — they are usually the same time but not always). The second line is the colophon. No newsletter, no social-icon strip, no "made with love." The `₹0 to host` line is a deliberate brand statement: this entire personal OS runs on Cloudflare Pages free tier + GitHub Actions free minutes. That fact is the site.

## What NOT to do

1. **No teal/violet/blue gradient hero.** No ambient `radial-gradient` glow at any opacity. No `backdrop-filter: blur()`. No glassmorphism. The surface is flat datasheet white. If a designer reaches for a hero gradient, the design has failed.
2. **No GitHub contribution heatmap as the homepage centerpiece.** The whole site is a daily build manifest — surfacing one stylised activity grid would undermine the more honest provenance-strip + leader-dotted-rows pattern. GitHub stats appear under `/code` as plain mono tables.
3. **No avatar, no professional headshot, no hero photo, no project thumbnails on the home page.** The data is the hero. If we ever add a single image anywhere, it goes on `/me/story` and is a passport-photo-sized portrait at 96×96 in a hairline `--rule` border, set in the right margin like a printed CV.
4. **No animated reveals, no scroll-triggered transitions, no stagger-in fade-up.** The 4px sync dot is the only motion. Reduced-motion users see the dot static.
5. **No emoji in chrome, no `</>` glyphs, no terminal-prompt mascots, no shipping-container icon, no rocket.** Wordmark is `oriz / me` — that's it.
6. **No "Available for hire" CTA button, no "Hire me" sticky bar, no "Book a call" widget.** The `available for ─ backend · ai/ml · full-stack engagements` line on the home page is the only hire-cue, set in mono at body weight, no link wrapping.
7. **No skill badges (React, Python, FastAPI tile wall).** Skills are demonstrated by the work shown, not asserted by a chest-thump grid.
8. **No carousel, no testimonial rotator, no "as seen on" logo strip, no "trusted by" row.** Static evidence only.
9. **No Outfit, no Inter, no Manrope, no Geist, no Satoshi.** Type lane is locked to IBM Plex Sans Condensed + Plex Sans + JetBrains Mono. These are the geometric-sans defaults of the 2024–2026 dev-portfolio cohort and the brief actively rejects them.
10. **No `--accent` swap toggle exposed in the UI.** The current site ships a 6-accent picker; the v2 design has one accent, archival blue, and one only. Theme toggle (light/dark) stays. Accent picker is removed.

## Migration notes (handed to D4)

The current oriz-me ships a teal+violet+glass+ambient-gradient design with Outfit + Inter + reveal-stagger animations and a 6-accent picker. v2 replaces that wholesale. Specifically:

- Drop the `glass` class and every `bg-white/[0.0X]` translucent surface — flatten to `--paper` with hairline rules.
- Drop `radial-gradient` and `bg-gradient-to-br` ambient overlays from layouts.
- Replace Outfit + Inter font imports with IBM Plex Sans Condensed + Plex Sans + JetBrains Mono. Remove the rest.
- Replace the 6-accent token system with one `--archival` blue.
- Keep the existing build-time data fetch (`pnpm fetch-data` cron). Surface its `_meta.builtAt` ISO timestamp as the provenance strip's text.
- Keep the existing command palette (`⌘K`) — globally available, indexed at build, no filtering.
- Remove every `reveal-stagger` / `reveal-scale` / `motion-safe:animate-*` class. Keep only the 4px sync-dot animation.
- The AI chat (Puter.js) and Firebase auth widgets stay as React islands but get re-skinned to flat datasheet style — no glass, no rounded-2xl pillows, no shadow.
