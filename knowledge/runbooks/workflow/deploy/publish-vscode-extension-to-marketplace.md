---
type: runbook
title: "Publish a VS Code extension to the Marketplace (vsce publish)"
description: "Ship VS Code extension to Marketplace + Open VSX via vsce + ovsx"
tags: [runbook, vscode, marketplace, publishing, vsce, open-vsx]
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
related:
  - branding/repo-naming-suffixes
  - rules/agent-minimum-context
---

# Publish a VS Code extension to the Marketplace

## One-time setup (per Microsoft Publisher account)

1. **Create the Microsoft Publisher**
   - https://marketplace.visualstudio.com/manage → **Create publisher**
   - Publisher ID: `chirag127` (already taken? pick `chirag127` instead — it's the publisher you have most leverage to use long-term)
   - Display name: `Oriz` or your real name
   - This Publisher ID must match the `publisher` field in every extension's `package.json`

2. **Generate a Personal Access Token (PAT)** at https://dev.azure.com
   - Sign in with the SAME Microsoft account you used to create the publisher
   - Top-right → User settings (⚙) → **Personal access tokens** → **New Token**
   - Name: `vsce publish`
   - Organization: **All accessible organizations**
   - Scopes: **Custom defined** → scroll to **Marketplace** → check **Manage**
   - Expiration: 1 year (the max non-custom value). Set a calendar reminder to rotate.
   - **Copy the token immediately** — Azure DevOps will not show it again.
   - Store in Bitwarden CLI: `bw create item ... name="vsce-pat-marketplace"`

3. **Install vsce + ovsx globally** (or just use npx)
   ```bash
   npm i -g @vscode/vsce ovsx
   ```

4. **Login once** to vsce locally
   ```bash
   vsce login chirag127   # paste the PAT when prompted
   ```
   The PAT is cached at `~/.azure-devops/.token-store` — keep it private.

5. **Optional but recommended: Open VSX**
   - https://open-vsx.org is the open-source-friendly mirror used by VSCodium, Cursor, Theia.
   - Create an Eclipse Foundation account, generate an access token at https://open-vsx.org/user-settings/tokens
   - Store in Bitwarden as `ovsx-pat`.
   - `ovsx create-namespace chirag127 -t <token>` (one-time)

## Per-release workflow

In the extension's repo (e.g. `sops-lens-vsc-ext`):

```bash
# 1. Bump the version per semver. Patch for fixes, minor for features, major for breaking.
#    package.json: "version": "0.2.0"

# 2. Make sure the build is clean
npm install
npm run compile         # tsc -p ./
npm run lint            # biome check

# 3. Package the .vsix locally to verify
npx vsce package
# Produces sops-lens-0.2.0.vsix in the repo root

# 4. Smoke-test the .vsix on your machine
code --install-extension sops-lens-0.2.0.vsix
# Reload window in VS Code, verify your extension activates + works

# 5. Publish to the Microsoft Marketplace
npx vsce publish
# Reads version from package.json, packages + uploads. Picks up the cached PAT.

# 6. Mirror to Open VSX (if set up in step 5 of one-time setup)
npx ovsx publish sops-lens-0.2.0.vsix -p $(bw get item ovsx-pat | jq -r .notes)

# 7. Tag the release on GitHub
git tag v0.2.0
git push origin v0.2.0
gh release create v0.2.0 sops-lens-0.2.0.vsix --title "v0.2.0" --notes "See CHANGELOG.md"
```

## Required package.json fields (Marketplace will reject otherwise)

```jsonc
{
  "name": "sops-lens",                           // unique within the publisher
  "displayName": "SOPS Lens",                    // shown in Marketplace
  "publisher": "chirag127",                        // MUST match the Publisher ID
  "version": "0.2.0",                            // semver
  "description": "≤ 200 char single-line summary",
  "engines": { "vscode": "^1.85.0" },            // minimum VS Code version
  "categories": ["Other"],                       // pick from the official list
  "keywords": [...],                              // for search
  "icon": "icon.png",                            // 128x128 PNG, optional but encouraged
  "license": "MIT",
  "repository": { "type": "git", "url": "https://..." },
  "bugs": { "url": "https://.../issues" }
}
```

Common rejection reasons:
- **No README.md** — Marketplace shows it as the extension's main page.
- **Description too long** (> 200 chars) — they truncate awkwardly.
- **No `engines.vscode`** — required for compatibility filtering.
- **`activationEvents` includes `"*"`** — flagged as too broad; use specific events.
- **Trying to publish with a username that doesn't match the publisher** — vsce will refuse.

## Update an existing extension

Same workflow, just bump the version. The Marketplace auto-detects the version increment and replaces the listing within ~5 minutes.

To unpublish: `npx vsce unpublish <publisher>.<extension-name>`. Use with care — extensions installed by users stop receiving updates but don't auto-uninstall.

## Cross-marketplace strategy for the oriz family

| Target | Audience | Cost | When to skip |
|---|---|---|---|
| **VS Code Marketplace** (Microsoft) | 90 %+ of VS Code users | Free, ~5 min setup once | Never — always publish here |
| **Open VSX** (Eclipse Foundation) | VSCodium, Cursor, Theia users | Free, separate PAT | Only skip if you don't care about FOSS-distro reach |
| **Direct .vsix on GitHub Releases** | Power users, CI installs | Free, automatic via `gh release` | Always do this — fallback if Marketplace ever blocks you |

Recommendation for any new `-vsc-ext` repo: publish to all three. Setup cost is bounded to the one-time work above; per-release cost is `npx vsce publish && npx ovsx publish *.vsix` (2 extra commands).

## Cross-refs

- Family naming convention (where `-vsc-ext` comes from): [[branding/repo-naming-suffixes]]
- The userscript-publishing analogue: [[runbooks/publish-userscript-to-greasyfork]]
- Agent context for new tasks: [[rules/agent-minimum-context]]
