---
type: runbook
title: "Codeberg as 2nd git remote \u2014 DR mirror for the family"
description: "Codeberg as DR mirror via nightly GH Actions"
tags:
- runbook
- codeberg
- git
- mirror
- backup
- dr
- free-tier
timestamp: 2026-06-23
format_version: okf-v0.1
status: pending-manual-action
related:
- rules/infrastructure/free-tier-with-cost-controls
- runbooks/security/feature-flags-storage-2026-06-23
---



# Codeberg as 2nd git remote — DR mirror

## Why

Single point of failure on GitHub. If `chirag127` org gets locked (mass-PR spam, automated false-positive, ToS misread, you-name-it), CF Pages builds break because GitHub is the source. 60+ submodules become inaccessible.

Mitigation: nightly mirror to https://codeberg.org/chirag127. Free, no payment, no card. Codeberg is a non-profit Gitea instance maintained by community.

## Setup (one-time, manual — 15 min)

1. Create Codeberg account at https://codeberg.org/user/sign_up (email + password; no card).
2. Create organization `chirag127` at https://codeberg.org/org/create (free for FOSS).
3. Generate access token at https://codeberg.org/user/settings/applications:
   - Name: `oriz-mirror-bot`
   - Scopes: `write:repository`, `write:organization`
   - Copy the token — save to `.env` as `CODEBERG_TOKEN=...`

4. Add token to GitHub org secrets:
   ```bash
   GH=$(grep "^GH_ADMIN_PAT=" /c/D/oriz/.env | cut -d= -f2)
   CODEBERG=$(grep "^CODEBERG_TOKEN=" /c/D/oriz/.env | cut -d= -f2)
   # Use gh CLI:
   gh secret set CODEBERG_TOKEN --org chirag127 --body "$CODEBERG"
   ```

## Recurring (automated, nightly cron via GH Action)

Add `.github/workflows/codeberg-mirror.yml` to the meta-repo (this file goes to `c:/D/oriz/`):

```yaml
name: Mirror to Codeberg
on:
  schedule:
    - cron: '0 3 * * *'  # 03:00 UTC daily (08:30 IST)
  workflow_dispatch:

jobs:
  mirror:
    runs-on: ubuntu-latest
    steps:
      - name: Mirror all org repos
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          CODEBERG_TOKEN: ${{ secrets.CODEBERG_TOKEN }}
        run: |
          # List all repos under chirag127
          gh api -X GET orgs/chirag127/repos --paginate -q '.[].name' > repos.txt
          while read repo; do
            echo "--- mirroring $repo ---"
            git clone --mirror "https://x-access-token:${GH_TOKEN}@github.com/chirag127/${repo}.git" /tmp/${repo}
            # Create on Codeberg if missing (idempotent)
            curl -s -X POST -H "Authorization: token ${CODEBERG_TOKEN}" \
              -H "Content-Type: application/json" \
              "https://codeberg.org/api/v1/orgs/chirag127/repos" \
              -d "{\"name\":\"${repo}\",\"private\":false,\"auto_init\":false}" || true
            cd /tmp/${repo}
            git push --mirror "https://chirag127:${CODEBERG_TOKEN}@codeberg.org/chirag127/${repo}.git" || echo "FAILED ${repo}"
            cd -
            rm -rf /tmp/${repo}
          done < repos.txt
```

## Recovery RPO/RTO

- **RPO** (data loss tolerance): 24h. Worst case loses one day's commits.
- **RTO** (time to restore): ~30 min if GitHub is gone for good. Clone from Codeberg, change CF Pages source to point at Codeberg via Git connector (CF supports custom Git URLs).

## Cost ceiling

Codeberg has a soft 1 GiB/repo guideline. Our biggest repos (workspace.git + book builds) are <100 MB. 30x headroom. If we ever exceed, Codeberg requests deletion of large binary blobs — not an issue for our text-heavy repos.

## Cross-refs

- Free-tier rule → [[rules/free-tier-with-cost-controls]] (Codeberg is non-profit + truly free, fits)
- DR backup pattern from flags → [[runbooks/feature-flags-storage-2026-06-23]] (same RPO/RTO discipline applied here)
