---
type: service
title: "GitHub Releases"
description: "Versioned-binary storage — unlimited releases, 2 GB/asset, free"
tags: [storage, github, releases, binary, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: storage-binary
provider: github
free_tier: "Unlimited releases per public repo, 2 GB per asset, no card"
swap_cost: low
related:
  - services/data/storage/backblaze-b2
  - decisions/architecture/object-storage-split
  - infrastructure/extensions-cross-store-publish
---

# GitHub Releases

## Role

Versioned binary storage for the family. Used to publish:

- Browser extension bundles (`.crx`, `.xpi`, `.zip`)
- VS Code extension VSIX (`.vsix`)
- CLI binaries (one per OS × arch)
- Any other artifact whose identity is `(repo, tag, asset-name)`

Pairs with [Backblaze B2](./backblaze-b2.md) — Releases for
versioned binaries, B2 for everything else. Documented in
[`decisions/architecture/object-storage-split.md`](../../decisions/architecture/object-storage-split.md).

## Free tier

- Unlimited releases per public repo
- 2 GB per asset
- No transfer charge for downloads
- Versioned by git tag — every asset is immutable per `(tag, name)`
- Server-side checksums via `gh api` / Releases API

## Card / subscription required?

**NO.** GitHub Free covers public repos with unlimited Releases.

## Alternatives

- [Backblaze B2](./backblaze-b2.md) — sibling, used for unversioned blobs
- npm tarballs (used for `@chirag127/*` packages — not for binaries)
- direct repo commits (rejected — bloats clone size)

## Swap cost

Low — `gh release upload` is one shell line; download is `gh release
download` or a stable URL. Replacing means choosing another binary
host (Cloudflare R2 was rejected on card grounds; B2 is the
fallback).

## Why this is our pick

Git tag = release version. The asset URL is stable, immutable, and
cacheable; the GitHub CDN handles delivery; the family already lives
on GitHub. Build pipelines can upload via `softprops/action-gh-release`
inside the per-repo CI from
[`decisions/process/code-quality-stack.md`](../../decisions/process/code-quality-stack.md).

## Cross-refs

- [Object storage split decision](../../decisions/architecture/object-storage-split.md)
- [Backblaze B2](./backblaze-b2.md) — sibling, unversioned blobs
- [Extensions cross-store publish](../../infrastructure/extensions-cross-store-publish.md)
