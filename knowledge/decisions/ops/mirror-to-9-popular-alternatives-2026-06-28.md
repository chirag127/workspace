---
type: decision
title: "Mirror repos/own/* to 9 popular GitHub alternatives — weekly cron from the umbrella repo"
description: Mirror repos/own/* to 9 free Git hosts via GH Actions
tags: [decision, mirror, insurance, git-host, backup, multi-platform, disaster-recovery, radicle, notabug, gitgud, rocketgit]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
supersedes:
  - decisions/ops/mirror-to-7-popular-alternatives-2026-06-28
related:
  - rules/interaction/no-card-on-file
  - rules/infrastructure/free-tier-with-cost-controls
  - runbooks/platform/mirror-all-hosts-setup
  - services/infra/hosting/gitlab-mirror
  - services/infra/hosting/codeberg-mirror
  - services/infra/hosting/bitbucket-mirror
  - services/infra/hosting/gitflic-mirror
  - services/infra/hosting/azure-devops-mirror
  - services/infra/hosting/notabug-mirror
  - services/infra/hosting/gitgud-mirror
  - services/infra/hosting/rocketgit-mirror
  - services/infra/hosting/radicle-mirror
---

# Mirror repos/own/* to 9 popular GitHub alternatives

## Decision

One GitHub Actions workflow (`.github/workflows/mirror-all.yml`) on the
`oriz-org/workspace` umbrella repo pushes every `repos/own/*` submodule
to **9 free, no-self-host GitHub-alternative hosts** on a weekly
schedule. All state lives in the workflow + `oriz-org` org-level secrets
and variables — zero local runner, zero card.

| Workflow | Schedule | Scope | Hosts |
|---|---|---|---|
| `mirror-all.yml` | Friday 03:30 IST (Thu 22:00 UTC) | 20 `repos/own/*` submodules from `.gitmodules` | All 9 |
| `codeberg-mirror.yml` | Daily 08:30 IST (03:00 UTC) | Same scope | Codeberg only (daily DR) |

## The 9 hosts

All free, no card, no self-hosting. Eight are managed git hosts; Radicle is a P2P seed-node network.

| # | Host | Free model | Push method | Env var(s) |
|---|---|---|---|---|
| 1 | **GitLab.com** | Unlimited public repos | HTTPS PAT (`api` + `write_repository`) | `MIRROR_GITLAB_TOKEN`, `MIRROR_GITLAB_USERNAME` |
| 2 | **Codeberg.org** | FOSS non-profit, Forgejo | HTTPS token (`write:repository`) | `MIRROR_CODEBERG_TOKEN`, `MIRROR_CODEBERG_USERNAME` |
| 3 | **Bitbucket Cloud** | Unlimited public + private (5 users) | Workspace Access Token | `MIRROR_BITBUCKET_API_TOKEN`, `MIRROR_BITBUCKET_USERNAME` |
| 4 | **Azure DevOps** | Unlimited repos, 5 free users | Org-scoped PAT (`Code: Manage`) | `MIRROR_AZURE_DEVOPS_TOKEN`, `MIRROR_AZURE_DEVOPS_ORG`, `MIRROR_AZURE_DEVOPS_PROJECT` |
| 5 | **GitFlic.ru** | Free + pull-mirror feature | Personal token | `MIRROR_GITFLIC_TOKEN`, `MIRROR_GITFLIC_USERNAME` |
| 6 | **NotABug.org** | Free, Gogs-based | HTTPS access token | `MIRROR_NOTABUG_TOKEN`, `MIRROR_NOTABUG_USERNAME` |
| 7 | **GitGud.io** | GitLab + Sapphire, unlimited free public + private | HTTPS PAT | `MIRROR_GITGUD_TOKEN`, `MIRROR_GITGUD_USERNAME` |
| 8 | **RocketGit.com** | Unlimited public + private, free | HTTPS API token | `MIRROR_ROCKETGIT_TOKEN`, `MIRROR_ROCKETGIT_USERNAME` |
| 9 | **Radicle** | Free P2P, public seed `radicle.garden` | `rad` CLI + restored keypair | `MIRROR_RADICLE_KEYPAIR_TAR_B64`, `MIRROR_RADICLE_PASSPHRASE` |

## Two hosts added 2026-06-28

| Host | Why added |
|---|---|
| **GitGud.io** | GitLab + Sapphire; unlimited free public + private; managed; another GitLab-fabric mirror under a different operator (trust-sphere diversity). |
| **RocketGit** | Niche but stable git-only host, unlimited public + private free, no card; adds non-GitLab/non-Gitea fabric for max code-host diversity. No public REST API for repo creation — pre-create manually if push 404s. |

## Rejected (kept here, won't be added)

| Platform | Why not |
|---|---|
| **Framagit** | 42-project cap per user — too tight for future scale even though we have 20 today |
| AWS CodeCommit | AWS halted onboarding mid-2024; not in 2026 rankings |
| SourceHut (sr.ht) | €4+/month — violates `no-card-on-file` |
| Google Cloud Source Repos | Closed to new users since 2024-06-17 |
| Gitee (gitee.com) | Requires Chinese phone number |
| Heptapod | Mercurial-first; git support via hg-git bridge, no clean `git push --mirror` |
| Pijul | Not git — different patch model |
| Projectlocker | 1 project / 50 MB — won't hold 20 repos |
| Savannah (GNU + non-GNU) | Manual approval per project; FOSS-only |
| Gitea Cloud | 30-day trial only |
| GitVerse.ru | Russian-niche; GitFlic already covers that hedge |
| Launchpad | Ubuntu-ecosystem only |

## Architecture

```
GitHub repo: oriz-org/workspace
+-- .github/workflows/mirror-all.yml  (the only state)

Friday 22:00 UTC (Friday 03:30 IST)
+-- Job: discover (parse repos/own/* from .gitmodules ? 20-repo matrix)
+-- Job: mirror (matrix × 8 HTTPS hosts:
¦     GitLab, Codeberg, Bitbucket, GitFlic, Azure, NotABug,
¦     GitGud, RocketGit)
+-- Job: mirror-radicle (separate — installs rad CLI, restores keypair, syncs)
+-- Job: weekly-digest (Telegram 9-host summary)
```

All credentials live as **org-level GitHub Secrets** under `oriz-org`
(the org that owns the umbrella `oriz-org/workspace` repo running the
cron). ENABLE flags live as **org-level Variables** so each host can be
flipped 0?1 without touching credentials.

## Radicle identity bootstrap (one-time)

The runner needs a Radicle keypair to push. Generate it once locally and
store as a base64 tarball in `MIRROR_RADICLE_KEYPAIR_TAR_B64`:

```bash
# Local one-time
curl -sSfL -H "Accept: text/plain" https://radicle.xyz/install | sh
rad auth                                          # creates ~/.radicle/keys
tar czf - -C ~/.radicle keys | base64 -w0 \
  | gh secret set MIRROR_RADICLE_KEYPAIR_TAR_B64 --org oriz-org --visibility all
gh secret set MIRROR_RADICLE_PASSPHRASE --org oriz-org --visibility all
```

Workflow then unpacks `~/.radicle/keys`, configures `radicle.garden` as
the preferred seed, and runs `rad init` (idempotent) + `rad sync --announce`.

## RPO / RTO

- **RPO**: 7 days worst-case (weekly cron); 24h for Codeberg.
- **RTO**: ~45 min to clone from any working mirror ? point CF Pages at custom URL.
- **Bus-factor**: 9 independent hosts × 4 governance models — corporate
  (Microsoft Azure, Atlassian, GitLab Inc), FOSS non-profit (Codeberg),
  niche-operator (GitFlic, NotABug, GitGud, RocketGit), P2P (Radicle).

## Cost ceiling

All 9 hosts free without card-on-file (verified 2026-06-28). Zero ongoing cost.

## Cross-refs

- Setup runbook ? [`runbooks/platform/mirror-all-hosts-setup.md`](../../../runbooks/platform/mirror-all-hosts-setup.md)
- Service files ? [`services/infra/hosting/`](../../../services/infra/hosting/)
- Workflow file ? `.github/workflows/mirror-all.yml`
- `gsaslis/mirror-to-radicle` reference action — <https://github.com/gsaslis/mirror-to-radicle>
