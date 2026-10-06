// ====================================================================
// [PRINT 08-B] 3D-Printable Reduced Axle Pin & Snap-Fit Retaining End Cap
//
// Features:
// - 1x Axle Pin: 4.0mm rod diameter x 17.5mm length with 9mm flat head & 4.4mm barb tip.
// - 1x Retaining End Cap: 9mm flat cap disk with 4.25mm socket & 4.6mm internal snap shoulder.
// - 100% Support-Free: Both pieces rest flat on build plate at Z = 0.
// ====================================================================

$fn = 50;

pin_shaft_d  = 4.0;  // Fits 4.2mm bore with 0.2mm clearance
pin_length   = 17.5; // Spans through roof hub / bracket
head_d       = 9.0;  // Flat head disk diameter
head_th      = 2.0;  // Flat head thickness
tip_barb_d   = 4.4;  // Split-prong barb tip diameter
tip_length   = 4.0;  // Tip length

module axle_pin() {
    difference() {
        union() {
            cylinder(d = head_d, h = head_th);
            translate([0, 0, head_th])
                cylinder(d = pin_shaft_d, h = pin_length);
            translate([0, 0, head_th + pin_length])
                cylinder(d1 = tip_barb_d, d2 = pin_shaft_d - 0.6, h = tip_length);
        }

        translate([0, 0, head_th + pin_length - 2.0])
            cube([1.0, tip_barb_d + 2.0, tip_length + 4.0], center = true);

        translate([0, 0, -0.01])
            cylinder(d1 = head_d + 1.0, d2 = head_d, h = 0.5);
    }
}

module retaining_end_cap() {
    difference() {
        union() {
            cylinder(d = head_d, h = 3.5);
        }

        translate([0, 0, -1])
            cylinder(d = pin_shaft_d + 0.25, h = 5.0);

        translate([0, 0, 1.2])
            cylinder(d = 4.6, h = 3.0);

        translate([0, 0, -0.01])
            cylinder(d1 = pin_shaft_d + 1.2, d2 = pin_shaft_d + 0.25, h = 0.8);
    }
}

// Layout on Print Bed (Spaced side-by-side at Z = 0)
translate([-8.0, 0, 0])
    axle_pin();

translate([8.0, 0, 0])
    retaining_end_cap();
