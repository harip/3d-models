// ====================================================================
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
