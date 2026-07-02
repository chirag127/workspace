#!/usr/bin/env -S npx tsx
// fix-broken-links — scan knowledge/ for broken relative markdown links and fix them
// where the target filename can be located elsewhere in the knowledge base.
// TypeScript port of fix_broken_links.py. Stdlib-only.

import * as fs from "node:fs";
import * as path from "node:path";
import * as process from "node:process";

const KNOWLEDGE_ROOT = path.resolve("c:/D/oriz/knowledge");
const REPO_ROOT = path.resolve("c:/D/oriz");

const LINK_RE = /\[([^\]]+)\]\(([^)]+)\)/g;

function toPosix(p: string): string {
  return p.split(path.sep).join("/");
}

function isRelativeTo(child: string, parent: string): boolean {
  const rel = path.relative(parent, child);
  return !rel.startsWith("..") && !path.isAbsolute(rel);
}

function walk(root: string): string[] {
  const out: string[] = [];
  const stack: string[] = [root];
  while (stack.length > 0) {
    const dir = stack.pop()!;
    let entries: fs.Dirent[];
    try {
      entries = fs.readdirSync(dir, { withFileTypes: true });
    } catch {
      continue;
    }
    for (const e of entries) {
      const full = path.join(dir, e.name);
      if (e.isDirectory()) stack.push(full);
      else if (e.isFile()) out.push(full);
    }
  }
  return out;
}

function buildFilenameMap(): Map<string, string> {
  const fileMap = new Map<string, string>();
  const files = walk(KNOWLEDGE_ROOT);
  for (const full of files) {
    if (!full.endsWith(".md")) continue;
    const baseName = path.basename(full);
    const relFromKnowledge = toPosix(path.relative(KNOWLEDGE_ROOT, full));
    fileMap.set(baseName, relFromKnowledge);
  }
  return fileMap;
}

function fixLinksInFile(filePath: string, fileMap: Map<string, string>): number {
  const content = fs.readFileSync(filePath, "utf-8");
  const isInKnowledge = isRelativeTo(filePath, KNOWLEDGE_ROOT);
  const relBase = isInKnowledge ? KNOWLEDGE_ROOT : REPO_ROOT;
  const relSource = toPosix(path.relative(relBase, filePath));
  const sourceDir = path.dirname(filePath);

  let modified = false;
  let fixedCount = 0;

  const newContent = content.replace(LINK_RE, (match, label: string, target: string) => {
    if (
      target.startsWith("http://") ||
      target.startsWith("https://") ||
      target.startsWith("mailto:") ||
      target.startsWith("tel:")
    ) {
      return match;
    }

    let pathPart: string;
    let anchorPart: string;
    const hashIdx = target.indexOf("#");
    if (hashIdx >= 0) {
      pathPart = target.slice(0, hashIdx);
      anchorPart = target.slice(hashIdx);
    } else {
      pathPart = target;
      anchorPart = "";
    }

    if (!pathPart) return match;

    // Check if resolved path exists
    const resolved = path.resolve(path.join(sourceDir, pathPart));
    if (fs.existsSync(resolved) && fs.statSync(resolved).isFile()) {
      return match;
    }

    // Link is broken — try to fix from filename map
    const targetFilename = path.basename(pathPart);
    if (!fileMap.has(targetFilename)) return match;

    const correctRelTarget = fileMap.get(targetFilename)!;
    const targetPathObj = path.join(KNOWLEDGE_ROOT, correctRelTarget);

    try {
      const srcParts = sourceDir.split(path.sep);
      const tgtParts = path.dirname(targetPathObj).split(path.sep);
      let commonLen = 0;
      const maxCommon = Math.min(srcParts.length, tgtParts.length);
      for (let i = 0; i < maxCommon; i++) {
        if (srcParts[i] === tgtParts[i]) commonLen++;
        else break;
      }
      const upSteps = srcParts.length - commonLen;
      const downPath = [...tgtParts.slice(commonLen), path.basename(targetPathObj)];
      const newRelParts = [...Array(upSteps).fill(".."), ...downPath];
      let newRelativeTarget = newRelParts.join("/");
      if (!newRelativeTarget.startsWith(".")) {
        newRelativeTarget = "./" + newRelativeTarget;
      }

      fixedCount++;
      modified = true;
      process.stdout.write(
        `Fixed link in ${relSource}: ${target} -> ${newRelativeTarget}${anchorPart}\n`,
      );
      return `[${label}](${newRelativeTarget}${anchorPart})`;
    } catch (e) {
      process.stdout.write(
        `Failed to resolve new relative path for ${targetFilename} in ${relSource}: ${e}\n`,
      );
      return match;
    }
  });

  if (modified) {
    fs.writeFileSync(filePath, newContent, "utf-8");
  }
  return fixedCount;
}

function main(): number {
  process.stdout.write("Building filename map...\n");
  const fileMap = buildFilenameMap();
  process.stdout.write(`Found ${fileMap.size} concept files in knowledge base.\n`);

  let totalFixed = 0;

  const allFiles = walk(KNOWLEDGE_ROOT)
    .filter((f) => f.endsWith(".md"))
    .sort();
  for (const filePath of allFiles) {
    totalFixed += fixLinksInFile(filePath, fileMap);
  }

  const rootFiles = [
    "AGENTS.md",
    "CLAUDE.md",
    "GEMINI.md",
    "COPILOT.md",
    "CURSOR.md",
    "AIDER.md",
    "README.md",
    "knowledge.md",
  ].map((f) => path.join(REPO_ROOT, f));

  for (const rf of rootFiles) {
    if (!fs.existsSync(rf)) continue;
    // Root files: use map with knowledge/ prefix
    const rootFileMap = new Map<string, string>();
    for (const [name, p] of fileMap.entries()) {
      rootFileMap.set(name, `knowledge/${p}`);
    }
    totalFixed += fixLinksInFile(rf, rootFileMap);
  }

  process.stdout.write(`Link fixing complete. Total links fixed: ${totalFixed}\n`);
  return 0;
}

process.exit(main());
