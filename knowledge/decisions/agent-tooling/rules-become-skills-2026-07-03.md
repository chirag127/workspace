---
type: decision
title: Auto-generate skills from knowledge/rules
description: Every knowledge/rules/agent/*.md compiled to a SKILL.md so rules are invokable as skills; cross-linked, not merged.
tags: [skills, rules, discovery, automation]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: medium
durability: durable
related:
  - decisions/agent-tooling/cloud-publish-skills-2026-07-03
  - decisions/architecture/general/agent-skills-monorepo
  - rules/agent/knowledge-everything-caveman
---

# Rules → skills auto-gen

## Decision

Every `knowledge/rules/agent/*.md` gets a corresponding `SKILL.md` auto-generated in `repos/own/infra/agent-skills/rules/<slug>/`. Rules become invokable as skills.

Script: `scripts/gen-rule-skills.mjs`. Runs on every commit touching `knowledge/rules/`.

## Why

- **Discovery** — agents can call `Skill(name='ponytail')` instead of scanning knowledge/.
- **Invocable** — rule bodies become "on-demand deep-read" via skill trigger.
- **Fleet-wide** — Once in agent-skills submodule, junctioned into all agents' `~/.claude/skills/` dirs.

## Confidence: medium

- Semantic overlap between rules (constraints) and skills (actions) — the mapping isn't clean for every rule.
- Solution: only rules with actionable body (checklists, procedures) get skill-ified. Pure-declarative rules (e.g. `no-card-on-file`) skipped.
- Filter: skill-gen only fires if rule has `## How` or `## Protocol` or `## Actions` section.

## Structure

```
agent-skills/
  rules/
    ponytail/
      SKILL.md      # generated
      _source        # softlink to knowledge/rules/agent/ponytail.md
    caveman/
      SKILL.md
      _source
    ...
```

`SKILL.md` body:
```md
---
name: <slug>
description: <one-line from rule frontmatter>
---
# <title>
See `_source` for the rule text. On invocation, read _source fully.
```

Skill.md acts as a wrapper — the real content stays in `knowledge/` (single source of truth).

## Anti-patterns

- ❌ Duplicate rule text into SKILL.md — drift risk. Wrapper only.
- ❌ Skill-ify every rule — noise. Filter to actionable ones.
- ❌ Manually create skills for rules — auto-gen or nothing.

## Cross-refs

- [`cloud-publish-skills-2026-07-03`](./cloud-publish-skills-2026-07-03.md)
- [`knowledge-everything-caveman`](../../rules/agent/knowledge-everything-caveman.md)
