// ====================================================================
// Modular Chopper Undercarriage (Skids & Wheeled Taxi Gear)
// Precision modular landing gear interchangeable system.
//
// Engineering Specifications:
// - Standardized Dual Chassis Mounting Pins (2.0mm dia x 2.2mm h, 10.0mm pitch)
// - Matches 2.2mm chassis sockets (0.2mm clearance fit)
// - Option "skids": Twin landing skids (13.0mm track, 24.0mm length, 45° upturns)
//   -> Aligns directly with 13.0mm guide slots on 35mm Helipad base
// - Option "wheels": Tricycle taxi gear (dual main wheels + steerable nose wheel)
// - 100% self-supporting flat print layout at Z = 0
// ====================================================================

$fn = 36;

gear_type = "skids"; // "skids" or "wheels"

pin_d     = 2.0;
pin_h     = 2.2;
pin_pitch = 10.0; // Distance between mounting pins along X
skid_span = 13.0; // Width between skids

module mounting_spine() {
    // Central mounting bridge block
    hull() {
        translate([pin_pitch/2, 0, 0.8])
            cylinder(d = 3.6, h = 1.4, center = false);
        translate([-pin_pitch/2, 0, 0.8])
            cylinder(d = 3.6, h = 1.4, center = false);
    }
    // Twin chassis mounting registration pins
    for (sx = [-pin_pitch/2, pin_pitch/2]) {
        translate([sx, 0, 2.2]) {
            cylinder(d = pin_d, h = pin_h, center = false);
            // Pin lead-in chamfer
            translate([0, 0, pin_h - 0.4])
                cylinder(d1 = pin_d, d2 = pin_d - 0.5, h = 0.4, center = false);
        }
    }
}

module landing_skids() {
    difference() {
        union() {
            mounting_spine();

            // Arched cross struts from spine to skids
            for (sx = [-pin_pitch/2, pin_pitch/2]) {
                for (sy = [-1, 1]) {
                    hull() {
                        translate([sx, 0, 1.4])
                            sphere(d = 1.6);
                        translate([sx, sy * skid_span/2, 0.8])
                            sphere(d = 1.5);
                    }
                }
            }

            // Twin longitudinal skids
            for (sy = [-1, 1]) {
                y = sy * skid_span/2;
                // Main runner tube
                hull() {
                    translate([-10.0, y, 0.75])
                        sphere(d = 1.5);
                    translate([8.5, y, 0.75])
                        sphere(d = 1.5);
                }
                // Front upturned toe (45° angle)
                hull() {
                    translate([8.5, y, 0.75])
                        sphere(d = 1.5);
                    translate([11.5, y, 2.2])
                        sphere(d = 1.3);
                }
                // Rear kick
                hull() {
                    translate([-10.0, y, 0.75])
                        sphere(d = 1.5);
                    translate([-11.8, y, 1.4])
                        sphere(d = 1.2);
                }
                // Boarding step on starboard skid
                if (sy > 0) {
                    translate([0, y + 0.9, 0.75])
                        cube([4.0, 1.0, 0.8], center = true);
                }
            }
        }

        // Flat ground contact plane at Z = 0
        translate([0, 0, -5.0])
            cube([40, 40, 10], center = true);
    }
}

module wheeled_gear() {
    difference() {
        union() {
            mounting_spine();

            // Nose gear strut and wheel (+X)
            hull() {
                translate([pin_pitch/2, 0, 1.2])
                    sphere(d = 1.6);
                translate([pin_pitch/2 + 2.0, 0, 0.8])
                    sphere(d = 1.6);
            }
            // Nose wheel
            translate([pin_pitch/2 + 2.0, 0, 1.8])
                rotate([90, 0, 0])
                    cylinder(d = 3.6, h = 1.4, center = true);

            // Main rear gear outrigger struts (-X)
            for (sy = [-1, 1]) {
                hull() {
                    translate([-pin_pitch/2, 0, 1.2])
                        sphere(d = 1.6);
                    translate([-pin_pitch/2, sy * 6.0, 0.8])
                        sphere(d = 1.6);
                }
                // Rear wheels
                translate([-pin_pitch/2, sy * 6.0, 1.8])
                    rotate([90, 0, 0])
                        cylinder(d = 4.0, h = 1.5, center = true);
            }
        }

        // Flat ground contact plane at Z = 0
        translate([0, 0, -5.0])
            cube([40, 40, 10], center = true);
    }
}

if (gear_type == "skids") {
    landing_skids();
} else if (gear_type == "wheels") {
    wheeled_gear();
}
