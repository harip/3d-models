// 6. Alpine Larch (3.00 in / 76.20 mm)
// Botanically Accurate: Deciduous conifer, open delicate branching with feathery golden needle whorls
$fn = 24;

module alpine_larch_3_0in(h = 76.20) {
    union() {
        // Trunk & Buttress Roots
        color([0.40, 0.25, 0.15]) {
            cylinder(r1 = 7.0, r2 = 3.4, h = 4.5);
            hull() {
                translate([0, 0, 3.5]) cylinder(r = 3.4, h = h * 0.25);
                translate([0, 0, h * 0.84]) cylinder(r1 = 2.0, r2 = 0.8, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a]) hull() {
                    translate([6.4, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                    translate([3.0, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                }
            }
        }
        // Feathery Golden-Green Needle Whorls
        color([0.32, 0.54, 0.24]) {
            for (t = [0 : 7]) {
                tz = h * (0.19 + t * 0.10);
                r_max = 21.0 * (1 - t / 8.5);
                th = 9.5 * (1 - t / 9.5);
                translate([0, 0, tz]) {
                    union() {
                        cylinder(r1 = r_max * 0.65, r2 = r_max * 0.30, h = th);
                        for (i = [0 : 7]) {
                            rotate([0, 0, i * 45 + t * 22.5]) {
                                translate([0, r_max * 0.72, 0])
                                    rotate([16, 0, 0])
                                        scale([1.2, 0.5, 0.5])
                                            cylinder(r1 = r_max * 0.28, r2 = 0.3, h = th * 0.75, $fn = 8);
                            }
                        }
                    }
                }
            }
            // Fine Conical Tip
            translate([0, 0, h - 9.0])
                cylinder(r1 = 1.5, r2 = 0.3, h = 9.0);
        }
    }
}

alpine_larch_3_0in();
