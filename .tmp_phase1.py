import subprocess, os, sys

ROOT = r"C:/D/oriz"
modules = []
with open(os.path.join(ROOT, ".gitmodules")) as f:
    for line in f:
        line = line.strip()
        if line.startswith("path"):
            modules.append(line.split("=",1)[1].strip())

def run(cmd, cwd):
    r = subprocess.run(cmd, cwd=cwd, shell=True, capture_output=True, text=True)
    return r.returncode, r.stdout.strip(), r.stderr.strip()

results = []
for m in modules:
    full = os.path.join(ROOT, m).replace("\\", "/")
    if not os.path.isdir(full):
        results.append((m, "missing", "no-dir"))
        continue
    if not os.path.isdir(os.path.join(full, ".git")) and not os.path.isfile(os.path.join(full, ".git")):
        results.append((m, "no-git", "not-a-repo"))
        continue
    code, out, err = run("git status --short", full)
    if code != 0:
        results.append((m, "error", f"status-fail: {err}"))
        continue
    dirty = bool(out)
    if not dirty:
        # check detached
        c2, head, _ = run("git symbolic-ref -q HEAD", full)
        if c2 != 0:
            results.append((m, "no", "detached"))
        else:
            results.append((m, "no", "clean"))
        continue
    # dirty: add, commit, push
    c, o, e = run("git add -A", full)
    if c != 0:
        results.append((m, "yes", f"add-fail: {e}"))
        continue
    c, o, e = run('git -c user.name="Chirag Singhal" -c user.email=chirag@oriz.in commit -m "wip: pre-v5-rename snapshot 2026-06-21"', full)
    if c != 0:
        results.append((m, "yes", f"commit-fail: {e[:200]}"))
        continue
    # get sha
    _, sha, _ = run("git rev-parse --short HEAD", full)
    c, o, e = run("git push origin HEAD:main", full)
    if c != 0:
        emsg = (e or o).lower()
        if "404" in emsg or "not found" in emsg or "repository not found" in emsg:
            results.append((m, "yes", "remote-deleted"))
        else:
            results.append((m, "yes", f"push-fail: {e[:200]}"))
        continue
    results.append((m, "yes", f"pushed {sha}"))

print("PATH\tDIRTY\tRESULT")
for r in results:
    print(f"{r[0]}\t{r[1]}\t{r[2]}")
