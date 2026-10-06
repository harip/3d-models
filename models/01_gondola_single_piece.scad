// ====================================================================
// 1-Piece Unified Gondola Cabin Body & Roof (100% Support-Free)
//
// Print Orientation:
// - Roof is fused directly onto the top of the cabin body as a single object.
// - Sits 100% flat on build plate at Z = 0 (cabin floor).
// - Roof overhang uses a 45-degree self-supporting chamfer profile = ZERO SUPPORTS NEEDED!
// - Keeps identical envelope, door, window, and hanger clevis dimensions.
// ====================================================================

$fn = 40;

// Dimensions (mm) - Scaled to 1/3 size
cabin_w       = 16.0;  // Width (across track)
cabin_l       = 21.33; // Length (along track)
cabin_h       = 16.67; // Body height
wall_th       = 1.2;   // Wall thickness
corner_r      = 2.0;   // Rounded corner radius

// Hanger Dimensions
hanger_height = 24.0;
hanger_offset = 10.0;
hanger_th     = 4.0;

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

module gondola_cabin_single_piece() {
    door_w = cabin_l * 0.42;
    door_h = cabin_h * 0.72;
    door_z = 0.6 + door_h / 2;
    
    roof_lip = 1.2;
    roof_h   = 5.0;
    clevis_slot_w = 4.6;
    clevis_h      = 5.0;

    difference() {
        union() {
            // Main Cabin Body
            rounded_box(cabin_l, cabin_w, cabin_h, corner_r);
            
            // Outer door frame molding / trim on sides (+Y and -Y)
            for (y_sign = [-1, 1]) {
                translate([0, y_sign * (cabin_w / 2 + 0.1), door_z])
                    cube([door_w + 0.8, 0.4, door_h], center = true);
            }
            
            // Integrated 1-Piece Roof (Fused seamlessly at cabin_h)
            translate([0, 0, cabin_h]) {
                // 45-degree self-supporting underside flare transition (ZERO overhang droop!)
                hull() {
                    translate([0, 0, 0])
                        rounded_box(cabin_l, cabin_w, 0.1, corner_r);
                    translate([0, 0, roof_lip])
                        rounded_box(cabin_l + roof_lip*2, cabin_w + roof_lip*2, 0.1, corner_r + 0.4);
                }
                
                // Hipped pitched roof cap
                hull() {
                    translate([0, 0, roof_lip])
                        rounded_box(cabin_l + roof_lip*2, cabin_w + roof_lip*2, 1.0, corner_r + 0.4);
                    translate([0, 0, roof_h])
                        rounded_box(cabin_l * 0.45, cabin_w * 0.25, 0.6, 1.0);
                }
                
                // Top Hanger Arm Mounting Clevis Bracket (45-degree chamfered base into roof peak)
                translate([0, 0, roof_h / 2])
                    hull() {
                        cube([12.0, 9.0, 1.0], center = true);
                        translate([0, 0, roof_h / 2 + clevis_h / 2])
                            cube([10.0, 7.0, clevis_h + 1], center = true);
                    }
            }
        }

        
        // Hollow interior cavity (stops at cabin ceiling to create a solid top roof!)
        translate([0, 0, wall_th])
            rounded_box(cabin_l - wall_th*2, cabin_w - wall_th*2, cabin_h - wall_th, max(0.8, corner_r - wall_th));

        
        // Door panel recessed outlines and seams on both sides (+Y and -Y)
        for (y_sign = [-1, 1]) {
            translate([0, y_sign * (cabin_w / 2), door_z])
                cube([door_w, 0.8, door_h], center = true);

            translate([0, y_sign * (cabin_w / 2), door_z])
                cube([0.4, 1.2, door_h - 0.4], center = true);
                
            translate([1.2, y_sign * (cabin_w / 2 + 0.15), door_z])
                rotate([90, 0, 0])
                    cylinder(d = 1.0, h = 1.0, center = true);
            translate([-1.2, y_sign * (cabin_w / 2 + 0.15), door_z])
                rotate([90, 0, 0])
                    cylinder(d = 1.0, h = 1.0, center = true);
        }

        // Side Door Window Cutouts (45-degree self-supporting arches)
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
        
        // Front & Rear Windows
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

        // Clevis slot for hanger arm tab (centered at Y = 0.0mm)
        translate([0, 0, cabin_h + roof_h + clevis_h / 2 + 0.5])
            cube([11.0, clevis_slot_w, clevis_h + 5], center = true);

        // Clevis heavy-duty 4.0mm horizontal cross-pin hole
        translate([0, 0, cabin_h + roof_h + clevis_h * 0.5])
            rotate([0, 90, 0])
                cylinder(d = 4.2, h = 18.0, center = true);
    }
}


// Render flat on bed at Z = 0
gondola_cabin_single_piece();

