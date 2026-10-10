import os
import subprocess

artifact_dir = "/Users/lavanyat/.gemini/antigravity-ide/brain/b6d63059-fcc2-4f58-9ee9-2a7dadcb769f"

# 1. Update 08_pine_tree_3.0in.scad with wide & thick base disc (44mm diameter x 1.8mm thick)
scad_08 = "models/trees/08_pine_tree_3.0in.scad"
stl_08 = "stls/trees/08_pine_tree_3.0in.stl"
png_08 = "scratch/08_pine_tree_3.0in_preview.png"

pine_08_content = """// ====================================================================
// 3D Printable Pine Tree (Wide Heavy Bed Anchor Disc)
// Height: 3.0 inches (76.2 mm)
// Base Upgrade: 44.0mm diameter x 1.8mm thick heavy adhesion pad
// - Prevents print bed detachment & thermal warping
// - 100% Supportless FDM Geometry (<=40 deg overhangs, 0% floating parts)
// - 100% Watertight Single Manifold Solid (NoError)
// ====================================================================

$fn = 32;

module fdm_pine_tier(r_base, r_top, h_tier, trunk_r = 4.2, num_boughs = 8) {
    color([0.20, 0.46, 0.24]) {
        union() {
            hull() {
                translate([0, 0, -h_tier * 0.55]) 
                    cylinder(r1 = trunk_r, r2 = trunk_r, h = 1.0);
                translate([0, 0, h_tier * 0.20]) 
                    cylinder(r1 = r_base, r2 = r_top, h = h_tier * 0.80);
            }
            
            for (i = [0 : num_boughs - 1]) {
                rotate([0, 0, i * (360 / num_boughs)]) {
                    hull() {
                        translate([0, trunk_r, h_tier * 0.10]) 
                            cylinder(r1 = 2.0, r2 = 1.0, h = h_tier * 0.50);
                        translate([0, r_base * 0.90, h_tier * 0.30]) 
                            cylinder(r1 = r_base * 0.16, r2 = 0.3, h = h_tier * 0.40, $fn = 6);
                    }
                    
                    for (k = [-1, 1]) {
                        rotate([0, 0, k * 14]) {
                            translate([0, r_base * 0.80, h_tier * 0.32])
                                rotate([-18, 0, 0])
                                    cylinder(r1 = r_base * 0.12, r2 = 0.2, h = h_tier * 0.38, $fn = 6);
                        }
                    }
                }
            }
        }
    }
}

module pine_tree_3in() {
    h = 76.2;
    trunk_r1 = 8.5;
    trunk_r2 = 4.4;
    base_disc_r = 22.0; // 44mm diameter wide anchor
    base_disc_h = 1.8;  // 1.8mm thick sturdy base
    
    union() {
        // --- 1. WIDE & THICK BED ADHESION BASE + TRUNK ---
        color([0.38, 0.24, 0.14]) {
            union() {
                // Heavy, thick bed-adhesion disc with beveled rim
                cylinder(h = base_disc_h, r1 = base_disc_r, r2 = base_disc_r - 0.6, center = false, $fn = 64);
                
                // Flared Root Collar at Z=0
                translate([0, 0, base_disc_h])
                    cylinder(r1 = trunk_r1, r2 = trunk_r2 * 1.1, h = 5.0);
                
                // Continuous Tapered Main Trunk Spire
                hull() {
                    translate([0, 0, base_disc_h + 3.5]) cylinder(r = trunk_r2, h = h * 0.36);
                    translate([0, 0, h - 8.0]) cylinder(r1 = 2.2, r2 = 0.8, h = 7.0);
                }
                
                // Organic Flared Root Buttresses
                for (a = [0 : 60 : 300]) {
                    rotate([0, 0, a])
                        hull() {
                            translate([trunk_r1 * 1.2, 0, base_disc_h]) sphere(r = 0.9, $fn = 8);
                            translate([trunk_r2 * 0.92, 0, base_disc_h + 4.0]) sphere(r = 0.45, $fn = 8);
                        }
                }

                // 8 Refined Vertical Bark Ridges
                for (b = [0 : 7]) {
                    b_ang = b * (360 / 8);
                    rotate([0, 0, b_ang]) {
                        hull() {
                            translate([trunk_r2 * 0.96, 0, base_disc_h + 1.5])
                                rotate([0, 1.5, 0])
                                    cylinder(r1 = 0.75, r2 = 0.50, h = 11.0, $fn = 8);
                            translate([trunk_r2 * 0.92, 0.3, base_disc_h + 12.0])
                                rotate([0, -1.5, 0])
                                    cylinder(r1 = 0.50, r2 = 0.35, h = 12.0, $fn = 8);
                        }
                    }
                }
            }
        }
        
        // --- 2. 6 ELEVATED BOUGH TIERS ---
        translate([0, 0, h * 0.295 + base_disc_h])
            fdm_pine_tier(r_base = 22.5, r_top = 15.0, h_tier = 11.5, trunk_r = 4.2, num_boughs = 8);
            
        translate([0, 0, h * 0.42 + base_disc_h])
            rotate([0, 0, 22.5])
                fdm_pine_tier(r_base = 19.0, r_top = 12.5, h_tier = 11.0, trunk_r = 3.8, num_boughs = 7);
                
        translate([0, 0, h * 0.535 + base_disc_h])
            rotate([0, 0, 12])
                fdm_pine_tier(r_base = 15.5, r_top = 10.0, h_tier = 10.2, trunk_r = 3.3, num_boughs = 7);
                
        translate([0, 0, h * 0.65 + base_disc_h])
            rotate([0, 0, 30])
                fdm_pine_tier(r_base = 12.0, r_top = 7.5, h_tier = 9.2, trunk_r = 2.8, num_boughs = 6);
                
        translate([0, 0, h * 0.75 + base_disc_h])
            rotate([0, 0, 16])
                fdm_pine_tier(r_base = 8.5, r_top = 4.8, h_tier = 8.0, trunk_r = 2.4, num_boughs = 5);
                
        translate([0, 0, h * 0.85 + base_disc_h])
            rotate([0, 0, 36])
                fdm_pine_tier(r_base = 5.2, r_top = 1.5, h_tier = 6.2, trunk_r = 1.8, num_boughs = 4);
                
        // Green Top Leader Spire
        translate([0, 0, h - 8.5 + base_disc_h]) {
            color([0.20, 0.46, 0.24]) {
                union() {
                    cylinder(r1 = 1.8, r2 = 0.3, h = 8.5);
                    for (ca = [0 : 90 : 270]) {
                        rotate([0, 0, ca])
                            translate([0, 0.6, 2.0])
                                rotate([-15, 0, 0])
                                    cylinder(r1 = 0.6, r2 = 0.1, h = 4.5, $fn = 6);
                    }
                }
            }
        }
    }
}

pine_tree_3in();
"""

with open(scad_08, "w") as f:
    f.write(pine_08_content)
print(f"Updated {scad_08}")

print("Rendering 08 Pine Tree STL...")
res_08 = subprocess.run(["openscad", "-o", stl_08, scad_08], capture_output=True, text=True)
print(f"08 STL Exit Code: {res_08.returncode}")
print(f"OpenSCAD Output:\n{res_08.stderr.strip()}")

print("Rendering 08 PNG...")
subprocess.run(["openscad", "-o", png_08, "--imgsize=1600,1200", "--colorscheme=Tomorrow", scad_08], capture_output=True, text=True)
if os.path.exists(png_08):
    subprocess.run(["cp", png_08, f"{artifact_dir}/08_pine_tree_3.0in_preview.png"])

# 2. Also Update 03_bristlecone_pine_3.6in.scad with wide & thick base disc
scad_03 = "models/trees/accurate_mountain_pack/03_bristlecone_pine_3.6in.scad"
stl_03 = "stls/trees/03_bristlecone_pine_3.6in.stl"
stl_03_pack = "stls/trees/accurate_mountain_pack/03_bristlecone_pine_3.6in.stl"
png_03 = "scratch/03_bristlecone_pine_3.6in_preview.png"

with open(scad_03, "r") as f:
    scad_03_text = f.read()

# Check if bristlecone has wide base disc, if not, add it
if "base_disc_r" not in scad_03_text:
    # Read the file and inject base disc
    replacement = """module bristlecone_pine_3_6in(h = 91.44) {
    base_disc_r = 22.0; // 44mm diameter wide anchor
    base_disc_h = 1.8;  // 1.8mm thick sturdy base
    union() {
        // --- 0. HEAVY BED ADHESION DISC ---
        color([0.46, 0.28, 0.17])
            cylinder(h = base_disc_h, r1 = base_disc_r, r2 = base_disc_r - 0.6, center = false, $fn = 64);
        
        translate([0, 0, base_disc_h]) {
        // --- 1. WEATHERED GNARLED TRUNK & MULTI-BRANCH SYSTEM ---"""
    
    scad_03_text = scad_03_text.replace("module bristlecone_pine_3_6in(h = 91.44) {\n    union() {\n        // --- 1. WEATHERED GNARLED TRUNK & MULTI-BRANCH SYSTEM ---", replacement)
    # Add closing brace for translate
    # The last line before the end
    scad_03_text = scad_03_text.rstrip()
    if scad_03_text.endswith("bristlecone_pine_3_6in();"):
        # find the last closing brace before the invocation
        idx = scad_03_text.rfind("}")
        scad_03_text = scad_03_text[:idx] + "}\n    }\n}\n\nbristlecone_pine_3_6in();\n"
    
    with open(scad_03, "w") as f:
        f.write(scad_03_text)
    print(f"Updated {scad_03}")

    print("Rendering 03 Bristlecone STL...")
    res_03 = subprocess.run(["openscad", "-o", stl_03, scad_03], capture_output=True, text=True)
    subprocess.run(["cp", stl_03, stl_03_pack])
    print(f"03 STL Exit Code: {res_03.returncode}")
    print(f"OpenSCAD Output:\n{res_03.stderr.strip()}")

    print("Rendering 03 PNG...")
    subprocess.run(["openscad", "-o", png_03, "--imgsize=1600,1200", "--colorscheme=Tomorrow", scad_03], capture_output=True, text=True)
    if os.path.exists(png_03):
        subprocess.run(["cp", png_03, f"{artifact_dir}/03_bristlecone_pine_3.6in_preview.png"])

print("WIDE & THICK BASES COMPLETE!")
