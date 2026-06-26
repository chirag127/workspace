# Skill registry migration — 2026-06-26

Moved from "one monorepo with symlinks" to "per-skill clones with canonical
upstreams + weekly ff-only pull". Anchor URL the user pasted:
`https://raw.githubusercontent.com/anthropics/skills/refs/heads/main/skills/frontend-design/SKILL.md`
→ canonical pattern = clone the parent repo once into `~/skill-sources/<org>-<repo>/`,
symlink the skill subdir into `~/.claude/skills/<name>` and `~/.agents/skills/<name>`.

## Canonical URL map

| Skill                          | Strategy | Upstream repo (origin)                              | Subdir within repo                   |
|--------------------------------|----------|------------------------------------------------------|--------------------------------------|
| develop-userscripts            | A        | https://github.com/xixu-me/skills                    | `skills/develop-userscripts`         |
| frontend-design                | A        | https://github.com/anthropics/skills                 | `skills/frontend-design`             |
| github-actions-docs            | A        | https://github.com/xixu-me/skills                    | `skills/github-actions-docs`         |
| grill-me                       | A        | https://github.com/oriz-org/agent-skills             | `grill-me`                           |
| karpathy-guidelines            | A        | https://github.com/multica-ai/andrej-karpathy-skills | `skills/karpathy-guidelines`         |
| playwright-cli                 | A        | https://github.com/oriz-org/agent-skills             | `playwright-cli`                     |
| playwright-persistent-sessions | A        | https://github.com/oriz-org/agent-skills             | `playwright-persistent-sessions`     |
| secure-linux-web-hosting       | A        | https://github.com/xixu-me/skills                    | `skills/secure-linux-web-hosting`    |
| smithery-ai-cli                | A        | https://github.com/oriz-org/agent-skills             | `smithery-ai-cli`                    |
| use-my-browser                 | A        | https://github.com/xixu-me/skills                    | `skills/use-my-browser`              |
| webapp-testing                 | A        | https://github.com/anthropics/skills                 | `skills/webapp-testing`              |
| web-design-reviewer            | A        | https://github.com/oriz-org/agent-skills             | `web-design-reviewer`                |

Strategy A = clone parent repo into `~/skill-sources/<slug>/`, then symlink the
subdir into both `~/.claude/skills/<name>` and `~/.agents/skills/<name>`.
Strategy B (direct clone of a standalone `<name>` repo) was unused — no skill
in the current inventory ships as its own repo. The retired
`chirag127/skill-*` repos from the global CLAUDE.md table are gone (no longer
exist on GitHub) and were not migrated.

## Provenance notes

- **xixu-me/skills** is an aggregator that mirrors many community/openclaw
  skills. Original authors for the skills it carries
  (`develop-userscripts`, `github-actions-docs`, `secure-linux-web-hosting`,
  `use-my-browser`) are not always trivially traceable; xixu-me's copies are
  the most discoverable canonical and they actively maintain them. If a
  more upstream origin surfaces later (e.g., obra, openclaw), swap the
  source repo and rerun `pull-all.ps1`.
- **multica-ai/andrej-karpathy-skills** contains the `karpathy-guidelines`
  skill and is the closest first-party-feeling home for it.
- **anthropics/skills** is the official Anthropic skills repo and provides
  `frontend-design` and `webapp-testing`.
- **oriz-org/agent-skills** keeps the four user-authored / locally-curated
  skills (`grill-me`, `playwright-cli`, `playwright-persistent-sessions`,
  `smithery-ai-cli`, `web-design-reviewer`). The monorepo memory rule
  (`agent-skills-monorepo.md`) still applies to these. The other 7 skills
  in that monorepo are no longer the canonical (they're now redirected to
  their actual upstreams) — feel free to delete those copies on the next
  monorepo edit, or leave them as a fallback.

## Headroom

`chopratejas/headroom` (mentioned in the prompt) is a **Claude plugin**, not
a skill — it ships a `.claude-plugin/marketplace.json` and no `SKILL.md`.
Not migrated as part of this registry. Use the marketplace install path
instead (`/plugin marketplace add chopratejas/headroom`).

## Layout after migration

```
~/skill-sources/
  anthropics-skills/                    # git clone, full repo
  xixu-me-skills/                       # git clone, full repo
  multica-ai-andrej-karpathy-skills/    # git clone, full repo
  pull-all.ps1                          # weekly updater (also pulls direct clones)

~/.claude/skills/
  develop-userscripts -> ~/skill-sources/xixu-me-skills/skills/develop-userscripts
  frontend-design     -> ~/skill-sources/anthropics-skills/skills/frontend-design
  github-actions-docs -> ~/skill-sources/xixu-me-skills/skills/github-actions-docs
  grill-me            -> /c/D/oriz/repos/own/agent-skills/grill-me
  karpathy-guidelines -> ~/skill-sources/multica-ai-andrej-karpathy-skills/skills/karpathy-guidelines
  playwright-cli      -> /c/D/oriz/repos/own/agent-skills/playwright-cli
  playwright-persistent-sessions -> /c/D/oriz/repos/own/agent-skills/playwright-persistent-sessions
  secure-linux-web-hosting -> ~/skill-sources/xixu-me-skills/skills/secure-linux-web-hosting
  smithery-ai-cli     -> /c/D/oriz/repos/own/agent-skills/smithery-ai-cli
  use-my-browser      -> ~/skill-sources/xixu-me-skills/skills/use-my-browser
  webapp-testing      -> ~/skill-sources/anthropics-skills/skills/webapp-testing
  web-design-reviewer -> /c/D/oriz/repos/own/agent-skills/web-design-reviewer
```

`~/.agents/skills/` mirrors the same set (so both the Claude Code harness
and the cross-agent harness see them).

## Weekly cron

- **Script:** `C:\Users\C5420321\skill-sources\pull-all.ps1`
- **Task XML:** `C:\d\oriz\.staging\skills-weekly-update.xml`
- **Task name:** `ClaudeSkillsWeeklyUpdate`
- **Schedule:** weekly, **Mondays 09:00 local**, starts 2026-06-29.
- **Log:** `~/.claude/skills/_update.log` (append, UTF-8, ISO timestamps).
- **Behavior:** `git pull --ff-only --quiet` on
  1. every dir under `~/skill-sources/` that has a `.git/`
  2. every dir under `~/.claude/skills/` that is not a symlink and has a
     `.git/` (catches future Strategy-B direct clones).
- **Idempotent:** ff-only never rewrites local commits; logs `fail` if a
  fast-forward isn't possible (e.g., local edits).
- **Registered:** `schtasks /Create /TN ClaudeSkillsWeeklyUpdate /XML ...
  /F`. Confirmed `Status: Ready`, `Next Run Time: 29-06-2026 09:00:00`.

To re-register on another machine:
```cmd
schtasks /Create /TN ClaudeSkillsWeeklyUpdate /XML C:\d\oriz\.staging\skills-weekly-update.xml /F
```

To run on-demand:
```cmd
schtasks /Run /TN ClaudeSkillsWeeklyUpdate
```

To unregister:
```cmd
schtasks /Delete /TN ClaudeSkillsWeeklyUpdate /F
```

## Migration summary

- **Total skills migrated:** 12.
- **Strategy A (parent clone + symlink):** 12.
- **Strategy B (direct standalone clone):** 0.
- **Unknown upstream:** 0 (5 routed to user's own oriz-org/agent-skills as the
  canonical home for hand-curated / locally-modified skills).
- **Old broken symlinks** (`/c/D/oriz/repos/oriz/own/content/skills/...`,
  a path that no longer exists after the `repos/own/` flatten) replaced.
- **No data lost:** the oriz-org/agent-skills monorepo is untouched on
  disk.
