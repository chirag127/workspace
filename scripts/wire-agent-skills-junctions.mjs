#!/usr/bin/env node
// Wire agent skill junctions — all targets are USER-GLOBAL dirs.
// Workspace root stays clean: no junctions there per workspace-root-cleanliness rule.
//
// Usage:
//   node scripts/wire-agent-skills-junctions.mjs [--dry-run] [--force]
//
// --dry-run  Print what would be done without creating junctions.
// --force    Remove existing junctions/dirs first, then recreate.

import { existsSync, mkdirSync, symlinkSync, rmSync, readdirSync } from 'node:fs'
import { execSync } from 'node:child_process'
import { join, dirname } from 'node:path'
import os from 'node:os'

const HOME = os.homedir()
const SKILLS_SOURCE = 'C:\\D\\oriz\\repos\\own\\infra\\agent-skills'
const DRY = process.argv.includes('--dry-run')
const FORCE = process.argv.includes('--force')
const IS_WIN = process.platform === 'win32'

// All user-global skill paths — one per agent that supports skills.
// Workspace-root skill dirs are intentionally excluded.
// Fleet cut 2026-07-02: CC-only. Dropped-fleet junction dirs no longer created.
// See knowledge/decisions/agent-tooling/fleet-cut-to-cc-only-2026-07-02.md
const TARGETS = [
  { agent: 'Claude Code',  path: join(HOME, '.claude', 'skills') },
]

if (!existsSync(SKILLS_SOURCE)) {
  console.error(`ERROR: Skills source not found: ${SKILLS_SOURCE}`)
  console.error('Run: git submodule update --init repos/own/infra/agent-skills')
  process.exit(1)
}

let created = 0, skipped = 0, failed = 0

for (const { agent, path: target } of TARGETS) {
  const parent = dirname(target)
  if (!existsSync(parent)) {
    if (DRY) { console.log(`[dry] mkdir -p "${parent}"`) }
    else { mkdirSync(parent, { recursive: true }) }
  }

  if (existsSync(target)) {
    if (FORCE) {
      if (DRY) { console.log(`[dry] remove "${target}"`) }
      else { rmSync(target, { recursive: true, force: true }) }
    } else {
      console.log(`  SKIP (exists): [${agent}] ${target}`)
      skipped++
      continue
    }
  }

  console.log(`  CREATE: [${agent}] ${target} -> ${SKILLS_SOURCE}`)
  if (!DRY) {
    try {
      if (IS_WIN) {
        // Windows: use mklink /J for directory junctions (no elevation needed)
        execSync(`mklink /J "${target}" "${SKILLS_SOURCE}"`, { shell: 'cmd.exe', stdio: 'pipe' })
      } else {
        symlinkSync(SKILLS_SOURCE, target, 'dir')
      }
      created++
    } catch (e) {
      console.error(`  FAIL [${agent}]:`, e.message)
      failed++
    }
  }
}

if (!DRY) {
  console.log(`\nDone: ${created} created, ${skipped} skipped, ${failed} failed`)
  if (failed > 0) process.exit(1)
} else {
  console.log('\n[Dry run complete — no changes made]')
}
