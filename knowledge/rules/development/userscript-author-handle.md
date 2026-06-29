---
type: rule
title: "Userscript @author metadata uses GitHub handle `chirag127`"
description: "Userscript @author = chirag127"
tags: [rule, userscript, metadata, attribution]
timestamp: 2026-06-25
format_version: okf-v0.1
status: active
related:
  - rules/development/git-identity-chirag127-noreply
  - rules/development/repo-naming
---

# Userscript @author = `chirag127`

## Rule

Every userscript in the family uses this metadata block author line:

```
// @author       chirag127
```

Not `Chirag Singhal`. Not `Chirag`. Not `Oriz`. The GitHub handle, lowercase.

## Why

- **Matches `@namespace`** — `https://github.com/oriz-org/userscripts` already identifies the family; the `@author` is the individual handle that maps to a discoverable GitHub profile.
- **Consistent with the noreply git identity rule** ([[rules/development/git-identity-chirag127-noreply]]) — commits use `76880977+chirag127@users.noreply.github.com`, so the public-facing identifier across git + userscript metadata is the same string `chirag127`.
- **Greasyfork / OpenUserJS searchability** — users searching authors on those listings find one consistent profile.

## Other userscript metadata standards (family conventions)

```
// ==UserScript==
// @name         <descriptive name>
// @namespace    https://github.com/oriz-org/userscripts
// @version      <semver>
// @description  <one-line, ≤200 chars>
// @author       chirag127
// @match        <as narrow as feasible>
// @run-at       document-end (default) | document-start | document-idle
// @grant        <list each used GM_* explicitly; never use @grant none unless truly grant-free>
// @license      MIT
// @homepageURL  https://github.com/oriz-org/userscripts/tree/main/<slug>
// @supportURL   https://github.com/oriz-org/userscripts/issues
// @updateURL    https://github.com/oriz-org/userscripts/raw/main/<slug>/<slug>.user.js
// @downloadURL  https://github.com/oriz-org/userscripts/raw/main/<slug>/<slug>.user.js
// ==/UserScript==
```

`@updateURL` + `@downloadURL` are non-negotiable — without them Tampermonkey/Violentmonkey skip the auto-update cycle and every user gets stuck on whatever version they first installed.

## Enforcement

Any new userscript: copy the metadata block above. Any existing userscript: when editing for any reason, normalize the `@author` line in the same commit. No standalone "fix author" commits — piggyback.

## Cross-refs

- Git identity rule (same name everywhere) → [[rules/development/git-identity-chirag127-noreply]]
- Userscripts monorepo README index → `repos/oriz/own/prod/userscripts/README.md`
- Greasyfork publishing runbook → [[runbooks/publish-userscript-to-greasyfork]]
