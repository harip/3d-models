// ====================================================================
// [PRINT 06-B] Tower Station A - Upper Head Bracket
// Lies 100% flat on its back plate at Z = 0.
// Includes square socket pocket for Part 06-A snap post.
// ZERO SUPPORTS NEEDED!
// ====================================================================

$fn = 50;

bracket_w        = 15.33; // Width of mounting face
bracket_h        = 17.33; // Height of mounting plate
plate_th         = 3.0;   // Thickness of plate
nema17_hole_dist = 10.33; // Motor mounting hole spacing
nema17_pilot_d   = 7.67;  // Center pilot collar clearance
m3_hole_d        = 2.2;   // Bolt clearance

module tower_head_a_bracket() {
    difference() {
        union() {
            // Main vertical faceplate
            translate([0, 0, bracket_h / 2])
                cube([bracket_w, plate_th, bracket_h], center = true);

            // Overhead cable guide horn
            translate([0, 3.5, bracket_h - 1.5])
                cube([bracket_w, 7.0 + plate_th, 3.0], center = true);

            // Lower snap-fit receiving hub (rests flat at Z = 0)
            translate([0, 3.5, 3.0])
                cube([10.0, 8.0, 6.0], center = true);
        }

        // Center pilot hole (for axle bolt or motor collar)
        translate([0, 0, bracket_h * 0.55])
            rotate([90, 0, 0])
                cylinder(d = nema17_pilot_d, h = plate_th + 4, center = true);

        // 4x Motor mounting holes
        for (dx = [-nema17_hole_dist / 2, nema17_hole_dist / 2]) {
            for (dz = [-nema17_hole_dist / 2, nema17_hole_dist / 2]) {
                translate([dx, 0, (bracket_h * 0.55) + dz])
                    rotate([90, 0, 0])
                        cylinder(d = m3_hole_d, h = plate_th + 4, center = true);
            }
        }

        // Cable path slot through the overhead horn
        translate([0, 3.5, bracket_h - 1.5])
            cube([6.5, 9.0, 5.0], center = true);

        // Receiving socket pocket for Part A post (includes +0.2mm print gap clearance)
        translate([0, 3.5, 3.0])
            cube([6.25, 6.25, 7.0], center = true);

        // Side snap-fit detent channels
        for (x_sign = [-1, 1]) {
            translate([x_sign * 3.1, 3.5, 4.5])
                sphere(r = 0.6, $fn = 16);
        }
    }
}

// Laid flat on rear face of motor plate at Z = 0
translate([0, plate_th / 2, 0])
    rotate([-90, 0, 0])
        tower_head_a_bracket();
