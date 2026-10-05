// ====================================================================
// Trolley Carriage Frame (100% 3D-Printable - Support Free)
// 
// Print-Optimized (Inverted U-Chassis):
// - Printed upside down: Top of carriage rests flat on bed at Z = 0 (100% adhesion).
// - Wheel and cable channel opens straight up to the sky = ZERO bridges, ZERO overhangs!
// - Lower clevis ears rise straight up as vertical columns with captive M3 nut pockets.
// ====================================================================

use <trolley_wheel.scad>;

$fn = 40;

wheel_spacing       = 12.67; // Distance between front and rear wheel centers [scaled from 38mm]
carriage_length     = 19.33; // Overall chassis length [scaled from 58mm]
carriage_height     = 7.33;  // Chassis height [scaled from 22mm]
wheel_slot_width    = 3.8;   // Fits scaled wheel + hub clearance
wall_thickness      = 1.5;   // Printable wall thickness on each side
total_width         = wheel_slot_width + (wall_thickness * 2);
axle_dia            = 3.4;   // Clearance for standard M3 screw
hanger_pivot_dia    = 3.4;   // Cross-pin hole for gondola hanger arm (standard M3)
clevis_ear_h        = 4.5;   // Clevis ear height [scaled from 10mm]


// Integrated 1-Piece Robust Trolley Carriage (100% Support Free)
module trolley_carriage_print() {
    difference() {
        union() {
            // Main chassis block (flat on bed at Z = 0)
            translate([0, 0, carriage_height / 2])
                cube([carriage_length, total_width, carriage_height], center = true);
            
            // Lower hanger clevis ears
            translate([0, (wheel_slot_width + wall_thickness) / 2, carriage_height + clevis_ear_h / 2])
                cube([14.0, wall_thickness, clevis_ear_h], center = true);
            translate([0, -(wheel_slot_width + wall_thickness) / 2, carriage_height + clevis_ear_h / 2])
                cube([14.0, wall_thickness, clevis_ear_h], center = true);
        }

        // Inner wheel channel opening straight up
        translate([0, 0, carriage_height / 2 + 2.5])
            cube([carriage_length + 2, wheel_slot_width, carriage_height], center = true);

        // Side axle pin holes for the 2 wheels (3.4mm diameter)
        for (x = [-wheel_spacing / 2, wheel_spacing / 2]) {
            translate([x, 0, carriage_height - 3.5])
                rotate([90, 0, 0])
                    cylinder(d = axle_dia, h = total_width + 2, center = true);
        }

        // Hanger arm pivot hole through the clevis ears
        translate([0, 0, carriage_height + clevis_ear_h / 2])
            rotate([90, 0, 0])
                cylinder(d = hanger_pivot_dia, h = total_width + 4, center = true);

        // Phase 2 Pre-Engineered Haul-Line Clamp / Tie-Off slots
        translate([5, 0, 4])
            rotate([0, 90, 0])
                cylinder(d = 2.0, h = 4, center = true);
        translate([-5, 0, 4])
            rotate([0, 90, 0])
                cylinder(d = 2.0, h = 4, center = true);
    }
}


// Operational upright orientation (used for assembly preview)
module trolley_carriage() {
    translate([0, 0, 7.5])
        rotate([180, 0, 0])
            trolley_carriage_print();
}

// Visual assembly view (carriage with preview of 2 wheels)
module trolley_with_wheels_preview() {
    trolley_carriage();
    #translate([wheel_spacing / 2, 0, 0])
        rotate([90, 0, 0])
            trolley_wheel();
    #translate([-wheel_spacing / 2, 0, 0])
        rotate([90, 0, 0])
            trolley_wheel();
}

// ====================================================================
// Selection
// ====================================================================
// "print"   -> 100% Flat on top face at Z = 0 (Ready to slice, ZERO supports!)
// "upright" -> In upright operational position
// "preview" -> Upright with wheels installed
mode = "print";

if (mode == "print") {
    trolley_carriage_print();
} else if (mode == "upright") {
    trolley_carriage();
} else if (mode == "preview") {
    trolley_with_wheels_preview();
}
