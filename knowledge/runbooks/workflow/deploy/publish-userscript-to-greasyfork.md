---
type: runbook
title: "Publish a userscript to Greasy Fork (manual paste, then webhook auto-update)"
description: "Publish userscript to Greasy Fork; manual paste first version, webhook auto-update"
tags: [runbook, userscript, greasyfork, publishing, marketplace]
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/userscript-prototype-via-tweeks
  - rules/agent-minimum-context
---

# Publish a userscript to Greasy Fork

## Pre-flight check (before opening the browser)

The script's metadata block MUST satisfy Greasy Fork's [code-rules](https://greasyfork.org/en/help/code-rules):

- [ ] `@name` present + descriptive
- [ ] `@description` present + 1-line + truthful (no SEO stuffing)
- [ ] `@namespace` present + stable (e.g. your GitHub repo URL)
- [ ] `@version` present + valid semver
- [ ] At least one `@match` or `@include`
- [ ] `@license` present (Greasy Fork prefers MIT, GPL, BSD, Apache, CC0)
- [ ] Script size < 2 MB (minification not allowed; use `@require` for libraries instead)
- [ ] No "loader" pattern (script must NOT fetch its real payload from an external URL — that's banned outright)
- [ ] No undisclosed antifeatures (tracking, ads, miners); if any exist, declare via `@antifeature`
- [ ] `@match` patterns match sites the script ACTUALLY does something on (no SEO-stuffing)

## Step 1: First-time Greasy Fork account (do this ONCE per author)

1. Open https://greasyfork.org/
2. Click **Sign in** (top right) → choose **GitHub** OAuth (or email/password if you prefer)
3. Done. Your author page is at `https://greasyfork.org/en/users/<id>`.

## Step 2: Paste-publish the first version

1. Open https://greasyfork.org/en/script_versions/new (or click **Publish a script you've written** from your profile)
2. **Copy** the entire contents of `<script>.user.js` from the GitHub raw URL
3. **Paste** into Greasy Fork's Ace editor
4. Scroll down — Greasy Fork parses the metadata block + previews the listing
5. Verify:
   - The detected `@name`, `@description`, `@match` look correct
   - Greasy Fork's "rewrites" notice mentions that `@updateURL` and `@downloadURL` will be rewritten to point at update.greasyfork.org (this is expected — Greasy Fork-installed users always update from Greasy Fork)
6. Click **Post new script**
7. Your script's listing URL is now `https://greasyfork.org/en/scripts/<numeric-id>-<slug>`

## Step 3: Register the GitHub webhook (so future pushes auto-sync)

After the script is published once, Greasy Fork can pull future versions automatically on every GitHub push:

1. On the script's Greasy Fork listing → click **Admin** → **Sync from external source**
2. Pick **GitHub**, enter the raw URL of the `.user.js` file:
   `https://github.com/oriz-org/userscripts/raw/main/<name>/<name>.user.js`
3. Save. Greasy Fork now receives a webhook on every push to the GitHub repo's main branch + re-fetches the raw URL with a ~5-10 min cache delay.
4. Bump `@version` in the .user.js metadata block before every push (Greasy Fork rejects pushes that don't increment the version).

After step 3, the publishing flow becomes:
```bash
# Edit script + bump version
vim repos/oriz/own/prod/userscripts/<name>/<name>.user.js
# Commit + push
git -C repos/oriz/own/prod/userscripts add -A && git commit -m "..." && git push
# ~5-10 min later, Greasy Fork has the new version automatically
```

## Common rejection reasons (from /help/code-rules)

If Greasy Fork rejects your initial post:

1. **"Loader" script** — your script fetches its real payload from an external URL. Inline the code instead.
2. **Undisclosed antifeatures** — tracking/ads/miners must be declared with `@antifeature`.
3. **`@match` doesn't match what the script does** — e.g. `@match *://*/*` on a script that only modifies one site. Narrow the match.
4. **Unrelated keywords in `@name`/`@description`** — SEO-stuffing is banned.
5. **Repost of an existing script** — if your script is a thin tweak of a popular existing one, the author may flag it. Materially improve OR use the appeal flow.
6. **Update-check rate in script** — don't bake `@updateURL` polling intervals; let the userscript-manager decide.
7. **Cosmetic version bumps** — bumping `@version` without actual changes is flagged as ranking-gaming.

## How Greasy Fork "rewrites" the install URL

Per https://greasyfork.org/en/help/rewriting:
- `@updateURL` and `@downloadURL` in your metadata are **rewritten** by Greasy Fork to point at its own `update.greasyfork.org/scripts/<id>/...` URL.
- `@installURL` (if any) is **removed**.
- Net effect: users who install from Greasy Fork always update from Greasy Fork, not your GitHub. Users who install directly from your GitHub raw URL still update from there.
- Keep the GitHub `@updateURL` in your source — it's used by the GitHub-raw-install path.

## What CANNOT be automated

- Initial paste of the first version (Greasy Fork has NO upload API)
- Adding the webhook (must be done in their UI)
- Responding to Greasy Fork moderator messages if your script gets flagged

## Greasy Fork's API (the read-only one)

Once your script is published, its data is queryable:
```
GET https://greasyfork.org/scripts/<id>.json
```
Returns the listing's metadata. Useful for checking install counts + ratings programmatically.

## Cross-marketplace

After Greasy Fork is validated, cross-publish to **OpenUserJS** (https://openuserjs.org):
- OpenUserJS has explicit **"Import from GitHub"** built into the publish flow — paste a GitHub repo URL, it picks up the .user.js automatically.
- Audience reach: < 10% of Greasy Fork, but FOSS-leaning + has GitHub integration that Greasy Fork doesn't.
- Greasy Fork-only is fine for most scripts; OpenUserJS is the second-best target.

Skip: Sleazyfork (NSFW-only), ScriptCat (CJK market — only relevant if your script targets CJK sites).

## Cross-refs

- The Tweeks-to-userscript prototype workflow: [[decisions/architecture/userscript-prototype-via-tweeks]]
- Userscripts monorepo location: `repos/oriz/own/prod/userscripts/`
