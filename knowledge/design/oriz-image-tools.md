---
type: design-brief
title: "oriz-image-tools v2 design brief"
description: 'Browser darkroom: 13 client-side tools, #C8FF3C accent, no uploads'
tags: [design, oriz-image-tools, v2]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - design/_family-rules
  - decisions/process/v2-design-implementation
---

# oriz-image-tools — design spec v2

> Browser darkroom. 13 client-side image tools. Zero uploads, zero pastel
> illustrations, zero reassurance copy. The histogram is the brand.

Locked per `_FAMILY-RULES.md`: dark surface, Space Grotesk display, phosphor
`#C8FF3C` accent. This site is one of four dark sites in the family and the
only one whose accent is a non-warm, non-red colour — the darkroom metaphor
earns both decisions.

---

## 1. Surface + tokens

```css
--ink:        #0E1116;   /* near-black surface — darkroom walls */
--paper:      #F2EEE3;   /* canvas substrate when an image is loaded */
--ink-2:      #161A21;   /* control-rail surface, one stop up from --ink */
--line:       #232934;   /* hairlines, control borders */
--phosphor:   #C8FF3C;   /* primary accent — selection, focus, scrub head */
--rgb-r:      #FF3B3B;   /* histogram red channel — IS the brand */
--rgb-g:      #3BFF6E;   /* histogram green channel */
--rgb-b:      #3B7BFF;   /* histogram blue channel */
```

Radius `4px` everywhere. Shadows `0`. Borders `1px solid var(--line)`. The
RGB triad tokens are first-class — they drive the histogram, the channel
toggles in the photo-editor tool, and the 3-dot footer pulse. Light variant
swaps `--ink → #F8F6F0`, `--ink-2 → #FFFFFF`, keeps the RGB triad and
phosphor identical (they survive both surfaces).

## 2. Type

Space Grotesk (display, 500/600), Inter (body, 400/500), JetBrains Mono
(EXIF, hex, dimensions, kB deltas, slider readouts). Scale is tight:
`12 / 14 / 16 / 20 / 28 / 48`. The `48` cut is reserved for **numbers** —
filesize before/after, percentage scale, megapixel count. No headline ever
hits 48. Slogans don't exist on this site.

## 3. Layout — home (contact sheet)

Single viewport. No scroll on desktop ≥1080px tall.

- **Header** (56px, see §6).
- **Search field** pinned top-centre, 480px wide, autofocused on load.
  Placeholder: `compress · resize · remove-bg · …` cycling every 4s.
  `⌘K` from anywhere refocuses it. Typing filters the grid live.
- **Contact-sheet grid**: 13 cells, CSS grid `repeat(auto-fit, 180px)`,
  gap `1px` filled by `--line` so cells share hairlines like a real
  contact sheet. Each cell: 180×180, `--ink-2` fill, single mono glyph
  centred (stroke icons, 32px, `--paper` at 80%), tool name beneath in
  Space Grotesk 14/500. Hover: cell flips to `--phosphor` fill, glyph
  and label go `--ink`. No descriptions, no "AI-powered" badges.
- **Footer histogram strip** (see §5) — 100vw × 64px, immediately above
  the status line. On first load it pulses with a synthetic
  `sin(t)`-driven RGB curve so the page never looks dead; once a tool
  has run, it reflects the last processed image (persisted in
  `sessionStorage` as a 256×3 Uint8Array).
- **Status bar** (§7).

## 4. Layout — tool page (2-zone darkroom)

Grid: `1fr 360px`, full viewport height minus header+footer.

- **Left zone — canvas on `--paper`.** Image dominates: `object-fit:
  contain`, max 92% of zone, centred, drop-zone outline (1px dashed
  `--line`) when empty. Before/after slider where the tool supports it
  (compress, upscale, remove-bg, blur-face, photo-editor) — vertical
  hairline scrub head in `--phosphor`, draggable, mono readout
  `42% · 1.4MB → 312KB` floating top-left.
- **Below canvas — live RGB histogram strip** (§5), 100% wide × 96px,
  sits flush on `--ink` background between paper canvas and footer.
- **Right zone — controls rail on `--ink-2`.** 360px, `--line` left
  border, 24px padding. Controls are dense, labelled in JetBrains Mono
  12/500 uppercase tracking 0.04em. Sliders are 2px tracks, 12px square
  thumbs in `--phosphor`. Numeric inputs are mono, right-aligned, with
  the unit (`px`, `%`, `kB`, `°`) suffixed in `--paper`/40%. EXIF dump
  panel collapses at the bottom: `EXIF ▾` toggle reveals key-value
  table in mono 12px.
- **Action button** at rail bottom: full-width, 40px, `--phosphor` fill,
  `--ink` text, label like `[ export · png ]` — square brackets are
  literal, mono. Secondary action (`[ reset ]`) hairline-ghost.

## 5. Signature — live RGB histogram strip

Three channels stacked in one SVG. Each channel is a filled path
sampled at 256 buckets, alpha `0.5` so overlapping regions composite
naturally to white-ish where all three peak (correctly mimicking
real-world luminance). Stroke `0`. Background transparent.

```ts
// useImageHistogram(bitmap: ImageBitmap): { r: Uint32Array; g: Uint32Array; b: Uint32Array }
// - downsamples bitmap to ≤512²  via OffscreenCanvas
// - reads ImageData once, walks pixels, increments three 256-bucket arrays
// - debounced 33ms (≈30fps), runs in a Worker so the main thread stays free
// - returns memoised refs; consumers re-render the SVG paths on each tick
```

The strip on the home page consumes the same hook against
`sessionStorage.lastBitmap`; on tool pages it consumes the live working
bitmap after each transform. Same component, two contexts.

## 6. Header

Single line, 56px, no border, no shadow, padding `0 24px`.

- **Left:** wordmark `oriz · image-tools` — Space Grotesk 16/600,
  `--paper`. The `·` is a centred middle dot in `--phosphor`.
- **Right (home):** `⌘K` chip, mono 12px in `--line` outlined pill.
- **Right (tool page):** `[ ← all tools ]` breadcrumb, mono 12px, links
  home. The chip is gone — the brackets are the affordance.

## 7. Footer — filmstrip status line

One line, 32px, `--ink` background, mono 12px in `--paper` at 60%:

```
●●●  13 tools · 0 bytes uploaded ever · runs in your browser · MIT · GitHub · v0.4.1
```

The three leading `●` glyphs are not text — they are a 48×16 inline SVG
of the histogram component shrunk to three vertical bars in
`--rgb-r`/`--rgb-g`/`--rgb-b`, pulsing at the same 30fps tick. When the
strip above changes, the dots change. The link targets are underlined
on hover only, `--phosphor` underline.
