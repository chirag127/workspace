---
type: decision
title: "Tweeks (NextByte) modification — personal use only, never redistribute"
description: "Tweeks (chromewebstore.google.com/detail/fmkancpjcacjodknfjcpmgkccbhedkhc) is a closed-source proprietary commercial Chrome extension by NextByte (YC-backed, tweeks.io). It has NO open-source license. Any modification is permissible under fair-use for personal study + personal-machine use only. NEVER publish a modified Tweeks fork to GitHub (public or private), Chrome Web Store, or any other distribution channel — that would violate Chrome Web Store ToS §2 + NextByte's copyright. CRX extraction via scripts/download-cws-extension.mjs is for study/personal modification only."
tags: [decision, tweeks, closed-source, license, cws-tos, personal-use-only]
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
related:
  - decisions/policy/forked-extension-cws-rules
  - decisions/architecture/userscript-prototype-via-tweeks
  - rules/fork-discipline
---

# Tweeks modification policy

## Status

**Closed-source proprietary commercial extension.** No LICENSE file in the extracted bundle. No "Source available on GitHub" link in the manifest or popup. Author: NextByte (YC-backed, https://tweeks.io, contact whyiswhen@gmail.com).

## What IS allowed

- **Download the .crx via `scripts/download-cws-extension.mjs`** for personal study + reverse engineering on YOUR machine.
- **Modify the extracted bundle locally** at `C:/D/Tweeks-Customize-Any-Website-Chrome-Web-Store/` and load it as an unpacked extension in YOUR browser.
- **Use Tweeks unmodified** for prototyping userscript ideas (per [[decisions/architecture/userscript-prototype-via-tweeks]]).
- **Replicate functionality from scratch** — observation of behavior is fine; the API surface and ideas are not protected.

## What is NOT allowed

- **Pushing modified Tweeks to ANY GitHub repo** (public or private). Chrome Web Store ToS §2 + copyright law forbid redistribution without permission.
- **Publishing to Chrome Web Store** under any name (yours or anonymous). Account ban risk.
- **Sharing the modified extension via Discord / DM / direct download** with anyone else. Same redistribution problem.
- **Committing the extracted source to ANY repo** in the `oriz-org/*` or `chirag127/*` family (or anywhere on `c:/D/oriz/`). The repo would expose proprietary code to the public mirror cron and put oriz-org's reputation at risk.
- **Forking Tweeks "as a starting point" for a competing open-source product.** The boundary between "inspired by" (legal) and "derivative work" (copyright infringement) is contested; safest path is clean-room reimplementation if a competing product is the goal.

## The right path if you want a customizable Tweeks-like tool

Build a USERSCRIPT that does the specific thing you wanted Tweeks to do. Userscripts (Tampermonkey / Violentmonkey / ScriptCat) cover most of what Tweeks does, are 100% your code, and live in the `repos/oriz/own/prod/userscripts/` monorepo with full Greasefork distribution rights.

Per [[decisions/architecture/userscript-prototype-via-tweeks]], you can still prototype using Tweeks' AI generator AS LONG AS you copy out the generated JS and reshape it into your own .user.js. The generated JS is yours — it was generated against your prompt against your DOM. The Tweeks extension itself is not.

## Where local mods can live

`C:/D/Tweeks-Customize-Any-Website-Chrome-Web-Store/` (outside the umbrella repo). Add to umbrella `.gitignore` if any future tooling might accidentally include `C:/D/Tweeks-*`. Currently it's outside `c:/D/oriz/` so it's not in scope of the workspace clone — fine as-is.

## When this rule unlocks

If NextByte open-sources Tweeks (announces on tweeks.io or github.com/nextbyte-* with an OSS license), this whole rule is superseded. Until then, treat modifications as private-machine-only.

## Cross-refs

- General forked-extension CWS policy: [[decisions/policy/forked-extension-cws-rules]]
- Userscript prototype flow (Tweeks → portable .user.js): [[decisions/architecture/userscript-prototype-via-tweeks]]
- Fork discipline (applies only to OSS forks): [[rules/fork-discipline]]
