# Workspace inventory — 2026-06-27

Source: `c:\D\oriz\` umbrella repo. Submodule count: **20** (5 `frk/` forks + 15 `own/`). Reference: today = 2026-06-26.

## Submodules in repos/

| # | Path | Repo | Type (own/frk) | Last commit | Purpose |
|---|------|------|----------------|-------------|---------|
| 1 | repos/frk/ai-rewrite-bs-ext | oriz-org/ai-rewrite-bs-ext | frk (fork) | 2026-06-24 | Chrome ext — right-click rewrite selected text via Gemini (Polite/Professional/Cheeky) |
| 2 | repos/frk/claude-notifications-cli | oriz-org/claude-notifications-cli | frk (fork) | 2026-06-22 | Cross-platform smart notifications plugin for Claude Code; webhooks (ntfy/slack/telegram); zero-dep |
| 3 | repos/frk/dearrow-plus-bs-ext | oriz-org/dearrow-plus-bs-ext | frk (fork) | 2026-06-25 | Browser ext — crowdsourced better YouTube titles & thumbnails |
| 4 | repos/frk/freellmapi | oriz-org/freellmapi | frk (fork) | 2026-06-26 | OpenAI-compatible proxy stacking 16 free LLM providers (~1.7B tok/mo) behind one /v1 endpoint |
| 5 | repos/frk/omniroute | oriz-org/omniroute | frk (fork) | 2026-06-26 | AI gateway — 160+ providers (50+ free), RTK+Caveman token compression, MCP/A2A, Desktop/PWA |
| 6 | repos/own/agent-skills | oriz-org/agent-skills | own | 2026-06-25 | Monorepo of agent skills; symlinked into ~/.claude/skills/ and ~/.agents/skills/ |
| 7 | repos/own/backup | oriz-org/backup | own | 2026-06-25 | Disaster-recovery — restic config + RECOVERY.md + scripts; data on Backblaze B2 |
| 8 | repos/own/blog | oriz-org/blog | own | 2026-06-23 | blog.oriz.in — Astro 6 + Tailwind 4 + Cloudflare Pages; long-form engineering/finance/books |
| 9 | repos/own/bookmark-mind-bs-ext | oriz-org/bookmark-mind-bs-ext | own | 2025-12-04 | Browser ext — AI bookmark categorization via Gemini/Groq; snapshot/undo, cross-browser |
| 10 | repos/own/home | oriz-org/home | own | 2026-06-25 | oriz.in — apex hub linking every *.oriz.in; AdSense-monetized; Astro 6 |
| 11 | repos/own/journal | oriz-org/journal | own | 2026-06-23 | journal.oriz.in — privacy-first PWA journal, Tiptap, mood/tags/photos, E2EE, offline |
| 12 | repos/own/me | oriz-org/me | own | 2026-06-22 | me.oriz.in — personal site (hero, now, uses, CV, contact) |
| 13 | repos/own/oriz-janaushdhi-app | oriz-org/oriz-janaushdhi-app | own | 2026-06-25 | janaushdhi.oriz.in — PMBJP generic medicine catalog; Astro 6 + React 19; weekly cron |
| 14 | repos/own/oriz-janaushdhi-book | oriz-org/oriz-janaushdhi-book | own | 2026-06-22 | Source manuscript — "Oriz Janaushdhi: Generic Medicines India" book |
| 15 | repos/own/oriz-lore-app | oriz-org/oriz-lore-app | own | 2026-06-23 | lore.oriz.in — knowledge summaries library (books/courses/papers); ad-supported |
| 16 | repos/own/oriz-me-book | oriz-org/oriz-me-book | own | 2026-06-22 | Source manuscript — "Oriz Me: 100-Year Strategy" book |
| 17 | repos/own/oriz-mmi-tickertape-mmi-api | oriz-org/oriz-mmi-tickertape-mmi-api | own | 2026-06-25 | Hourly mirror of Tickertape Market Mood Index; GH Actions scraper → static JSON via GH Pages |
| 18 | repos/own/oriz-ncert-app | oriz-org/oriz-ncert-app | own | 2026-06-23 | books.oriz.in — Free NCERT textbook directory (browse/search/download by class/subject/lang) |
| 19 | repos/own/sops-lens-vsc-ext | oriz-org/sops-lens-vsc-ext | own | 2026-06-26 | VS Code ext — reveals SOPS-encrypted values via CodeLens/hover/ghost-text; in-memory decrypt |
| 20 | repos/own/userscripts | oriz-org/userscripts | own | 2026-06-25 | Personal userscripts collection — Tampermonkey / ScriptCat / Violentmonkey compatible |

## oriz-org repos NOT submoduled

(oriz-org has 24 repos total per `gh repo list`; 20 submoduled above; 4 absent below. None are archived.)

| Repo | Reason (archived? scaffold? content-only?) |
|------|---|
| workspace | The umbrella itself (this repo, `c:\D\oriz\`). Not self-submoduled. |
| demo-repository | GitHub default sample repo ("best of GitHub" template). Not part of the fleet; safe to ignore/delete. |
| Oriz-DeArrow-browser-ext | Older/duplicate DeArrow fork (PascalCase slug). Superseded by `dearrow-plus-bs-ext` (#3 above). |
| oriz-portfolio-engine-app | Scaffold-only — empty description, last touched 2026-06-25, no live URL. Not yet wired into the umbrella. |

## Non-submodule top-level dirs

| Path | Purpose |
|------|---|
| `.claude/` | Claude Code project settings (settings.local.json, skills, hooks) |
| `.github/` | Umbrella-level GitHub Actions workflows + repo metadata |
| `.headroom/` | Headroom proxy state (LLM gateway local config) |
| `.obsidian/` | Obsidian vault config — `knowledge/` is wired as the PKM vault |
| `.staging/` | Scratch space for staged artefacts (this report lives here) |
| `.vscode/` | VS Code workspace settings |
| `knowledge/` | OKF knowledge bundle — decisions, rules, runbooks, services, glossary, log, inbox, archive, concepts, playbooks, personal |
| `logs/` | Operational artefacts (cf-recreate logs, screenshots) |
| `node_modules/` | pnpm workspace deps for umbrella-level scripts |
| `repos/` | Container for `own/` + `frk/` submodules (table above) |
| `scripts/` | Umbrella ops scripts — CF audit/recreate, scaffold, migrate-to-oriz-org, OKF index lookup, crawl-mcp, dev-all |
| `templates/` | Reusable scaffolding templates for new repos/apps |
| `tmp/` | Throwaway scratch |
| Root files | `AGENTS.md`, `README.md`, `CLAUDE.md`/`COPILOT.md`/`CURSOR.md`/`GEMINI.md`/`AIDER.md` (agent pointers), `DEPLOY.md`, `pnpm-workspace.yaml`, `package.json`, `.gitmodules`, `.env`/`.env.enc`/`.env.example`, `.sops.yaml`/`.sops-age-key.txt`, `.mcp.json`, `cf_cleanup.py`, `oriz-desktop.yml`, `pkg-snap.yml`, `knowledge.md` |

## Health flags

- **1 submodule stale (>90d no commit):** `repos/own/bookmark-mind-bs-ext` — last commit 2025-12-04 (~204d ago).
- **1 submodule with un-pushed local changes:** `repos/own/oriz-janaushdhi-app` — local HEAD `40fdfee7` is ahead of upstream `9df34ef4`. (Untracked-only: `repos/own/blog` has 10 unstaged powertoys-series MDX drafts; no committed divergence.)
- **0 submodules pointing at archived repos** — no repo in `oriz-org` is currently archived.
- **4 oriz-org repos not represented in `.gitmodules`** — `workspace` (self), `demo-repository` (GH sample, candidate for removal), `Oriz-DeArrow-browser-ext` (superseded duplicate, candidate for archive), `oriz-portfolio-engine-app` (scaffold, not yet adopted).
- **2 forks with naming asymmetry vs upstream slug** — `claude-notifications-cli` upstream README badges point at `777genius/claude-notifications-go` (Go→CLI rename in our fork); `dearrow-plus-bs-ext` has a sibling PascalCase duplicate `Oriz-DeArrow-browser-ext` still in the org.
