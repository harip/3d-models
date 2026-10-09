// Mountain Hemlock (2.8 in / 71.12 mm) - FDM Certified 100% Supportless
$fn = 32;

module mountain_hemlock(h = 71.12) {
    union() {
        color([0.36, 0.22, 0.13]) {
            cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
            cylinder(r1 = 7.0, r2 = 3.4, h = 4.5);
            hull() {
                translate([0, 0, 3.0]) cylinder(r = 3.4, h = h * 0.28);
                translate([0, 0, h * 0.82]) cylinder(r1 = 2.4, r2 = 0.9, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([6.2, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                        translate([3.0, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                    }
            }
        }
        color([0.14, 0.40, 0.20]) { // Deep Forest Alpine Green
            for (t = [0 : 6]) {
                tz = h * (0.22 + t * 0.10);
                rb = 20.0 * (1 - t / 7.5);
                rt = rb * 0.55;
                ht = 10.5 * (1 - t / 9.0);
                translate([0, 0, tz]) {
                    hull() {
                        translate([0, 0, -ht * 0.55]) cylinder(r1 = 3.4, r2 = 3.4, h = 1.0);
                        translate([0, 0, ht * 0.20]) cylinder(r1 = rb, r2 = rt, h = ht * 0.80);
                    }
                    for (i = [0 : 5]) {
                        rotate([0, 0, i * 60 + t * 25]) {
                            hull() {
                                translate([0, 3.4, ht * 0.10]) cylinder(r1 = 1.8, r2 = 0.9, h = ht * 0.45);
                                translate([0, rb * 0.88, ht * 0.25]) cylinder(r1 = rb * 0.15, r2 = 0.3, h = ht * 0.38, $fn = 6);
                            }
                        }
                    }
                }
            }
            translate([0, 0, h - 10.0]) rotate([10, 0, 0]) cylinder(r1 = 1.6, r2 = 0.3, h = 10.0);
        }
    }
}

mountain_hemlock(71.12);
