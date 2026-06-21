#!/usr/bin/env bash
# bulk-enable-security.sh — turn on GitHub-native security features
# (secret scanning, push protection, vuln alerts, automated security fixes)
# for every chirag127/oriz* repo.
# ponytail: idempotent — all PUT/PATCH endpoints return 204 if already on.

set -euo pipefail

REPOS=$(gh repo list chirag127 --limit 200 --json name --jq '.[].name' | grep -E '(astro|auth)-.*-npm-pkg$|.*-app$')

count=0
for repo in $REPOS; do
  count=$((count+1))
  echo "=== [$count] $repo ==="

  gh api -X PUT "repos/chirag127/$repo/vulnerability-alerts" >/dev/null 2>&1 && echo "  ✓ vuln alerts"
  gh api -X PUT "repos/chirag127/$repo/automated-security-fixes" >/dev/null 2>&1 && echo "  ✓ auto-security-fixes"
  gh api -X PATCH "repos/chirag127/$repo" \
    -F 'security_and_analysis[secret_scanning][status]=enabled' \
    -F 'security_and_analysis[secret_scanning_push_protection][status]=enabled' \
    >/dev/null 2>&1 && echo "  ✓ secret scanning + push protection"
done

echo ""
echo "DONE. Processed $count repos."
