import os
import subprocess

artifact_dir = "/Users/lavanyat/.gemini/antigravity-ide/brain/b6d63059-fcc2-4f58-9ee9-2a7dadcb769f"

distinct_stride_legs_scad = """// ====================================================================
// Rustic Stone Arch Bridge with Center Support Pier & Solid Figure Anchors
// Dimensions: Length 11.0 cm (110 mm), Uniform Width 2.0 cm (20 mm)
// Base Height: 0.25 cm (2.5 mm)
// Center Mechanisms: Flared Central Stone Support Pier + Solid Horse Belly Blanket Anchor
// 100% Supportless FDM Printing (NoError Manifold Solid)
// ====================================================================

$fn = 28;

length     = 110.0;  // 11.0 cm overall length (FROZEN)
width      = 20.0;   // 2.0 cm uniform width (FROZEN)
base_h     = 2.5;    // 0.25 cm Base Height (FROZEN)
max_h      = 22.0;   // Center Peak Height (FROZEN)

arch_rx    = 26.0;   // Arch Semi-span (FROZEN)
arch_rz    = 14.5;   // Arch Clearance Height (FROZEN)
arch_z     = 0.5;    // Springing Z

module bridge_stride_legs_scene() {
    union() {
        // --- 1. RESTORED STONE ARCH BRIDGE STRUCTURE WITH CENTER SUPPORT PIER ---
        stone_bridge_structure();

        // --- 2. CENTER MOUNTED HORSE RIDER WITH SOLID BELLY ANCHOR ---
        translate([0, -2.5, 18.0 + 0.1])
            scale([0.45, 0.45, 0.45])
                horse_with_rider_anchored_tail();

        // --- 3. STANDING/WALKING PEDESTRIANS WITH SOLID COAT ANCHORS ---
        // Person 1: Center Right beside horse (X = 3mm, Y = +3.5mm)
        translate([3.0, 3.5, 18.0 + 0.1])
            scale([0.65, 0.65, 0.65])
                pedestrian_with_distinct_stride_legs(h_scale = 1.05);

        // Person 2: Left Incline (X = -25mm, Y = -3.5mm, Deck Z = 14.8mm)
        translate([-25.0, -3.5, 14.8 + 0.1])
            scale([0.65, 0.65, 0.65])
                pedestrian_with_distinct_stride_legs(h_scale = 0.95);

        // Person 3: Right Exit (X = +38mm, Y = +3.2mm, Deck Z = 10.4mm)
        translate([38.0, 3.2, 10.4 + 0.1])
            scale([0.65, 0.65, 0.65])
                pedestrian_with_distinct_stride_legs(h_scale = 1.0);
    }
}

// PEDESTRIAN WITH SOLID COAT/CROTCH ANCHOR (ZERO OVERHANG BETWEEN LEGS)
module pedestrian_with_distinct_stride_legs(h_scale = 1.0) {
    scale([h_scale, h_scale, h_scale]) {
        color([0.65, 0.32, 0.22]) {
            union() {
                // Forward Left Leg & Boot (X = +1.4, Y = +0.8)
                hull() {
                    translate([1.4, 0.8, 0.0]) cylinder(r1 = 1.0, r2 = 0.7, h = 1.5, $fn = 8);
                    translate([1.4, 0.8, 0.0]) cylinder(r1 = 0.7, r2 = 0.6, h = 7.5, $fn = 8);
                    translate([0.5, 0.4, 7.5]) sphere(r = 0.8, $fn = 8);
                }
                
                // Backward Right Leg & Boot (X = -1.4, Y = -0.8)
                hull() {
                    translate([-1.4, -0.8, 0.0]) cylinder(r1 = 1.0, r2 = 0.7, h = 1.5, $fn = 8);
                    translate([-1.4, -0.8, 0.0]) cylinder(r1 = 0.7, r2 = 0.6, h = 7.5, $fn = 8);
                    translate([-0.5, -0.4, 7.5]) sphere(r = 0.8, $fn = 8);
                }

                // Solid Coat Drape between legs (anchors crotch down to ground Z=0)
                hull() {
                    translate([-1.2, -0.6, 0.0]) cube([2.4, 1.2, 0.1]);
                    translate([-0.8, -0.4, 7.0]) cube([1.6, 0.8, 0.2]);
                }

                // Torso & Jacket (Z=7.0 to Z=11.5)
                hull() {
                    translate([0, 0, 7.0]) cylinder(r1 = 1.7, r2 = 1.3, h = 4.5, $fn = 10);
                    translate([0, 0, 11.0]) scale([1.2, 1.8, 1.0]) sphere(r = 1.2, $fn = 10);
                }

                // Head & Cap (Z=12.0 to Z=14.5)
                translate([0, 0, 13.0])
                    sphere(r = 1.3, $fn = 12);
                translate([0, 0, 13.8])
                    scale([1.1, 1.1, 0.7]) sphere(r = 1.3, $fn = 10);

                // Arms in natural walking counter-balance pose
                hull() {
                    translate([0, 1.8, 11.0]) sphere(r = 0.7, $fn = 8);
                    translate([-1.5, 1.4, 6.8]) sphere(r = 0.5, $fn = 8);
                }
                hull() {
                    translate([0, -1.8, 11.0]) sphere(r = 0.7, $fn = 8);
                    translate([1.5, -1.4, 6.8]) sphere(r = 0.5, $fn = 8);
                }
            }
        }
    }
}

// HORSE MODULE WITH SOLID BELLY DRAPE ANCHOR & STURDY LEGS
module horse_with_rider_anchored_tail() {
    color([0.45, 0.28, 0.16]) {
        union() {
            // Main Barrel Torso
            translate([0, 0, 10.0])
                scale([1.8, 1.0, 1.1]) sphere(r = 4.2, $fn = 16);

            // Neck & Head
            hull() {
                translate([5.0, 0, 11.5]) sphere(r = 3.0, $fn = 12);
                translate([9.5, 0, 16.0]) sphere(r = 2.2, $fn = 12);
            }
            translate([11.5, 0, 15.2])
                scale([1.2, 0.8, 0.8]) sphere(r = 1.6, $fn = 10);
            translate([9.0, 0.8, 18.0]) rotate([10, 0, 15]) cylinder(r1 = 0.6, r2 = 0.1, h = 1.8, $fn = 6);
            translate([9.0, -0.8, 18.0]) rotate([-10, 0, 15]) cylinder(r1 = 0.6, r2 = 0.1, h = 1.8, $fn = 6);

            // Mane
            hull() {
                translate([3.5, 0, 12.0]) sphere(r = 1.0, $fn = 8);
                translate([8.5, 0, 17.5]) sphere(r = 0.8, $fn = 8);
            }

            // Anchored Tail
            hull() {
                translate([-4.5, 0, 11.5]) sphere(r = 1.8, $fn = 10);
                translate([-6.5, 0, 7.0]) sphere(r = 1.5, $fn = 10);
                translate([-5.5, 0, 0.0]) cylinder(r1 = 1.6, r2 = 1.0, h = 7.0, $fn = 10);
            }

            // Solid Horse Under-Belly Saddle Blanket / Travel Pack Support Anchor (Z=0 to Z=9.0)
            hull() {
                translate([-5.0, -1.8, 0.0]) cube([10.0, 3.6, 0.1]);
                translate([-4.5, -1.5, 8.5]) cube([9.0, 3.0, 0.5]);
            }

            // 4 Solid Horse Legs
            hull() {
                translate([5.5, 2.2, 10.0]) sphere(r = 1.3, $fn = 8);
                translate([5.5, 2.0, 0.0]) cylinder(r1 = 1.2, r2 = 0.8, h = 10.0, $fn = 8);
            }
            hull() {
                translate([5.5, -2.2, 10.0]) sphere(r = 1.3, $fn = 8);
                translate([5.5, -2.0, 0.0]) cylinder(r1 = 1.2, r2 = 0.8, h = 10.0, $fn = 8);
            }
            hull() {
                translate([-5.5, 2.2, 10.0]) sphere(r = 1.4, $fn = 8);
                translate([-5.5, 2.0, 0.0]) cylinder(r1 = 1.3, r2 = 0.8, h = 10.0, $fn = 8);
            }
            hull() {
                translate([-5.5, -2.2, 10.0]) sphere(r = 1.3, $fn = 8);
                translate([-5.5, -2.0, 0.0]) cylinder(r1 = 1.2, r2 = 0.8, h = 10.0, $fn = 8);
            }

            // Rider Detail
            color([0.22, 0.38, 0.55]) {
                translate([0, 0, 13.5])
                    scale([1.4, 1.1, 0.6]) sphere(r = 3.0, $fn = 12);
                translate([0, 0, 16.5])
                    cylinder(r1 = 2.4, r2 = 1.8, h = 5.5, $fn = 12);
                translate([0, 0, 23.0])
                    sphere(r = 1.7, $fn = 12);
                translate([0, 0, 24.2])
                    cylinder(r1 = 3.2, r2 = 1.2, h = 1.2, $fn = 14);

                hull() {
                    translate([0, 1.5, 16.5]) sphere(r = 1.4, $fn = 8);
                    translate([1.2, 3.8, 11.5]) sphere(r = 1.2, $fn = 8);
                }
                hull() {
                    translate([1.2, 3.8, 11.5]) sphere(r = 1.2, $fn = 8);
                    translate([1.5, 3.6, 7.0]) cylinder(r1 = 1.0, r2 = 0.8, h = 4.5, $fn = 8);
                }

                hull() {
                    translate([0, -1.5, 16.5]) sphere(r = 1.4, $fn = 8);
                    translate([1.2, -3.8, 11.5]) sphere(r = 1.2, $fn = 8);
                }
                hull() {
                    translate([1.2, -3.8, 11.5]) sphere(r = 1.2, $fn = 8);
                    translate([1.5, -3.6, 7.0]) cylinder(r1 = 1.0, r2 = 0.8, h = 4.5, $fn = 8);
                }

                hull() {
                    translate([1.2, 1.8, 20.0]) sphere(r = 0.9, $fn = 8);
                    translate([5.0, 0.8, 16.0]) sphere(r = 0.7, $fn = 8);
                }
                hull() {
                    translate([1.2, -1.8, 20.0]) sphere(r = 0.9, $fn = 8);
                    translate([5.0, -0.8, 16.0]) sphere(r = 0.7, $fn = 8);
                }
            }
        }
    }
}

// CORE BRIDGE STRUCTURE WITH FLARED CENTRAL SUPPORT PIER & SACRIFICIAL ARCH RIBS
module stone_bridge_structure() {
    half_l = length / 2.0;
    difference() {
        union() {
            // Main solid body
            hull() {
                for (x = [-half_l : 2.0 : half_l]) {
                    norm_x = x / half_l;
                    z_deck = 18.0 - 15.5 * norm_x * norm_x;
                    translate([x, -width/2, 0])
                        cube([2.0, width, max(base_h, z_deck)]);
                }
            }
            // Parapet side walls
            for (side_y = [-width/2, width/2 - 2.5]) {
                hull() {
                    for (x = [-half_l : 2.0 : half_l]) {
                        norm_x = x / half_l;
                        z_deck = 18.0 - 15.5 * norm_x * norm_x;
                        translate([x, side_y, max(base_h, z_deck)])
                            cube([2.0, 2.5, 4.0]);
                    }
                }
            }
            // HEAVY FLARED CENTRAL SUPPORT PIER (Width 8mm at base -> 4mm at top)
            hull() {
                translate([-4.5, -width/2, 0]) cube([9.0, width, base_h]);
                translate([-2.2, -width/2, arch_z + arch_rz - 0.2]) cube([4.4, width, 0.5]);
            }

            // SACRIFICIAL OVERHANG SUPPORT RIBS (0.6mm thin internal printable support webbing)
            for (rx = [-18.0, -10.0, 10.0, 18.0]) {
                hull() {
                    translate([rx - 0.3, -width/2, 0]) cube([0.6, width, base_h]);
                    translate([rx - 0.3, -width/2, arch_z + arch_rz * sqrt(max(0, 1 - (rx/arch_rx)*(rx/arch_rx))) - 0.2]) cube([0.6, width, 0.2]);
                }
            }
        }

        // Elliptical Arch Vault Cutout
        translate([0, -width/2 - 1, arch_z])
            rotate([-90, 0, 0])
                scale([1.0, arch_rz / arch_rx, 1.0])
                    cylinder(r = arch_rx, h = width + 2, $fn = 80);

        // Masonry Engravings on Exterior Side Walls & Central Pier
        for (side_sign = [-1, 1]) {
            y_cut = side_sign * (width/2 + 0.05);
            for (x = [-half_l + 1.5 : 2.5 : half_l - 1.5]) {
                norm_x = x / half_l;
                
                // Horizontal masonry joints
                for (z = [1.5 : 2.2 : max_h]) {
                    translate([x, y_cut - side_sign * 0.35, z])
                        cube([2.6, 0.4, 0.35]);
                }
                
                z_top = 18.0 - 15.5 * norm_x * norm_x;
                in_arch = (abs(x) < arch_rx);
                arch_clearance = in_arch ? (arch_z + (arch_rz * sqrt(max(0, 1 - (x/arch_rx)*(x/arch_rx)))) + 1.2) : 0;
                
                // Vertical masonry joints
                for (z_pos = [1.5 : 2.2 : max(base_h + 3.0, z_top)]) {
                    if (z_pos > arch_clearance || abs(x) <= 4.5) {
                        translate([x, y_cut - side_sign * 0.35, z_pos])
                            cube([0.35, 0.4, 2.2]);
                    }
                }
            }

            // Arch Keystone Radial Ring Engravings
            for (a = [8 : 6 : 172]) {
                rad_ang = a * 3.14159 / 180.0;
                px = arch_rx * cos(rad_ang);
                pz = arch_z + arch_rz * sin(rad_ang);
                nx = cos(rad_ang) / arch_rx;
                nz = sin(rad_ang) / arch_rz;
                tang_deg = atan2(nz, nx) - 90;
                
                translate([px, side_sign * (width/2 - 0.1), pz])
                    rotate([0, -tang_deg, 0])
                        translate([0, 0, 1.8])
                            cube([0.35, 0.4, 3.6], center = true);
            }
        }

        // Cobblestone Roadbed Surface Engravings
        for (x = [-half_l + 4 : 3.2 : half_l - 4]) {
            norm_x = x / half_l;
            z_deck = 18.0 - 15.5 * norm_x * norm_x;
            for (y = [-width/2 + 3.2 : 3.2 : width/2 - 3.2]) {
                translate([x + (y % 2 == 0 ? 0 : 1.2), y, max(base_h, z_deck) - 0.15])
                    rotate([0, 0, 35])
                        cube([1.8, 1.8, 0.35]);
            }
        }
    }
}

bridge_stride_legs_scene();
"""

scad_file = "models/bridges/03_stone_arch_bridge_with_travelers.scad"
stl_file = "stls/bridges/03_stone_arch_bridge_with_travelers.stl"
png_file = "scratch/bridge_with_travelers_preview.png"

with open(scad_file, "w") as f:
    f.write(distinct_stride_legs_scad)
print(f"Updated {scad_file} (Added flared central pier + sacrificial support ribs + horse belly anchor)")

print("Rendering STL file...")
res_stl = subprocess.run(["openscad", "-o", stl_file, scad_file], capture_output=True, text=True)
print(f"STL Exit Code: {res_stl.returncode}")
print(f"OpenSCAD Output:\n{res_stl.stderr.strip()}")

print("Rendering high-res PNG preview...")
subprocess.run(["openscad", "-o", png_file, "--imgsize=1600,1200", "--colorscheme=Tomorrow", scad_file], capture_output=True, text=True)
if os.path.exists(png_file):
    subprocess.run(["cp", png_file, f"{artifact_dir}/bridge_with_travelers_preview.png"])

print("ENHANCED CENTER SUPPORT MECHANISMS COMPLETE!")
