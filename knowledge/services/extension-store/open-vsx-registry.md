---
type: service
title: "Open VSX Registry"
description: "Eclipse Foundation's vendor-neutral VS Code extension registry. Used by VSCodium, Cursor, Theia, Gitpod, code-server. Free OSS, no card. Publish via ovsx."
tags: [services, extension-store, vscodium, cursor, theia, eclipse, distribution, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: ext-store-openvsx
provider: eclipse-foundation
free_tier: "Free, OSS (EPL-2.0), no developer fee, no card; publisher namespace requested via the eclipse/openvsx GitHub repo"
swap_cost: low
related:
  - services/extension-store/vs-code-marketplace
  - services/extension-store/index
  - decisions/architecture/distribution-and-queues-locked
  - decisions/branding/repo-naming-suffixes
  - rules/no-card-on-file
---

# Open VSX Registry

## Role

Mandatory second publish target for every `oriz-*-vsc-ext` repo.
Open VSX (`open-vsx.org`) is the Eclipse Foundation's
vendor-neutral, OSS extension registry — the only VS-Code-compatible
marketplace that VSCodium, Cursor, Theia, Gitpod, code-server, and
several other community editors are allowed to consume by default
(the official VS Code Marketplace's terms forbid third-party
clients).

Every VS Code extension dual-publishes to here and to the
[VS Code Marketplace](./vs-code-marketplace.md), per
[`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md).

## Free tier

- Free, fully OSS (EPL-2.0).
- Unlimited extensions, unlimited versions.
- No developer fee, no review fee, no per-install fee.
- Publisher namespace approval is a one-time PR to
  [`eclipse/openvsx`](https://github.com/eclipse/openvsx) listing
  the publisher's GitHub identity.

## Card / subscription required?

**NO.** Open VSX is a free Eclipse Foundation service; tokens are
issued via Eclipse Foundation account login (free, no card).

## CI auto-publish

```yaml
- name: Publish to Open VSX
  run: |
    pnpm exec ovsx publish dist/extension.vsix \
      --pat "$OVSX_PAT"
  env:
    OVSX_PAT: ${{ secrets.OVSX_PAT }}
```

`ovsx` (`@vscode/ovsx`) is API-compatible with `vsce`. The same
`.vsix` artifact submitted to the
[VS Code Marketplace](./vs-code-marketplace.md) is reused.
Credentials in [Doppler](../secrets/doppler.md) →
[GitHub Secrets](../secrets/github-secrets.md).

## Who reads from Open VSX

- **VSCodium** — community FOSS rebuild of VS Code, defaults to
  Open VSX.
- **Cursor** — AI-first VS Code fork, defaults to Open VSX (with
  partial fallthrough to Microsoft's marketplace).
- **Theia / Gitpod / code-server** — cloud + browser-based IDEs
  that legally cannot use Microsoft's marketplace.
- **Eclipse Che** — same constraint.

Skipping Open VSX means our extensions are invisible to every user
on those platforms.

## Alternatives

- [VS Code Marketplace](./vs-code-marketplace.md) — sibling,
  required.
- JetBrains Marketplace — different IDE family, walked back as a
  publish target. See
  [`decisions/architecture/distribution-and-queues-locked.md`](../../decisions/architecture/distribution-and-queues-locked.md).

## Swap cost

Low — `ovsx publish` is one CI step against a well-defined REST API.

## Why this is our pick

Reach. Open VSX is the *only* publish target that captures every
non-Microsoft VS Code descendant — and that user base is growing
fast (Cursor in particular). The cost of adding it is one CI step
and a one-time namespace PR.

## Cross-refs

- [Distribution + queues locked decision](../../decisions/architecture/distribution-and-queues-locked.md)
- [VS Code Marketplace](./vs-code-marketplace.md)
- [Repo naming suffixes (`-vsc-ext`)](../../decisions/branding/repo-naming-suffixes.md)
- [Extension-store bucket index](./index.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
