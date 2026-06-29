---
type: service
title: "GitGud.io — mirror host #7"
description: "GitLab+Sapphire mirror #7 — unlimited free repos, CI/CD, no card"
tags: [service, hosting, mirror, gitgud, gitlab, sapphire, free]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - decisions/ops/mirror-to-9-popular-alternatives-2026-06-28
  - runbooks/platform/mirror-all-hosts-setup
---

# GitGud.io

Managed GitLab + Sapphire instance. Unlimited free public + private git
hosting; no card.

## Free-tier numbers (2026-06-28)

- Unlimited public + private repos
- Built-in CI/CD, container registry, static hosting, issue tracking
- No card-on-file, no seat cap, no project cap
- Independent operator — trust-sphere diversity from gitlab.com

## Push method

```
git push --mirror "https://oauth2:TOKEN@gitgud.io/USER/REPO.git"
```

Token: <https://gitgud.io/-/user_settings/personal_access_tokens> → Add new token → scopes: `api` + `write_repository`.

## Env vars

```
MIRROR_GITGUD_TOKEN
MIRROR_GITGUD_USERNAME
```

## Cross-refs

- Decision → [`decisions/ops/mirror-to-9-popular-alternatives-2026-06-28`](../../decisions/ops/mirror-to-9-popular-alternatives-2026-06-28.md)
- Setup → [`runbooks/platform/mirror-all-hosts-setup`](../../runbooks/platform/mirror-all-hosts-setup.md)
- Sign up: <https://gitgud.io/users/sign_up>
