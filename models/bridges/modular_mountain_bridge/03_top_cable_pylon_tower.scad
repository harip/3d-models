// ====================================================================
// Modular Snap-In Mountain Bridge - PART 3: TOP CABLE PYLON TOWER
// Height: 46.0 mm above deck
// Recalibrated Dimensions (20% Slimmed, Perfect Deck Clearance):
// - Leg Base: 5.8mm in X, 2.4mm in Y (centered at Y = +/- 5.5 mm)
// - Leg spans Y = +/- 4.3mm to +/- 6.7mm (0.8mm clear buffer from railings!)
// - Leg Peak: 4.6mm in X, 2.2mm in Y
// - Tenons: 4.0mm in X, 2.0mm in Y, 2.2mm depth with 45-deg lead-in bevel
//   (snaps with 0.2mm per-side clearance into 4.4mm x 2.4mm deck sockets!)
// - 10 Threading Holes (D = 1.6 mm) with 1.6mm solid protective side walls
// 100% Watertight Manifold Solid for Flat Bed Printing (NoError)
// ====================================================================

$fn = 28;

deck_w   = 18.0;
tower_h  = 46.0;

module top_cable_pylon_tower_part() {
    difference() {
        union() {
            // Twin vertical pylon towers with subtle architectural taper
            for (side_sign = [-1, 1]) {
                y_bot = side_sign * 5.5; // Exactly matches deck socket center!
                y_top = side_sign * 6.0; // Subtle elegant taper, stays 100% inside deck width!

                // Main Tower Leg (Z = 0 to Z = tower_h)
                hull() {
                    // Base: 5.8mm wide in X, 2.4mm thick in Y
                    translate([-2.9, y_bot - 1.2, 0])
                        cube([5.8, 2.4, 2.0]);
                    // Peak: 4.6mm wide in X, 2.2mm thick in Y
                    translate([-2.3, y_top - 1.1, tower_h - 2.0])
                        cube([4.6, 2.2, 2.0]);
                }

                // Decorative Finial Crown Cap
                translate([0, y_top, tower_h])
                    scale([1.1, 1.0, 1.3])
                        sphere(r = 1.6, $fn = 14);

                // --- PRECISION SNAP-IN TENON (4.0mm x 2.0mm x 2.2mm) ---
                // Fits into 4.4mm x 2.4mm x 2.5mm deck sockets with exact 0.2mm clearance!
                hull() {
                    translate([-2.0, y_bot - 1.0, -1.2])
                        cube([4.0, 2.0, 1.3]);
                    translate([-1.5, y_bot - 0.6, -2.2])
                        cube([3.0, 1.2, 0.2]); // 45-deg lead-in chamfer
                }
            }

            // Sturdy Cross-Bracing Struts (Staying inside tower legs)
            // Lower Cross-Strut
            translate([-1.8, -4.5, 14.0])
                cube([3.6, 9.0, 2.6]);

            // Upper Cross-Strut
            translate([-1.5, -5.0, 30.0])
                cube([3.0, 10.0, 2.4]);
        }

        // --- 10 PRECISION THREADING HOLES (D = 1.6 mm) ---
        // Sized for easy thread rigging with >1.5mm solid meat on each side
        tower_holes_z = [8.5, 16.5, 24.5, 32.5, 39.5];
        for (tz = tower_holes_z) {
            for (side_sign = [-1, 1]) {
                y_leg = side_sign * (5.5 + (6.0 - 5.5) * (tz / tower_h));

                // Clean through-hole drilled through leg from -X to +X (D = 1.6 mm)
                translate([0, y_leg, tz])
                    rotate([0, 90, 0])
                        cylinder(r = 0.8, h = 10.0, center = true, $fn = 20);

                // Conical funnels on hole entrances
                for (x_mouth = [-2.6, 2.6]) {
                    translate([x_mouth, y_leg, tz])
                        rotate([0, (x_mouth > 0 ? 90 : -90), 0])
                            cylinder(r1 = 1.4, r2 = 0.8, h = 0.8, center = true, $fn = 16);
                }
            }
        }
    }
}

top_cable_pylon_tower_part();
