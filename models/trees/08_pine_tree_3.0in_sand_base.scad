// ====================================================================
// 3D Printable Pine Tree with Multi-Feature Terrain Base
// Scale: 3.0 inches (76.2 mm tree height)
// Spec: Strictly adheres to Tree Base Creation Skill (tree_base_skill)
// - 1 Single Watertight Manifold Solid (NoError)
// - Base Color Standard: color([0.96, 0.94, 0.88]) Light Ivory Cream
// - Pure Polar Polyhedron Geometry (0 CSG cut artifacts)
// - Low-profile floor (0.4mm)
// - Zero-gap tree anchorage into mountain summit ground
// ====================================================================

use <../modules/tree_base.scad>;
use <08_pine_tree_3.0in.scad>;

module complete_pine_tree_3in_with_base() {
    union() {
        // 1. Terrain Base (Ivory Cream, Polar Polyhedron)
        multi_feature_terrain_base(
            r = 20.0,
            rings = 36,
            sectors = 80,
            min_h = 0.4,
            max_h = 6.8
        );
        
        // 2. Tree anchored inside mountain summit (zero-gap sink)
        translate([0, 0, 2.6]) {
            pine_tree_3in();
        }
    }
}

complete_pine_tree_3in_with_base();
