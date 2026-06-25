# Knowledge restructure moves log — 2026-06-25

OKF restructure: drop redundant top-level dirs (`knowledge/architecture/`, `knowledge/policy/`, `knowledge/design/`), dedupe flat-vs-nested files in `rules/` and `runbooks/`.

Operations:
- `MV` = `git mv source target` (file moved, history preserved)
- `RM-DUP` = `git rm source` (duplicate-of-nested-canonical, removed)
- `SKIP-EXISTS` = source duplicates existing target; left in place

## Moves

| Op | Source | Target |
|---|---|---|
| RM-DUP | knowledge/rules/profile-readme-cross-link.md | (kept knowledge/rules/interaction/profile-readme-cross-link.md) |
| RM-DUP | knowledge/rules/future-overrides-past.md | (kept knowledge/rules/interaction/future-overrides-past.md) |
| RM-DUP | knowledge/rules/org-level-secrets-only-no-per-repo.md | (kept knowledge/rules/security/org-level-secrets-only-no-per-repo.md) |
| RM-DUP | knowledge/rules/conventional-commits.md | (kept knowledge/rules/development/conventional-commits.md) |
| RM-DUP | knowledge/rules/read-before-edit.md | (kept knowledge/rules/agent/read-before-edit.md) |
| RM-DUP | knowledge/rules/per-app-distinctive-frontend-design.md | (kept knowledge/rules/design/per-app-distinctive-frontend-design.md) |
| RM-DUP | knowledge/rules/push-by-default.md | (kept knowledge/rules/development/push-by-default.md) |
| RM-DUP | knowledge/rules/user-prefers-pure-tool-brand.md | (kept knowledge/rules/interaction/user-prefers-pure-tool-brand.md) |
| RM-DUP | knowledge/rules/tests-parallel-and-master-install.md | (kept knowledge/rules/development/tests-parallel-and-master-install.md) |
| RM-DUP | knowledge/rules/knowledge-first.md | (kept knowledge/rules/agent/knowledge-first.md) |
| RM-DUP | knowledge/rules/community-packages-first.md | (kept knowledge/rules/development/community-packages-first.md) |
| RM-DUP | knowledge/rules/one-level-subdomain-only.md | (kept knowledge/rules/infrastructure/one-level-subdomain-only.md) |
| RM-DUP | knowledge/rules/no-ad-slots-in-markup.md | (kept knowledge/rules/design/no-ad-slots-in-markup.md) |
| RM-DUP | knowledge/rules/grill-to-knowledge.md | (kept knowledge/rules/agent/grill-to-knowledge.md) |
| RM-DUP | knowledge/rules/cloudflare-pages-apps-only.md | (kept knowledge/rules/infrastructure/cloudflare-pages-apps-only.md) |
| RM-DUP | knowledge/rules/match-surrounding-style.md | (kept knowledge/rules/interaction/match-surrounding-style.md) |
| RM-DUP | knowledge/rules/parse-mcq-other-for-context.md | (kept knowledge/rules/interaction/parse-mcq-other-for-context.md) |
| RM-DUP | knowledge/rules/astro-version-pin.md | (kept knowledge/rules/development/astro-version-pin.md) |
| RM-DUP | knowledge/rules/grill-on-loc-removal.md | (kept knowledge/rules/agent/grill-on-loc-removal.md) |
| RM-DUP | knowledge/rules/submodule-env-files-three-file-pattern.md | (kept knowledge/rules/security/submodule-env-files-three-file-pattern.md) |
| RM-DUP | knowledge/rules/no-emoji-in-chrome.md | (kept knowledge/rules/design/no-emoji-in-chrome.md) |
| RM-DUP | knowledge/rules/use-pnpm.md | (kept knowledge/rules/development/use-pnpm.md) |
| RM-DUP | knowledge/rules/git-identity-chirag127-noreply.md | (kept knowledge/rules/development/git-identity-chirag127-noreply.md) |
| RM-DUP | knowledge/rules/communication-stt-friendly.md | (kept knowledge/rules/interaction/communication-stt-friendly.md) |
| RM-DUP | knowledge/rules/shared-tenant-by-default.md | (kept knowledge/rules/infrastructure/shared-tenant-by-default.md) |
| RM-DUP | knowledge/rules/frontend-design-skill-baked-in.md | (kept knowledge/rules/design/frontend-design-skill-baked-in.md) |
| RM-DUP | knowledge/rules/agents-md-2025-discipline.md | (kept knowledge/rules/agent/agents-md-2025-discipline.md) |
| RM-DUP | knowledge/rules/no-subscriptions.md | (kept knowledge/rules/infrastructure/no-subscriptions.md) |
| RM-DUP | knowledge/rules/user-prefers-same-name-repo-and-npm.md | (kept knowledge/rules/interaction/user-prefers-same-name-repo-and-npm.md) |
| RM-DUP | knowledge/rules/user-prefers-strict-no-toggle.md | (kept knowledge/rules/interaction/user-prefers-strict-no-toggle.md) |
| RM-DUP | knowledge/rules/fork-customization-minimum-conflict.md | (kept knowledge/rules/development/fork-customization-minimum-conflict.md) |
| RM-DUP | knowledge/rules/linux-ci-only.md | (kept knowledge/rules/interaction/linux-ci-only.md) |
| RM-DUP | knowledge/rules/repos-work-independently.md | (kept knowledge/rules/development/repos-work-independently.md) |
| RM-DUP | knowledge/rules/free-tier-with-cost-controls.md | (kept knowledge/rules/infrastructure/free-tier-with-cost-controls.md) |
| RM-DUP | knowledge/rules/cloudflare-pages-only.md | (kept knowledge/rules/infrastructure/cloudflare-pages-only.md) |
| RM-DUP | knowledge/rules/openai-compat-for-all-ai-providers.md | (kept knowledge/rules/interaction/openai-compat-for-all-ai-providers.md) |
| RM-DUP | knowledge/rules/telegram-channels-and-roles.md | (kept knowledge/rules/interaction/telegram-channels-and-roles.md) |
| RM-DUP | knowledge/rules/no-firebase-admin-in-workers.md | (kept knowledge/rules/infrastructure/no-firebase-admin-in-workers.md) |
| RM-DUP | knowledge/rules/user-prefers-wider-coverage.md | (kept knowledge/rules/interaction/user-prefers-wider-coverage.md) |
| RM-DUP | knowledge/rules/confirm-knowledge-deltas.md | (kept knowledge/rules/agent/confirm-knowledge-deltas.md) |
| RM-DUP | knowledge/rules/parallel-by-default.md | (kept knowledge/rules/interaction/parallel-by-default.md) |
| RM-DUP | knowledge/rules/user-prefers-deletion-over-archive.md | (kept knowledge/rules/interaction/user-prefers-deletion-over-archive.md) |
| RM-DUP | knowledge/rules/no-paid-self-hosting-only.md | (kept nested version) |
| RM-DUP | knowledge/rules/auto-only-tracking.md | (kept nested version) |
| RM-DUP | knowledge/rules/self-update-rule.md | (kept nested version) |
| RM-DUP | knowledge/rules/design-divergence-vs-dedup.md | (kept nested version) |
| RM-DUP | knowledge/rules/auto-grill-on-architectural-decisions.md | (kept nested version) |
| RM-DUP | knowledge/rules/recruiter-strategy.md | (kept nested version) |
| RM-DUP | knowledge/rules/keep-knowledge-fresh.md | (kept nested version) |
| RM-DUP | knowledge/rules/no-hardcoded-secrets.md | (kept nested version) |
| RM-DUP | knowledge/rules/fork-discipline.md | (kept nested version) |
| RM-DUP | knowledge/rules/parallel-fan-out-by-default.md | (kept nested version) |
| RM-DUP | knowledge/rules/env-example-synced-from-master.md | (kept nested version) |
| RM-DUP | knowledge/rules/always-latest-deps.md | (kept nested version) |
| RM-DUP | knowledge/rules/no-web3forms-server-side.md | (kept nested version) |
| RM-DUP | knowledge/rules/no-firebase-functions-blaze.md | (kept nested version) |
| RM-DUP | knowledge/rules/github-org-level-secrets.md | (kept nested version) |
| RM-DUP | knowledge/rules/user-prefers-atomic-split.md | (kept nested version) |
| RM-DUP | knowledge/rules/repo-naming.md | (kept nested version) |
| RM-DUP | knowledge/rules/never-delete-empty-placeholder-repos.md | (kept nested version) |
| RM-DUP | knowledge/rules/one-branch-only.md | (kept nested version) |
| RM-DUP | knowledge/rules/no-force-push-to-main.md | (kept nested version) |
| RM-DUP | knowledge/rules/never-hit-quotas.md | (kept nested version) |
| RM-DUP | knowledge/rules/agent-minimum-context.md | (kept nested version) |
| RM-DUP | knowledge/rules/aws-lambda-exception.md | (kept nested version) |
| RM-DUP | knowledge/runbooks/git-upstream-merge-private-fork.md | (kept knowledge/runbooks/hosting/git-upstream-merge-private-fork.md) |
| RM-DUP | knowledge/runbooks/cf-dns-add-api-subdomain.md | (kept knowledge/runbooks/hosting/cf-dns-add-api-subdomain.md) |
| RM-DUP | knowledge/runbooks/build-distributable.md | (kept knowledge/runbooks/operations/build-distributable.md) |
| RM-DUP | knowledge/runbooks/visual-audit-2026-06-22.md | (kept knowledge/runbooks/operations/visual-audit-2026-06-22.md) |
| RM-DUP | knowledge/runbooks/scaffold-a-new-site.md | (kept knowledge/runbooks/operations/scaffold-a-new-site.md) |
| RM-DUP | knowledge/runbooks/cf-dns-audit-2026-06-23.md | (kept knowledge/runbooks/hosting/cf-dns-audit-2026-06-23.md) |
| RM-DUP | knowledge/runbooks/backup-metadata-to-b2.md | (kept knowledge/runbooks/security/backup-metadata-to-b2.md) |
| RM-DUP | knowledge/runbooks/clean-install.md | (kept knowledge/runbooks/operations/clean-install.md) |
| RM-DUP | knowledge/runbooks/github-apps-audit-2026-06-22.md | (kept knowledge/runbooks/operations/github-apps-audit-2026-06-22.md) |
| RM-DUP | knowledge/runbooks/add-new-extension.md | (kept knowledge/runbooks/operations/add-new-extension.md) |
| RM-DUP | knowledge/runbooks/install-and-bootstrap.md | (kept knowledge/runbooks/operations/install-and-bootstrap.md) |
| RM-DUP | knowledge/runbooks/sync-env-example-to-all-repos.md | (kept knowledge/runbooks/operations/sync-env-example-to-all-repos.md) |
| RM-DUP | knowledge/runbooks/install-github-apps.md | (kept knowledge/runbooks/operations/install-github-apps.md) |
| RM-DUP | knowledge/runbooks/add-new-decision.md | (kept knowledge/runbooks/operations/add-new-decision.md) |
| RM-DUP | knowledge/runbooks/razorpay-end-to-end-setup.md | (kept knowledge/runbooks/security/razorpay-end-to-end-setup.md) |
| RM-DUP | knowledge/runbooks/auth-setup.md | (kept knowledge/runbooks/security/auth-setup.md) |
| RM-DUP | knowledge/runbooks/rename-repo.md | (kept knowledge/runbooks/operations/rename-repo.md) |
| RM-DUP | knowledge/runbooks/migrate-ci-platform.md | (kept knowledge/runbooks/operations/migrate-ci-platform.md) |
| RM-DUP | knowledge/runbooks/codeberg-mirror-2026-06-23.md | (kept knowledge/runbooks/hosting/codeberg-mirror-2026-06-23.md) |
| RM-DUP | knowledge/runbooks/cf-pages-branch-deploys.md | (kept knowledge/runbooks/hosting/cf-pages-branch-deploys.md) |
| RM-DUP | knowledge/runbooks/add-package-to-catalog.md | (kept knowledge/runbooks/operations/add-package-to-catalog.md) |
| RM-DUP | knowledge/runbooks/razorpay-paddle-subscriptions-setup.md | (kept knowledge/runbooks/security/razorpay-paddle-subscriptions-setup.md) |
| RM-DUP | knowledge/runbooks/bump-submodule-pointer.md | (kept knowledge/runbooks/operations/bump-submodule-pointer.md) |
| RM-DUP | knowledge/runbooks/set-github-org-level-secrets.md | (kept knowledge/runbooks/security/set-github-org-level-secrets.md) |
| RM-DUP | knowledge/runbooks/rotate-leaked-secret.md | (kept knowledge/runbooks/security/rotate-leaked-secret.md) |
| RM-DUP | knowledge/runbooks/dependabot-notification-tuning.md | (kept knowledge/runbooks/operations/dependabot-notification-tuning.md) |
| RM-DUP | knowledge/runbooks/restic-backup-setup.md | (kept knowledge/runbooks/security/restic-backup-setup.md) |
| RM-DUP | knowledge/runbooks/migrate-okf-to-new-version.md | (kept knowledge/runbooks/operations/migrate-okf-to-new-version.md) |
| RM-DUP | knowledge/runbooks/npm-publish-token-setup.md | (kept knowledge/runbooks/security/npm-publish-token-setup.md) |
| RM-DUP | knowledge/runbooks/lifestream-auto-sources-setup.md | (kept knowledge/runbooks/operations/lifestream-auto-sources-setup.md) |
| RM-DUP | knowledge/runbooks/add-new-site-to-family.md | (kept knowledge/runbooks/operations/add-new-site-to-family.md) |
| RM-DUP | knowledge/runbooks/apply-per-site-ci.md | (kept knowledge/runbooks/operations/apply-per-site-ci.md) |
| RM-DUP | knowledge/runbooks/env-management.md | (kept knowledge/runbooks/operations/env-management.md) |
| MV | knowledge/runbooks/mirror-cron-prep.md | knowledge/runbooks/hosting/mirror-cron-prep.md |
| MV | knowledge/runbooks/publish-userscript-to-greasyfork.md | knowledge/runbooks/operations/publish-userscript-to-greasyfork.md |
| MV | knowledge/runbooks/publish-vscode-extension-to-marketplace.md | knowledge/runbooks/operations/publish-vscode-extension-to-marketplace.md |
| MV | knowledge/architecture/compute/api-routes-structure.md | knowledge/decisions/architecture/compute/api-routes-structure.md |
| MV | knowledge/architecture/compute/api-umbrella-hono-worker.md | knowledge/decisions/architecture/compute/api-umbrella-hono-worker.md |
| MV | knowledge/architecture/compute/hono-rpc-type-sharing.md | knowledge/decisions/architecture/compute/hono-rpc-type-sharing.md |
| RM-DUP | knowledge/architecture/compute/index.md | (kept knowledge/decisions/architecture/compute/index.md) |
| MV | knowledge/architecture/compute/service-bindings-future.md | knowledge/decisions/architecture/compute/service-bindings-future.md |
| MV | knowledge/architecture/database/canonical-store-jsonl.md | knowledge/decisions/architecture/database/canonical-store-jsonl.md |
| MV | knowledge/architecture/database/cloud-dbs-as-caches.md | knowledge/decisions/architecture/database/cloud-dbs-as-caches.md |
| MV | knowledge/architecture/database/events-table-schema.md | knowledge/decisions/architecture/database/events-table-schema.md |
| RM-DUP | knowledge/architecture/database/index.md | (kept knowledge/decisions/architecture/database/index.md) |
| RM-DUP | knowledge/architecture/frontend/index.md | (kept knowledge/decisions/architecture/frontend/index.md) |
| MV | knowledge/architecture/frontend/layer-1-static-hosting.md | knowledge/decisions/architecture/frontend/layer-1-static-hosting.md |
| MV | knowledge/architecture/frontend/layer-2-survival-fallback.md | knowledge/decisions/architecture/frontend/layer-2-survival-fallback.md |
| MV | knowledge/architecture/general/agent-skills-monorepo.md | knowledge/decisions/architecture/general/agent-skills-monorepo.md |
| RM-DUP | knowledge/architecture/general/index.md | (kept knowledge/decisions/architecture/general/index.md) |
| MV | knowledge/architecture/general/layer-4-database-by-shape.md | knowledge/decisions/architecture/general/layer-4-database-by-shape.md |
| MV | knowledge/architecture/general/layer-5-compute.md | knowledge/decisions/architecture/general/layer-5-compute.md |
| MV | knowledge/architecture/general/master-pointer-as-production-sha.md | knowledge/decisions/architecture/general/master-pointer-as-production-sha.md |
| MV | knowledge/architecture/ops/extension-distribution.md | knowledge/decisions/architecture/ops/extension-distribution.md |
| RM-DUP | knowledge/architecture/ops/index.md | (kept knowledge/decisions/architecture/ops/index.md) |
| MV | knowledge/architecture/ops/submodule-pattern.md | knowledge/decisions/architecture/ops/submodule-pattern.md |
| MV | knowledge/architecture/ops/subscription-flow.md | knowledge/decisions/architecture/ops/subscription-flow.md |
| RM-DUP | knowledge/architecture/packages/index.md | (kept knowledge/decisions/architecture/packages/index.md) |
| MV | knowledge/architecture/packages/the-six-packages.md | knowledge/decisions/architecture/packages/the-six-packages.md |
| MV | knowledge/architecture/security/cross-site-auth-via-auth-oriz-in.md | knowledge/decisions/architecture/security/cross-site-auth-via-auth-oriz-in.md |
| RM-DUP | knowledge/architecture/security/index.md | (kept knowledge/decisions/architecture/security/index.md) |
| MV | knowledge/architecture/security/layer-3-auth-firebase-spark.md | knowledge/decisions/architecture/security/layer-3-auth-firebase-spark.md |
| MV | knowledge/architecture/security/package-isolation-rule.md | knowledge/decisions/architecture/security/package-isolation-rule.md |
| MV | knowledge/architecture/stack/automation.md | knowledge/decisions/architecture/stack/automation.md |
| MV | knowledge/architecture/stack/cli-tools.md | knowledge/decisions/architecture/stack/cli-tools.md |
| MV | knowledge/architecture/stack/cpp.md | knowledge/decisions/architecture/stack/cpp.md |
| MV | knowledge/architecture/stack/csharp.md | knowledge/decisions/architecture/stack/csharp.md |
| MV | knowledge/architecture/stack/databases.md | knowledge/decisions/architecture/stack/databases.md |
| MV | knowledge/architecture/stack/extensions.md | knowledge/decisions/architecture/stack/extensions.md |
| MV | knowledge/architecture/stack/go.md | knowledge/decisions/architecture/stack/go.md |
| MV | knowledge/architecture/stack/hosting.md | knowledge/decisions/architecture/stack/hosting.md |
| RM-DUP | knowledge/architecture/stack/index.md | (kept knowledge/decisions/architecture/stack/index.md) |
| MV | knowledge/architecture/stack/java.md | knowledge/decisions/architecture/stack/java.md |
| MV | knowledge/architecture/stack/javascript-typescript.md | knowledge/decisions/architecture/stack/javascript-typescript.md |
| MV | knowledge/architecture/stack/python.md | knowledge/decisions/architecture/stack/python.md |
| MV | knowledge/architecture/stack/rust.md | knowledge/decisions/architecture/stack/rust.md |
| RM-DUP | knowledge/architecture/layer-3-auth-firebase-spark.md | (kept knowledge/decisions/architecture/security/layer-3-auth-firebase-spark.md) |
| RM-DUP | knowledge/architecture/extension-distribution.md | (kept knowledge/decisions/architecture/ops/extension-distribution.md) |
| RM-DUP | knowledge/architecture/package-isolation-rule.md | (kept knowledge/decisions/architecture/security/package-isolation-rule.md) |
| RM-DUP | knowledge/architecture/service-bindings-future.md | (kept knowledge/decisions/architecture/compute/service-bindings-future.md) |
| RM-DUP | knowledge/architecture/submodule-pattern.md | (kept knowledge/decisions/architecture/ops/submodule-pattern.md) |
| RM-DUP | knowledge/architecture/cloud-dbs-as-caches.md | (kept knowledge/decisions/architecture/database/cloud-dbs-as-caches.md) |
| RM-DUP | knowledge/architecture/api-routes-structure.md | (kept knowledge/decisions/architecture/compute/api-routes-structure.md) |
| RM-DUP | knowledge/architecture/subscription-flow.md | (kept knowledge/decisions/architecture/ops/subscription-flow.md) |
| RM-DUP | knowledge/architecture/events-table-schema.md | (kept knowledge/decisions/architecture/database/events-table-schema.md) |
| RM-DUP | knowledge/architecture/layer-2-survival-fallback.md | (kept knowledge/decisions/architecture/frontend/layer-2-survival-fallback.md) |
| RM-DUP | knowledge/architecture/layer-4-database-by-shape.md | (kept knowledge/decisions/architecture/general/layer-4-database-by-shape.md) |
| RM-DUP | knowledge/architecture/layer-1-static-hosting.md | (kept knowledge/decisions/architecture/frontend/layer-1-static-hosting.md) |
| RM-DUP | knowledge/architecture/hono-rpc-type-sharing.md | (kept knowledge/decisions/architecture/compute/hono-rpc-type-sharing.md) |
| RM-DUP | knowledge/architecture/canonical-store-jsonl.md | (kept knowledge/decisions/architecture/database/canonical-store-jsonl.md) |
| RM-DUP | knowledge/architecture/layer-5-compute.md | (kept knowledge/decisions/architecture/general/layer-5-compute.md) |
| RM-DUP | knowledge/architecture/cross-site-auth-via-auth-oriz-in.md | (kept knowledge/decisions/architecture/security/cross-site-auth-via-auth-oriz-in.md) |
| RM-DUP | knowledge/architecture/the-six-packages.md | (kept knowledge/decisions/architecture/packages/the-six-packages.md) |
| RM-DUP | knowledge/architecture/master-pointer-as-production-sha.md | (kept knowledge/decisions/architecture/general/master-pointer-as-production-sha.md) |
| RM-DUP | knowledge/architecture/api-umbrella-hono-worker.md | (kept knowledge/decisions/architecture/compute/api-umbrella-hono-worker.md) |
| MV | knowledge/architecture/the-23-packages.md | knowledge/decisions/architecture/packages/the-23-packages.md |
| RM-DUP | knowledge/architecture/index.md | (kept knowledge/decisions/architecture/index.md) |
| MV | knowledge/policy/age-gating.md | knowledge/decisions/policy/age-gating.md |
| MV | knowledge/policy/archive-allowlist.md | knowledge/decisions/policy/archive-allowlist.md |
| MV | knowledge/policy/commercial-use.md | knowledge/decisions/policy/commercial-use.md |
| MV | knowledge/policy/data-canonical-store.md | knowledge/decisions/policy/data-canonical-store.md |
| RM-DUP | knowledge/policy/index.md | (kept knowledge/decisions/policy/index.md) |
| MV | knowledge/policy/ingester-contract.md | knowledge/decisions/policy/ingester-contract.md |
| MV | knowledge/policy/journal-not-public.md | knowledge/decisions/policy/journal-not-public.md |
| MV | knowledge/policy/monetisation.md | knowledge/decisions/policy/monetisation.md |
| MV | knowledge/policy/no-paid-tier.md | knowledge/decisions/policy/no-paid-tier.md |
| MV | knowledge/policy/privacy-policy-per-extension.md | knowledge/decisions/policy/privacy-policy-per-extension.md |
| MV | knowledge/policy/public-private-line.md | knowledge/decisions/policy/public-private-line.md |
| MV | knowledge/policy/secrets-handling.md | knowledge/decisions/policy/secrets-handling.md |
| MV | knowledge/design/_family-rules.md | knowledge/decisions/design/_family-rules.md |
| RM-DUP | knowledge/design/index.md | (kept knowledge/decisions/design/index.md) |
| MV | knowledge/design/oriz-blog.md | knowledge/decisions/design/oriz-blog.md |
| MV | knowledge/design/oriz-book-lore.md | knowledge/decisions/design/oriz-book-lore.md |
| MV | knowledge/design/oriz-books.md | knowledge/decisions/design/oriz-books.md |
| MV | knowledge/design/oriz-cards.md | knowledge/decisions/design/oriz-cards.md |
| MV | knowledge/design/oriz-finance.md | knowledge/decisions/design/oriz-finance.md |
| MV | knowledge/design/oriz-home.md | knowledge/decisions/design/oriz-home.md |
| MV | knowledge/design/oriz-image-tools.md | knowledge/decisions/design/oriz-image-tools.md |
| MV | knowledge/design/oriz-journal.md | knowledge/decisions/design/oriz-journal.md |
| MV | knowledge/design/oriz-me.md | knowledge/decisions/design/oriz-me.md |
| MV | knowledge/design/oriz-pdf-tools.md | knowledge/decisions/design/oriz-pdf-tools.md |
| MV | knowledge/decisions/architecture/knowledge-bundle/depth/5-level-hierarchy.md | knowledge/decisions/architecture/knowledge-bundle/depth-5-level-hierarchy.md |
| RM-DUP | knowledge/decisions/architecture/knowledge-bundle/depth/index.md | (consolidated to parent) |
| MV | knowledge/decisions/branding/naming/policy/family-naming-policy.md | knowledge/decisions/branding/naming/policy-family-naming-policy.md |
| RM-DUP | knowledge/decisions/branding/naming/policy/index.md | (consolidated to parent) |

## Summary

- **Total operations:** 190 (60 moves + 130 dedupe-removals)
- **Files before:** 922 (after sibling agent's superseded deletion)
- **Files after:** 792
- **Top-level dirs dropped:** `knowledge/architecture/`, `knowledge/policy/`, `knowledge/design/`
- **Top-level layout now:** `decisions/`, `glossary/`, `rules/`, `runbooks/`, `services/`
- **Max depth below `knowledge/`:** 4 dirs + file = 5 path components (within hard cap of 5 dirs)
- **Deepest paths now:**
  - `knowledge/decisions/architecture/knowledge-bundle/depth-5-level-hierarchy.md`
  - `knowledge/decisions/branding/naming/policy-family-naming-policy.md`

## Broken-link status

- **Pre-restructure broken:** 456 (mix of pre-existing + restructure-induced)
- **Post-restructure broken:** 309 — all are pre-existing refs to never-created files (e.g. `no-telegram-india-banned.md`, `single-env-example-per-repo.md`, `oriz-restructure-2026-06-20.md`, `log.md` after sibling deletion) or refs within `decisions/index.md` that the index-rebuild agent (task #9) will normalize.
- **Restructure-induced broken: 0** (all architecture/policy/design path moves had their inbound refs rewritten via the python sweep)

## Categories of remaining broken refs (informational)

| Category | Count | Cause |
|---|---|---|
| decisions/ | 103 | refs to never-created decision files (e.g. `packages-14-atomic.md`, `market-data-via-github.md`) |
| glossary/ | 89 | refs to never-created glossary entries (e.g. `oriz-kit.md`) |
| rules/ | 74 | refs to never-created rules (e.g. `no-telegram-india-banned.md`, `no-self-host.md`) |
| runbooks/ | 35 | mostly `runbooks/index.md` referencing flat-runbook files now nested — index-rebuild will fix |
| log.md | 12 | sibling agent deleted `knowledge/log.md` per new no-supersession rule |
| design/services/others | 9 | misc pre-existing |
