---
type: design-brief
title: "oriz-cards v2 design brief"
description: 'Credit card dashboard: slate surface, carbon-blue, vermilion negatives'
tags: [design, oriz-cards, v2]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - design/_family-rules
  - decisions/process/v2-design-implementation
---

# oriz-cards — design spec v2

A Bloomberg-terminal-for-Indian-credit-cards. ~750 card profiles across 35 issuers. The home page collapses 750 down to a shortlist of 3 in under a minute via a filter rail and a ledger of rows — never a marketing grid. The detail page is a long, sober prospectus. The signature is a CSS-rendered embossed card carrying the signed-in user's name.

## Surface + tokens

Slate grey, not cream. Reads cool-archival, distinct from oriz-finance's warm graph-paper.

| Token | Light | Dark |
|---|---|---|
| `--surface` | `#E8EAEE` (cool slate paper) | `#171922` (deep slate) |
| `--surface-raised` | `#F2F4F7` | `#21232E` |
| `--ink` | `#0E1116` | `#E6E8EE` |
| `--ink-muted` | `#5C6470` | `#8B92A0` |
| `--rule` | `#C9CDD4` | `#2E323D` |
| `--accent` (carbon blue, PRIMARY) | `#2B3A55` | `#7C9AD4` |
| `--negative` (stamp vermilion, RESERVED) | `#B8362A` | `#E26A5C` |
| `--brass` (foil, chip motif only) | `#B8923A` | `#D4AE5C` |

Vermilion only on: negative deltas, late-fee figures, "Apply" CTA on detail pages (never list rows). Brass only on the chip motif and wordmark middle-dot.

## Type

- **Display — Geist Mono 700/900.** Wordmark, H1, big numerics, tool names. Wide mono reinforces the screener/terminal metaphor: every card is a row in a database, every fee is a number in a column. Serif would cue editorial-magazine, which is exactly the NerdWallet trap we are avoiding. Mono signals "data, aligned, comparable."
- **Sub-headings — Inter Tight 500**, tracking `-0.005em`.
- **Body — Inter Tight 400**, tracking `-0.005em`.
- **Numerics — JetBrains Mono 500**, `font-variant-numeric: tabular-nums; font-feature-settings: "zero" 1;` (slashed zero). Non-negotiable — joining fees, APRs, reward rates, and limits must align vertically across rows.

## Layout — home (`/`)

Two-pane, no hero marketing block.

- **Filter rail — left, 320px, sticky.** Sections: Issuer (35 checkboxes, scrollable), Network (Visa/Mastercard/Amex/RuPaY/Diners), Fee bracket (Free / ≤₹500 / ≤₹2,500 / ≤₹10,000 / >₹10,000), Reward type (cashback/points/miles/fuel), Income eligibility slider (₹0–50L), LTF toggle, Lounge access toggle. Filter labels Inter Tight 500 13px; counts JetBrains Mono 12px in `--ink-muted`. Active filters render as `[ × ICICI ]` mono chips at the rail top.
- **Ledger — right, fluid.** Header row (sticky, 40px, `--rule` bottom border): `CARD ▾ · JOIN · ANNUAL · REWARDS · APR · ▢`. Rows 64px tall, `1px solid --rule` between, hover `--surface-raised`. Per row: 96×60 thumbnail (the embossed-card component scaled), card name (Inter Tight 500 15px) + issuer (Inter Tight 400 12px `--ink-muted`) stacked, then four right-aligned JetBrains Mono 14px columns: joining fee, annual fee, rewards rate (`1.5%` / `4 pts/₹100`), APR (`3.50% p.m.`); negatives in vermilion, "LTF" rendered as a brass tag. Right edge: a single 18×18 compare checkbox. Click row → detail page. No star ratings, no rosettes, no editor's-pick badges.
- **Compare drawer — bottom-right, persistent.** 360×auto, `--surface-raised`, `1px solid --rule`, no shadow. Header: `COMPARE · 0/4` mono. Empty state: muted `add up to 4 cards`. Filled: stacked mini-rows (thumbnail + name + ×). Footer button: `[ COMPARE → ]` Geist Mono 700 in `--accent`, disabled below 2.

## Layout — detail (`/card/:slug`)

- **Hero — embossed card, left 480px; key facts right.** Right column: card name H1 Geist Mono 900 32px; one-line positioning Inter Tight 400 15px `--ink-muted`; four-stat strip (joining/annual/rewards/APR) JetBrains Mono 20px; `[ APPLY → ]` 44px CTA in vermilion (only place vermilion is a CTA).
- **Spec table — full width below.** Sections rendered as mono section headers (`§ ELIGIBILITY`, `§ FEES`, `§ ATM`, `§ TRANSACTIONS`, `§ FUEL`, `§ LIMITS`, `§ INSURANCE`, `§ REWARDS`, `§ LOUNGE`) with two-column rows: label Inter Tight 400 14px left, value JetBrains Mono 14px right-aligned. Footnote disclosures Inter Tight 400 12px `--ink-muted` directly under the offending row, prefixed `† `.
- Compare drawer persists.

## Signature — embossed card component

CSS-only, no images. Real CR80 proportions: 86×54mm rendered at 1px = 0.25mm density (344×216 in hero, 140×88 in list/drawer). Background: linear-gradient `145deg, #2B3A55 → #1A2438` for default Visa stock; per-card override via CSS var `--card-stock`. Embossed text uses `text-shadow: 0 1px 0 rgba(255,255,255,.18), 0 -1px 0 rgba(0,0,0,.45)` plus a subtle `transform: translateZ(0)`. Layout:

- Top-left: issuer logo (SVG, 32px tall, white at 88% opacity).
- Bottom-right: network logo (SVG, 28px tall).
- EMV chip: 44×34 brass gradient rectangle at left-center, 28% from top, with five horizontal hairlines (`--brass` to `#8B6E2A`).
- BIN window: Geist Mono 700 18px (hero) / 11px (list), `4242 •••• •••• ••••` — first 4 chars are the real BIN, rest dotted glyphs.
- Cardholder line: Geist Mono 700 14px (hero) / 9px (list), uppercase, pulled from Firebase auth `displayName`. Fallback `YOUR NAME HERE`. Positioned bottom-left, 14% from bottom.
- Expiry: `MM/YY` placeholder `••/••` in Geist Mono 11px, just above the cardholder line.

Same component renders at 140×88 in ledger thumbnails and drawer mini-rows — same emboss, same name, smaller type clamp.

## Header

56px thin bar, no border, `--surface`. Left: wordmark `oriz·cards` in Geist Mono 700 18px — the middle `·` is replaced by an 8×8 brass-gradient square (the chip motif). Right: filter count `742 cards` JetBrains Mono 12px `--ink-muted`, then auth avatar (28px, initials in Geist Mono if no photo). No mega-nav, no dropdowns, no search (filter rail is search).

## Footer

Statement-stub. `--rule` top border, 32px top padding, 24px bottom. Four-column grid (`Catalog · Methodology · Data · Legal`), each column header Geist Mono 700 11px uppercase tracking `0.08em`, links Inter Tight 400 13px stacked. Below the grid, a single mono line: `LAST REFRESHED 2026-06-19 · 742 CARDS · 35 ISSUERS · SOURCE: ISSUER WEBSITES` in JetBrains Mono 11px `--ink-muted`. No social icons. No newsletter form. No "trusted by" logos. No copyright flourish — just `© oriz 2026` mono, right-aligned, same line.
