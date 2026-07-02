#!/usr/bin/env node
/**
 * MEMORY sync push — encrypt local project memories and push to chirag127/claude-memory.
 *
 * Fires from Claude Code Stop hook (once per session end).
 * Reads: ~/.claude/projects/*//memory//*.md
 * Writes: sops-encrypted copies to a temp clone of chirag127/claude-memory
 * Pushes: only when diff non-empty
 *
 * Requires: sops on PATH, age key at ~/.config/sops/age/keys.txt, gh CLI authed.
 *
 * Idempotent: safe to run every session end. No-op if no changes.
 *
 * Related: knowledge/decisions/agent-tooling/memory-cross-machine-sync-2026-07-03.md
 */
import { execSync } from 'node:child_process'
import { existsSync, readdirSync, readFileSync, mkdirSync, statSync, writeFileSync } from 'node:fs'
import { homedir } from 'node:os'
import path from 'node:path'

const HOME = homedir()
const PROJECTS_DIR = path.join(HOME, '.claude', 'projects')
const REPO_URL = 'https://github.com/chirag127/claude-memory.git'
const WORK = path.join(HOME, '.claude', '.memory-sync-work')
const AGE_KEY = process.env.SOPS_AGE_KEY_FILE || path.join(HOME, '.config', 'sops', 'age', 'keys.txt')

if (!existsSync(AGE_KEY)) {
  console.error(`memory-push: SOPS_AGE_KEY_FILE not found at ${AGE_KEY} — skipping sync`)
  process.exit(0)
}

if (!existsSync(PROJECTS_DIR)) {
  console.log('memory-push: no ~/.claude/projects — nothing to sync')
  process.exit(0)
}

// Discover project memories
const projects = readdirSync(PROJECTS_DIR).filter(p => {
  const mem = path.join(PROJECTS_DIR, p, 'memory')
  return existsSync(mem) && statSync(mem).isDirectory()
})

if (projects.length === 0) {
  console.log('memory-push: no memory/ dirs found')
  process.exit(0)
}

// Clone or update repo
const gitEnv = { ...process.env, GIT_TERMINAL_PROMPT: '0' }
if (!existsSync(WORK)) {
  mkdirSync(path.dirname(WORK), { recursive: true })
  execSync(`git clone --depth 1 ${REPO_URL} ${WORK}`, { stdio: 'inherit', env: gitEnv })
} else {
  execSync(`git -C ${WORK} pull --ff-only`, { stdio: 'inherit', env: gitEnv })
}

// For each project's memory dir, encrypt every .md to work repo
let changed = 0
for (const proj of projects) {
  const src = path.join(PROJECTS_DIR, proj, 'memory')
  const dst = path.join(WORK, proj)
  mkdirSync(dst, { recursive: true })
  const files = readdirSync(src).filter(f => f.endsWith('.md'))
  for (const f of files) {
    const srcPath = path.join(src, f)
    const dstPath = path.join(dst, `${f}.enc`)
    const plain = readFileSync(srcPath, 'utf8')
    // sops encrypt via stdin — write to a temp then encrypt
    const tmp = path.join(WORK, `.tmp-${f}`)
    writeFileSync(tmp, plain)
    try {
      execSync(`sops --encrypt --age $(cat ${AGE_KEY} | grep public | awk '{print $NF}') ${tmp} > ${dstPath}`, {
        shell: '/bin/sh', stdio: ['ignore', 'ignore', 'inherit'], env: gitEnv,
      })
      changed++
    } catch (e) {
      console.error(`memory-push: sops encrypt failed for ${srcPath}`, e.message)
    } finally {
      try { execSync(`rm ${tmp}`) } catch {}
    }
  }
}

// Commit + push if diff
const status = execSync(`git -C ${WORK} status --porcelain`, { encoding: 'utf8' })
if (status.trim() === '') {
  console.log('memory-push: no changes to push')
  process.exit(0)
}

const iso = new Date().toISOString().slice(0, 19).replace('T', ' ')
execSync(`git -C ${WORK} add .`, { stdio: 'inherit' })
execSync(`git -C ${WORK} -c user.email="151329215+chirag127@users.noreply.github.com" -c user.name="Chirag Singhal" commit -m "chore: memory sync ${iso}"`, { stdio: 'inherit' })
execSync(`git -C ${WORK} push origin main`, { stdio: 'inherit', env: gitEnv })

console.log(`memory-push: synced ${changed} memory files`)
