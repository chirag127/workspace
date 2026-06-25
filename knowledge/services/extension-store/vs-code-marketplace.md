---
type: service
title: "Visual Studio Code Marketplace"
description: "Microsoft's official VS Code extension marketplace. Free unlimited, no developer fee. Publish via vsce."
tags: [services, extension-store, vscode, microsoft, distribution, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: ext-store-vscode
provider: microsoft
free_tier: "Free unlimited extensions, unlimited published versions, no developer fee, no card; vsce CLI publishes via Azure DevOps PAT"
swap_cost: low
related:
  - services/extension-store/open-vsx-registry
  - services/extension-store/index
  - decisions/architecture/distribution-and-queues-locked
  - decisions/branding/repo-naming-suffixes
  - rules/no-card-on-file
---

# Visual Studio Code Marketplace

## Role

Primary distribution channel for every `oriz-*-vsc-ext` repo. The
official Microsoft-run marketplace at
`marketplace.visualstudio.com` — what `code --install-extension` and
the in-editor extension panel resolve against on a vanilla VS Code
install.

VS Code extensions in the family **dual-publish** here and to
[Open VSX](./open-vsx-registry.md) per
[`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md).
JetBrains Marketplace was considered as a third target and explicitly
walked back — the family does not ship JetBrains plugins.

## Free tier

- Unlimited extensions per publisher.
- Unlimited versions per extension.
- No developer fee, no review fee, no per-install fee.

## Card / subscription required?

**NO.** Publishing to the marketplace requires an Azure DevOps PAT
(Personal Access Token). Creating an Azure DevOps organization for
PAT-only use is free and requires no card. The Microsoft account
that owns the PAT is the same account used elsewhere in the family
(GitHub login, Edge Add-ons partner center).

## CI auto-publish

```yaml
- name: Publish to VS Code Marketplace
  run: |
    pnpm exec vsce publish --pat "$VSCE_PAT" \
      --packagePath dist/extension.vsix
  env:
    VSCE_PAT: ${{ secrets.VSCE_PAT }}
```

`vsce` (`@vscode/vsce`) is the official Microsoft CLI; it accepts
the same `.vsix` artifact that's pushed to Open VSX in the next
step, so packaging happens once. Credentials in
[Doppler](../secrets/doppler.md) →
[GitHub Secrets](../secrets/github-secrets.md).

## Alternatives

- [Open VSX Registry](./open-vsx-registry.md) — sibling, OSS-friendly
  fork. Required for VSCodium / Cursor / Theia / Gitpod /
  code-server users.
- JetBrains Marketplace — different IDE family entirely. Walked back
  as a future publish target; family has no plans to ship JetBrains
  plugins. See [`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md)
  "walked-back" section.

## Swap cost

Low — `vsce publish` is one CI step. Dropping it would lose the
Microsoft-VS-Code user base; not realistic, but mechanically cheap.

## Why this is our pick

The default user installs VS Code from `code.visualstudio.com` and
gets Microsoft's marketplace pre-wired. Skipping it is unthinkable
for any VS Code extension. Free + no card means the only ongoing
cost is the CI step.

## Cross-refs

- [Distribution + queues locked decision](../../decisions/architecture/distribution-and-queues-locked.md)
- [Open VSX Registry](./open-vsx-registry.md)
- [Repo naming suffixes (`-vsc-ext`)](../../decisions/branding/repo-naming-suffixes.md)
- [Extension-store bucket index](./index.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
