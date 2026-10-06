// ====================================================================
// [PRINT 05-A] Single 18mm Trolley Roller Wheel
// Prints 1 single wheel centered directly in the middle of your print bed.
// Large 18mm footprint rests 100% flat at Z = 0.
// ZERO SUPPORTS NEEDED!
// ====================================================================

use <trolley_wheel.scad>;

$fn = 60;

// Centered on bed at Z = 0
trolley_wheel();
