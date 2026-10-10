// ====================================================================
// Modular Rotor Axle Pin & Retaining Cap
// Precision bearing pin for low-friction rotation of the main rotor.
//
// Engineering Specifications:
// - Cap Head: 5.2mm diameter x 1.2mm height with chamfered top
// - Bearing Spindle: 2.4mm diameter x 2.5mm length (matches 2.8mm rotor bore)
//   -> 0.4mm diametral clearance ensures free, low-friction spin
//   -> 0.3mm axial play prevents vertical pinching
// - Anchor Stem: 2.2mm diameter x 4.2mm length with retention barb
// - Central compliance slit (0.6mm) enables spring-loaded snap retention
// - 100% supportless vertical print grounded on flat cap head (Z = 0)
// ====================================================================

$fn = 48;

cap_d     = 5.2;
cap_h     = 1.2;
journal_d = 2.4;
journal_h = 2.5;
stem_d    = 2.2;
stem_h    = 4.2;
barb_d    = 2.38; // Slight snap-retaining barb

module rotor_axle_pin() {
    difference() {
        union() {
            // 1. Cap Head (grounded at Z = 0)
            cylinder(d = cap_d, h = cap_h, center = false);
            // Cap chamfer
            translate([0, 0, cap_h - 0.3])
                cylinder(d1 = cap_d, d2 = cap_d - 0.6, h = 0.3, center = false);

            // 2. Bearing Spindle Journal (smooth rotation surface)
            translate([0, 0, cap_h])
                cylinder(d = journal_d, h = journal_h, center = false);

            // 3. Anchor Stem
            translate([0, 0, cap_h + journal_h]) {
                // Shaft
                cylinder(d = stem_d, h = stem_h - 0.8, center = false);

                // Retention barb ring
                translate([0, 0, 1.8])
                    cylinder(d1 = stem_d, d2 = barb_d, h = 0.6, center = false);
                translate([0, 0, 2.4])
                    cylinder(d1 = barb_d, d2 = stem_d, h = 0.4, center = false);

                // Lead-in chamfer at tip for easy insertion
                translate([0, 0, stem_h - 0.8])
                    cylinder(d1 = stem_d, d2 = stem_d - 0.6, h = 0.8, center = false);
            }
        }

        // Longitudinal compliance slot in stem (spring-loaded snap action)
        translate([0, 0, cap_h + journal_h + stem_h/2])
            cube([0.6, stem_d + 1.0, stem_h + 0.2], center = true);
    }
}

// Standalone print orientation: Head flat on bed at Z = 0
rotor_axle_pin();
