// Colorado Blue Spruce (3.0 in / 76.2 mm) - FDM Certified 100% Supportless
$fn = 32;

module colorado_blue_spruce(h = 76.2) {
    union() {
        color([0.38, 0.24, 0.14]) {
            cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
            cylinder(r1 = 7.5, r2 = 3.8, h = 4.5);
            hull() {
                translate([0, 0, 3.0]) cylinder(r = 3.8, h = h * 0.25);
                translate([0, 0, h - 8.0]) cylinder(r1 = 2.2, r2 = 0.8, h = 7.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([6.8, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                        translate([3.2, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                    }
            }
        }
        color([0.21, 0.42, 0.40]) { // Slate Blue-Green
            for (t = [0 : 6]) {
                tz = h * (0.20 + t * 0.11);
                rb = 23.0 * (1 - t / 7.2);
                rt = rb * 0.6;
                ht = 11.5 * (1 - t / 9.0);
                translate([0, 0, tz]) {
                    hull() {
                        translate([0, 0, -ht * 0.60]) cylinder(r1 = 3.8, r2 = 3.8, h = 1.0);
                        translate([0, 0, ht * 0.20]) cylinder(r1 = rb, r2 = rt, h = ht * 0.80);
                    }
                    for (i = [0 : 6]) {
                        rotate([0, 0, i * (360/7) + t * 18]) {
                            hull() {
                                translate([0, 3.8, ht * 0.10]) cylinder(r1 = 2.0, r2 = 1.0, h = ht * 0.50);
                                translate([0, rb * 0.90, ht * 0.30]) cylinder(r1 = rb * 0.16, r2 = 0.3, h = ht * 0.40, $fn = 6);
                            }
                        }
                    }
                }
            }
            translate([0, 0, h - 8.5]) cylinder(r1 = 1.8, r2 = 0.3, h = 8.5);
        }
    }
}

colorado_blue_spruce(76.2);
