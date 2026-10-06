// ====================================================================
// [PRINT 08-D] Standalone Snap-Fit Retaining End Cap
//
// Features:
// - 1x Retaining End Cap: 10mm flat cap disk with internal snap shoulder. Closes the end of the M5 pin!
// - 100% Support-Free: Rests flat on build plate at Z = 0.
// ====================================================================

$fn = 50;

pin_shaft_d  = 5.0;  // Fits 5.2mm bore with 0.2mm clearance
head_d       = 10.0; // Flat cap head diameter

module m5_retaining_end_cap() {
    difference() {
        union() {
            // Flat outer cap disk resting flat at Z = 0
            cylinder(d = head_d, h = 3.5);
        }

        // Inner receiving socket for 5.0mm shaft
        translate([0, 0, -1])
            cylinder(d = pin_shaft_d + 0.25, h = 5.0);

        // Internal snap-shoulder recess (5.6mm diameter accepts 5.4mm barb tip)
        translate([0, 0, 1.2])
            cylinder(d = 5.6, h = 3.0);

        // Chamfer mouth lead-in
        translate([0, 0, -0.01])
            cylinder(d1 = pin_shaft_d + 1.2, d2 = pin_shaft_d + 0.25, h = 0.8);
    }
}

m5_retaining_end_cap();
