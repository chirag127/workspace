---
type: log
title: Knowledge bundle change log
description: Chronological append-only log of every new or updated concept file in
  this knowledge bundle.
tags:
- log
- okf
- meta
timestamp: 2026-06-24
format_version: okf-v0.1
---


# Knowledge bundle change log

One line per file, newest at top. Format: `YYYY-MM-DD — path — summary`

---

## 2026-06-24

- 2026-06-24 — `architecture/stack/python.md` — UPDATED: expanded Python stack documentation with comparisons, FastAPI, Pydantic, SQLAlchemy, pytest, and Ruff
- 2026-06-24 — `architecture/stack/go.md` — UPDATED: expanded Go stack documentation with comparisons, Chi, sqlc, testify, and golangci-lint
- 2026-06-24 — `architecture/stack/index.md` — NEW: index file for the new Minimalist & Modern stack hierarchy
- 2026-06-24 — `architecture/stack/javascript-typescript.md` — NEW: documents the minimalist stack for JS/TS
- 2026-06-24 — `architecture/stack/python.md` — NEW: documents the minimalist stack for Python
- 2026-06-24 — `architecture/stack/rust.md` — NEW: documents the minimalist stack for Rust
- 2026-06-24 — `architecture/stack/go.md` — NEW: documents the minimalist stack for Go
- 2026-06-24 — `architecture/stack/java.md` — NEW: documents the minimalist stack for Java
- 2026-06-24 — `architecture/stack/csharp.md` — NEW: documents the minimalist stack for C#
- 2026-06-24 — `architecture/stack/cpp.md` — NEW: documents the minimalist stack for C++
- 2026-06-24 — `runbooks/git-upstream-merge-private-fork.md` — NEW: documents how to host, sync, and merge a private organization copy of a public upstream Chrome extension, plus organization visibility and billing rules.
- 2026-06-24 — `services/compute/github-actions.md` — UPDATED: documents details on organization Actions minute quotas, pool sharing, and account isolation.
- 2026-06-24 — `runbooks/index.md` — UPDATED: listed new `git-upstream-merge-private-fork.md` runbook.
- 2026-06-24 — `decisions/architecture/alternative-free-backup-channels.md` — NEW: documents other free-forever metadata + repository backup channels (R2, B2, HF, Migration API)

- 2026-06-24 — `decisions/architecture/mirror-to-6-git-hosts.md` — NEW: extends 4-host → 6-host mirror (adds Azure DevOps + CodeCommit, fixes Bitbucket auth, adds chirag127 personal repos scope)
- 2026-06-24 — `decisions/architecture/mirror-to-4-git-hosts.md` — UPDATED: status → superseded; superseded_by → mirror-to-6-git-hosts
- 2026-06-24 — `runbooks/mirror-all-hosts-setup.md` — NEW: master one-time setup runbook for all 6 mirror hosts; token generation + repo pre-creation + org secret storage + dry-run steps
- 2026-06-24 — `runbooks/mirror-cron-prep.md` — UPDATED: status → superseded; superseded_by → mirror-all-hosts-setup
- 2026-06-24 — `services/hosting/gitlab-mirror.md` — NEW: GitLab.com as push-mirror target service file; free tier limits, token scopes, API endpoints
- 2026-06-24 — `services/hosting/codeberg-mirror.md` — NEW: Codeberg.org push-mirror target; pull-mirror disabled on public instance; Forgejo API details
- 2026-06-24 — `services/hosting/bitbucket-mirror.md` — NEW: Bitbucket Cloud push-mirror; CRITICAL note on App Password retirement July 2026 → Workspace Access Token
- 2026-06-24 — `services/hosting/gitflic-mirror.md` — NEW: GitFlic.ru push + built-in pull mirror; geopolitical diversity note; Russian hosting risk
- 2026-06-24 — `services/hosting/azure-devops-mirror.md` — NEW: Azure DevOps Repos push-mirror; unlimited free repos; global PAT retirement Dec 1 2026 note
- 2026-06-24 — `services/hosting/codecommit-mirror.md` — NEW: AWS CodeCommit push-mirror; back to GA Nov 2025; IAM HTTPS credentials setup
- 2026-06-24 — `services/hosting/index.md` — UPDATED: added Git Mirror Hosts section with 6 entries + cross-links
- 2026-06-24 — `runbooks/index.md` — UPDATED: mirror-cron-prep marked superseded; mirror-all-hosts-setup added
