---
type: decision
title: "Mirror repos/own/* to 7 popular GitHub alternatives — weekly cron from the umbrella repo"
description: "Backup repos/own/* submodules to 7 free, no-self-hosting GitHub alternatives — GitLab, Codeberg, Bitbucket, GitFlic, Azure DevOps, NotABug, and Radicle (P2P) — driven entirely from GitHub Actions on the oriz-org/workspace umbrella repo. No local state, no self-hosted hardware, no card-on-file."
tags: [decision, mirror, insurance, git-host, backup, multi-platform, disaster-recovery, radicle, notabug]
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
  - services/hosting/notabug-mirror
  - services/hosting/radicle-mirror
---

# Mirror repos/own/* to 7 popular GitHub alternatives

## Decision

One GitHub Actions workflow (`.github/workflows/mirror-all.yml`) on the
umbrella repo pushes every `repos/own/*` submodule to **7 free, no-self-host
GitHub-alternative hosts** on a weekly schedule. All state lives in the
workflow + org-level secrets — zero local runner.

| Workflow | Schedule | Scope | Hosts |
|---|---|---|---|
| `mirror-all.yml` | Friday 03:30 IST (Thu 22:00 UTC) | 20 `repos/own/*` submodules from `.gitmodules` | All 7 |
| `codeberg-mirror.yml` | Daily 08:30 IST (03:00 UTC) | Same scope | Codeberg only (daily DR) |

## The 7 hosts

All free, no card, no self-hosting required. Six are managed git hosts; Radicle is a P2P seed-node network.

| # | Host | Free model | Push method | Env var(s) |
|---|---|---|---|---|
| 1 | **GitLab.com** | Unlimited public repos | HTTPS PAT (`api` + `write_repository`) | `MIRROR_GITLAB_TOKEN`, `MIRROR_GITLAB_USERNAME` |
| 2 | **Codeberg.org** | FOSS non-profit, Forgejo | HTTPS token (`write:repository`) | `MIRROR_CODEBERG_TOKEN`, `MIRROR_CODEBERG_USERNAME` |
| 3 | **Bitbucket Cloud** | Unlimited public repos | Workspace Access Token (NOT App Password) | `MIRROR_BITBUCKET_API_TOKEN`, `MIRROR_BITBUCKET_USERNAME` |
| 4 | **Azure DevOps** | Unlimited repos, 5 free users | Org-scoped PAT (`Code: Manage`) | `MIRROR_AZURE_DEVOPS_TOKEN`, `MIRROR_AZURE_DEVOPS_ORG`, `MIRROR_AZURE_DEVOPS_PROJECT` |
| 5 | **GitFlic.ru** | Free + pull-mirror feature | Personal token | `MIRROR_GITFLIC_TOKEN`, `MIRROR_GITFLIC_USERNAME` |
| 6 | **NotABug.org** | Free, Gogs-based, no signup wall | HTTPS access token | `MIRROR_NOTABUG_TOKEN`, `MIRROR_NOTABUG_USERNAME` |
| 7 | **Radicle** | Free P2P, public seed node `radicle.garden` | `rad` CLI + restored keypair | `MIRROR_RADICLE_KEYPAIR_TAR_B64`, `MIRROR_RADICLE_PASSPHRASE` |

## Why these 7 (not more, not fewer)

- **Cross-checked against 2026 GitHub-alternative rankings** from dev.to,
  aiproductivity.ai, refine.dev, openreplay, eesel.ai, itqlick,
  ctodiscovery, mendios, jamdesk, bit-guardian, dokan, towardsai.
- **All 7 are free without card-on-file** — no `no-card-on-file` rule violation.
- **All 7 are managed/network hosts, no self-host** — agent's GitHub Actions
  runner pushes; no VPS, no Docker, no daily heartbeat from a laptop.
- **Two added 2026-06-28** on user direction:
  - **NotABug** — Gogs API, HTTPS push, intermittent stability noted but
    free DR insurance worth having. Failure tolerated by `continue-on-error: true`.
  - **Radicle** — P2P seed network; pushed via `rad sync --announce`
    after restoring identity from `MIRROR_RADICLE_KEYPAIR_TAR_B64`.
    Uses public seed `radicle.garden` so no self-hosted node needed.
    Reference action: <https://github.com/gsaslis/mirror-to-radicle>.

## Rejected (kept here, won't be added)

| Platform | Why not |
|---|---|
| AWS CodeCommit | AWS halted onboarding mid-2024; not in 2026 rankings |
| SourceHut (sr.ht) | €4+/month, no free tier — violates `no-card-on-file` |
| Google Cloud Source Repos | Closed to new users since 2024-06-17 |
| Gitee (gitee.com) | Requires Chinese phone number |
| Framagit | 42-project cap + manual moderation |
| Gitea Cloud | 30-day trial only |
| GitVerse.ru | Russian-niche; GitFlic already covers that hedge |
| Launchpad | Ubuntu-ecosystem only |

## Architecture

```
GitHub repo: oriz-org/workspace
└── .github/workflows/mirror-all.yml  (the only state)

Friday 22:00 UTC (Friday 03:30 IST)
├── Job: discover (parse repos/own/* from .gitmodules → 20-repo matrix)
├── Job: mirror (matrix × 6 hosts: GitLab, Codeberg, Bitbucket, GitFlic, Azure, NotABug)
├── Job: mirror-radicle (separate — installs rad CLI, restores keypair, syncs)
└── Job: weekly-digest (Telegram 7-host summary)
```

All credentials live as **org-level GitHub Secrets** under `chirag127` —
see [`rules/security/github-org-level-secrets.md`](../../../rules/security/github-org-level-secrets.md).

## Radicle identity bootstrap (one-time)

The runner needs a Radicle keypair to push. Generate it once locally and
store as a base64 tarball in `MIRROR_RADICLE_KEYPAIR_TAR_B64`:

```bash
# Local one-time
curl -sSf https://radicle.xyz/install | sh
rad auth                                          # creates ~/.radicle/keys
tar czf - -C ~/.radicle keys | base64 -w0 \
  | gh secret set MIRROR_RADICLE_KEYPAIR_TAR_B64 --org chirag127 --visibility all
gh secret set MIRROR_RADICLE_PASSPHRASE --org chirag127 --visibility all  # type when prompted
```

Workflow then unpacks `~/.radicle/keys`, configures `radicle.garden` as
the preferred seed, and runs `rad init` (idempotent) + `rad sync --announce`.

## RPO / RTO

- **RPO**: 7 days worst-case (weekly cron); 24h for Codeberg.
- **RTO**: ~45 min to clone from any working mirror → point CF Pages at custom URL.
- **Bus-factor**: 7 independent hosts × 3 governance models (corporate, FOSS non-profit, P2P).

## Cost ceiling

All 7 hosts free without card-on-file (verified 2026-06-28). Zero ongoing cost.

## Cross-refs

- Setup runbook → [`runbooks/hosting/mirror-all-hosts-setup.md`](../../../runbooks/hosting/mirror-all-hosts-setup.md)
- Service files → [`services/hosting/`](../../../services/hosting/)
- Workflow file → `.github/workflows/mirror-all.yml`
- `gsaslis/mirror-to-radicle` reference action — <https://github.com/gsaslis/mirror-to-radicle>
