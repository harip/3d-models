// ====================================================================
// [PRINT 08-C] Standalone 3D-Printable Precision Axle Pin (3.8mm Shaft)
//
// Engineering Specifications:
// - Station Clevis Total Outer Span: 14.0mm (4mm Ear1 + 6mm Channel + 4mm Ear2)
// - Shaft Diameter: 3.8mm (Reduced slightly for effortless insertion through bores)
// - Shaft Length: EXACTLY 14.0mm (0.0mm extra protrusion past clevis walls!)
// - Head: 9.0mm flat disk x 1.8mm thickness (Rests flush against Ear 1 outer face)
// - Tip: 4.2mm split-prong barb tip for snap-fitting retaining cap
// ====================================================================

$fn = 50;

pin_shaft_d  = 3.8;   // 3.8mm rod shaft (fits sheave & clevis bores with zero binding)
pin_length   = 14.0;  // EXACT 14.0mm shaft length matching total clevis span
head_d       = 9.0;   // Flat head disk diameter
head_th      = 1.8;   // Flat head thickness
tip_barb_d   = 4.2;   // Split-prong barb tip diameter
tip_length   = 3.2;   // Tip length

module precision_axle_pin() {
    difference() {
        union() {
            // Flat base head resting flat at Z = 0
            cylinder(d = head_d, h = head_th);
            
            // Main 3.8mm rod shaft column (exact 14.0mm length)
            translate([0, 0, head_th])
                cylinder(d = pin_shaft_d, h = pin_length);

            // Split-prong snap barb tip at end of shaft
            translate([0, 0, head_th + pin_length])
                cylinder(d1 = tip_barb_d, d2 = pin_shaft_d - 0.6, h = tip_length);
        }

        // Center flex-slit (gives spring flex space for cap snap-fit)
        translate([0, 0, head_th + pin_length - 1.5])
            cube([1.0, tip_barb_d + 2.0, tip_length + 3.0], center = true);

        // Self-guiding chamfer on base head
        translate([0, 0, -0.01])
            cylinder(d1 = head_d + 1.0, d2 = head_d, h = 0.4);
    }
}

module axle_pin() {
    precision_axle_pin();
}

precision_axle_pin();
