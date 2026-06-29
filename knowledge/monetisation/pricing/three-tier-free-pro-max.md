---
type: decision
title: "Three-tier pricing: Free / Pro / Max — single package, minimum manual work, community-support only"
description: 3 tiers Free/Pro/Max. Single @chirag127/astro-billing package
tags: [decision, pricing, tiers, free, pro, max, single-package, minimum-manual]
timestamp: 2026-06-22
format_version: okf-v0.1
status: active
supersedes: monetisation/pricing/two-tier-ad-free-plus-pro
related:
  - decisions/architecture/single-pricing-page-package
  - decisions/architecture/payment-architecture-direct-links
  - decisions/architecture/billing-webhook-cf-pages-function
  - rules/no-card-on-file
  - decisions/architecture/oriz-ai-providers-package
---

# Three-tier pricing: Free / Pro / Max

## Tier matrix

| Feature | Free | Pro | Max |
|---|---|---|---|
| **Use all 26 apps** | ? | ? | ? |
| **Ads (AdSense + AdMob)** | shown | hidden | hidden |
| **PWA install / offline static content** | ? | ? | ? |
| **Family SSO across all 26 apps** | ? | ? | ? |
| **Cross-device sync** (history, bookmarks, theme) | — | ? | ? |
| **Custom themes** (light/dark/HC + custom palette) | — | ? | ? |
| **Multi-format export** (PDF / CSV / JSON / XLSX) | limited | full | full |
| **Usage caps on tools** (PDF merges, image converts, etc.) | 10/day | 100/day | unlimited |
| **AI features in apps** (chatbot, summarize, rewrite) | 10/day free-providers only | 50/day free-providers | unlimited + premium models |
| **AI rate limit** | shared free-provider pool | dedicated free-provider quota | premium models + dedicated quota |
| **Early access to new tools** | — | — | ? (30 days before Free) |
| **API access to oriz services** (REST) | — | — | ? |
| **Pro badge in community** (Giscus comments) | — | ? | ? (Max badge) |
| **Free books bundle** | — | — | ? (1 book/year for Yearly Pro/Max) |
| **Support** | community (Giscus/Discord) | community + GH issue priority | community + GH issue priority + direct DM |

## Pricing — NO LIFETIME (monthly + yearly only, per 2026-06-22 grill update)

| Tier | Monthly INR | Yearly INR |
|---|---|---|
| **Free** | ?0 | ?0 |
| **Pro** | ?99 | ?799 |
| **Max** | ?299 | ?2,499 |

USD via Paddle (auto-converted): Pro ~$1.19/mo · $9.59/yr · Max ~$3.59/mo · $30/yr.

**Lifetime tier DROPPED 2026-06-22.** Reason: subscription is the standard for SaaS; lifetime locks predictable revenue. Reintroducible later if user demand emerges.
|---|---|---|---|
| **Free** | ?0 | ?0 |
| **Pro** | ?99 | ?799 |
| **Max** | ?299 | ?2,499 |

USD via Paddle (auto-converted): Pro ~$1.19/mo · $9.59/yr · Max ~$3.59/mo · $30/yr.

## Cross-refs

- Replaces two-tier ? [[monetisation/pricing/two-tier-ad-free-plus-pro]]
- Single pricing page ? [[decisions/packages/single-pricing-page-package]]
- Payment architecture ? [[security/payment-architecture-direct-links]]
- Billing webhooks ? [[decisions/compute/billing-webhook-cf-pages-function]]
- AI providers ? [[decisions/packages/oriz-ai-providers-package]]
- No card on file ? [[rules/no-card-on-file]]
