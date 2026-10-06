// ====================================================================
// [PRINT 04-A] Simple Top Plug Caps for Trolley Carriage 04 (Pair of 2)
//
// Features:
// - Overall Plug Width: Strictly 4.0mm (matches original carriage width).
// - Top Cap Flange: 4.0mm x 9.6mm x 2.0mm (unaltered overall width).
// - Protruding Snapin Tab: 4.0mm x 2.6mm x 4.2mm (snapin tab thickness increased to 2.6mm).
// ====================================================================

$fn = 40;

module simple_top_plug() {
    union() {
        // Top Cap Flange (overall width strictly preserved at 4.0mm)
        translate([0, 0, 1.0])
            cube([4.0, 9.6, 2.0], center = true);

        // Protruding Snapin Tab (snapin thickness increased to 2.6mm, height 4.2mm)
        translate([0, 0, 4.1])
            cube([4.0, 2.6, 4.2], center = true);
    }
}

// Pair of 2 simple plugs
translate([-5.0, 0, 0])
    simple_top_plug();

translate([5.0, 0, 0])
    simple_top_plug();
