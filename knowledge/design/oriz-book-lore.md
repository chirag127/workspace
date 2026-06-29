---
type: design-brief
title: "oriz-book-lore v2 design brief"
description: 'Aged-cream reading-room: pencil-red marginalia, bottle-green ribbon'
tags: [design, oriz-book-lore, v2]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - design/_family-rules
  - decisions/process/v2-design-implementation
---

# oriz-book-lore — v2 spec

## Surface + tokens
| Token | Hex | Role |
|---|---|---|
| --paper | #F2EAD8 | Aged-cream surface; warmer than blog's bone, reads as "old book that lived on a desk" |
| --paper-2 | #E8DEC6 | Margin column band, footer colophon strip, blockquote backing |
| --ink | #1A1611 | Warm-black body; AA on paper at 17px |
| --pencil | #B71C1C | Pencil-red marginalia, section-label rules, sufficiency dots, middot |
| --bottle | #2F5141 | Bottle-green reading ribbon (6px vertical strip), "narration" label tint |
| --brass | #8C6A2E | Page numbers, breadcrumb spine separators, drop-cap "No." numerals |

Dark variant: paper→#1B1813, paper-2→#221E18, ink→#EDE3CD, pencil→#E07A7A, bottle→#7DB39A, brass→#C9A864. Cream commits to the metaphor in light mode; dark mode reads as candle-lit reading room (NOT a black void).

## Type
- Display: Cormorant Garamond, italic small-caps for section labels and the wordmark; regular roman 600 for headlines (`Books, read on your behalf` opens at 41.5px, 1.15 leading, 36ch max)
- Body: Source Serif 4, 17px / 1.7 / 64ch, wght 400, opsz auto — slightly looser leading than blog (commentary breathes)
- Hand: Caveat 18px / 1.35 for marginalia notes; rotated `−1.5deg` via `transform`, color `--pencil`, never on paper-2 backing
- Mono utility: JetBrains Mono 13px small-caps for breadcrumb spine, footer link row, sufficiency rating glyphs — never for code blocks (this site has none)
- Scale: 1.250 modular on 17px → 13.6 / 17 / 21.25 / 26.6 / 33.25 / 41.5

## Layout — home (reading-room dashboard, NOT a grid)
```
┌──────────────────────────────────────────────────────────────────┐
│ book·lore                                  [shelves] [about] [/] │
├──────────────────────────────────────────────────────────────────┤
│  No. 047                                                         │
│  Books, read on your behalf.                                     │
│  Forty-seven volumes annotated since 2024. ●●●●○ sufficient.     │
├──────────────────────────────────────────────────────────────────┤
│  RECENTLY ANNOTATED                                              │
│                                                                  │
│  Thinking, Fast and Slow · Kahneman              ●●●●●           │
│    — overview · content map · analysis · narration               │
│                          ╲ this one finally clicked on reread    │
│                                                                  │
│  The Pragmatic Programmer · Hunt & Thomas        ●●●●○           │
│    — overview · content map · analysis · narration               │
│                                                                  │
│  Atomic Habits · Clear                           ●●●○○           │
│    — overview · content map · — — —                              │
│                          ╲ narration pending; analysis is enough │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│  SHELVES                                                         │
│  ─────────────────────  cognition           14 volumes  ─────────│
│  ─────────────────────  software craft      11 volumes  ─────────│
│  ─────────────────────  history & memoir     9 volumes  ─────────│
│  ─────────────────────  finance & decision   7 volumes  ─────────│
│  ─────────────────────  fiction (rare)       6 volumes  ─────────│
└──────────────────────────────────────────────────────────────────┘
```

Running list, never a grid. Each row: title in Cormorant 21.25px, author in Source Serif 4 italic 15px, sufficiency rating right-aligned (●●●●● filled = all 4 sections + reread; ●●●●○ = all 4 once; ●●●○○ = 3 of 4). Below: the four section labels in mono small-caps separated by middots, dimmed `— — —` for any unwritten section. Optional Caveat marginalia note hangs in the right column with a thin `--pencil` rule bracket connecting to the title row. Shelves are horizontal `--rule` lines (1px, `--brass` at 30% opacity) with discipline name + count typeset INSIDE the rule (background-color `--paper` cuts the line behind the text).

## Layout — book page (cover-less, four MDX sections)
```
┌──────────────────────────────────────────────────────────────────┐
│ book·lore · cognition · Thinking, Fast and Slow                  │
├─┬────────────────────────────────────────────────┬───────────────┤
│▌│  Thinking, Fast and Slow                       │               │
│▌│  Daniel Kahneman · 2011 · 499pp                │  ╱ I read     │
│▌│  ●●●●● sufficient · reread on 2026-04-12       │  ╱ this on a  │
│▌│  reading path: overview → analysis → narration │  ╱ flight to  │
│▌│                                                │    Pune. The  │
│▌│  ──────────── overview ────────────            │    ─────────  │
│▌│  Body in Source Serif 4 sets at 64ch. Outer    │   airport     │
│▌│  margin column on the right holds Caveat       │   wifi died   │
│▌│  marginalia notes pulled from MDX `margin:`    │   at chapter  │
│▌│  callouts, rotated −1.5deg, pencil red.        │   nine.       │
│▌│                                                │               │
│▌│  ──────────── content map ────────────         │               │
│▌│  Numbered chapter outline with one-line gloss  │               │
│▌│  per chapter. Brass page numbers right-align.  │               │
│▌│                                                │               │
│▌│  ──────────── analysis ────────────            │               │
│▌│  Argued commentary. Pull-quotes set in         │               │
│▌│  Cormorant italic 26.6px, indented 4ch, no     │               │
│▌│  quote marks, pencil rule above and below.     │               │
│▌│                                                │               │
│▌│  ──────────── narration ────────────           │               │
│▌│  First-person retelling. Bottle-green tinted   │               │
│▌│  drop-cap on the first paragraph signals       │               │
│▌│  "voice changes here."                         │               │
│▌└────────────────────────────────────────────────┴───────────────│
│ ▌ = 6px bottle-green reading ribbon, pinned to article left edge │
└──────────────────────────────────────────────────────────────────┘
```

The four sections separate via a centered red rule with the label in Cormorant italic small-caps 13px, `--pencil` color, kerned +0.08em, dashes flanking: `─────── overview ───────`. Labels are ALWAYS lowercase. Unwritten sections render the rule + label dimmed to `--ink` 25% opacity with the text `— pending —` below in italic.

Sufficiency rating: 5-dot row in `--pencil`. Five filled = all four sections written + at least one reread documented. Four = all four once. Three = three sections. Below three = the page redirects to a "stub" template that shows only what exists.

Reading path: italic Source Serif 4 line `reading path: overview → analysis → narration` suggests the order Chirag actually recommends for THIS book; `→` is `→` U+2192 in `--brass`. Defaults to the canonical 1→2→3→4 if no `path:` frontmatter.

## Signature — live marginalia + reading ribbon

**Marginalia.** MDX callout syntax: ` ::: margin "this one finally clicked on reread" ::: ` placed inline after a paragraph. The Astro plugin extracts `margin:` blocks, anchors them to the next-following paragraph's bounding box top, renders them in the right outer column (22ch wide, starting at `--paper`'s right edge + 32px gutter) in Caveat 18px `--pencil`, transformed `rotate(-1.5deg)`. A 1px `--pencil` hairline `╲` (45deg, `width: 24px`, `transform-origin: top-left`) connects the note's top-left to the paragraph's right edge — drawn via an absolutely-positioned `::before` pseudo-element, NOT SVG. On screens ≤900px the margin column collapses; notes inline as `<aside class="pull-aside">` block-level pull-asides indented 2ch with a left `--pencil` 2px border, rotation removed.

**Reading ribbon.** A `<div class="ribbon">` 6px wide, `background: --bottle`, `position: sticky; top: 0; height: 100vh` pinned to the article's left padding (NOT the viewport edge). Tracks last-read paragraph by `IntersectionObserver` and writes `localStorage[`bookLore:${slug}:para`] = paragraphIndex` + scroll offset on every observation. On mount, if a value exists, the page silently `scrollIntoView({block:'center'})` to that paragraph after a 200ms delay — no "resume reading?" modal, no toast. The ribbon has a single horizontal notch (1px brass) at the saved position, visible even when the reader scrolls past.

## Header
Single horizontal `--brass` 1px rule at 56px from top, no chrome bar, no fill. Wordmark `book·lore` in Cormorant italic small-caps 21.25px, the middot `·` is `--pencil`. Right side: three text links `shelves · about · /` in JetBrains Mono small-caps 12px `--ink-2`, no underlines until `:hover`. On book pages a breadcrumb spine sits BELOW the rule, indented to article column: `book·lore · {shelf} · {title}` in JetBrains Mono small-caps 11px, separators are `--brass` middots. No logo mark, no theme toggle (lives in footer).

## Footer
Two-line colophon strip on `--paper-2` band, 13px `--ink` for paragraph and `--ink-2` for utility links.

Line 1 (Source Serif 4 italic, 64ch max, justified): *"Set in Cormorant Garamond and Source Serif 4 on aged cream. Marginalia in Caveat, pencil red. Reading ribbon in bottle green. Forty-seven volumes since the autumn of 2024."*

Line 2 (JetBrains Mono small-caps 11px, separated by `--brass` middots): `shelves · rss · colophon · theme · source on github`

No newsletter, no email capture, no social icons.

## What NOT to do (no-compromise list)
1. NO card grid on home — that's oriz-books's catalogue territory. Running list with shelves-as-rules only.
2. NO accent blue, NO accent purple, NO teal — palette is cream + warm-black + pencil red + bottle green + brass. Five colors, no others.
3. NO emoji eyebrows ("📖 Book Lore", "🧠 Core Concepts", "📝 Notes"). Italic small-caps section labels carry the work.
4. NO white surfaces anywhere — `#FFF` does not appear in any token, modal, code-block backing, or input field. Cream commits.
5. NO leader-dotted TOC as the signature element — that belongs to oriz-finance now. Book-lore's signature is marginalia + ribbon.
6. NO cover images on book pages. The four MDX sections are the page; a cover would lie about what the destination is (commentary, not catalogue).
7. NO progress percentage or scroll bar at top of viewport — the bottle-green ribbon's notch is the only progress affordance.
