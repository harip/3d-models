// ====================================================================
// [PRINT 04-A] Simple Top Plug Caps for Trolley Carriage 04 (Pair of 2)
//
// Simple & Clean:
// - 2 simple press-fit plugs that push into the top slot of Carriage 04.
// - Top Cap: 4.0mm x 9.6mm x 2.0mm.
// - Bottom Plug Tab: 4.0mm x 2.1mm x 3.0mm press-fit tab.
// ====================================================================

$fn = 40;

module simple_top_plug() {
    union() {
        // Top Cap (rests on top of Carriage 04)
        translate([0, 0, 1.0])
            cube([4.0, 9.6, 2.0], center = true);

        // Simple Press-Fit Plug Tab (pushes into top slot)
        translate([0, 0, 3.5])
            cube([4.0, 2.1, 3.0], center = true);
    }
}

// Pair of 2 simple plugs
translate([-5.0, 0, 0])
    simple_top_plug();

translate([5.0, 0, 0])
    simple_top_plug();
