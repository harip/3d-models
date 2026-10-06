// ====================================================================
// [PRINT 04-A] Precision Snap-Fit Top Plugins for Carriage 04 (Pair of 2)
//
// Precision Engineering Specifications:
// - Matched to Carriage 04 Top Slot Gap (2.2mm nominal width).
// - Top Flange: 6.0mm (X-length) x 9.6mm (Y-width) x 2.0mm (Z-thickness).
// - Protruding Snapin Tab: 4.5mm (X-length) x 2.35mm (Y-thickness) x 4.5mm (Z-depth) [Increased Height].
// - Locking Snap Barb: 2.50mm max barb width (snaps tight inside Carriage 04 slot).
// - 100% Support-Free: Rests flat on build plate at Z = 0.
// ====================================================================

$fn = 40;

module snap_top_plugin() {
    union() {
        // 1. Top Cap Seating Flange (rests flush on top surface of Carriage 04)
        translate([0, 0, 1.0])
            cube([6.0, 9.6, 2.0], center = true);

        // 2. Main Protruding Snapin Shaft (increased height to 4.0mm)
        translate([0, 0, 4.0])
            cube([4.5, 2.35, 4.0], center = true);

        // 3. Precision Snap-Lock Barb (2.50mm max width with 45-deg lead-in)
        translate([0, 0, 6.25])
            hull() {
                translate([0, 0, -0.25])
                    cube([4.5, 2.5, 0.1], center = true);
                translate([0, 0, 0.25])
                    cube([4.5, 1.8, 0.1], center = true);
            }
    }
}

// Pair of 2 precision snap-fit plugins
translate([-6.0, 0, 0])
    snap_top_plugin();

translate([6.0, 0, 0])
    snap_top_plugin();
