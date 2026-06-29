---
type: log
title: "Oriz Knowledge Change Log"
description: "Chronological record of all knowledge file changes."
tags: [okf, meta, changelog]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
---

# Knowledge Change Log

| Date | File | Change |
|------|------|--------|
| 2026-06-29 | `log.md` | Created — OKF-spec change log |
| 2026-06-29 | `decisions/architecture/*.md` | Bulk-deleted 123 duplicate root copies keeping subdir versions |
| 2026-06-29 | `decisions/architecture/general/auth-billing-polish-locks-2026-06-22-evening.md` | Moved from root to `general/` |
| 2026-06-29 | `decisions/architecture/packages/four-more-packages-22-total.md` | Moved from root to `packages/` |
| 2026-06-29 | `decisions/architecture/ops/mirror-to-4-git-hosts.md` | Moved from root to `ops/` |
| 2026-06-29 | `decisions/architecture/ops/multi-target-build.md` | Moved from root to `ops/` |
| 2026-06-29 | `decisions/architecture/infrastructure/projects-owner-own-forks-layout.md` | Moved from root to `infrastructure/` |
| 2026-06-29 | `decisions/architecture/apps/ship-order-2026q3.md` | Moved from root to `apps/` |
| 2026-06-29 | `knowledge/index.md` | Updated references to point to subdirectory paths |
| 2026-06-29 | Multiple files | Fixed invalid `type` values (rejected/fallback/deferred→deprecated/draft) |
| 2026-06-29 | Multiple files | Added `format_version: okf-v0.1` to 29 files |
| 2026-06-29 | Multiple files | Added `status: active` to 111 files |
| 2026-06-29 | Multiple files | Added missing `title`/`description`/`timestamp` fields |
| 2026-06-29 | Multiple files | Compressed all descriptions to caveman style |
| 2026-06-29 | Knowledge restructure | Full recategorisation: rules/agent/ → rules/agent/ (L1), decisions/architecture/ flattened → decisions/, decisions/{branding,design,infrastructure,monetisation,policy,security} → L1, services/ → 6 groups (infra/data/code/business/monitoring/media), runbooks/ deepened (platform/workflow split), concepts/ → core-concepts/, inbox/ → personal/inbox/, playbooks/ merged into runbooks/, archive/ deleted, decisions/pricing/ → monetisation/pricing/, decisions/process/ merged (7→7), 38 general/ files distributed to categories |
