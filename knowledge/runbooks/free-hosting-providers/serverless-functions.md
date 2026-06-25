---
type: runbook
title: "Free hosting — serverless functions + edge (CF Workers, Deno Deploy, AWS Lambda EXCEPTION, Render, Koyeb, Val.town, HF Spaces, Modal — 2026-06-23 audit)"
description: "Provider-by-provider free-tier numbers for serverless functions and edge runtimes, adversarially verified against official pricing pages on 2026-06-23. The family's 4-rail fallback chain is CF Workers → Deno Deploy → AWS Lambda → Render. Koyeb sits as the 5th candidate. Fly.io free tier is now dead. Cloudflare Containers is paid-only. Vercel Hobby still bans commercial use. Netlify is credit-based. Azure Functions accessible via Student account only."
tags: [runbook, hosting, free-tier, serverless, edge, cloudflare-workers, deno-deploy, aws-lambda, render, koyeb, hugging-face, modal, val-town]
timestamp: 2026-06-23
format_version: okf-v0.1
status: active
related:
  - runbooks/free-hosting-providers/index
  - runbooks/free-hosting-providers/azure-student
  - rules/no-card-on-file
  - rules/aws-lambda-exception
---

# Serverless functions + edge — free tiers (verified 2026-06-23)

Adversarially re-verified against the official pricing pages on 2026-06-23. Sources cited per row. AWS Lambda remains a **user-approved exception** to the no-card rule (see [`rules/infrastructure/aws-lambda-exception.md`](../../rules/infrastructure/aws-lambda-exception.md)). GCP Cloud Run, Oracle Functions, Vercel Hobby (commercial-use ban), Cloudflare Containers (paid-plan-only), and Fly.io (free tier killed) are all DROP in 2026.

## The 4-rail fallback chain (production order, 2026-06-23)

```
1. Cloudflare Worker    (primary;     100K req/day,   10 ms CPU,         edge,  no card)
2. Deno Deploy          (secondary;   1M req/mo,      15 CPU-h/mo,       edge,  no card)
3. AWS Lambda           (tertiary;    1M req/mo,      400K GB-sec/mo,    region, CARD REQ — exception)
4. Render Free          (quaternary;  750 inst-h/mo,  15-min cold sleep, region, no card)
```

Order updated 2026-06-23: Lambda promoted to rail 3 (was 4), Render demoted to rail 4 (was 3). Rationale: Lambda has the family's biggest perpetual free quota, no cold-sleep penalty, and AWS infra is uncorrelated with CF/Deno. Render stays in chain as last-resort (its 15-min spin-down makes it strictly worse for user-facing paths).

A possible **rail 5 (no-card alternative)**: **Koyeb free instance** (512 MB RAM, 0.1 vCPU, 2 GB SSD, no card) — replaces Fly.io which killed its free plan. Useful as a no-card fallback when the Lambda exception is unavailable for a given workload.

A possible **rail 5 (prototype-only)**: **Azure Functions** under the user's [Azure Student account](./azure-student.md). NOT a production rail.

## The verified table

| # | Provider | Free tier (verified 2026-06-23) | Card req? | Cold start | Commercial OK? | Verdict | Source |
|---|---|---|---|---|---|---|---|
| 1 | **Cloudflare Workers** | 100,000 requests/day, 10 ms CPU per invocation, no duration cap, includes Pages Functions | **No** | None (edge) | Yes | **KEEP** (rail 1) | [pricing](https://developers.cloudflare.com/workers/platform/pricing/) |
| 2 | **Deno Deploy** | 1M req/mo, 20 GB egress, 15 CPU-h/mo, 350 GB-h memory, 50 custom domains, 1 GiB volume storage, 450K KV reads + 300K KV writes/mo | **No** | None (edge) | Yes | **KEEP** (rail 2) | [pricing](https://deno.com/deploy/pricing) |
| 3 | **AWS Lambda** | 1M req/mo + 400K GB-sec/mo — listed under "30+ Always Free services". **AWS Free Plan accounts now close after 6 months / $200 credits**; perpetual quota only survives on Paid Plan accounts | **Yes** (Free Plan AND Paid Plan both require valid payment method) | Cold start | Yes | **KEEP-EXCEPTION** (rail 3) | [Lambda pricing](https://aws.amazon.com/lambda/pricing/) · [Free Tier FAQ Q10](https://aws.amazon.com/free/free-tier-faqs/) |
| 4 | **Render Free** | 750 instance-hours/mo across all free web services, 15-min idle spin-down (~1 min cold restart), 100 GB bandwidth/mo, custom domains + TLS, free Postgres 30-day expiry, free Key Value | **No** | 15-min idle sleep | Yes | **KEEP** (rail 4) | [docs/free](https://render.com/docs/free) · [pricing](https://render.com/pricing) |
| 5 | **Koyeb** (free instance) | 1× free instance — **512 MB RAM, 0.1 vCPU, 2 GB SSD**, scale-to-zero, no time limit on the instance | **No** | Scale-to-zero cold start | Yes | **KEEP** (rail 5 / no-card alt) | [docs intro](https://www.koyeb.com/docs) |
| 6 | **Cloudflare Pages Functions** | Shares Workers Free quota (100K req/day) — static asset requests free + unlimited | **No** | None (edge) | Yes | **KEEP** (bundled w/ Workers) | [pricing](https://developers.cloudflare.com/pages/functions/pricing/) |
| 7 | **Cloudflare Cron Triggers** | Shared with Workers Free request quota; cron invocations count as requests | **No** | None | Yes | **KEEP** (rail-1 bundled) | [docs](https://developers.cloudflare.com/workers/configuration/cron-triggers/) |
| 8 | **Cloudflare Workers AI** | **10,000 Neurons/day** free (well below user's prior memory). Above that → Workers Paid required | **No** | None | Yes | **KEEP-AI-ONLY** (light use) | [pricing](https://developers.cloudflare.com/workers-ai/platform/pricing/) |
| 9 | **Cloudflare Queues** | **10,000 ops/day** on Workers Free (NOT 1M/mo as previously believed). Each operation = 64 KB of write/read/delete | **No** | n/a | Yes | **KEEP-LIGHT** — quota tighter than expected | [pricing](https://developers.cloudflare.com/queues/platform/pricing/) |
| 10 | **Val.town** | Unlimited public vals, **100,000 runs/day**, 1 min wall-clock per run, 15-min cron interval minimum, no custom domains, 3-day log retention | **No** | None (edge) | Yes (terms permit) | **KEEP-LIGHT** (specialty: snippet hosting, cron, webhook glue) | [pricing](https://www.val.town/pricing) |
| 11 | **Hugging Face Spaces** | CPU Basic free: **2 vCPU, 16 GB RAM, 50 GB ephemeral disk** for public Spaces. **ZeroGPU now FREE** (dynamic RTX Pro 6000 Blackwell, quota-based, PRO gets 8× quota) | **No** | Cold start on first hit | Yes (open-source/demo focus) | **KEEP-AI-ONLY** (ML demos, ZeroGPU inference) | [pricing](https://huggingface.co/pricing) · [spaces overview](https://huggingface.co/docs/hub/spaces-overview) · [ZeroGPU](https://huggingface.co/docs/hub/spaces-zerogpu) |
| 12 | **Modal Labs** | Starter: **$30/mo free compute credits**, 3 seats, 100 containers + 10 GPU concurrency, 5 deployed crons, 1-day log retention | **Yes** (card required to validate account) | Container cold start | Yes | **KEEP-AI-ONLY** (heavy GPU jobs) | [pricing](https://modal.com/pricing) |
| 13 | **Replicate** | Pay-as-you-go from $0 — no perpetual free credit on signup advertised in docs (model pricing by GPU-second or input/output) | **Yes** (card required for predictions beyond free trial) | Boot delay | Yes | **EVALUATE** (no useful free quota for steady use) | [pricing](https://replicate.com/pricing) · [billing docs](https://replicate.com/docs/billing) |
| 14 | **GitHub Actions** | **Unlimited free minutes for public repos** on standard runners; private repos get plan-tier monthly quota (Free plan: 2,000 min/mo Ubuntu, 500 MB Packages storage) | **No** (for free plan) | Job queue (~10 s) | Yes | **KEEP** (CI/cron rail for public repos) | [billing docs](https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-actions/about-billing-for-github-actions) |
| 15 | **Azure Functions** (Student account) | Consumption plan free grant: 1M execs + 400K GB-sec/mo (legacy plan); Flex Consumption has separate on-demand free grants. Available via [Azure Students](./azure-student.md) | **No** (student-verified) | Cold start | **No** (student/educational only) | **EVALUATE** — 5th-rail prototype only | [Functions pricing](https://azure.microsoft.com/en-us/pricing/details/functions/) · [consumption costs](https://learn.microsoft.com/en-us/azure/azure-functions/functions-consumption-costs) |
| 16 | **Fly.io** | **Free tier KILLED**. Docs: "All organizations require a credit card on file." Historic 3 free shared-cpu-1x VMs no longer advertised | **Yes** | n/a | Yes | **DROP** (free tier killed 2024-2025) | [pricing](https://fly.io/docs/about/pricing/) · [plans](https://fly.io/plans) |
| 17 | **Cloudflare Containers** | **No free tier** — "Available on Workers Paid plan" ($5/mo minimum). Free row in pricing matrix is literally `N/A` | n/a (paid only) | Container start | Yes | **DROP** (paid-only) | [containers pricing](https://developers.cloudflare.com/containers/pricing/) |
| 18 | **Netlify Functions** | Free plan: **300 credits**. Functions cost: web requests 2 credits / 10K, compute 10 credits / GB-hour, deploys 15 credits each. Pool shared with build / bandwidth / AI | **No** | Cold start | Yes | **DROP** — user decision; credit pool too unpredictable for 50-site fleet | [pricing](https://www.netlify.com/pricing/) |
| 19 | **Vercel Hobby Functions** | 1M function invocations, 4 CPU-hrs, 360 GB-hrs memory, 1M edge requests. **"Hobby plan restricts users to non-commercial, personal use only"** | **No** | Cold start | **NO** (commercial-use ban explicit) | **DROP** — commercial ban | [Hobby docs](https://vercel.com/docs/plans/hobby) |
| 20 | **GCP Cloud Run** | 2M req/mo, 360K vCPU-sec, 180K GiB-sec free | **Yes** | Cold start | Yes | **DROP** — user rule (no Google beyond Firebase) | [cloud.google.com/run/pricing](https://cloud.google.com/run/pricing) |
| 21 | **Oracle Functions** | Always-Free 2M invocations/mo | **Yes** (mandatory at signup, user cannot complete) | Cold start | Yes | **DROP** — card barrier | n/a |

## What changed in 2026 (vs. the 2026-06-22 snapshot)

| Change | Direction | Impact |
|---|---|---|
| **AWS Free Tier restructured** (announced mid-2025) | DOWNGRADE | New AWS accounts are forced into "Free Plan" (closes after 6 months / $200 credits) or "Paid Plan". Lambda 1M req/mo + 400K GB-sec/mo **is still in the "Always Free" list** but accessing it past month 6 requires upgrading the account to Paid Plan. **Card required on either plan** (FAQ Q10). Lambda exception still holds, but the rule file needs to reflect the 6-month account-close trap. |
| **Fly.io free tier killed** | KILLED | Was claimed 3× shared-cpu-1x / 256 MB / 160 GB egress. Now: "All organizations require a credit card on file." No free allowance language remains. Dropped from chain. |
| **Cloudflare Containers** | CONFIRMED PAID-ONLY | $5/mo Workers Paid plan required. Free row in pricing matrix is `N/A`. Was never a free rail; DROP confirmed. |
| **Cloudflare Queues free quota** | DOWNGRADE vs prior memory | Free = **10K ops/DAY**, not 1M/mo. The 1M/mo number is the Workers Paid included amount. |
| **Koyeb free instance** | CONFIRMED + UPGRADED | Still free, and the spec is **512 MB RAM / 0.1 vCPU / 2 GB SSD** (better than the 256 MB user remembered). Replaces Fly as the no-card 5th rail. |
| **HF Spaces ZeroGPU** | UPGRADED | ZeroGPU (dynamic RTX Pro 6000 Blackwell, 48 GB VRAM `large` / 96 GB `xlarge`) is now FREE for all users (PRO users get 8× quota). Significant upgrade for AI demos. |
| **Deno Deploy quotas clarified** | CONFIRMED | 1M req/mo, 15 CPU-hours/mo, 350 GB-hours memory, 50 custom domains, 1 GiB volume storage, 20 GB egress, 450K KV reads + 300K KV writes/mo. Deno Deploy Classic is dead — current product is just "Deno Deploy". |
| **Workers AI quota** | CLARIFIED | 10K Neurons/day free (not "Workers AI free tier" hand-wave). Above that requires Workers Paid. |
| **Netlify Functions credit model** | CONFIRMED | Free plan: 300 credits total, all features share the pool. Verdict: DROP for the fleet — too unpredictable for 50 sites. |
| **Vercel Hobby commercial ban** | CONFIRMED | "the Hobby plan restricts users to non-commercial, personal use only." Stays DROP. |
| **Azure Functions Consumption** | LEGACY-STATUS | Old Consumption plan retiring Linux 2028-09-30; v3 runtime on Linux dies 2026-09-30. Flex Consumption is the recommended on-demand plan. Free grants exist on both; student-account perpetual claim holds. |

## Where the family runs functions today (2026-06-23)

- **API endpoints under `*.api.oriz.in`** → Cloudflare Workers (DNS CNAME → workers.dev, custom domain on the Worker)
- **Per-site dynamic endpoints** → Cloudflare Pages Functions (`functions/` dir in each Pages project) — same Workers Free quota
- **Cron / scheduled jobs** → Cloudflare Workers Cron Triggers (same Workers Free quota); GitHub Actions for build/repo-side cron
- **Anything that needs >10 ms CPU** → Deno Deploy (CPU-hours budget instead of per-invocation cap)
- **AI inference (light)** → Workers AI (10K Neurons/day free) or HF Spaces ZeroGPU (free, quota-limited)
- **AI inference (heavy / GPU)** → Modal Labs ($30/mo credits, card on file)
- **Fallback if all of the above fail** → AWS Lambda (rail 3, exception) → Render Free (rail 4, cold sleep)

## Quota math for a 50-site fleet (unchanged from prior snapshot)

100K req/day on Workers Free is the shared cap. For 50 sites:
- 1 cron call/hour each: 1,200 req/day → 1.2% of cap
- 100 user req/day each: 5,000 req/day → 5% of cap
- 1 req/sec sustained each: 4.3M req/day → **43× over cap**

Cap holds for sparse / cron / lightweight-API traffic. Static + edge cache should absorb the user-traffic bulk; functions only for auth/checkout/search-style paths.

## Quirks per provider (2026-06-23 view)

- **Cloudflare Workers 10 ms CPU per invocation.** Hard. Image processing, heavy AI, big JSON crunching trips it. Mitigation: Deno Deploy (CPU-h budget) or Workers Paid Standard ($5/mo, but breaks no-card rule).
- **Deno Deploy Classic is dead.** Migration cliff was 2025-07. Current product = "Deno Deploy" (no Classic suffix). Volume storage, memory-time, CPU-time billing model applies.
- **AWS Free Plan auto-closes after 6 months.** This is the new 2026 model. To keep Lambda's 1M req/mo perpetual quota, the account must be on **Paid Plan** with card on file. The user-approved Lambda exception still holds — see [`rules/infrastructure/aws-lambda-exception.md`](../../rules/infrastructure/aws-lambda-exception.md) for hardening (budgets, service-quota floor, reserved concurrency).
- **Render Free spins down after 15 min idle.** ~1 min cold restart. Not suitable for user-facing critical paths — purely a last-resort rail.
- **Koyeb free instance is small.** 512 MB / 0.1 vCPU / 2 GB SSD. Fine for a Node/Python API server with light traffic; not for memory-hungry workloads.
- **Cloudflare Containers is $5/mo gated.** No free tier exists. If a workload needs containers, the family should reach for Render Free (free, with cold sleep) or Koyeb free instance first.
- **Vercel Hobby commercial ban is enforced.** Stays DROP.
- **Netlify credit pool**: 300 free credits shared across functions/build/bandwidth/AI/etc. Each function request costs 2 credits per 10K. Hard to reason about with 50 sites — DROP per user decision.
- **GCP Cloud Run is DROP** despite generous quota — user is aggressive about avoiding Google beyond Firebase.
- **Fly.io free plan is dead.** Card required on every org. Dropped.
- **Azure Functions Linux Consumption** is retiring 2028-09-30; Flex Consumption is the path forward. Student account still works as a 5th-rail prototype.
- **HF Spaces ZeroGPU** is the surprise upgrade — RTX Pro 6000 Blackwell GPU access for free, quota-based, perfect for image/video gen demos.

## Recommendation for the family (2026-06-23)

1. **Rail 1 (primary):** Cloudflare Workers + Pages Functions for all edge-grade work. 100K req/day across the fleet.
2. **Rail 2 (secondary):** Deno Deploy for anything exceeding 10 ms CPU per invocation.
3. **Rail 3 (tertiary) — USER-APPROVED EXCEPTION:** AWS Lambda. Per [`aws-lambda-exception`](../../rules/infrastructure/aws-lambda-exception.md). Lambda only, no other AWS services. Account on Paid Plan to keep the perpetual quota past 6 months.
4. **Rail 4 (quaternary):** Render Free (with 15-min cold sleep) — last-resort rail.
5. **Rail 5 candidate (no-card alt):** Koyeb free instance (512 MB / 0.1 vCPU / 2 GB SSD) — replaces Fly.io, useful when the Lambda exception isn't appropriate for a given workload.
6. **AI specialty:** HF Spaces ZeroGPU (free GPU, quota-based, public Spaces) for demos; Modal ($30/mo credits, card req) for heavier GPU jobs; Workers AI (10K Neurons/day) for light inference.
7. **CI/repo cron:** GitHub Actions on public repos (unlimited minutes).
8. **Never reach for:** GCP Cloud Run, Oracle Functions, Vercel Hobby (commercial ban), Netlify Functions (credit-pool unpredictability), Fly.io (free tier dead), Cloudflare Containers (paid-only), Azure Functions on non-student account (production).

## Sources (verified 2026-06-23)

- [Cloudflare Workers pricing](https://developers.cloudflare.com/workers/platform/pricing/)
- [Cloudflare Pages Functions pricing](https://developers.cloudflare.com/pages/functions/pricing/)
- [Cloudflare Workers AI pricing](https://developers.cloudflare.com/workers-ai/platform/pricing/)
- [Cloudflare Queues pricing](https://developers.cloudflare.com/queues/platform/pricing/)
- [Cloudflare Cron Triggers docs](https://developers.cloudflare.com/workers/configuration/cron-triggers/)
- [Cloudflare Containers pricing](https://developers.cloudflare.com/containers/pricing/) — paid-only confirmed
- [Deno Deploy pricing](https://deno.com/deploy/pricing) · [Deno Deploy limits](https://docs.deno.com/deploy/manual/pricing-and-limits)
- [AWS Lambda pricing](https://aws.amazon.com/lambda/pricing/) · [AWS Free Tier FAQs](https://aws.amazon.com/free/free-tier-faqs/) · [AWS Free Tier](https://aws.amazon.com/free/)
- [Render Free docs](https://render.com/docs/free) · [Render pricing](https://render.com/pricing)
- [Fly.io pricing](https://fly.io/docs/about/pricing/) · [Fly.io plans](https://fly.io/plans)
- [Koyeb docs intro](https://www.koyeb.com/docs) · [Koyeb pricing](https://www.koyeb.com/pricing)
- [Val.town pricing](https://www.val.town/pricing)
- [Hugging Face pricing](https://huggingface.co/pricing) · [Spaces overview](https://huggingface.co/docs/hub/spaces-overview) · [ZeroGPU docs](https://huggingface.co/docs/hub/spaces-zerogpu)
- [Modal pricing](https://modal.com/pricing)
- [Replicate pricing](https://replicate.com/pricing) · [Replicate billing docs](https://replicate.com/docs/billing)
- [Netlify pricing](https://www.netlify.com/pricing/)
- [Vercel Hobby plan](https://vercel.com/docs/plans/hobby)
- [Azure Functions pricing](https://azure.microsoft.com/en-us/pricing/details/functions/) · [Consumption costs](https://learn.microsoft.com/en-us/azure/azure-functions/functions-consumption-costs) · [Consumption plan legacy notice](https://learn.microsoft.com/en-us/azure/azure-functions/consumption-plan)
- [GitHub Actions billing](https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-actions/about-billing-for-github-actions)
