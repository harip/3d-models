// 1. Colorado Blue Spruce (4.00 in / 101.6 mm)
// Botanically Accurate: Layered rigid whorls, blue-green needles, downturned branchlets, spire top
$fn = 24;

module blue_spruce_4in(h = 101.6) {
    union() {
        // Tapered Trunk with Bark Ridges
        color([0.38, 0.25, 0.16]) {
            cylinder(r1 = 8.5, r2 = 3.8, h = 6.0);
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 3.8, h = h * 0.25);
                translate([0, 0, h * 0.88]) cylinder(r1 = 2.5, r2 = 0.8, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a]) hull() {
                    translate([7.8, 0, 0.4]) sphere(r = 0.8, $fn = 8);
                    translate([3.5, 0, 3.5]) sphere(r = 0.4, $fn = 8);
                }
            }
        }
        // Dense Rigid Tiered Foliage
        color([0.20, 0.45, 0.42]) {
            for (t = [0 : 9]) {
                tz = h * (0.16 + t * 0.082);
                r_max = 30.0 * (1 - t / 10.5);
                th = 13.0 * (1 - t / 12.0);
                translate([0, 0, tz]) {
                    union() {
                        // Trunk overlay cone
                        cylinder(r1 = r_max * 0.55, r2 = r_max * 0.25, h = th);
                        // Radiant branches (8 per tier)
                        for (i = [0 : 7]) {
                            rotate([0, 0, i * 45 + t * 27.5]) {
                                // Main drooping bough stem
                                hull() {
                                    translate([0, 0, th * 0.3]) sphere(r = r_max * 0.18, $fn = 8);
                                    translate([0, r_max * 0.85, -th * 0.2]) sphere(r = r_max * 0.08, $fn = 8);
                                }
                                // Needle sprays along bough stem
                                for (np = [0.25, 0.50, 0.75, 0.95]) {
                                    translate([0, r_max * np, th * 0.3 * (1 - np) - th * 0.2 * np]) {
                                        for (na = [-35, -15, 0, 15, 35]) {
                                            rotate([na, 12, 0])
                                                cylinder(r1 = r_max * 0.09, r2 = 0.2, h = th * 0.45, $fn = 6);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // Sharp Spire Apex Leader
            translate([0, 0, h - 12.0])
                cylinder(r1 = 2.0, r2 = 0.3, h = 12.0);
        }
    }
}

blue_spruce_4in();
