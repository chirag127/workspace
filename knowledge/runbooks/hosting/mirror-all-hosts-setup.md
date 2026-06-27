---
type: runbook
title: "Mirror all hosts setup \u2014 one-time token generation + repo pre-creation\
  \ for the 7 popular hosts"
description: 'One-time setup runbook to configure the 7-host automatic git mirror
  for repos/own/* submodules. Covers: token generation for GitLab, Codeberg, Bitbucket
  (API Token, NOT App Password), GitFlic, Azure DevOps, NotABug, and Radicle (P2P
  identity bootstrap); pre-creating mirror repos on each host; storing tokens at
  chirag127 GitHub org level; and running the first dry-run. All steps automated
  except token generation (browser UI). No manual recurring sync.'
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
- radicle
- secrets
- setup
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
- decisions/architecture/ops/mirror-to-7-popular-alternatives-2026-06-28
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
- services/hosting/radicle-mirror
---



# Mirror all hosts setup — one-time

Complete setup guide for the 7-host automatic git mirror strategy. Run this
once per org (or after a full token rotation). Recurring mirror runs via
`mirror-all.yml` cron automatically — no further manual steps.

## Prerequisites

- `gh` CLI authenticated as admin of `chirag127` org
- `doppler` CLI authenticated
- Browser access for token generation steps
- `jq` installed
- `rad` CLI (for Radicle keypair generation — installed via `curl -sSf https://radicle.xyz/install | sh`)

---

## Step 1: Generate 7 host credentials (browser + local — one-time per host)

### 1A. GitLab.com — Personal Access Token

1. Log in at <https://gitlab.com>
2. Go to: `https://gitlab.com/-/user_settings/personal_access_tokens`
3. Click **Add new token**
4. Name: `oriz-mirror-bot` | Expiration: 1 year | Scopes: ✅ `api` + ✅ `write_repository`
5. Copy token immediately
6. Save to Doppler:
   ```bash
   doppler secrets set MIRROR_GITLAB_TOKEN --config prd
   doppler secrets set MIRROR_GITLAB_USERNAME --config prd
   ```

### 1B. Codeberg.org — Access Token

1. Log in at <https://codeberg.org>
2. Go to: `https://codeberg.org/user/settings/applications`
3. Under "Manage Access Tokens" → **Generate Token**
4. Name: `oriz-mirror-bot` | Scope: ✅ `write:repository`
5. Copy token immediately
6. Save to Doppler:
   ```bash
   doppler secrets set MIRROR_CODEBERG_TOKEN --config prd
   doppler secrets set MIRROR_CODEBERG_USERNAME --config prd
   ```

### 1C. Bitbucket Cloud — Workspace Access Token (NOT App Password)

⚠️ App Passwords are permanently retired (June-July 2026). Use API Tokens.

1. Log in at <https://bitbucket.org>
2. Go to: `https://bitbucket.org/account/settings/access-tokens/`
   (Or: Workspace → Settings → Security → Access tokens)
3. Click **Create access token**
4. Name: `oriz-mirror-bot` | Permissions: ✅ Repositories: **Write** + ✅ Projects: **Read**
5. Expiration: 1 year
6. Copy token immediately
7. Save to Doppler:
   ```bash
   doppler secrets set MIRROR_BITBUCKET_API_TOKEN --config prd
   doppler secrets set MIRROR_BITBUCKET_USERNAME --config prd
   ```

### 1D. GitFlic.ru — Personal Token

1. Log in at <https://gitflic.ru>
2. Go to: `https://gitflic.ru/user/settings/tokens`
3. Click **Create token** | Name: `oriz-mirror-bot` | Scope: `repo:write`
4. Copy token immediately
5. Save to Doppler:
   ```bash
   doppler secrets set MIRROR_GITFLIC_TOKEN --config prd
   ```

### 1E. Azure DevOps — Personal Access Token (org-scoped)

⚠️ Use org-scoped PAT, NOT "All accessible organizations" (global PATs retire Dec 1 2026).

1. Log in at <https://dev.azure.com>
2. Create/ensure organization exists (e.g. `chirag127`)
3. Create a project inside it (e.g. `mirrors`)
4. Go to: `https://dev.azure.com/{org}/_usersSettings/tokens`
5. Click **+ New Token**
6. Name: `oriz-mirror-bot` | Org: select your specific org | Expiry: 1 year
7. Scope: **Code → Manage** (tick this custom scope)
8. Copy token immediately
9. Save to Doppler:
   ```bash
   doppler secrets set MIRROR_AZURE_DEVOPS_TOKEN --config prd
   doppler secrets set MIRROR_AZURE_DEVOPS_ORG --config prd      # e.g. chirag127
   doppler secrets set MIRROR_AZURE_DEVOPS_PROJECT --config prd  # e.g. mirrors
   ```

### 1F. NotABug.org — Access Token

1. Log in at <https://notabug.org> (Gogs-based, registration via email)
2. Go to: `https://notabug.org/user/settings/applications`
3. Under "Manage Access Tokens" → **Generate New Token**
4. Name: `oriz-mirror-bot`
5. Copy token immediately (Gogs shows it once)
6. Save to Doppler:
   ```bash
   doppler secrets set MIRROR_NOTABUG_TOKEN --config prd
   doppler secrets set MIRROR_NOTABUG_USERNAME --config prd
   ```

⚠️ NotABug intermittently shows "ERROR! :(" pages. The workflow uses
`continue-on-error: true` for this host so transient outages don't fail
the cron.

### 1G. Radicle — Identity bootstrap (one-time, local machine)

Radicle is P2P. The runner needs a Radicle keypair (`~/.radicle/keys/`)
and a passphrase. Generate them once on your local machine and ship them
to org secrets:

1. Install the CLI locally:
   ```bash
   curl -sSf https://radicle.xyz/install | sh
   ```
2. Create a fresh identity:
   ```bash
   rad auth   # prompts for an alias and a passphrase — pick a strong one
   ```
   This creates `~/.radicle/keys/radicle` and `radicle.pub`.
3. Tar + base64-encode and save to Doppler:
   ```bash
   tar czf - -C ~/.radicle keys | base64 -w0 \
     | doppler secrets set MIRROR_RADICLE_KEYPAIR_TAR_B64 --config prd
   doppler secrets set MIRROR_RADICLE_PASSPHRASE --config prd  # paste the passphrase
   ```
4. Public seed node `radicle.garden` is used (free, public). No
   self-hosted Radicle node needed.

---

## Step 2: Store all tokens at chirag127 GitHub org level

Per [`rules/security/github-org-level-secrets.md`](../../rules/security/github-org-level-secrets.md),
ALL secrets live at org level. Run this script:

```bash
#!/bin/bash
# Run from c:/D/oriz after doppler is authenticated

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
  MIRROR_RADICLE_KEYPAIR_TAR_B64
  MIRROR_RADICLE_PASSPHRASE
)

for NAME in "${SECRETS[@]}"; do
  VALUE="$(doppler secrets get "$NAME" --plain --config prd)"
  printf '%s' "$VALUE" | gh secret set "$NAME" --org chirag127 --visibility all
  echo "✓ Set $NAME"
done

echo ""
echo "Verify:"
gh secret list --org chirag127 | grep -E '^MIRROR_'
```

---

## Step 3: Pre-create mirror repos on each host

This script reads `repos/own/*` submodules from `.gitmodules` and creates
empty target repos on each of the 6 HTTPS hosts (Radicle creates repos
on first `rad init`, no pre-creation step needed). Idempotent — 409/4xx
errors on existing repos are ignored.

```bash
#!/bin/bash
# pre-create-mirror-repos.sh
# Run from c:/D/oriz — requires curl, jq, doppler

set -e

# Load secrets from Doppler
GITLAB_TOKEN=$(doppler secrets get MIRROR_GITLAB_TOKEN --plain --config prd)
GITLAB_USER=$(doppler secrets get MIRROR_GITLAB_USERNAME --plain --config prd)
CODEBERG_TOKEN=$(doppler secrets get MIRROR_CODEBERG_TOKEN --plain --config prd)
CODEBERG_USER=$(doppler secrets get MIRROR_CODEBERG_USERNAME --plain --config prd)
BB_TOKEN=$(doppler secrets get MIRROR_BITBUCKET_API_TOKEN --plain --config prd)
BB_USER=$(doppler secrets get MIRROR_BITBUCKET_USERNAME --plain --config prd)
GITFLIC_TOKEN=$(doppler secrets get MIRROR_GITFLIC_TOKEN --plain --config prd)
GITFLIC_USER=$(doppler secrets get MIRROR_GITFLIC_USERNAME --plain --config prd)
ADO_TOKEN=$(doppler secrets get MIRROR_AZURE_DEVOPS_TOKEN --plain --config prd)
ADO_ORG=$(doppler secrets get MIRROR_AZURE_DEVOPS_ORG --plain --config prd)
ADO_PROJECT=$(doppler secrets get MIRROR_AZURE_DEVOPS_PROJECT --plain --config prd)
NOTABUG_TOKEN=$(doppler secrets get MIRROR_NOTABUG_TOKEN --plain --config prd)
NOTABUG_USER=$(doppler secrets get MIRROR_NOTABUG_USERNAME --plain --config prd)

# Collect repos/own/* submodule names from .gitmodules
echo "Collecting repos/own/* submodules..."
REPOS_JSON=$(awk '
  /^\[submodule/ { path="" }
  /^[[:space:]]*path[[:space:]]*=/ { sub(/^[^=]*=[[:space:]]*/, ""); path=$0
    if (path ~ /^repos\/own\//) { n=split(path, p, "/"); print p[n] }
  }
' .gitmodules)

echo "$REPOS_JSON" | while read -r REPO_NAME; do
  [ -z "$REPO_NAME" ] && continue
  echo "--- Creating mirrors for: $REPO_NAME ---"

  # GitLab
  curl -s -o /dev/null -X POST "https://gitlab.com/api/v4/projects" \
    -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"${REPO_NAME}\",\"visibility\":\"public\"}" || true
  sleep 0.3

  # Codeberg (user namespace)
  curl -s -o /dev/null -X POST "https://codeberg.org/api/v1/user/repos" \
    -H "Authorization: token ${CODEBERG_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"${REPO_NAME}\",\"private\":false,\"auto_init\":false}" || true
  sleep 0.3

  # Bitbucket
  curl -s -o /dev/null -X POST \
    -H "Authorization: Bearer ${BB_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"scm\":\"git\",\"is_private\":false}" \
    "https://api.bitbucket.org/2.0/repositories/${BB_USER}/${REPO_NAME}" || true
  sleep 0.3

  # GitFlic
  curl -s -o /dev/null -X POST "https://api.gitflic.ru/project" \
    -H "Authorization: token ${GITFLIC_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"title\":\"${REPO_NAME}\",\"alias\":\"${REPO_NAME}\",\"private\":false}" || true
  sleep 0.3

  # Azure DevOps — need project ID first (cache it)
  if [ -z "$ADO_PROJECT_ID" ]; then
    ADO_PROJECT_ID=$(curl -s -u ":${ADO_TOKEN}" \
      "https://dev.azure.com/${ADO_ORG}/_apis/projects/${ADO_PROJECT}?api-version=7.1" \
      | jq -r '.id')
    echo "Azure DevOps project ID: $ADO_PROJECT_ID"
  fi
  curl -s -o /dev/null -X POST -u ":${ADO_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"${REPO_NAME}\",\"project\":{\"id\":\"${ADO_PROJECT_ID}\"}}" \
    "https://dev.azure.com/${ADO_ORG}/${ADO_PROJECT}/_apis/git/repositories?api-version=7.1" || true
  sleep 0.3

  # NotABug (Gogs API)
  curl -s -o /dev/null -X POST "https://notabug.org/api/v1/user/repos" \
    -H "Authorization: token ${NOTABUG_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"${REPO_NAME}\",\"private\":false,\"auto_init\":false}" || true
  sleep 0.3

  echo "✓ $REPO_NAME pre-created on all 6 HTTPS hosts (Radicle created on first sync)"
done

echo ""
echo "Pre-creation complete. Run a dry-run next (Step 4)."
```

---

## Step 4: Dry-run the mirror workflow

```bash
# Trigger workflow with dry-run mode (add --dry-run flag in push step temporarily)
gh workflow run mirror-all.yml --repo chirag127/oriz
gh run watch --repo chirag127/oriz
```

Check logs: every host should show ✓ per repo. Any ✗ indicates missing
repo or wrong token — fix before re-enabling the full cron.

## Step 5: Force a real first run

```bash
gh workflow run mirror-all.yml --repo chirag127/oriz
```

After completion, spot-check each host's web UI for the workspace repo's
commit history — should match GitHub HEAD.

---

## Adding a new repo (recurring task)

When a new submodule or standalone repo is added:

1. Run Step 3's repo-creation script (idempotent — safe to re-run fully)
2. The next Friday cron will include the new repo automatically

---

## Token rotation

When a token expires or is compromised:
1. Regenerate on the host's dashboard (see Step 1 for each host)
2. Update in Doppler: `doppler secrets set <NAME> --config prd`
3. Re-run Step 2's `gh secret set` loop
4. Per [`runbooks/security/rotate-leaked-secret.md`](../security/rotate-leaked-secret.md)

---

## See also

- Mirror decision → [`../../decisions/architecture/ops/mirror-to-7-popular-alternatives-2026-06-28.md`](../../decisions/architecture/ops/mirror-to-7-popular-alternatives-2026-06-28.md)
- Org secrets rule → [`../rules/security/github-org-level-secrets.md`](../../rules/security/github-org-level-secrets.md)
- Set org secrets → [`./set-github-org-level-secrets.md`](../security/set-github-org-level-secrets.md)
- Rotate leaked secret → [`./rotate-leaked-secret.md`](../security/rotate-leaked-secret.md)
- Service files per host → [`../../services/hosting/`](../../services/hosting)
- Workflow file → `.github/workflows/mirror-all.yml`
