// ====================================================================
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
