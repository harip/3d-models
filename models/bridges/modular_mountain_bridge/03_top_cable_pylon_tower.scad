// ====================================================================
// Modular Snap-In Mountain Bridge - PART 3: REINFORCED V-CABLE PYLON
// Height: 48.0 mm above deck
// Upgrades:
// - Widened Pylon Legs: 8.4mm in X (was 7.6mm), 6.2mm in Y (was 4.6mm)
// - Reduced Gap Between Pylons: Legs expanded inwards (inner gap reduced to 11.6mm)
// - Larger Cable Threading Holes: D = 2.6 mm (was 1.8 mm, over 2x area!)
// - Deep Conical Entry Funnels: D = 4.0 mm mouth for effortless cable threading
// - Extended Spring-Snap Tenons: 4.5mm depth with split cantilever prongs
//   (Snaps tight into through-cut deck mortises below the roadbed)
// 100% Watertight Manifold Solid for Flat Bed Printing (NoError)
// ====================================================================

$fn = 32;

deck_w   = 27.0; // Untouched deck width
tower_h  = 48.0;

// Leg centerline parameters:
// Base: Center of leg at Y = +/- 8.9 mm (spans Y = +/- 5.8mm to +/- 12.0mm)
// Peak: Center of leg at Y = +/- 11.8 mm (spans Y = +/- 9.1mm to +/- 14.5mm)
y_leg_base = 8.90;
y_leg_peak = 11.80;

leg_w_base = 6.20; // 6.2mm in Y (widened inwards to reduce separation)
leg_w_peak = 5.40; // 5.4mm in Y (ample solid meat around 2.6mm holes)
leg_x_base = 8.40; // 8.4mm in X
leg_x_peak = 6.60; // 6.6mm in X

hole_d     = 2.60; // Enlarged cable hole diameter (was 1.8mm)

function pylon_y(z, side_sign) = side_sign * (y_leg_base + (y_leg_peak - y_leg_base) * (z / tower_h));
function pylon_w_y(z) = leg_w_base + (leg_w_peak - leg_w_base) * (z / tower_h);
function pylon_w_x(z) = leg_x_base + (leg_x_peak - leg_x_base) * (z / tower_h);

module top_cable_pylon_tower_part() {
    difference() {
        union() {
            // Twin Thick V-Flared Pylon Legs (Widened inwards, reduced gap)
            for (side_sign = [-1, 1]) {
                y_bot = pylon_y(0, side_sign);        // Y = +/- 8.90 mm
                y_top = pylon_y(tower_h, side_sign); // Y = +/- 11.80 mm

                // Beefy Structural Tower Leg
                hull() {
                    // Base at deck: 8.4mm in X, 6.2mm in Y
                    translate([-leg_x_base/2, y_bot - leg_w_base/2, 0])
                        cube([leg_x_base, leg_w_base, 2.0]);
                    // Peak: 6.6mm in X, 5.4mm in Y
                    translate([-leg_x_peak/2, y_top - leg_w_peak/2, tower_h - 2.0])
                        cube([leg_x_peak, leg_w_peak, 2.0]);
                }

                // Substantial Finial Crown Sphere
                translate([0, y_top, tower_h])
                    scale([1.4, 1.3, 1.4])
                        sphere(r = 2.2, $fn = 20);

                // --- EXTENDED SPRING-LOADED SNAP-IN TENON (4.5MM LONG, SNAPS BELOW DECK) ---
                // Full 4.5mm penetration through deck with cantilever spring prongs and locking barb
                y_socket_center = side_sign * 9.50;
                tenon_x = 5.90;
                tenon_y = 3.30;
                barb_x  = 6.30;
                barb_y  = 3.60;

                difference() {
                    union() {
                        // 1. Straight upper alignment body (Z = 0 down to -3.6mm)
                        translate([-tenon_x/2, y_socket_center - tenon_y/2, -3.6])
                            cube([tenon_x, tenon_y, 3.6]);

                        // 2. Positive locking snap barb (Z = -3.6mm down to -4.1mm, expands below deck)
                        hull() {
                            translate([-barb_x/2, y_socket_center - barb_y/2, -3.9])
                                cube([barb_x, barb_y, 0.3]);
                            translate([-tenon_x/2, y_socket_center - tenon_y/2, -3.6])
                                cube([tenon_x, tenon_y, 0.1]);
                        }

                        // 3. 45-degree entry lead-in ramp (Z = -4.1mm down to -4.5mm)
                        hull() {
                            translate([-barb_x/2, y_socket_center - barb_y/2, -3.9])
                                cube([barb_x, barb_y, 0.1]);
                            translate([-4.6/2, y_socket_center - 2.4/2, -4.5])
                                cube([4.6, 2.4, 0.1]);
                        }
                    }

                    // Central compliance flex slot (enables spring-loaded deflection on entry)
                    translate([0, y_socket_center, -2.7])
                        cube([tenon_x + 1.0, 0.8, 3.8], center = true);
                }
            }

            // Heavy Cross-Bracing Struts bridging the reduced separation gap
            // Lower Cross-Strut (Z = 14mm to 19mm)
            y_mid1_inner = pylon_y(16.5, 1) - pylon_w_y(16.5)/2;
            hull() {
                translate([-2.4, -y_mid1_inner, 14.0]) cube([4.8, 2 * y_mid1_inner, 0.1]);
                translate([-2.4, -y_mid1_inner, 19.0]) cube([4.8, 2 * y_mid1_inner, 0.1]);
            }

            // Upper Cross-Strut (Z = 30mm to 35mm)
            y_mid2_inner = pylon_y(32.5, 1) - pylon_w_y(32.5)/2;
            hull() {
                translate([-2.0, -y_mid2_inner, 30.0]) cube([4.0, 2 * y_mid2_inner, 0.1]);
                translate([-2.0, -y_mid2_inner, 35.0]) cube([4.0, 2 * y_mid2_inner, 0.1]);
            }
        }

        // --- 10 ENLARGED CABLE THREADING HOLES (D = 2.6 mm) WITH DEEP ENTRY FUNNELS ---
        tower_holes_z = [9.0, 17.5, 26.0, 34.5, 42.0];
        for (tz = tower_holes_z) {
            for (side_sign = [-1, 1]) {
                y_hole = pylon_y(tz, side_sign);
                x_thick = pylon_w_x(tz);

                // Through-hole drilled along X through thick leg (D = 2.6 mm)
                translate([0, y_hole, tz])
                    rotate([0, 90, 0])
                        cylinder(d = hole_d, h = x_thick + 4.0, center = true, $fn = 24);

                // Conical funnels on both hole mouths for effortless thread insertion
                for (side_x = [-1, 1]) {
                    x_mouth = side_x * (x_thick/2 - 0.2);
                    translate([x_mouth, y_hole, tz])
                        rotate([0, (side_x > 0 ? 90 : -90), 0])
                            cylinder(r1 = hole_d/2 + 0.7, r2 = hole_d/2, h = 1.0, center = true, $fn = 20);
                }
            }
        }
    }
}

top_cable_pylon_tower_part();
