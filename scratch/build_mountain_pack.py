import os

# Ensure directories exist
os.makedirs("models/trees/mountain_pack", exist_ok=True)
os.makedirs("stls/trees/mountain_pack", exist_ok=True)
os.makedirs("scratch", exist_ok=True)

mountain_scad_content = """// ====================================================================
// 3D Printable Mountain Trees Variety Pack (Heights 2.0in to 3.0in)
// Botanically Realistic Mountain Species:
// 1. Colorado Blue Spruce (3.00 in / 76.2 mm)
// 2. Mountain Hemlock    (2.80 in / 71.12 mm)
// 3. Ponderosa Pine      (2.60 in / 66.04 mm)
// 4. Subalpine Fir       (2.40 in / 60.96 mm)
// 5. Alpine Larch        (2.20 in / 55.88 mm)
// 6. Mountain Cypress    (2.00 in / 50.80 mm)
// 100% Supportless Manifold Solids for FDM 3D Printing
// ====================================================================

$fn = 28;

// --- 1. COLORADO BLUE SPRUCE (3.00 in / 76.2 mm) ---
module blue_spruce(h = 76.2) {
    union() {
        // Trunk & Base Foot
        color([0.38, 0.24, 0.14]) {
            cylinder(r1 = 7.5, r2 = 3.6, h = 4.5);
            hull() {
                translate([0, 0, 3.0]) cylinder(r = 3.6, h = h * 0.25);
                translate([0, 0, h * 0.80]) cylinder(r1 = 2.5, r2 = 1.0, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([6.8, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                        translate([3.2, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                    }
            }
        }
        // Slate Blue-Green Foliage Tiers
        color([0.22, 0.45, 0.42]) {
            for (t = [0 : 6]) {
                tz = h * (0.20 + t * 0.11);
                r_b = 23.0 * (1 - t / 7.2);
                r_t = r_b * 0.6;
                th = 11.5 * (1 - t / 9.0);
                translate([0, 0, tz]) {
                    union() {
                        translate([0, 0, -th * 0.15])
                            cylinder(r1 = r_b * 0.60, r2 = r_t * 0.85, h = th * 1.15);
                        for (i = [0 : 6]) {
                            rotate([0, 0, i * (360 / 7) + t * 18]) {
                                rotate([15, 0, 0]) {
                                    hull() {
                                        translate([0, 0, th * 0.60]) scale([1.2, 0.8, 0.8]) sphere(r = r_t * 0.42, $fn = 10);
                                        translate([0, r_b * 0.85, -th * 0.12]) scale([1.4, 0.6, 0.6]) sphere(r = r_b * 0.18, $fn = 10);
                                    }
                                    for (k = [-2 : 2]) {
                                        rotate([0, 0, k * 12])
                                            translate([0, r_b * 0.90, -th * 0.18])
                                                rotate([34, 0, 0])
                                                    cylinder(r1 = r_b * 0.10, r2 = 0.2, h = th * 0.45, $fn = 6);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // Top Leader Cone
            translate([0, 0, h - 8.5])
                cylinder(r1 = 1.8, r2 = 0.3, h = 8.5);
        }
    }
}

// --- 2. MOUNTAIN HEMLOCK (2.80 in / 71.12 mm) ---
module mountain_hemlock(h = 71.12) {
    union() {
        // Trunk
        color([0.36, 0.22, 0.13]) {
            cylinder(r1 = 7.0, r2 = 3.4, h = 4.5);
            hull() {
                translate([0, 0, 3.0]) cylinder(r = 3.4, h = h * 0.28);
                translate([0, 0, h * 0.82]) cylinder(r1 = 2.4, r2 = 0.9, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([6.2, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                        translate([3.0, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                    }
            }
        }
        // Deep Forest Green Drooping Boughs
        color([0.16, 0.42, 0.22]) {
            for (t = [0 : 6]) {
                tz = h * (0.22 + t * 0.10);
                r_b = 20.0 * (1 - t / 7.5);
                r_t = r_b * 0.55;
                th = 10.5 * (1 - t / 9.0);
                translate([0, 0, tz]) {
                    union() {
                        translate([0, 0, -th * 0.1])
                            cylinder(r1 = r_b * 0.62, r2 = r_t * 0.82, h = th * 1.1);
                        for (i = [0 : 5]) {
                            rotate([0, 0, i * 60 + t * 25]) {
                                rotate([18, 0, 0]) {
                                    hull() {
                                        translate([0, 0, th * 0.5]) sphere(r = r_t * 0.45, $fn = 10);
                                        translate([0, r_b * 0.88, -th * 0.15]) sphere(r = r_b * 0.20, $fn = 10);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // Characteristic Drooping Leader Top
            translate([0, 0, h - 10.0]) {
                rotate([12, 0, 0])
                    cylinder(r1 = 1.6, r2 = 0.3, h = 10.0);
            }
        }
    }
}

// --- 3. PONDEROSA PINE (2.60 in / 66.04 mm) ---
module ponderosa_pine(h = 66.04) {
    union() {
        // High Clear Trunk with Thick Bark Plates
        color([0.48, 0.28, 0.15]) {
            cylinder(r1 = 8.0, r2 = 3.8, h = 5.0);
            hull() {
                translate([0, 0, 4.0]) cylinder(r1 = 3.8, r2 = 2.6, h = h * 0.55);
                translate([0, 0, h * 0.82]) cylinder(r1 = 2.6, r2 = 1.0, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([7.2, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                        translate([3.4, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                    }
            }
            // High branch forks
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba]) {
                    hull() {
                        translate([0, 0, h * 0.55]) sphere(r = 1.8, $fn = 8);
                        translate([0, 11.0, h * 0.72]) sphere(r = 1.1, $fn = 8);
                    }
                }
            }
        }
        // Tufted Needle Clusters (Upper Half Canopy)
        color([0.18, 0.44, 0.20]) {
            // Lower canopy tufts
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba]) {
                    translate([0, 11.0, h * 0.72]) {
                        union() {
                            cylinder(r1 = 1.0, r2 = 6.5, h = 6.0);
                            translate([0, 0, 3.0]) cylinder(r1 = 7.0, r2 = 0.5, h = 5.5);
                        }
                    }
                }
            }
            // Upper canopy tufts
            for (ba = [45, 135, 225, 315]) {
                rotate([0, 0, ba]) {
                    translate([0, 7.5, h * 0.82]) {
                        union() {
                            cylinder(r1 = 0.8, r2 = 5.5, h = 5.5);
                            translate([0, 0, 2.5]) cylinder(r1 = 6.0, r2 = 0.4, h = 5.0);
                        }
                    }
                }
            }
            // Top crown tuft
            translate([0, 0, h - 7.5]) {
                union() {
                    cylinder(r1 = 1.2, r2 = 5.0, h = 5.0);
                    translate([0, 0, 2.5]) cylinder(r1 = 5.5, r2 = 0.3, h = 5.0);
                }
            }
        }
    }
}

// --- 4. SUBALPINE FIR (2.40 in / 60.96 mm) ---
module subalpine_fir(h = 60.96) {
    union() {
        // Trunk
        color([0.34, 0.22, 0.14]) {
            cylinder(r1 = 6.5, r2 = 3.2, h = 4.0);
            hull() {
                translate([0, 0, 3.0]) cylinder(r = 3.2, h = h * 0.22);
                translate([0, 0, h * 0.85]) cylinder(r1 = 2.2, r2 = 0.8, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([5.8, 0, 0.4]) sphere(r = 0.5, $fn = 8);
                        translate([2.8, 0, 3.0]) sphere(r = 0.35, $fn = 8);
                    }
            }
        }
        // Narrow Spire Conical Foliage Tiers
        color([0.14, 0.40, 0.20]) {
            for (t = [0 : 7]) {
                tz = h * (0.16 + t * 0.10);
                r_b = 13.5 * (1 - t / 8.2);
                r_t = r_b * 0.5;
                th = 8.5 * (1 - t / 9.5);
                translate([0, 0, tz]) {
                    union() {
                        cylinder(r1 = r_b, r2 = r_t, h = th);
                        for (i = [0 : 5]) {
                            rotate([0, 0, i * 60 + t * 20])
                                translate([r_b * 0.70, 0, -th * 0.1])
                                    rotate([28, 0, 0])
                                        cylinder(r1 = r_b * 0.20, r2 = 0.2, h = th * 0.55, $fn = 6);
                        }
                    }
                }
            }
            // Sharp Spire Apex
            translate([0, 0, h - 8.0])
                cylinder(r1 = 1.5, r2 = 0.3, h = 8.0);
        }
    }
}

// --- 5. ALPINE LARCH (2.20 in / 55.88 mm) ---
module alpine_larch(h = 55.88) {
    union() {
        // Trunk
        color([0.40, 0.25, 0.15]) {
            cylinder(r1 = 6.2, r2 = 3.0, h = 4.0);
            hull() {
                translate([0, 0, 3.0]) cylinder(r = 3.0, h = h * 0.25);
                translate([0, 0, h * 0.82]) cylinder(r1 = 2.0, r2 = 0.8, h = 3.5);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([5.5, 0, 0.4]) sphere(r = 0.5, $fn = 8);
                        translate([2.6, 0, 2.8]) sphere(r = 0.35, $fn = 8);
                    }
            }
        }
        // Feathery Golden-Green Needle Whorls
        color([0.28, 0.52, 0.22]) {
            for (t = [0 : 5]) {
                tz = h * (0.22 + t * 0.12);
                r_b = 16.0 * (1 - t / 6.5);
                th = 8.0 * (1 - t / 8.0);
                translate([0, 0, tz]) {
                    union() {
                        cylinder(r1 = r_b * 0.6, r2 = r_b * 0.3, h = th);
                        for (i = [0 : 6]) {
                            rotate([0, 0, i * (360 / 7) + t * 15]) {
                                translate([0, r_b * 0.75, 0])
                                    rotate([12, 0, 0])
                                        scale([1.2, 0.5, 0.5])
                                            cylinder(r1 = r_b * 0.25, r2 = 0.2, h = th * 0.7, $fn = 8);
                            }
                        }
                    }
                }
            }
            translate([0, 0, h - 7.0])
                cylinder(r1 = 1.4, r2 = 0.3, h = 7.0);
        }
    }
}

// --- 6. MOUNTAIN CYPRESS / CEDAR (2.00 in / 50.80 mm) ---
module mountain_cypress(h = 50.80) {
    union() {
        // Trunk & Base Foot
        color([0.36, 0.24, 0.14]) {
            cylinder(r1 = 6.0, r2 = 2.8, h = 4.0);
            hull() {
                translate([0, 0, 3.0]) cylinder(r = 2.8, h = h * 0.20);
                translate([0, 0, h * 0.85]) cylinder(r1 = 1.8, r2 = 0.7, h = 3.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([5.2, 0, 0.4]) sphere(r = 0.5, $fn = 8);
                        translate([2.5, 0, 2.8]) sphere(r = 0.35, $fn = 8);
                    }
            }
        }
        // Vertical Flame / Scale Foliage Plates
        color([0.20, 0.46, 0.28]) {
            for (t = [0 : 5]) {
                tz = h * (0.18 + t * 0.13);
                r_max = 12.5 * sin((t + 1) / 7 * 180);
                th = 9.0;
                translate([0, 0, tz]) {
                    union() {
                        cylinder(r1 = r_max * 0.85, r2 = r_max * 0.45, h = th);
                        for (i = [0 : 4]) {
                            rotate([0, 0, i * 72 + t * 25]) {
                                translate([0, r_max * 0.70, 0])
                                    rotate([-15, 0, 0])
                                        scale([0.6, 1.2, 1.0])
                                            cylinder(r1 = r_max * 0.3, r2 = 0.2, h = th * 0.8, $fn = 8);
                            }
                        }
                    }
                }
            }
            translate([0, 0, h - 6.5])
                cylinder(r1 = 1.4, r2 = 0.3, h = 6.5);
        }
    }
}

// ====================================================================
// MASTER MOUNTAIN PACK LAYOUT (2x3 Grid spaced 45mm apart)
// ====================================================================
translate([-45, 25, 0])  blue_spruce(76.2);       // 3.00 in
translate([0, 25, 0])    mountain_hemlock(71.12); // 2.80 in
translate([45, 25, 0])   ponderosa_pine(66.04);   // 2.60 in

translate([-45, -25, 0]) subalpine_fir(60.96);    // 2.40 in
translate([0, -25, 0])   alpine_larch(55.88);     // 2.20 in
translate([45, -25, 0])  mountain_cypress(50.80); // 2.00 in
"""

with open("models/trees/09_tree_variety_pack_spaced.scad", "w") as f:
    f.write(mountain_scad_content)

print("Saved models/trees/09_tree_variety_pack_spaced.scad (Mountain Trees Variety Pack)")
