# TREE BASE CREATION SKILL & MASTER SPECIFICATION

## Overview
This document defines the consolidated rules, mathematical heightfield formulas, rendering techniques, and OpenSCAD patterns for generating **3D-printable terrain bases** for miniature tree models.

---

## Core Principles & Hard Constraints

1. **Always 1 Single Unified STL File**:
   - Every tree script MUST output **1 single watertight (manifold) STL file** per tree.
   - The terrain base and tree trunk MUST be combined inside a top-level `union()` block (`complete_*_tree()`).
   - Never generate separate STL parts for base and tree.

2. **Base Color Standard**:
   - **ALWAYS** use `color([0.96, 0.94, 0.88])` (Light Ivory Cream) for the terrain base polyhedron.
   - DO NOT alter or override this color vector.

3. **Pure Polar Polyhedron Geometry (No CSG Cut Artifacts)**:
   - **Do NOT** use `intersection()` with a `cylinder()` to trim square grid polyhedrons. OpenSCAD CSG fast preview (F5) renders intersected cut faces in dark grey (`[0.5, 0.5, 0.5]`).
   - **Do** generate the polyhedron natively in polar coordinates $(R, \theta)$:
     - `rings = 36` (concentric radial rings)
     - `sectors = 80` (angular divisions)
     - Top center vertex $(0,0,z(0,0))$ and bottom center vertex $(0,0,0)$.
     - Automatically yields a smooth, watertight circular disc boundary with zero CSG cut artifacts.

4. **Low-Profile Base Floor Thickness**:
   - Set `base_min_thick = 0.4` mm (2 print layer height slices at 0.2mm layer height).
   - Keeps the base floor low-profile so terrain slopes transition smoothly onto the 3D printer bed.

5. **Seamless Tree Anchorage (No Floating Tree)**:
   - Translate the tree trunk down into the summit mountain surface (e.g. `translate([x, y, 2.6])`).
   - Ensures flared trunk roots sink $1.0\text{mm} - 1.5\text{mm}$ into the ground with zero floating gaps.

---

## Procedural Terrain Heightfield Math

The terrain combines a 360° balance of **smooth rolling hills** and **sharp rock crags/needles**:

```openscad
// 1. Smooth Rolling Hills & Gentle Knolls
smooth_h1 = 3.5 * exp(-((wx + 0.2)*(wx + 0.2) + (wy + 0.2)*(wy + 0.2)) / 32);
smooth_h2 = 2.8 * exp(-((x + 7.5)*(x + 7.5) + (y - 5.5)*(y - 5.5)) / 22);
smooth_h3 = 2.5 * exp(-((x - 7.0)*(x - 7.0) + (y + 7.0)*(y + 7.0)) / 20);
smooth_h4 = 2.2 * exp(-((x + 6.0)*(x + 6.0) + (y + 8.0)*(y + 8.0)) / 18);
smooth_waves = 1.4 * sin(x * 0.22) * cos(y * 0.20);

// 2. Sharp Rock Needle Spires & Radial Crags
sharp_p1 = 2.4 * exp(-((x - 8.5)*(x - 8.5) + (y - 7.5)*(y - 7.5)) / 5.5);
sharp_p2 = 2.2 * exp(-((x + 2.0)*(x + 2.0) + (y - 12.0)*(y - 12.0)) / 5.0);
sharp_p3 = 2.0 * exp(-((x - 11.5)*(x - 11.5) + (y + 1.5)*(y + 1.5)) / 4.5);

radial_crags   = 1.4 * pow(1.0 - abs(sin(4 * angle + 2.5 * norm_d)), 0.6);
radial_gullies = -1.3 * pow(abs(cos(3 * angle - 2.0 * norm_d)), 0.6);

// 3. Slope Blending (50% Smooth Slopes + 50% Terraced Cliff Ledges)
step_height = 1.5;
norm_h = raw_h / step_height;
floor_h = floor(norm_h);
frac_h = norm_h - floor_h;
cliff_frac = pow(frac_h, 3.0) / (pow(frac_h, 3.0) + pow(1.0 - frac_h, 3.0));
stepped_h = (floor_h + cliff_frac) * step_height;

blended_h = 0.45 * raw_h + 0.55 * stepped_h;
z_final = min_h + max(0, blended_h - min_h) * taper;
```

---

## Standard OpenSCAD Script Structure

```openscad
use <../modules/tree_base.scad>;

// Tree parameters
tree_total_h = 40.0;
base_radius  = 20.0;
base_min_thick = 0.4;
max_mountain_h = 6.8;

// Tree assembly module
module complete_tree() {
    union() {
        // 1. Terrain Base
        multi_feature_terrain_base(
            r = base_radius,
            rings = 36,
            sectors = 80,
            min_h = base_min_thick,
            max_h = max_mountain_h
        );
        
        // 2. Tree Trunk & Canopy anchored inside mountain summit
        translate([-0.2, -0.2, 2.6]) {
            tree_trunk();
            tree_foliage();
        }
    }
}

// Render complete tree
complete_tree();
```

---

## Verification Checklist
Before saving any tree model, run:
```bash
openscad -o stls/trees/model_name.stl models/trees/model_name.scad
```
Check CLI output for:
- `Top level object is a 3D object (manifold):`
- `Status: NoError`
