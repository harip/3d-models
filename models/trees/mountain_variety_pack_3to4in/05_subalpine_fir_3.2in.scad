// Subalpine Fir (3.20 in / 81.28 mm)
// Mountain Variety Pack (3-4 inch)
// Narrow Spire Alpine Cone - 100% Supportless Manifold Solid

$fn = 32;

module subalpine_fir_3_2in(h = 81.28) {
    union() {
        // Tapered Alpine Trunk
        color([0.34, 0.22, 0.14]) {
            cylinder(r1 = 8.0, r2 = 3.8, h = 5.0);
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 3.8, h = h * 0.22);
                translate([0, 0, h * 0.86]) cylinder(r1 = 2.4, r2 = 0.9, h = 4.5);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([7.2, 0, 0.5]) sphere(r = 0.6, $fn = 8);
                        translate([3.4, 0, 3.5]) sphere(r = 0.4, $fn = 8);
                    }
            }
        }
        // Narrow Spire Conical Foliage Tiers
        color([0.14, 0.42, 0.22]) {
            for (t = [0 : 8]) {
                tz = h * (0.16 + t * 0.09);
                r_b = 16.5 * (1 - t / 9.2);
                r_t = r_b * 0.5;
                th = 10.5 * (1 - t / 11.0);
                translate([0, 0, tz]) {
                    union() {
                        cylinder(r1 = r_b, r2 = r_t, h = th);
                        for (i = [0 : 6]) {
                            rotate([0, 0, i * (360 / 7) + t * 22])
                                translate([r_b * 0.70, 0, -th * 0.1])
                                    rotate([28, 0, 0])
                                        cylinder(r1 = r_b * 0.22, r2 = 0.3, h = th * 0.58, $fn = 6);
                        }
                    }
                }
            }
            // Sharp Spire Apex
            translate([0, 0, h - 9.5])
                cylinder(r1 = 1.8, r2 = 0.3, h = 9.5);
        }
    }
}

subalpine_fir_3_2in();
