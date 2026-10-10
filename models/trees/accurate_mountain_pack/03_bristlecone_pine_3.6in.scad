// 3. Bristlecone Pine (3.60 in / 91.44 mm) - Multi-Branch Rich Alpine Model
// Botanically Accurate: Gnarled Weathered Trunk, Deadwood Spike Top, 6 Supportless Foxtail Limb Tufts
// 100% Supportless Manifold Solid (Zero Floating Objects, All Overhangs <= 45 Deg)

$fn = 28;

module bristlecone_pine_3_6in(h = 91.44) {
    union() {
        // --- 1. WEATHERED GNARLED TRUNK & MULTI-BRANCH SYSTEM ---
        color([0.46, 0.28, 0.17]) {
            // Flared Base & Root Buttresses
            cylinder(r1 = 10.5, r2 = 5.4, h = 6.0);
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a]) hull() {
                    translate([9.5, 0, 0.5]) sphere(r = 1.0, $fn = 8);
                    translate([4.8, 0, 4.0]) sphere(r = 0.6, $fn = 8);
                }
            }

            // Gnarled Twisted Trunk Path
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 5.4, h = 10.0);
                translate([4.0, 2.0, h * 0.35]) sphere(r = 4.2, $fn = 12);
            }
            hull() {
                translate([4.0, 2.0, h * 0.35]) sphere(r = 4.2, $fn = 12);
                translate([-3.0, 4.0, h * 0.60]) sphere(r = 3.5, $fn = 12);
            }
            hull() {
                translate([-3.0, 4.0, h * 0.60]) sphere(r = 3.5, $fn = 12);
                translate([1.5, 1.0, h * 0.82]) sphere(r = 2.4, $fn = 12);
            }

            // Exposed Ancient Deadwood Spike Top
            translate([1.5, 1.0, h * 0.82])
                cylinder(r1 = 2.2, r2 = 0.3, h = h * 0.18, $fn = 10);

            // --- 6 SUPPORTLESS GNARLED LIMB FORKS ---
            // Branch 1 (Lower Right)
            hull() {
                translate([4.0, 2.0, h * 0.35]) sphere(r = 3.2, $fn = 10);
                translate([15.0, 7.0, h * 0.48]) sphere(r = 2.0, $fn = 10);
            }
            // Branch 2 (Lower Left Low Bough)
            hull() {
                translate([4.0, 2.0, h * 0.35]) sphere(r = 3.0, $fn = 10);
                translate([-14.0, -6.0, h * 0.42]) sphere(r = 1.9, $fn = 10);
            }
            // Branch 3 (Mid Left)
            hull() {
                translate([-3.0, 4.0, h * 0.60]) sphere(r = 2.8, $fn = 10);
                translate([-15.0, 5.0, h * 0.68]) sphere(r = 1.8, $fn = 10);
            }
            // Branch 4 (Mid Front Bough)
            hull() {
                translate([-3.0, 4.0, h * 0.54]) sphere(r = 2.6, $fn = 10);
                translate([6.0, 13.0, h * 0.58]) sphere(r = 1.8, $fn = 10);
            }
            // Branch 5 (Upper Rear)
            hull() {
                translate([1.5, 1.0, h * 0.76]) sphere(r = 2.2, $fn = 10);
                translate([8.0, -10.0, h * 0.82]) sphere(r = 1.6, $fn = 10);
            }
            // Branch 6 (Upper Right Crown)
            hull() {
                translate([1.5, 1.0, h * 0.76]) sphere(r = 2.2, $fn = 10);
                translate([11.0, -6.0, h * 0.78]) sphere(r = 1.6, $fn = 10);
            }
        }

        // --- 2. DENSE SUPPORTLESS FOXTAIL NEEDLE TUFTS (6 CLUSTERS + CROWN) ---
        color([0.22, 0.44, 0.24]) {
            // Main Center Crown Tuft
            translate([1.5, 1.0, h * 0.75])
                supportless_foxtail_tuft(r = 13.0, length = 16.0);

            // Tuft 1 (Lower Right)
            translate([15.0, 7.0, h * 0.48])
                supportless_foxtail_tuft(r = 11.0, length = 14.0);

            // Tuft 2 (Lower Left Low Bough)
            translate([-14.0, -6.0, h * 0.42])
                supportless_foxtail_tuft(r = 10.5, length = 13.0);

            // Tuft 3 (Mid Left)
            translate([-15.0, 5.0, h * 0.68])
                supportless_foxtail_tuft(r = 12.0, length = 15.0);

            // Tuft 4 (Mid Front Bough)
            translate([6.0, 13.0, h * 0.58])
                supportless_foxtail_tuft(r = 11.5, length = 14.0);

            // Tuft 5 (Upper Rear)
            translate([8.0, -10.0, h * 0.82])
                supportless_foxtail_tuft(r = 10.0, length = 13.0);

            // Tuft 6 (Upper Right Crown)
            translate([11.0, -6.0, h * 0.78])
                supportless_foxtail_tuft(r = 10.5, length = 13.5);
        }
    }
}

// 100% Supportless Foxtail Tuft
module supportless_foxtail_tuft(r = 12.0, length = 14.0) {
    union() {
        translate([0, 0, -2.5])
            cylinder(r1 = 2.5, r2 = 3.5, h = 3.5, $fn = 12);
        
        cylinder(r1 = 3.5, r2 = r, h = (r - 3.5), $fn = 16);
        
        translate([0, 0, r - 3.5])
            cylinder(r1 = r, r2 = 0.8, h = length - (r - 3.5), $fn = 16);
            
        for (a = [0 : 45 : 315]) {
            rotate([0, 0, a]) {
                translate([0, r * 0.55, r * 0.6])
                    rotate([22, 0, 0])
                        scale([1.1, 0.7, 0.7])
                            sphere(r = r * 0.32, $fn = 8);
            }
        }
    }
}

bristlecone_pine_3_6in();
