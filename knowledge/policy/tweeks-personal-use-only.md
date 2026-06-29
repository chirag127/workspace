---
type: decision
title: "Tweeks (NextByte) modification — personal mods OK, no public redistribution"
description: 'Tweeks: closed-source, personal use only, no redistribution'
tags: [decision, tweeks, closed-source, license, cws-tos, personal-use-only]
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
related:
  - policy/forked-extension-cws-rules
  - decisions/architecture/userscript-prototype-via-tweeks
  - decisions/ops/mirror-to-9-popular-alternatives-2026-06-28
  - rules/fork-discipline
---

# Tweeks modification policy

## Status

**Closed-source proprietary commercial extension.** No LICENSE file in the extracted bundle. No "Source available on GitHub" link in the manifest or popup. Author: NextByte (YC-backed, https://tweeks.io, contact whyiswhen@gmail.com).

## What IS allowed

- **Download the .crx via `scripts/download-cws-extension.mjs`** for personal study + reverse engineering on YOUR machine.
- **Modify the extracted bundle locally** at `C:/D/Tweeks-Customize-Any-Website-Chrome-Web-Store/` (or anywhere on YOUR disk) and load it as an unpacked extension in YOUR browser.
- **Store the modified bundle in a PRIVATE single-repo** under chirag127 or oriz-org IF that repo is NOT part of the umbrella's submodule tree (the umbrella mirrors to 6 public hosts every Friday, which would publish proprietary code). Set the repo to private + NOT a submodule + name it something like `chirag127/tweeks-personal-mods` (not a public-facing slug).
- **Use Tweeks unmodified** for prototyping userscript ideas (per [[decisions/apps/userscript-prototype-via-tweeks]]).
- **Replicate functionality from scratch** — observation of behavior is fine; the API surface and ideas are not protected.

## What is NOT allowed

- **Public redistribution in any form**: Chrome Web Store publish, public GitHub repo, Greasefork, Discord / DM / direct download links shared with anyone else, npm publish, file uploads to public hosting. Chrome Web Store ToS §2 + copyright law forbid this without NextByte's permission.
- **Storing in the umbrella workspace** (`c:/D/oriz/repos/**` or any submodule under it) — the mirror cron at `.github/workflows/mirror-all.yml` pushes the entire umbrella to 6 public mirror hosts (GitLab, Codeberg, Bitbucket, GitFlic, Azure DevOps, AWS CodeCommit) every Friday. Even though oriz-org/workspace itself is public, those mirrors create additional public copies — clearly redistribution.
- **Forking Tweeks "as a starting point" for a competing open-source product.** The boundary between "inspired by" (legal) and "derivative work" (copyright infringement) is contested; safest path is clean-room reimplementation if a competing product is the goal.

## The right path if you want a customizable Tweeks-like tool

Build a USERSCRIPT that does the specific thing you wanted Tweeks to do. Userscripts (Tampermonkey / Violentmonkey / ScriptCat) cover most of what Tweeks does, are 100% your code, and live in the `repos/oriz/own/prod/userscripts/` monorepo with full Greasefork distribution rights.

Per [[decisions/apps/userscript-prototype-via-tweeks]], you can still prototype using Tweeks' AI generator AS LONG AS you copy out the generated JS and reshape it into your own .user.js. The generated JS is yours — it was generated against your prompt against your DOM. The Tweeks extension itself is not.

## Where local mods can live

`C:/D/Tweeks-Customize-Any-Website-Chrome-Web-Store/` (outside the umbrella repo). Add to umbrella `.gitignore` if any future tooling might accidentally include `C:/D/Tweeks-*`. Currently it's outside `c:/D/oriz/` so it's not in scope of the workspace clone — fine as-is.

## When this rule unlocks

If NextByte open-sources Tweeks (announces on tweeks.io or github.com/nextbyte-* with an OSS license), this whole rule is superseded. Until then, treat modifications as private-machine-only.

## Cross-refs

- General forked-extension CWS policy: [[policy/forked-extension-cws-rules]]
- Userscript prototype flow (Tweeks ? portable .user.js): [[decisions/apps/userscript-prototype-via-tweeks]]
- Fork discipline (applies only to OSS forks): [[rules/fork-discipline]]
