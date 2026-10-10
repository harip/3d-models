// Alpine Larch (3.00 in / 76.20 mm)
// Mountain Variety Pack (3-4 inch)
// Golden-Green Needle Whorls - 100% Supportless Manifold Solid

$fn = 32;

module alpine_larch_3_0in(h = 76.20) {
    union() {
        // Trunk & Flared Foot
        color([0.40, 0.25, 0.15]) {
            cylinder(r1 = 7.5, r2 = 3.6, h = 4.5);
            hull() {
                translate([0, 0, 3.5]) cylinder(r = 3.6, h = h * 0.25);
                translate([0, 0, h * 0.84]) cylinder(r1 = 2.2, r2 = 0.9, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([6.8, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                        translate([3.2, 0, 3.2]) sphere(r = 0.4, $fn = 8);
                    }
            }
        }
        // Feathery Golden-Green Needle Whorl Tiers
        color([0.32, 0.54, 0.24]) {
            for (t = [0 : 6]) {
                tz = h * (0.20 + t * 0.11);
                r_b = 20.0 * (1 - t / 7.5);
                th = 10.0 * (1 - t / 9.0);
                translate([0, 0, tz]) {
                    union() {
                        cylinder(r1 = r_b * 0.65, r2 = r_b * 0.32, h = th);
                        for (i = [0 : 7]) {
                            rotate([0, 0, i * 45 + t * 18]) {
                                translate([0, r_b * 0.75, 0])
                                    rotate([14, 0, 0])
                                        scale([1.2, 0.5, 0.5])
                                            cylinder(r1 = r_b * 0.26, r2 = 0.3, h = th * 0.72, $fn = 8);
                            }
                        }
                    }
                }
            }
            // Conical Apex
            translate([0, 0, h - 9.0])
                cylinder(r1 = 1.6, r2 = 0.4, h = 9.0);
        }
    }
}

alpine_larch_3_0in();
