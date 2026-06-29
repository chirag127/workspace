#!/usr/bin/env python3
"""rename-agent-rules-to-rules-agent - one-shot refactor: knowledge/agent-rules/ -> knowledge/rules/agent/.

Two-step:
  1. git mv every file (preserves rename history per-file).
  2. Rewrite all link references via regex (handles relative + absolute forms).

Idempotent: re-running after success is a no-op. Skips dest paths that already exist.

Usage:
  python scripts/rename-agent-rules-to-rules-agent.py [--dry-run]
"""
from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SOURCE_DIR = REPO_ROOT / "knowledge" / "agent-rules"
TARGET_DIR = REPO_ROOT / "knowledge" / "rules" / "agent"

# Link patterns: both bare `agent-rules/foo.md` and `./agent-rules/foo.md`, in
# markdown links `[label](path)`, wikilinks `[[path]]`, frontmatter `related:`
# entries, and import lines `@knowledge/agent-rules/foo.md`. Single regex
# matches the segment 'agent-rules' wherever it appears as a path component.
PATH_RE = re.compile(r"(?<![A-Za-z0-9_-])agent-rules(?=/)")


def run(cmd: list[str], dry: bool) -> None:
    print(f"  $ {' '.join(cmd)}")
    if dry:
        return
    result = subprocess.run(cmd, cwd=REPO_ROOT, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"    FAILED: {result.stderr.strip()}", file=sys.stderr)
        sys.exit(result.returncode)


def git_mv_tree(dry: bool) -> int:
    if not SOURCE_DIR.is_dir():
        print(f"source {SOURCE_DIR} not found - already migrated?")
        return 0
    TARGET_DIR.parent.mkdir(parents=True, exist_ok=True)
    moved = 0
    for src in sorted(SOURCE_DIR.rglob("*")):
        if not src.is_file():
            continue
        rel = src.relative_to(SOURCE_DIR)
        dst = TARGET_DIR / rel
        if dst.exists():
            print(f"  skip (exists): {dst}")
            continue
        dst.parent.mkdir(parents=True, exist_ok=True)
        run(["git", "mv", str(src.relative_to(REPO_ROOT)), str(dst.relative_to(REPO_ROOT))], dry)
        moved += 1
    return moved


def rewrite_links(dry: bool) -> int:
    """Scan all .md and .json files in repo, regex-rewrite agent-rules -> rules/agent."""
    touched = 0
    for ext in ("*.md", "*.json", "*.jsonc"):
        for path in REPO_ROOT.rglob(ext):
            # Skip vendored / generated content
            parts_lower = {p.lower() for p in path.parts}
            if any(seg in parts_lower for seg in ("node_modules", ".git", "dist", "build", "repos")):
                continue
            try:
                content = path.read_text(encoding="utf-8")
            except (OSError, UnicodeDecodeError):
                continue
            if "agent-rules" not in content:
                continue
            new_content = PATH_RE.sub("rules/agent", content)
            if new_content == content:
                continue
            print(f"  rewrite: {path.relative_to(REPO_ROOT)}")
            if not dry:
                path.write_text(new_content, encoding="utf-8")
            touched += 1
    return touched


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--dry-run", action="store_true", help="Print actions without executing.")
    args = p.parse_args()

    print(f"== Step 1: git mv tree {SOURCE_DIR.name} -> rules/agent ==")
    moved = git_mv_tree(args.dry_run)
    print(f"  moved: {moved} files\n")

    print("== Step 2: rewrite link references ==")
    touched = rewrite_links(args.dry_run)
    print(f"  rewrote: {touched} files\n")

    if not args.dry_run:
        # Sanity: confirm zero residual agent-rules refs (excluding the script itself).
        result = subprocess.run(
            ["git", "grep", "-l", "agent-rules"],
            cwd=REPO_ROOT, capture_output=True, text=True,
        )
        lingering = [
            line for line in result.stdout.splitlines()
            if line and "rename-agent-rules-to-rules-agent.py" not in line
        ]
        if lingering:
            print(f"WARNING: {len(lingering)} files still contain 'agent-rules':")
            for f in lingering[:20]:
                print(f"  {f}")
        else:
            print("clean: no lingering agent-rules references")
    return 0


if __name__ == "__main__":
    sys.exit(main())
