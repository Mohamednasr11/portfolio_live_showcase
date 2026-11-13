"""Provision the three brand families so CanvasKit (Flutter web) can resolve
every weight we ask for.

Two defects made heavy text silently fall back to a system font in the web
build (visible as CanvasKit's yellow double underline):
  1. Google's static instances self-report family "Syne ExtraBold" /
     "DM Sans Medium", so declaring them under "Syne"/"DM Sans" + weight
     leaves no face registered for that family/weight pair.
  2. DM Sans 600/700/800 were never downloaded at all.

This script downloads the missing weights and rewrites every face's name table
so nameID 1 == the declared family and nameID 2 == the weight, with
usWeightClass matching. Re-run any time; it is idempotent.
"""

import io
import os
import re
import sys
import urllib.request

from fontTools.ttLib import TTFont

FONTS = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'assets', 'fonts')
UA = 'Mozilla/5.0'

FAMILIES = {
    'Syne': [400, 500, 600, 700, 800],
    'DM Sans': [300, 400, 500, 600, 700, 800],
    'Cairo': [400, 500, 600, 700, 800],
}

WEIGHT_NAME = {
    100: 'Thin', 200: 'ExtraLight', 300: 'Light', 400: 'Regular',
    500: 'Medium', 600: 'SemiBold', 700: 'Bold', 800: 'ExtraBold', 900: 'Black',
}


def css_url(family, weights):
    return 'https://fonts.googleapis.com/css2?family=%s:wght@%s&display=swap' % (
        family.replace(' ', '+'), ';'.join(str(w) for w in weights))


def download(family, weights):
    """Return {weight: bytes} parsed out of the @font-face block."""
    req = urllib.request.Request(css_url(family, weights), headers={'User-Agent': UA})
    css = urllib.request.urlopen(req, timeout=30).read().decode('utf-8')
    out = {}
    for block in css.split('@font-face {')[1:]:
        m_w = re.search(r'font-weight:\s*(\d+)', block)
        m_u = re.search(r'url\((https://[^)]+)\)', block)
        if m_w and m_u:
            w = int(m_w.group(1))
            out[w] = urllib.request.urlopen(
                urllib.request.Request(m_u.group(1), headers={'User-Agent': UA}),
                timeout=60).read()
    missing = [w for w in weights if w not in out]
    if missing:
        raise SystemExit('%s: google did not serve %s' % (family, missing))
    return out


def fix_names(path, family, weight):
    font = TTFont(path)
    sub = WEIGHT_NAME[weight]
    values = {1: family, 2: sub, 4: '%s %s' % (family, sub),
              6: '%s-%s' % (family.replace(' ', ''), sub), 16: family, 17: sub}
    names = font['name']
    for pid, eid, lang in ((1, 0, 0), (3, 1, 0x409)):
        for name_id, value in values.items():
            names.setName(value, name_id, pid, eid, lang)
    font['OS/2'].usWeightClass = weight
    bold = bool(font['OS/2'].fsSelection & 0x20)
    font['head'].macStyle = (font['head'].macStyle & ~1) | (1 if bold else 0)
    font.save(path)


def main():
    os.makedirs(FONTS, exist_ok=True)
    for family, weights in FAMILIES.items():
        data = download(family, weights)
        for w in weights:
            slug = family.replace(' ', '')
            path = os.path.join(FONTS, '%s-%s.ttf' % (slug, WEIGHT_NAME[w]))
            with open(path, 'wb') as fh:
                fh.write(data[w])
            fix_names(path, family, w)
            print('wrote', os.path.basename(path))
    print('---- verification ----')
    for family in FAMILIES:
        for w in FAMILIES[family]:
            slug = family.replace(' ', '')
            p = os.path.join(FONTS, '%s-%s.ttf' % (slug, WEIGHT_NAME[w]))
            t = TTFont(p)
            print('%-26s 1=%-18s 2=%-10s 16=%-18s 17=%-10s us/2=%s' % (
                os.path.basename(p), t['name'].getDebugName(1), t['name'].getDebugName(2),
                t['name'].getDebugName(16), t['name'].getDebugName(17),
                t['OS/2'].usWeightClass))


if __name__ == '__main__':
    main()
