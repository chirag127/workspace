---
type: index
title: "Extension store services"
description: "Five distribution channels for the family's browser and editor extensions. Browser extensions trio: Chrome / Firefox / Edge. VS Code dual: VS Code Marketplace + Open VSX. JetBrains walked back."
tags: [services, extension-store, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Extension store services

The family ships **two flavours** of extensions. Browser extensions
publish to **three stores** (Chrome, Firefox, Edge); VS Code
extensions publish to **two marketplaces** (VS Code Marketplace +
Open VSX). JetBrains was considered as a third VS Code-style target
and explicitly walked back — the family does not ship JetBrains
plugins. All five stores in this bucket are free or one-time-fee, no
card-on-file. Single consolidated decision:
[`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md).

## Browser-extension stores (`oriz-*-ext`)

| Service | Status | Role | Cost |
|---|---|---|---|
| [chrome-web-store.md](./chrome-web-store.md) | active | ext-store-chrome | $5 one-time dev fee (sunk) |
| [firefox-add-ons.md](./firefox-add-ons.md) | active | ext-store-firefox | Free, no card |
| [edge-add-ons.md](./edge-add-ons.md) | active | ext-store-edge | Free, no card |

CI flow per repo: build once → submit in parallel to all three.
Tools: [`web-ext`](https://github.com/mozilla/web-ext) for the
cross-browser package + AMO sign,
[`chrome-webstore-upload`](https://github.com/fregante/chrome-webstore-upload-keys)
for Chrome,
[`wdzeng/edge-addon`](https://github.com/wdzeng/edge-addon) GitHub
Action for Edge.

## VS Code extension marketplaces (`oriz-*-vsc-ext`)

| Service | Status | Role | Cost |
|---|---|---|---|
| [vs-code-marketplace.md](./vs-code-marketplace.md) | active | ext-store-vscode | Free, no card |
| [open-vsx-registry.md](./open-vsx-registry.md) | active | ext-store-openvsx | Free OSS, no card |

CI flow per repo: build `.vsix` → publish to VS Code Marketplace
via [`@vscode/vsce`](https://github.com/microsoft/vscode-vsce) +
publish to Open VSX via
[`@vscode/ovsx`](https://github.com/EclipseFdn/openvsx) (same
artifact). One build, two pushes — never three.

## Walked back

| Store | Reason walked back |
|---|---|
| JetBrains Marketplace | Family ships VS Code extensions only. No JetBrains-IDE plugin in plan; adding the publish step pre-emptively would be over-coverage. Re-open if a JetBrains plugin is ever greenlit — see [`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md) "walked back" section. |

## The publish matrix

```
Browser extension repo (oriz-*-ext)
  ├── build → dist/extension.zip       (web-ext)
  ├── publish → Chrome Web Store       (chrome-webstore-upload)
  ├── publish → Firefox AMO            (web-ext sign)
  └── publish → Microsoft Edge Add-ons (edge-addon action)

VS Code extension repo (oriz-*-vsc-ext)
  ├── build → dist/extension.vsix      (vsce package)
  ├── publish → VS Code Marketplace    (vsce publish)
  └── publish → Open VSX Registry      (ovsx publish)
```

Both flows use the same family pattern from
[`decisions/process/per-repo-ci-workflows.md`](../../decisions/process/per-repo-ci-workflows.md).
Credentials originate at [Doppler](../secrets/doppler.md) and
mirror to [GitHub Secrets](../secrets/github-secrets.md).

## Cross-refs

- [Distribution + queues locked decision](../../decisions/architecture/distribution-and-queues-locked.md)
- [Earlier (Batch 1) cross-store browser-extension decision](../../decisions/infrastructure/extensions-cross-store-publish.md)
- [Repo naming suffixes (`-ext` / `-vsc-ext`)](../../decisions/branding/repo-naming-suffixes.md)
- [Chrome extensions as submodules](../../decisions/infrastructure/chrome-extensions-as-submodules.md)
- [Per-extension privacy policy](../../decisions/content/per-extension-privacy-policy.md)
- [Per-repo CI workflows](../../decisions/process/per-repo-ci-workflows.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
