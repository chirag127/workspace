---
type: decision
title: "Mirror repos/own/* to 5 popular GitHub alternatives — weekly cron"
description: "Trim the mirror fleet from 6 hosts to 5 popular feature-complete GitHub alternatives (GitLab, Codeberg, Bitbucket, GitFlic, Azure DevOps). AWS CodeCommit dropped — niche, not named in 2026 popularity rankings, and Amazon stopped onboarding new accounts. Scope narrowed from 'all oriz-org + chirag127 public repos' to 'repos/own/* submodules only' per user's 2026-06-28 ask."
tags: [decision, mirror, insurance, git-host, backup, multi-platform, disaster-recovery]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
supersedes:
  - decisions/architecture/ops/mirror-to-6-git-hosts
related:
  - rules/interaction/no-card-on-file
  - rules/infrastructure/free-tier-with-cost-controls
  - runbooks/hosting/mirror-all-hosts-setup
  - services/hosting/gitlab-mirror
  - services/hosting/codeberg-mirror
  - services/hosting/bitbucket-mirror
  - services/hosting/gitflic-mirror
  - services/hosting/azure-devops-mirror
---

# Mirror repos/own/* to 5 popular GitHub alternatives

## Decision

One automated GitHub Actions workflow (`mirror-all.yml`) pushes every
`repos/own/*` submodule to 5 popular feature-complete GitHub-alternative
hosts on a weekly schedule. Zero manual steps after one-time token setup.

| Workflow | Schedule | Scope | Hosts |
|---|---|---|---|
| `mirror-all.yml` | Friday 03:30 IST (Thu 22:00 UTC) | 20 `repos/own/*` submodules from `.gitmodules` | All 5 hosts |
| `codeberg-mirror.yml` | Daily 08:30 IST (03:00 UTC) | Same scope | Codeberg only (extra daily DR) |

## The 5 popular feature-complete hosts

Picked by cross-checking 2026 GitHub-alternative rankings from dev.to,
aiproductivity.ai, refine.dev, openreplay, eesel.ai, itqlick,
ctodiscovery, mendios, jamdesk, bit-guardian, dokan, towardsai. Every
host below appears in ≥3 of those rankings as a popular feature-complete
alternative AND passes [`no-card-on-file`](../../../rules/interaction/no-card-on-file.md).

| # | Host | Free? | Token type | Env var | Why included |
|---|---|---|---|---|---|
| 1 | **GitLab.com** | ✅ Unlimited repos, 10 GiB/project | PAT (`api` + `write_repository`) | `MIRROR_GITLAB_TOKEN` | #1 named alt in every 2026 ranking; full DevOps |
| 2 | **Codeberg.org** | ✅ Free, non-profit, Forgejo | Access token (`write:repository`) | `MIRROR_CODEBERG_TOKEN` | Top FOSS/Forgejo pick; Gitea Actions CI |
| 3 | **Bitbucket Cloud** | ✅ Unlimited repos, 1 GB ws | Workspace Access Token | `MIRROR_BITBUCKET_API_TOKEN` | Atlassian/Jira-tied; pipelines |
| 4 | **Azure DevOps** | ✅ Unlimited repos, 5 users free | PAT (org-scoped, Code: Manage) | `MIRROR_AZURE_DEVOPS_TOKEN` | MS-backed; pipelines + boards |
| 5 | **GitFlic.ru** | ✅ Free + built-in pull mirror | Personal token | `MIRROR_GITFLIC_TOKEN` | Geopolitical-diversity hedge; full features |

## What changed from `mirror-to-6-git-hosts` (2026-06-24)

1. **−1 host**: AWS CodeCommit dropped. Not named in any 2026
   GitHub-alternative ranking; AWS halted new CodeCommit onboarding mid-2024
   and only briefly walked it back; niche, not "popular".
2. **Scope narrowed**: was "all oriz-org + chirag127 public repos via `gh repo list`"
   → now "20 `repos/own/*` submodules parsed from `.gitmodules`". Smaller,
   deterministic, matches the user's literal request 2026-06-28.
3. **Forks excluded**: `repos/frk/*` skipped — upstream already mirrors them;
   we only patched local copies. The patch lives on GitHub `oriz-org/<slug>`
   and is recoverable from there alone.

## Platforms evaluated and rejected (carried forward + new)

| Platform | Verdict | Reason |
|---|---|---|
| AWS CodeCommit | ❌ Dropped 2026-06-28 | Not in 2026 popularity rankings; AWS halted new onboarding |
| SourceHut (sr.ht) | ❌ Rejected | €4+/month, no free tier — violates `no-card-on-file` |
| Google Cloud Source Repos | ❌ Rejected | Closed to new users since June 17 2024 |
| Gitee (gitee.com) | ❌ Rejected | Requires Chinese phone number |
| Framagit | ❌ Rejected | 42-project cap + manual moderation + mirroring ToS risk |
| NotABug.org | ❌ Rejected | Outdated Gogs fork, unstable |
| Gitea Cloud | ❌ Rejected | 30-day trial only, no free tier |
| GitVerse.ru | ⚠️ Optional | Free + unlimited but Russian-niche; Gitflic already covers that hedge |
| Radicle | ⚠️ Experimental | P2P, different paradigm |
| Launchpad | ⚠️ Niche | Ubuntu-ecosystem focused; FOSS-only |

## How it works

```
Friday 22:00 UTC (Friday 03:30 IST)
├── Job: discover (parse repos/own/* from .gitmodules → 20-repo matrix)
├── Job: mirror-gitlab    ─── matrix: all 20 repos
├── Job: mirror-codeberg  ─── matrix: all 20 repos
├── Job: mirror-bitbucket ─── matrix: all 20 repos
├── Job: mirror-gitflic   ─── matrix: all 20 repos
├── Job: mirror-azure     ─── matrix: all 20 repos
└── Job: weekly-digest (Telegram 5-host summary)
```

Each mirror job:
1. Creates the target repo on the host if missing (idempotent)
2. Clones source with `--mirror` (all branches/tags/refs)
3. Pushes to target with `git push --mirror --force-with-lease`
4. Per-host Telegram completion notification

## Env vars required (chirag127 org-level GitHub Secrets)

```bash
# GitLab
MIRROR_GITLAB_TOKEN=             # PAT: api + write_repository
MIRROR_GITLAB_USERNAME=

# Codeberg
MIRROR_CODEBERG_TOKEN=           # Access token: write:repository
MIRROR_CODEBERG_USERNAME=

# Bitbucket (API Token — App Passwords retired 2026-07-28)
MIRROR_BITBUCKET_API_TOKEN=
MIRROR_BITBUCKET_USERNAME=

# GitFlic
MIRROR_GITFLIC_TOKEN=
MIRROR_GITFLIC_USERNAME=

# Azure DevOps
MIRROR_AZURE_DEVOPS_TOKEN=       # Org-scoped PAT, Code: Manage
MIRROR_AZURE_DEVOPS_ORG=
MIRROR_AZURE_DEVOPS_PROJECT=

# GitHub (already set)
GH_ADMIN_PAT=

# Notifications (already set)
TELEGRAM_BOT_TOKEN=
TELEGRAM_CHAT_ID=
```

`MIRROR_CODECOMMIT_*` and `MIRROR_AWS_*` secrets can be revoked after the
first run of this workflow confirms 5-host parity.

## RPO / RTO

- **RPO**: 7 days worst-case (weekly cron); 24h for Codeberg daily.
- **RTO**: ~45 min to clone from Codeberg → point CF Pages at custom Git URL.

## Cost ceiling

All 5 hosts free without card-on-file (verified across the 2026 ranking
sources cited above). Zero ongoing cost.

## Cross-refs

- Service files → [`services/hosting/`](../../../services/hosting/)
- Setup runbook → [`runbooks/hosting/mirror-all-hosts-setup.md`](../../../runbooks/hosting/mirror-all-hosts-setup.md)
- Migrate to fallback CI → [`runbooks/operations/migrate-ci-platform.md`](../../../runbooks/operations/migrate-ci-platform.md)
- Workflow file → `.github/workflows/mirror-all.yml`
