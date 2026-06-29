---
type: design-brief
title: "oriz-home v2 design brief"
description: 'Hub: dark leather, monochrome until hover, mustard-yellow'
tags: [design, oriz-home, v2]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - design/_family-rules
  - decisions/process/v2-design-implementation
---

# oriz-home — design spec v2

> Master hub. Portal route. Single job: in 5 seconds prove this is a SYSTEM (10 coherent sub-domains) and route the visitor to the sub-site they need. The page is the SPINE of the family — dark, typographic, monochrome until you touch it.

## Surface + tokens

Dark spine. Two colors at rest, four interactive-only colors that appear on `:hover` / `:focus-visible` only.

```css
:root {
  /* Rest tokens — the only two colors visible on first paint */
  --paper:        #15110D;  /* deep ink with warm bias — leather spine */
  --paper-oled:   #0A0805;  /* optional OLED-er variant via @media */
  --ink:          #E8E2D1;  /* bone — body text, masthead, index rows */
  --ink-mute:     #8A8270;  /* hairline rules, mono caps, secondary */

  /* Interactive-only tokens — NEVER applied at rest */
  --mustard:      #F0DC5A;  /* category labels + numerals on hover/focus */
  --vermilion:    #C8412B;  /* RESERVED: only the .start-arrow + wordmark `z` strike */
  --ledger:       #6B8F71;  /* sub-domain mono strings on hover (dark-surface ledger green) */
  --highlighter:  #F0DC5A;  /* focus-visible 30% bg fill */
}
```

Body text `--ink` on `--paper` clears WCAG AA at 13.4:1. Mustard on dark clears AA Large. Vermilion on dark clears AA Large — only used on the `start anywhere ↓` arrow and the wordmark `z` strike, both display-sized.

## Type

- **GT Sectra** (fallback Newsreader) — masthead lockup, the 10 site names in the index, the `oriz` wordmark. Display weights: SemiBold 600 for "ALMANAC" and site names; Regular 400 italic for "ten · small · free · sites".
- **Inter Tight** 400 / 500 / 600 — manifesto body, descriptions, sign-in word, sitemap labels.
- **JetBrains Mono** 400 / 500 — index numerals (`01`–`10`), sub-domain strings (`books.oriz.dev`), masthead meta (`NO. 010 · JUN 2026`), CI deploy timestamp.
- No Fraunces. Reserved for blog + finance.

### The `oriz` wordmark — printers'-mark deletion

Set in GT Sectra SemiBold, tracking `-0.02em`. A 1px `--vermilion` hairline rule passes horizontally through the `z` glyph at x-height midline, extending 0.15em past the glyph on each side — like a copy-editor's strike-through. This is the ONE place vermilion appears in the wordmark, and it appears at first paint (it's part of the brand mark, not decoration).

## Layout — single broadsheet column, 920px, 4 bands

```
┌────────────────────────────────────────────────────────────────┐
│ ─── hairline rule ───────────────────────────────────────────  │
│ ORIZ · ALMANAC          NO. 010 · JUN 2026 · CHIRAG SINGHAL    │  band 1: masthead meta
│ ─── hairline rule ───────────────────────────────────────────  │
│                                                                 │
│              [oriz wordmark, GT Sectra, z-struck]               │  band 2: masthead lockup
│                                                                 │
│                  ten · small · free · sites                     │
│        one · sign-in · one · person · one · /etc                │
│                                                                 │
│                     start anywhere ↓                            │  ← lone vermilion mark
│                                                                 │
│ ─── hairline rule ───────────────────────────────────────────  │
│ 01   READ           Books            books.oriz.dev             │  band 3: index table
│ 02   READ           Book Lore        book-lore.oriz.dev         │
│ 03   WRITE          Blog             blog.oriz.dev              │
│ 04   WRITE          Journal          journal.oriz.dev           │
│ ... 10 rows total ...                                           │
│ ─── hairline rule ───────────────────────────────────────────  │
│                                                                 │
│ [4-column hairline-ruled sitemap table]                         │  band 4: colophon
│ Built with Next.js · Firebase · oriz-ui                         │
│ Deployed 2026-06-19 14:32 UTC · commit a13d713                  │
└────────────────────────────────────────────────────────────────┘
```

- Column max-width 920px, centered, side gutters 32px on mobile, 0 on desktop.
- Hairline rules: 1px `--ink-mute` at 40% opacity. Four rules total: above and below masthead meta, above and below the index.
- Vertical rhythm: 8px base, bands separated by 96px on desktop / 64px on mobile.

### Band 1 — Masthead meta

Single hairline ruled-in row, JetBrains Mono 11px tracked `+0.12em` UPPERCASE. `--ink-mute`.
Left: `ORIZ · ALMANAC`. Right: `NO. 010 · JUN 2026 · CHIRAG SINGHAL`. Far right: the word `sign in` set in Inter Tight 14px with a 1px underline (offset 3px) — the only chrome affordance on the page. No nav links anywhere.

### Band 2 — Masthead lockup (the hero)

Three centered lines, generous breathing:

```
                  o r i z          ← GT Sectra 96px, letter-spacing 0.04em, the `z` struck
                                     by a 1px vermilion hairline at x-height midline
              ten · small · free · sites    ← GT Sectra 28px italic, --ink-mute
   one · sign-in · one · person · one · /etc ← Inter Tight 16px italic, --ink-mute
```

Em-spaces between dot-separated tokens. The two italic lines use `--ink-mute` (lighter than `--ink`) to recede behind the wordmark. A single centered `·` (vermilion) is NOT used — vermilion is reserved.

Below the manifesto, on its own line, centered:

```
.start-arrow { color: var(--vermilion); }   /* THE one exception */
```

Set as `start anywhere ↓` — Inter Tight 14px, vermilion `#C8412B`, with the down-arrow glyph `↓` at the same color. The only color visible on first paint. It is a real `<a href="#index">` jumping to band 3.

### Band 3 — The index (numbered TOC table)

Ten rows. NO card grid. Set as a `<ol>` with `display: grid; grid-template-columns: 48px 120px 1fr 240px;` — number / category / name+description / sub-domain.

```
01   READ        Books          A second-life library, by-default-public.    books.oriz.dev
02   READ        Book Lore      Marginalia worth keeping.                    book-lore.oriz.dev
03   WRITE       Blog           Long-form notes, drafted in the open.        blog.oriz.dev
04   WRITE       Journal        End-to-end-encrypted daily entries.          journal.oriz.dev
05   MAKE        Cards          Spaced-repetition flashcards, plain text.    cards.oriz.dev
06   MAKE        URLs to MD     Paste a URL, get a clean Markdown file.      urls-to-md.oriz.dev
07   TOOL        PDF Tools      Merge, split, redact — never uploads.        pdf-tools.oriz.dev
08   TOOL        Image Tools    Convert, compress, scrub EXIF locally.       image-tools.oriz.dev
09   TRACK       Finance        Graph-paper ledger for personal money.       finance.oriz.dev
10   META        Home           This page.                                   oriz.dev
```

Column type:
- `01`–`10` — JetBrains Mono 13px, `--ink-mute` at rest.
- `READ` / `WRITE` / `MAKE` / `TOOL` / `TRACK` / `META` — JetBrains Mono 11px UPPERCASE tracked `+0.16em`, `--ink-mute` at rest.
- Site name — GT Sectra SemiBold 22px, `--ink` at rest.
- Description — Inter Tight 14px, `--ink-mute`.
- Sub-domain — JetBrains Mono 12px, `--ink-mute` at rest, right-aligned.

Row height 64px, separated by 1px `--ink-mute` 20% hairlines. Each row is `<a>` wrapping the whole grid cell — entire row clickable.

## No-compromise spec — monochrome until hover

```css
/* REST: only --ink and --paper apply to elements (plus the lone arrow + z-strike). */
.row { color: var(--ink); background: transparent; }
.row .num,
.row .cat,
.row .domain { color: var(--ink-mute); }

/* HOVER: row comes alive. */
.row:hover { box-shadow: inset 0 -1px 0 var(--mustard); }
.row:hover .cat    { color: var(--mustard); }
.row:hover .domain { color: var(--ledger);  }
.row:hover .num    { color: var(--mustard); }

/* FOCUS-VISIBLE: same as hover + 30% highlighter wash. */
.row:focus-visible {
  background: color-mix(in oklab, var(--highlighter) 30%, transparent);
  box-shadow: inset 0 -1px 0 var(--mustard);
  outline: none;
}
.row:focus-visible .cat,
.row:focus-visible .num    { color: var(--mustard); }
.row:focus-visible .domain { color: var(--ledger);  }

/* The single concession from first paint. */
.start-arrow { color: var(--vermilion); }

/* The wordmark strike — also from first paint, it is part of the mark. */
.wordmark .z-strike { background: var(--vermilion); height: 1px; }
```

Mustard, ledger green, and the highlighter wash are unreachable until the user moves a pointer or tabs into a row. The page TEACHES interactivity through the lone vermilion arrow, then REWARDS it with color.

## Header

A single hairline rule top, then band 1 (masthead meta). No nav links — sub-sites are reached only via the index. The word `sign in` is the only header affordance, plain Inter Tight 14px, underlined, opens the shared `AuthModal` from `@chirag127/oriz-ui`. When signed in, replace with the user's first name + a 1px-underline `sign out`.

## Footer (band 4 — colophon)

A 4-column hairline-ruled `<table>` with every sub-site grouped by category, plus a meta column for `/about`, `/changelog`, `/privacy`, `/terms`. Below the table, a single mono line:

```
Built with Next.js · Firebase · @chirag127/oriz-ui
Deployed {{ DEPLOY_TIMESTAMP }} UTC · commit {{ GIT_SHA_SHORT }}
```

`DEPLOY_TIMESTAMP` and `GIT_SHA_SHORT` are injected by the GitHub Actions matrix-deploy workflow at build time (`NEXT_PUBLIC_DEPLOY_TIME`, `NEXT_PUBLIC_GIT_SHA`). JetBrains Mono 11px, `--ink-mute`. No copyright line, no social links, no "back to top" — the page is short enough.

## What this spec forbids

1. No emoji-prefixed cards in a CSS grid. Kill the v1 page.
2. No `8 sites · 461 books · 750 cards · 492 posts` stats row. The masthead `NO. 010` carries scale.
3. No hero illustration, 3D blob, or animated gradient. The masthead lockup IS the hero.
4. No Fraunces.
5. No cream surface. Dark anchors the family.
6. No color visible from first paint except the lone vermilion `start anywhere ↓` arrow and the vermilion hairline through the wordmark `z`.
