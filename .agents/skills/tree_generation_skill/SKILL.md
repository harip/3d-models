# Tree Generation Skill

---
name: tree_generation_skill
description: Automates creating OpenSCAD (.scad) models and rendering 3D-printable STL files under the trees directory whenever the user asks to generate or print a tree.
---

## Trigger Words & Intent
Trigger automatically whenever the user asks to create, generate, model, or print a tree:
- `generate a tree` / `create a tree` / `make a tree` / `print a tree`
- Any tree species request: `pine tree`, `cypress tree`, `banyan tree`, `oak tree`, `palm tree`, etc.
- Tree packs / swarms: `10-pack of trees`, `tree pack`, `trees varying from...`

## Core Workflow & Directory Rules

1. **File Locations (MUST be under trees directories)**:
   - **SCAD Files**: Always save to `models/trees/<model_name>.scad` (or `models/trees/<pack_name>/` for packs).
   - **STL Files**: Always render and save to `stls/trees/<model_name>.stl` (or `stls/trees/<pack_name>/` for packs).

2. **Automated Step-by-Step Execution**:
   1. **Create OpenSCAD Model**: Write the parametric OpenSCAD script under `models/trees/`.
   2. **Render STL Automatically**: Run OpenSCAD CLI:
      ```bash
      openscad -o stls/trees/<model_name>.stl models/trees/<model_name>.scad
      ```
   3. **Verify Manifold Status**: Check CLI output for:
      - `Top level object is a 3D object (manifold)`
      - `Status: NoError`
   4. **Report Results**: Provide direct markdown file links to both the `.scad` source and `.stl` output.

3. **Tree Modeling Specs (`tree_base_skill` integration)**:
   - **1 Single Watertight STL**: Merge trunk + foliage (+ base) into 1 manifold solid.
   - **Supportless Printing**: Overhang angles $\le 45^\circ$ from vertical (0% print supports required).
   - **Base Standard**:
     - *Standalone Tree*: Smooth flared root foot flat at Z=0 for high stability and bed adhesion.
     - *Terrain Base Tree*: Light Ivory Cream `color([0.96, 0.94, 0.88])`, pure polar polyhedron geometry (0 CSG cut artifacts), low-profile 0.4mm floor, and 2.6mm zero-gap trunk anchorage into mountain summit.
