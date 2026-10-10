// ====================================================================
// Modular Snap-In Mountain Bridge - PART 2: BOTTOM CENTER PILLAR
// Height: Exactly 30.0 mm (3.0 cm) downward extension below deck
// Tenon: 11.4mm x 6.4mm x 2.5mm (Snaps tight & nice into 12x7mm deck socket)
// 100% Watertight Manifold Solid for Flat Bed Printing (NoError)
// ====================================================================

$fn = 28;

pillar_h  = 30.0;
deck_w    = 27.0; // 50% wider proportion

module bottom_center_pillar_part() {
    union() {
        // Main Pillar Body (from Z = 0 to Z = 30.0 mm)
        hull() {
            // Wide foundation footing on chasm floor (Z = 0)
            translate([-8.0, -deck_w/2 + 1.5, 0])
                cube([16.0, deck_w - 3.0, 3.0]);
            // Top mating face at deck underside (Z = 30.0 mm)
            translate([-6.5, -4.0, pillar_h - 0.2])
                cube([13.0, 8.0, 0.2]);
        }

        // Structural 45-degree flared wing brackets supporting wide deck
        for (s = [-1, 1]) {
            hull() {
                translate([s * 5.0, -deck_w/2 + 3.0, pillar_h - 1.0])
                    cube([0.5, deck_w - 6.0, 1.0]);
                translate([s * 18.0, -deck_w/2 + 3.0, pillar_h - 0.2])
                    cube([0.5, deck_w - 6.0, 0.2]);
                translate([s * 5.0, -deck_w/2 + 3.0, pillar_h - 12.0])
                    cube([0.5, deck_w - 6.0, 1.0]);
            }
        }

        // --- MALE SNAP-IN TENON KEY (SNAPS TIGHT & NICE INTO 12.0 x 7.0 MM SOCKET) ---
        // Sized 11.4mm x 6.4mm x 2.5mm (0.3mm per-side clearance with 45-deg lead-in bevel)
        hull() {
            translate([-5.7, -3.2, pillar_h])
                cube([11.4, 6.4, 1.6]);
            translate([-5.0, -2.5, pillar_h + 2.5])
                cube([10.0, 5.0, 0.2]);
        }
    }
}

bottom_center_pillar_part();
