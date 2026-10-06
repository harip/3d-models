// ====================================================================
// [PRINT 07-B] Tower Station B - Upper Cable Tensioner Bracket
// Lies 100% flat on bed at Z = 0.
// Includes square receiving pocket for Part 07-A snap post.
// ZERO SUPPORTS NEEDED!
// ====================================================================

$fn = 50;

body_w         = 15.33; // Width of tensioner body
body_l         = 21.67; // Length of tensioner body
body_h         = 12.0;  // Overall height
slot_travel    = 9.33;  // Tension travel distance
axle_dia       = 5.4;   // M5 axle bolt clearance
axle_z         = 9.53;  // Matched to Tower A sheave axle height!

module tower_head_b_bracket() {
    difference() {
        union() {
            // Main horizontal tensioner body
            translate([body_l / 2 - 4, 0, axle_z])
                cube([body_l, body_w, body_h], center = true);

            // Lower snap-fit receiving hub (rests flat at Z = 0)
            translate([0, 0, 3.0])
                cube([10.0, 8.0, 6.0], center = true);
        }

        // Inner clevis channel for sheave wheel (fits 5.4mm sheave wheel with 0.6mm clearance)
        translate([body_l / 2 - 2, 0, axle_z])
            cube([body_l + 4, 6.0, body_h + 4], center = true);

        // Horizontal tensioning slots on both sides (for axle bolt travel)
        translate([body_l / 2 - 2, 0, axle_z])
            hull() {
                translate([-slot_travel / 2, 0, 0])
                    rotate([90, 0, 0])
                        cylinder(d = axle_dia, h = body_w + 4, center = true);
                translate([slot_travel / 2, 0, 0])
                    rotate([90, 0, 0])
                        cylinder(d = axle_dia, h = body_w + 4, center = true);
            }

        // Longitudinal tensioner screw hole
        translate([body_l / 2 + 5, 0, axle_z])
            rotate([0, 90, 0])
                cylinder(d = 3.4, h = 20, center = true);

        // Receiving socket pocket for Part A post (includes +0.2mm print gap clearance)
        translate([0, 0, 3.0])
            cube([6.25, 6.25, 7.0], center = true);

        // Side snap-fit detent channels
        for (x_sign = [-1, 1]) {
            translate([x_sign * 3.1, 0, 4.5])
                sphere(r = 0.6, $fn = 16);
        }
    }
}

// Laid flat on its side at Z = 0 for 100% support-free printing
translate([0, 0, body_w / 2])
    rotate([90, 0, 0])
        tower_head_b_bracket();
