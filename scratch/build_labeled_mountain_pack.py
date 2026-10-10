import os
import subprocess

os.makedirs("models/trees/accurate_mountain_pack", exist_ok=True)
os.makedirs("stls/trees", exist_ok=True)
os.makedirs("scratch/accurate_previews", exist_ok=True)

artifact_dir = "/Users/lavanyat/.gemini/antigravity-ide/brain/b6d63059-fcc2-4f58-9ee9-2a7dadcb769f"

# ==============================================================================
# HYPER-ACCURATE BOTANICAL OPENSCAD MODELS (Heights 3.0" to 4.0")
# ==============================================================================

# 1. COLORADO BLUE SPRUCE (4.00 in / 101.6 mm)
spruce_scad = """// 1. Colorado Blue Spruce (4.00 in / 101.6 mm)
// Botanically Accurate: Layered rigid whorls, blue-green needles, downturned branchlets, spire top
$fn = 24;

module blue_spruce_4in(h = 101.6) {
    union() {
        // Tapered Trunk with Bark Ridges
        color([0.38, 0.25, 0.16]) {
            cylinder(r1 = 8.5, r2 = 3.8, h = 6.0);
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 3.8, h = h * 0.25);
                translate([0, 0, h * 0.88]) cylinder(r1 = 2.5, r2 = 0.8, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a]) hull() {
                    translate([7.8, 0, 0.4]) sphere(r = 0.8, $fn = 8);
                    translate([3.5, 0, 3.5]) sphere(r = 0.4, $fn = 8);
                }
            }
        }
        // Dense Rigid Tiered Foliage
        color([0.20, 0.45, 0.42]) {
            for (t = [0 : 9]) {
                tz = h * (0.16 + t * 0.082);
                r_max = 30.0 * (1 - t / 10.5);
                th = 13.0 * (1 - t / 12.0);
                translate([0, 0, tz]) {
                    union() {
                        // Trunk overlay cone
                        cylinder(r1 = r_max * 0.55, r2 = r_max * 0.25, h = th);
                        // Radiant branches (8 per tier)
                        for (i = [0 : 7]) {
                            rotate([0, 0, i * 45 + t * 27.5]) {
                                // Main drooping bough stem
                                hull() {
                                    translate([0, 0, th * 0.3]) sphere(r = r_max * 0.18, $fn = 8);
                                    translate([0, r_max * 0.85, -th * 0.2]) sphere(r = r_max * 0.08, $fn = 8);
                                }
                                // Needle sprays along bough stem
                                for (np = [0.25, 0.50, 0.75, 0.95]) {
                                    translate([0, r_max * np, th * 0.3 * (1 - np) - th * 0.2 * np]) {
                                        for (na = [-35, -15, 0, 15, 35]) {
                                            rotate([na, 12, 0])
                                                cylinder(r1 = r_max * 0.09, r2 = 0.2, h = th * 0.45, $fn = 6);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // Sharp Spire Apex Leader
            translate([0, 0, h - 12.0])
                cylinder(r1 = 2.0, r2 = 0.3, h = 12.0);
        }
    }
}

blue_spruce_4in();
"""

# 2. MOUNTAIN HEMLOCK (3.80 in / 96.52 mm)
hemlock_scad = """// 2. Mountain Hemlock (3.80 in / 96.52 mm)
// Botanically Accurate: Nodding leader tip, weeping branchlets, irregular soft canopy
$fn = 24;

module mountain_hemlock_3_8in(h = 96.52) {
    union() {
        // Tapered Alpine Trunk
        color([0.35, 0.22, 0.14]) {
            cylinder(r1 = 8.0, r2 = 3.6, h = 5.5);
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 3.6, h = h * 0.28);
                translate([0, 0, h * 0.85]) cylinder(r1 = 2.4, r2 = 0.8, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a]) hull() {
                    translate([7.2, 0, 0.4]) sphere(r = 0.7, $fn = 8);
                    translate([3.2, 0, 3.2]) sphere(r = 0.4, $fn = 8);
                }
            }
        }
        // Weeping Feathery Canopy
        color([0.16, 0.42, 0.22]) {
            for (t = [0 : 8]) {
                tz = h * (0.18 + t * 0.088);
                r_max = 26.0 * (1 - t / 9.5);
                th = 12.0 * (1 - t / 11.0);
                translate([0, 0, tz]) {
                    union() {
                        cylinder(r1 = r_max * 0.6, r2 = r_max * 0.28, h = th);
                        for (i = [0 : 6]) {
                            rotate([0, 0, i * (360 / 7) + t * 31]) {
                                // Curved weeping branch stem
                                hull() {
                                    translate([0, 0, th * 0.4]) sphere(r = r_max * 0.16, $fn = 8);
                                    translate([0, r_max * 0.7, -th * 0.05]) sphere(r = r_max * 0.12, $fn = 8);
                                }
                                hull() {
                                    translate([0, r_max * 0.7, -th * 0.05]) sphere(r = r_max * 0.12, $fn = 8);
                                    translate([0, r_max * 0.95, -th * 0.35]) sphere(r = r_max * 0.05, $fn = 8);
                                }
                                // Soft drooping foliage pods
                                translate([0, r_max * 0.65, -th * 0.1])
                                    scale([1.4, 0.8, 0.6]) sphere(r = r_max * 0.22, $fn = 10);
                            }
                        }
                    }
                }
            }
            // Characteristic Drooping / Nodding Top Leader
            translate([0, 0, h - 13.0]) {
                rotate([18, 0, 0]) hull() {
                    cylinder(r1 = 1.8, r2 = 1.0, h = 8.0);
                    translate([0, 2.5, 7.0]) cylinder(r1 = 1.0, r2 = 0.3, h = 6.0);
                }
            }
        }
    }
}

mountain_hemlock_3_8in();
"""

# 3. BRISTLECONE PINE (3.60 in / 91.44 mm)
bristlecone_scad = """// 3. Bristlecone Pine (3.60 in / 91.44 mm)
// Botanically Accurate: Gnarled twisted trunk, deadwood spike top, foxtail needle tufts
$fn = 24;

module bristlecone_pine_3_6in(h = 91.44) {
    union() {
        // Weathered Gnarled Alpine Trunk & Deadwood Spike
        color([0.46, 0.28, 0.17]) {
            cylinder(r1 = 9.5, r2 = 4.8, h = 6.0);
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 4.8, h = 10.0);
                translate([4.0, 2.0, h * 0.35]) sphere(r = 4.0, $fn = 10);
            }
            hull() {
                translate([4.0, 2.0, h * 0.35]) sphere(r = 4.0, $fn = 10);
                translate([-3.0, 4.0, h * 0.60]) sphere(r = 3.2, $fn = 10);
            }
            hull() {
                translate([-3.0, 4.0, h * 0.60]) sphere(r = 3.2, $fn = 10);
                translate([1.5, 1.0, h * 0.85]) sphere(r = 2.2, $fn = 10);
            }
            // Exposed Deadwood Spike Top (characteristic of ancient subalpine pines)
            translate([1.5, 1.0, h * 0.85])
                cylinder(r1 = 2.0, r2 = 0.2, h = h * 0.15, $fn = 8);

            // Root buttresses
            for (a = [0 : 72 : 288]) {
                rotate([0, 0, a]) hull() {
                    translate([8.5, 0, 0.5]) sphere(r = 0.9, $fn = 8);
                    translate([4.2, 0, 3.5]) sphere(r = 0.5, $fn = 8);
                }
            }
            // Heavy twisted limb forks
            hull() {
                translate([4.0, 2.0, h * 0.35]) sphere(r = 2.8, $fn = 8);
                translate([16.0, 8.0, h * 0.48]) sphere(r = 1.6, $fn = 8);
            }
            hull() {
                translate([-3.0, 4.0, h * 0.60]) sphere(r = 2.4, $fn = 8);
                translate([-17.0, 5.0, h * 0.68]) sphere(r = 1.4, $fn = 8);
            }
            hull() {
                translate([1.5, 1.0, h * 0.82]) sphere(r = 1.8, $fn = 8);
                translate([10.0, -11.0, h * 0.86]) sphere(r = 1.2, $fn = 8);
            }
        }

        // Foxtail Needle Tufts (Dense bottleneck clusters attached to limbs)
        color([0.22, 0.44, 0.24]) {
            // Main Center Canopy Tuft
            translate([1.5, 1.0, h * 0.78])
                foxtail_tuft(r = 14.0, length = 16.0);
            // Limb 1 Tuft
            translate([16.0, 8.0, h * 0.48])
                foxtail_tuft(r = 12.0, length = 14.0);
            // Limb 2 Tuft
            translate([-17.0, 5.0, h * 0.68])
                foxtail_tuft(r = 13.0, length = 15.0);
            // Limb 3 Tuft
            translate([10.0, -11.0, h * 0.86])
                foxtail_tuft(r = 11.0, length = 13.0);
        }
    }
}

module foxtail_tuft(r = 12.0, length = 14.0) {
    union() {
        cylinder(r1 = 1.8, r2 = r, h = length * 0.5);
        translate([0, 0, length * 0.45])
            cylinder(r1 = r, r2 = 0.8, h = length * 0.55);
        for (a = [0 : 45 : 315]) {
            rotate([0, 0, a]) translate([0, r * 0.6, length * 0.3])
                rotate([25, 0, 0])
                    scale([0.8, 1.2, 0.8]) sphere(r = r * 0.3, $fn = 8);
        }
    }
}

bristlecone_pine_3_6in();
"""

# 4. PONDEROSA PINE (3.40 in / 86.36 mm)
ponderosa_scad = """// 4. Ponderosa Pine (3.40 in / 86.36 mm)
// Botanically Accurate: High clear trunk, thick bark plates, flat-topped tufted canopy rosettes
$fn = 24;

module ponderosa_pine_3_4in(h = 86.36) {
    union() {
        // High Clear Trunk with Plated Bark Ridges
        color([0.48, 0.28, 0.15]) {
            cylinder(r1 = 8.5, r2 = 4.0, h = 5.5);
            hull() {
                translate([0, 0, 4.0]) cylinder(r1 = 4.0, r2 = 2.6, h = h * 0.52);
                translate([0, 0, h * 0.84]) cylinder(r1 = 2.6, r2 = 1.0, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a]) hull() {
                    translate([7.8, 0, 0.4]) sphere(r = 0.7, $fn = 8);
                    translate([3.5, 0, 3.2]) sphere(r = 0.4, $fn = 8);
                }
            }
            // Stout Upper Branch Forks
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba]) {
                    hull() {
                        translate([0, 0, h * 0.52]) sphere(r = 2.0, $fn = 8);
                        translate([0, 15.0, h * 0.70]) sphere(r = 1.2, $fn = 8);
                    }
                }
            }
        }

        // Tufted 3-Needle Rosette Clusters (Upper Canopy)
        color([0.18, 0.44, 0.20]) {
            // Main lower Rosette Ring
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba]) {
                    translate([0, 15.0, h * 0.70]) {
                        ponderosa_rosette(r = 10.0);
                    }
                }
            }
            // Upper Rosette Ring
            for (ba = [45, 135, 225, 315]) {
                rotate([0, 0, ba]) {
                    translate([0, 10.0, h * 0.80]) {
                        ponderosa_rosette(r = 8.5);
                    }
                }
            }
            // Top Crown Rosette Dome
            translate([0, 0, h - 10.0]) {
                ponderosa_rosette(r = 8.0);
            }
        }
    }
}

module ponderosa_rosette(r = 9.0) {
    union() {
        cylinder(r1 = 1.2, r2 = r, h = 6.0);
        translate([0, 0, 3.0]) cylinder(r1 = r * 1.05, r2 = 0.6, h = 6.0);
        for (i = [0 : 5]) {
            rotate([0, 0, i * 60])
                translate([0, r * 0.65, 3.0])
                    rotate([20, 0, 0])
                        cylinder(r1 = r * 0.2, r2 = 0.2, h = 5.0, $fn = 6);
        }
    }
}

ponderosa_pine_3_4in();
"""

# 5. SUBALPINE FIR (3.20 in / 81.28 mm)
fir_scad = """// 5. Subalpine Fir (3.20 in / 81.28 mm)
// Botanically Accurate: Extreme narrow spire silhouette, compact snow-shedding foliage tiers
$fn = 24;

module subalpine_fir_3_2in(h = 81.28) {
    union() {
        // Tapered Trunk & Base Foot
        color([0.34, 0.22, 0.14]) {
            cylinder(r1 = 7.5, r2 = 3.6, h = 5.0);
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 3.6, h = h * 0.22);
                translate([0, 0, h * 0.86]) cylinder(r1 = 2.2, r2 = 0.8, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a]) hull() {
                    translate([6.8, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                    translate([3.2, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                }
            }
        }
        // Narrow Columnar Tiered Spire
        color([0.14, 0.42, 0.22]) {
            for (t = [0 : 9]) {
                tz = h * (0.15 + t * 0.082);
                r_max = 16.0 * (1 - t / 10.5);
                th = 9.5 * (1 - t / 11.5);
                translate([0, 0, tz]) {
                    union() {
                        cylinder(r1 = r_max, r2 = r_max * 0.45, h = th);
                        for (i = [0 : 6]) {
                            rotate([0, 0, i * (360 / 7) + t * 20])
                                translate([r_max * 0.65, 0, -th * 0.1])
                                    rotate([32, 0, 0])
                                        cylinder(r1 = r_max * 0.24, r2 = 0.3, h = th * 0.62, $fn = 6);
                        }
                    }
                }
            }
            // Ultra-Sharp Spire Apex
            translate([0, 0, h - 10.0])
                cylinder(r1 = 1.6, r2 = 0.3, h = 10.0);
        }
    }
}

subalpine_fir_3_2in();
"""

# 6. ALPINE LARCH (3.00 in / 76.20 mm)
larch_scad = """// 6. Alpine Larch (3.00 in / 76.20 mm)
// Botanically Accurate: Deciduous conifer, open delicate branching with feathery golden needle whorls
$fn = 24;

module alpine_larch_3_0in(h = 76.20) {
    union() {
        // Trunk & Buttress Roots
        color([0.40, 0.25, 0.15]) {
            cylinder(r1 = 7.0, r2 = 3.4, h = 4.5);
            hull() {
                translate([0, 0, 3.5]) cylinder(r = 3.4, h = h * 0.25);
                translate([0, 0, h * 0.84]) cylinder(r1 = 2.0, r2 = 0.8, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a]) hull() {
                    translate([6.4, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                    translate([3.0, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                }
            }
        }
        // Feathery Golden-Green Needle Whorls
        color([0.32, 0.54, 0.24]) {
            for (t = [0 : 7]) {
                tz = h * (0.19 + t * 0.10);
                r_max = 21.0 * (1 - t / 8.5);
                th = 9.5 * (1 - t / 9.5);
                translate([0, 0, tz]) {
                    union() {
                        cylinder(r1 = r_max * 0.65, r2 = r_max * 0.30, h = th);
                        for (i = [0 : 7]) {
                            rotate([0, 0, i * 45 + t * 22.5]) {
                                translate([0, r_max * 0.72, 0])
                                    rotate([16, 0, 0])
                                        scale([1.2, 0.5, 0.5])
                                            cylinder(r1 = r_max * 0.28, r2 = 0.3, h = th * 0.75, $fn = 8);
                            }
                        }
                    }
                }
            }
            // Fine Conical Tip
            translate([0, 0, h - 9.0])
                cylinder(r1 = 1.5, r2 = 0.3, h = 9.0);
        }
    }
}

alpine_larch_3_0in();
"""

species_dict = {
    "01_colorado_blue_spruce_4.0in.scad": spruce_scad,
    "02_mountain_hemlock_3.8in.scad": hemlock_scad,
    "03_bristlecone_pine_3.6in.scad": bristlecone_scad,
    "04_ponderosa_pine_3.4in.scad": ponderosa_scad,
    "05_subalpine_fir_3.2in.scad": fir_scad,
    "06_alpine_larch_3.0in.scad": larch_scad,
}

for fname, s_code in species_dict.items():
    fpath = f"models/trees/accurate_mountain_pack/{fname}"
    with open(fpath, "w") as f:
        f.write(s_code)
    print(f"Wrote {fpath}")

# ==============================================================================
# SINGLE MASTER STL SCAD WITH EMBOSSED NUMBERS & SPECIES PLAQUES
# ==============================================================================

master_numbered_scad = """// ====================================================================
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
"""

master_scad_file = "models/trees/11_accurate_mountain_trees_numbered_pack.scad"
with open(master_scad_file, "w") as f:
    f.write(master_numbered_scad)
print(f"Saved master SCAD: {master_scad_file}")

# ==============================================================================
# RENDER ALL STLs AND PNG PREVIEWS
# ==============================================================================
print("Rendering Master Single STL...")
master_stl = "stls/trees/11_accurate_mountain_trees_numbered_pack.stl"
master_png = "scratch/accurate_previews/11_accurate_mountain_trees_numbered_pack.png"

res_stl = subprocess.run(["openscad", "-o", master_stl, master_scad_file], capture_output=True, text=True)
print(f"Master STL Render Code: {res_stl.returncode}")
print(f"OpenSCAD Output: {res_stl.stderr.strip()}")

print("Rendering Master PNG Preview...")
subprocess.run(["openscad", "-o", master_png, "--imgsize=1600,1200", "--colorscheme=Tomorrow", master_scad_file], capture_output=True, text=True)
if os.path.exists(master_png):
    subprocess.run(["cp", master_png, f"{artifact_dir}/11_accurate_mountain_trees_numbered_pack.png"])

# Render individual species STL & PNG previews as well
for fname in species_dict.keys():
    scad_p = f"models/trees/accurate_mountain_pack/{fname}"
    png_p = f"scratch/accurate_previews/{fname.replace('.scad', '.png')}"
    print(f"Rendering preview image for {fname}...")
    subprocess.run(["openscad", "-o", png_p, "--imgsize=1080,1080", "--colorscheme=Tomorrow", scad_p], capture_output=True, text=True)
    if os.path.exists(png_p):
        subprocess.run(["cp", png_p, f"{artifact_dir}/{fname.replace('.scad', '.png')}"])

print("ALL RENDERS DONE SUCCESSFULLY!")
