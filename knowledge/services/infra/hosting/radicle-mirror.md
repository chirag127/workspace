---
type: service
title: "Radicle — mirror host #7 (P2P)"
description: "P2P git mirror #7 — push via `rad` CLI, no self-hosted node needed"
tags: [service, hosting, mirror, radicle, p2p, free]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - decisions/ops/mirror-to-9-popular-alternatives-2026-06-28
  - runbooks/platform/mirror-all-hosts-setup
---

# Radicle

Free peer-to-peer git network. Mirror host #7 in the 9-host weekly cron.
Different paradigm — no centralized host, replication via seed nodes.

## Free-tier numbers (2026-06-28)

- Free, no signup, no card-on-file
- Public seed node `radicle.garden` accepts all comers (no self-host needed)
- Browse mirrored repos at `https://radicle.network/nodes/<seed>.radicle.garden/<repo-id>`

## Push method

```bash
# In a clone of the source repo
rad init --name "$REPO" --public --default-branch main --no-confirm
rad sync --announce
```

Requires `~/.radicle/keys/` populated with a Radicle identity. In CI,
the identity is restored from base64-tarball secret `MIRROR_RADICLE_KEYPAIR_TAR_B64`
and unlocked with `MIRROR_RADICLE_PASSPHRASE`. Reference action:
<https://github.com/gsaslis/mirror-to-radicle>.

## Env vars

```
MIRROR_RADICLE_KEYPAIR_TAR_B64   # base64(tar of ~/.radicle/keys)
MIRROR_RADICLE_PASSPHRASE
```

## Cross-refs

- Decision → [`decisions/ops/mirror-to-9-popular-alternatives-2026-06-28`](../../decisions/ops/mirror-to-9-popular-alternatives-2026-06-28.md)
- Setup → [`runbooks/platform/mirror-all-hosts-setup`](../../runbooks/platform/mirror-all-hosts-setup.md)
- Reference action → <https://github.com/gsaslis/mirror-to-radicle>
- Radicle install → <https://radicle.xyz>
