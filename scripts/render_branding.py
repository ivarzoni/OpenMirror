#!/usr/bin/env python3
"""Generate vector launcher resources; on macOS also export PNGs with CoreGraphics."""
import json
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
mark = json.loads((root / 'branding/mark.json').read_text())
res = root / 'app/src/main/res'

def path_of(shape):
    if shape['type'] == 'rect':
        x, y, w, h = shape['rect']
        r = shape['radius']
        return (f'M{x+r},{y} H{x+w-r} Q{x+w},{y} {x+w},{y+r} V{y+h-r} '
                f'Q{x+w},{y+h} {x+w-r},{y+h} H{x+r} Q{x},{y+h} {x},{y+h-r} '
                f'V{y+r} Q{x},{y} {x+r},{y} Z')
    return 'M' + ' L'.join(','.join(map(str, p)) for p in shape['points']) + (' Z' if shape['type'] == 'polygon' else '')

android, svg = [], []
for s in mark['shapes']:
    d = path_of(s)
    a = f'    <path android:pathData="{d}" android:fillColor="{s.get("fill", "#00000000")}"'
    v = f'  <path d="{d}" fill="{s.get("fill", "none")}"'
    if 'stroke' in s:
        a += f' android:strokeColor="{s["stroke"]}" android:strokeWidth="{s["width"]}" android:strokeLineCap="round" android:strokeLineJoin="round"'
        v += f' stroke="{s["stroke"]}" stroke-width="{s["width"]}" stroke-linecap="round" stroke-linejoin="round"'
    android.append(a + '/>\n')
    svg.append(v + '/>\n')
body = ''.join(android)
vector_start = '<vector xmlns:android="http://schemas.android.com/apk/res/android" android:width="108dp" android:height="108dp" android:viewportWidth="108" android:viewportHeight="108">\n'
(res / 'drawable/ic_launcher_foreground.xml').write_text(vector_start + body + '</vector>\n')
mono = body
for c in ['#DCEBF5', '#75E2C9', '#173B53', '#0B1D31']:
    mono = mono.replace(c, '#FFFFFF')
(res / 'drawable/ic_launcher_monochrome.xml').write_text(vector_start + mono + '</vector>\n')
(root / 'branding/openmirror-icon.svg').write_text(
    '<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 108 108">\n'
    f'  <rect width="108" height="108" rx="24" fill="{mark["background"]}"/>\n' + ''.join(svg) + '</svg>\n')
if sys.platform == 'darwin':
    subprocess.run(['swift', str(root / 'scripts/render_branding.swift'), str(root)], check=True)
else:
    print('Vectors generated. PNGs already included; regenerating them requires macOS and Swift.')
