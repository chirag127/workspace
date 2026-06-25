#!/usr/bin/env python3
"""Split repos/ into repos/own/<slug> and repos/frk/<slug> per fork status."""
import subprocess, sys
from pathlib import Path

UMBRELLA = Path("c:/D/oriz")
FRK = {"ai-rewrite-bs-ext", "claude-notifications-cli", "dearrow-plus-bs-ext", "freellmapi", "omniroute"}


def list_submodules():
    r = subprocess.run("git submodule status", cwd=UMBRELLA, shell=True, capture_output=True, text=True)
    return [line.strip().split(maxsplit=2)[1] for line in r.stdout.splitlines() if line.strip()]


def main():
    apply = "--apply" in sys.argv
    paths = list_submodules()
    plan = []
    for p in paths:
        if not p.startswith("repos/"):
            continue
        slug = p[len("repos/"):]
        if "/" in slug:
            print(f"[skip] {p} — already nested")
            continue
        bucket = "frk" if slug in FRK else "own"
        plan.append((p, f"repos/{bucket}/{slug}", bucket))

    print(f"=== PLAN: split {len(plan)} submodules ===\n")
    for bucket in ("own", "frk"):
        items = [(o, n) for o, n, b in plan if b == bucket]
        print(f"  [{bucket}] ({len(items)} repos)")
        for o, n in items:
            print(f"    {o}  ->  {n}")
        print()

    if not apply:
        print("(dry run; pass --apply)")
        return

    print("=== APPLYING ===\n")
    failed = []
    for i, (o, n, b) in enumerate(plan, 1):
        Path(UMBRELLA / f"repos/{b}").mkdir(parents=True, exist_ok=True)
        r = subprocess.run(f'git mv "{o}" "{n}"', cwd=UMBRELLA, shell=True, capture_output=True, text=True)
        marker = "OK" if r.returncode == 0 else "FAIL"
        print(f"  [{i:2d}/{len(plan)}] {marker} {o} -> {n}")
        if r.returncode != 0:
            failed.append((o, n, r.stderr.strip()[:200]))
            print(f"          stderr: {r.stderr.strip()[:200]}")

    print(f"\nDone. {len(plan)-len(failed)} ok, {len(failed)} failed.")
    if failed:
        sys.exit(1)


if __name__ == "__main__":
    main()
