---
type: decision
title: Disk image backups — Windows built-in Backup-and-Restore
description: Windows Backup-and-Restore replaces Macrium for disk images
tags:
- decision
- ops
- backup
- disk-image
- windows
- macrium
- restic
timestamp: 2026-06-25
format_version: okf-v0.1
status: active
related:
- decisions/ops/backup-restic-to-b2
- decisions/ops/backup-everywhere-weekly
- decisions/ops/alternative-free-backup-channels
---

# Disk image backups — Windows built-in

## Decision

Full-disk image backups switch from Macrium Reflect Free (discontinued January 2024) to the **Windows built-in Backup-and-Restore** tool — the legacy Windows 7 utility that still ships in Windows 11. File-level backups continue under the existing decision (Restic to Backblaze B2, weekly schedule).

## Why

- **Macrium Reflect Free is gone** — the free SKU was retired in Jan 2024; only paid Home / Workstation editions remain. Free-tier-only posture forbids the paid SKU.
- **Windows built-in is free, signed, and shipped with the OS** — no third-party install, no Defender ASR concerns.
- **Same use case** — bootable image of the OS drive for bare-metal restore. Good enough for the one-laptop dev environment.
- **Restic stays for files** — incremental, deduplicated, encrypted, cross-platform; the right tool for daily working data.
- **No subscription cost added** — both rails fit no-card-on-file rule.
- **One alternative considered (Veeam Agent Free)** but the Windows built-in tool is simpler to schedule and doesn't need a separate vendor account.

## Implications

- Update the weekly backup runbook to invoke Windows Backup-and-Restore (`sdclt.exe` or Control Panel ? Backup and Restore) instead of Macrium Reflect.
- The image target stays an external drive; B2 remains the file-level remote.
- Restore drill cadence (quarterly) continues; the drill now exercises the Windows recovery environment instead of Macrium's Rescue Media.
- Per-file daily backup script (Restic to B2) is unchanged.
- If Windows ever drops the legacy Backup-and-Restore tool, the fallback list (`alternative-free-backup-channels.md`) covers next options.
