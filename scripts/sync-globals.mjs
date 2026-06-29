#!/usr/bin/env node
/**
 * sync-globals.mjs
 *
 * Workspace canonical → globals derived.
 *
 * Reads:
 *   - .mcp.json                                          (canonical MCP servers)
 *   - .agents/claude/settings.template.json              (CC settings template, if exists)
 *
 * Writes:
 *   - ~/.claude.json                                     (mcpServers; merges into existing)
 *   - ~/.claude/settings.json                            (only if template exists; merge)
 *
 * Behaviour:
 *   - MANUAL invocation only — never wire to a hook, cron, or session-start trigger.
 *     Per user instruction 2026-06-29: sync runs only when explicitly invoked.
 *   - Silent when workspace and globals already match.
 *   - Prints diff + fires grill-me prompt when drift is detected.
 *   - `--bootstrap` skips the grill on every new item (used on a fresh clone).
 *   - `--dry-run` prints planned changes without writing.
 *
 * Run: node scripts/sync-globals.mjs [--bootstrap] [--dry-run]
 *
 * See: knowledge/rules/agent/globals-derived-from-workspace.md
 */

import { readFileSync, writeFileSync, existsSync } from 'fs';
import { homedir } from 'os';
import { join } from 'path';
import readline from 'readline';

const ROOT = process.cwd().replace(/\\/g, '/');
const HOME = homedir().replace(/\\/g, '/');
const args = new Set(process.argv.slice(2));
const BOOTSTRAP = args.has('--bootstrap');
const DRY = args.has('--dry-run');

function readJSON(path) {
  const raw = readFileSync(path, 'utf-8');
  const stripped = raw
    .replace(/^\s*\/\/.*$/gm, '')
    .replace(/,\s*\/\/[^"]*$/gm, '')
    .replace(/\/\*[\s\S]*?\*\//g, '');
  return JSON.parse(stripped);
}

function writeJSON(path, data) {
  if (DRY) {
    console.log(`  [dry-run] would write ${path}`);
    return;
  }
  writeFileSync(path, JSON.stringify(data, null, 2) + '\n');
}

function diffKeys(a, b) {
  const aKeys = new Set(Object.keys(a ?? {}));
  const bKeys = new Set(Object.keys(b ?? {}));
  const onlyA = [...aKeys].filter(k => !bKeys.has(k));
  const onlyB = [...bKeys].filter(k => !aKeys.has(k));
  const changed = [...aKeys].filter(k => bKeys.has(k) &&
    JSON.stringify(a[k]) !== JSON.stringify(b[k]));
  return { onlyA, onlyB, changed };
}

async function prompt(question) {
  if (BOOTSTRAP) return 'sync';
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  return new Promise(resolve => {
    rl.question(question, ans => { rl.close(); resolve(ans.trim().toLowerCase()); });
  });
}

// ── Source: workspace .mcp.json ─────────────────────────────────────
const sourceMCP = join(ROOT, '.mcp.json');
if (!existsSync(sourceMCP)) {
  console.error('❌ .mcp.json missing — run from workspace root');
  process.exit(1);
}
const source = readJSON(sourceMCP);
const wsServers = source.mcpServers;

// ── Target: ~/.claude.json ──────────────────────────────────────────
const globalClaude = join(HOME, '.claude.json');
if (!existsSync(globalClaude)) {
  console.error('❌ ~/.claude.json missing — Claude Code not yet initialised');
  process.exit(1);
}
const globalRaw = readFileSync(globalClaude, 'utf-8');
const global = JSON.parse(globalRaw);
global.mcpServers ??= {};

const { onlyA: newInWS, onlyB: onlyInGlobal, changed } = diffKeys(wsServers, global.mcpServers);

if (!newInWS.length && !onlyInGlobal.length && !changed.length) {
  console.log('✅ Workspace and global mcpServers already match.');
  process.exit(0);
}

console.log('\n📋 MCP drift detected:');
if (newInWS.length)      console.log(`  + new in workspace      : ${newInWS.join(', ')}`);
if (onlyInGlobal.length) console.log(`  − only in global        : ${onlyInGlobal.join(', ')}`);
if (changed.length)      console.log(`  ~ changed (ws vs global): ${changed.join(', ')}`);

// ── Grill on each new/changed item ──────────────────────────────────
for (const name of newInWS) {
  const ans = await prompt(`\n  ${name}: workspace has it, global doesn't. [s]ync to global / [k]eep workspace-only / [d]elete from workspace? (default sync): `);
  if (ans === 'd') {
    delete wsServers[name];
    console.log(`    → deleted from workspace`);
  } else if (ans === 'k') {
    console.log(`    → kept workspace-only (global skipped)`);
  } else {
    global.mcpServers[name] = wsServers[name];
    console.log(`    → synced to global`);
  }
}

for (const name of onlyInGlobal) {
  const ans = await prompt(`\n  ${name}: global has it, workspace doesn't. [m]igrate to workspace / [d]elete from global / [k]eep global-only? (default migrate): `);
  if (ans === 'd') {
    delete global.mcpServers[name];
    console.log(`    → deleted from global`);
  } else if (ans === 'k') {
    console.log(`    → kept global-only`);
  } else {
    wsServers[name] = global.mcpServers[name];
    console.log(`    → migrated to workspace`);
  }
}

for (const name of changed) {
  console.log(`\n  ${name}: differs between workspace and global.`);
  console.log(`    workspace: ${JSON.stringify(wsServers[name])}`);
  console.log(`    global   : ${JSON.stringify(global.mcpServers[name])}`);
  const ans = await prompt(`    [w]orkspace wins / [g]lobal wins? (default workspace): `);
  if (ans === 'g') {
    wsServers[name] = global.mcpServers[name];
    console.log(`    → workspace updated from global`);
  } else {
    global.mcpServers[name] = wsServers[name];
    console.log(`    → global updated from workspace`);
  }
}

// ── Write back ──────────────────────────────────────────────────────
writeJSON(sourceMCP, source);
writeJSON(globalClaude, global);

if (!DRY) {
  console.log('\n✅ Synced. Run `node scripts/sync-mcp-configs.mjs` manually to propagate to per-agent files.');
}
