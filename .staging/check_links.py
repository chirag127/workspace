import os, re, sys
root = r'C:\D\oriz'
os.chdir(root)

files = []
for dirpath, dirnames, filenames in os.walk('knowledge'):
    for fn in filenames:
        if fn.endswith('.md'):
            p = os.path.join(dirpath, fn)
            files.append(p.replace(os.sep, '/'))
for extra in ('AGENTS.md','README.md','CLAUDE.md'):
    if os.path.exists(extra):
        files.append(extra)

link_re = re.compile(r'\]\(([^)]+)\)')
total = 0
broken = []
all_records = []
for f in files:
    try:
        with open(f, 'r', encoding='utf-8', errors='replace') as fh:
            content = fh.read()
    except Exception as e:
        continue
    # Strip HTML comments before scanning (TODO markers are wrapped in <!-- ... -->)
    content = re.sub(r'<!--.*?-->', '', content, flags=re.DOTALL)
    dir_ = os.path.dirname(f)
    for m in link_re.finditer(content):
        link = m.group(1).strip()
        if not link:
            continue
        low = link.lower()
        if low.startswith('http://') or low.startswith('https://') or low.startswith('mailto:') or low.startswith('file://') or low.startswith('ftp://') or low.startswith('tel:'):
            continue
        if link.startswith('#'):
            continue
        # strip anchor
        target = link.split('#',1)[0]
        if not target:
            continue
        # whitespace in target -> probably not a path
        if ' ' in target and not (target.endswith('.md') or '/' in target or '\\' in target):
            # could still be a real path with space; keep checking
            pass
        if os.path.isabs(target):
            resolved = os.path.normpath(target)
        else:
            resolved = os.path.normpath(os.path.join(dir_, target))
        total += 1
        all_records.append((f, link, resolved))
        if not os.path.exists(resolved):
            broken.append((f, link, resolved))

os.makedirs(r'C:\D\oriz\.staging', exist_ok=True)
with open(r'C:\D\oriz\.staging\_all_links.txt','w',encoding='utf-8') as o:
    for r in all_records:
        o.write('|'.join(r)+'\n')
with open(r'C:\D\oriz\.staging\_broken_links.txt','w',encoding='utf-8') as o:
    for r in broken:
        o.write('|'.join(r)+'\n')

print(f"Total internal links scanned: {total}")
print(f"Broken before: {len(broken)}")
print("--- first 30 broken ---")
for r in broken[:30]:
    print(r[0], '->', r[1])
