#!/usr/bin/env node
/**
 * sync-mcp-configs.mjs
 *
 * Single source of truth: .mcp.json
 * Fleet (2026-06-29 onward, 4 agents):
 *   - Claude Code  → .mcp.json (canonical, no copy needed)
 *   - Kilo Code    → .kilocode/mcp.json   (direct copy)
 *   - Antigravity  → .antigravity/mcp.json (direct copy)
 *   - OpenCode     → .opencode/opencode.jsonc (format-transformed)
 *
 * Run: node scripts/sync-mcp-configs.mjs
 */

import { readFileSync, writeFileSync, copyFileSync, existsSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, '..');

function readJSON(path) {
  const raw = readFileSync(path, 'utf-8');
  // Strip JSONC comments only (not // in URLs)
  const stripped = raw
    .replace(/^\s*\/\/.*$/gm, '')           // line comments at line start
    .replace(/,\s*\/\/[^"]*$/gm, '')        // trailing commas before line-end comments
    .replace(/\/\*[\s\S]*?\*\//g, '');      // block comments
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

// ── Sync OpenCode (different format) ──────────────────────────────
const opencodePath = join(ROOT, '.opencode', 'opencode.jsonc');
if (!existsSync(opencodePath)) {
  console.warn('  ⚠️  .opencode/opencode.jsonc not found, skipping OpenCode');
} else {
  const opencode = readJSON(opencodePath);
  if (!opencode.mcp) opencode.mcp = {};

  for (const [name, cfg] of Object.entries(servers)) {
    if (cfg.type === 'http' || cfg.type === 'sse') {
      // Remote MCP: OpenCode wants { type, url, enabled }
      opencode.mcp[name] = {
        type: 'remote',
        url: cfg.url,
        enabled: true,
      };
    } else {
      // Local MCP: OpenCode wants { type: 'local', command, environment? }
      opencode.mcp[name] = {
        type: 'local',
        command: [cfg.command, ...(cfg.args ?? [])],
        enabled: true,
        ...(cfg.env && Object.keys(cfg.env).length > 0
          ? { environment: cfg.env }
          : {}),
      };
    }
  }

  // Write back as JSONC (no comments preserved — they're instructions, not config)
  writeFileSync(
    opencodePath,
    JSON.stringify(opencode, null, 2) + '\n',
  );
  console.log(`  ✅ Synced ${count} servers → .opencode/opencode.jsonc`);
}

console.log(`\n🎉 All ${count} MCP servers synced to the 4-agent fleet.`);
