import sys

def analyze_severe(path):
    with open(path, "r") as f:
        lines = f.readlines()
    facets = []
    cur_norm = None
    cur_verts = []
    for line in lines:
        line = line.strip()
        if line.startswith("facet normal"):
            parts = line.split()
            cur_norm = (float(parts[2]), float(parts[3]), float(parts[4]))
            cur_verts = []
        elif line.startswith("vertex"):
            parts = line.split()
            cur_verts.append((float(parts[1]), float(parts[2]), float(parts[3])))
        elif line.startswith("endfacet"):
            facets.append((cur_norm, cur_verts))
            
    # Overhang angle from vertical Z axis:
    # theta = angle between normal and (0,0,-1).
    # If face points downward (norm[2] < 0):
    # If norm[2] < -0.7071 (i.e. closer to horizontal than 45 degrees, e.g. -0.8, -0.9, -1.0)
    # AND Z > 0.05 mm (not on bed):
    severe = []
    for norm, verts in facets:
        zs = [v[2] for v in verts]
        min_z = min(zs)
        max_z = max(zs)
        if norm[2] < -0.7071 and min_z > 0.05:
            severe.append((norm, min_z, max_z, verts))
    return severe

if __name__ == "__main__":
    severe = analyze_severe(sys.argv[1])
    print(f"File: {sys.argv[1]}")
    print(f"Severe overhangs (> 45 deg from vertical, Z > 0.05): {len(severe)}")
    for norm, zmin, zmax, verts in severe[:15]:
        xs = [v[0] for v in verts]
        ys = [v[1] for v in verts]
        print(f"  norm={norm}, Z=[{zmin:.2f}, {zmax:.2f}], X=[{min(xs):.1f}, {max(xs):.1f}], Y=[{min(ys):.1f}, {max(ys):.1f}]")
