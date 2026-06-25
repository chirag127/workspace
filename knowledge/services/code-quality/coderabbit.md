---
type: service
title: "CodeRabbit"
description: "AI code review on every PR. Free forever for OSS / public repos. Catches logic bugs and security smells biome misses."
tags: [services, code-quality, ai, reviews]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: ai-code-review
provider: coderabbit
free_tier: "Free forever for OSS / public repos: 200 files/hour, 3 reviews/hour, 50 conversations/hour"
swap_cost: low
---

# CodeRabbit

## Role

LLM-driven code review on every pull request across the family. CodeRabbit reads the diff, understands intent, and posts inline comments calling out:

- Logic errors (off-by-one, wrong condition, missing null check)
- Security smells (unsafe input handling, injection vectors, leaked secrets)
- Design issues (tight coupling, missing error paths, race conditions)
- Style drift from the rest of the file

It catches the class of bugs Dependabot and biome both miss — the ones that need a model to *understand* the code, not just match patterns.

## Free tier

Free forever for public repos:

- 200 files/hour throughput
- 3 reviews/hour
- 50 conversations/hour
- Unlimited repos
- All review features (chat, walkthroughs, summaries)

The family is entirely OSS, so this tier covers everything.

## Card / subscription required?

**NO** for OSS use.

## Alternatives

- **Greptile** — similar AI review tool, also has an OSS-friendly tier
- **Sourcery** — Python-leaning, less helpful for the TypeScript-heavy family
- **Pull-request-reviewer GitHub Actions** wrapping ChatGPT — DIY route; we'd own the prompt engineering

## Swap cost

**Low.** Both alternatives are GitHub-app installs that comment on PRs; replacing is a one-time install + uninstall in the GitHub org settings.

## Why this is our pick

CodeRabbit's free OSS tier is unbounded in repo count, which matches the family's repo-per-site shape. The reviews are noticeably stronger on TypeScript than Sourcery, and the conversational follow-up ("why?", "how do I fix?") gives a useful learning loop on top of the review itself.

## Cross-refs

- [services/code-quality/dependabot](./dependabot.md)
- [services/code-quality/sonarcloud](./sonarcloud.md)
- [rules/match-surrounding-style](../../rules/interaction/match-surrounding-style.md)
- [runbooks/clean-install](../../runbooks/operations/clean-install.md)
- [decisions/code-quality-stack](../../decisions/process/code-quality-stack.md)
