// ====================================================================
// [PRINT 06-A] Tower Station A - Lower Mast Socket
// Sits 100% flat on build plate at Z = 0.
// Includes square locking post with snap-fit retention nubs.
// ZERO SUPPORTS NEEDED!
// ====================================================================

$fn = 50;

socket_inner_d = 6.8;   // Fits scaled 6.8mm mast plug
socket_wall    = 2.0;   // Wall thickness
socket_depth   = 10.0;  // Socket depth

module tower_head_a_socket() {
    difference() {
        union() {
            // Main cylindrical mast socket
            cylinder(d = socket_inner_d + (socket_wall * 2), h = socket_depth);
            
            // Upper square snap post (plugs into the Upper Bracket 06-B)
            translate([0, 0, socket_depth + 3.0])
                cube([6.0, 6.0, 6.0], center = true);

            // Friction snap detent nubs on sides of post
            for (x_sign = [-1, 1]) {
                translate([x_sign * 3.0, 0, socket_depth + 4.5])
                    sphere(r = 0.5, $fn = 16);
            }
        }

        // Mast socket cavity (bottom) with 45-degree self-aligning lead-in chamfer
        translate([0, 0, -1])
            cylinder(d = socket_inner_d, h = socket_depth + 1);
        translate([0, 0, -0.01])
            cylinder(d1 = socket_inner_d + 1.5, d2 = socket_inner_d, h = 1.5);

        // Mast cross-pin clamp hole
        translate([0, 0, socket_depth / 2])
            rotate([0, 90, 0])
                cylinder(d = 2.4, h = socket_inner_d + 6, center = true);
    }
}

// Centered on bed at Z = 0
tower_head_a_socket();
