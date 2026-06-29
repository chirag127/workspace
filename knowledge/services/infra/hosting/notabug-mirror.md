---
type: service
title: "NotABug.org — mirror host #6"
description: "Gogs-based mirror #6 — free git hosting, no signup wall, no card"
tags: [service, hosting, mirror, notabug, gogs, free]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - decisions/ops/mirror-to-9-popular-alternatives-2026-06-28
  - runbooks/platform/mirror-all-hosts-setup
---

# NotABug.org

Free Gogs-based public git host. Mirror host #6 in the 9-host weekly cron.

## Free-tier numbers (2026-06-28)

- Unlimited public repos
- Unlimited storage (soft — community-funded)
- API supports repo creation + HTTPS push
- No card-on-file, no quota, no team-seat cap
- Caveat: site shows "ERROR! :(" intermittently in 2026. Workflow uses
  `continue-on-error: true` so the cron survives a flake.

## Push method

```
git push --mirror "https://USER:TOKEN@notabug.org/USER/REPO.git"
```

Token: <https://notabug.org/user/settings/applications> → Manage Access Tokens

## Env vars

```
MIRROR_NOTABUG_TOKEN
MIRROR_NOTABUG_USERNAME
```

## Cross-refs

- Decision → [`decisions/ops/mirror-to-9-popular-alternatives-2026-06-28`](../../decisions/ops/mirror-to-9-popular-alternatives-2026-06-28.md)
- Setup → [`runbooks/platform/mirror-all-hosts-setup`](../../runbooks/platform/mirror-all-hosts-setup.md)
