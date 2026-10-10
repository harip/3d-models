// 5. Subalpine Fir (3.20 in / 81.28 mm)
// Botanically Accurate: Extreme narrow spire silhouette, compact snow-shedding foliage tiers
$fn = 24;

module subalpine_fir_3_2in(h = 81.28) {
    union() {
        // Tapered Trunk & Base Foot
        color([0.34, 0.22, 0.14]) {
            cylinder(r1 = 7.5, r2 = 3.6, h = 5.0);
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 3.6, h = h * 0.22);
                translate([0, 0, h * 0.86]) cylinder(r1 = 2.2, r2 = 0.8, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a]) hull() {
                    translate([6.8, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                    translate([3.2, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                }
            }
        }
        // Narrow Columnar Tiered Spire
        color([0.14, 0.42, 0.22]) {
            for (t = [0 : 9]) {
                tz = h * (0.15 + t * 0.082);
                r_max = 16.0 * (1 - t / 10.5);
                th = 9.5 * (1 - t / 11.5);
                translate([0, 0, tz]) {
                    union() {
                        cylinder(r1 = r_max, r2 = r_max * 0.45, h = th);
                        for (i = [0 : 6]) {
                            rotate([0, 0, i * (360 / 7) + t * 20])
                                translate([r_max * 0.65, 0, -th * 0.1])
                                    rotate([32, 0, 0])
                                        cylinder(r1 = r_max * 0.24, r2 = 0.3, h = th * 0.62, $fn = 6);
                        }
                    }
                }
            }
            // Ultra-Sharp Spire Apex
            translate([0, 0, h - 10.0])
                cylinder(r1 = 1.6, r2 = 0.3, h = 10.0);
        }
    }
}

subalpine_fir_3_2in();
