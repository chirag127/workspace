"""Convert remaining broken links to TODO comments and write final unresolved list."""
import os, re
from collections import defaultdict

root = r'C:\D\oriz'
os.chdir(root)

broken = []
with open('.staging/_broken_links.txt','r',encoding='utf-8') as fh:
    for line in fh:
        line=line.rstrip('\n')
        if not line: continue
        parts = line.split('|',2)
        if len(parts) != 3: continue
        broken.append(parts)

# Group by source file
by_file = defaultdict(list)
for src,link,res in broken:
    by_file[src].append(link)

# For each file, find the [text](link) occurrence and replace with TODO comment.
# Pattern: \[([^\]]*)\]\(LINK\) where LINK matches exactly.
todo_count = 0
unresolved_records = []
for f, links in by_file.items():
    try:
        with open(f, 'r', encoding='utf-8') as fh:
            text = fh.read()
    except Exception as e:
        continue
    orig = text
    for link in set(links):
        # Escape link for regex
        esc = re.escape(link)
        pattern = re.compile(r'\[([^\]]*)\]\(' + esc + r'\)')
        def repl(m):
            txt = m.group(1)
            return f'<!-- TODO: broken link, was [{txt}]({link}) -->'
        new_text, n = pattern.subn(repl, text)
        if n > 0:
            text = new_text
            todo_count += n
            for _ in range(n):
                unresolved_records.append((f, link))
    if text != orig:
        with open(f, 'w', encoding='utf-8') as fh:
            fh.write(text)

# Write final unresolved list
out_path = r'C:\D\oriz\.staging\broken-links-remaining-2026-06-25.md'
with open(out_path, 'w', encoding='utf-8') as fh:
    fh.write('# Unresolved broken links — 2026-06-25\n\n')
    fh.write(f'Total unresolved links converted to TODO comments: **{len(unresolved_records)}**\n\n')
    fh.write('These targets did not exist in the post-restructure tree and had no supersession pointer.\n')
    fh.write('They were inline-replaced with `<!-- TODO: broken link, was [text](old/path) -->` comments.\n\n')
    fh.write('| Source file | Broken link |\n|---|---|\n')
    for src, link in sorted(set(unresolved_records)):
        # escape pipes
        src_e = src.replace('|','\\|')
        link_e = link.replace('|','\\|')
        fh.write(f'| `{src_e}` | `{link_e}` |\n')

print(f"TODO comments inserted: {todo_count}")
print(f"Unresolved file -> {out_path}")
