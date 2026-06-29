---
type: design-brief
title: "oriz-finance v2 design brief"
description: 'Finance: graph-paper grid, decimal-aligned numbers, teal, Fraunces'
tags: [design, oriz-finance, v2]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - design/_family-rules
  - decisions/process/v2-design-implementation
---

# oriz-finance — design spec v2

Calculator workbench for the salaried Indian, 22-45, who is tired of lead-capture popups and "talk to advisor" CTAs. ~28 calculators across 4 ledgers (Investments / Loans & EMI / Banking & savings / Tax & salary). The page IS a ledger sheet: a literal printed graph grid lives behind everything, hairline tan rules separate sections, every number is decimal-aligned and tabular. No charts trying to be exciting; no upsell.

## Surface + tokens

Light is canonical. Dark is a recessed inversion (graph grid stays visible).

```
--surface       #F0F2EE   /* engineering-print white, hair of green */
--ink           #11201C   /* near-black with teal undertone */
--rule          #C9B98A   /* hairline tan, for section + table rules */
--accent        #0F766E   /* graph teal — H1 underline, totals, focus ring */
--muted         #5C6B66   /* assumption text, formula labels */
--negative      #B23A2A   /* losses, tax owed, overruns — never decorative */
```

Graph grid is a CSS `background-image` painted on `body`, NOT an `<img>`:

```css
body{
  background:
    linear-gradient(var(--surface),var(--surface)),
    repeating-linear-gradient(0deg,  rgba(15,118,110,.06) 0 1px, transparent 1px 8px),
    repeating-linear-gradient(90deg, rgba(15,118,110,.06) 0 1px, transparent 1px 8px);
  background-blend-mode: normal, multiply, multiply;
}
```

8px squares, 6% opacity teal. Every 5th line at 9% opacity gives the major-grid feel. Grid does NOT scale with content; it stays fixed to the viewport so scrolling reads as paper sliding under a fixed sheet.

## Type

- **Display — Fraunces** (Soft -10, Opsz 144, wght 500). H1 only, 64px / 1.05, tracked -0.01em. Used on home headline and on each calculator-page title. That's it. Small footprint, big presence.
- **Body — Source Sans 3.** 16/26 for prose, 14/22 for table cells, 13/20 for marginalia. Weights 400 / 600. No italics for emphasis — use `--accent` underline instead.
- **Numeric — JetBrains Mono.** ALL numbers, including in body prose, in table cells, in inputs, and in the result hero. Mandatory:

  ```css
  .num{ font-variant-numeric: tabular-nums slashed-zero; }
  ```

  Indian grouping (lakhs / crores, NOT Western thousands) is non-negotiable. Render every rupee value through:

  ```js
  new Intl.NumberFormat('en-IN', { maximumFractionDigits: 0 }).format(n)
  // 1234567 → "12,34,567"   (NOT "1,234,567")
  ```

  Rupee glyph `₹` set 0.1em smaller than the digits beside it via `<span class="rupee">₹</span>` with `font-size: .9em; margin-right: .12em;`. The glyph is Source Sans 3, the digits are JetBrains Mono — the size step makes the seam invisible.

## Layout — home

1. **Folio header strip** (issue strip). 2 rows, full-bleed, hairline tan rule beneath.
   - Row 1: `oriz-finance` wordmark left (Source Sans 3 600), nav (`Investments / Loans / Banking / Tax`) center, `⌘K` + theme toggle right.
   - Row 2: `FOLIO 001 · finance.oriz.in · ISSUE 06 / 2026` in JetBrains Mono caps, tracked +0.15em, 12px, `--muted`.
2. **Headline.** Fraunces 64px: `A folio of 28 calculators for Indian money.` Sub-line in Source Sans 3 18/28: `SIP, EMI, FIRE, FD, RD, PPF, NPS, HRA, TDS, take-home. No popups. No advisor CTA. Inputs never leave your device.`
3. **Inline live SIP calculator.** Three inputs in a row (monthly amount / years / expected return), result number to the right. Result updates on `input` event. JetBrains Mono 48px for the result, leader-dotted line beneath: `Final corpus . . . . . . . . . . . . . . . . . . . ₹47,12,839`. This is the only "hero" — proves the page works without scrolling.
4. **Catalogue — leader-dotted TOC of all 28 calculators**, grouped under 4 ledger headings. NO card grid. NO icons. Each row is `name . . . . . . . . . . brief`. See Signature.

## Layout — calculator page

Three-column horizontal slab, 12-col grid, 1200px max:

- **Left (cols 1-4) — Inputs.** Stacked label-over-field. Numeric inputs are right-aligned, JetBrains Mono, 18px. Sliders below each input mirror the value. Section ends with a hairline tan rule.
- **Center (cols 5-8) — Result.** One big number, JetBrains Mono 56px, with `₹` 0.1em smaller. Below it a 200px-tall sparkline-style chart drawn as a single `--accent` stroke on the graph grid (no fill, no gradient, no axis labels — the grid IS the axis). Tiny mono caption: `5Y · 10% p.a. · monthly compounding`.
- **Right (cols 9-12) — Formula + assumptions.** Formula typeset in JetBrains Mono on its own line: `M = P × ({(1+i)^n − 1} / i) × (1+i)`. Below, `--muted` Source Sans 3 13/20 list of assumptions: compounding cadence, tax treatment, inflation handling, edge cases.

Below the slab, full-width: **year-by-year ledger table.** Columns: `Year │ Opening │ Invested │ Interest │ Closing`. Header row is JetBrains Mono caps 12px, tracked +0.1em, `--muted`. Body rows alternate surface and `rgba(201,185,138,.08)`. Decimal alignment via `text-align: right` on numeric columns. Final row is the **double-rule totals row** (see Signature).

## Signature

These two motifs appear nowhere else in the family. Finance owns them.

**1. Leader-dotted TOC.** Every catalogue row, every result label, every footer link list. Implementation:

```css
.toc-row{ display:flex; align-items:baseline; gap:.5rem; }
.toc-row .name{ flex:0 0 auto; }
.toc-row .leader{ flex:1 1 auto; border-bottom:1px dotted var(--rule); transform: translateY(-.35em); }
.toc-row .value{ flex:0 0 auto; font-variant-numeric: tabular-nums; }
```

The `transform` lifts the dotted leader so it sits on the x-height baseline, exactly like a printed index.

**2. Double-rule totals row.** Every results table closes with:

```css
.totals td{
  border-top: 3px double var(--ink);
  border-bottom: 3px double var(--ink);
  font-weight: 600;
  padding-block: .6rem;
}
```

`border-style: double` renders as `══` — the printed-ledger convention for "this row is the sum." Used on the year-by-year table totals, on the tax-summary final liability, on the EMI grand-total row.

## Header — issue strip

As described above. 2 rows, full-bleed, hairline tan rule. Row 2 carries the `FOLIO · domain · ISSUE MM / YYYY` line in mono caps tracked +0.15em — gives every page a "this is a published sheet" frame.

## Footer — closing the books

3-column layout, full-bleed, opens with a hairline tan rule.

- **Col 1 — Index.** Leader-dotted TOC of all 28 calculators (same component as home), grouped by ledger. Mini version: 12px Source Sans 3, dotted leader, page count or "live" on the right.
- **Col 2 — Family.** Leader-dotted list of the 9 sister oriz-* sites with one-line descriptions. Same TOC component.
- **Col 3 — Colophon.** Source Sans 3 prose: typefaces (Fraunces / Source Sans 3 / JetBrains Mono), Indian numbering source (`Intl.NumberFormat('en-IN')`), formula provenance, last-revised date in mono.

Footer closes with a double-rule strip across the full width and a single mono line, centered, 12px, tracked +0.1em:

```
end of folio · MIT · CC BY 4.0 · no inputs leave your device
```

That's the page. The grid is the chrome; the dotted leaders are the index; the double rule is the sum. Nothing else is asked to perform.
