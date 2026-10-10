// ====================================================================
// Tappan Zee Style Cable-Stayed Bridge (Governor Mario M. Cuomo Inspired)
// Dimensions: Length 136.0 mm, Width 28.0 mm, Tower Peak Height 54.0 mm
// Architecture:
// - Iconic outward-canted faceted center towers (Tappan Zee / Cuomo signature)
// - 16 Solid cable-stay fan rods connecting center pylon to roadway deck
// - Aerodynamic girder deck with safety barriers & approach piers
// - Heavy riverbed foundation plate (100% bed adhesion, anti-warp)
// 100% Watertight Manifold Solid for Supportless FDM 3D Printing (NoError)
// ====================================================================

$fn = 28;

bridge_l    = 136.0; // Total length
base_w      = 28.0;  // Water base width
deck_w      = 18.0;  // Road deck width
base_h      = 2.0;   // Water base thickness
deck_z      = 12.0;  // Roadway deck elevation
tower_top_z = 54.0;  // Center tower pylon peak

module tappan_zee_cable_bridge() {
    union() {
        // --- 1. RIVERBED FOUNDATION & CUTWATER NAVIGATION PIERS ---
        riverbed_and_piers();

        // --- 2. ROADWAY GIRDER DECK & BARRIERS ---
        roadway_deck();

        // --- 3. TAPPAN ZEE SIGNATURE OUTWARD-CANTED CENTER PYLON TOWER ---
        tappan_zee_center_tower();

        // --- 4. FAN CABLE-STAYS CONNECTING CENTER TOWER TO DECK ---
        cable_stay_system();
    }
}

// 1. RIVERBED FOUNDATION & PIERS
module riverbed_and_piers() {
    // Water baseplate with smooth rounded anti-warp corners
    hull() {
        for (x = [-bridge_l/2 + 3.5, bridge_l/2 - 3.5])
            for (y = [-base_w/2 + 3.5, base_w/2 - 3.5])
                translate([x, y, 0]) cylinder(r = 3.5, h = base_h, $fn = 24);
    }

    // Stylized river flow contours
    for (x = [-42 : 14 : 42]) {
        translate([x, 0, base_h - 0.2])
            scale([1.8, 1.0, 0.4])
                cylinder(r = 8.0, h = 0.4, $fn = 20);
    }

    // Heavy Central Navigation Pier (Supporting Center Tower & Midspan)
    hull() {
        // Aerodynamic pointed cutwater base at water level
        translate([-11.0, 0, 0]) cylinder(r = 7.0, h = base_h, $fn = 20);
        translate([11.0, 0, 0]) cylinder(r = 7.0, h = base_h, $fn = 20);
        
        // Tapered pier cap under deck
        translate([-8.5, 0, deck_z - 0.5]) cylinder(r = 5.5, h = 0.5, $fn = 20);
        translate([8.5, 0, deck_z - 0.5]) cylinder(r = 5.5, h = 0.5, $fn = 20);
    }

    // Left & Right Approach Piers
    for (s = [-1, 1]) {
        px = s * 42.0;
        hull() {
            translate([px - 4.0, -deck_w/2 + 1.5, 0]) cube([8.0, deck_w - 3.0, base_h]);
            translate([px - 2.5, -deck_w/2 + 1.5, deck_z - 0.5]) cube([5.0, deck_w - 3.0, 0.5]);
        }
        
        // End Abutment Ramps
        ax = s * (bridge_l/2 - 9.0);
        hull() {
            translate([ax - 8.0, -base_w/2 + 1.5, 0]) cube([16.0, base_w - 3.0, base_h]);
            translate([ax - 6.0, -deck_w/2, deck_z - 1.0]) cube([12.0, deck_w, 1.0]);
        }
    }
}

// 2. ROADWAY GIRDER DECK & BARRIERS
module roadway_deck() {
    // Aerodynamic Trapezoidal Box Girder Deck
    hull() {
        translate([-bridge_l/2 + 2.0, -deck_w/2, deck_z])
            cube([bridge_l - 4.0, deck_w, 2.2]);
        translate([-bridge_l/2 + 4.0, -deck_w/2 + 2.0, deck_z - 2.0])
            cube([bridge_l - 8.0, deck_w - 4.0, 0.5]);
    }

    // Roadway Center Median Barrier
    translate([-bridge_l/2 + 5.0, -0.6, deck_z + 2.2])
        cube([bridge_l - 10.0, 1.2, 0.6]);

    // Outer Safety Parapet Railings with Stanchion Posts
    for (side_y = [-deck_w/2 + 0.3, deck_w/2 - 1.3]) {
        // Continuous Handrail Barrier
        translate([-bridge_l/2 + 3.0, side_y, deck_z + 2.2])
            cube([bridge_l - 6.0, 1.0, 3.2]);

        // Stanchion Ribs
        for (x = [-bridge_l/2 + 6.0 : 8.0 : bridge_l/2 - 6.0]) {
            translate([x, side_y - 0.1, deck_z + 1.0])
                cube([1.2, 1.2, 4.4]);
        }
    }

    // Cable Anchor Blisters along Deck Edges
    for (s = [-1, 1]) {
        for (cx = [10.0, 20.0, 30.0, 42.0]) {
            translate([s * cx, deck_w/2 - 0.4, deck_z + 1.2])
                scale([1.2, 1.0, 0.8]) sphere(r = 1.3, $fn = 12);
            translate([s * cx, -deck_w/2 + 0.4, deck_z + 1.2])
                scale([1.2, 1.0, 0.8]) sphere(r = 1.3, $fn = 12);
        }
    }
}

// 3. TAPPAN ZEE SIGNATURE CENTER TOWER (OUTWARD-CANTED TWIN PYLONS)
module tappan_zee_center_tower() {
    color([0.88, 0.90, 0.92]) {
        union() {
            // Outward-canted faceted pylon legs (Tappan Zee V-flair)
            for (side_sign = [-1, 1]) {
                y_base = side_sign * 5.5;
                y_top  = side_sign * 9.8; // Canted outward towards top

                // Lower Leg (from Pier to Deck level)
                hull() {
                    translate([-3.5, y_base - 1.8, 0])
                        cube([7.0, 3.6, base_h]);
                    translate([-2.8, y_base - 1.5, deck_z])
                        cube([5.6, 3.0, 1.0]);
                }

                // Upper Pylon Tower (from Deck to Peak)
                hull() {
                    translate([-2.8, y_base - 1.5, deck_z])
                        cube([5.6, 3.0, 1.0]);
                    translate([-1.8, y_top - 1.3, tower_top_z - 2.0])
                        cube([3.6, 2.6, 2.0]);
                }

                // Pylon Crown Finial Cap
                translate([0, y_top, tower_top_z])
                    scale([1.2, 1.0, 1.4])
                        sphere(r = 1.6, $fn = 12);
            }

            // Cross-Bracing Struts between Twin Pylons (Tappan Zee structural ties)
            // Strut 1 (Under-deck Tie)
            translate([-2.5, -6.5, deck_z - 1.5])
                cube([5.0, 13.0, 1.8]);

            // Strut 2 (Mid-Tower Transverse Tie)
            translate([-1.8, -7.5, 30.0])
                cube([3.6, 15.0, 2.2]);

            // Strut 3 (Upper Cable Saddle Cross-Tie)
            translate([-1.5, -8.5, 46.0])
                cube([3.0, 17.0, 2.0]);
        }
    }
}

// 4. FAN CABLE-STAY SYSTEM (CABLES CONNECTING CENTER TOWER TO ROAD DECK)
module cable_stay_system() {
    color([0.72, 0.74, 0.78]) {
        // 4 pairs of cables on left span, 4 pairs on right span (16 cables total)
        cable_deck_x  = [10.0, 20.0, 30.0, 42.0];
        cable_tower_z = [36.0, 41.0, 46.0, 50.0];

        for (i = [0 : 3]) {
            dx = cable_deck_x[i];
            tz = cable_tower_z[i];

            for (span_sign = [-1, 1]) {
                target_x = span_sign * dx;

                // Cable to Right Deck Edge
                hull() {
                    translate([0, 8.8, tz])
                        sphere(r = 0.9, $fn = 8);
                    translate([target_x, deck_w/2 - 0.4, deck_z + 2.0])
                        cylinder(r1 = 1.0, r2 = 0.8, h = 0.8, $fn = 8);
                }

                // Cable to Left Deck Edge
                hull() {
                    translate([0, -8.8, tz])
                        sphere(r = 0.9, $fn = 8);
                    translate([target_x, -deck_w/2 + 0.4, deck_z + 2.0])
                        cylinder(r1 = 1.0, r2 = 0.8, h = 0.8, $fn = 8);
                }
            }
        }
    }
}

tappan_zee_cable_bridge();
