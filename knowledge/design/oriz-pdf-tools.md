---
type: design-brief
title: "oriz-pdf-tools v2 design brief"
description: 'Typesetter desk: cream manuscript, all-serif, green CTAs'
tags: [design, oriz-pdf-tools, v2]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - design/_family-rules
  - decisions/process/v2-design-implementation
---

# oriz-pdf-tools — design spec v2

A typesetter's desk for documents. Cream manuscript surface, all-serif type stack (yes, even buttons), ledger-green CTAs because no PDF utility ships green primaries. Sits beside oriz-image-tools (darkroom) — same workshop ethos, opposite craft. Voice: literate paralegal, not SaaS marketer. Files are *pages*, *leaves*, *signatures*. You *bind* documents, you don't merge PDFs.

## Surface + tokens

Six manuscript tokens — light:

```css
--paper:    #F4EFE6;  /* cream manuscript */
--ink:      #1A1814;  /* warm near-black, not pure */
--ledger:   #2D4A3E;  /* primary accent — CTAs, links, focus rings */
--vermilion:#B23A2A;  /* DESTRUCTIVE/REDACTION/ERROR ONLY — never CTA */
--margin:   #6B6457;  /* gutter text, page numbers, captions */
--rule:     #C9BFAE;  /* hairlines, dashed page-breaks, double-rule frames */
```

Dark variant inverts paper→`#1A1814` ink→`#EFE7D6`, ledger lifts to `#5C9379`, vermilion to `#D4604F`. Paper-grain SVG (feTurbulence baseFrequency=0.85, numOctaves=2) at 8% opacity tiled body background. Behind sticky header it sits below a 12px backdrop-blur.

## Type — all serif, no exceptions

**Display:** GT Sectra (licensed) with Source Serif 4 fallback, 36–48px, weight 500, letter-spacing -0.01em. Used for hero, tool-page titles, section heads.
**Body:** Source Serif 4 16/27, max-width 65–72ch, weight 400, optical sizing on. Must hold legibility for the 58 MDX longreads.
**Utility / numeric:** JetBrains Mono 13/20, used ONLY for: file sizes (`2.4 MB → 380 KB`), page ranges (`pp. 3–7, 12`), checksums (`sha256:9f2c…`), the page-number gutter, redaction coordinates. Mono is a *data* signal, not chrome.
**No sans-serif anywhere on this site.** Buttons are Source Serif 4 14px small-caps tracking +0.08em. Form labels, nav, tooltips, error toasts, modal titles, footer — all serif. This is the load-bearing typographic risk; do not soften it.

## Layout — home

Single page-shaped reading column, max 78ch, centered, with a notebook gutter of 8ch on the left holding faint page numbers in `--rule` JetBrains Mono. Hero: GT Sectra 48px "PDF tools that never leave your desk" — period included. One-line Sectra-italic 22px subtitle in `--margin`: *"On-device. Open source. Twenty-three implements for the documents craft."* Below: a single 720×220 dropzone framed in 1px `--rule` dashed, "Drop a leaf, or click to browse" in serif italic, no icon. Below dropzone, a four-column small-caps TOC of the 23 tools — NOT a card grid:

```
ORGANISE        CONVERT         SECURE          READ
merge           pdf → docx      redact          extract text
split           pdf → images    sign            ocr
reorder         images → pdf    encrypt         summarise
rotate          html → pdf      decrypt         outline
delete pages    md → pdf        watermark       compare
extract pages   ...             flatten         ...
```

Tool names lowercase Source Serif 4 14px, hover underlines in `--ledger`. Section headers small-caps tracking +0.12em in `--margin`. Dashed page-break separates each major section.

## Layout — tool page

Reading column flows: GT Sectra 36px tool title, two-paragraph Source Serif body explaining what the tool does and what stays on-device. Then the **column-to-workbench transition** — the brand's cross-tool gesture — when a file loads, the layout breaks out of 78ch into a 1080px-wide *workbench* enclosed in a double-rule frame drawn with CSS borders + `::before` inset 4px:

```
╔══════════════════════════════════════════╗
║  contract.pdf  ·  18 leaves · 2.4 MB     ║
║  ┌── pages ────────────────────────┐     ║
║  │ [1] [2] [3] [4] [5] [6] [7]…    │     ║
║  └─────────────────────────────────┘     ║
║                                          ║
║         [ Bind document ]                ║
╚══════════════════════════════════════════╝
```

Page thumbnails are 1px `--rule` framed leaves; selected page gets a 2px `--ledger` frame and a small-caps `KEEP` tag. Destructive actions (delete page, redact region) draw a 2px `--vermilion` frame and require a confirm modal whose title is "This will overwrite your leaves." Primary CTA: **`Bind document`** — Source Serif 14px small-caps, `--ledger` background, `--paper` text, 1px `--ink` border, 4px radius, no shadow. Secondary: ghost — same type, transparent fill, `--ledger` border.

## Layout — blog post

Single 68ch column, no sidebar. Marginalia: ordered-list numbers and footnote markers float into the left gutter in `--margin` JetBrains Mono 12px. Pull-quotes get a 3px `--vermilion` left rule, italic Source Serif 18/30, no quote marks. Footnotes live at the foot of the article above a 1px `--rule` hairline, numbered `¹ ² ³` in mono, body in serif 14/22, like a real book. Code blocks: JetBrains Mono 13/20 on a `#EBE3D2` tint — 4% darker than paper — with a 1px `--rule` left border only. Drop cap on the first paragraph: GT Sectra 64px, 3 lines tall, `--ledger` color.

## Signature — the dashed page-break

Between every major section on every page:

```
— — — — — — — — — — § 2 — — — — — — — — — —
```

CSS: `<hr data-section="N">` with `border: none; border-top: 1px dashed var(--rule); margin: 4rem 0;` and a `::before` pseudo-element holding `content: "§ " attr(data-section);` absolutely positioned center, JetBrains Mono 12px small-caps `--margin`, a 12px paper-colored gutter on each side of the bug to break the dash. Section number increments down the page. Long-form posts use Roman: `— i —`, `— ii —`. Plus the **running-foot** closes every page like a printed book:

```
─────  1  ─────  pdf-tools.oriz.in  ─────
```

A 1px `--rule` solid line with the page number left-of-center and the domain bug center, both JetBrains Mono 12px small-caps `--margin`, 96px from the bottom of the document.

## Header

Sticky, 64px tall, `--paper` with paper-grain at 8% behind a 12px backdrop-blur, double-rule baseline (1px `--ink` over 1px `--rule` 3px apart). Left: a 12×16 SVG dog-eared-page glyph (folded top-right corner, single fold-line stroke `--margin`) followed by wordmark **`oriz / pdf-tools`** in GT Sectra italic 20px — forward-slash, NOT middle-dot (middle-dot is image-tools' move). Right: small-caps Source Serif 13px nav `TOOLS · BLOG · ABOUT` with a `§` mark sliding in left of the link on hover via `::before`. Active route gets a 2px `--ledger` underline offset 6px. Auth button (when present): same small-caps treatment, ghost border.

## Footer

Opens with a running-foot rule, centered domain bug `─── pdf-tools.oriz.in ───` JetBrains Mono small-caps. Below: three columns, small-caps Source Serif 13px headers in `--margin`, body links serif 14px `--ink`:

```
COLOPHON              LINKS                 FAMILY
set in Sectra         github                oriz-image-tools
& Source Serif        rss                   oriz-blog
on-device only        changelog             oriz-home
MIT licence           contact               see all →
```

Final attribution line, centered, Source Serif 13px `--margin`, middle-dot separated — these are the **only** middle-dots on the site:

```
© 2026 Chirag Singhal · MIT · all processing on-device
```

## Don't

- No Acrobat red anywhere. Vermilion is reserved for redaction bars, delete-page, encrypt-overwrite warnings, and validation errors. CTAs are ledger green precisely because no competitor ships green.
- No Smallpdf-style colorful card grid with mascot. Tools are a four-column small-caps TOC.
- No middle-dot in the wordmark — that's image-tools. Forward-slash here.
- No Inter / no sans-serif. Even buttons are Source Serif. Do not water this down.
- No emoji. The dog-eared-page SVG is the brand glyph.
- No Fraunces — that budget belongs to blog and finance.
