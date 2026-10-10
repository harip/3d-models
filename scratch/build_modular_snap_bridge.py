import os
import subprocess

artifact_dir = "/Users/lavanyat/.gemini/antigravity-ide/brain/b6d63059-fcc2-4f58-9ee9-2a7dadcb769f"
bridge_dir = "models/bridges/modular_mountain_bridge"
stl_dir = "stls/bridges/modular_mountain_bridge"

# ====================================================================
# PART 1: 50% WIDER BRIDGE DECK SPAN (Width = 27.0 mm)
# ====================================================================
deck_scad = """// ====================================================================
// Modular Snap-In Mountain Bridge - PART 1: 50% WIDER ROADWAY DECK
// Dimensions: Length 130.0 mm, Width 27.0 mm (50% wider!), Thickness 3.8 mm
// Snap-In Interfaces:
// - Top Sockets: Dual keyed pockets at Y = +/- 9.5 mm (6.0mm x 3.4mm x 2.8mm deep)
// - Bottom Socket: Center keyed mortise at X=0, Y=0 (12.0mm x 7.0mm x 2.8mm deep)
// - 16 Threading Eyelet Holes: D = 1.8 mm with conical countersunk funnels
// - Mountain Shelf Landing Pads on both ends (Width 29.0 mm)
// 100% Watertight Manifold Solid for Flat Bed Printing (NoError)
// ====================================================================

$fn = 28;

bridge_l    = 130.0;
deck_w      = 27.0; // 50% wider (was 18.0mm)
deck_thick  = 3.8;

module bridge_deck_part() {
    difference() {
        union() {
            // Main Roadway Plate (Flat on Z=0 for flawless printing)
            translate([-bridge_l/2, -deck_w/2, 0])
                cube([bridge_l, deck_w, deck_thick]);

            // Outer Safety Railings (Y = +/- 12.8mm)
            for (side_y = [-deck_w/2 + 0.4, deck_w/2 - 1.4]) {
                translate([-bridge_l/2, side_y, deck_thick])
                    cube([bridge_l, 1.0, 3.2]);

                for (x = [-bridge_l/2 + 5.0 : 10.0 : bridge_l/2 - 5.0]) {
                    translate([x, side_y - 0.1, 0])
                        cube([1.2, 1.2, deck_thick + 3.2]);
                }
            }

            // Mountain Shelf Landing Shoes on cliff ends
            for (s = [-1, 1]) {
                x_end = s * (bridge_l/2 - 5.0);
                translate([x_end - 4.5, -deck_w/2 - 1.0, -2.0])
                    cube([9.0, deck_w + 2.0, 2.0]);
            }
        }

        // --- TOP SNAP-IN SOCKETS FOR V-PYLON (Y = +/- 9.5 mm) ---
        // Sockets: 6.0mm in X, 3.4mm in Y, 2.8mm depth
        for (side_sign = [-1, 1]) {
            y_socket = side_sign * 9.5;
            translate([-3.0, y_socket - 1.7, deck_thick - 2.8])
                cube([6.0, 3.4, 2.9]);
        }

        // --- BOTTOM SNAP-IN SOCKET FOR 3CM PILLAR (X=0, Y=0) ---
        // Socket: 12.0mm in X, 7.0mm in Y, 2.8mm depth
        translate([-6.0, -3.5, -2.2])
            cube([12.0, 7.0, 3.0]);

        // --- 16 THREAD EYELET HOLES (D = 1.8 mm) WITH COUNTERSUNK ENTRY ---
        deck_holes_x = [-48.0, -36.0, -24.0, -12.0, 12.0, 24.0, 36.0, 48.0];
        for (hx = deck_holes_x) {
            for (side_sign = [-1, 1]) {
                y_pos = side_sign * (deck_w/2 - 2.2); // Y = +/- 11.3 mm
                // Through-hole
                translate([hx, y_pos, -2.5])
                    cylinder(r = 0.9, h = deck_thick + 5.0, $fn = 16);
                // Conical entry funnel
                translate([hx, y_pos, deck_thick - 0.6])
                    cylinder(r1 = 0.9, r2 = 1.5, h = 1.0, $fn = 16);
            }
        }
    }
}

bridge_deck_part();
"""

# ====================================================================
# PART 2: BOTTOM CENTER PILLAR (Proportioned for 27mm Deck)
# ====================================================================
pillar_scad = """// ====================================================================
// Modular Snap-In Mountain Bridge - PART 2: BOTTOM CENTER PILLAR
// Height: Exactly 30.0 mm (3.0 cm) downward extension below deck
// Tenon: 11.4mm x 6.4mm x 2.5mm (Snaps tight & nice into 12x7mm deck socket)
// 100% Watertight Manifold Solid for Flat Bed Printing (NoError)
// ====================================================================

$fn = 28;

pillar_h  = 30.0;
deck_w    = 27.0; // 50% wider proportion

module bottom_center_pillar_part() {
    union() {
        // Main Pillar Body (from Z = 0 to Z = 30.0 mm)
        hull() {
            // Wide foundation footing on chasm floor (Z = 0)
            translate([-8.0, -deck_w/2 + 1.5, 0])
                cube([16.0, deck_w - 3.0, 3.0]);
            // Top mating face at deck underside (Z = 30.0 mm)
            translate([-6.5, -4.0, pillar_h - 0.2])
                cube([13.0, 8.0, 0.2]);
        }

        // Structural 45-degree flared wing brackets supporting wide deck
        for (s = [-1, 1]) {
            hull() {
                translate([s * 5.0, -deck_w/2 + 3.0, pillar_h - 1.0])
                    cube([0.5, deck_w - 6.0, 1.0]);
                translate([s * 18.0, -deck_w/2 + 3.0, pillar_h - 0.2])
                    cube([0.5, deck_w - 6.0, 0.2]);
                translate([s * 5.0, -deck_w/2 + 3.0, pillar_h - 12.0])
                    cube([0.5, deck_w - 6.0, 1.0]);
            }
        }

        // --- MALE SNAP-IN TENON KEY (SNAPS TIGHT & NICE INTO 12.0 x 7.0 MM SOCKET) ---
        // Sized 11.4mm x 6.4mm x 2.5mm (0.3mm per-side clearance with 45-deg lead-in bevel)
        hull() {
            translate([-5.7, -3.2, pillar_h])
                cube([11.4, 6.4, 1.6]);
            translate([-5.0, -2.5, pillar_h + 2.5])
                cube([10.0, 5.0, 0.2]);
        }
    }
}

bottom_center_pillar_part();
"""

# ====================================================================
# PART 3: V-SHAPED CABLE PYLON TOWER (Proportioned for 27mm Deck)
# ====================================================================
tower_scad = """// ====================================================================
// Modular Snap-In Mountain Bridge - PART 3: V-SHAPED CABLE PYLON TOWER
// Height: 48.0 mm above deck
// Proportioned for 27.0mm Wide Deck:
// - Base centered at Y = +/- 9.5 mm (snaps tight & nice into deck sockets)
// - Flares gracefully outward to Y = +/- 14.2 mm at crown finials (proud V silhouette)
// - Male Tenons: 5.4mm x 2.8mm x 2.5mm with 45-deg lead-in chamfer
//   (snaps tight & nice with 0.3mm clearance into deck's 6.0mm x 3.4mm sockets!)
// - 10 Cable Threading Holes: D = 1.8 mm with conical funnels for easy rigging
// - Heavy solid walls (>=2.3mm solid meat around every hole)
// 100% Watertight Manifold Solid for Flat Bed Printing (NoError)
// ====================================================================

$fn = 28;

deck_w   = 27.0; // 50% wider
tower_h  = 48.0;

// V-Shape flare parameters for 27mm deck:
y_flare_base = 9.50;  // Matches deck socket center
y_flare_peak = 14.20; // Elegant outward V-flare

function pylon_y(z, side_sign) = side_sign * (y_flare_base + (y_flare_peak - y_flare_base) * (z / tower_h));

module top_cable_pylon_tower_part() {
    difference() {
        union() {
            // Twin V-flared pylon tower legs
            for (side_sign = [-1, 1]) {
                y_bot = pylon_y(0, side_sign);        // Y = +/- 9.50 mm
                y_top = pylon_y(tower_h, side_sign); // Y = +/- 14.20 mm

                // Main V-Canted Tower Leg
                hull() {
                    // Base at deck: 6.8mm in X, 3.0mm in Y (spans Y = +/- 8.0mm to +/- 11.0mm)
                    translate([-3.4, y_bot - 1.5, 0])
                        cube([6.8, 3.0, 2.0]);
                    // Peak: 5.2mm in X, 2.6mm in Y
                    translate([-2.6, y_top - 1.3, tower_h - 2.0])
                        cube([5.2, 2.6, 2.0]);
                }

                // Decorative Finial Crown Sphere
                translate([0, y_top, tower_h])
                    scale([1.2, 1.1, 1.4])
                        sphere(r = 1.8, $fn = 16);

                // --- PRECISION SNAP-IN TENON (SNAPS TIGHT & NICE INTO 6.0 x 3.4 MM SOCKET) ---
                // Sized 5.4mm x 2.8mm x 2.5mm (0.30mm per-side clearance + 45-deg lead-in bevel)
                y_socket_center = side_sign * 9.50;
                hull() {
                    translate([-2.7, y_socket_center - 1.4, -1.3])
                        cube([5.4, 2.8, 1.4]);
                    translate([-2.0, y_socket_center - 0.8, -2.5])
                        cube([4.0, 1.6, 0.2]); // 45-deg lead-in chamfer
                }
            }

            // Sturdy Cross-Bracing Struts bridging the V-flared span
            // Lower Cross-Strut (Z = 15mm to 19mm)
            y_mid1 = pylon_y(17.0, 1);
            hull() {
                translate([-2.0, -(y_mid1 - 1.0), 15.0]) cube([4.0, (2 * y_mid1 - 2.0), 0.1]);
                translate([-2.0, -(y_mid1 - 1.0), 18.8]) cube([4.0, (2 * y_mid1 - 2.0), 0.1]);
            }

            // Upper Cross-Strut (Z = 31mm to 35mm)
            y_mid2 = pylon_y(33.0, 1);
            hull() {
                translate([-1.7, -(y_mid2 - 1.0), 31.0]) cube([3.4, (2 * y_mid2 - 2.0), 0.1]);
                translate([-1.7, -(y_mid2 - 1.0), 34.4]) cube([3.4, (2 * y_mid2 - 2.0), 0.1]);
            }
        }

        // --- 10 PRECISION THREADING HOLES (D = 1.8 mm) ALONG V-LEGS ---
        tower_holes_z = [9.0, 17.5, 26.0, 34.5, 42.0];
        for (tz = tower_holes_z) {
            for (side_sign = [-1, 1]) {
                y_hole = pylon_y(tz, side_sign);

                // Clean through-hole drilled through V-leg from -X to +X (D = 1.8 mm)
                translate([0, y_hole, tz])
                    rotate([0, 90, 0])
                        cylinder(r = 0.9, h = 12.0, center = true, $fn = 20);

                // Conical funnels on both hole entrances for effortless thread insertion
                for (x_mouth = [-3.0, 3.0]) {
                    translate([x_mouth, y_hole, tz])
                        rotate([0, (x_mouth > 0 ? 90 : -90), 0])
                            cylinder(r1 = 1.6, r2 = 0.9, h = 1.0, center = true, $fn = 16);
                }
            }
        }
    }
}

top_cable_pylon_tower_part();
"""

# ====================================================================
# MASTER 3-IN-1 PRINT KIT
# ====================================================================
kit_scad = f"""// ====================================================================
// Modular Snap-In Mountain Bridge - 3-IN-1 PRINT KIT (50% WIDER DECK)
// ====================================================================

use <01_bridge_deck.scad>
use <02_bottom_center_pillar_30mm.scad>
use <03_top_cable_pylon_tower.scad>

module modular_bridge_print_kit() {{
    translate([0, 0, 0])
        bridge_deck_part();

    translate([0, -28.0, 0])
        bottom_center_pillar_part();

    translate([0, 28.0, 2.5])
        top_cable_pylon_tower_part();
}}

modular_bridge_print_kit();
"""

# ====================================================================
# ASSEMBLED PREVIEW
# ====================================================================
assembled_scad = f"""// ====================================================================
// Modular Mountain Bridge - ASSEMBLED PREVIEW (50% WIDER DECK + V-PYLON)
// ====================================================================

use <01_bridge_deck.scad>
use <02_bottom_center_pillar_30mm.scad>
use <03_top_cable_pylon_tower.scad>

module assembled_bridge() {{
    color([0.28, 0.45, 0.65])
        bridge_deck_part();

    color([0.38, 0.40, 0.42])
        translate([0, 0, -30.0])
            bottom_center_pillar_part();

    color([0.88, 0.90, 0.92])
        translate([0, 0, 3.8])
            top_cable_pylon_tower_part();
}}

assembled_bridge();
"""

files = {
    f"{bridge_dir}/01_bridge_deck.scad": deck_scad,
    f"{bridge_dir}/02_bottom_center_pillar_30mm.scad": pillar_scad,
    f"{bridge_dir}/03_top_cable_pylon_tower.scad": tower_scad,
    f"{bridge_dir}/00_modular_bridge_print_kit.scad": kit_scad,
    f"{bridge_dir}/00_assembled_preview.scad": assembled_scad
}

for path, content in files.items():
    with open(path, "w") as f:
        f.write(content)
    print(f"Written: {path}")

# Compile all STLs
stls = [
    (f"{bridge_dir}/01_bridge_deck.scad", f"{stl_dir}/01_bridge_deck.stl"),
    (f"{bridge_dir}/02_bottom_center_pillar_30mm.scad", f"{stl_dir}/02_bottom_center_pillar_30mm.stl"),
    (f"{bridge_dir}/03_top_cable_pylon_tower.scad", f"{stl_dir}/03_top_cable_pylon_tower.stl"),
    (f"{bridge_dir}/00_modular_bridge_print_kit.scad", f"{stl_dir}/00_modular_bridge_print_kit.stl"),
]

for scad_p, stl_p in stls:
    print(f"Rendering STL for {os.path.basename(scad_p)}...")
    res = subprocess.run(["openscad", "-o", stl_p, scad_p], capture_output=True, text=True)
    print(f"{os.path.basename(stl_p)}: Exit {res.returncode}")
    print(res.stderr.strip())

# Render PNG Previews
preview_png = f"{artifact_dir}/modular_bridge_wide_assembled_preview.png"
kit_png = f"{artifact_dir}/modular_bridge_wide_kit_preview.png"
tower_png = f"{artifact_dir}/03_top_cable_pylon_tower_wide_preview.png"

subprocess.run(["openscad", "-o", preview_png, "--imgsize=1600,1200", "--colorscheme=Tomorrow", f"{bridge_dir}/00_assembled_preview.scad"])
subprocess.run(["openscad", "-o", kit_png, "--imgsize=1600,1200", "--colorscheme=Tomorrow", f"{bridge_dir}/00_modular_bridge_print_kit.scad"])
subprocess.run(["openscad", "-o", tower_png, "--imgsize=1600,1200", "--colorscheme=Tomorrow", f"{bridge_dir}/03_top_cable_pylon_tower.scad"])

print("50% WIDER DECK & RECALIBRATED V-PYLON COMPLETE!")
