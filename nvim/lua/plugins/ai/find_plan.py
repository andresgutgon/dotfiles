"""Find the plan that belongs to a given project's Claude sessions.

Plans live globally in ~/.claude/plans/ with no project/session marker, so a
plan is mapped back to its project by content-matching it against that
project's session transcripts (~/.claude/projects/<slug>/*.jsonl). Prints the
newest matching plan path, or nothing if none belongs to the project.

Usage: python3 find_plan.py <cwd>
"""

import sys
import os
import glob
import re


def probe(path):
    # Longest line fragment with no chars that JSON would escape, so it can be
    # matched verbatim inside a transcript's escaped strings.
    best = ""
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                for piece in re.split(r'["\\\t]', line):
                    piece = piece.strip()
                    if len(piece) > len(best):
                        best = piece
    except OSError:
        return ""
    return best if len(best) >= 20 else ""


def main():
    cwd = sys.argv[1]
    home = os.path.expanduser("~")
    slug = "".join(c if c.isalnum() else "-" for c in cwd)
    proj = os.path.join(home, ".claude", "projects", slug)
    plans_dir = os.path.join(home, ".claude", "plans")

    if not os.path.isdir(proj):
        return

    remaining, mtimes = {}, {}
    for p in glob.glob(os.path.join(plans_dir, "*.md")):
        pr = probe(p)
        if pr:
            remaining[p] = pr
            mtimes[p] = os.path.getmtime(p)

    matched = {}
    for t in glob.glob(os.path.join(proj, "*.jsonl")):
        if not remaining:
            break
        try:
            with open(t, encoding="utf-8", errors="replace") as fh:
                data = fh.read()
        except OSError:
            continue
        for p in [p for p, pr in remaining.items() if pr in data]:
            matched[p] = mtimes[p]
            del remaining[p]

    if matched:
        print(max(matched, key=lambda p: matched[p]))


if __name__ == "__main__":
    main()
