// ====================================================================
// [PRINT 05] Pair of Grooved Trolley Roller Wheels
// Deep V-groove for cable, built-in standoff hubs start flush at Z = 0.
// Print both wheels together spaced comfortably at center of bed.
// ZERO SUPPORTS NEEDED!
// ====================================================================

use <trolley_wheel.scad>;

$fn = 60;

// 2 wheels spaced comfortably at center of bed
translate([-8.0, 0, 0])
    trolley_wheel();

translate([8.0, 0, 0])
    trolley_wheel();

// 2 3D-Printable Axle Pins standing vertically on flat 5.2mm head at Z = 0
module trolley_axle_pin() {
    // Flat cap head on bed
    cylinder(d = 5.2, h = 1.2, $fn = 40);
    // Pin shaft
    translate([0, 0, 1.2])
        cylinder(d = 3.2, h = 7.0, $fn = 40);
}

// Separate printable pins placed to the left and right
translate([-18.0, 0, 0])
    trolley_axle_pin();

translate([18.0, 0, 0])
    trolley_axle_pin();

