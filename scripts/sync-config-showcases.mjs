#!/usr/bin/env node
// Sync workspace-canonical agent configs to 4 public showcase repos.
// One-way: workspace → showcase mirror. Run manually.
//
// Usage: node scripts/sync-config-showcases.mjs [--dry-run]

import { existsSync, readFileSync, writeFileSync, mkdirSync, rmSync, cpSync, readdirSync, statSync } from 'node:fs'
import { join, dirname } from 'node:path'
import { execSync } from 'node:child_process'

const WORKSPACE = 'C:\\D\\oriz'
const STAGING = join(WORKSPACE, '.staging', 'showcase')
const DRY = process.argv.includes('--dry-run')

const ORG = 'oriz-org'
const AGENTS = [
  {
    name: 'claude-code-config',
    desc: 'Public mirror of Claude Code config: CLAUDE.md global rules, settings.template.json, .mcp.json, per-agent rules. Canonical: oriz-org/workspace.',
    copy: [
      // [src-rel-to-workspace, dst-rel-in-repo]
      ['.agents/claude/CLAUDE.md', 'CLAUDE.md'],
      ['.agents/claude/rules', 'rules'],
      ['.mcp.json', '.mcp.json'],
    ],
    extraFiles: {
      // Mirror ~/.claude/CLAUDE.md (the global one) — scrubbed
      'global-CLAUDE.md': scrubSecrets(readFileSync('C:\\Users\\C5420321\\.claude\\CLAUDE.md', 'utf8')),
      'settings.template.json': scrubSecrets(readFileSync('C:\\Users\\C5420321\\.claude\\settings.json', 'utf8')),
    },
    autoLoadedRules: true,
  },
  {
    name: 'opencode-config',
    desc: 'Public mirror of OpenCode config: AGENTS.md pointer, opencode.jsonc, MCP servers. Canonical: oriz-org/workspace.',
    copy: [
      ['.agents/opencode/AGENTS.md', 'AGENTS.md'],
      ['.opencode/opencode.jsonc', 'opencode.jsonc'],
    ],
    autoLoadedRules: false,
  },
  {
    name: 'kilocode-config',
    desc: 'Public mirror of Kilo Code (VS Code extension) config: rule pointer, MCP servers. Canonical: oriz-org/workspace.',
    copy: [
      ['.agents/kilocode/rules', 'rules'],
      ['.kilocode/mcp.json', 'mcp.json'],
    ],
    autoLoadedRules: false,
  },
  {
    name: 'antigravity-config',
    desc: 'Public mirror of Antigravity IDE config: AGENTS.md, MCP servers. Canonical: oriz-org/workspace.',
    copy: [
      ['.agents/antigravity/AGENTS.md', 'AGENTS.md'],
      ['.antigravity/mcp.json', 'mcp.json'],
    ],
    autoLoadedRules: false,
  },
]

function scrubSecrets(text) {
  return text
    .replace(/"ANTHROPIC_AUTH_TOKEN"\s*:\s*"[^"]+"/g, '"ANTHROPIC_AUTH_TOKEN":"<set via ~/.claude/settings.local.json>"')
    .replace(/C:\\Users\\C5420321/g, '<USER_HOME>')
    .replace(/C:\/Users\/C5420321/g, '<USER_HOME>')
}

function run(cmd, cwd = WORKSPACE) {
  if (DRY) { console.log(`[dry] ${cmd}`); return '' }
  return execSync(cmd, { cwd, encoding: 'utf8', stdio: ['inherit', 'pipe', 'pipe'] })
}

function copyRecursive(src, dst) {
  if (!existsSync(src)) return
  if (statSync(src).isDirectory()) {
    mkdirSync(dst, { recursive: true })
    for (const entry of readdirSync(src)) copyRecursive(join(src, entry), join(dst, entry))
  } else {
    mkdirSync(dirname(dst), { recursive: true })
    cpSync(src, dst)
  }
}

const PER_AGENT_INSTALL = {
  'claude-code-config': `# CORP-LAPTOP-ONLY. Claude Code requires $20/mo Pro (no free tier).
# This config assumes a Hr->hai->Bedrock corp proxy chain (also corp-only).
# For personal/free use, see opencode-config or antigravity-config below.

# install Claude Code (paid Pro required to actually run it)
npm i -g @anthropic-ai/claude-code

# mirror the global rules
cp CLAUDE.md ~/.claude/CLAUDE.md

# copy the settings template, then set ANTHROPIC_AUTH_TOKEN in ~/.claude/settings.local.json
# settings.template.json points at Hr proxy on :8787 — adjust for direct Anthropic API or remove the BASE_URL line
cp settings.template.json ~/.claude/settings.json`,
  'opencode-config': `# Personal-laptop friendly. OpenCode is free OSS (172K stars, surpassed CC on GitHub).

# install OpenCode CLI
npm i -g opencode-ai

# point OpenCode at this config
cp opencode.jsonc ~/.config/opencode/opencode.jsonc
cp AGENTS.md ~/.config/opencode/AGENTS.md

# free providers to wire up (any one is enough):
# - OpenRouter free tier (~50 free models, one OAuth, no card)
# - Z.ai coding plan free tier (GLM-4.5-air, GLM-4.6 free)
# - Google AI Studio (Gemini 2.0/2.5 free with rate limits)`,
  'kilocode-config': `# Personal-laptop friendly. Free VS Code extension (replaces Roo Code, archived May 2026).

# install Kilo Code in VS Code
code --install-extension kilocode.Kilo-Code

# copy into your project's .kilocode/
mkdir -p .kilocode && cp -r rules mcp.json .kilocode/

# configure a free provider via Kilo Code's settings UI:
# OpenRouter free, Z.ai free, Google AI Studio, or local (Ollama/LM Studio)`,
  'antigravity-config': `# Personal-laptop primary. Google's free CLI/IDE: 1000 reqs/day, free Google account, no card.
# Antigravity replaced Gemini CLI on 2026-05-19 (Google I/O); Gemini CLI sunset 2026-06-18.

# install Antigravity IDE manually from https://antigravity.google.com/
# then copy this config into your workspace
mkdir -p .antigravity && cp AGENTS.md mcp.json .antigravity/

# login with Google account on first launch — Gemini 3 free tier auto-applied`,
}

const PER_AGENT_BADGE = {
  'claude-code-config': '> ⚠️ **Corp-laptop only.** Claude Code has no free tier (Pro = $20/mo as of 2026-06-29). This config assumes a corp Hr → hai → Bedrock proxy chain. For personal/free use see [opencode-config](https://github.com/oriz-org/opencode-config) or [antigravity-config](https://github.com/oriz-org/antigravity-config).',
  'opencode-config': '> ✅ **Personal-laptop friendly.** OpenCode is free OSS. Pair with OpenRouter / Z.ai / Google AI Studio free tiers — no card required.',
  'kilocode-config': '> ✅ **Personal-laptop friendly.** Free VS Code extension. Configure any free provider.',
  'antigravity-config': '> ✅ **Personal-laptop primary.** Google free tier = 1000 reqs/day with a Google account, no card.',
}

const README_TEMPLATE = (agent) => {
  const installCmds = PER_AGENT_INSTALL[agent.name] || ''
  const badge = PER_AGENT_BADGE[agent.name] || ''
  const filesList = [
    ...agent.copy.map(([s, d]) => `- \`${d}\` — mirrored from \`${s}\` in the canonical workspace`),
    ...(agent.extraFiles ? Object.keys(agent.extraFiles).map(f => `- \`${f}\` — scrubbed global config (secrets and absolute paths replaced with placeholders)`) : []),
    ...(agent.autoLoadedRules ? ['- `agents-md-rules/` — 13 universal rules auto-loaded by every fleet agent (Ponytail, Caveman, output-minimalism, self-update, etc.)'] : []),
  ].join('\n')

  return `# ${agent.name}

${agent.desc}

${badge}

> **Canonical source:** [oriz-org/workspace](https://github.com/oriz-org/workspace) — this repo is a one-way mirror, edits here will be overwritten on next sync.

## Table of contents

- [What's in this repo](#whats-in-this-repo)
- [Quick install](#quick-install)
- [Free vs paid](#free-vs-paid)
- [Architecture](#architecture)
- [Roadmap](#roadmap)
- [Sync](#sync)
- [Reference links](#reference-links)

## What's in this repo

${filesList}

## Quick install

\`\`\`bash
${installCmds}
\`\`\`

Or get the full canonical workspace (recommended — includes all 4 agents + skills + 793 OKF concept files):

\`\`\`bash
gh auth login
git clone https://github.com/oriz-org/workspace.git C:/D/oriz --recurse-submodules
\`\`\`

## Free vs paid

This fleet runs on two physical machines with different cost profiles:

| Machine | Active agents | Provider |
|---|---|---|
| **Corp laptop** | Claude Code (primary) + OpenCode + Kilo Code + Antigravity | Anthropic via Hr → hai → Bedrock (corp-paid) |
| **Personal laptop** | OpenCode + Kilo Code + Antigravity (no CC) | Free only: OpenRouter / Z.ai / Google AI Studio |

**Hard rule:** [no card-on-file ever](https://github.com/oriz-org/workspace/blob/main/knowledge/rules/interaction/no-card-on-file.md). Claude Code's $20/mo Pro minimum (no free tier as of 2026-06-29) is therefore impossible on personal laptop and stays corp-only.

Full split: [\`corp-vs-personal-laptop-split-2026-06-29\`](https://github.com/oriz-org/workspace/blob/main/knowledge/decisions/architecture/agent-tooling/corp-vs-personal-laptop-split-2026-06-29.md).

## Architecture

Part of a 4-agent fleet (Claude Code, OpenCode, Kilo Code, Antigravity) sharing:

- **Universal rules** in [\`oriz-org/workspace/AGENTS.md\`](https://github.com/oriz-org/workspace/blob/main/AGENTS.md) — 78 rules total covering agent behaviour, dev discipline, infra, security, interaction.
- **Canonical MCP servers** in [\`.mcp.json\`](https://github.com/oriz-org/workspace/blob/main/.mcp.json), synced to all 4 agents via [\`scripts/sync-mcp-configs.mjs\`](https://github.com/oriz-org/workspace/blob/main/scripts/sync-mcp-configs.mjs).
- **Skills monorepo** at [\`oriz-org/agent-skills\`](https://github.com/oriz-org/agent-skills) — auto-discovered by all fleet agents via junctions.
- **Knowledge base** at [\`knowledge/\`](https://github.com/oriz-org/workspace/tree/main/knowledge) — 793 OKF concept files (decisions, runbooks, services, rules, glossary).

Discipline (auto-loaded every session):

- **Ponytail** — lazy senior dev ladder; reuse > stdlib > installed dep > one line > minimum code.
- **Caveman** — terse prose, drop articles + filler + hedging.
- **Output-minimalism** — no preamble, no restatement, answer-first ordering.
- **Delegate-to-subagents-by-default** — \`researcher\` (Haiku) for fan-out reads (corp-laptop only; CC subagent).

## Roadmap

This mirror is being simplified around three directions:

1. **Workspace-canonical, mirrors derived.** This repo is a one-way mirror of the workspace; never edit it directly. Source of truth: [\`oriz-org/workspace\`](https://github.com/oriz-org/workspace).
2. **MCP fan-out via single canonical \`.mcp.json\`.** One file, synced to all 4 agents by a script. No per-agent MCP drift. Future: investigate [MCPProxy](https://github.com/TBXark/mcp-proxy) for lazy tool loading + a single MCP HTTP endpoint.
3. **Free-only on personal, corp-paid only on corp.** No mixing. Claude Code stays corp-only; personal stack pivots on OpenCode + Antigravity free tier.

### Recent transitions

- **2026-06-29.** Locked corp-vs-personal split — CC + Bedrock chain corp-only, personal stack on OpenCode + Antigravity + free providers (OpenRouter / Z.ai / Google AI Studio).
- **2026-06-29.** Cline dropped from the fleet — overlapped Kilo Code (both VS Code, both MCP-native).
- **2026-06-29.** Locked workspace-canonical + derived-globals rule with \`scripts/sync-globals.mjs\` (manual-trigger).
- **2026-06-29.** Spun out these 4 mirror repos for discoverability, inspired by [5kahoisaac/opencode-configs](https://github.com/5kahoisaac/opencode-configs).
- **2026-06-28.** Ponytail + Caveman locked at ULTRA level — biggest token-savings discipline of the year.

## Sync

This repo is regenerated from the canonical workspace by a script (one-way, never the reverse).

\`\`\`bash
# from C:/D/oriz/
make sync-showcases       # syncs all 4 mirror repos
make sync-showcases-dry   # dry-run, no push
\`\`\`

Inside this mirror, \`make help\` lists the available targets (one-liner shims around the upstream script).

## Reference links

- **Canonical workspace:** https://github.com/oriz-org/workspace
- **All 4 fleet agent mirrors:**
  - [oriz-org/claude-code-config](https://github.com/oriz-org/claude-code-config) — corp-laptop only
  - [oriz-org/opencode-config](https://github.com/oriz-org/opencode-config) — free-friendly
  - [oriz-org/kilocode-config](https://github.com/oriz-org/kilocode-config) — free-friendly
  - [oriz-org/antigravity-config](https://github.com/oriz-org/antigravity-config) — free-friendly, personal primary
- **Skills monorepo:** https://github.com/oriz-org/agent-skills
- **OKF spec:** https://github.com/oriz-org/workspace/blob/main/knowledge/_okf.md
- **Corp vs personal split:** [\`corp-vs-personal-laptop-split-2026-06-29\`](https://github.com/oriz-org/workspace/blob/main/knowledge/decisions/architecture/agent-tooling/corp-vs-personal-laptop-split-2026-06-29.md)
- **Inspiration:** [5kahoisaac/opencode-configs](https://github.com/5kahoisaac/opencode-configs) — README structure (TOC, Roadmap, Recent transitions) borrowed; agent-personas + paid model routing skipped (free-only constraint).

## License

MIT
`
}

const MAKEFILE_TEMPLATE = `# ${' '.repeat(0)}Showcase mirror — synced from oriz-org/workspace.
# Edits here are overwritten on next sync; edit the workspace instead.

.PHONY: help sync sync-dry pull

help: ## Display available targets
\t@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*?## "}; {printf "  %-15s %s\\n", $$1, $$2}'

pull: ## Pull latest from this mirror's remote
\tgit pull origin main

sync: ## Re-run the upstream sync script (writes this repo from workspace)
\tcd ../../.. && node scripts/sync-config-showcases.mjs

sync-dry: ## Dry-run upstream sync script
\tcd ../../.. && node scripts/sync-config-showcases.mjs --dry-run

.DEFAULT_GOAL := help
`

function syncAgent(agent) {
  const stagingDir = join(STAGING, agent.name)
  const repoUrl = `https://github.com/${ORG}/${agent.name}.git`

  console.log(`\n=== ${agent.name} ===`)

  // Clone or pull
  if (!existsSync(stagingDir)) {
    mkdirSync(STAGING, { recursive: true })
    try {
      run(`git clone ${repoUrl} ${stagingDir}`, STAGING)
    } catch {
      console.log(`  Repo doesn't exist yet — will init locally`)
      mkdirSync(stagingDir, { recursive: true })
      run(`git init`, stagingDir)
      run(`git remote add origin ${repoUrl}`, stagingDir)
    }
  } else {
    try { run(`git pull origin main`, stagingDir) } catch { /* empty repo */ }
  }

  // Clear everything except .git
  for (const entry of readdirSync(stagingDir)) {
    if (entry === '.git') continue
    rmSync(join(stagingDir, entry), { recursive: true, force: true })
  }

  // Copy files
  for (const [src, dst] of agent.copy) {
    const srcAbs = join(WORKSPACE, src)
    const dstAbs = join(stagingDir, dst)
    copyRecursive(srcAbs, dstAbs)
  }

  // Auto-loaded rules (claude-code-config only — these are referenced in workspace AGENTS.md @-imports)
  if (agent.autoLoadedRules) {
    const autoLoaded = [
      'ponytail.md', 'caveman.md', 'output-minimalism.md', 'minimum-everything.md',
      'delegate-to-subagents-by-default.md', 'self-update-rule.md',
      'preferences/edit-mode-prefs.md',
      'mcp-config-single-source-of-truth.md', 'globals-derived-from-workspace.md',
      'agent-fleet-parity.md', 'agents-md-three-place-update.md',
    ]
    for (const rel of autoLoaded) {
      copyRecursive(join(WORKSPACE, 'knowledge/rules/agent', rel), join(stagingDir, 'agents-md-rules/agent', rel))
    }
    const interactionRules = ['future-overrides-past.md', 'communication-stt-friendly.md']
    for (const rel of interactionRules) {
      copyRecursive(join(WORKSPACE, 'knowledge/rules/interaction', rel), join(stagingDir, 'agents-md-rules/interaction', rel))
    }
  }

  // Extra files (scrubbed)
  if (agent.extraFiles) {
    for (const [name, content] of Object.entries(agent.extraFiles)) {
      writeFileSync(join(stagingDir, name), content)
    }
  }

  // README + Makefile + LICENSE
  writeFileSync(join(stagingDir, 'README.md'), README_TEMPLATE(agent))
  writeFileSync(join(stagingDir, 'Makefile'), MAKEFILE_TEMPLATE)
  writeFileSync(join(stagingDir, 'LICENSE'), `MIT License\n\nCopyright (c) ${new Date().getFullYear()} Chirag Singhal\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.\n`)

  // Commit if dirty
  const status = run(`git status --short`, stagingDir)
  if (!status.trim()) {
    console.log(`  No changes`)
    return
  }
  console.log(`  Changes:\n${status.split('\n').map(l => '    ' + l).join('\n')}`)
  if (DRY) return
  run(`git add -A`, stagingDir)
  run(`git -c user.email="103297613+chirag127@users.noreply.github.com" -c user.name="Chirag Singhal" commit -m "chore: sync from oriz-org/workspace"`, stagingDir)
  run(`git push -u origin main 2>&1 || git push -u origin master`, stagingDir)
}

if (DRY) console.log('[DRY RUN]')
for (const agent of AGENTS) {
  try { syncAgent(agent) }
  catch (e) { console.error(`  FAIL ${agent.name}:`, e.message) }
}
console.log('\nDone.')
