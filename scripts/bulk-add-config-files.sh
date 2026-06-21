#!/usr/bin/env bash
# bulk-add-config-files.sh — for every chirag127/oriz* repo (39 of them),
# add standard config files for: Renovate, DeepSource, Mergify, SonarCloud.
# All free-tier services that don't check license.
# ponytail: one loop, idempotent — gh api refuses to overwrite existing files.

set -euo pipefail

REPOS=$(gh repo list chirag127 --limit 200 --json name --jq '.[].name' | grep -E '(astro|auth)-.*-npm-pkg$|.*-app$')

count=0
for repo in $REPOS; do
  count=$((count+1))
  echo "=== [$count] $repo ==="

  # 1. renovate.json
  renovate_b64=$(printf '{\n  "$schema": "https://docs.renovatebot.com/renovate-schema.json",\n  "extends": ["config:recommended"],\n  "labels": ["deps"],\n  "schedule": ["before 4am on monday"]\n}\n' | base64 -w0)
  gh api -X PUT "repos/chirag127/$repo/contents/renovate.json" \
    -f message="chore: add renovate config" \
    -f content="$renovate_b64" \
    >/dev/null 2>&1 && echo "  ✓ renovate.json" || echo "  - renovate.json exists"

  # 2. .deepsource.toml
  deepsource_b64=$(printf 'version = 1\n\n[[analyzers]]\nname = "javascript"\n\n[analyzers.meta]\nplugins = ["react"]\nenvironment = ["nodejs", "browser"]\n\n[[analyzers]]\nname = "test-coverage"\n' | base64 -w0)
  gh api -X PUT "repos/chirag127/$repo/contents/.deepsource.toml" \
    -f message="chore: add deepsource config" \
    -f content="$deepsource_b64" \
    >/dev/null 2>&1 && echo "  ✓ .deepsource.toml" || echo "  - .deepsource.toml exists"

  # 3. .mergify.yml
  mergify_b64=$(printf 'queue_rules:\n  - name: default\n    queue_conditions:\n      - check-success=check\n    merge_conditions:\n      - check-success=check\n    merge_method: squash\n\npull_request_rules:\n  - name: automatic merge on approval\n    conditions:\n      - "#approved-reviews-by>=1"\n      - check-success=check\n      - -draft\n    actions:\n      queue: {}\n  - name: automatic merge for dependabot/renovate\n    conditions:\n      - or:\n        - author=dependabot[bot]\n        - author=renovate[bot]\n      - check-success=check\n    actions:\n      queue: {}\n' | base64 -w0)
  gh api -X PUT "repos/chirag127/$repo/contents/.mergify.yml" \
    -f message="chore: add mergify config" \
    -f content="$mergify_b64" \
    >/dev/null 2>&1 && echo "  ✓ .mergify.yml" || echo "  - .mergify.yml exists"

  # 4. sonar-project.properties
  sonar_b64=$(printf 'sonar.projectKey=chirag127_%s\nsonar.organization=chirag127\nsonar.sources=src\nsonar.exclusions=**/*.test.ts,**/*.test.tsx,**/__tests__/**,**/node_modules/**,**/dist/**\nsonar.javascript.lcov.reportPaths=coverage/lcov.info\n' "$repo" | base64 -w0)
  gh api -X PUT "repos/chirag127/$repo/contents/sonar-project.properties" \
    -f message="chore: add sonarcloud config" \
    -f content="$sonar_b64" \
    >/dev/null 2>&1 && echo "  ✓ sonar-project.properties" || echo "  - sonar-project.properties exists"

  # 5. .github/FUNDING.yml
  funding_b64=$(printf 'github: chirag127\nko_fi: chirag127\nliberapay: chirag127\nthanks_dev: gh/chirag127\ncustom:\n  - https://paypal.me/chirag127\n' | base64 -w0)
  gh api -X PUT "repos/chirag127/$repo/contents/.github/FUNDING.yml" \
    -f message="chore: add FUNDING.yml" \
    -f content="$funding_b64" \
    >/dev/null 2>&1 && echo "  ✓ .github/FUNDING.yml" || echo "  - .github/FUNDING.yml exists"

  # 6. .github/workflows/scorecard.yml
  scorecard_b64=$(printf 'name: Scorecard\non:\n  branch_protection_rule:\n  schedule:\n    - cron: "0 0 * * 1"\n  push:\n    branches: [main]\npermissions: read-all\njobs:\n  analysis:\n    runs-on: ubuntu-latest\n    permissions:\n      security-events: write\n      id-token: write\n    steps:\n      - uses: actions/checkout@v4\n        with:\n          persist-credentials: false\n      - uses: ossf/scorecard-action@v2\n        with:\n          results_file: results.sarif\n          results_format: sarif\n          publish_results: true\n      - uses: actions/upload-artifact@v4\n        with:\n          name: SARIF\n          path: results.sarif\n          retention-days: 5\n      - uses: github/codeql-action/upload-sarif@v3\n        with:\n          sarif_file: results.sarif\n' | base64 -w0)
  gh api -X PUT "repos/chirag127/$repo/contents/.github/workflows/scorecard.yml" \
    -f message="chore: add OSSF Scorecard workflow" \
    -f content="$scorecard_b64" \
    >/dev/null 2>&1 && echo "  ✓ scorecard.yml" || echo "  - scorecard.yml exists"
done

echo ""
echo "DONE. Processed $count repos."
