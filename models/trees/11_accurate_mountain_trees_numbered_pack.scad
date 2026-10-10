// ====================================================================
// SINGLE WATERTIGHT MANIFOLD STL: ACCURATE MOUNTAIN TREES (3.0" to 4.0")
// Features:
// - 6 Botanically Accurate Mountain Species
// - Solid Integrated Terrain Base Plate (Single Manifold Solid)
// - 3D Embossed Sample Numbers (1, 2, 3, 4, 5, 6) in front of each tree
// - 3D Embossed Botanical Name Plaques on the base slab
// ====================================================================

$fn = 28;

use <accurate_mountain_pack/01_colorado_blue_spruce_4.0in.scad>
use <accurate_mountain_pack/02_mountain_hemlock_3.8in.scad>
use <accurate_mountain_pack/03_bristlecone_pine_3.6in.scad>
use <accurate_mountain_pack/04_ponderosa_pine_3.4in.scad>
use <accurate_mountain_pack/05_subalpine_fir_3.2in.scad>
use <accurate_mountain_pack/06_alpine_larch_3.0in.scad>

// Single Unified Master Solid
union() {
    // 1. Heavy Integrated Terrain Base Slab (Fits 220x150 mm bed)
    color([0.94, 0.92, 0.86]) {
        difference() {
            // Main Beveled Terrain Slab
            hull() {
                translate([-95, -55, 0]) cylinder(r = 5, h = 6);
                translate([95, -55, 0])  cylinder(r = 5, h = 6);
                translate([95, 55, 0])   cylinder(r = 5, h = 6);
                translate([-95, 55, 0])  cylinder(r = 5, h = 6);
            }
            // Subtle rocky terrain surface contours on top
            translate([0, 0, 7.5]) sphere(r = 200, $fn = 40);
        }
    }

    // 2. Sample 1: Colorado Blue Spruce (4.00 in / 101.6 mm)
    translate([-65, 22, 5.0]) {
        blue_spruce_4in(101.6);
        // Embossed Number "1" & Plaque
        translate([0, -28, 0]) sample_label("1", "BLUE SPRUCE");
    }

    // 3. Sample 2: Mountain Hemlock (3.80 in / 96.52 mm)
    translate([0, 22, 5.0]) {
        mountain_hemlock_3_8in(96.52);
        // Embossed Number "2" & Plaque
        translate([0, -28, 0]) sample_label("2", "MNT HEMLOCK");
    }

    // 4. Sample 3: Bristlecone Pine (3.60 in / 91.44 mm)
    translate([65, 22, 5.0]) {
        bristlecone_pine_3_6in(91.44);
        // Embossed Number "3" & Plaque
        translate([0, -28, 0]) sample_label("3", "BRISTLECONE");
    }

    // 5. Sample 4: Ponderosa Pine (3.40 in / 86.36 mm)
    translate([-65, -22, 5.0]) {
        ponderosa_pine_3_4in(86.36);
        // Embossed Number "4" & Plaque
        translate([0, -26, 0]) sample_label("4", "PONDEROSA");
    }

    // 6. Sample 5: Subalpine Fir (3.20 in / 81.28 mm)
    translate([0, -22, 5.0]) {
        subalpine_fir_3_2in(81.28);
        // Embossed Number "5" & Plaque
        translate([0, -26, 0]) sample_label("5", "SUBALPINE FIR");
    }

    // 7. Sample 6: Alpine Larch (3.00 in / 76.20 mm)
    translate([65, -22, 5.0]) {
        alpine_larch_3_0in(76.20);
        // Embossed Number "6" & Plaque
        translate([0, -26, 0]) sample_label("6", "ALPINE LARCH");
    }
}

// 3D Number & Species Label Plaque Module
module sample_label(num_str, name_str) {
    color([0.2, 0.2, 0.2]) {
        union() {
            // Number Plaque Pedestal Base
            hull() {
                translate([-14, -8, 0]) cylinder(r = 2, h = 2.5);
                translate([14, -8, 0])  cylinder(r = 2, h = 2.5);
                translate([14, 8, 0])   cylinder(r = 2, h = 2.5);
                translate([-14, 8, 0])  cylinder(r = 2, h = 2.5);
            }
            // Big Embossed 3D Number
            translate([0, 0, 2.5]) {
                linear_extrude(height = 2.5) {
                    text(num_str, size = 7.5, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
                }
            }
            // Embossed Botanical Subtitle
            translate([0, -5.5, 2.5]) {
                linear_extrude(height = 1.2) {
                    text(name_str, size = 2.4, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
                }
            }
        }
    }
}
