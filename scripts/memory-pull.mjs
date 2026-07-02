#!/usr/bin/env node
/**
 * MEMORY sync pull — pull chirag127/claude-memory and decrypt to local project memories.
 *
 * Fires from Claude Code SessionStart hook.
 * Reads: chirag127/claude-memory repo
 * Writes: decrypted files to ~/.claude/projects/<proj>/memory/*.md (merge, not overwrite)
 *
 * Requires: sops on PATH, age key at ~/.config/sops/age/keys.txt, gh CLI authed.
 *
 * Merge strategy: local file newer → keep local. Remote file newer → replace local.
 * Conflict (both modified since last sync) → warn + write remote as .remote.md alongside local.
 *
 * Related: knowledge/decisions/agent-tooling/memory-cross-machine-sync-2026-07-03.md
 */
import { execSync } from 'node:child_process'
import { existsSync, readdirSync, readFileSync, mkdirSync, statSync, writeFileSync, copyFileSync } from 'node:fs'
import { homedir } from 'node:os'
import path from 'node:path'

const HOME = homedir()
const PROJECTS_DIR = path.join(HOME, '.claude', 'projects')
const REPO_URL = 'https://github.com/chirag127/claude-memory.git'
const WORK = path.join(HOME, '.claude', '.memory-sync-work')
const AGE_KEY = process.env.SOPS_AGE_KEY_FILE || path.join(HOME, '.config', 'sops', 'age', 'keys.txt')

if (!existsSync(AGE_KEY)) {
  console.error(`memory-pull: SOPS_AGE_KEY_FILE not found at ${AGE_KEY} — skipping sync`)
  process.exit(0)
}

const gitEnv = { ...process.env, GIT_TERMINAL_PROMPT: '0' }
if (!existsSync(WORK)) {
  mkdirSync(path.dirname(WORK), { recursive: true })
  try {
    execSync(`git clone --depth 1 ${REPO_URL} ${WORK}`, { stdio: 'inherit', env: gitEnv })
  } catch {
    console.log('memory-pull: repo not yet initialized (first push pending)')
    process.exit(0)
  }
} else {
  execSync(`git -C ${WORK} pull --ff-only`, { stdio: 'inherit', env: gitEnv })
}

mkdirSync(PROJECTS_DIR, { recursive: true })
const remoteProjects = readdirSync(WORK).filter(p => {
  const full = path.join(WORK, p)
  return !p.startsWith('.') && statSync(full).isDirectory()
})

let decrypted = 0, conflicts = 0
for (const proj of remoteProjects) {
  const remoteDir = path.join(WORK, proj)
  const localDir = path.join(PROJECTS_DIR, proj, 'memory')
  mkdirSync(localDir, { recursive: true })
  const encFiles = readdirSync(remoteDir).filter(f => f.endsWith('.md.enc'))
  for (const f of encFiles) {
    const encPath = path.join(remoteDir, f)
    const plainName = f.slice(0, -4) // strip .enc
    const localPath = path.join(localDir, plainName)
    // Decrypt to a temp target, compare with local
    const tmp = path.join(WORK, `.tmp-${plainName}`)
    try {
      execSync(`sops --decrypt ${encPath} > ${tmp}`, { shell: '/bin/sh', stdio: ['ignore', 'ignore', 'inherit'], env: { ...gitEnv, SOPS_AGE_KEY_FILE: AGE_KEY } })
      const remote = readFileSync(tmp, 'utf8')
      if (!existsSync(localPath)) {
        writeFileSync(localPath, remote)
        decrypted++
      } else {
        const local = readFileSync(localPath, 'utf8')
        if (local === remote) {
          // identical — no-op
        } else {
          // Different — remote wins if newer (mtime), else keep local + write .remote.md
          const localStat = statSync(localPath)
          const remoteCommitDate = execSync(`git -C ${WORK} log -1 --format=%at -- ${proj}/${f}`, { encoding: 'utf8' }).trim()
          const remoteMs = parseInt(remoteCommitDate, 10) * 1000
          if (remoteMs > localStat.mtimeMs) {
            writeFileSync(localPath, remote)
            decrypted++
          } else {
            writeFileSync(`${localPath}.remote.md`, remote)
            conflicts++
          }
        }
      }
    } catch (e) {
      console.error(`memory-pull: sops decrypt failed for ${encPath}`, e.message)
    } finally {
      try { execSync(`rm ${tmp}`) } catch {}
    }
  }
}

console.log(`memory-pull: decrypted ${decrypted} files, ${conflicts} conflicts (see *.remote.md)`)
