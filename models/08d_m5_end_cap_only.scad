// ====================================================================
// [PRINT 08-D] Standalone Snap-Fit Retaining End Cap (Matched to 4.0mm Rod)
//
// Features:
// - Matched to 4.0mm reduced rod diameter (4.25mm inner socket).
// - Internal snap shoulder (4.6mm) catches 4.4mm barb tip securely.
// - 100% Support-Free: Rests flat on build plate at Z = 0.
// ====================================================================

$fn = 50;

pin_shaft_d  = 4.0; // Reduced rod diameter
head_d       = 9.0; // Flat cap head diameter

module retaining_end_cap() {
    difference() {
        union() {
            // Flat outer cap disk resting flat at Z = 0
            cylinder(d = head_d, h = 3.5);
        }

        // Inner receiving socket for 4.0mm shaft (4.25mm diameter)
        translate([0, 0, -1])
            cylinder(d = pin_shaft_d + 0.25, h = 5.0);

        // Internal snap-shoulder recess (4.6mm diameter accepts 4.4mm barb tip)
        translate([0, 0, 1.2])
            cylinder(d = 4.6, h = 3.0);

        // Chamfer mouth lead-in
        translate([0, 0, -0.01])
            cylinder(d1 = pin_shaft_d + 1.2, d2 = pin_shaft_d + 0.25, h = 0.8);
    }
}

retaining_end_cap();
