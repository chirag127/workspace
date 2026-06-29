---
type: decision
title: "Backup keys in private oriz-org/backup repo"
description: Private oriz-org/backup repo for restic config + keys
tags: [backup, restic, secrets, ops]
timestamp: 2026-06-25
format_version: okf-v0.1
status: active
---

Private repo `oriz-org/backup` (not public) stores: restic repo config, recovery keys (git-crypt encrypted with a GPG key), and `RECOVERY.md` step-by-step restore runbook. Actual snapshot data is in Backblaze B2, not in the repo. Pairs with [`backup-restic-b2-plus-windows-builtin`](./backup-restic-b2-plus-windows-builtin.md). Locked 2026-06-25.
