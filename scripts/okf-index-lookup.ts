#!/usr/bin/env -S npx tsx
// okf-index-lookup — grep knowledge/index.md for a term and emit matching concept-file paths.
// TypeScript port of okf-index-lookup.py. Stdlib-only.

import * as fs from "node:fs";
import * as path from "node:path";
import * as process from "node:process";
import { fileURLToPath } from "node:url";

const LINK_RE = /\[[^\]]+\]\(([^)]+)\)/g;

function findRepoRoot(start: string): string {
  // Default: parent of scripts/ — i.e. the repo root that owns knowledge/index.md.
  return path.dirname(path.dirname(path.resolve(start)));
}

function isSubPath(child: string, parent: string): boolean {
  const rel = path.relative(parent, child);
  return !rel.startsWith("..") && !path.isAbsolute(rel);
}

function lookup(term: string, repoRoot: string, limit: number | null): string[] {
  const indexPath = path.join(repoRoot, "knowledge", "index.md");
  if (!fs.existsSync(indexPath) || !fs.statSync(indexPath).isFile()) {
    process.stderr.write(`error: index not found at ${indexPath}\n`);
    process.exit(2);
  }

  const needle = term.toLowerCase();
  const indexDir = path.dirname(indexPath);
  const repoResolved = path.resolve(repoRoot);
  const seen = new Set<string>();
  const out: string[] = [];

  const content = fs.readFileSync(indexPath, "utf-8");
  const lines = content.split(/\r?\n/);

  for (const raw of lines) {
    if (!raw.toLowerCase().includes(needle)) continue;
    LINK_RE.lastIndex = 0;
    let m: RegExpExecArray | null;
    while ((m = LINK_RE.exec(raw)) !== null) {
      let target = m[1].split("#", 1)[0].trim();
      if (!target.endsWith(".md")) continue;
      if (
        target.startsWith("http://") ||
        target.startsWith("https://") ||
        target.startsWith("mailto:")
      )
        continue;
      const resolved = path.resolve(path.join(indexDir, target));
      if (!isSubPath(resolved, repoResolved) && resolved !== repoResolved) continue;
      if (!fs.existsSync(resolved) || !fs.statSync(resolved).isFile()) continue;
      if (seen.has(resolved)) continue;
      seen.add(resolved);
      out.push(resolved);
      if (limit && out.length >= limit) return out;
    }
  }
  return out;
}

function main(): number {
  const argv = process.argv.slice(2);
  let term: string | undefined;
  let root: string | undefined;
  let limit: number | null = null;

  let i = 0;
  while (i < argv.length) {
    const a = argv[i];
    if (a === "--root") {
      root = argv[++i];
    } else if (a === "--limit") {
      limit = parseInt(argv[++i], 10);
    } else if (a === "-h" || a === "--help") {
      process.stdout.write("Usage: okf-index-lookup <term> [--root DIR] [--limit N]\n");
      return 0;
    } else if (a.startsWith("--")) {
      process.stderr.write(`error: unknown flag ${a}\n`);
      return 2;
    } else if (term === undefined) {
      term = a;
    }
    i++;
  }

  if (term === undefined) {
    process.stderr.write("error: term required\n");
    return 2;
  }

  const scriptFile = fileURLToPath(import.meta.url);
  const repoRoot = root ? path.resolve(root) : findRepoRoot(scriptFile);
  const paths = lookup(term, repoRoot, limit);
  for (const p of paths) process.stdout.write(p + "\n");
  return paths.length > 0 ? 0 : 1;
}

process.exit(main());
