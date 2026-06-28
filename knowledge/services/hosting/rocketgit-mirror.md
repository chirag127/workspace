---
type: service
title: "RocketGit.com — mirror host #8"
description: "RocketGit.com is mirror host #8. Niche but stable git host. Unlimited free public + private repos, no card. No public REST API for repo creation — repos must be pre-created via the web UI before first push."
tags: [service, hosting, mirror, rocketgit, free]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/ops/mirror-to-9-popular-alternatives-2026-06-28
  - runbooks/hosting/mirror-all-hosts-setup
---

# RocketGit.com

Niche git host. Unlimited free public + private repos; no card.

## Free-tier numbers (2026-06-28)

- Unlimited public + private repos
- No card-on-file, no seat cap
- Non-GitLab/non-Gitea fabric — fabric diversity

## Push method

```
git push --mirror "https://USER:TOKEN@rocketgit.com/user/USER/REPO"
```

Token: dashboard → Settings → API tokens → Create.

## ⚠️ No repo-create REST API

RocketGit doesn't expose a public REST endpoint for creating repos.
Workflow's pre-create step is a no-op for RocketGit; push will 404 until
the repo exists at the target URL.

**Workaround:** create repos manually via the web UI before first cron run.
Idempotent — repeat for each new `repos/own/*` submodule.

## Env vars

```
MIRROR_ROCKETGIT_TOKEN
MIRROR_ROCKETGIT_USERNAME
```

## Cross-refs

- Decision → [`decisions/architecture/ops/mirror-to-9-popular-alternatives-2026-06-28`](../../decisions/architecture/ops/mirror-to-9-popular-alternatives-2026-06-28.md)
- Setup → [`runbooks/hosting/mirror-all-hosts-setup`](../../runbooks/hosting/mirror-all-hosts-setup.md)
- Sign up: <https://rocketgit.com/op/register>
