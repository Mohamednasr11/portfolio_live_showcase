"""Gate: every (family, weight) the app declares must be a real face.

Flutter web's CanvasKit renderer resolves a TextStyle against the font's
*internal* name table, not the name pubspec declares. A miss does not error:
it silently renders in a system font (marked by a yellow double underline).
This checks the three things that have actually broken here.
"""

import os
import re
import sys

from fontTools.ttLib import TTFont

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
ALLOWED = {'Syne', 'DM Sans', 'Noto Sans Arabic'}


def declared_fonts():
    text = open(os.path.join(ROOT, 'pubspec.yaml'), encoding='utf-8').read()
    block = text.split('fonts:', 1)[1]
    out = []
    family = None
    weight = None
    asset = None
    for line in block.splitlines():
        m = re.match(r'\s*- family: (.+)$', line)
        if m:
            if asset and family:
                out.append((family, asset, weight))
                asset, weight = None, None
            family = m.group(1).strip().strip("'\"")
            continue
        m = re.match(r'\s*- asset: (\S+)', line)
        if m:
            if asset and family:
                out.append((family, asset, weight))
            asset = m.group(1).strip()
            weight = None
            continue
        m = re.match(r'\s*weight: (\d+)', line)
        if m and asset:
            weight = int(m.group(1))
    if asset and family:
        out.append((family, asset, weight))
    return out


def main():
    problems = []
    seen = {}
    for family, asset, weight in declared_fonts():
        if weight is None:
            weight = 400
        path = os.path.join(ROOT, asset)
        if not os.path.isfile(path):
            problems.append('%s: declared asset missing on disk' % asset)
            continue
        font = TTFont(path)
        internal = font['name'].getDebugName(1)
        actual = font['OS/2'].usWeightClass
        if internal != family:
            problems.append('%s: internal family %r != declared %r '
                            '(CanvasKit will fall back)' % (asset, internal, family))
        if actual != weight:
            problems.append('%s: usWeightClass %s != declared weight %s' % (asset, actual, weight))
        seen.setdefault(family, set()).add(weight)
    for family, weights in seen.items():
        gap = [w for w in range(min(weights), max(weights) + 100, 100) if w not in weights]
        if gap:
            problems.append('%s: declared weights have holes at %s' % (family, gap))
    for dirpath, _, names in os.walk(os.path.join(ROOT, 'lib')):
        for name in names:
            if not name.endswith('.dart'):
                continue
            src = open(os.path.join(dirpath, name), encoding='utf-8').read()
            for line in src.splitlines():
                if 'fontFamily' not in line:
                    continue
                for literal in re.findall(r"'([^']+)'", line):
                    if literal not in ALLOWED:
                        problems.append('%s: fontFamily %r is not a shipped family'
                                        % (name, literal))
    for p in problems:
        print('FAIL', p)
    if problems:
        sys.exit(1)
    faces = sum(len(w) for w in seen.values())
    print('OK %d faces, families %s' % (faces, sorted(seen)))


main()
