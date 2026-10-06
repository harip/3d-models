// ====================================================================
// [PRINT 08-D] Standalone Precision Retaining End Cap (Flush Fit)
//
// Engineering Specifications:
// - Outer Disk: 9.0mm diameter x 2.5mm compact thickness
// - Inner Socket: 4.25mm diameter (receives 4.0mm rod shaft)
// - Internal Snap Shoulder: 4.6mm internal recess (locks 4.4mm barb tip)
// - Flush Mounting: Outer face sits tight against Ear 2 outer face with zero axial gap!
// ====================================================================

$fn = 50;

pin_shaft_d  = 4.0; // 4.0mm rod diameter
head_d       = 9.0; // Flat cap head diameter
cap_th       = 2.5; // Compact cap disk thickness

module precision_retaining_end_cap() {
    difference() {
        union() {
            // Flat outer cap disk resting flat at Z = 0
            cylinder(d = head_d, h = cap_th);
        }

        // Inner receiving socket for 4.0mm shaft (4.25mm diameter)
        translate([0, 0, -0.5])
            cylinder(d = pin_shaft_d + 0.25, h = 1.5);

        // Internal snap-shoulder recess (4.6mm diameter accepts 4.4mm barb tip)
        translate([0, 0, 0.9])
            cylinder(d = 4.6, h = 2.0);

        // Chamfer mouth lead-in
        translate([0, 0, -0.01])
            cylinder(d1 = pin_shaft_d + 1.2, d2 = pin_shaft_d + 0.25, h = 0.6);
    }
}

precision_retaining_end_cap();
