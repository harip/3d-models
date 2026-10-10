// ====================================================================
// Modular Snap-In Mountain Bridge - PART 2: BOTTOM CENTER PILLAR
// Height: Exactly 30.0 mm (3.0 cm) downward extension below deck
// Tenon: 8.0mm x 4.8mm x 2.2mm with 45-deg lead-in chamfer
// 100% Watertight Manifold Solid for Flat Bed Printing (NoError)
// ====================================================================

$fn = 28;

pillar_h  = 30.0;
deck_w    = 18.0;

module bottom_center_pillar_part() {
    union() {
        // Main Pillar Body (from Z = 0 to Z = 30.0 mm)
        hull() {
            translate([-6.0, -deck_w/2 + 1.0, 0])
                cube([12.0, deck_w - 2.0, 2.5]);
            translate([-4.5, -2.6, pillar_h - 0.2])
                cube([9.0, 5.2, 0.2]);
        }

        // Under-deck structural wing supports
        for (s = [-1, 1]) {
            hull() {
                translate([s * 3.5, -deck_w/2 + 2.5, pillar_h - 1.0])
                    cube([0.5, deck_w - 5.0, 1.0]);
                translate([s * 14.0, -deck_w/2 + 2.5, pillar_h - 0.2])
                    cube([0.5, deck_w - 5.0, 0.2]);
                translate([s * 3.5, -deck_w/2 + 2.5, pillar_h - 9.0])
                    cube([0.5, deck_w - 5.0, 1.0]);
            }
        }

        // --- MALE SNAP-IN TENON KEY (8.0mm x 4.8mm x 2.2mm) ---
        hull() {
            translate([-4.0, -2.4, pillar_h])
                cube([8.0, 4.8, 1.4]);
            translate([-3.4, -1.8, pillar_h + 2.2])
                cube([6.8, 3.6, 0.2]);
        }
    }
}

bottom_center_pillar_part();
