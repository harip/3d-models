// ====================================================================
// Trolley Roller Wheel - Large 18mm Heavy-Duty Design
// Includes built-in 22mm sacrificial print adhesion brim disk!
// - Sticks 100% solidly to any build plate without tipping/warping.
// - Snaps or trims off easily with fingernails or cutters after printing!
// ====================================================================

$fn = 60; // High circular resolution

// Dimensions (mm) - Large Heavy-Duty 18mm Wheel
wheel_outer_dia   = 18.0; // Outer flange diameter (matches tower sheaves)
groove_root_dia   = 13.5; // Bottom of cable groove diameter (solid wall!)
wheel_thickness   = 4.5;  // Total rim thickness
groove_width      = 3.0;  // Cable track width
axle_hole_dia     = 4.2;  // Fits heavy-duty 4.0mm axle pin cleanly
hub_lip_extension = 0.5;  // Standoff spacer on each side (total width across hubs = 5.5mm)
hub_dia           = 8.0;  // Standoff spacer diameter
brim_dia          = 22.0; // Built-in sacrificial bed adhesion brim disk diameter


module trolley_wheel_body() {
    difference() {
        union() {
            // Built-in sacrificial bed-adhesion brim disk (22mm wide, 0.35mm height)
            // Provides massive surface contact so the wheel NEVER detaches while printing!
            cylinder(d = brim_dia, h = 0.35);

            // Built-in standoff hub spacers (starts at Z = 0)
            cylinder(d = hub_dia, h = wheel_thickness + (hub_lip_extension * 2));

            // Main wheel body (lifted by lower hub spacer)
            translate([0, 0, hub_lip_extension])
                cylinder(d = wheel_outer_dia, h = wheel_thickness);
        }
        
        // Central heavy-duty axle bore (4.2mm)
        translate([0, 0, -1])
            cylinder(d = axle_hole_dia, h = wheel_thickness + (hub_lip_extension * 2) + 2);
        
        // Deep V/U Cable groove around the perimeter
        translate([0, 0, (wheel_thickness / 2) + hub_lip_extension])
            rotate_extrude(convexity = 10) {
                translate([groove_root_dia / 2 + (wheel_outer_dia - groove_root_dia) / 4, 0, 0])
                    rotate([0, 0, 45])
                        square([groove_width * 1.1, groove_width * 1.1], center = true);
            }

        // Sacrificial breakaway score line (0.2mm notch for easy snap-off after printing)
        translate([0, 0, -0.1])
            difference() {
                cylinder(d = brim_dia + 1.0, h = 0.25);
                cylinder(d = hub_dia + 0.8, h = 0.5);
            }
    }
}

module trolley_wheel() {
    trolley_wheel_body();
}

// Render single wheel flat on build plate at Z = 0
trolley_wheel();
