// Mountain Hemlock (3.80 in / 96.52 mm)
// Mountain Variety Pack (3-4 inch)
// 100% Supportless Single Manifold Solid

$fn = 32;

module mountain_hemlock_3_8in(h = 96.52) {
    union() {
        // Tapered Alpine Trunk
        color([0.36, 0.22, 0.13]) {
            cylinder(r1 = 9.0, r2 = 4.2, h = 5.5);
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 4.2, h = h * 0.28);
                translate([0, 0, h * 0.84]) cylinder(r1 = 2.8, r2 = 1.0, h = 5.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([8.2, 0, 0.5]) sphere(r = 0.7, $fn = 8);
                        translate([3.8, 0, 4.0]) sphere(r = 0.5, $fn = 8);
                    }
            }
        }
        // Deep Evergreen Drooping Boughs
        color([0.16, 0.44, 0.24]) {
            for (t = [0 : 7]) {
                tz = h * (0.20 + t * 0.095);
                r_b = 25.0 * (1 - t / 8.5);
                r_t = r_b * 0.55;
                th = 12.0 * (1 - t / 10.0);
                translate([0, 0, tz]) {
                    union() {
                        translate([0, 0, -th * 0.10])
                            cylinder(r1 = r_b * 0.65, r2 = r_t * 0.85, h = th * 1.1);
                        for (i = [0 : 6]) {
                            rotate([0, 0, i * (360 / 7) + t * 24]) {
                                rotate([18, 0, 0]) {
                                    hull() {
                                        translate([0, 0, th * 0.52]) sphere(r = r_t * 0.48, $fn = 10);
                                        translate([0, r_b * 0.90, -th * 0.14]) sphere(r = r_b * 0.22, $fn = 10);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // Characteristic Graceful Drooping Top Tip
            translate([0, 0, h - 12.0]) {
                rotate([14, 0, 0])
                    cylinder(r1 = 2.0, r2 = 0.4, h = 12.0);
            }
        }
    }
}

mountain_hemlock_3_8in();
