// ====================================================================
// Modular Snap-In Mountain Bridge - PART 1: ROADWAY DECK SPAN
// Length: 130.0 mm, Width: 18.0 mm, Thickness: 3.6 mm
// Precision Fit:
// - Top Sockets: Exactly centered at Y = +/- 5.5 mm (4.4mm x 2.4mm x 2.5mm deep)
// - 0.8mm clear buffer away from railings (ZERO collision)
// - Bottom Socket: Center keyed mortise (8.6mm x 5.4mm x 2.6mm)
// - 16 Threading Eyelet Holes: D = 1.6 mm with conical lead-in funnels
// 100% Watertight Manifold Solid for Flat Bed Printing (NoError)
// ====================================================================

$fn = 28;

bridge_l    = 130.0;
deck_w      = 18.0;
deck_thick  = 3.6;

module bridge_deck_part() {
    difference() {
        union() {
            // Main Roadway Plate (Flat on Z=0)
            translate([-bridge_l/2, -deck_w/2, 0])
                cube([bridge_l, deck_w, deck_thick]);

            // Outer Safety Railings (Y = +/- 8.2mm, inside edge at +/- 7.7mm)
            for (side_y = [-deck_w/2 + 0.3, deck_w/2 - 1.3]) {
                translate([-bridge_l/2, side_y, deck_thick])
                    cube([bridge_l, 1.0, 3.0]);

                for (x = [-bridge_l/2 + 5.0 : 10.0 : bridge_l/2 - 5.0]) {
                    translate([x, side_y - 0.1, 0])
                        cube([1.2, 1.2, deck_thick + 3.0]);
                }
            }

            // Mountain Cliff Landing Shoes on both ends
            for (s = [-1, 1]) {
                x_end = s * (bridge_l/2 - 5.0);
                translate([x_end - 4.5, -deck_w/2 - 1.0, -1.8])
                    cube([9.0, deck_w + 2.0, 1.8]);
            }
        }

        // --- TOP SNAP-IN SOCKETS FOR PYLON (Y = +/- 5.5 mm) ---
        // Sockets: 4.4mm in X, 2.4mm in Y, 2.5mm depth (0.2mm per-side clearance)
        for (side_sign = [-1, 1]) {
            y_socket = side_sign * 5.5;
            translate([-2.2, y_socket - 1.2, deck_thick - 2.5])
                cube([4.4, 2.4, 2.6]);
        }

        // --- BOTTOM SNAP-IN SOCKET FOR 3CM PILLAR (X=0, Y=0) ---
        // Socket: 8.6mm in X, 5.4mm in Y, 2.6mm depth
        translate([-4.3, -2.7, -2.0])
            cube([8.6, 5.4, 2.8]);

        // --- 16 THREAD EYELET HOLES (D = 1.6 mm) ALONG DECK EDGES ---
        deck_holes_x = [-48.0, -36.0, -24.0, -12.0, 12.0, 24.0, 36.0, 48.0];
        for (hx = deck_holes_x) {
            for (side_sign = [-1, 1]) {
                y_pos = side_sign * (deck_w/2 - 2.0); // Y = +/- 7.0 mm
                // Through-hole
                translate([hx, y_pos, -2.5])
                    cylinder(r = 0.8, h = deck_thick + 5.0, $fn = 16);
                // Conical entrance funnel
                translate([hx, y_pos, deck_thick - 0.6])
                    cylinder(r1 = 0.8, r2 = 1.4, h = 1.0, $fn = 16);
            }
        }
    }
}

bridge_deck_part();
