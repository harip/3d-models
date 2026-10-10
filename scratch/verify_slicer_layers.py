import sys
import collections

def load_stl(path):
    facets = []
    with open(path, "r") as f:
        lines = f.readlines()
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
    return facets

def check_floating(path):
    facets = load_stl(path)
    # Check downward facets
    downward_floating = []
    for norm, verts in facets:
        zs = [v[2] for v in verts]
        # strictly downward face: norm[2] < -0.1
        # mid-air: min(zs) > 0.05
        if norm[2] < -0.1 and min(zs) > 0.05:
            # check overhang angle
            # norm[2] = cos(theta). If theta > 135 deg (i.e. angle from vertical < 45 deg overhang),
            # normal_z < -0.707 is overhang > 45 deg
            downward_floating.append((norm, min(zs), max(zs)))
    return downward_floating

if __name__ == "__main__":
    floats = check_floating(sys.argv[1])
    print(f"File: {sys.argv[1]}")
    print(f"Downward mid-air facets: {len(floats)}")
    for norm, zmin, zmax in floats[:10]:
        print(f"  norm_z={norm[2]:.2f}, Z=[{zmin:.2f}, {zmax:.2f}]")
