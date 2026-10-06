// ====================================================================
// Alpine Christmas Gondola Cabin & C-Hanger Arm
// OPTION A: Heavy-Duty Wedge Arrow-Head / Barb Snap Tabs
//
// Features:
// - ZERO TINY PEGS OR PROTRUSIONS!
// - Solid split wedge arrow-heads integrated directly at the top and bottom tips of the C-arm.
// - When pushed into slot, barbs flex inward and CLICK over internal locking shoulders.
// - 100% support-free, printed flat on bed at Z = 0.
// ====================================================================

$fn = 40;

// Cabin Dimensions (mm)
cabin_w       = 16.0;  // Width
cabin_l       = 21.33; // Length
cabin_h       = 16.67; // Body height
wall_th       = 1.2;   // Wall thickness
corner_r      = 2.0;   // Rounded corner radius

// Hanger Arm Dimensions
hanger_height = 24.0;  // Vertical clearance
hanger_offset = 10.0;  // Side offset for cable line
hanger_th     = 4.0;   // Arm thickness
barb_width    = 6.2;   // Width of arrow-head barb tip
barb_neck     = 4.0;   // Width of barb neck
clevis_slot_w = 4.4;   // Clevis slot gap width


module rounded_box(l, w, h, r) {
    hull() {
        for (x = [-l/2 + r, l/2 - r]) {
            for (y = [-w/2 + r, w/2 - r]) {
                translate([x, y, 0])
                    cylinder(r = r, h = h);
            }
        }
    }
}

// 1. Cabin Body
module cabin_body() {
    door_w = cabin_l * 0.42;
    door_h = cabin_h * 0.72;
    door_z = 0.6 + door_h / 2;
    
    difference() {
        union() {
            rounded_box(cabin_l, cabin_w, cabin_h, corner_r);
            for (y_sign = [-1, 1]) {
                translate([0, y_sign * (cabin_w / 2 + 0.1), door_z])
                    cube([door_w + 0.8, 0.4, door_h], center = true);
            }
        }
        
        translate([0, 0, wall_th])
            rounded_box(cabin_l - wall_th*2, cabin_w - wall_th*2, cabin_h + 2, max(0.8, corner_r - wall_th));
        
        for (y_sign = [-1, 1]) {
            translate([0, y_sign * (cabin_w / 2), door_z])
                cube([door_w, 0.8, door_h], center = true);
            translate([0, y_sign * (cabin_w / 2), door_z])
                cube([0.4, 1.2, door_h - 0.4], center = true);
            translate([1.2, y_sign * (cabin_w / 2 + 0.15), door_z])
                rotate([90, 0, 0]) cylinder(d = 1.0, h = 1.0, center = true);
            translate([-1.2, y_sign * (cabin_w / 2 + 0.15), door_z])
                rotate([90, 0, 0]) cylinder(d = 1.0, h = 1.0, center = true);
        }

        for (x = [-door_w * 0.26, door_w * 0.26]) {
            translate([x, 0, cabin_h * 0.58])
                rotate([90, 0, 0])
                    hull() {
                        cube([door_w * 0.38, cabin_h * 0.36, cabin_w + 10], center = true);
                        translate([0, cabin_h * 0.16, 0])
                            rotate([0, 0, 45])
                                cube([door_w * 0.26, door_w * 0.26, cabin_w + 10], center = true);
                    }
        }
        
        for (x = [-cabin_l/2 - 2, cabin_l/2 + 2]) {
            translate([x, 0, cabin_h * 0.56])
                rotate([0, 90, 0])
                    hull() {
                        cube([cabin_h * 0.42, cabin_w * 0.58, 20], center = true);
                        translate([0, cabin_w * 0.20, 0])
                            rotate([0, 0, 45])
                                cube([cabin_w * 0.3, cabin_w * 0.3, 20], center = true);
                    }
        }
    }
}

// 2. Cabin Roof with Internal Barb-Lock Shoulders
module cabin_roof() {
    roof_lip = 1.2;
    roof_h   = 5.0;
    clevis_h = 6.0;
    
    difference() {
        union() {
            hull() {
                rounded_box(cabin_l + roof_lip*2, cabin_w + roof_lip*2, 1.2, corner_r + 0.4);
                translate([0, 0, roof_h])
                    rounded_box(cabin_l * 0.45, cabin_w * 0.25, 0.6, 1.0);
            }
            // Roof Clevis Bracket
            translate([0, 0, roof_h / 2])
                hull() {
                    cube([12.0, 9.0, 1.0], center = true);
                    translate([0, 0, roof_h / 2 + clevis_h / 2])
                        cube([10.0, 7.0, clevis_h + 1], center = true);
                }
        }
        
        translate([0, 0, -0.01])
            rounded_box((cabin_l - 1.6) + 0.25, (cabin_w - 1.6) + 0.25, 2.2, max(0.5, corner_r));

        // Central receiving slot for Barb Tab
        translate([0, 0, roof_h + clevis_h / 2 + 0.5])
            cube([11.0, clevis_slot_w, clevis_h + 5], center = true);

        // Internal Barb-Lock Shoulders (6.5mm width inside slot)
        translate([0, 0, roof_h + 2.0])
            cube([6.5, clevis_slot_w + 4.0, 2.2], center = true);

        // 45-degree lead-in mouth at entry
        translate([0, 0, roof_h + clevis_h + 0.5])
            rotate([45, 0, 0])
                cube([4.0, 4.0, 18.0], center = true);
    }
}

// 3. Classic C-Hanger Arm with Integrated Wedge Arrow-Head Barb Tabs
module hanger_arm_barb_2d() {
    difference() {
        union() {
            // Bottom Barb Tab (Snaps into Roof)
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

            // Top Barb Tab (Snaps into Glider Carriage)
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
    // Main flat C-arm body resting on bed at Z = 0
    linear_extrude(height = hanger_th)
        hanger_arm_barb_2d();
}

module hanger_arm_flat() {
    hanger_arm_snap_print();
}

// Render flat on bed at Z = 0
hanger_arm_snap_print();
