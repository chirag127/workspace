#!/usr/bin/env python3
"""okf-prompt-lookup - score knowledge/index.md lines against a free-form prompt.

Standalone. No Headroom dependency. Stdlib only. Sibling to okf-index-lookup.py
(which does single-term substring); this one does prompt-tokenised overlap.

Usage:
    python scripts/okf-prompt-lookup.py "rotate a leaked GitHub token" [--root <repo>] [--limit N]

Reads prompt from stdin if no positional given. Designed to be wired into agent
UserPromptSubmit-style hooks: takes the user prompt, returns top-N concept-file
paths whose index.md lines best match the prompt's content tokens.

Behaviour:
- Tokenise prompt: lowercase, strip punctuation, drop stopwords + tokens <3 chars.
- For each line in knowledge/index.md, score = sum of distinct prompt tokens that
  appear in the line (case-insensitive).
- For lines with score >= 1, extract every `[label](./path.md)` link target.
- Rank link targets by (line_score, first_seen_order). Return top-N.
- Emit one line per hit: `<absolute_path>\t<score>\t<index_line_text_trimmed>`.
- If no hits, exit 1 with empty stdout (hook caller decides whether to suppress).

Wire into a hook to prepend the top-3 paths as a system-reminder before the agent
sees the prompt. Cheap (stdlib, ~30ms on 1300-line index.md). Deterministic.
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

LINK_RE = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
TOKEN_RE = re.compile(r"[a-z0-9][a-z0-9\-_]+")

# Minimal stopword list - English fillers + agent-prompt noise.
STOPWORDS = frozenset("""
the a an and or but if then else when while for from to of in on at by with
about into over under across this that these those it its is are was were be
been being have has had do does did will would should could may might must
can shall i me my we us our you your they them their he she his her
please thanks thank yes no ok okay sure can pls plz just want need help
how what why where which who whose make let lets set get got make have take
""".split())

# Tokens that ALMOST always appear in oriz prompts and add nothing to ranking.
DOMAIN_STOPWORDS = frozenset("""
oriz knowledge agent agents rule rules file files repo repos
""".split())


def tokenize(text: str) -> set[str]:
    tokens = TOKEN_RE.findall(text.lower())
    return {
        t for t in tokens
        if len(t) >= 3 and t not in STOPWORDS and t not in DOMAIN_STOPWORDS
    }


def lookup(prompt: str, repo_root: Path, limit: int) -> list[tuple[Path, int, str]]:
    index_path = repo_root / "knowledge" / "index.md"
    if not index_path.is_file():
        print(f"error: index not found at {index_path}", file=sys.stderr)
        sys.exit(2)

    needle_tokens = tokenize(prompt)
    if not needle_tokens:
        return []

    index_dir = index_path.parent
    seen: set[Path] = set()
    hits: list[tuple[Path, int, str]] = []

    for raw in index_path.read_text(encoding="utf-8", errors="replace").splitlines():
        line_lower = raw.lower()
        score = sum(1 for t in needle_tokens if t in line_lower)
        if score == 0:
            continue
        for target in LINK_RE.findall(raw):
            target = target.split("#", 1)[0].strip()
            if not target.endswith(".md"):
                continue
            if target.startswith(("http://", "https://", "mailto:")):
                continue
            resolved = (index_dir / target).resolve()
            try:
                resolved.relative_to(repo_root.resolve())
            except ValueError:
                continue
            if not resolved.is_file():
                continue
            if resolved in seen:
                continue
            seen.add(resolved)
            trimmed = raw.strip()[:120]
            hits.append((resolved, score, trimmed))

    # Sort by score desc, preserve first-seen order on ties.
    hits.sort(key=lambda h: -h[1])
    return hits[:limit]


def main() -> int:
    p = argparse.ArgumentParser(description="Score index.md links by prompt-token overlap.")
    p.add_argument("prompt", nargs="?", help="Prompt text (else read from stdin).")
    p.add_argument("--root", type=Path, default=None, help="Repo root (default: parent of this script's dir).")
    p.add_argument("--limit", type=int, default=3, help="Top-N hits to print (default: 3).")
    p.add_argument("--format", choices=["paths", "reminder"], default="reminder",
                   help="paths = one path per line; reminder = <system-reminder> block (default).")
    args = p.parse_args()

    if args.prompt:
        prompt = args.prompt
    else:
        raw = sys.stdin.read()
        # Hook callers (Claude Code et al) pass JSON on stdin. Detect + extract.
        stripped = raw.lstrip()
        if stripped.startswith("{"):
            try:
                import json
                payload = json.loads(raw)
                prompt = payload.get("prompt") or payload.get("user_prompt") or ""
            except (ValueError, TypeError):
                prompt = raw
        else:
            prompt = raw
    if not prompt.strip():
        return 1

    root = args.root if args.root else Path(__file__).resolve().parent.parent
    hits = lookup(prompt, root, args.limit)

    if not hits:
        return 1

    if args.format == "paths":
        for path, _score, _line in hits:
            print(path)
    else:
        print("Relevant knowledge files matched by prompt-token overlap. Read before acting.")
        for path, score, line in hits:
            try:
                rel = path.relative_to(root.resolve())
                rel_str = str(rel).replace("\\", "/")
            except ValueError:
                rel_str = str(path)
            print(f"- {rel_str} (score={score}) - {line}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
