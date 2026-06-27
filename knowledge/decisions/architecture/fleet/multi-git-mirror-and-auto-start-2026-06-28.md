---
type: decision
title: "Public-only multi-Git mirror + auto-start services + datasets-to-build queue"
description: "Master plan locked 2026-06-28: mirror oriz-org public repos to 4-5 Git providers, auto-start Hr/RTK/cavemem on login, queue of datasets to ship as static APIs."
tags: [backup, mirroring, auto-start, datasets, master-plan]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - runbooks/hosting/mirror-all-hosts-setup
  - rules/agent/preferences/dont-recreate-what-exists-freely
  - rules/agent/preferences/always-search-twice-before-deciding
---

# Master plan — multi-Git mirror + auto-start + dataset queue

## 1. Multi-Git mirror

**Goal**: every public `oriz-org/*` and `chirag127/*` repo gets pushed to N Git providers automatically. If one provider goes down or DMCAs us, the others stand.

**Targets (locked 2026-06-28)** — every **managed** (non-self-hosted) Git host:

| # | Provider | URL pattern | Why |
|---|---|---|---|
| 1 | **GitHub** (primary) | `github.com/oriz-org/<slug>` | Where the work happens |
| 2 | **GitLab Cloud** | `gitlab.com/oriz-org/<slug>` | Free unlimited public; mature CI |
| 3 | **Codeberg** | `codeberg.org/oriz-org/<slug>` | German non-profit, EU jurisdiction, no AI training |
| 4 | **Bitbucket Cloud** | `bitbucket.org/oriz-org/<slug>` | Atlassian, free 5-user public |
| 5 | **Azure DevOps** | `dev.azure.com/oriz-org/<slug>` | Microsoft enterprise host |
| 6 | **GitFlic** | `gitflic.ru/oriz-org/<slug>` | Russian-hosted, relaxed DMCA |
| 7 | **GitGud.io** | `gitgud.io/oriz-org/<slug>` | Sapphire.moe-hosted GitLab, fringe-friendly |
| 8 | **Notabug.org** | `notabug.org/oriz-org/<slug>` | P2P-friendly, FOSS, minimal admin interference |
| 9 | **SourceHut** | `git.sr.ht/~oriz-org/<slug>` | Hyper-minimalist, no JS, no tracking |
| 10 | **Gitea.com** (hosted) | `gitea.com/oriz-org/<slug>` | Public Gitea instance (NOT self-host) |

**Scope of mirroring**:
- ✅ Only repos under `repos/own/*` in the umbrella (originals we authored)
- ❌ NOT `repos/frk/*` (forks — upstream already exists elsewhere)
- ❌ NOT private content (per public-only rule)

**Skipped (and why)**:

- Self-hosted Gitea/Forgejo/GitLab CE — we don't run servers (per `cloud-dbs-as-caches` + no-self-host bias)
- Radicle (P2P) — too niche, no web URL means no jsDelivr equivalent

**Implementation**: GitHub Actions workflow in each repo that pushes to all 4 mirrors on every push to main. Use `pixta-dev/repository-mirroring-action` or hand-rolled `git push --mirror` per provider. Secrets (mirror PATs) stored as GH Actions org-level secrets.

**Scope**: PUBLIC repos only. Secrets stay in restic→Backblaze B2 + Bitwarden per existing rules. No private mirror repo.

## 2. Auto-start services

**Goal**: Hr (Headroom), hai, RTK hook, cavemem worker, plus anything else session-critical, start on user login without manual intervention. Survive reboot.

**Mechanism**: Windows Task Scheduler entries triggered at user logon. One entry per service. Each entry runs a small `.cmd` or directly the binary.

**Services to wire**:

| Service | What | Why auto-start |
|---|---|---|
| Headroom Docker container | Hr→hai→Bedrock chain on `localhost:8787` | Claude Code fails if `:8787` is down |
| cavemem worker | local SQLite worker on `:37777` | Background memory writes need it |
| RTK hook | Per-session via Claude Code hook (already wired) | n/a — fires on demand |
| MCP servers | Per-session via Claude Code MCP config | n/a — Claude Code starts them |

So actually only **Headroom + cavemem** truly need Task Scheduler. RTK + MCP run inside Claude Code.

**Implementation**: a single script `C:\D\oriz\scripts\install-auto-start.cmd` that:
1. Registers a Scheduled Task `Oriz-Headroom-Login` running `docker start headroom` at user logon
2. Registers a Scheduled Task `Oriz-Cavemem-Login` running `cavemem start` at user logon
3. Both with "Run only when user is logged on" + "Run with highest privileges"

## 3. Dataset queue — build order

Verified gaps from 2026-06-28 audit (no free OSS API exists for any of these):

| # | Dataset | Subdomain | Effort estimate | Time-to-ship | Status |
|---|---|---|---|---|---|
| 1 | Indian RTO codes | `rto.oriz.in` | Trivial | ~2 hours | ✅ Shipped 2026-06-28 (`oriz-org/rto-api`, 1299 codes, 35 states) |
| 2 | Physics constants (CODATA 2022) | `constants.oriz.in` | Trivial — one-shot CODATA parse, ~150 constants | ~2 hours | Queued |
| 3 | Indian classical music ragas | `ragas.oriz.in` | Moderate — schema exists at OpenRaga/ragajson, no hosted API; merge Hindustani+Carnatic data | ~1 day | Queued |
| 4 | Indian dynasties timeline | `dynasties.oriz.in` | Moderate — Wikipedia scrape + reconciliation across articles | ~1 day | Queued |
| 5 | RestCountries extension (mottos, founding dates, former capitals) | `countries-plus.oriz.in` | Moderate — Wikipedia infobox parse + merge with existing RestCountries shape | ~1 day | Queued |

**Build order rationale**: Constants next (trivial, fastest validation of the rto-api pattern on a different dataset). Then ragas/dynasties/countries-plus in parallel if time allows.

**Each ships with same pattern**:
- One repo `oriz-org/<slug>-api`
- jsDelivr URL immediately works after first push
- CF Pages subdomain `<slug>.oriz.in` wired after `wrangler login` (done as of 2026-06-28)
- Auto-mirrored to GitLab/Codeberg/Bitbucket per §1

## 4. Sequence to execute

1. **Deploy `rto.oriz.in`** to CF Pages now (wrangler is authed; 5-10 min)
2. **Lock auto-start rule** + write `install-auto-start.cmd`
3. **Set up mirror automation** — create org accounts on GitLab/Codeberg/Bitbucket, generate PATs, store as GH org secrets, write the reusable workflow
4. **Ship Physics Constants API** (next dataset)
5. **Ship the remaining 3 datasets** one by one
6. **Backfill mirrors** — once §3 works, run a one-time backfill to push every existing oriz-org/* and chirag127/* public repo to all mirrors

Step 1 can happen this session. §2-§6 likely need multiple sessions; this plan is the durable spec.

## 5. Cost (verified 2x via web search)

| Item | Cost |
|---|---|
| GitHub Pages / Actions | ₹0 (2000 min/mo) |
| GitLab Cloud free tier | ₹0 (free public, free 5GB) |
| Codeberg | ₹0 (FOSS-only, donations-funded) |
| Bitbucket free | ₹0 (5 users, 1GB LFS) |
| Azure DevOps free | ₹0 (5 users public) |
| Cloudflare Pages | ₹0 (100 projects free) |
| Cloudflare DNS | ₹0 (unlimited) |
| oriz.in domain | already owned |
| jsDelivr CDN | ₹0 (unlimited public-repo serving) |
| **Total ongoing** | **₹0** |
