---
type: rule
title: "kepano/obsidian-skills: global install"
description: Steph Ango obsidian-skills cloned to ~/skill-sources/; 5 sub-skills symlinked global
tags: [rules, agent-tooling, obsidian, skills, claude-code]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/development/obsidian-vault-plugins-minimal
  - security/personal-notes-public-discipline-2026-06-27
---

# kepano/obsidian-skills — global install

## Rule

Steph Ango's `kepano/obsidian-skills` repo is installed globally into Claude Code. The repo is cloned to `~/skill-sources/obsidian-skills/`, and each of its five sub-skills is symlinked into `~/.claude/skills/` as `obsidian-defuddle`, `obsidian-json-canvas`, `obsidian-bases`, `obsidian-cli`, `obsidian-markdown`. Available to every project's Claude Code session, not per-repo.

## How to apply

- Source of truth: `~/skill-sources/obsidian-skills/` (git remote = `https://github.com/kepano/obsidian-skills`).
- Update path: `git -C ~/skill-sources/obsidian-skills pull` — symlinks pick up changes automatically.
- New machines: clone the repo to `~/skill-sources/`, then `ln -sf ~/skill-sources/obsidian-skills/skills/<name> ~/.claude/skills/obsidian-<name>` for each of the five.
- Do not install via `npx skills add` — these skills aren't packaged that way; manual symlink is the supported path.
- If kepano adds a new sub-skill upstream, decide explicitly whether to symlink it (grill if non-obvious).

## Why

User locked this on 2026-06-27 (Q10). Global install matches how the vault is used — across every project — and the five skills (defuddle, json-canvas, bases, cli, markdown) cover the common Obsidian-shaped agent tasks.

## Captured

2026-06-27 session, Q10 of the rules-lock grill round.

## Related

- [`obsidian-vault-plugins-minimal`](../development/obsidian-vault-plugins-minimal.md)
- [`personal-notes-public-discipline-2026-06-27`](../../security/personal-notes-public-discipline-2026-06-27.md)
