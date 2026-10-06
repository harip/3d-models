// ====================================================================
// [PRINT 05-B] Set of 4 Heavy-Duty 4.0mm Axle Pins
// Prints 4 sturdy 4.0mm pins centered on your build plate at Z = 0.
// ZERO SUPPORTS NEEDED!
// ====================================================================

$fn = 40;

module trolley_heavy_duty_pin() {
    cylinder(d = 7.5, h = 1.5);
    translate([0, 0, 1.5])
        cylinder(d = 4.0, h = 11.0);
}

// 4 Pins arranged in a compact square centered on bed at Z = 0
translate([-8.0, -8.0, 0]) trolley_heavy_duty_pin();
translate([-8.0,  8.0, 0]) trolley_heavy_duty_pin();
translate([ 8.0, -8.0, 0]) trolley_heavy_duty_pin();
translate([ 8.0,  8.0, 0]) trolley_heavy_duty_pin();
