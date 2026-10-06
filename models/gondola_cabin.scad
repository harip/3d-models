// ====================================================================
// Alpine Christmas Gondola Cabin & C-Hanger Arm (100% Snap-Fit)
// 
// Features:
// - Classic C-Hanger Arm with integrated solid top & bottom snap-studs.
// - Zero loose pins, zero screws required.
// - Roof clevis and trolley carriage have open 45-degree snap-fit lead-in slots.
// - All parts sit perfectly flat on build plate at Z = 0 (100% support-free).
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
snap_stud_d   = 3.4;   // Solid snap stud diameter
snap_stud_l   = 1.8;   // Stud protrusion length on each side
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

// 2. Cabin Roof with Snap-Sockets
module cabin_roof() {
    roof_lip = 1.2;
    roof_h   = 5.0;
    clevis_h = 5.0;
    
    difference() {
        union() {
            hull() {
                rounded_box(cabin_l + roof_lip*2, cabin_w + roof_lip*2, 1.2, corner_r + 0.4);
                translate([0, 0, roof_h])
                    rounded_box(cabin_l * 0.45, cabin_w * 0.25, 0.6, 1.0);
            }
            translate([0, 0, roof_h / 2])
                hull() {
                    cube([12.0, 9.0, 1.0], center = true);
                    translate([0, 0, roof_h / 2 + clevis_h / 2])
                        cube([10.0, 7.0, clevis_h + 1], center = true);
                }
        }
        
        translate([0, 0, -0.01])
            rounded_box((cabin_l - 1.6) + 0.25, (cabin_w - 1.6) + 0.25, 2.2, max(0.5, corner_r));

        // Clevis slot for hanger arm
        translate([0, 0, roof_h + clevis_h / 2 + 0.5])
            cube([11.0, clevis_slot_w, clevis_h + 5], center = true);

        // Round bearing socket holes (3.4mm diameter) for snap studs
        translate([0, 0, roof_h + clevis_h * 0.5])
            rotate([0, 90, 0])
                cylinder(d = snap_stud_d, h = 18.0, center = true);

        // Open-top vertical snap entry slot (3.0mm constriction)
        translate([0, 0, roof_h + clevis_h * 0.75])
            cube([3.0, clevis_slot_w + 4.0, 5.0], center = true);

        // 45-degree self-guiding lead-in mouth
        translate([0, 0, roof_h + clevis_h + 0.5])
            rotate([45, 0, 0])
                cube([4.0, 4.0, 18.0], center = true);
    }
}

// 3. Classic C-Hanger Arm with Integrated Solid Snap-Studs
module hanger_arm_flat_2d() {
    difference() {
        union() {
            // Bottom tab
            hull() {
                translate([0, 0]) circle(d = 8.0);
                translate([0, 6.0]) circle(d = 8.0);
            }
            // Lower horizontal bridge
            hull() {
                translate([0, 4.0]) circle(d = 8.0);
                translate([hanger_offset, 4.0]) circle(d = 8.0);
            }
            // Vertical C-stem
            hull() {
                translate([hanger_offset, 4.0]) circle(d = 8.0);
                translate([hanger_offset, hanger_height]) circle(d = 8.0);
            }
            // Top horizontal bridge
            hull() {
                translate([hanger_offset, hanger_height]) circle(d = 8.0);
                translate([0, hanger_height]) circle(d = 8.0);
            }
            // Top eyelet
            translate([0, hanger_height])
                circle(d = 8.0);
        }
    }
}

module hanger_arm_snap_print() {
    union() {
        // Main flat C-arm body resting on bed at Z = 0
        linear_extrude(height = hanger_th)
            hanger_arm_flat_2d();

        // Bottom Integrated Snap-Studs (for Gondola Roof Clevis)
        translate([0, 2.5, hanger_th / 2])
            rotate([90, 0, 0])
                cylinder(d = snap_stud_d, h = hanger_th + (snap_stud_l * 2), center = true);

        // Top Integrated Snap-Studs (for Trolley Carriage Clevis)
        translate([0, hanger_height, hanger_th / 2])
            rotate([90, 0, 0])
                cylinder(d = snap_stud_d, h = hanger_th + (snap_stud_l * 2), center = true);
    }
}

module hanger_arm_flat() {
    hanger_arm_snap_print();
}

// Render flat on bed at Z = 0
hanger_arm_snap_print();
