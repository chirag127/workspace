#!/usr/bin/env python3
"""okf-index-lookup — grep knowledge/index.md for a term and emit matching concept-file paths.

Standalone. No Headroom dependency. Stdlib only.

Usage:
    python scripts/okf-index-lookup.py <term> [--root <repo-root>] [--limit N]

Behaviour:
- Loads knowledge/index.md relative to <repo-root> (default: parent of this script's dir).
- Case-insensitive substring match against each line.
- Extracts every markdown link target on matching lines: `[label](./path/to/file.md)`.
- Filters to `.md` paths (drops anchors, external URLs).
- Resolves each path relative to knowledge/index.md's directory and prints absolute paths
  that exist on disk. Deduped, in first-seen order.
- Exit 0 if at least one path printed; 1 otherwise. Empty stdout when no match.
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

LINK_RE = re.compile(r"\[[^\]]+\]\(([^)]+)\)")


def find_repo_root(start: Path) -> Path:
    # Default: parent of scripts/ — i.e. the repo root that owns knowledge/index.md.
    return start.resolve().parent.parent


def lookup(term: str, repo_root: Path, limit: int | None) -> list[Path]:
    index_path = repo_root / "knowledge" / "index.md"
    if not index_path.is_file():
        print(f"error: index not found at {index_path}", file=sys.stderr)
        sys.exit(2)

    needle = term.lower()
    index_dir = index_path.parent
    seen: set[Path] = set()
    out: list[Path] = []

    for raw in index_path.read_text(encoding="utf-8", errors="replace").splitlines():
        if needle not in raw.lower():
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
            out.append(resolved)
            if limit and len(out) >= limit:
                return out
    return out


def main() -> int:
    p = argparse.ArgumentParser(description="Grep knowledge/index.md for a term.")
    p.add_argument("term", help="Case-insensitive substring to search for.")
    p.add_argument(
        "--root",
        type=Path,
        default=None,
        help="Repo root (default: parent of this script's dir).",
    )
    p.add_argument("--limit", type=int, default=None, help="Cap on matches printed.")
    args = p.parse_args()

    root = args.root if args.root else find_repo_root(Path(__file__))
    paths = lookup(args.term, root, args.limit)
    for path in paths:
        print(path)
    return 0 if paths else 1


if __name__ == "__main__":
    sys.exit(main())
