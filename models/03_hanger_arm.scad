// ====================================================================
// [PRINT 03] Classic C-Hanger Arm with Integrated Barb-Snap Tabs
//
// Features:
// - TOP BARB TAB: Snaps into Cable Glider Sled Runner (04_trolley_carriage)
// - BOTTOM BARB TAB: Snaps into Gondola Roof Clevis (01_gondola_single_piece)
// - Heavy-duty wedge arrowhead tabs with 1.2mm center flex-slit.
// - ZERO TINY PROTRUSIONS / PINS! ZERO SCREWS! ZERO SUPPORTS NEEDED!
// - Sits 100% flat on build plate at Z = 0.
// ====================================================================

$fn = 50;

hanger_height = 24.0;  // Vertical clearance
hanger_offset = 10.0;  // Side offset for cable line
hanger_th     = 4.0;   // Arm thickness
barb_width    = 6.2;   // Width of arrow-head barb tip
barb_neck     = 4.0;   // Width of barb neck

module hanger_arm_barb_2d() {
    difference() {
        union() {
            // Bottom Barb Tab (Snaps into Roof of Gondola 01)
            polygon([
                [-barb_neck/2, 0],
                [-barb_width/2, 3.0],
                [-barb_neck/2, 4.2],
                [barb_neck/2, 4.2],
                [barb_width/2, 3.0],
                [barb_neck/2, 0]
            ]);

            // Lower horizontal bridge
            hull() {
                translate([0, 3.5]) circle(d = 7.0);
                translate([hanger_offset, 3.5]) circle(d = 7.0);
            }
            // Vertical C-stem
            hull() {
                translate([hanger_offset, 3.5]) circle(d = 7.0);
                translate([hanger_offset, hanger_height]) circle(d = 7.0);
            }
            // Top horizontal bridge
            hull() {
                translate([hanger_offset, hanger_height]) circle(d = 7.0);
                translate([0, hanger_height]) circle(d = 7.0);
            }

            // Top Barb Tab (Snaps into Trolley Glider Carriage 04)
            translate([0, hanger_height])
                polygon([
                    [-barb_neck/2, 0],
                    [-barb_width/2, 3.0],
                    [-barb_neck/2, 4.2],
                    [barb_neck/2, 4.2],
                    [barb_width/2, 3.0],
                    [barb_neck/2, 0]
                ]);
        }

        // Central flexing slits (gives barbs 1.2mm spring flex space)
        translate([0, 2.0])
            square([1.2, 5.0], center = true);
        translate([0, hanger_height + 2.0])
            square([1.2, 5.0], center = true);
    }
}

module hanger_arm_snap_print() {
    linear_extrude(height = hanger_th)
        hanger_arm_barb_2d();
}

// Render flat on bed at Z = 0
hanger_arm_snap_print();
