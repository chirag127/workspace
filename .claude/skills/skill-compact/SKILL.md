---
name: skill-compact
description: Analyze, deduplicate, and restructure agent skills to follow agentskills.io best practices. Merges duplicate skills, extracts shared content into references, reduces SKILL.md sizes, and tracks original sources for update-then-recompact workflows. Use when the user mentions "compact skills", "deduplicate skills", "merge skills", "skill bloat", "too many skills", "skill cleanup", or "optimize skills". Integrates with openskills, skills.sh, and skillshare CLIs.
license: MIT
metadata:
  author: skill-compact
  version: "0.1.0"
compatibility: Requires Node.js 20+, tsx. Works with any agent that supports skills.
---

# Skill Compact

Analyze, deduplicate, and restructure agent skills following the agentskills.io specification.

## When to use

- User has many installed skills with potential overlap
- Skills are monolithic (>300 lines) without progressive disclosure
- Multiple skills share boilerplate content
- User wants to clean up and optimize their skills collection
- User wants to update skills from upstream and re-compact

## Prerequisites

Ensure `tsx` is available. If not, install it:

```bash
npm install -g tsx
```

## Workflow

Follow these phases in order. **Always get user approval before modifying files.**

### Phase 1: Scan and Analyze

Run the scanner to get a full inventory:

```bash
npx tsx scripts/scan.ts <skills-dir>
```

Where `<skills-dir>` is typically `~/.claude/skills` or `.claude/skills`.

Review the JSON output. Focus on:
- `summary.monolithicSkills` - skills >300 lines without references/
- `summary.skillsOverLineLimit` - skills violating the 500-line limit
- `summary.totalTokens` - total context cost of all skills

Present a summary table to the user showing: skill name, lines, tokens, has-refs, has-scripts.

### Phase 2: Cluster and Identify Duplicates

Run the grouper to find overlapping clusters:

```bash
npx tsx scripts/group.ts <skills-dir>
```

Review the clusters. For each cluster with `overlapScore > 0.2`:
1. Read the full SKILL.md of each skill in the cluster
2. Identify specific overlapping content (shared paragraphs, identical code blocks, repeated templates)
3. Identify what is unique to each skill
4. Consult [references/strategies.md](references/strategies.md) for the appropriate compaction strategy

Present each cluster to the user with:
- Which skills overlap and how
- The proposed strategy (merge/absorb/extract-shared/refactor)
- Expected line savings

### Phase 3: Compact (with user approval)

**Before making any changes**, create a backup:

```bash
npx tsx scripts/backup.ts <skills-dir>
```

For each approved compaction, apply the strategy. See [references/strategies.md](references/strategies.md) for detailed instructions per strategy type.

After generating compacted content, write it using:

```bash
npx tsx scripts/write-compact.ts <skills-dir> <skill-name> <strategy> <sources-json>
```

This script handles:
- Writing the compacted SKILL.md with source tracking in frontmatter
- Creating reference files if the strategy requires them
- Removing absorbed/merged skills that were folded in
- Updating the manifest

### Phase 4: Validate

Run validation on the compacted output:

```bash
npx tsx scripts/validate.ts <skills-dir>
```

Fix any violations. Common issues:
- SKILL.md body over 500 lines → move content to references/
- Missing or empty description → write a specific, third-person description
- References nested more than one level deep → flatten

See [references/spec-checklist.md](references/spec-checklist.md) for the full checklist.

### Phase 5: Track Sources

Run source detection to record where each skill came from:

```bash
npx tsx scripts/detect-sources.ts <skills-dir>
```

This detects whether skills were installed via openskills, skills.sh, skillshare, or git.

### Update and Re-compact

When the user wants to update skills and re-compact:

```bash
npx tsx scripts/update-sources.ts <skills-dir>
```

This pulls fresh copies from upstream, then you re-run the compact workflow using the existing manifest's merge decisions as a starting point.

To restore from backup at any time:

```bash
npx tsx scripts/restore.ts <skills-dir> [backup-name]
```

## Compaction Rules

See [references/best-practices.md](references/best-practices.md) for the full set of rules derived from the official agentskills.io specification and Anthropic's authoring guide.

Key rules:
1. SKILL.md body MUST be under 500 lines
2. Detailed content SHOULD be in references/ (one level deep)
3. Descriptions MUST be third-person, specific, include "when to use"
4. Name MUST be lowercase, hyphens only, max 64 chars
5. Only add context the agent doesn't already know
6. Provide a default approach, not multiple options
7. Use consistent terminology throughout

## Available Strategies

See [references/strategies.md](references/strategies.md) for full details on each:

| Strategy | When | Result |
|----------|------|--------|
| **merge** | 2+ skills with >30% content duplication | Single unified skill |
| **absorb** | Small skill is subset of a larger one | Small skill becomes reference file in larger skill |
| **extract-shared** | Group shares boilerplate template | Shared reference file, skills reference it |
| **refactor** | Single skill >300 lines, no references/ | Body reduced, content moved to references/ |
| **no-op** | Already well-structured | No changes |
