---
type: rule
title: "Obsidian vault: minimal plugin set"
description: "Only 3 Obsidian plugins: Terminal, Templater, Dataview"
tags: [rules, obsidian, pkm, plugins, vault, minimalism]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - security/personal-notes-public-discipline-2026-06-27
  - rules/agent/kepano-obsidian-skills-global
---

# Obsidian vault: minimal plugin set

## Rule

The vault runs exactly three community plugins: **Terminal**, **Templater**, **Dataview**. Adding a fourth requires a grill — most "useful" Obsidian plugins are sync-conflict surfaces, abandoned within 18 months, or duplicate something the vanilla app already does.

## How to apply

- Default install: Terminal (shell access inside Obsidian), Templater (note templating), Dataview (query notes as a DB).
- Any new plugin proposal triggers a grill: what core need? what does vanilla + the existing three already do? what's the maintenance status?
- Themes and CSS snippets are not plugins — those are unconstrained.
- When syncing the vault across machines, only `.obsidian/plugins/{terminal,templater,dataview}/` needs to be in scope.
- If a plugin gets abandoned, remove it the same week; do not patch around it.

## Why

User locked this on 2026-06-27 (Q12). Obsidian's plugin ecosystem is a known time-sink; constraining to three keeps the vault portable and the upgrade burden near zero.

## Captured

2026-06-27 session, Q12 of the rules-lock grill round.

## Related

- [`personal-notes-public-discipline-2026-06-27`](../../security/personal-notes-public-discipline-2026-06-27.md)
- [`kepano-obsidian-skills-global`](../agent/kepano-obsidian-skills-global.md)
