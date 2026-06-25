---
type: design-brief
title: "oriz-books v2 design brief"
description: "NCERT textbook directory rendered as a library catalogue drawer: ink-block desk, bone catalogue cards, cinnabar accent, IBM Plex Serif + Sans Devanagari."
tags: [design, oriz-books, v2]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - design/_family-rules
  - decisions/process/v2-design-implementation
---

# oriz-books — design spec v2

NCERT textbook directory for Indian K-12. The metaphor is a library catalogue drawer on a wooden desk: each book is a 5x3 catalogue card, punched, color-banded, and code-stamped. No hero, no carousel, no lift — students arrive knowing what they want and search by class + subject.

## Surface + tokens (6 hex max)

- **Ink Block** `#0E1014` — primary surface (the desk)
- **Card Bone** `#F4EDE0` — catalogue card face (warm, slightly aged)
- **Cinnabar** `#E5482A` — primary accent, used for active filter chips, current-page underline, and the Maths subject band
- **Brass** `#A89968` — punch-hole, Social Studies band, hairline dividers on dark
- **Indigo Stamp** `#2E3A8C` — Sciences band, link color on card face
- **Graphite** `#3A3A3A` — body text on Card Bone; Languages band

Contrast pairs: Card Bone on Ink Block (15.8:1), Graphite on Card Bone (10.4:1), Cinnabar on Ink Block (5.1:1 — large-text only on the desk; AA on cards).

## Type

- **Display:** IBM Plex Serif. Used for book titles on cards (18px), book detail H1 (32px), and page H1 ("Class 8 — Science"). Weight 500. No italic for titles.
- **Body Latin + Devanagari:** IBM Plex Sans / IBM Plex Sans Devanagari. 16px/1.55 on detail pages, 14px/1.45 on cards. Hindi titles render in Plex Sans Devanagari at the same optical size — no font swap mid-line. The same family handles Tamil/Bengali/Marathi via system fallback (Noto Sans + script tag).
- **Utility mono:** JetBrains Mono. Used for the bookCode top-strip (`khvk108.pdf` → `KHVK 108`), class/medium tags, and the last-scrape timestamp. **`font-feature-settings: "ss20"` ON** (slashed zero) so `0` is never confused with `O` in codes like `kemh101` vs `kemho1`. Tabular figures on for the catalogue grid.

## Layout — home / class index

Wooden desk surface (Ink Block, no texture image — flat). Two-column shell:

- **Left rail (240px, sticky):** filter rail. Class (1-12, vertical list), Medium (English / Hindi / Urdu, segmented), Subject (Maths / Science / Social / Language, with the band color as a 3px swatch left of each label). Active filter = cinnabar text + 1px cinnabar underline. No accordion — all filters visible.
- **Main grid:** catalogue cards. CSS grid, `repeat(auto-fill, minmax(280px, 1fr))`, gap 24px. Each card is 280x168 (the 5x3 ratio). Cards do not lift, scale, or glow on hover — hover only darkens the brass punch-hole 60% → 80% opacity and underlines the title. Click anywhere on the card navigates; the punch-hole is the visual affordance, not the only hit target.

No featured row, no "trending this week," no carousel. Sort is alphabetical within (Class, Subject). Pagination is a numbered strip at the bottom — current page in cinnabar, others in Card Bone.

## Layout — book detail

Three-column at ≥1024px, single-column below:

- **Left (220px):** cover image (NCERT cover scan, 4:5 aspect, 1px brass border, no shadow). Below: download button — `[ Download PDF · 18.4 MB ]` rendered in JetBrains Mono inside square brackets, cinnabar text on Card Bone, no fill.
- **Middle (flex):** H1 title in Plex Serif, Hindi subtitle below in Plex Sans Devanagari at 0.7× size, then a **leader-dotted chapter list** — chapter title left, page number right, dots between (`Chapter 3 — Atoms .................. 47`). Each row is a link. Leader dots are real CSS (`::after { content: " . . . . . "; letter-spacing: 2px; }`) that fill the gap, not a graphic. This is now a **layout pattern**, not the site signature.
- **Right (200px, sticky):** spec sidebar. Definition list — Class, Subject, Medium, Publisher (NCERT), Edition year, Pages, ISBN, Last scraped (mono timestamp). Brass hairline above and below.

**Print stylesheet:** `@media print` hides the rail, header, footer, and download button. Cover + spec sidebar + chapter list remain. Chapter list page numbers stay aligned via the leader dots. Print one A4 page per book where possible.

## Signature — catalogue card with brass punch-hole

The card itself is the mark. Spec, top to bottom:

- **Top strip (28px tall):** JetBrains Mono, 11px, uppercase, letter-spaced 0.08em. Shows the bookCode (`KEMH 1 01`). Background = Card Bone, bottom border = 1px Graphite at 20%.
- **Subject color band:** 6px wide vertical strip on the LEFT edge, full card height. Maths = Cinnabar `#E5482A`, Science = Indigo Stamp `#2E3A8C`, Social = Brass `#A89968`, Language = Graphite `#3A3A3A`. Solid fill, no gradient.
- **Title block:** Plex Serif 18px / 1.3, max 3 lines, Graphite. Padding 16px left (after band) / 14px right / 12px top.
- **Brass punch-hole (the click affordance):** SVG `<circle>` centered horizontally, 8px above the card's bottom edge. Diameter **18px**. Fill `#A89968` at 60% opacity. Inner shadow: `<circle r="8" fill="#0E1014" opacity="0.35">` nested to suggest a real punched hole through the card to the desk below. On `:hover` the outer ring goes to 80% opacity — no scale, no transition longer than 120ms.
- **Card body:** Card Bone fill, 1px Graphite-at-15% border, 0 border-radius (catalogue cards have square corners), no shadow.

The punch-hole + color band combination is the site's primary signature — it appears on every grid card and is echoed at small size as the favicon (a single punched card).

## Header

Newsprint strip on Ink Block. 56px tall. Left: `oriz-books` wordmark in Plex Serif 18px, Card Bone, with a 6px cinnabar band to its left mirroring the Maths card band. Center: persistent search input (480px max), Card Bone fill, Graphite text, 1px brass border. Placeholder cycles every 4 seconds between English and Hindi prompts: `Search by class, subject, or chapter…` → `कक्षा, विषय या अध्याय खोजें…` → `Find Class 10 Science…` → `कक्षा 8 गणित…`. Cycle pauses on focus. Right: `Class ▾` and `Subject ▾` quick-jump menus in mono, no icons.

## Footer

Ink Block, 80px tall, Card Bone text. Three rows:

1. Colophon paragraph (one line, Plex Sans 13px): "oriz-books mirrors NCERT's public textbook PDFs. We don't host editorial content — only structure and search. NCERT owns the books."
2. Last-scrape timestamp in JetBrains Mono with slashed zero: `Last sync · 2026-06-18 03:14 IST · 1,847 books indexed`.
3. Family links: `oriz-home · oriz-blog · oriz-book-lore · oriz-pdf-tools` — Card Bone at 60%, hover to 100%, no underline until hover.

No social icons, no newsletter signup, no emoji.
