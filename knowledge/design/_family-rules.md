---
type: convention
title: "oriz family — locked design rules (v2)"
description: 'Cross-site design contract: surface, typeface, accent, constraints'
tags: [design, family, convention, v2]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - design/index
  - decisions/process/v2-design-implementation
---

# oriz family — locked design rules (v2)

Version: 2026-06-19. Applies to all 11 oriz-* sites.

## Surface distribution (forced)

- **Cream / paper:** oriz-blog, oriz-book-lore, oriz-pdf-tools, oriz-urls-to-md (4 sites)
- **Dark:** oriz-books, oriz-image-tools, oriz-journal, oriz-home (4 sites)
- **Other:** oriz-finance (graph-paper light), oriz-cards (slate grey), oriz-me (datasheet white)

A user surfing 2-3 sites in a row should see a different surface each time.

## Display typeface budget

- **Fraunces** — only on oriz-blog and oriz-finance (capped at 2)
- **GT Sectra / Source Serif 4** — pdf-tools, journal, book-lore, home (mixed)
- **Wide monospace (Geist Mono / Reddit Mono / JetBrains Mono display cut)** — oriz-cards
- **IBM Plex Serif** — oriz-books (pairs with existing Plex Sans Devanagari)
- **IBM Plex Sans Condensed** — oriz-me (deliberate cut-divergence from books' Plex Serif + Plex Sans)
- **Space Grotesk** — oriz-image-tools
- **Instrument Serif** — oriz-urls-to-md

## Primary accent distribution (forced)

- **oriz-blog** — cobalt `#1F4FD8`
- **oriz-books** — cinnabar `#E5482A` (red, justified by NCERT cover heritage)
- **oriz-book-lore** — pencil red `#B71C1C` (justified by marginalia)
- **oriz-cards** — carbon blue `#2B3A55` PRIMARY; vermilion only on negative numbers
- **oriz-finance** — graph teal `#0F766E`
- **oriz-home** — mustard yellow `#F0DC5A` PRIMARY; vermilion only on the lone "start anywhere ↓" arrow
- **oriz-image-tools** — phosphor `#C8FF3C`
- **oriz-journal** — seal red `#C25A3F` (justified by encryption metaphor)
- **oriz-me** — archival blue `#0B5394` (drafting-blueprint / IBM cyan / engineering-datasheet heritage)
- **oriz-pdf-tools** — ledger green `#2D4A3E` (vermilion only for redaction/destructive)
- **oriz-urls-to-md** — hot red `#E63946` (load-bearing — the # toggle)

Three sites with red as primary (book-lore, journal, urls-to-md) — each has a non-negotiable metaphoric reason. Others have non-red primaries.

## No-compromise briefs

- **oriz-urls-to-md** — ship the "site is a .md file" conceit whole. Literal `#` headings, `[ bracketed ]` buttons, `> blockquote` toasts, `# toggle` for raw↔rendered, about page shows source side-by-side.
- **oriz-journal** — ship "the seal" whole. Animated wax seal, ciphertext fingerprint marginalia, no streaks, no AI in editor.
- **oriz-home** — ship "monochrome until hover" whole. First paint = ink-on-bone only. Color appears on `:hover` and `:focus-visible` only. One vermilion `start anywhere ↓` arrow as the affordance hint.
- **oriz-me** — ship "the build manifest" whole. Provenance strip with live build timestamp + 4px pulsing sync dot is the only animation on the entire site. No images, no gradients, no glassmorphism.

## Universal constraints

- No ad slot divs anywhere. AdSense/Ezoic inject at runtime when monetization arrives.
- Currently free + open source.
- No emoji in chrome (logos, nav, headers, footers).
- Header + footer are NOT shared across sites — each site has its own. Only Button, Input, Modal, AuthModal, Firebase init are shared via @chirag127/oriz-ui.
- Every site supports light + dark variants of its own palette.
- WCAG AA contrast minimum on all body text against all surfaces.
