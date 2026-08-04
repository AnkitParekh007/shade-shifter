"""Generate dependency-free ASCII STL fit/volume previews.

The preview meshes are unions of overlapping closed boxes. They are suitable for
quoting and fit visualization. Use the OpenSCAD source for final functional exports.
"""
from pathlib import Path

OUT = Path(__file__).resolve().parents[1] / "stl"
OUT.mkdir(exist_ok=True)

FACES = ((0, 2, 1), (0, 3, 2), (4, 5, 6), (4, 6, 7),
         (0, 1, 5), (0, 5, 4), (1, 2, 6), (1, 6, 5),
         (2, 3, 7), (2, 7, 6), (3, 0, 4), (3, 4, 7))

def box(extents, center):
    x, y, z = (v / 2 for v in extents); cx, cy, cz = center
    return [(cx+sx*x, cy+sy*y, cz+sz*z) for sx, sy, sz in
            ((-1,-1,-1),(1,-1,-1),(1,1,-1),(-1,1,-1),
             (-1,-1,1),(1,-1,1),(1,1,1),(-1,1,1))]

def write_stl(name, solids):
    lines = [f"solid {name}"]
    for vertices in solids:
        for a, b, c in FACES:
            lines += [" facet normal 0 0 0", "  outer loop",
                      f"   vertex {' '.join(map(str, vertices[a]))}",
                      f"   vertex {' '.join(map(str, vertices[b]))}",
                      f"   vertex {' '.join(map(str, vertices[c]))}",
                      "  endloop", " endfacet"]
    lines.append(f"endsolid {name}")
    (OUT / f"{name}.stl").write_text("\n".join(lines) + "\n", encoding="ascii")

def front():
    pieces = []
    lens_w, lens_h, bridge, rim, depth = 55, 39, 18, 5, 6
    spacing = lens_w + bridge
    for cx in (-spacing/2, spacing/2):
        pieces.extend((
            box((lens_w+2*rim, rim, depth), (cx, (lens_h+rim)/2, depth/2)),
            box((lens_w+2*rim, rim, depth), (cx, -(lens_h+rim)/2, depth/2)),
            box((rim, lens_h, depth), (cx-(lens_w+rim)/2, 0, depth/2)),
            box((rim, lens_h, depth), (cx+(lens_w+rim)/2, 0, depth/2))))
    pieces.append(box((bridge+6, 8, depth), (0, 5, depth/2)))
    return pieces

def temple(mirror=False):
    sign = -1 if mirror else 1
    return [box((145, 5, 9), (72.5, 0, 4.5)),
            box((45, 10, 15), (57.5, sign*0, 4.5))]

write_stl("front_fitcheck_preview", front())
write_stl("left_temple_volume_preview", temple())
write_stl("right_temple_volume_preview", temple(True))
print(f"Wrote preview meshes to {OUT}")
