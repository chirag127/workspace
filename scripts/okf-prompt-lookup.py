#!/usr/bin/env python3
"""okf-prompt-lookup - score knowledge/index.md lines against a free-form prompt.

Standalone. No Headroom dependency. Stdlib only. Sibling to okf-index-lookup.py
(which does single-term substring); this one does prompt-tokenised overlap.

Usage:
    python scripts/okf-prompt-lookup.py "rotate a leaked GitHub token"
    python scripts/okf-prompt-lookup.py --limit 5 --min-score 2 "..."
    echo '{"prompt":"..."}' | python scripts/okf-prompt-lookup.py

Reads prompt from argv or JSON-stdin (e.g. CC UserPromptSubmit hook). Returns
top-N concept-file paths from `knowledge/index.md` whose lines best match the
prompt's content tokens.

Configuration (precedence, lowest to highest):
  1. Built-in defaults (limit=3, min_score=1, etc.)
  2. scripts/okf-lookup.config.json — every knob documented inline
  3. OKF_LOOKUP_<KEY> env vars — e.g. OKF_LOOKUP_LIMIT=5
  4. CLI flags — --limit, --min-score, --format, --root, --no-glossary, etc.

Behaviour:
- Tokenise prompt: lowercase, strip punctuation, drop stopwords + short tokens.
- For each line in `index.md`, score = sum of distinct prompt tokens present.
- Optional +1 boost for lines linking to a runbook (--boost-runbooks).
- Extract every `[label](./path.md)` link target on qualifying lines.
- Rank link targets by (score desc, first-seen order). Return top-N.
- Exit 1 if zero hits (hook caller decides whether to suppress).

Wire into agent hooks via JSON-stdin (CC) or argv (other agents). ~30ms on
1300-line index. Deterministic. No network, no embeddings, no LLM.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
from pathlib import Path

LINK_RE = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
TOKEN_RE = re.compile(r"[a-z0-9][a-z0-9\-_]+")

# English fillers + agent-prompt noise. Removed from token set before scoring.
STOPWORDS = frozenset("""
the a an and or but if then else when while for from to of in on at by with
about into over under across this that these those it its is are was were be
been being have has had do does did will would should could may might must
can shall i me my we us our you your they them their he she his her
please thanks thank yes no ok okay sure can pls plz just want need help
how what why where which who whose make let lets set get got make have take
""".split())

# Oriz-specific stopwords. Suppressed via config.domain_stopwords_enabled=false
# when the script is forked for a non-oriz repo.
DOMAIN_STOPWORDS = frozenset("""
oriz knowledge agent agents rule rules file files repo repos
""".split())

DEFAULT_CONFIG = {
    "limit": 3,
    "min_token_length": 3,
    "min_score": 1,
    "max_line_preview": 120,
    "index_path": "knowledge/index.md",
    "format": "reminder",
    "extra_stopwords": [],
    "domain_stopwords_enabled": True,
    "include_glossary": True,
    "boost_runbooks": False,
}


def load_config(script_dir: Path) -> dict:
    """Load config from JSON file next to script, then overlay env vars."""
    cfg = dict(DEFAULT_CONFIG)
    cfg_file = script_dir / "okf-lookup.config.json"
    if cfg_file.is_file():
        try:
            raw = json.loads(cfg_file.read_text(encoding="utf-8"))
            for k in DEFAULT_CONFIG:
                if k in raw:
                    cfg[k] = raw[k]
        except (ValueError, OSError) as exc:
            print(f"warning: could not parse {cfg_file}: {exc}", file=sys.stderr)

    # Env-var overlay: OKF_LOOKUP_<KEY_UPPER>=value
    for key in DEFAULT_CONFIG:
        env_key = f"OKF_LOOKUP_{key.upper()}"
        if env_key in os.environ:
            val = os.environ[env_key]
            default = DEFAULT_CONFIG[key]
            if isinstance(default, bool):
                cfg[key] = val.lower() in ("1", "true", "yes", "on")
            elif isinstance(default, int):
                try:
                    cfg[key] = int(val)
                except ValueError:
                    pass
            elif isinstance(default, list):
                cfg[key] = [t.strip() for t in val.split(",") if t.strip()]
            else:
                cfg[key] = val
    return cfg


def tokenize(text: str, cfg: dict) -> set[str]:
    min_len = max(1, int(cfg["min_token_length"]))
    extra = frozenset(cfg.get("extra_stopwords") or [])
    domain = DOMAIN_STOPWORDS if cfg["domain_stopwords_enabled"] else frozenset()
    tokens = TOKEN_RE.findall(text.lower())
    return {
        t for t in tokens
        if len(t) >= min_len
        and t not in STOPWORDS
        and t not in domain
        and t not in extra
    }


def lookup(prompt: str, repo_root: Path, cfg: dict) -> list[tuple[Path, int, str]]:
    index_rel = cfg["index_path"]
    index_path = Path(index_rel) if Path(index_rel).is_absolute() else repo_root / index_rel
    if not index_path.is_file():
        print(f"error: index not found at {index_path}", file=sys.stderr)
        sys.exit(2)

    needle_tokens = tokenize(prompt, cfg)
    if not needle_tokens:
        return []

    index_dir = index_path.parent
    repo_resolved = repo_root.resolve()
    seen: set[Path] = set()
    hits: list[tuple[Path, int, str]] = []
    min_score = int(cfg["min_score"])
    boost_runbooks = bool(cfg["boost_runbooks"])
    include_glossary = bool(cfg["include_glossary"])
    max_preview = int(cfg["max_line_preview"])

    for raw in index_path.read_text(encoding="utf-8", errors="replace").splitlines():
        line_lower = raw.lower()
        score = sum(1 for t in needle_tokens if t in line_lower)
        if score < min_score:
            continue
        if boost_runbooks and "/runbooks/" in line_lower:
            score += 1
        for target in LINK_RE.findall(raw):
            target = target.split("#", 1)[0].strip()
            if not target.endswith(".md"):
                continue
            if target.startswith(("http://", "https://", "mailto:")):
                continue
            if not include_glossary and "/glossary/" in target.lower():
                continue
            resolved = (index_dir / target).resolve()
            try:
                resolved.relative_to(repo_resolved)
            except ValueError:
                continue
            if not resolved.is_file():
                continue
            if resolved in seen:
                continue
            seen.add(resolved)
            trimmed = raw.strip()[:max_preview]
            hits.append((resolved, score, trimmed))

    hits.sort(key=lambda h: -h[1])
    limit = int(cfg["limit"])
    return hits if limit <= 0 else hits[:limit]


def read_prompt(args_prompt: str | None) -> str:
    if args_prompt:
        return args_prompt
    raw = sys.stdin.read()
    stripped = raw.lstrip()
    if stripped.startswith("{"):
        try:
            payload = json.loads(raw)
            return payload.get("prompt") or payload.get("user_prompt") or ""
        except (ValueError, TypeError):
            return raw
    return raw


def main() -> int:
    script_dir = Path(__file__).resolve().parent
    cfg = load_config(script_dir)

    p = argparse.ArgumentParser(
        description="Score knowledge/index.md links by prompt-token overlap.",
        epilog="Config precedence: defaults < scripts/okf-lookup.config.json < OKF_LOOKUP_* env < CLI flags.",
    )
    p.add_argument("prompt", nargs="?", help="Prompt text (else read from stdin).")
    p.add_argument("--root", type=Path, default=None, help="Repo root (default: parent of script dir).")
    p.add_argument("--limit", type=int, default=None, help=f"Top-N (default: {cfg['limit']}, 0=all).")
    p.add_argument("--min-score", type=int, default=None, help=f"Min match score (default: {cfg['min_score']}).")
    p.add_argument("--format", choices=["paths", "reminder"], default=None,
                   help=f"Output format (default: {cfg['format']}).")
    p.add_argument("--no-glossary", action="store_true", help="Exclude knowledge/glossary/ hits.")
    p.add_argument("--boost-runbooks", action="store_true", help="+1 score for runbook hits.")
    p.add_argument("--print-config", action="store_true", help="Print effective config + exit.")
    args = p.parse_args()

    # CLI overrides config
    if args.limit is not None:
        cfg["limit"] = args.limit
    if args.min_score is not None:
        cfg["min_score"] = args.min_score
    if args.format is not None:
        cfg["format"] = args.format
    if args.no_glossary:
        cfg["include_glossary"] = False
    if args.boost_runbooks:
        cfg["boost_runbooks"] = True

    if args.print_config:
        print(json.dumps(cfg, indent=2))
        return 0

    prompt = read_prompt(args.prompt)
    if not prompt.strip():
        return 0  # nothing to surface ? not an error (Claude Code logs exit?0 as hook error)

    root = args.root if args.root else script_dir.parent
    hits = lookup(prompt, root, cfg)

    if not hits:
        return 0  # no matches ? not an error

    repo_resolved = root.resolve()
    if cfg["format"] == "paths":
        for path, _score, _line in hits:
            print(path)
    else:
        print("Relevant knowledge files matched by prompt-token overlap. Read before acting.")
        for path, score, line in hits:
            try:
                rel = path.relative_to(repo_resolved)
                rel_str = str(rel).replace("\\", "/")
            except ValueError:
                rel_str = str(path)
            print(f"- {rel_str} (score={score}) - {line}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
