// ====================================================================
// [PRINT 08-D] Standalone Precision Retaining End Cap (Compact Flush Fit)
//
// Engineering Specifications:
// - Outer Disk: 8.0mm diameter x 2.5mm thickness
// - Inner Entry Neck: 4.0mm narrow bore (compresses 4.2mm barb tip on insertion)
// - Internal Snap Shoulder: 4.4mm internal recess (locks 4.2mm barb tip securely)
// - Flush Mounting: Outer face sits tight against Ear 2 outer face with zero axial gap!
// ====================================================================

$fn = 50;

pin_shaft_d  = 3.8;   // 3.8mm rod diameter
head_d       = 8.0;   // Outer cap head disk diameter
cap_th       = 2.5;   // Cap disk thickness
socket_d     = 4.0;   // Narrow entry neck bore (4.0mm)
shoulder_d   = 4.4;   // Internal snap-shoulder recess (4.4mm)

module precision_retaining_end_cap() {
    difference() {
        union() {
            // Flat outer cap disk resting flat at Z = 0
            cylinder(d = head_d, h = cap_th);
        }

        // 1. Narrow inner entry neck bore (4.0mm diameter x 1.0mm depth)
        translate([0, 0, -0.5])
            cylinder(d = socket_d, h = 1.5);

        // 2. Internal snap-shoulder recess (4.4mm diameter catches 4.2mm barb tip)
        translate([0, 0, 0.9])
            cylinder(d = shoulder_d, h = 1.6);

        // 3. Small self-guiding chamfer at entry face (4.3mm -> 4.0mm over 0.4mm depth)
        translate([0, 0, -0.01])
            cylinder(d1 = socket_d + 0.3, d2 = socket_d, h = 0.4);
    }
}

module retaining_end_cap() {
    precision_retaining_end_cap();
}

precision_retaining_end_cap();
