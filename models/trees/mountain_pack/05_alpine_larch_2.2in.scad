// Alpine Larch (2.2 in / 55.88 mm) - FDM Certified 100% Supportless
$fn = 32;

module alpine_larch(h = 55.88) {
    union() {
        color([0.40, 0.25, 0.15]) {
            cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
            cylinder(r1 = 6.2, r2 = 3.0, h = 4.0);
            hull() {
                translate([0, 0, 3.0]) cylinder(r = 3.0, h = h * 0.25);
                translate([0, 0, h * 0.82]) cylinder(r1 = 2.0, r2 = 0.8, h = 3.5);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([5.5, 0, 0.4]) sphere(r = 0.5, $fn = 8);
                        translate([2.6, 0, 2.8]) sphere(r = 0.35, $fn = 8);
                    }
            }
        }
        color([0.24, 0.48, 0.20]) { // Golden Alpine Green
            for (t = [0 : 5]) {
                tz = h * (0.22 + t * 0.12);
                rb = 16.0 * (1 - t / 6.5);
                ht = 8.0 * (1 - t / 8.0);
                translate([0, 0, tz]) {
                    hull() {
                        translate([0, 0, -ht * 0.50]) cylinder(r1 = 3.0, r2 = 3.0, h = 1.0);
                        translate([0, 0, ht * 0.20]) cylinder(r1 = rb * 0.6, r2 = rb * 0.3, h = ht * 0.8);
                    }
                    for (i = [0 : 6]) {
                        rotate([0, 0, i * (360/7) + t * 15]) {
                            translate([0, rb * 0.75, 0])
                                rotate([12, 0, 0])
                                    scale([1.2, 0.5, 0.5])
                                        cylinder(r1 = rb * 0.25, r2 = 0.2, h = ht * 0.7, $fn = 8);
                        }
                    }
                }
            }
            translate([0, 0, h - 7.0]) cylinder(r1 = 1.4, r2 = 0.3, h = 7.0);
        }
    }
}

alpine_larch(55.88);
