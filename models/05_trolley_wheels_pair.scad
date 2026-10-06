// ====================================================================
// [PRINT 05] Vehicle Assembly Pins (Wheel-Less System)
// 2 Heavy-Duty 4.0mm Axle Pins to connect:
//   1. Trolley Glider Carriage (04) -> Hanger Arm (03)
//   2. Hanger Arm (03) -> Gondola Roof (01)
// ZERO SUPPORTS NEEDED - Sits flat on bed at Z = 0!
// ====================================================================

$fn = 40;

module trolley_heavy_duty_pin() {
    // Flat cap head resting at Z = 0
    cylinder(d = 7.5, h = 1.5);
    // Heavy-duty 4.0mm shaft (11.0mm length spans clevis ears)
    translate([0, 0, 1.5])
        cylinder(d = 4.0, h = 11.0);
}

// 2 Heavy-Duty Pins spaced comfortably on build plate at Z = 0
translate([-8.0, 0, 0]) trolley_heavy_duty_pin();
translate([ 8.0, 0, 0]) trolley_heavy_duty_pin();
