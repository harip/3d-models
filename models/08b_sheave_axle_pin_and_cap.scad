// ====================================================================
// [PRINT 08-B] Precision Axle Pin & Retaining End Cap Set (Flush Fit)
//
// Engineering Specifications:
// - Matched to Station A Clevis Total Outer Width (14.0mm).
// - Shaft: 4.0mm diameter x 14.0mm exact length (0.0mm extra protrusion!).
// - Cap: 9.0mm disk with internal 4.6mm snap shoulder for 4.4mm barb tip.
// ====================================================================

$fn = 50;

pin_shaft_d  = 4.0;   // 4.0mm rod shaft
pin_length   = 14.0;  // EXACT 14.0mm shaft length
head_d       = 9.0;   // Flat head disk diameter
head_th      = 1.8;   // Flat head thickness
tip_barb_d   = 4.4;   // Barb tip diameter
tip_length   = 3.2;   // Tip length
cap_th       = 2.5;   // Cap disk thickness

module precision_axle_pin() {
    difference() {
        union() {
            cylinder(d = head_d, h = head_th);
            translate([0, 0, head_th])
                cylinder(d = pin_shaft_d, h = pin_length);
            translate([0, 0, head_th + pin_length])
                cylinder(d1 = tip_barb_d, d2 = pin_shaft_d - 0.6, h = tip_length);
        }

        translate([0, 0, head_th + pin_length - 1.5])
            cube([1.0, tip_barb_d + 2.0, tip_length + 3.0], center = true);

        translate([0, 0, -0.01])
            cylinder(d1 = head_d + 1.0, d2 = head_d, h = 0.4);
    }
}

module precision_retaining_end_cap() {
    difference() {
        union() {
            cylinder(d = head_d, h = cap_th);
        }

        translate([0, 0, -0.5])
            cylinder(d = pin_shaft_d + 0.25, h = 1.5);

        translate([0, 0, 0.9])
            cylinder(d = 4.6, h = 2.0);

        translate([0, 0, -0.01])
            cylinder(d1 = pin_shaft_d + 1.2, d2 = pin_shaft_d + 0.25, h = 0.6);
    }
}

// Layout on Print Bed (Spaced side-by-side at Z = 0)
translate([-8.0, 0, 0])
    precision_axle_pin();

translate([8.0, 0, 0])
    precision_retaining_end_cap();
