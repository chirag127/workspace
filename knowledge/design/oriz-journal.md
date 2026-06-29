---
type: design-brief
title: "oriz-journal v2 design brief"
description: 'Auth-gated PWA: dusk surface, animated wax seal, libsodium encryption'
tags: [design, oriz-journal, v2]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - design/_family-rules
  - decisions/process/v2-design-implementation
---

# oriz-journal — design spec v2

Auth-gated PWA for serious journalers. 30 routes, 22 React islands, TipTap + libsodium client-side encryption + recharts + calendar + goals. Audience: people who actually keep a journal — closes the door at 11pm, rereads March before decisions. The seal is the entire visual language; everything else gets out of the way.

## Surface + tokens

**Dusk (default, dark)** — `--ink-black: #0B0B10` (frame), `--dusk: #13131A` (page surface), `--page-cream: #F5EFE0` (entry surface), `--seal-red: #C25A3F` (accent, single use), `--graphite: #6B6B73` (chrome text), `--rule: #1E1E26` (1px hairlines).

**Dawn (light)** — `--bone: #F5EFE0` (frame, same cream as dusk's page), `--paper: #FBF7EC` (page surface), `--ink: #1A1A22` (entry surface text), `--seal-red: #C25A3F` (unchanged), `--graphite: #585862` (chrome text), `--rule: #E4DFD0`.

WCAG AA verified on body text against both surfaces. No third surface, no card backgrounds, no elevation.

## Type

- **GT Sectra** (Source Serif 4 fallback) — entry titles, the date heading at the top of every entry, the wordmark. Nowhere else.
- **iA Writer Quattro Variable** — body. 18px / 1.7 line-height desktop, 17px / 1.65 mobile. **66ch hard cap** on the entry column. Purpose-built for sustained drafting; this is the load-bearing choice.
- **Inter** — chrome only (header, nav, word count, fingerprint, dates in lists). `font-feature-settings: "tnum"` on every numeric run.

No italic display type. No tracking changes. Body uses default tracking.

## Layout — dashboard (`/`)

Single 720px column, centered, vertical letter — **never a card grid.**

```
[ today's prompt — GT Sectra 22px italic, graphite ]
[ Open today's entry — single button, seal-red text on dusk, no fill ]
[ 1px rule, --rule ]
[ Mar 14   The argument with M. didn't actually start at … ] ← Inter 14px date, Quattro 16px first sentence
[ Mar 13   I keep coming back to the same … ]
[ Mar 12   … ]
[ Mar 11   … ]
[ Mar 10   … ]
[ all entries → ]   ← Inter 13px graphite, end of column, then whitespace
```

Five entries, one line each, date + first sentence truncated at column. Click row → entry. No counts, no streak strip, no metrics card, no "memories from a year ago."

## Layout — editor (`/entry/:date`)

Full-bleed `--page-cream` page floating on `--dusk` frame. 720px column, 64px top/bottom padding. **No toolbar at rest.** TipTap formatting menu appears as a 6-option floating bar **on selection only**: bold, italic, h2, blockquote, bullet list, link. Header chrome (see below) collapses on first keystroke. Word count + lock-status text fade to 20% opacity after 8s of stillness; cursor movement restores them.

The seal (top-right of the page-cream surface, not the dusk frame) is the only persistent UI.

Sealed-margin: each saved entry's libsodium ciphertext fingerprint renders as a faint **8-character hex string in Inter 11px graphite** in the right margin opposite the date heading. Deliberately unreadable. Never collapsed to a settings page, never tooltipped, never explained in chrome — it just is.

## Layout — calendar (`/calendar/:year`)

Vertical year-strip: **12 month rows × 28-31 day cells**, full year fits one viewport on desktop (1440×900). Empty days = `--dusk` graphite squares; days with an entry = `--page-cream` fills. Streaks become visible as **shapes** — a run of cream against dusk — not as numbers. Hover a cream day: first sentence appears as a right-margin note in Inter 13px graphite. Click → entry. Mobile collapses to one month per viewport, same row geometry.

No heatmap gradient, no intensity, no "you wrote 412 words." Binary: wrote / didn't.

## Signature — THE SEAL

A 12px-diameter circle, top-right corner of every page, 16px from top and right edges. The PWA icon is this same circle.

```css
.seal {
  position: fixed; top: 16px; right: 16px;
  width: 12px; height: 12px; border-radius: 50%;
  transition: none; /* state changes are explicit, not eased */
}
.seal--typing  { background: transparent; box-shadow: inset 0 0 0 1px var(--seal-red); }
.seal--sealing { background: var(--seal-red); animation: seal-pulse 600ms ease-in-out; }
.seal--sealed  { background: var(--seal-red); }
.seal--closing { background: var(--seal-red); transform: rotate(90deg); transition: transform 300ms ease-out; }
@keyframes seal-pulse { 0%, 100% { opacity: 1 } 50% { opacity: 0.55 } }
```

Four states: hollow ring (unsaved local edits) → soft 600ms opacity pulse (libsodium operation) → solid fill (encrypted to disk) → quarter-turn rotate over 300ms (entry close, wax pressing shut / key turning).

**This is the only animated element in the entire app.** No route transitions, no scroll animations, no skeleton shimmers, no toast slides, no hover lifts. Nothing else moves.

The seal also sits on the dashboard (sealed = vault is current), the calendar header, and every export-confirmation screen.

## Header

**Chrome version (dashboard / calendar / settings)** — 56px tall, `--ink-black` on dusk. "oriz-journal" wordmark in GT Sectra 18px `--page-cream` lowercase, left. ⌘K search hidden behind shortcut. Hamburger nav-drawer right (slides over, no animation beyond display swap). Seal top-right.

**Editor version** — present at 100% opacity for 2s after route enter, then dissolves to 0% on first keystroke or after 8s of stillness, whichever lands first. Only the seal persists. Cursor-to-top-64px summons it back at 60% opacity.

## Footer

**No global app-shell footer.** Dashboard ends with `[ all entries → ]` and whitespace. Editor footer = word count + lock status, right-aligned, Inter 13px graphite, fades with the rest. Settings / about / export / legal pages carry one line:

`oriz-journal · open source · sealed with libsodium · v0.x.x` — Inter 12px graphite, centered, 64px from page bottom.

## Forbidden

1. **No streak gamification** — no flame, no "47-day streak", no "don't break the chain" nags, no medals. Streaks read as shapes on the calendar or not at all.
2. **No AI in the writing surface** — no summarize, no sentiment, no auto-tag, no Gemini sidebar. Plaintext never leaves the device; an AI feature would betray that.
3. **No skeuomorphism** — no paper texture, no leather, no book-cover bind, no page-curl. Cream is flat. Type does the work. The seal is the only ornament.
4. **No padlock icon as the privacy signal** — the seal IS the privacy signal.
5. **No emoji** anywhere in chrome or content shell.
6. **No persistent toolbar in the editor** — formatting only appears on selection.
