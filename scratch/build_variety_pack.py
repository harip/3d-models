import os
import subprocess

# Ensure directories exist
os.makedirs("models/trees/variety_pack", exist_ok=True)
os.makedirs("stls/trees/variety_pack", exist_ok=True)
os.makedirs("scratch", exist_ok=True)

# Master OpenSCAD model containing all 6 trees spaced in a 2x3 grid
master_scad_content = """// ====================================================================
// 3D Printable 6-Tree Species Variety Pack (Heights 2.0in to 3.0in)
// 100% Supportless Manifold Solids for FDM 3D Printing
// ====================================================================

$fn = 28;

// --- 1. GIANT SEQUOIA (3.0 in / 76.2 mm) ---
module giant_sequoia(h = 76.2) {
    union() {
        // Bark Brown Trunk
        color([0.40, 0.22, 0.12]) {
            union() {
                cylinder(r1 = 11.0, r2 = 5.2, h = 9.0);
                hull() {
                    translate([0, 0, 5.0]) cylinder(r1 = 5.2, r2 = 2.4, h = h * 0.85);
                    translate([0, 0, h - 6.0]) cylinder(r1 = 2.4, r2 = 0.8, h = 5.0);
                }
                for (a = [0 : 45 : 315]) {
                    rotate([0, 0, a])
                        hull() {
                            translate([10.0, 0, 0.4]) sphere(r = 0.8, $fn = 8);
                            translate([4.5, 0, 4.0]) sphere(r = 0.5, $fn = 8);
                        }
                }
            }
        }
        // Dark Evergreen Tiers
        color([0.12, 0.38, 0.18]) {
            for (t = [0 : 7]) {
                tz = h * (0.22 + t * 0.095);
                tr_base = 22.0 * (1 - t / 8.2);
                tr_top = tr_base * 0.5;
                th = 10.0 * (1 - t / 10.0);
                translate([0, 0, tz]) {
                    cylinder(r1 = tr_base, r2 = tr_top, h = th);
                    for (i = [0 : 7]) {
                        rotate([0, 0, i * 45])
                            translate([tr_base * 0.75, 0, -th * 0.1])
                                rotate([25, 0, 0])
                                    cylinder(r1 = tr_base * 0.22, r2 = 0.3, h = th * 0.6, $fn = 6);
                    }
                }
            }
            translate([0, 0, h - 8.0])
                cylinder(r1 = 2.5, r2 = 0.4, h = 8.0);
        }
    }
}

// --- 2. JAPANESE BONSAI PINE (2.2 in / 55.88 mm) ---
module bonsai_pine(h = 55.88) {
    union() {
        // Gnarled Trunk
        color([0.35, 0.22, 0.14]) {
            union() {
                cylinder(r1 = 9.0, r2 = 4.2, h = 5.0);
                // S-curve trunk segments
                hull() {
                    translate([0, 0, 3.0]) sphere(r = 4.0, $fn = 12);
                    translate([6.0, 0, h * 0.25]) sphere(r = 3.4, $fn = 12);
                }
                hull() {
                    translate([6.0, 0, h * 0.25]) sphere(r = 3.4, $fn = 12);
                    translate([-4.0, 3.0, h * 0.55]) sphere(r = 2.6, $fn = 12);
                }
                hull() {
                    translate([-4.0, 3.0, h * 0.55]) sphere(r = 2.6, $fn = 12);
                    translate([2.0, 0, h * 0.85]) sphere(r = 1.6, $fn = 12);
                }
                // Root flare feet
                for (a = [0, 90, 180, 270]) {
                    rotate([0, 0, a])
                        hull() {
                            translate([8.2, 0, 0.4]) sphere(r = 0.7, $fn = 8);
                            translate([4.0, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                        }
                }
            }
        }
        // Cloud Foliage Pads
        color([0.15, 0.42, 0.22]) {
            // Pad 1
            translate([8.0, 0, h * 0.35])
                scale([1.3, 1.0, 0.45]) sphere(r = 11.0, $fn = 16);
            // Pad 2
            translate([-7.0, 4.0, h * 0.62])
                scale([1.2, 1.1, 0.45]) sphere(r = 12.5, $fn = 16);
            // Pad 3
            translate([4.0, -3.0, h * 0.78])
                scale([1.1, 1.0, 0.45]) sphere(r = 10.0, $fn = 16);
            // Top Pad
            translate([1.0, 0, h * 0.90])
                scale([1.0, 1.0, 0.50]) sphere(r = 9.0, $fn = 16);
        }
    }
}

// --- 3. AFRICAN BAOBAB (2.4 in / 60.96 mm) ---
module african_baobab(h = 60.96) {
    union() {
        // Massive Swollen Trunk & Bare Gnarled Limbs
        color([0.45, 0.32, 0.22]) {
            union() {
                // Swollen bottle trunk
                cylinder(r1 = 12.5, r2 = 14.5, h = 8.0);
                hull() {
                    translate([0, 0, 6.0]) cylinder(r1 = 14.5, r2 = 12.0, h = h * 0.45);
                    translate([0, 0, h * 0.65]) cylinder(r1 = 12.0, r2 = 7.0, h = h * 0.18);
                }
                // Root buttresses
                for (a = [0 : 45 : 315]) {
                    rotate([0, 0, a])
                        hull() {
                            translate([12.0, 0, 0.4]) sphere(r = 0.9, $fn = 8);
                            translate([13.5, 0, 6.0]) sphere(r = 0.6, $fn = 8);
                        }
                }
                // Thick radiating top limbs
                for (a = [0, 60, 120, 180, 240, 300]) {
                    rotate([0, 0, a]) {
                        hull() {
                            translate([0, 0, h * 0.62]) sphere(r = 3.5, $fn = 8);
                            translate([0, 14.0, h * 0.82]) sphere(r = 1.8, $fn = 8);
                        }
                    }
                }
            }
        }
        // Crown Foliage Cap
        color([0.28, 0.48, 0.20]) {
            for (a = [0, 60, 120, 180, 240, 300]) {
                rotate([0, 0, a])
                    translate([0, 14.0, h * 0.82])
                        scale([1.1, 1.1, 0.55]) sphere(r = 8.5, $fn = 14);
            }
            translate([0, 0, h * 0.88])
                scale([1.2, 1.2, 0.50]) sphere(r = 11.0, $fn = 16);
        }
    }
}

// --- 4. WEEPING WILLOW (2.8 in / 71.12 mm) ---
module weeping_willow(h = 71.12) {
    union() {
        // Main Trunk
        color([0.38, 0.25, 0.15]) {
            union() {
                cylinder(r1 = 9.0, r2 = 4.2, h = 5.0);
                hull() {
                    translate([0, 0, 4.0]) cylinder(r1 = 4.2, r2 = 2.8, h = h * 0.55);
                    translate([0, 0, h * 0.68]) cylinder(r1 = 2.8, r2 = 1.5, h = h * 0.15);
                }
                for (a = [0 : 72 : 288]) {
                    rotate([0, 0, a])
                        hull() {
                            translate([8.2, 0, 0.4]) sphere(r = 0.7, $fn = 8);
                            translate([4.0, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                        }
                }
            }
        }
        // Cascading Downward Foliage Dome
        color([0.22, 0.52, 0.24]) {
            translate([0, 0, h * 0.68]) {
                union() {
                    // Central upper canopy dome
                    scale([1.0, 1.0, 0.75]) sphere(r = 19.0, $fn = 20);
                    // Drooping curtain skirt
                    for (i = [0 : 11]) {
                        rotate([0, 0, i * 30]) {
                            translate([15.5, 0, -h * 0.12])
                                rotate([12, 0, 0])
                                    cylinder(r1 = 5.2, r2 = 1.2, h = h * 0.28, $fn = 12);
                        }
                    }
                }
            }
        }
    }
}

// --- 5. COCONUT PALM TREE (2.6 in / 66.04 mm) ---
module coconut_palm(h = 66.04) {
    union() {
        // Leaning Ringed Trunk
        color([0.48, 0.35, 0.22]) {
            union() {
                cylinder(r1 = 9.0, r2 = 3.6, h = 5.0);
                // Leaning segmented trunk
                for (i = [0 : 12]) {
                    t = i / 12;
                    lz = 4.0 + t * (h * 0.80);
                    lx = sin(t * 90) * 8.0;
                    translate([lx, 0, lz])
                        scale([1.0, 1.0, 0.7])
                            sphere(r = 3.4 - t * 1.2, $fn = 12);
                }
                for (a = [0 : 60 : 300]) {
                    rotate([0, 0, a])
                        hull() {
                            translate([8.2, 0, 0.4]) sphere(r = 0.7, $fn = 8);
                            translate([3.5, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                        }
                }
            }
        }
        // Coconuts
        color([0.30, 0.20, 0.10]) {
            for (ca = [0, 90, 180, 270]) {
                rotate([0, 0, ca])
                    translate([7.2, 1.2, h * 0.82])
                        sphere(r = 2.2, $fn = 10);
            }
        }
        // Radial Drooping Palm Fronds
        color([0.16, 0.48, 0.20]) {
            translate([8.0, 0, h * 0.84]) {
                for (f = [0 : 7]) {
                    rotate([0, 0, f * 45]) {
                        rotate([22, 0, 0]) {
                            hull() {
                                translate([0, 0, 0]) sphere(r = 1.2, $fn = 8);
                                translate([0, 18.0, -6.0]) scale([2.4, 0.5, 0.4]) sphere(r = 3.5, $fn = 10);
                            }
                        }
                    }
                }
            }
        }
    }
}

// --- 6. ANCIENT OAK TREE (2.0 in / 50.8 mm) ---
module ancient_oak(h = 50.8) {
    union() {
        // Wide Gnarled Trunk & Main Forks
        color([0.36, 0.22, 0.12]) {
            union() {
                cylinder(r1 = 11.0, r2 = 5.5, h = 6.0);
                hull() {
                    translate([0, 0, 4.0]) cylinder(r1 = 5.5, r2 = 4.0, h = h * 0.45);
                    translate([0, 0, h * 0.55]) cylinder(r1 = 4.0, r2 = 2.5, h = h * 0.15);
                }
                for (a = [0 : 45 : 315]) {
                    rotate([0, 0, a])
                        hull() {
                            translate([10.2, 0, 0.4]) sphere(r = 0.8, $fn = 8);
                            translate([5.0, 0, 3.5]) sphere(r = 0.5, $fn = 8);
                        }
                }
                // Main branches
                for (ba = [0, 90, 180, 270]) {
                    rotate([0, 0, ba]) {
                        hull() {
                            translate([0, 0, h * 0.50]) sphere(r = 2.8, $fn = 8);
                            translate([0, 12.0, h * 0.70]) sphere(r = 1.6, $fn = 8);
                        }
                    }
                }
            }
        }
        // Broad Rounded Canopy Dome
        color([0.18, 0.46, 0.20]) {
            translate([0, 0, h * 0.68]) {
                scale([1.3, 1.3, 0.70])
                    sphere(r = 18.0, $fn = 22);
            }
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba])
                    translate([0, 12.0, h * 0.70])
                        scale([1.1, 1.1, 0.65]) sphere(r = 10.0, $fn = 16);
            }
        }
    }
}

// ====================================================================
// MASTER PACK LAYOUT (2x3 Grid spaced 45mm apart)
// ====================================================================
translate([-45, 25, 0])  giant_sequoia(76.2);    // 3.00 in
translate([0, 25, 0])    bonsai_pine(55.88);     // 2.20 in
translate([45, 25, 0])   african_baobab(60.96);  // 2.40 in

translate([-45, -25, 0]) weeping_willow(71.12); // 2.80 in
translate([0, -25, 0])   coconut_palm(66.04);   // 2.60 in
translate([45, -25, 0])  ancient_oak(50.8);      // 2.00 in
"""

with open("models/trees/09_tree_variety_pack_spaced.scad", "w") as f:
    f.write(master_scad_content)

print("Saved models/trees/09_tree_variety_pack_spaced.scad")
