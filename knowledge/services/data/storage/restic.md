---
type: service
title: "restic"
description: "Encrypted, deduplicating backup CLI — weekly GH Actions cron to B2"
tags: [storage, backup, restic, oss, encryption, deduplication, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: backup-tool
provider: self-hosted
free_tier: "OSS (BSD-2-Clause). Zero licence cost. Backup target storage costs are whatever the destination charges — Backblaze B2 free 10 GB / 3x egress in our case."
swap_cost: low
related:
  - services/data/storage/backblaze-b2
  - services/business/cron/github-actions-schedule
  - decisions/architecture/backup-restic-to-b2
  - runbooks/restic-backup-setup
  - rules/no-card-on-file
---

# restic

## Role

The family's **backup engine**. A single static-binary CLI
(`restic`) snapshots local trees / repo dumps / Firestore exports
into a content-addressed, encrypted, deduplicated repository. Pairs
with [Backblaze B2](./backblaze-b2.md) as the storage backend per
[`decisions/architecture/backup-restic-to-b2.md`](../../decisions/architecture/backup-restic-to-b2.md).

Run from a [GitHub Actions schedule](../cron/github-actions-schedule.md)
weekly cron — see
[`runbooks/security/restic-backup-setup.md`](../../runbooks/security/restic-backup-setup.md)
for the full setup.

## Free tier

- **OSS (BSD-2-Clause).** No licence fee, no signup, no per-host charge.
- Cost is the storage backend only. Targeting
  [Backblaze B2](./backblaze-b2.md) keeps it inside the family's
  no-card free tier (10 GB stored + 3x egress free).
- Encryption (AES-256) + integrity (Poly1305-AES) + dedup (CDC chunker)
  are all on by default — no paid tier toggle.

## Card / subscription required?

**NO.** Pure OSS CLI. The only credentials it touches are the B2
app-key + the `RESTIC_PASSWORD` (the repo-encryption key), both
sourced from [Doppler](../secrets/doppler.md) at runtime.

## How CI / cron consumes it

```yaml
# .github/workflows/backup-weekly.yml (sketch — full version in runbook)
name: weekly-backup
on:
  schedule:
    - cron: '0 3 * * 0'   # Sundays 03:00 UTC
jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: |
          curl -L https://github.com/restic/restic/releases/latest/download/restic_linux_amd64.bz2 \
            | bunzip2 > restic && chmod +x restic
      - run: ./restic backup ./data
        env:
          RESTIC_REPOSITORY: s3:s3.us-west-002.backblazeb2.com/${{ secrets.B2_BUCKET_NAME }}
          RESTIC_PASSWORD: ${{ secrets.RESTIC_PASSWORD }}
          AWS_ACCESS_KEY_ID: ${{ secrets.B2_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.B2_APPLICATION_KEY }}
      - run: ./restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --prune
```

Secrets resolve from Doppler → GitHub Secrets per
[`security/secrets-management-doppler.md`](../../security/secrets-management-doppler.md).

## Alternatives

- **rclone** — sync, not snapshot; no dedup, no point-in-time restore.
- **borg** — strong feature parity, but no native S3 backend; needs
  rclone-mount or a borgbase account.
- **Duplicacy** — non-OSS for commercial use; rejected.
- **Bare `tar | gpg | aws s3 cp`** — no dedup, no incremental, no
  integrity checks. Acceptable for one-shot exports, not weekly.

## Swap cost

Low. The repository format is documented; if the family ever moves
off restic, `restic dump` extracts every snapshot to plain files.
Swapping the **backend** (B2 → R2 → some other S3) is a one-line
`RESTIC_REPOSITORY` change.

## Why this is our pick

- **OSS, single static binary** — drops into a GitHub Actions runner
  with one curl, no per-runner licence.
- **Encrypted by default** — repo password is the only key; B2 sees
  ciphertext, satisfies the
  [no-hardcoded-secrets posture](../../rules/security/no-hardcoded-secrets.md).
- **Content-addressed dedup** — week-over-week diffs cost only the
  changed chunks; 10 GB B2 free tier covers many weeks of family-scale
  backups before any pruning kicks in.
- **S3-compatible backend** — uses B2's S3 surface, no per-provider
  plugin to maintain.

## Cross-refs

- [Backup decision — restic + B2 + GH Actions cron](../../decisions/architecture/backup-restic-to-b2.md)
- [Backblaze B2 — backup target](./backblaze-b2.md)
- [GitHub Actions schedule — runs the cron](../cron/github-actions-schedule.md)
- [Restic backup setup runbook](../../runbooks/security/restic-backup-setup.md)
- [Doppler — secrets source-of-truth](../secrets/doppler.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
