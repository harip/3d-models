// Subalpine Fir (2.4 in / 60.96 mm) - FDM Certified 100% Supportless
$fn = 32;

module subalpine_fir(h = 60.96) {
    union() {
        color([0.34, 0.22, 0.14]) {
            cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
            cylinder(r1 = 6.5, r2 = 3.2, h = 4.0);
            hull() {
                translate([0, 0, 3.0]) cylinder(r = 3.2, h = h * 0.22);
                translate([0, 0, h * 0.85]) cylinder(r1 = 2.2, r2 = 0.8, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([5.8, 0, 0.4]) sphere(r = 0.5, $fn = 8);
                        translate([2.8, 0, 3.0]) sphere(r = 0.35, $fn = 8);
                    }
            }
        }
        color([0.12, 0.38, 0.18]) { // Dark Conifer Green
            for (t = [0 : 7]) {
                tz = h * (0.16 + t * 0.10);
                rb = 13.5 * (1 - t / 8.2);
                rt = rb * 0.5;
                ht = 8.5 * (1 - t / 9.5);
                translate([0, 0, tz]) {
                    hull() {
                        translate([0, 0, -ht * 0.50]) cylinder(r1 = 3.2, r2 = 3.2, h = 1.0);
                        translate([0, 0, ht * 0.20]) cylinder(r1 = rb, r2 = rt, h = ht * 0.80);
                    }
                    for (i = [0 : 5]) {
                        rotate([0, 0, i * 60 + t * 20])
                            translate([rb * 0.70, 0, -ht * 0.1])
                                rotate([28, 0, 0])
                                    cylinder(r1 = rb * 0.20, r2 = 0.2, h = ht * 0.55, $fn = 6);
                    }
                }
            }
            translate([0, 0, h - 8.0]) cylinder(r1 = 1.5, r2 = 0.3, h = 8.0);
        }
    }
}

subalpine_fir(60.96);
