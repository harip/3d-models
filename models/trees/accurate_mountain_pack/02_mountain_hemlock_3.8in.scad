// 2. Mountain Hemlock (3.80 in / 96.52 mm)
// Botanically Accurate: Nodding leader tip, weeping branchlets, irregular soft canopy
$fn = 24;

module mountain_hemlock_3_8in(h = 96.52) {
    union() {
        // Tapered Alpine Trunk
        color([0.35, 0.22, 0.14]) {
            cylinder(r1 = 8.0, r2 = 3.6, h = 5.5);
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 3.6, h = h * 0.28);
                translate([0, 0, h * 0.85]) cylinder(r1 = 2.4, r2 = 0.8, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a]) hull() {
                    translate([7.2, 0, 0.4]) sphere(r = 0.7, $fn = 8);
                    translate([3.2, 0, 3.2]) sphere(r = 0.4, $fn = 8);
                }
            }
        }
        // Weeping Feathery Canopy
        color([0.16, 0.42, 0.22]) {
            for (t = [0 : 8]) {
                tz = h * (0.18 + t * 0.088);
                r_max = 26.0 * (1 - t / 9.5);
                th = 12.0 * (1 - t / 11.0);
                translate([0, 0, tz]) {
                    union() {
                        cylinder(r1 = r_max * 0.6, r2 = r_max * 0.28, h = th);
                        for (i = [0 : 6]) {
                            rotate([0, 0, i * (360 / 7) + t * 31]) {
                                // Curved weeping branch stem
                                hull() {
                                    translate([0, 0, th * 0.4]) sphere(r = r_max * 0.16, $fn = 8);
                                    translate([0, r_max * 0.7, -th * 0.05]) sphere(r = r_max * 0.12, $fn = 8);
                                }
                                hull() {
                                    translate([0, r_max * 0.7, -th * 0.05]) sphere(r = r_max * 0.12, $fn = 8);
                                    translate([0, r_max * 0.95, -th * 0.35]) sphere(r = r_max * 0.05, $fn = 8);
                                }
                                // Soft drooping foliage pods
                                translate([0, r_max * 0.65, -th * 0.1])
                                    scale([1.4, 0.8, 0.6]) sphere(r = r_max * 0.22, $fn = 10);
                            }
                        }
                    }
                }
            }
            // Characteristic Drooping / Nodding Top Leader
            translate([0, 0, h - 13.0]) {
                rotate([18, 0, 0]) hull() {
                    cylinder(r1 = 1.8, r2 = 1.0, h = 8.0);
                    translate([0, 2.5, 7.0]) cylinder(r1 = 1.0, r2 = 0.3, h = 6.0);
                }
            }
        }
    }
}

mountain_hemlock_3_8in();
