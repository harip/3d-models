// ====================================================================
// [OPTION B] C-Hanger Arm with T-Slot Slide & Lock Flanges
// Zero Flex Required! Solid 100% rigid T-flanges at top and bottom.
// - Top T-head slides into Carriage (04) T-slot.
// - Bottom T-head slides into Gondola Roof (01) T-slot.
// ZERO PEGS, ZERO PINS, ZERO HARDWARE!
// ====================================================================

$fn = 50;

hanger_height = 24.0;
hanger_offset = 10.0;
hanger_th     = 4.0;
thead_w       = 8.0; // T-head width
tstem_w       = 4.0; // T-stem neck width

module hanger_arm_tslot_2d() {
    union() {
        // Bottom T-Head Flange
        polygon([
            [-thead_w/2, 0],
            [-thead_w/2, 2.0],
            [-tstem_w/2, 2.0],
            [-tstem_w/2, 5.0],
            [tstem_w/2, 5.0],
            [tstem_w/2, 2.0],
            [thead_w/2, 2.0],
            [thead_w/2, 0]
        ]);

        // Lower horizontal bridge
        hull() {
            translate([0, 4.0]) circle(d = 7.0);
            translate([hanger_offset, 4.0]) circle(d = 7.0);
        }
        // Vertical C-stem
        hull() {
            translate([hanger_offset, 4.0]) circle(d = 7.0);
            translate([hanger_offset, hanger_height]) circle(d = 7.0);
        }
        // Top horizontal bridge
        hull() {
            translate([hanger_offset, hanger_height]) circle(d = 7.0);
            translate([0, hanger_height]) circle(d = 7.0);
        }

        // Top T-Head Flange
        translate([0, hanger_height])
            polygon([
                [-thead_w/2, 3.0],
                [-thead_w/2, 5.0],
                [-tstem_w/2, 5.0],
                [-tstem_w/2, 0],
                [tstem_w/2, 0],
                [tstem_w/2, 5.0],
                [thead_w/2, 5.0],
                [thead_w/2, 3.0]
            ]);
    }
}

module hanger_arm_tslot_print() {
    linear_extrude(height = hanger_th)
        hanger_arm_tslot_2d();
}

// Render flat on bed at Z = 0
hanger_arm_tslot_print();
