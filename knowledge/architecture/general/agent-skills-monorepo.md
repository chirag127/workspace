---
type: concept
title: agent-skills monorepo + symlink invariant
description: Single source of truth for all agent skills used by both Claude Code
  (~/.claude/skills/) and the cross-agent harness (~/.agents/skills/). Lives as a
  git submodule of oriz; both target dirs are symlinks into it.
tags:
- architecture
- skills
- agents
- monorepo
- submodule
timestamp: '2026-06-25'
format_version: okf-v0.1
status: active
---

# agent-skills monorepo + symlink invariant

## What

A single repo, [`oriz-org/agent-skills`](https://github.com/oriz-org/agent-skills),
holds every agent skill used by either harness on this machine. It is mounted
into oriz as a git submodule at
[`repos/oriz/own/content/skills/agent-skills/`](../../../repos/oriz/own/content/skills/agent-skills/).
The only working copy is the submodule checkout — there is **no separate clone**.

`~/.claude/skills/<skill>` and `~/.agents/skills/<skill>` are NTFS symbolic links
(mklink /D on Windows) pointing at directories inside the submodule. Editing a
skill once updates both harnesses.

## Why

Two harnesses (Claude Code and the cross-agent shell) read skills from two
different dirs. Before this change, the same skill existed twice on disk —
sometimes as a real copy in one dir and an ad-hoc symlink in the other,
sometimes as drifting copies in both. Editing a skill required remembering to
sync. A monorepo + symlink kills that whole class of bug.

## Layout

```
oriz-org/agent-skills/
├── README.md            # install + setup instructions
├── scripts/link.sh      # idempotent setup script for new machines
├── develop-userscripts/
├── frontend-design/
├── github-actions-docs/
├── grill-me/
├── karpathy-guidelines/
├── playwright-cli/
├── secure-linux-web-hosting/
├── smithery-ai-cli/
├── use-my-browser/
├── webapp-testing/
└── web-design-reviewer/
```

11 skills as of 2026-06-25. `unblock-action` was listed in CLAUDE.md but turned
out to be a dangling symlink with no source on disk — dropped from the canonical
set.

## Invariants

- **The submodule is the only working copy.** Do not clone agent-skills
  separately. Edit it in place at
  `repos/oriz/own/content/skills/agent-skills/`, commit, push, then bump the
  submodule pointer in oriz.
- **No real directories under the symlinked names.** If
  `~/.claude/skills/<X>` or `~/.agents/skills/<X>` exists as a real dir, the
  invariant is broken — back it up and re-run `scripts/link.sh`.
- **Skills not in the monorepo are still allowed.** A skill that lives only in
  one harness can sit as a real dir next to the symlinks; `link.sh` only
  manages dirs that exist in the monorepo. (Today, no such skill exists — all
  11 are symlinked into both dirs.)

## Setup on a new machine

After `git submodule update --init --recursive` on the oriz superproject:

```bash
bash repos/oriz/own/content/skills/agent-skills/scripts/link.sh
```

On Windows, this requires Developer Mode (Settings → For developers) so that
`mklink /D` works without admin. The script refuses to clobber any real
directory already at a target path.

## Related

- [[master-pointer-as-production-sha]] — the same submodule-pointer-as-state
  pattern, applied here at the per-machine level rather than per-deploy.
- [[dont-create-bak-folders]] (memory) — informed `link.sh`'s decision to
  refuse rather than auto-rename when a target dir already exists.
