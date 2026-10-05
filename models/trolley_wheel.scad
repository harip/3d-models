// ====================================================================
// Trolley Roller Wheel (100% 3D-Printable - Flat on Bed at Z = 0)
// Grooved sheave designed to roll directly on a 1.0 - 2.0 mm cable line.
// Spins freely on a standard M3 or M4 screw / pin axle.
// ====================================================================

$fn = 60; // Smooth curve resolution

// Parameters - Scaled to 1/3 size (reduced size by 2/3rd)
wheel_outer_dia   = 7.33; // Outer flange diameter (mm) [scaled from 22mm]
groove_root_dia   = 5.33; // Bottom of groove diameter (mm) [scaled from 16mm]
wheel_thickness   = 2.5;  // Total thickness along axle (mm) [scaled from 6mm]
groove_width      = 1.5;  // Width of cable track (mm)
axle_hole_dia     = 3.4;  // Fits standard M3 screw with clearance
hub_lip_extension = 0.4;  // Built-in standoff hub so wheel faces don't rub
hub_dia           = 5.0;  // Diameter of built-in standoff spacer


total_wheel_h = wheel_thickness + (hub_lip_extension * 2);

module trolley_wheel_body(od = wheel_outer_dia, root_d = groove_root_dia, th = wheel_thickness, axle_d = axle_hole_dia) {
    difference() {
        union() {
            // Main wheel body
            translate([0, 0, hub_lip_extension])
                cylinder(d = od, h = th);
            // Built-in hub spacers on both sides (starts at Z = 0)
            cylinder(d = hub_dia, h = th + (hub_lip_extension * 2));
        }
        
        // Central axle bore
        translate([0, 0, -1])
            cylinder(d = axle_d, h = th + (hub_lip_extension * 2) + 2);
        
        // Deep V/U Cable groove around the perimeter
        translate([0, 0, (th / 2) + hub_lip_extension])
            rotate_extrude(convexity = 10) {
                translate([root_d / 2 + (od - root_d) / 4, 0, 0])
                    rotate([0, 0, 45])
                        square([groove_width * 1.1, groove_width * 1.1], center = true);
            }
    }
}

module trolley_wheel() {
    trolley_wheel_body();
}

// Render single wheel flat on build plate at Z = 0
trolley_wheel();
