// ====================================================================
// [PRINT 08-C] Standalone 3D-Printable Reduced Axle Pin (4.0mm Rod Diameter)
//
// Features:
// - Reduced 4.0mm rod diameter (fits 4.2mm bore sheave).
// - Length adjusted (17.5mm shaft) for the 10% reduced 4.5mm sheave wheel.
// - 100% Support-Free: Rests flat on build plate at Z = 0.
// ====================================================================

$fn = 50;

pin_shaft_d  = 4.0;  // Reduced rod diameter (fits 4.2mm bore with 0.2mm clearance)
pin_length   = 17.5; // Adjusted length for 4.5mm sheave wheel
head_d       = 9.0;  // Flat head disk diameter
head_th      = 2.0;  // Flat head thickness
tip_barb_d   = 4.4;  // Split-prong barb tip diameter
tip_length   = 4.0;  // Tip length

module axle_pin() {
    difference() {
        union() {
            // Flat base head resting flat at Z = 0
            cylinder(d = head_d, h = head_th);
            
            // Main 4.0mm rod shaft column
            translate([0, 0, head_th])
                cylinder(d = pin_shaft_d, h = pin_length);

            // Split-prong snap barb tip at end of shaft
            translate([0, 0, head_th + pin_length])
                cylinder(d1 = tip_barb_d, d2 = pin_shaft_d - 0.6, h = tip_length);
        }

        // Center flex-slit (gives spring flex space for cap snap-fit)
        translate([0, 0, head_th + pin_length - 2.0])
            cube([1.0, tip_barb_d + 2.0, tip_length + 4.0], center = true);

        // Self-guiding chamfer on base
        translate([0, 0, -0.01])
            cylinder(d1 = head_d + 1.0, d2 = head_d, h = 0.5);
    }
}

axle_pin();
