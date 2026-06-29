---
type: rule
title: 'Junctions on Windows, symlinks on Unix'
description: 'When creating links to shared content (skills, configs), use directory junctions on Windows (`mklink /J`) and symlinks on Unix (`ln -s`). Junctions work without Developer Mode, are transparent to all tools, and survive across processes.'
tags: [windows, junction, symlink, link, hard-rule]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - rules/agent/agent-fleet-parity
  - rules/agent/globals-derived-from-workspace
---

# Junctions on Windows, symlinks on Unix

## Rule

When creating filesystem links to shared content (e.g. agent-skills monorepo into `~/.claude/skills`, `~/.aider-desk/skills`, etc.):

- **Windows:** `cmd /c mklink /J "<link>" "<target>"` — directory junction.
- **Unix:** `ln -s "<target>" "<link>"` — symbolic link.

## Why junctions over symlinks on Windows

| Property | Junction (`/J`) | Symlink (`/D`) |
|---|---|---|
| Needs admin / Developer Mode? | **No** | Yes |
| Transparent to every tool? | Yes | Yes (mostly) |
| Survives across processes? | Yes | Yes |
| Cross-volume? | No (same drive only) | Yes |
| Network paths? | No | Yes |

For local same-drive content (which is every skill/config in this fleet), junctions win because they need no privilege elevation. Symlinks require Developer Mode or admin, and break when the user runs the script from a non-elevated shell.

## Anti-patterns

- ❌ Hardcoding `mklink /D` (symlink) when junction works.
- ❌ Copying files instead of linking — defeats the single-source-of-truth.
- ❌ Using git submodules in each agent dir — too heavy for "edit once, see everywhere".
- ❌ Live file watchers (chokidar/inotify) — process drift risk.

## When to break the rule

- **Cross-drive content** — junction can't span volumes; use symlink + accept the Developer Mode requirement.
- **Network paths** — junction can't; use UNC symlink.

Both edge cases are rare in this fleet (everything lives on `C:`).

## Cross-refs

- [`agent-fleet-parity`](./agent-fleet-parity.md) — what links enable
- [`globals-derived-from-workspace`](./globals-derived-from-workspace.md) — broader sync rule
- Script: `repos/own/infra/agent-skills/scripts/wire-skills.mjs`
