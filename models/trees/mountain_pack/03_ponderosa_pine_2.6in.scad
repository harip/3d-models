// Ponderosa Pine (2.6 in / 66.04 mm) - FDM Certified 100% Supportless
$fn = 32;

module ponderosa_pine(h = 66.04) {
    union() {
        color([0.46, 0.27, 0.15]) { // Warm Bark Orange-Brown
            cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
            cylinder(r1 = 8.0, r2 = 3.8, h = 5.0);
            hull() {
                translate([0, 0, 4.0]) cylinder(r1 = 3.8, r2 = 2.6, h = h * 0.55);
                translate([0, 0, h * 0.82]) cylinder(r1 = 2.6, r2 = 1.0, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([7.2, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                        translate([3.4, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                    }
            }
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba]) {
                    hull() {
                        translate([0, 0, h * 0.55]) sphere(r = 1.8, $fn = 8);
                        translate([0, 11.0, h * 0.72]) sphere(r = 1.1, $fn = 8);
                    }
                }
            }
        }
        color([0.16, 0.42, 0.18]) {
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba]) {
                    translate([0, 11.0, h * 0.72]) {
                        cylinder(r1 = 1.1, r2 = 6.5, h = 6.0);
                        translate([0, 0, 2.5]) cylinder(r1 = 6.5, r2 = 0.4, h = 5.0);
                    }
                }
            }
            for (ba = [45, 135, 225, 315]) {
                rotate([0, 0, ba]) {
                    translate([0, 7.5, h * 0.82]) {
                        cylinder(r1 = 0.9, r2 = 5.5, h = 5.5);
                        translate([0, 0, 2.0]) cylinder(r1 = 5.5, r2 = 0.3, h = 4.5);
                    }
                }
            }
            translate([0, 0, h - 7.5]) {
                cylinder(r1 = 1.2, r2 = 5.0, h = 5.0);
                translate([0, 0, 2.2]) cylinder(r1 = 5.0, r2 = 0.3, h = 4.5);
            }
        }
    }
}

ponderosa_pine(66.04);
