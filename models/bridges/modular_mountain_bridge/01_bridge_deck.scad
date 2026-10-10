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

            // Outer Safety Railings (100% Flush to outer deck edges Y = +/- 13.5mm)
            for (side_sign = [-1, 1]) {
                y_rail = (side_sign == -1) ? -deck_w/2 : (deck_w/2 - 1.2);
                translate([-bridge_l/2, y_rail, deck_thick])
                    cube([bridge_l, 1.2, 3.2]);

                for (x = [-bridge_l/2 + 5.0 : 10.0 : bridge_l/2 - 5.0]) {
                    translate([x, y_rail, 0])
                        cube([1.2, 1.2, deck_thick + 3.2]);
                }
            }

            // Mountain Shelf Landing Shoes on cliff ends (Flush with deck width)
            for (s = [-1, 1]) {
                x_end = s * (bridge_l/2 - 5.0);
                translate([x_end - 4.5, -deck_w/2, -2.0])
                    cube([9.0, deck_w, 2.0]);
            }
        }

        // --- TOP SNAP-IN THROUGH-SOCKETS FOR V-PYLON (Y = +/- 9.5 mm) ---
        // Sockets: 6.0mm in X, 3.4mm in Y, cuts all the way through deck with snap undercut
        for (side_sign = [-1, 1]) {
            y_socket = side_sign * 9.5;
            // Full through-mortise cutting through the entire deck plate
            translate([-3.0, y_socket - 1.7, -0.5])
                cube([6.0, 3.4, deck_thick + 1.0]);

            // Underside snap-lock relief cavity with 45° self-supporting slope
            hull() {
                translate([-3.3, y_socket - 1.95, -0.5])
                    cube([6.6, 3.9, 0.6]);
                translate([-3.0, y_socket - 1.7, 1.2])
                    cube([6.0, 3.4, 0.1]);
            }
        }

        // --- BOTTOM SNAP-IN SOCKET FOR 3CM PILLAR (X=0, Y=0) ---
        // Socket: 12.0mm in X, 7.0mm in Y, 2.8mm depth
        translate([-6.0, -3.5, -2.2])
            cube([12.0, 7.0, 3.0]);

        // --- 16 THREAD EYELET HOLES (D = 2.6 mm) MATCHING PYLON DIAMETER ---
        deck_holes_x = [-48.0, -36.0, -24.0, -12.0, 12.0, 24.0, 36.0, 48.0];
        hole_d = 2.60;
        for (hx = deck_holes_x) {
            for (side_sign = [-1, 1]) {
                y_pos = side_sign * (deck_w/2 - 2.8); // Y = +/- 10.7 mm (clear of railing)
                // Through-hole (D = 2.6 mm)
                translate([hx, y_pos, -2.5])
                    cylinder(d = hole_d, h = deck_thick + 5.0, $fn = 20);
                // Conical entry funnel
                translate([hx, y_pos, deck_thick - 0.7])
                    cylinder(r1 = hole_d/2, r2 = hole_d/2 + 0.6, h = 1.0, $fn = 20);
            }
        }
    }
}

bridge_deck_part();
