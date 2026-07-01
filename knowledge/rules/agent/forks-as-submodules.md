---
type: rule
title: 'Forks are submodules, never plain clones'
description: Every fork under repos/frk/ is added via `git submodule add`, never via `git clone`. Locks fork pointer in umbrella, keeps umbrella tree clean.
tags: [rules, agent, forks, submodules, workspace, hard-rule]
timestamp: 2026-07-01
format_version: okf-v0.1
status: active
related:
  - rules/agent/no-fork-divergence
  - rules/agent/fork-thin-upstream-tracking
  - rules/development/fork-discipline
  - infrastructure/workspace-flat-repos-2026-06-25
---

# Forks are submodules

## Rule

Every fork living under `C:\D\oriz\repos\frk\<name>` MUST be added to the umbrella as a **git submodule**. Plain `git clone` into `repos/frk/*` is forbidden.

## How to add a new fork

```bash
cd C:/D/oriz
# 1. Fork upstream to your account under chirag127 (per fork-thin-upstream-tracking)
gh repo fork <upstream-owner>/<upstream-repo> --clone=false
# 2. Add the chirag127 fork as a submodule under repos/frk/<name>
git submodule add https://github.com/chirag127/<upstream-repo>.git repos/frk/<name>
# 3. Wire upstream in the submodule
cd repos/frk/<name>
git remote add upstream https://github.com/<upstream-owner>/<upstream-repo>.git
cd ../../..
# 4. Commit .gitmodules + the new submodule pointer
git add .gitmodules repos/frk/<name>
git commit -m "chore(submodules): add repos/frk/<name> tracking chirag127/<upstream-repo>"
```

## Why submodule, not plain clone

1. **Umbrella tree stays clean.** A plain clone at `repos/frk/x/` puts 1000s of files into git's untracked set. Every `git status` from the umbrella scans them. Submodules are one line in `.gitmodules` + one commit SHA — umbrella sees a single "modified pointer" instead.
2. **Pointer is reproducible.** Bootstrap on a new laptop: `git clone --recurse-submodules` gets every fork at its known-good SHA. Plain clones leave no trace of which fork was where.
3. **Ownership is explicit.** `.gitmodules` records `submodule.repos/frk/<name>.url = https://github.com/chirag127/<repo>`. No guessing which account the fork lives under.
4. **Sync is compositional.** Weekly auto-sync (per [`fork-thin-upstream-tracking`](./fork-thin-upstream-tracking.md)) advances the submodule pointer; a single umbrella commit records the sync.
5. **Consistency with the umbrella pattern.** Every `repos/own/*` and `repos/frk/*` is already a submodule per [`workspace-flat-repos-2026-06-25`](../../infrastructure/workspace-flat-repos-2026-06-25.md). Plain clones inside `repos/frk/` are a rule violation surfaced only when they cause confusion.

## Enforcement

Before ending any session that added a new `repos/frk/*` entry:

```bash
git -C C:/D/oriz submodule status | grep -F repos/frk/
```

Every fork must appear as a submodule line. Any plain directory under `repos/frk/` not appearing in `.gitmodules` is a rule violation. Delete or migrate.

## Migrations from plain clone

If you find a plain clone (no `.gitmodules` entry):

```bash
cd C:/D/oriz
# Save any local work first (branches on chirag127 fork)
git -C repos/frk/<name> push --all origin
# Wipe the plain clone
rm -rf repos/frk/<name>
# Re-add as submodule
git submodule add https://github.com/chirag127/<upstream-repo>.git repos/frk/<name>
```

## Related fork rules — must all be true simultaneously

- [`no-fork-divergence`](./no-fork-divergence.md) — fork's main = upstream's main, byte-identical
- [`fork-thin-upstream-tracking`](./fork-thin-upstream-tracking.md) — origin = `chirag127/*`, upstream = source
- This rule — submodule not clone

Together they define the entire fork lifecycle.

## Anti-patterns

- ❌ `git clone https://github.com/chirag127/<repo>.git repos/frk/<name>` — plain clone, no submodule pointer
- ❌ `mkdir repos/frk/<name> && git init && git remote add ...` — worse: initialises a fresh repo instead of pointing at chirag127
- ❌ Adding an untracked directory to `.gitignore` to hide it from `git status` — hiding the violation instead of fixing it
- ❌ Submodule pointing at `oriz-org/*` — per [`fork-thin-upstream-tracking`](./fork-thin-upstream-tracking.md), forks are `chirag127`-owned

## Cross-refs

- [`no-fork-divergence`](./no-fork-divergence.md)
- [`fork-thin-upstream-tracking`](./fork-thin-upstream-tracking.md)
- [`fork-discipline`](../development/fork-discipline.md)
- [`workspace-flat-repos-2026-06-25`](../../infrastructure/workspace-flat-repos-2026-06-25.md)
