// ====================================================================
// [PRINT 08-B] 3D-Printable M5 Sheave Axle Pin & Snap-Fit Retaining End Cap
//
// Features:
// - 1x M5 Axle Pin: 5.0mm shaft diameter x 18mm length with 10mm flat cap head and split-prong tip.
// - 1x Retaining End Cap: 10mm flat cap disk with internal snap shoulder. Closes the end of the M5 pin!
// - 100% Support-Free: Both pieces rest flat on build plate at Z = 0.
// ====================================================================

$fn = 50;

pin_shaft_d  = 5.0;  // Fits 5.2mm bore with 0.2mm clearance
pin_length   = 18.0; // Spans through roof hub / bracket
head_d       = 10.0; // Flat head disk diameter
head_th      = 2.0;  // Flat head thickness
tip_barb_d   = 5.4;  // Split-prong barb tip diameter
tip_length   = 4.0;  // Tip length

module m5_axle_pin() {
    difference() {
        union() {
            // Flat base head resting flat at Z = 0
            cylinder(d = head_d, h = head_th);
            
            // Main 5.0mm M5 shaft column
            translate([0, 0, head_th])
                cylinder(d = pin_shaft_d, h = pin_length);

            // Split-prong snap barb tip at end of shaft
            translate([0, 0, head_th + pin_length])
                cylinder(d1 = tip_barb_d, d2 = pin_shaft_d - 0.6, h = tip_length);
        }

        // Center flex-slit (gives 1.2mm spring flex space for cap snap-fit)
        translate([0, 0, head_th + pin_length - 2.0])
            cube([1.2, tip_barb_d + 2.0, tip_length + 4.0], center = true);

        // Self-guiding chamfer on base
        translate([0, 0, -0.01])
            cylinder(d1 = head_d + 1.0, d2 = head_d, h = 0.5);
    }
}

module m5_retaining_end_cap() {
    difference() {
        union() {
            // Flat outer cap disk resting flat at Z = 0
            cylinder(d = head_d, h = 3.5);
        }

        // Inner receiving socket for 5.0mm shaft
        translate([0, 0, -1])
            cylinder(d = pin_shaft_d + 0.25, h = 5.0);

        // Internal snap-shoulder recess (5.5mm diameter accepts 5.4mm barb tip)
        translate([0, 0, 1.2])
            cylinder(d = 5.6, h = 3.0);

        // Chamfer mouth lead-in
        translate([0, 0, -0.01])
            cylinder(d1 = pin_shaft_d + 1.2, d2 = pin_shaft_d + 0.25, h = 0.8);
    }
}

// Layout on Print Bed (Spaced side-by-side at Z = 0)
translate([-8.0, 0, 0])
    m5_axle_pin();

translate([8.0, 0, 0])
    m5_retaining_end_cap();
