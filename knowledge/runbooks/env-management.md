---
type: runbook
title: "Env management — sops + age + GitHub Org Secrets"
description: "Plain-English runbook for managing the single env source `c:/D/oriz/.env`. Covers: install sops + age, generate keys, encrypt + commit `.env.enc`, decrypt locally, rotate a secret, add a new secret, recover if you lose the age key, restore from password manager backup. Read this when you need to change ANY env var anywhere in the oriz family. Single source: master `c:/D/oriz/.env` → encrypted to `.env.enc` → daily cron pushes values to chirag127 GH org secrets → every repo's CI/builds consume from org secrets automatically. Zero per-repo manual setup."
tags: [runbook, env, secrets, sops, age, rotation, recovery, single-source]
timestamp: 2026-06-22
format_version: okf-v0.1
status: active
related:
  - decisions/security/env-single-source-auto-push
  - decisions/security/env-and-secrets-single-source
  - rules/github-org-level-secrets
  - rules/no-card-on-file
---

# Env management runbook

## What this is

Master `c:/D/oriz/.env` is the **single source of truth** for every env var anywhere in the chirag127/oriz family (51+ repos). You edit ONE file. A scheduled GH Action pushes those values to chirag127 GitHub Org Secrets with `--visibility all`, so every workflow + build in every repo sees them automatically.

You set 2 bootstrap secrets ONCE. Everything else flows from `.env`.

## Why sops + age (not Doppler / Vault / KMS)

- **sops + age** = no service, no card, single bootstrap key, GitHub-Actions integration, diff-readable `.env.enc`. Best free no-card option.
- **Doppler** = free 5 users but 3rd-party trust + outage risk; deferred.
- **HashiCorp Vault** = heavy self-host; violates `no-self-hosting-outside-cf`.
- **AWS KMS / GCP KMS** = requires AWS/GCP account with card; violates `no-card-on-file`.

If a better no-card option emerges, this runbook is the file to update first.

## Files in this system

| Path | Tracked? | Purpose |
|---|---|---|
| `c:/D/oriz/.env` | gitignored | PLAINTEXT — your working copy. Edit here. |
| `c:/D/oriz/.env.enc` | committed | ENCRYPTED — committed to master. Decrypted by sops with age key. |
| `c:/D/oriz/.sops.yaml` | committed | sops config — names the age recipient public key. |
| `c:/D/oriz/.sops-age-key.txt` | gitignored | age PRIVATE key. NEVER commit. Backup elsewhere. |
| `c:/D/oriz/templates/.env.example` | committed | Canonical key names + comments. NEVER any values. |
| `c:/D/oriz/scripts/sync-env-to-org-secrets.mjs` | committed | The sync script. |
| `c:/D/oriz/.github/workflows/sync-env-to-org-secrets.yml` | committed | The cron workflow. |

## The 2 bootstrap secrets (you set these ONCE, manually)

1. **`SOPS_AGE_KEY`** — the age private key contents. Set on chirag127 org secret with `--visibility all`. Lets the sync workflow decrypt `.env.enc`.
2. **`GH_ADMIN_PAT`** — a GitHub PAT with `admin:org` scope, ~1-year expiry. Set on master repo only (`chirag127/workspace`). Lets the workflow call `gh secret set --org`.

Everything else (NPM_TOKEN, CLOUDFLARE_API_TOKEN, RAZORPAY_KEY_ID, Firebase keys, all ~50 other secrets) lives in `.env`. The sync pushes them all from there.

## Initial setup (one-time, ~10 min)

### 1. Install sops + age

```bash
# Windows (preferred):
winget install --id=getsops.sops -e
winget install --id=FiloSottile.age -e

# OR via Scoop:
scoop install sops age

# OR portable binaries:
# sops: https://github.com/getsops/sops/releases
# age: https://github.com/FiloSottile/age/releases
```

Verify: `sops --version` and `age --version` both work.

### 2. Generate age key

```bash
cd c:/D/oriz
age-keygen -o .sops-age-key.txt
# Outputs the PUBLIC key (line starting with `# public key: age1...`)
```

Already done; verify with `head .sops-age-key.txt`.

### 3. Back up the age key

**CRITICAL:** lose this file = lose access to all secrets.

Store in 3 places:
- Dev machine at `c:/D/oriz/.sops-age-key.txt` (gitignored) — primary
- **Bitwarden** (free, no card) — open Bitwarden → add Secure Note titled "oriz sops age key" → paste contents
- chirag127 GitHub Org Secrets as `SOPS_AGE_KEY` (this also serves the GH Action AND acts as backup #3)

If you lose 2 of 3, recover from the surviving copy.

### 4. Configure sops

`c:/D/oriz/.sops.yaml` (committed):

```yaml
creation_rules:
  - path_regex: \.env(\.enc)?$
    age: age1c40qjamejzrp9cajle9g0dss25mmsmyaq6uaa2pgmyr3pflsy4qspgw5c4
```

Replace the `age1...` line with YOUR public key from step 2 if regenerating.

### 5. First-time encrypt

```bash
cd c:/D/oriz
sops --encrypt --input-type dotenv --output-type dotenv .env > .env.enc
git add .env.enc .sops.yaml
git commit -m "chore: bootstrap encrypted .env"
git push
```

### 6. Push the 2 bootstrap secrets

```bash
# Generate GH_ADMIN_PAT manually at https://github.com/settings/tokens
# Scopes needed: admin:org

# Push the age private key as org secret:
gh secret set SOPS_AGE_KEY --org chirag127 --visibility all \
  --body "$(cat c:/D/oriz/.sops-age-key.txt)"

# Push the PAT as a master-repo secret (NOT org-level — too sensitive):
gh secret set GH_ADMIN_PAT --repo chirag127/workspace \
  --body "ghp_YOUR_PAT_HERE"
```

### 7. First-run sync

Trigger the workflow:

```bash
gh workflow run sync-env-to-org-secrets.yml --repo chirag127/workspace
```

Watch:

```bash
gh run watch --repo chirag127/workspace
```

Expected: all ~50 keys in `.env` pushed to chirag127 org secrets. Verify:

```bash
gh secret list --org chirag127 | wc -l
```

## Daily operation

### Rotate a secret (e.g. Razorpay key compromised)

1. Open `c:/D/oriz/.env` in your editor.
2. Change the value, e.g. `RAZORPAY_KEY_SECRET=new_value`.
3. Re-encrypt:

   ```bash
   cd c:/D/oriz
   pnpm run env:encrypt
   # OR manually:
   # sops --encrypt --input-type dotenv --output-type dotenv .env > .env.enc
   ```

4. Commit + push:

   ```bash
   git add .env.enc
   git commit -m "chore(secrets): rotate RAZORPAY_KEY_SECRET"
   git push
   ```

5. Trigger sync immediately (or wait for daily cron at 06:30 IST):

   ```bash
   gh workflow run sync-env-to-org-secrets.yml --repo chirag127/workspace
   ```

6. Verify rotation propagated (~30 seconds after workflow finishes):

   ```bash
   gh secret list --org chirag127 | grep RAZORPAY_KEY_SECRET
   # check `Updated at` column
   ```

Every running deployment in every repo picks up the new value on its NEXT build/deploy.

### Add a new secret

1. Add the key name + comment to `c:/D/oriz/templates/.env.example` (canonical list).
2. Add `KEY=value` to `c:/D/oriz/.env`.
3. Re-encrypt (`pnpm run env:encrypt`).
4. Commit `.env.enc` + `.env.example`.
5. Sync workflow picks up on next cron or manual trigger.

### Decrypt locally to read a value

```bash
sops --decrypt .env.enc | grep RAZORPAY_KEY_ID
# OR open in editor (sops handles encrypt-on-save):
sops .env.enc
```

### Edit `.env.enc` directly via sops

```bash
sops .env.enc
# Opens your $EDITOR with decrypted contents.
# Save + exit → sops re-encrypts automatically.
# This skips the .env file entirely. Good for quick rotations from any machine
# (as long as you have the .sops-age-key.txt restored).
```

## Recovery scenarios

### Lost the age private key (.sops-age-key.txt deleted from machine)

1. Open Bitwarden → find the "oriz sops age key" secure note → copy contents.
2. Restore: `pbpaste > c:/D/oriz/.sops-age-key.txt` (or paste via editor).
3. Verify: `sops --decrypt c:/D/oriz/.env.enc | head` should print plaintext .env.

If Bitwarden ALSO lost (worst case):

1. Generate a fresh age key: `age-keygen -o .sops-age-key.txt`
2. You CAN'T decrypt the old `.env.enc` without the old key — you'll re-fill `.env` from scratch.
3. Re-fill `c:/D/oriz/.env` from your memory / vendor dashboards (rotate every secret while you're at it).
4. Update `.sops.yaml` with the new public key.
5. `sops --encrypt --input-type dotenv --output-type dotenv .env > .env.enc`
6. Commit; push new `SOPS_AGE_KEY` to org secrets (re-bootstrap).

### Lost the GH_ADMIN_PAT (expired or revoked)

1. Generate a fresh PAT at <https://github.com/settings/tokens> with `admin:org`.
2. `gh secret set GH_ADMIN_PAT --repo chirag127/workspace --body "ghp_NEW"`
3. Re-run the sync workflow.

### Forgot what's in .env

```bash
sops --decrypt c:/D/oriz/.env.enc
```

### Multiple recipients (advanced — not enabled by default)

If you want a "backup key" that can also decrypt (e.g. for a co-worker, or a second machine):

```yaml
# .sops.yaml
creation_rules:
  - path_regex: \.env(\.enc)?$
    age: >-
      age1xxx_primary_key,
      age1yyy_backup_key
```

Re-encrypt with `sops --encrypt --in-place .env.enc` to apply.

## Submodule .gitignore

Every submodule must ignore the same patterns to prevent accidental commits:

```
.env
.env.local
.env.*.local
.sops-age-key.txt
```

Master's `.gitignore` doesn't propagate into submodules. A sweep script ensures all 51 submodules have these patterns. See `scripts/sweep-gitignore.mjs`.

## Cron schedule

- **Daily 06:30 IST (01:00 UTC)** — `.github/workflows/sync-env-to-org-secrets.yml`
- On push to master when `.env.enc` or `templates/.env.example` or `scripts/sync-env-to-org-secrets.mjs` changes
- On manual `workflow_dispatch`

## Audit trail

Every commit to `.env.enc` is a secret-rotation event. `git log .env.enc` shows the rotation history. The actual values rotate; the encrypted blob's diff is opaque but timestamps + commit messages tell the story.

## Cross-refs

- The decision driving this → [[decisions/security/env-single-source-auto-push]]
- Two-track delivery context → [[decisions/security/env-and-secrets-single-source]]
- GH org-level secrets rule → [[rules/github-org-level-secrets]]
- No card on file → [[rules/no-card-on-file]]
- No self-hosting outside CF → [[rules/no-self-hosting-outside-cf]]
