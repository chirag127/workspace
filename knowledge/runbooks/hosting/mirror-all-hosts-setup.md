---
type: runbook
title: "Mirror all hosts setup — one-time token generation + repo pre-creation for the 9 popular hosts"
description: 'One-time setup runbook to configure the 9-host automatic git mirror for repos/own/* submodules. Covers token + keypair generation for GitLab, Codeberg, Bitbucket, GitFlic, Azure DevOps, NotABug, GitGud, RocketGit, and Radicle; pre-creating mirror repos on each host; storing tokens directly as oriz-org GitHub org-level secrets (workflow lives in oriz-org/workspace); per-host ENABLE flags as org-level Variables; dry-run + first real run. No manual recurring sync.'
tags:
- runbook
- mirror
- git-host
- gitlab
- codeberg
- bitbucket
- gitflic
- azure-devops
- notabug
- gitgud
- rocketgit
- radicle
- secrets
- setup
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
- decisions/architecture/ops/mirror-to-9-popular-alternatives-2026-06-28
- rules/security/github-org-level-secrets
- rules/infrastructure/free-tier-with-cost-controls
- rules/interaction/no-card-on-file
- runbooks/security/set-github-org-level-secrets
- services/hosting/gitlab-mirror
- services/hosting/codeberg-mirror
- services/hosting/bitbucket-mirror
- services/hosting/gitflic-mirror
- services/hosting/azure-devops-mirror
- services/hosting/notabug-mirror
- services/hosting/gitgud-mirror
- services/hosting/rocketgit-mirror
- services/hosting/radicle-mirror
---

# Mirror all hosts setup — one-time

Complete setup for the 9-host weekly git mirror. Run once. After this, the
Friday cron in `.github/workflows/mirror-all.yml` runs hands-free.

**Where the workflow reads from.** Mirror secrets and `ENABLE_MIRROR_*`
variables live at the **`oriz-org`** GitHub org level — that's the org
that owns the umbrella `oriz-org/workspace` repo running the cron. Local
mirror in `c:/D/oriz/.env` (gitignored) is the authoring copy; Doppler
may also hold it as a personal vault but the workflow path is GitHub
org secrets only.

## Prerequisites

- `gh` CLI authenticated as admin of `oriz-org` org
- Browser access for token generation
- `jq` and `curl` installed
- `rad` CLI (for Radicle keypair only): `curl -sSf https://radicle.xyz/install | sh`

---

## Step 1: Generate 9 host credentials (browser + local)

Fill the value into `c:/D/oriz/.env` next to the matching `MIRROR_<HOST>_*`
key as you go. Push to org secrets in Step 2.

### 1A. GitLab.com — Personal Access Token

1. Log in: <https://gitlab.com>
2. Token page: <https://gitlab.com/-/user_settings/personal_access_tokens>
3. **Add new token** → name `oriz-mirror-bot` → expiry 1 year → scopes ✅ `api` + ✅ `write_repository`
4. Copy → paste into `.env`: `MIRROR_GITLAB_TOKEN`, `MIRROR_GITLAB_USERNAME`

### 1B. Codeberg.org — Access Token

Re-check status first: <https://status.codeberg.eu>. Skip if site is down.

1. Sign up: <https://codeberg.org/user/sign_up>
2. Token page: <https://codeberg.org/user/settings/applications>
3. Under "Manage Access Tokens" → **Generate Token** → name `oriz-mirror-bot` → scope ✅ `write:repository`
4. Copy → `.env`: `MIRROR_CODEBERG_TOKEN`, `MIRROR_CODEBERG_USERNAME`

### 1C. Bitbucket Cloud — Workspace Access Token (NOT App Password)

⚠️ App Passwords retired 2026-07-28. Use Workspace Access Tokens.

1. Sign up: <https://bitbucket.org/account/signup>
2. Token page: <https://bitbucket.org/account/settings/access-tokens/> (if 404: Workspace → Settings → Security → Access tokens)
3. **Create access token** → name `oriz-mirror-bot` → permissions ✅ Repositories: **Write** + ✅ Projects: **Read** → expiry 1 year
4. Copy → `.env`: `MIRROR_BITBUCKET_API_TOKEN`, `MIRROR_BITBUCKET_USERNAME` (workspace slug)

### 1D. GitFlic.ru — Personal Token

1. Sign up: <https://gitflic.ru/auth/signup/first-step>
2. Token page: <https://gitflic.ru/user/settings/tokens>
3. **Create token** → name `oriz-mirror-bot` → scope `repo:write`
4. Copy → `.env`: `MIRROR_GITFLIC_TOKEN`, `MIRROR_GITFLIC_USERNAME`

### 1E. Azure DevOps — Org-scoped PAT

⚠️ Use **org-scoped** PAT, not "All accessible organizations".

1. Sign up: <https://dev.azure.com>
2. Create org (e.g. `chirag127`) → create project (e.g. `mirrors`)
3. Token page: `https://dev.azure.com/{org}/_usersSettings/tokens`
4. **+ New Token** → name `oriz-mirror-bot` → org: pick your specific org → expiry 1 year → custom scope **Code → Manage**
5. Copy → `.env`: `MIRROR_AZURE_DEVOPS_TOKEN`, `MIRROR_AZURE_DEVOPS_ORG`, `MIRROR_AZURE_DEVOPS_PROJECT`

### 1F. NotABug.org — Gogs Access Token

1. Sign up: <https://notabug.org/user/sign_up>
2. Token page: <https://notabug.org/user/settings/applications>
3. **Manage Access Tokens** → Generate New Token → name `oriz-mirror-bot`
4. ⚠️ COPY IMMEDIATELY — Gogs shows the token once
5. Paste → `.env`: `MIRROR_NOTABUG_TOKEN`, `MIRROR_NOTABUG_USERNAME`

Workflow uses `continue-on-error: true` for NotABug so flakes don't break the cron.

### 1G. GitGud.io — GitLab PAT

1. Sign up: <https://gitgud.io/users/sign_up>
2. Token page: <https://gitgud.io/-/user_settings/personal_access_tokens>
3. **Add new token** → name `oriz-mirror-bot` → expiry 1 year → scopes ✅ `api` + ✅ `write_repository`
4. Copy → `.env`: `MIRROR_GITGUD_TOKEN`, `MIRROR_GITGUD_USERNAME`

### 1H. RocketGit.com — API Token

1. Sign up: <https://rocketgit.com/op/register>
2. Dashboard → Settings → API tokens → **Create**
3. Copy → `.env`: `MIRROR_ROCKETGIT_TOKEN`, `MIRROR_ROCKETGIT_USERNAME`

⚠️ RocketGit has no public REST repo-create API. Pre-create each `repos/own/*` repo via the web UI before the first cron, or push will 404. Idempotent: repeat only for new submodules.

### 1I. Radicle — Identity bootstrap (local one-time)

Radicle is P2P. Generate a keypair locally and ship to the runner.

```bash
curl -sSf https://radicle.xyz/install | sh
rad auth                                  # pick an alias + a strong passphrase
# Encode the keypair directory as one line:
tar czf - -C ~/.radicle keys | base64 -w0 > /tmp/rad-keypair-b64.txt
```

Then paste:
- contents of `/tmp/rad-keypair-b64.txt` → `.env`: `MIRROR_RADICLE_KEYPAIR_TAR_B64`
- the passphrase you typed during `rad auth` → `.env`: `MIRROR_RADICLE_PASSPHRASE`

Public seed node `radicle.garden` is used. No self-hosted Radicle node needed.

---

## Step 2: Push all secrets to oriz-org org level

Mirror secrets live at `oriz-org` (the org that owns the workflow repo).
Doppler may also hold them; the workflow only reads org-level GH secrets.
Reads from your local `.env`:

```bash
#!/bin/bash
# Run from c:/D/oriz with .env already populated
set -e
set -a; . ./.env; set +a   # load .env into shell

SECRETS=(
  MIRROR_GITLAB_TOKEN
  MIRROR_GITLAB_USERNAME
  MIRROR_CODEBERG_TOKEN
  MIRROR_CODEBERG_USERNAME
  MIRROR_BITBUCKET_API_TOKEN
  MIRROR_BITBUCKET_USERNAME
  MIRROR_GITFLIC_TOKEN
  MIRROR_GITFLIC_USERNAME
  MIRROR_AZURE_DEVOPS_TOKEN
  MIRROR_AZURE_DEVOPS_ORG
  MIRROR_AZURE_DEVOPS_PROJECT
  MIRROR_NOTABUG_TOKEN
  MIRROR_NOTABUG_USERNAME
  MIRROR_GITGUD_TOKEN
  MIRROR_GITGUD_USERNAME
  MIRROR_ROCKETGIT_TOKEN
  MIRROR_ROCKETGIT_USERNAME
  MIRROR_RADICLE_KEYPAIR_TAR_B64
  MIRROR_RADICLE_PASSPHRASE
)

for NAME in "${SECRETS[@]}"; do
  VAL="${!NAME}"
  if [ -z "$VAL" ]; then
    echo "⊘ skip $NAME (empty in .env)"
    continue
  fi
  printf '%s' "$VAL" | gh secret set "$NAME" --org oriz-org --visibility all
  echo "✓ set $NAME"
done

echo ""
gh secret list --org oriz-org | grep -E '^MIRROR_'
```

Each empty value is skipped so partial setups (e.g. Codeberg still down)
don't blow up the loop.

### Per-host ENABLE flags as org-level Variables

Flags are **Variables**, not Secrets — they're 0/1 toggles, not credentials:

```bash
#!/bin/bash
# Set / reset the 9 ENABLE flags from .env values
set -a; . ./.env; set +a

FLAGS=(
  ENABLE_MIRROR_GITLAB
  ENABLE_MIRROR_CODEBERG
  ENABLE_MIRROR_BITBUCKET
  ENABLE_MIRROR_GITFLIC
  ENABLE_MIRROR_AZURE_DEVOPS
  ENABLE_MIRROR_NOTABUG
  ENABLE_MIRROR_GITGUD
  ENABLE_MIRROR_ROCKETGIT
  ENABLE_MIRROR_RADICLE
)

for NAME in "${FLAGS[@]}"; do
  VAL="${!NAME:-0}"
  gh variable set "$NAME" --org oriz-org --visibility all --body "$VAL"
  echo "✓ var $NAME=$VAL"
done

gh variable list --org oriz-org | grep -E '^ENABLE_MIRROR_'
```

To toggle a single host later: `gh variable set ENABLE_MIRROR_CODEBERG --org oriz-org --visibility all --body 1`.

---

## Step 3: Pre-create mirror repos on each host

This script reads `repos/own/*` submodules from `.gitmodules` and creates
empty target repos on the 6 HTTPS hosts (Radicle creates on first
`rad init`, no pre-creation step needed). Idempotent — 409/4xx errors on
existing repos are ignored.

```bash
#!/bin/bash
# pre-create-mirror-repos.sh — requires curl, jq
set -e
set -a; . ./.env; set +a

# Collect repos/own/* submodule names from .gitmodules
REPOS=$(awk '
  /^\[submodule/ { path="" }
  /^[[:space:]]*path[[:space:]]*=/ { sub(/^[^=]*=[[:space:]]*/, ""); path=$0
    if (path ~ /^repos\/own\//) { n=split(path, p, "/"); print p[n] }
  }
' .gitmodules)

echo "$REPOS" | while read -r REPO_NAME; do
  [ -z "$REPO_NAME" ] && continue
  echo "--- $REPO_NAME ---"

  # GitLab
  if [ "${ENABLE_MIRROR_GITLAB:-0}" = "1" ] && [ -n "$MIRROR_GITLAB_TOKEN" ]; then
    curl -s -o /dev/null -X POST "https://gitlab.com/api/v4/projects" \
      -H "PRIVATE-TOKEN: ${MIRROR_GITLAB_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "{\"name\":\"${REPO_NAME}\",\"visibility\":\"public\"}" || true
    sleep 0.3
  fi

  # Codeberg
  if [ "${ENABLE_MIRROR_CODEBERG:-0}" = "1" ] && [ -n "$MIRROR_CODEBERG_TOKEN" ]; then
    curl -s -o /dev/null -X POST "https://codeberg.org/api/v1/user/repos" \
      -H "Authorization: token ${MIRROR_CODEBERG_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "{\"name\":\"${REPO_NAME}\",\"private\":false,\"auto_init\":false}" || true
    sleep 0.3
  fi

  # Bitbucket
  if [ "${ENABLE_MIRROR_BITBUCKET:-0}" = "1" ] && [ -n "$MIRROR_BITBUCKET_API_TOKEN" ]; then
    curl -s -o /dev/null -X POST \
      -H "Authorization: Bearer ${MIRROR_BITBUCKET_API_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "{\"scm\":\"git\",\"is_private\":false}" \
      "https://api.bitbucket.org/2.0/repositories/${MIRROR_BITBUCKET_USERNAME}/${REPO_NAME}" || true
    sleep 0.3
  fi

  # GitFlic
  if [ "${ENABLE_MIRROR_GITFLIC:-0}" = "1" ] && [ -n "$MIRROR_GITFLIC_TOKEN" ]; then
    curl -s -o /dev/null -X POST "https://api.gitflic.ru/project" \
      -H "Authorization: token ${MIRROR_GITFLIC_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "{\"title\":\"${REPO_NAME}\",\"alias\":\"${REPO_NAME}\",\"private\":false}" || true
    sleep 0.3
  fi

  # Azure DevOps (cache project ID across iterations)
  if [ "${ENABLE_MIRROR_AZURE_DEVOPS:-0}" = "1" ] && [ -n "$MIRROR_AZURE_DEVOPS_TOKEN" ]; then
    if [ -z "$ADO_PROJECT_ID" ]; then
      ADO_PROJECT_ID=$(curl -s -u ":${MIRROR_AZURE_DEVOPS_TOKEN}" \
        "https://dev.azure.com/${MIRROR_AZURE_DEVOPS_ORG}/_apis/projects/${MIRROR_AZURE_DEVOPS_PROJECT}?api-version=7.1" \
        | jq -r '.id')
      export ADO_PROJECT_ID
    fi
    curl -s -o /dev/null -X POST -u ":${MIRROR_AZURE_DEVOPS_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "{\"name\":\"${REPO_NAME}\",\"project\":{\"id\":\"${ADO_PROJECT_ID}\"}}" \
      "https://dev.azure.com/${MIRROR_AZURE_DEVOPS_ORG}/${MIRROR_AZURE_DEVOPS_PROJECT}/_apis/git/repositories?api-version=7.1" || true
    sleep 0.3
  fi

  # NotABug (Gogs API)
  if [ "${ENABLE_MIRROR_NOTABUG:-0}" = "1" ] && [ -n "$MIRROR_NOTABUG_TOKEN" ]; then
    curl -s -o /dev/null -X POST "https://notabug.org/api/v1/user/repos" \
      -H "Authorization: token ${MIRROR_NOTABUG_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "{\"name\":\"${REPO_NAME}\",\"private\":false,\"auto_init\":false}" || true
    sleep 0.3
  fi

  echo "✓ $REPO_NAME pre-created (enabled hosts only; Radicle inits on first sync)"
done
```

---

## Step 4: Dry-run the workflow

```bash
gh workflow run mirror-all.yml --repo oriz-org/workspace
gh run watch --repo oriz-org/workspace
```

Disabled hosts emit `::notice::Mirror <host> disabled` and skip. Enabled
hosts should show ✓ per repo. Any ✗ = missing repo or wrong token — fix
before the next Friday cron.

## Step 5: First real run

The cron runs every Friday 22:00 UTC. To force one now:

```bash
gh workflow run mirror-all.yml --repo oriz-org/workspace
```

Spot-check each enabled host's web UI for a fresh commit history matching
GitHub HEAD.

---

## Adding a new repo (recurring task)

When a new submodule is added under `repos/own/*`:

1. Re-run Step 3's repo-creation script (idempotent — safe to re-run).
2. The next Friday cron picks up the new repo automatically.

---

## Token rotation

When a token expires or is compromised:

1. Regenerate on the host (see Step 1 for the exact URL).
2. Overwrite the value in `c:/D/oriz/.env`.
3. Re-run Step 2's `gh secret set` loop — it overwrites existing secrets idempotently.
4. Per [`runbooks/security/rotate-leaked-secret.md`](../security/rotate-leaked-secret.md).

---

## Re-enabling a previously disabled host

When a downed host (Codeberg / Bitbucket / GitFlic) comes back:

1. Verify signup + token page work end-to-end (Step 1).
2. Paste credentials into `c:/D/oriz/.env`.
3. Flip `ENABLE_MIRROR_<HOST>=1` in `.env`.
4. Re-run Step 2 (secrets loop) and Step 2's flag loop.
5. Re-run Step 3 to create any missing target repos.

---

## See also

- Mirror decision → [`../../decisions/architecture/ops/mirror-to-9-popular-alternatives-2026-06-28.md`](../../decisions/architecture/ops/mirror-to-9-popular-alternatives-2026-06-28.md)
- Org secrets rule → [`../../rules/security/github-org-level-secrets.md`](../../rules/security/github-org-level-secrets.md)
- Set org secrets runbook → [`../security/set-github-org-level-secrets.md`](../security/set-github-org-level-secrets.md)
- Rotate leaked secret → [`../security/rotate-leaked-secret.md`](../security/rotate-leaked-secret.md)
- Service files per host → [`../../services/hosting/`](../../services/hosting)
- Workflow file → `.github/workflows/mirror-all.yml`
