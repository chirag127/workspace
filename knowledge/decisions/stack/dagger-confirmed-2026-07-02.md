---
type: decision
title: "Dagger keep + full sweep — confirmed 2026-07-02"
description: "After a re-grill on Dagger's disadvantages (Docker dep, cold start, ecosystem loss), the 2026-07-01 pipeline-stack decision is confirmed. Full retro-migration of all 20 own/* repos proceeds. Local pipeline runs justify Dagger over `act`."
tags: [ci, dagger, pipeline, migration]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - decisions/stack/pipeline-stack-2026-07-01
  - decisions/architecture/agent-tooling/reusable-workflows-layered-2026-07-02
---

# Dagger confirmed 2026-07-02

## The re-grill

User questioned Dagger 2026-07-02 after starting a retro-migration. Steel-manned both sides. Locked answers:

| Question | Answer |
|---|---|
| Do you actually run pipelines locally on every commit? | Yes |
| Realistic chance of moving off GHA in 24 months? | Yes |
| Worth 4-8h to learn Dagger? | Yes |
| Full sweep or template-only? | Full sweep of all 20 own/* repos |

## Why Dagger, factually

- **GHA has no first-party local runner.** `act` (nektos/act) is community; ~85% fidelity. Every OIDC-based action fails locally (deploy-pages, cloudflare wrangler on some configs).
- **Dagger runs 100% same code locally + in CI.** Local `dagger call ci` = CI `dagger call ci`. This matches "every commit locally" workflow.
- **Portability is realistic hedge.** GHA pricing changed 2024. Codeberg is our mirror-of-nine. GitLab is a fallback. Dagger runs unchanged on all.
- **Type-safe pipelines refactor cleanly.** TS compiler catches broken shared helpers before push.

## What was rejected

- **Reverting Dagger + returning to pure GHA-YAML.** Considered. Rejected because local-run is real requirement.
- **Template-only (new repos start with Dagger, existing keep YAML).** Considered. Rejected — divergence between old and new repos = drift-in-perpetuity.

## Migration scope

- All 20 `own/*` repos: sweep to Dagger-via-reusable-workflow model per [`reusable-workflows-layered-2026-07-02`](../architecture/agent-tooling/reusable-workflows-layered-2026-07-02.md).
- Forks (`frk/*`): SKIP. Per [`no-fork-divergence`](../../rules/agent/no-fork-divergence.md), forks stay byte-identical to upstream. If we want Dagger there, file an upstream PR — each upstream decides.
- Scorecard, CodeQL, deploy-pages OIDC workflows: KEEP native. GH-integrated features Dagger can't replicate.

## Cross-refs

- [`pipeline-stack-2026-07-01`](../stack/pipeline-stack-2026-07-01.md)
- [`reusable-workflows-layered-2026-07-02`](../architecture/agent-tooling/reusable-workflows-layered-2026-07-02.md)
- [`workspace-owns-secrets-2026-07-02`](../architecture/agent-tooling/workspace-owns-secrets-2026-07-02.md)
