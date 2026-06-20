---
type: service
title: "Azure for Students"
description: "Available — free Azure credits via student program, no card required."
tags: [cloud, azure, student, conditional]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: conditional-cloud-credits
provider: microsoft
free_tier: "$100 USD Azure credits annually (renewable while student) + free always-free services. No credit card required."
swap_cost: n/a
---

# Azure for Students

## Role

Available extra. Reserved for ML / data tasks that benefit from
Azure-specific services (e.g. Computer Vision API calls during build
for `oriz-image-tools`). **Production sites still host on Cloudflare
Pages.**

## Free tier

- $100 USD Azure credits / year (renewable while enrolled)
- Free always-free services on top of the credits
- Azure Cognitive Services within budget

## Card / subscription required?

**NO.** This is the headline difference from standard Azure. Eligibility
is verified via institutional email or student documents, not a card.
Auto-billing does not engage when credits run out — services pause.

## Alternatives

- [Cloudflare Workers](./cloudflare-workers.md) for compute
- [OpenRouter](./openrouter.md) / [Puter.js](./puter-js.md) for AI inference

## Swap cost

N/A — used opportunistically, not depended on.

## Why available

Free credits + no card + no auto-bill = compatible with the
no-card-on-file rule. Useful for one-off ML batch jobs.

## Constraints

- Do **not** host production sites on Azure for Students.
- Do **not** depend on it for critical paths — the credit budget can
  expire on graduation / re-verification.
- Treat any deployment here as ephemeral and reproducible.

## Cross-refs

- [Azure (paid tiers) — REJECTED](../azure-paid-tiers.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
- [Cloudflare Pages](../hosting/cloudflare-pages.md) — primary production host
