// Mountain Cypress / Cedar (2.0 in / 50.80 mm) - FDM Certified 100% Supportless
$fn = 32;

module mountain_cypress(h = 50.80) {
    union() {
        color([0.36, 0.24, 0.14]) {
            cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
            cylinder(r1 = 6.0, r2 = 2.8, h = 4.0);
            hull() {
                translate([0, 0, 3.0]) cylinder(r = 2.8, h = h * 0.20);
                translate([0, 0, h * 0.85]) cylinder(r1 = 1.8, r2 = 0.7, h = 3.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([5.2, 0, 0.4]) sphere(r = 0.5, $fn = 8);
                        translate([2.5, 0, 2.8]) sphere(r = 0.35, $fn = 8);
                    }
            }
        }
        color([0.18, 0.44, 0.26]) {
            for (t = [0 : 5]) {
                tz = h * (0.18 + t * 0.13);
                rmax = 12.5 * sin((t + 1) / 7 * 180);
                th = 9.0;
                translate([0, 0, tz]) {
                    hull() {
                        translate([0, 0, -th * 0.40]) cylinder(r1 = 2.8, r2 = 2.8, h = 1.0);
                        translate([0, 0, 0]) cylinder(r1 = rmax * 0.85, r2 = rmax * 0.45, h = th);
                    }
                    for (i = [0 : 4]) {
                        rotate([0, 0, i * 72 + t * 25]) {
                            translate([0, rmax * 0.70, 0])
                                rotate([-15, 0, 0])
                                    scale([0.6, 1.2, 1.0])
                                        cylinder(r1 = rmax * 0.3, r2 = 0.2, h = th * 0.8, $fn = 8);
                        }
                    }
                }
            }
            translate([0, 0, h - 6.5]) cylinder(r1 = 1.4, r2 = 0.3, h = 6.5);
        }
    }
}

mountain_cypress(50.80);
