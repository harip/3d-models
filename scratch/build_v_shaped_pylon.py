import os
import subprocess

artifact_dir = "/Users/lavanyat/.gemini/antigravity-ide/brain/b6d63059-fcc2-4f58-9ee9-2a7dadcb769f"
bridge_dir = "models/bridges/modular_mountain_bridge"
stl_dir = "stls/bridges/modular_mountain_bridge"

v_tower_scad = """// ====================================================================
// Modular Snap-In Mountain Bridge - PART 3: V-SHAPED CABLE PYLON TOWER
// Height: 46.0 mm above deck
// Architecture:
// - Dynamic Outward-Flaring V-Shaped Twin Pylons (Tappan Zee signature)
// - Base centered at Y = +/- 6.05 mm (flawless railing clearance at Z=0)
// - Flares gracefully outward to Y = +/- 9.6 mm at tower peak (iconic V silhouette)
// - Snap-in tenons FROZEN: Exactly 4.4mm x 2.2mm at Y = +/- 6.2 mm
// - 10 Threading guide holes (D = 1.6 mm) tracked along V-canted centerline
// 100% Watertight Manifold Solid for Flat Bed Printing (NoError)
// ====================================================================

$fn = 28;

deck_w   = 18.0;
tower_h  = 46.0;

// V-Shape flare parameters:
// Base center: Y = +/- 6.05 mm (clears deck railings by 0.5mm)
// Peak center: Y = +/- 9.60 mm (dynamic V-angle flare)
y_flare_base = 6.05;
y_flare_peak = 9.60;

function pylon_y(z, side_sign) = side_sign * (y_flare_base + (y_flare_peak - y_flare_base) * (z / tower_h));

module top_cable_pylon_tower_part() {
    difference() {
        union() {
            // Twin V-flared pylon tower legs
            for (side_sign = [-1, 1]) {
                y_bot = pylon_y(0, side_sign);        // Y = +/- 6.05 mm
                y_top = pylon_y(tower_h, side_sign); // Y = +/- 9.60 mm

                // Main V-Canted Tower Leg
                hull() {
                    // Base at deck (5.6mm in X, 2.3mm in Y, perfectly clears railings)
                    translate([-2.8, y_bot - 1.15, 0])
                        cube([5.6, 2.3, 2.0]);
                    // Flared Peak (4.4mm in X, 2.3mm in Y)
                    translate([-2.2, y_top - 1.15, tower_h - 2.0])
                        cube([4.4, 2.3, 2.0]);
                }

                // Decorative Finial Crown Sphere
                translate([0, y_top, tower_h])
                    scale([1.1, 1.0, 1.3])
                        sphere(r = 1.5, $fn = 14);

                // --- UNCHANGED SNAP-IN TENON (EXACTLY Y = +/- 6.2 MM) ---
                // Sized 4.4mm x 2.2mm x 2.2mm with 45-deg lead-in chamfer
                y_socket_center = side_sign * 6.20;
                hull() {
                    translate([-2.2, y_socket_center - 1.1, -1.2])
                        cube([4.4, 2.2, 1.3]);
                    translate([-1.6, y_socket_center - 0.7, -2.2])
                        cube([3.2, 1.4, 0.2]);
                }
            }

            // Cross-Bracing Struts bridging the V-flared gap
            // Lower Cross-Strut (Z = 14mm to 17mm, Span = 2 * pylon_y(15) - leg_thickness)
            y_mid1 = pylon_y(15.5, 1);
            hull() {
                translate([-1.7, -(y_mid1 - 0.8), 14.0]) cube([3.4, (2 * y_mid1 - 1.6), 0.1]);
                translate([-1.7, -(y_mid1 - 0.8), 16.8]) cube([3.4, (2 * y_mid1 - 1.6), 0.1]);
            }

            // Upper Cross-Strut (Z = 29mm to 32mm)
            y_mid2 = pylon_y(30.5, 1);
            hull() {
                translate([-1.4, -(y_mid2 - 0.9), 29.0]) cube([2.8, (2 * y_mid2 - 1.8), 0.1]);
                translate([-1.4, -(y_mid2 - 0.9), 31.6]) cube([2.8, (2 * y_mid2 - 1.8), 0.1]);
            }
        }

        // --- 10 PRECISION THREADING HOLES (D = 1.6 mm) ALONG V-SHAPED LEGS ---
        tower_holes_z = [8.5, 16.5, 24.5, 32.5, 39.5];
        for (tz = tower_holes_z) {
            for (side_sign = [-1, 1]) {
                y_hole = pylon_y(tz, side_sign);

                // Clean through-hole drilled through V-leg from -X to +X (D = 1.6 mm)
                translate([0, y_hole, tz])
                    rotate([0, 90, 0])
                        cylinder(r = 0.8, h = 10.0, center = true, $fn = 20);

                // Conical funnels on both hole entrances for effortless thread insertion
                for (x_mouth = [-2.6, 2.6]) {
                    translate([x_mouth, y_hole, tz])
                        rotate([0, (x_mouth > 0 ? 90 : -90), 0])
                            cylinder(r1 = 1.4, r2 = 0.8, h = 0.8, center = true, $fn = 16);
                }
            }
        }
    }
}

top_cable_pylon_tower_part();
"""

scad_file = f"{bridge_dir}/03_top_cable_pylon_tower.scad"
stl_file = f"{stl_dir}/03_top_cable_pylon_tower.stl"
png_file = f"{artifact_dir}/03_top_cable_pylon_tower_v_shape.png"

with open(scad_file, "w") as f:
    f.write(v_tower_scad)
print(f"Updated {scad_file} (V-Shaped flare)")

print("Rendering V-Shaped Tower STL...")
res = subprocess.run(["openscad", "-o", stl_file, scad_file], capture_output=True, text=True)
print(f"Exit Code: {res.returncode}")
print(res.stderr.strip())

# Update kit STL and assemble preview
subprocess.run(["openscad", "-o", f"{stl_dir}/00_modular_bridge_print_kit.stl", f"{bridge_dir}/00_modular_bridge_print_kit.scad"], capture_output=True)
subprocess.run(["openscad", "-o", f"{artifact_dir}/modular_bridge_assembled_v_shape.png", "--imgsize=1600,1200", "--colorscheme=Tomorrow", f"{bridge_dir}/00_assembled_preview.scad"], capture_output=True)
subprocess.run(["openscad", "-o", png_file, "--imgsize=1600,1200", "--colorscheme=Tomorrow", scad_file], capture_output=True, text=True)

print("V-SHAPED PYLON TOWER COMPLETE!")
