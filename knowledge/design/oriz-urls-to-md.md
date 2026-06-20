---
type: design-brief
title: "oriz-urls-to-md v2 design brief"
description: "URL → Markdown converter where the site IS a .md file: literal # headings, [bracketed] buttons, > blockquote toasts, # toggle for raw↔rendered, hot-red # glyph as the brand."
tags: [design, oriz-urls-to-md, v2]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - design/_family-rules
  - decisions/process/v2-design-implementation
---

# oriz-urls-to-md — design spec v2

Single-purpose tool: paste URLs, get clean Markdown. Audience: developers, AI engineers feeding context to LLMs, researchers, archivists. The conceit is total: **the site IS a `.md` file you can toggle between raw source and rendered prose.** Every chrome string carries visible Markdown syntax in raw mode. No purple gradients, no charcoal terminal, no emoji, no Lottie, no illustrations. The `#` glyph in the left margin is the brand.

## Surface + tokens

Manuscript cream — one of four cream sites in the family, distinguished by being the only one where chrome reads as monospace source code on paper. Cream paper, ink that scans as typewriter ribbon, hot red as the single accent.

```
--paper:    #F5F1E8   /* manuscript cream — same hex as blog/pdf-tools/book-lore, differentiated by type system */
--ink:      #1A1714   /* near-black warm, never #000 */
--ink-soft: #6B5F52   /* line numbers, captions, --- rule shadow */
--rule:     #D9CFBE   /* box-drawing borders, hairline dividers */
--mark:     #E63946   /* hot red — # glyph, [paste] focus, error fences, ONLY accent */
--link:     #1A1714   /* links are ink + 1px underline; --mark only on :hover */
```

Dark mode inverts to `--paper: #15110D` (warm coffee-stain black, NOT #0D1117 dev-tool slate), `--ink: #EDE6D6`, `--mark: #FF4D5A` (lifted 6% for AA on dark cream-inverse). The cream identity reads through both modes — never charcoal.

## Type

**Instrument Serif** — display only. H1 56px mobile / 96px desktop, italic strap at 28px. Used for `# paste urls. get markdown.` after the rendered-mode toggle resolves the `#`. Tracking -0.01em, line-height 1.05.

**JetBrains Mono — THE HERO FACE.** 15/24 default, weight 400, weight 700 for bold runs inside markdown blocks. **Ligatures OFF (`font-feature-settings: "calt" 0, "liga" 0, "zero" 1`)** — this is the load-bearing typography decision. We render `=>`, `--`, `!=`, `->` as raw two-glyph sequences because the entire site is a literal `.md` source view; ligated `⇒` would betray the conceit. Slashed zero on for filename/version strings. JetBrains Mono carries: every button, every nav link, every form input, every toast, every error, every footer line, every line number, every box-drawing border, the H1 in raw mode, file labels in pane chrome.

**Inter** — chrome strings only when prose breaks the source frame: rendered-mode H1 fallback after the `#` toggle resolves typography to Instrument Serif (not Inter — Inter only handles command palette result strings, modal dialog body, and meta tags). 14-15px, tracking -0.005em. Sparing.

## Layout — home

Two-pane manuscript. Max-width 1280px, 64px gutters, single `---` rule (literal three-em-dash glyph row in `--rule` color, JetBrains Mono 15px) separates header band from content.

Left pane (560px): `┌─ input.txt ─────────────────────┐` box-drawing top, `│` left+right borders, `└─` bottom. Inside: a textarea where pasted URLs appear with `--ink-soft` line numbers in a 32px left gutter (real line numbers of the pasted list, not CSS counters). Empty state shows ghost text `// paste one url per line`.

Right pane (560px): `┌─ output.md ─────────────────────┐` matching frame. Top-right of the frame holds the segmented toggle `[ raw | rendered ]` — clicking cross-fades the same character stream between mono-source (visible `#`, `**bold**`, `[link](url)`) and rendered prose (Instrument Serif headings, ink underlined links). 180ms opacity cross-fade, no slide.

Below both panes, centered: `[ convert → ]` primary button (literal brackets, JetBrains Mono 15px, 1px `--ink` border, 12px padding, fills `--mark` on hover with cream text). To its left: `[ paste ]` secondary (transparent, 1px `--rule` border).

## Signature — THE `#` TOGGLE

A single `#` glyph in `--mark` red sits in the left margin of every page, at 1.5× the line height of the line it's anchored to (so 36px when the H1 is 24px tall, 84px when the H1 is 56px). Position: `position: fixed; left: 24px; top: <line-1-y>;` on desktop; collapses into the header band on mobile.

Click behavior: toggles a `<html data-mode="raw|rendered">` attribute. CSS `[data-mode="raw"]` keeps every chrome string as literal Markdown source — H1 reads `# paste urls. get markdown.` set in JetBrains Mono 56px; buttons keep their `[ ]`; the strap reads `> a typewriter for the llm era. no ads, open source, runs in your tab.`. `[data-mode="rendered"]` resolves: H1 swaps to Instrument Serif italic and the literal `#` glyph hides via `::before` content swap; `[ convert → ]` keeps brackets (they're the brand) but `> blockquotes` typeset to italic indented prose; the footer fenced block resolves to a flat row.

Persists in `localStorage.setItem('oriz-md-mode', 'raw'|'rendered')`. Default on first visit: `raw`. The `#` glyph pulses once (180ms scale 1.0 → 1.15 → 1.0, `--mark` opacity 1.0 → 0.6 → 1.0) on first paint, and a one-line tooltip in JetBrains Mono 13px, `--ink-soft`, anchored 8px right of the glyph reads `click # to render` for 3 seconds, then fades.

The toggle ALSO governs:

- **404 page** is a single line: `> 404: file not found` in JetBrains Mono 24px, `--ink-soft`, vertical-centered. In rendered mode it resolves to the same string italicized, indented 32px, `--rule` left-border 3px (real `<blockquote>`).
- **Toasts** render as `> done. 3 files copied to clipboard.` — fixed bottom-right, 16px JetBrains Mono, `--ink` on `--paper` with 1px `--rule` border, 4-second auto-dismiss. In rendered mode the `>` becomes a left border bar.
- **Form errors** render under the input pane as a fenced block:
  ```
  ```error
  url_invalid: missing scheme (line 4)
  ```
  ```
  Real triple-backticks, `error` info-string in `--mark`, fence body in `--ink`, 1px `--mark` left border. Rendered mode resolves to a red-tinted callout but keeps the monospace body.
- **Loading** shows `> fetching [3/12]...` — the bracket count updates live as URLs resolve. JetBrains Mono 15px, `--ink-soft`.
- **About page** is a real `.md` file in the repo (`/about.md`), shown in split-pane: source on the left in JetBrains Mono with visible `#`/`**`/`[]()`, rendered prose on the right in Instrument Serif + Inter. The `#` toggle on this page collapses the split to whichever side wins. The split is 50/50, draggable divider, persists position in localStorage.

## Header

Single 56px band, 64px horizontal padding. Left: `# urls-to-md` — the `#` is `--mark` JetBrains Mono 14px, the rest is `--ink` JetBrains Mono 14px, 1px gap. The `#` here is NOT the toggle (that lives in the margin); this one just signals brand. Right side, three text-only links in JetBrains Mono 14px with literal brackets: `[ about ]` `[ source ]` `[ ⌘ ]` — the last opens a command palette (Cmd/Ctrl-K also opens it; palette uses Inter for result strings, JetBrains Mono for shortcuts). Hover state on each: bracket interiors fill `--mark`. No background, no shadow, just the band.

Mobile: collapses to `# urls-to-md` left, three stacked `=` characters right (literal `===` reading as a hamburger). Tap opens a full-screen sheet with the three links stacked, each on its own `[ link ]` line, separated by `---` rules.

## Footer

Full-width, top border 1px `--rule`, 32px vertical padding, 64px horizontal. The entire footer is a literal triple-backtick fenced block rendered as raw text in JetBrains Mono 13px, `--ink-soft`:

```
``` footer
oriz/urls-to-md · v0.4.2 · MIT · no ads · runs in your browser
[home] [about] [contact] [legal/privacy] [legal/terms] [github]
> built by oriz · part of the oriz tools family
```
```

The opening and closing fence rows are present and visible. The `[bracketed]` words are real links — hover fills brackets `--mark`. The `>` line is real `--ink-soft` italicized in rendered mode, plain mono in raw. The fence info-string `footer` sits in `--mark` on the opening fence. Single column on mobile, fence rows wrap, links wrap to a second line.
