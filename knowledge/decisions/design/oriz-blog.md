---
type: design-brief
title: "oriz-blog v2 design brief"
description: "An engineer's working notebook — cream paper, Fraunces drop-cap, cobalt accent, series-spine signature glyph, no card grid, no hero images."
tags: [design, oriz-blog, v2]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - design/_family-rules
  - decisions/process/v2-design-implementation
---

# oriz-blog — v2 spec

## Surface + tokens
| Token | Hex | Role |
|---|---|---|
| --paper | #FBFAF7 | Bone background; warm enough to read 30 min without glare |
| --paper-2 | #F4F1EA | Sidenote rail + footer band; one step deeper than paper |
| --ink | #11131A | Body text; AA on paper at 17px |
| --ink-2 | #5A5E6B | Meta, captions, sidenote body |
| --rule | #D9D2C2 | Hairline rules between sections, table borders |
| --cobalt | #1F4FD8 | Drop-cap, links, current-dot fill, series-spine accent |

Dark variant inverts paper→#12141B, ink→#E8E4D8, cobalt→#7AA0FF. No other hues.

## Type
- Display: Fraunces (variable, opsz 96, SOFT 50, wght 380) — H1, drop-cap (SOFT 100), section labels at SOFT 30
- Body: Source Serif 4, 17px / 1.65 / 66ch, wght 400, opsz auto
- Code: JetBrains Mono 15px / 1.55, ligatures off
- Scale: 1.250 modular on 17px → 13.6 / 17 / 21.25 / 26.6 / 33.25 / 41.5 / 51.9

## Layout — home
```
┌──────────────────────────────────────────────────────────────┐
│ oriz-blog                              [archive] [rss] [/]   │
├──────────────────────────────────────────────────────────────┤
│  An engineer's working notebook. 526 posts since 2019.       │
│  ●─●─○─○                                                     │
├──────────────────────────────────────────────────────────────┤
│  IN PROGRESS                                                 │
│  Building oriz · part 7 of 12      ●●●●●●⦿○○○○○  ·  3d ago  │
│  Firebase rules audits · 2 of 5    ●●⦿○○○        ·  1w ago  │
│  Tampermonkey patterns · 4 of 6    ●●●●⦿○        ·  2w ago  │
├──────────────────────────────────────────────────────────────┤
│  RECENT                                                      │
│  2026-06-18 · The drop-cap is a series spine                 │
│  2026-06-15 · Why 66ch is not arbitrary                      │
│  2026-06-11 · Submodule bumps without ceremony               │
├──────────────────────────────────────────────────────────────┤
│  BY CATEGORY                                                 │
│  firebase (84) · agents (61) · design (47) · git (39) ...    │
└──────────────────────────────────────────────────────────────┘
```

## Layout — post
```
┌──────────────────────────────────────────────────────────────┐
│ oriz-blog · Building oriz · part 7 of 12 · ●●●●●●⦿○○○○○      │
├──────────────────────────────────────────────────────────────┤
│  H1 in Fraunces opsz 96, SOFT 50, 41.5px, two lines max      │
│  2026-06-18 · 7 min · firebase, design                       │
│                                                              │
│  T he body opens with a 4-line drop-cap        │  ●  sidenote│
│  in Fraunces SOFT 100, cobalt. 66ch column.    │  │  rail    │
│  Source Serif 4 paragraphs. Sidenote rail to   │  │  shows   │
│  the right at paper-2 width 22ch, ink-2 13px.  │  ⦿  spine   │
│                                                │  │  vertical│
│  ## H2 sections in Fraunces SOFT 40, 26.6px.   │  ○         │
│                                                              │
│  Code blocks span full 66ch, JetBrains Mono.                 │
└──────────────────────────────────────────────────────────────┘
```

## Signature — concrete spec
Series spine: `●─●─○─○` rendered as JetBrains Mono `●` `○` glyphs joined by U+2500 box-drawing `─`. Filled `●` = published, hollow `○` = drafting, current = `⦿` enlarged 1.4× with cobalt fill. Connectors are `--rule` color. Appears on:
- home in-progress section — one row per series, inline after title
- post header meta row — inline, current dot enlarged
- post sidenote rail — vertical `│` connectors, current dot enlarged, sticky on scroll
- footer — single miniature row at 11px, ink-2 color

Drop-cap: first letter of post body in Fraunces SOFT 100, font-size set so cap-height = 4 line-heights (~110px at 17/1.65), `float: left`, margin-right 12px, color `--cobalt`. Renders only on `<article> > p:first-of-type::first-letter`.

## Header
Single line at 64px height. Wordmark `oriz-blog` in Fraunces SOFT 30 wght 500 left-aligned, three text links right-aligned (`archive`, `rss`, `/` for search). Hairline `--rule` border-bottom only. No nav drawer, no logo mark, no theme toggle in header (lives in footer).

## Footer
Three stacked lines, left-aligned, `--paper-2` band, 13px ink-2. Line 1: `●─●─○─○` miniature spine linking to current series. Line 2: `rss · archive · colophon · theme` text links. Line 3: `oriz-blog · 2019–2026 · source on github`. No columns, no newsletter, no social icons.

## What NOT to do (no-compromise list)
1. NO card grid of recent posts with cover images. Stratified text list only — in-progress, recent, by-category.
2. NO hero image, NO cover images on posts. Code blocks, tables, KaTeX equations are not images and are welcome.
3. NO scroll progress bar. Series spine in sidenote rail + reading-time pill in meta row carry that info.
4. NO newsletter signup, NO email capture modal. RSS at `/rss.xml` is the contract.
5. NO emoji in headers, nav, post titles, or category labels. Dots `●○⦿` are typographic glyphs, not emoji.
