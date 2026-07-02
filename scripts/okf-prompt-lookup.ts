#!/usr/bin/env -S npx tsx
// okf-prompt-lookup — score knowledge/index.md lines against a free-form prompt.
// TypeScript port of okf-prompt-lookup.py. Stdlib-only (Node builtins).
// Reads prompt from argv or JSON-stdin (e.g. CC UserPromptSubmit hook).

import * as fs from "node:fs";
import * as path from "node:path";
import * as process from "node:process";
import { fileURLToPath } from "node:url";

const LINK_RE = /\[[^\]]+\]\(([^)]+)\)/g;
const TOKEN_RE = /[a-z0-9][a-z0-9\-_]+/g;

const STOPWORDS = new Set(
  `the a an and or but if then else when while for from to of in on at by with
about into over under across this that these those it its is are was were be
been being have has had do does did will would should could may might must
can shall i me my we us our you your they them their he she his her
please thanks thank yes no ok okay sure can pls plz just want need help
how what why where which who whose make let lets set get got make have take`
    .split(/\s+/)
    .filter(Boolean),
);

const DOMAIN_STOPWORDS = new Set(
  `oriz knowledge agent agents rule rules file files repo repos`
    .split(/\s+/)
    .filter(Boolean),
);

interface Config {
  limit: number;
  min_token_length: number;
  min_score: number;
  max_line_preview: number;
  index_path: string;
  format: "paths" | "reminder";
  extra_stopwords: string[];
  domain_stopwords_enabled: boolean;
  include_glossary: boolean;
  boost_runbooks: boolean;
}

const DEFAULT_CONFIG: Config = {
  limit: 3,
  min_token_length: 3,
  min_score: 1,
  max_line_preview: 120,
  index_path: "knowledge/index.md",
  format: "reminder",
  extra_stopwords: [],
  domain_stopwords_enabled: true,
  include_glossary: true,
  boost_runbooks: false,
};

function loadConfig(scriptDir: string): Config {
  const cfg: Config = { ...DEFAULT_CONFIG };
  const cfgFile = path.join(scriptDir, "okf-lookup.config.json");
  if (fs.existsSync(cfgFile) && fs.statSync(cfgFile).isFile()) {
    try {
      const raw = JSON.parse(fs.readFileSync(cfgFile, "utf-8"));
      for (const k of Object.keys(DEFAULT_CONFIG) as (keyof Config)[]) {
        if (k in raw) {
          (cfg as any)[k] = raw[k];
        }
      }
    } catch (exc) {
      process.stderr.write(`warning: could not parse ${cfgFile}: ${exc}\n`);
    }
  }

  // Env-var overlay: OKF_LOOKUP_<KEY_UPPER>=value
  for (const key of Object.keys(DEFAULT_CONFIG) as (keyof Config)[]) {
    const envKey = `OKF_LOOKUP_${key.toUpperCase()}`;
    if (envKey in process.env) {
      const val = process.env[envKey]!;
      const def = DEFAULT_CONFIG[key];
      if (typeof def === "boolean") {
        (cfg as any)[key] = ["1", "true", "yes", "on"].includes(val.toLowerCase());
      } else if (typeof def === "number") {
        const n = parseInt(val, 10);
        if (!Number.isNaN(n)) (cfg as any)[key] = n;
      } else if (Array.isArray(def)) {
        (cfg as any)[key] = val
          .split(",")
          .map((t) => t.trim())
          .filter(Boolean);
      } else {
        (cfg as any)[key] = val;
      }
    }
  }
  return cfg;
}

function tokenize(text: string, cfg: Config): Set<string> {
  const minLen = Math.max(1, Math.floor(cfg.min_token_length));
  const extra = new Set(cfg.extra_stopwords || []);
  const domain = cfg.domain_stopwords_enabled ? DOMAIN_STOPWORDS : new Set<string>();
  const tokens = text.toLowerCase().match(TOKEN_RE) || [];
  const out = new Set<string>();
  for (const t of tokens) {
    if (
      t.length >= minLen &&
      !STOPWORDS.has(t) &&
      !domain.has(t) &&
      !extra.has(t)
    ) {
      out.add(t);
    }
  }
  return out;
}

interface Hit {
  path: string;
  score: number;
  line: string;
}

function resolvePath(p: string): string {
  return path.resolve(p);
}

function isSubPath(child: string, parent: string): boolean {
  const rel = path.relative(parent, child);
  return !rel.startsWith("..") && !path.isAbsolute(rel);
}

function lookup(prompt: string, repoRoot: string, cfg: Config): Hit[] {
  const indexRel = cfg.index_path;
  const indexPath = path.isAbsolute(indexRel)
    ? indexRel
    : path.join(repoRoot, indexRel);
  if (!fs.existsSync(indexPath) || !fs.statSync(indexPath).isFile()) {
    process.stderr.write(`error: index not found at ${indexPath}\n`);
    process.exit(2);
  }

  const needleTokens = tokenize(prompt, cfg);
  if (needleTokens.size === 0) return [];

  const indexDir = path.dirname(indexPath);
  const repoResolved = resolvePath(repoRoot);
  const seen = new Set<string>();
  const hits: Hit[] = [];
  const minScore = Math.floor(cfg.min_score);
  const boostRunbooks = Boolean(cfg.boost_runbooks);
  const includeGlossary = Boolean(cfg.include_glossary);
  const maxPreview = Math.floor(cfg.max_line_preview);

  const content = fs.readFileSync(indexPath, "utf-8");
  const lines = content.split(/\r?\n/);

  for (const raw of lines) {
    const lineLower = raw.toLowerCase();
    let score = 0;
    for (const t of needleTokens) {
      if (lineLower.includes(t)) score += 1;
    }
    if (score < minScore) continue;
    if (boostRunbooks && lineLower.includes("/runbooks/")) score += 1;

    // Reset regex state before each line
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
      if (!includeGlossary && target.toLowerCase().includes("/glossary/")) continue;

      const resolved = resolvePath(path.join(indexDir, target));
      if (!isSubPath(resolved, repoResolved) && resolved !== repoResolved) continue;
      if (!fs.existsSync(resolved) || !fs.statSync(resolved).isFile()) continue;
      if (seen.has(resolved)) continue;
      seen.add(resolved);
      const trimmed = raw.trim().slice(0, maxPreview);
      hits.push({ path: resolved, score, line: trimmed });
    }
  }

  hits.sort((a, b) => b.score - a.score);
  const limit = Math.floor(cfg.limit);
  return limit <= 0 ? hits : hits.slice(0, limit);
}

function readStdin(): string {
  try {
    return fs.readFileSync(0, "utf-8");
  } catch {
    return "";
  }
}

function readPrompt(argsPrompt: string | undefined): string {
  if (argsPrompt) return argsPrompt;
  const raw = readStdin();
  const stripped = raw.replace(/^\s+/, "");
  if (stripped.startsWith("{")) {
    try {
      const payload = JSON.parse(raw);
      return payload.prompt || payload.user_prompt || "";
    } catch {
      return raw;
    }
  }
  return raw;
}

interface Args {
  prompt?: string;
  root?: string;
  limit?: number;
  min_score?: number;
  format?: "paths" | "reminder";
  no_glossary: boolean;
  boost_runbooks: boolean;
  print_config: boolean;
}

function parseArgs(argv: string[]): Args {
  const args: Args = {
    no_glossary: false,
    boost_runbooks: false,
    print_config: false,
  };
  const positional: string[] = [];
  let i = 0;
  while (i < argv.length) {
    const a = argv[i];
    if (a === "--root") {
      args.root = argv[++i];
    } else if (a === "--limit") {
      args.limit = parseInt(argv[++i], 10);
    } else if (a === "--min-score") {
      args.min_score = parseInt(argv[++i], 10);
    } else if (a === "--format") {
      const v = argv[++i];
      if (v !== "paths" && v !== "reminder") {
        process.stderr.write(`error: --format must be 'paths' or 'reminder'\n`);
        process.exit(2);
      }
      args.format = v;
    } else if (a === "--no-glossary") {
      args.no_glossary = true;
    } else if (a === "--boost-runbooks") {
      args.boost_runbooks = true;
    } else if (a === "--print-config") {
      args.print_config = true;
    } else if (a === "-h" || a === "--help") {
      process.stdout.write(
        "Usage: okf-prompt-lookup [prompt] [--root DIR] [--limit N] [--min-score N] [--format paths|reminder] [--no-glossary] [--boost-runbooks] [--print-config]\n",
      );
      process.exit(0);
    } else if (a.startsWith("--")) {
      process.stderr.write(`error: unknown flag ${a}\n`);
      process.exit(2);
    } else {
      positional.push(a);
    }
    i++;
  }
  if (positional.length > 0) args.prompt = positional.join(" ");
  return args;
}

function main(): number {
  const scriptFile = fileURLToPath(import.meta.url);
  const scriptDir = path.dirname(scriptFile);
  const cfg = loadConfig(scriptDir);

  const args = parseArgs(process.argv.slice(2));

  // CLI overrides config
  if (args.limit !== undefined) cfg.limit = args.limit;
  if (args.min_score !== undefined) cfg.min_score = args.min_score;
  if (args.format !== undefined) cfg.format = args.format;
  if (args.no_glossary) cfg.include_glossary = false;
  if (args.boost_runbooks) cfg.boost_runbooks = true;

  if (args.print_config) {
    process.stdout.write(JSON.stringify(cfg, null, 2) + "\n");
    return 0;
  }

  const prompt = readPrompt(args.prompt);
  if (!prompt.trim()) return 0; // nothing to surface — not an error

  const root = args.root ? path.resolve(args.root) : path.dirname(scriptDir);
  const hits = lookup(prompt, root, cfg);

  if (hits.length === 0) return 0; // no matches — not an error

  const repoResolved = resolvePath(root);
  if (cfg.format === "paths") {
    for (const h of hits) process.stdout.write(h.path + "\n");
  } else {
    process.stdout.write(
      "Relevant knowledge files matched by prompt-token overlap. Read before acting.\n",
    );
    for (const h of hits) {
      let relStr: string;
      if (isSubPath(h.path, repoResolved) || h.path === repoResolved) {
        relStr = path.relative(repoResolved, h.path).replace(/\\/g, "/");
      } else {
        relStr = h.path;
      }
      process.stdout.write(`- ${relStr} (score=${h.score}) - ${h.line}\n`);
    }
  }
  return 0;
}

process.exit(main());
