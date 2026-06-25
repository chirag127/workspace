---
type: index
title: "Object storage services"
description: "Two-way split — GitHub Releases for versioned binaries, Backblaze B2 for unversioned blobs. Cloudflare R2 rejected."
tags: [services, storage, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Object storage services

The family runs a **two-way split** locked on 2026-06-20:

- **[GitHub Releases](./github-releases.md)** — versioned binaries.
  Anything whose identity is `(repo, tag, asset-name)`: extension
  bundles, VS Code VSIX, CLI binaries.
- **[Backblaze B2](./backblaze-b2.md)** — unversioned blobs.
  Backups, raw photo / video originals, asset archives.

[Cloudflare R2](./cloudflare-r2.md) was **rejected** because its
adjacent paid features pull in a card-on-file requirement on the
same account, in violation of
[`rules/no-card-on-file.md`](../../rules/interaction/no-card-on-file.md). The
split decision is documented in
[`decisions/architecture/object-storage-split.md`](../../decisions/architecture/object-storage-split.md).

| Service | Status | Role | Used for |
|---|---|---|---|
| [github-releases.md](./github-releases.md) | active | storage-binary | Extension binaries, VSIX, CLI bins |
| [backblaze-b2.md](./backblaze-b2.md) | active | storage-blob | Backups, raw originals, archives |
| [restic.md](./restic.md) | active | backup-tool | Encrypted, deduplicated weekly backups (target = B2) |
| [cloudflare-r2.md](./cloudflare-r2.md) | rejected | — | (adjacent card requirement) |

## Why split rather than one bucket

Versioned binaries already have an excellent home (Releases) — git
tags double as release identifiers, the URL is immutable, the CDN is
free. Unversioned blobs don't fit that model — B2 fills the gap.
Trying to put everything in one bucket either bloats Releases past
the 2 GB/asset cap or loses the version-as-URL property B2 doesn't
give you for free.

## Cross-refs

- [Object storage split decision](../../decisions/architecture/object-storage-split.md)
- [Backup decision — restic + B2 + GH Actions cron](../../decisions/architecture/backup-restic-to-b2.md)
- [Restic backup setup runbook](../../runbooks/security/restic-backup-setup.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [Extensions cross-store publish](../../decisions/infrastructure/extensions-cross-store-publish.md)
