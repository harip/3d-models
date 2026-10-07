# Tree Base Creation Skill

---
name: tree_base_skill
description: Master specification and pattern for generating 3D-printable OpenSCAD multi-feature tree terrain bases.
---

## Overview
Use this skill whenever generating or modifying 3D printable tree models with terrain bases.

## Core Rules & Constraints

1. **Always 1 Single Unified STL**:
   - Merge base + tree trunk inside `complete_*_tree()` into 1 watertight solid (`Status: NoError`).
   - Never output separate STL files for base and tree.

2. **Base Color Standard**:
   - **MUST** use `color([0.96, 0.94, 0.88])` (Light Ivory Cream) for base preview rendering. Do NOT alter.

3. **Pure Polar Polyhedron (0 CSG Cut Artifacts)**:
   - Generate mesh natively in polar coordinates $(R, \theta)$ (`rings = 36`, `sectors = 80`).
   - Do NOT use `intersection()` with a `cylinder()` (avoids dark CSG cut face preview artifacts).

4. **Low-Profile Floor**:
   - Minimum base floor thickness `base_min_thick = 0.4` mm (2 print layer height slices at 0.2mm).

5. **Zero-Gap Tree Anchorage**:
   - Translate tree trunk Z coordinate to `2.6` mm so flared roots sink $1.0\text{mm} - 1.5\text{mm}$ into the ground with zero floating gaps.

6. **360° Smooth & Sharp Heightfield Blend**:
   - 45% smooth Gaussian rolling hills + 55% terraced cliff stepping (`0.45 * raw_h + 0.55 * stepped_h`).

## Reusable Library Module
`use <../modules/tree_base.scad>;`

```openscad
multi_feature_terrain_base(
    r = 20.0,
    rings = 36,
    sectors = 80,
    min_h = 0.4,
    max_h = 6.8
);
```
