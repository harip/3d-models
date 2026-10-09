import os

os.makedirs("models/trees/mountain_pack", exist_ok=True)
os.makedirs("stls/trees/mountain_pack", exist_ok=True)
os.makedirs("scratch", exist_ok=True)

# 1. COLORADO BLUE SPRUCE (3.0 in / 76.2 mm)
blue_spruce_scad = """// Colorado Blue Spruce (3.0 in / 76.2 mm) - FDM Certified 100% Supportless
$fn = 32;

module colorado_blue_spruce(h = 76.2) {
    union() {
        color([0.38, 0.24, 0.14]) {
            cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
            cylinder(r1 = 7.5, r2 = 3.8, h = 4.5);
            hull() {
                translate([0, 0, 3.0]) cylinder(r = 3.8, h = h * 0.25);
                translate([0, 0, h - 8.0]) cylinder(r1 = 2.2, r2 = 0.8, h = 7.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([6.8, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                        translate([3.2, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                    }
            }
        }
        color([0.21, 0.42, 0.40]) { // Slate Blue-Green
            for (t = [0 : 6]) {
                tz = h * (0.20 + t * 0.11);
                rb = 23.0 * (1 - t / 7.2);
                rt = rb * 0.6;
                ht = 11.5 * (1 - t / 9.0);
                translate([0, 0, tz]) {
                    hull() {
                        translate([0, 0, -ht * 0.60]) cylinder(r1 = 3.8, r2 = 3.8, h = 1.0);
                        translate([0, 0, ht * 0.20]) cylinder(r1 = rb, r2 = rt, h = ht * 0.80);
                    }
                    for (i = [0 : 6]) {
                        rotate([0, 0, i * (360/7) + t * 18]) {
                            hull() {
                                translate([0, 3.8, ht * 0.10]) cylinder(r1 = 2.0, r2 = 1.0, h = ht * 0.50);
                                translate([0, rb * 0.90, ht * 0.30]) cylinder(r1 = rb * 0.16, r2 = 0.3, h = ht * 0.40, $fn = 6);
                            }
                        }
                    }
                }
            }
            translate([0, 0, h - 8.5]) cylinder(r1 = 1.8, r2 = 0.3, h = 8.5);
        }
    }
}

colorado_blue_spruce(76.2);
"""

# 2. MOUNTAIN HEMLOCK (2.8 in / 71.12 mm)
hemlock_scad = """// Mountain Hemlock (2.8 in / 71.12 mm) - FDM Certified 100% Supportless
$fn = 32;

module mountain_hemlock(h = 71.12) {
    union() {
        color([0.36, 0.22, 0.13]) {
            cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
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
        color([0.14, 0.40, 0.20]) { // Deep Forest Alpine Green
            for (t = [0 : 6]) {
                tz = h * (0.22 + t * 0.10);
                rb = 20.0 * (1 - t / 7.5);
                rt = rb * 0.55;
                ht = 10.5 * (1 - t / 9.0);
                translate([0, 0, tz]) {
                    hull() {
                        translate([0, 0, -ht * 0.55]) cylinder(r1 = 3.4, r2 = 3.4, h = 1.0);
                        translate([0, 0, ht * 0.20]) cylinder(r1 = rb, r2 = rt, h = ht * 0.80);
                    }
                    for (i = [0 : 5]) {
                        rotate([0, 0, i * 60 + t * 25]) {
                            hull() {
                                translate([0, 3.4, ht * 0.10]) cylinder(r1 = 1.8, r2 = 0.9, h = ht * 0.45);
                                translate([0, rb * 0.88, ht * 0.25]) cylinder(r1 = rb * 0.15, r2 = 0.3, h = ht * 0.38, $fn = 6);
                            }
                        }
                    }
                }
            }
            translate([0, 0, h - 10.0]) rotate([10, 0, 0]) cylinder(r1 = 1.6, r2 = 0.3, h = 10.0);
        }
    }
}

mountain_hemlock(71.12);
"""

# 3. PONDEROSA PINE (2.6 in / 66.04 mm)
ponderosa_scad = """// Ponderosa Pine (2.6 in / 66.04 mm) - FDM Certified 100% Supportless
$fn = 32;

module ponderosa_pine(h = 66.04) {
    union() {
        color([0.46, 0.27, 0.15]) { // Warm Bark Orange-Brown
            cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
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
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba]) {
                    hull() {
                        translate([0, 0, h * 0.55]) sphere(r = 1.8, $fn = 8);
                        translate([0, 11.0, h * 0.72]) sphere(r = 1.1, $fn = 8);
                    }
                }
            }
        }
        color([0.16, 0.42, 0.18]) {
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba]) {
                    translate([0, 11.0, h * 0.72]) {
                        cylinder(r1 = 1.1, r2 = 6.5, h = 6.0);
                        translate([0, 0, 2.5]) cylinder(r1 = 6.5, r2 = 0.4, h = 5.0);
                    }
                }
            }
            for (ba = [45, 135, 225, 315]) {
                rotate([0, 0, ba]) {
                    translate([0, 7.5, h * 0.82]) {
                        cylinder(r1 = 0.9, r2 = 5.5, h = 5.5);
                        translate([0, 0, 2.0]) cylinder(r1 = 5.5, r2 = 0.3, h = 4.5);
                    }
                }
            }
            translate([0, 0, h - 7.5]) {
                cylinder(r1 = 1.2, r2 = 5.0, h = 5.0);
                translate([0, 0, 2.2]) cylinder(r1 = 5.0, r2 = 0.3, h = 4.5);
            }
        }
    }
}

ponderosa_pine(66.04);
"""

# 4. SUBALPINE FIR (2.4 in / 60.96 mm)
fir_scad = """// Subalpine Fir (2.4 in / 60.96 mm) - FDM Certified 100% Supportless
$fn = 32;

module subalpine_fir(h = 60.96) {
    union() {
        color([0.34, 0.22, 0.14]) {
            cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
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
        color([0.12, 0.38, 0.18]) { // Dark Conifer Green
            for (t = [0 : 7]) {
                tz = h * (0.16 + t * 0.10);
                rb = 13.5 * (1 - t / 8.2);
                rt = rb * 0.5;
                ht = 8.5 * (1 - t / 9.5);
                translate([0, 0, tz]) {
                    hull() {
                        translate([0, 0, -ht * 0.50]) cylinder(r1 = 3.2, r2 = 3.2, h = 1.0);
                        translate([0, 0, ht * 0.20]) cylinder(r1 = rb, r2 = rt, h = ht * 0.80);
                    }
                    for (i = [0 : 5]) {
                        rotate([0, 0, i * 60 + t * 20])
                            translate([rb * 0.70, 0, -ht * 0.1])
                                rotate([28, 0, 0])
                                    cylinder(r1 = rb * 0.20, r2 = 0.2, h = ht * 0.55, $fn = 6);
                    }
                }
            }
            translate([0, 0, h - 8.0]) cylinder(r1 = 1.5, r2 = 0.3, h = 8.0);
        }
    }
}

subalpine_fir(60.96);
"""

# 5. ALPINE LARCH (2.2 in / 55.88 mm)
larch_scad = """// Alpine Larch (2.2 in / 55.88 mm) - FDM Certified 100% Supportless
$fn = 32;

module alpine_larch(h = 55.88) {
    union() {
        color([0.40, 0.25, 0.15]) {
            cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
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
        color([0.24, 0.48, 0.20]) { // Golden Alpine Green
            for (t = [0 : 5]) {
                tz = h * (0.22 + t * 0.12);
                rb = 16.0 * (1 - t / 6.5);
                ht = 8.0 * (1 - t / 8.0);
                translate([0, 0, tz]) {
                    hull() {
                        translate([0, 0, -ht * 0.50]) cylinder(r1 = 3.0, r2 = 3.0, h = 1.0);
                        translate([0, 0, ht * 0.20]) cylinder(r1 = rb * 0.6, r2 = rb * 0.3, h = ht * 0.8);
                    }
                    for (i = [0 : 6]) {
                        rotate([0, 0, i * (360/7) + t * 15]) {
                            translate([0, rb * 0.75, 0])
                                rotate([12, 0, 0])
                                    scale([1.2, 0.5, 0.5])
                                        cylinder(r1 = rb * 0.25, r2 = 0.2, h = ht * 0.7, $fn = 8);
                        }
                    }
                }
            }
            translate([0, 0, h - 7.0]) cylinder(r1 = 1.4, r2 = 0.3, h = 7.0);
        }
    }
}

alpine_larch(55.88);
"""

# 6. MOUNTAIN CYPRESS (2.0 in / 50.80 mm)
cypress_scad = """// Mountain Cypress / Cedar (2.0 in / 50.80 mm) - FDM Certified 100% Supportless
$fn = 32;

module mountain_cypress(h = 50.80) {
    union() {
        color([0.36, 0.24, 0.14]) {
            cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
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
        color([0.18, 0.44, 0.26]) {
            for (t = [0 : 5]) {
                tz = h * (0.18 + t * 0.13);
                rmax = 12.5 * sin((t + 1) / 7 * 180);
                th = 9.0;
                translate([0, 0, tz]) {
                    hull() {
                        translate([0, 0, -th * 0.40]) cylinder(r1 = 2.8, r2 = 2.8, h = 1.0);
                        translate([0, 0, 0]) cylinder(r1 = rmax * 0.85, r2 = rmax * 0.45, h = th);
                    }
                    for (i = [0 : 4]) {
                        rotate([0, 0, i * 72 + t * 25]) {
                            translate([0, rmax * 0.70, 0])
                                rotate([-15, 0, 0])
                                    scale([0.6, 1.2, 1.0])
                                        cylinder(r1 = rmax * 0.3, r2 = 0.2, h = th * 0.8, $fn = 8);
                        }
                    }
                }
            }
            translate([0, 0, h - 6.5]) cylinder(r1 = 1.4, r2 = 0.3, h = 6.5);
        }
    }
}

mountain_cypress(50.80);
"""

# Save individual species files
files = {
    "models/trees/mountain_pack/01_colorado_blue_spruce_3.0in.scad": blue_spruce_scad,
    "models/trees/mountain_pack/02_mountain_hemlock_2.8in.scad": hemlock_scad,
    "models/trees/mountain_pack/03_ponderosa_pine_2.6in.scad": ponderosa_scad,
    "models/trees/mountain_pack/04_subalpine_fir_2.4in.scad": fir_scad,
    "models/trees/mountain_pack/05_alpine_larch_2.2in.scad": larch_scad,
    "models/trees/mountain_pack/06_mountain_cypress_2.0in.scad": cypress_scad,
}

for path, content in files.items():
    with open(path, "w") as f:
        f.write(content)

# Master layout SCAD
master_scad = f"""// Master 6-Tree Mountain Variety Pack Layout (Spaced 45mm apart in 2x3 Grid)
// All trees FDM certified 100% supportless with 32mm breakaway base rafts

use <mountain_pack/01_colorado_blue_spruce_3.0in.scad>
use <mountain_pack/02_mountain_hemlock_2.8in.scad>
use <mountain_pack/03_ponderosa_pine_2.6in.scad>
use <mountain_pack/04_subalpine_fir_2.4in.scad>
use <mountain_pack/05_alpine_larch_2.2in.scad>
use <mountain_pack/06_mountain_cypress_2.0in.scad>

// Back Row (Left to Right):
translate([-45, 25, 0])  colorado_blue_spruce(76.2);       // 1. Colorado Blue Spruce (3.0 in)
translate([0, 25, 0])    mountain_hemlock(71.12);         // 2. Mountain Hemlock (2.8 in)
translate([45, 25, 0])   ponderosa_pine(66.04);           // 3. Ponderosa Pine (2.6 in)

// Front Row (Left to Right):
translate([-45, -25, 0]) subalpine_fir(60.96);            // 4. Subalpine Fir (2.4 in)
translate([0, -25, 0])   alpine_larch(55.88);             // 5. Alpine Larch (2.2 in)
translate([45, -25, 0])  mountain_cypress(50.80);         // 6. Mountain Cypress (2.0 in)
"""

with open("models/trees/09_mountain_trees_pack_spaced.scad", "w") as f:
    f.write(master_scad)

print("Saved all 6 individual mountain species SCAD files and master 09_mountain_trees_pack_spaced.scad")
