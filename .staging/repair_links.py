"""Repair broken markdown links by fuzzy basename match.

Strategy:
1. Build index of every existing file under knowledge/ keyed by basename.
2. For each broken link, take basename of the target.
3. If exactly one file with that basename exists -> use it (rewrite path relative to source file).
4. If multiple matches -> pick the shortest path (often the canonical one) unless source file is in a category subdir
   in which case prefer one in the same top-level category.
5. If zero matches -> mark as TODO.
"""
import os, re, json
from collections import defaultdict

root = r'C:\D\oriz'
os.chdir(root)

# build index
index = defaultdict(list)  # basename -> list of relative paths (posix)
for dirpath, dirnames, filenames in os.walk('knowledge'):
    for fn in filenames:
        if fn.endswith('.md'):
            p = os.path.join(dirpath, fn).replace(os.sep, '/')
            index[fn].append(p)
for extra in ('AGENTS.md','README.md','CLAUDE.md'):
    if os.path.exists(extra):
        index[extra].append(extra)

# read broken links
broken = []
with open(r'C:\D\oriz\.staging\_broken_links.txt','r',encoding='utf-8') as fh:
    for line in fh:
        line = line.rstrip('\n')
        if not line: continue
        parts = line.split('|', 2)
        if len(parts) != 3: continue
        broken.append(parts)

# build supersession map by reading frontmatter `supersedes:` and `superseded_by:` (or similar) plus pointer lines
# (Loose: scan all .md for `superseded_by:` or `→` pointers)
supersession = {}  # old_basename -> new_relative_path (posix relative to repo root)
for dirpath, dirnames, filenames in os.walk('knowledge'):
    for fn in filenames:
        if not fn.endswith('.md'): continue
        p = os.path.join(dirpath, fn).replace(os.sep, '/')
        try:
            with open(p, 'r', encoding='utf-8', errors='replace') as fh:
                text = fh.read()
        except: continue
        # look for frontmatter `supersedes: path` lines
        m = re.search(r'^supersedes:\s*(.+?)$', text, re.MULTILINE)
        if m:
            old = m.group(1).strip().strip('"').strip("'")
            old_bn = os.path.basename(old)
            if old_bn:
                supersession[old_bn] = p

def rel_from(src_file, target_path):
    src_dir = os.path.dirname(src_file) or '.'
    rel = os.path.relpath(target_path, start=src_dir)
    return rel.replace(os.sep, '/')

# Determine top-level category of a path under knowledge/
def top_cat(path):
    p = path.replace('\\','/')
    parts = p.split('/')
    if parts[0] == 'knowledge' and len(parts) >= 3:
        return parts[1] + '/' + parts[2] if parts[1] in ('architecture','decisions','rules','runbooks','services') else parts[1]
    return parts[0] if parts else ''

# Build per-file edit list: file -> list of (old_link, new_link_or_None)
edits = defaultdict(list)
repairs = []
unresolved = []

for src_file, link, resolved in broken:
    target = link.split('#',1)[0]
    anchor = ''
    if '#' in link:
        anchor = '#' + link.split('#',1)[1]
    bn = os.path.basename(target.rstrip('/'))
    if not bn:
        unresolved.append((src_file, link, 'empty-basename'))
        continue
    new_path = None
    # 1. supersession map
    if bn in supersession:
        new_path = supersession[bn]
    # 2. unique basename match in index
    elif bn in index:
        candidates = index[bn]
        if len(candidates) == 1:
            new_path = candidates[0]
        else:
            # prefer candidate in same top-level category as source
            src_top = top_cat(src_file)
            same_cat = [c for c in candidates if top_cat(c) == src_top]
            if len(same_cat) == 1:
                new_path = same_cat[0]
            elif same_cat:
                new_path = sorted(same_cat, key=len)[0]
            else:
                new_path = sorted(candidates, key=len)[0]
    # 3. try with .md added
    elif not bn.endswith('.md') and (bn + '.md') in index:
        candidates = index[bn + '.md']
        new_path = sorted(candidates, key=len)[0] if candidates else None

    if new_path:
        new_link = rel_from(src_file, new_path) + anchor
        edits[src_file].append((link, new_link))
        repairs.append((src_file, link, new_link))
    else:
        unresolved.append((src_file, link, 'no-match'))

# Apply edits
applied = 0
for f, pairs in edits.items():
    try:
        with open(f, 'r', encoding='utf-8') as fh:
            text = fh.read()
    except Exception as e:
        continue
    orig = text
    for old, new in pairs:
        # Replace `](old)` with `](new)` -- exact substring including the brackets
        needle = f']({old})'
        repl = f']({new})'
        if needle in text:
            text = text.replace(needle, repl)
            applied += 1
    if text != orig:
        with open(f, 'w', encoding='utf-8') as fh:
            fh.write(text)

# Write unresolved for human review
out_path = r'C:\D\oriz\.staging\broken-links-remaining-2026-06-25.md'
with open(out_path, 'w', encoding='utf-8') as fh:
    fh.write('# Unresolved broken links (2026-06-25)\n\n')
    fh.write(f'Total unresolved: {len(unresolved)}\n\n')
    fh.write('| Source file | Broken link | Reason |\n|---|---|---|\n')
    for src, link, reason in unresolved:
        fh.write(f'| `{src}` | `{link}` | {reason} |\n')

print(f"Repair candidates: {len(repairs)}")
print(f"Substitutions applied: {applied}")
print(f"Unresolved: {len(unresolved)}")
print(f"Unresolved list -> {out_path}")
