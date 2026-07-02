#!/usr/bin/env node
/**
 * sync-mcp-configs.mjs
 *
 * Single source of truth: .mcp.json
 * Fleet (10 agents):
 *   - Claude Code  → .mcp.json (canonical, no copy needed)
 *   - ZCode        → GUI only (Settings → MCP Servers) — see knowledge/runbooks/hosting/zcode-mcp-setup.md
 *   - Kilo Code    → .kilocode/mcp.json            (direct copy)
 *   - Antigravity  → .antigravity/mcp.json         (direct copy)
 *   - OpenCode     → .opencode/opencode.jsonc      (format-transformed)
 *   - MiMoCode     → .mimo/mimocode.json           (format-transformed, same as OpenCode)
 *   - Codeep       → .codeep/mcp_servers.json      (direct copy, flat JSON)
 *   - Claurst      → ACP protocol (not MCP) — not synced
 *   - gocode       → ~/.gocode/skills/ (MCP via skills) — not synced
 *   - Coddy        → ~/.coddy/config.yaml (YAML) — not synced
 *
 * Run: node scripts/sync-mcp-configs.mjs
 */

import { readFileSync, writeFileSync, copyFileSync, existsSync, mkdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, '..');

function readJSON(path) {
  const raw = readFileSync(path, 'utf-8');
  // Strip JSONC comments + trailing commas
  const stripped = raw
    .replace(/^\s*\/\/.*$/gm, '')           // line comments at line start
    .replace(/,\s*\/\/[^"]*$/gm, '')        // trailing commas before line-end comments
    .replace(/\/\*[\s\S]*?\*\//g, '')       // block comments
    .replace(/,\s*([}\]])/g, '$1');          // trailing commas before ] or }
  return JSON.parse(stripped);
}

function writeJSON(path, data) {
  writeFileSync(path, JSON.stringify(data, null, 2) + '\n');
}

// ── Read source of truth ──────────────────────────────────────────
const sourcePath = join(ROOT, '.mcp.json');
if (!existsSync(sourcePath)) {
  console.error('❌ .mcp.json not found at', sourcePath);
  process.exit(1);
}
const source = readJSON(sourcePath);
const servers = source.mcpServers;
const count = Object.keys(servers).length;

console.log(`📦 Read ${count} MCP servers from .mcp.json`);

// ── Sync identical-format targets ─────────────────────────────────
const identicalTargets = [
  join(ROOT, '.kilocode', 'mcp.json'),
  join(ROOT, '.antigravity', 'mcp.json'),
];

for (const target of identicalTargets) {
  writeJSON(target, { $schema: source.$schema ?? '', mcpServers: servers });
  console.log(`  ✅ Synced ${count} servers → ${target.replace(ROOT, '.')}`);
}

// ── Sync Codeep (flat JSON at .codeep/mcp_servers.json) ──────────
const codeepDir = join(ROOT, '.codeep');
if (!existsSync(codeepDir)) {
  console.warn(`  ⚠️  .codeep/ dir not found, creating it`);
  mkdirSync(codeepDir, { recursive: true });
}
const codeepTarget = join(codeepDir, 'mcp_servers.json');
writeJSON(codeepTarget, { mcpServers: servers });
console.log(`  ✅ Synced ${count} servers → .codeep/mcp_servers.json`);

// ── Transform: .mcp.json server entry → OpenCode/MiMoCode MCP entry ─────
function mcpEntryForAgent(name, cfg) {
  if (cfg.type === 'http' || cfg.type === 'sse') {
    return { type: 'remote', url: cfg.url, enabled: true };
  }
  return {
    type: 'local',
    command: [cfg.command, ...(cfg.args ?? [])],
    enabled: true,
    ...(cfg.env && Object.keys(cfg.env).length > 0
      ? { environment: cfg.env }
      : {}),
  };
}

function syncMcpField(targetPath, label) {
  if (!existsSync(targetPath)) {
    console.warn(`  ⚠️  ${label} not found, skipping`);
    return;
  }
  const config = readJSON(targetPath);
  if (!config.mcp) config.mcp = {};
  for (const [name, cfg] of Object.entries(servers)) {
    config.mcp[name] = mcpEntryForAgent(name, cfg);
  }
  writeFileSync(targetPath, JSON.stringify(config, null, 2) + '\n');
  console.log(`  ✅ Synced ${count} servers → ${label}`);
}

// ── Sync OpenCode (mcp field in opencode.jsonc) ─────────────────
syncMcpField(join(ROOT, '.opencode', 'opencode.jsonc'), '.opencode/opencode.jsonc');

// ── Sync MiMoCode (mcp field in .mimo/mimocode.json) ────────────
syncMcpField(join(ROOT, '.mimo', 'mimocode.json'), '.mimo/mimocode.json');

console.log(`\n🎉 All ${count} MCP servers synced to the 10-agent fleet.`);
