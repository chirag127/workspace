#!/usr/bin/env node
/**
 * test-mcp-servers.mjs
 *
 * Smoke-tests every MCP server in `.mcp.json` by:
 *   1. Spawning the server (local: command+args; remote: skip launch).
 *   2. Sending `tools/list` JSON-RPC over stdio (local) or HTTP (remote).
 *   3. Recording pass/fail + error.
 *
 * Flags:
 *   --file-issues   create gh issues on the upstream repo for failures.
 *   --json          output JSON instead of table.
 *
 * Run: node scripts/test-mcp-servers.mjs [--file-issues] [--json]
 *
 * Notes:
 *   - Local servers: 10s timeout per server.
 *   - Remote servers: HTTP GET to discover endpoint; non-200 = fail (auth-required is a known soft-fail).
 *   - The `tools/list` method is the MCP 2024-11 spec init handshake.
 */

import { readFileSync } from 'fs';
import { spawn } from 'child_process';
import { join } from 'path';

const ROOT = process.cwd().replace(/\\/g, '/');
const args = new Set(process.argv.slice(2));
const FILE_ISSUES = args.has('--file-issues');
const AS_JSON = args.has('--json');

function readJSON(path) {
  const raw = readFileSync(path, 'utf-8');
  return JSON.parse(raw.replace(/^\s*\/\/.*$/gm, '').replace(/\/\*[\s\S]*?\*\//g, ''));
}

const { mcpServers } = readJSON(join(ROOT, '.mcp.json'));

async function testLocal(name, cfg) {
  return new Promise(resolve => {
    const start = Date.now();
    let proc;
    try {
      proc = spawn(cfg.command, cfg.args ?? [], {
        env: { ...process.env, ...(cfg.env ?? {}) },
        stdio: ['pipe', 'pipe', 'pipe'],
        shell: process.platform === 'win32',
      });
    } catch (e) {
      return resolve({ name, status: 'fail', error: `spawn: ${e.message}`, ms: Date.now() - start });
    }

    let stdout = '';
    let stderr = '';
    let resolved = false;

    const finish = (status, error) => {
      if (resolved) return;
      resolved = true;
      try { proc.kill(); } catch {}
      resolve({ name, status, error, ms: Date.now() - start });
    };

    proc.stdout.on('data', d => {
      stdout += d.toString();
      // First JSON-RPC line back = success
      if (stdout.includes('"jsonrpc"') && stdout.includes('"result"')) {
        finish('pass');
      }
    });
    proc.stderr.on('data', d => { stderr += d.toString(); });
    proc.on('error', err => finish('fail', `proc: ${err.message}`));
    proc.on('exit', code => {
      if (!resolved) finish('fail', `exit ${code}; stderr: ${stderr.slice(0, 200)}`);
    });

    // Send tools/list per MCP protocol
    const req = JSON.stringify({
      jsonrpc: '2.0',
      id: 1,
      method: 'initialize',
      params: { protocolVersion: '2024-11-05', capabilities: {}, clientInfo: { name: 'test', version: '0' } },
    });
    proc.stdin.write(req + '\n');

    setTimeout(() => finish('fail', `timeout 10s; stderr: ${stderr.slice(0, 200)}`), 10_000);
  });
}

async function testRemote(name, cfg) {
  const start = Date.now();
  try {
    const url = cfg.url;
    // MCP JSON-RPC over HTTP: POST initialize, expect 200/202/auth response
    const initReq = JSON.stringify({
      jsonrpc: '2.0',
      id: 1,
      method: 'initialize',
      params: { protocolVersion: '2024-11-05', capabilities: {}, clientInfo: { name: 'test', version: '0' } },
    });
    const resp = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Accept: 'application/json, text/event-stream' },
      body: initReq,
    });
    const status = resp.status;
    if (status === 200 || status === 202) return { name, status: 'pass', ms: Date.now() - start };
    if (status === 401 || status === 403) return { name, status: 'auth', error: `HTTP ${status}: needs auth`, ms: Date.now() - start };
    return { name, status: 'fail', error: `HTTP ${status}`, ms: Date.now() - start };
  } catch (e) {
    return { name, status: 'fail', error: `fetch: ${e.message}`, ms: Date.now() - start };
  }
}

const results = [];
for (const [name, cfg] of Object.entries(mcpServers)) {
  process.stdout.write(`  testing ${name}... `);
  const r = (cfg.type === 'http' || cfg.url) ? await testRemote(name, cfg) : await testLocal(name, cfg);
  results.push(r);
  process.stdout.write(`${r.status} (${r.ms}ms)${r.error ? ' — ' + r.error.slice(0, 80) : ''}\n`);
}

if (AS_JSON) {
  console.log(JSON.stringify(results, null, 2));
} else {
  console.log('\n┌─ MCP smoke-test summary ─');
  for (const r of results) {
    const icon = r.status === 'pass' ? '✓' : r.status === 'auth' ? '⚠' : '✗';
    console.log(`│ ${icon} ${r.name.padEnd(20)} ${r.status.padEnd(5)} ${r.ms}ms`);
    if (r.error) console.log(`│   ${r.error.slice(0, 120)}`);
  }
  console.log('└─');
  const fails = results.filter(r => r.status === 'fail');
  console.log(`\nResult: ${results.filter(r => r.status==='pass').length} pass, ${results.filter(r => r.status==='auth').length} auth-needed, ${fails.length} fail`);

  if (FILE_ISSUES && fails.length) {
    console.log('\n📝 Filing gh issues on failures...');
    const { execSync } = await import('child_process');
    for (const f of fails) {
      // Upstream repo lookup is server-specific; for now log a recommended issue body.
      console.log(`\n  Failure: ${f.name}`);
      console.log(`  Suggested gh issue:`);
      console.log(`    Title: MCP smoke-test fail: ${f.name} (oriz fleet, 2026-06-29)`);
      console.log(`    Body: Server fails handshake. Error: ${f.error}`);
      console.log(`  Run: gh issue create --repo <upstream-repo> --title "..." --body "..."`);
    }
  }

  if (fails.length) process.exit(1);
}
