// 4. Ponderosa Pine (3.40 in / 86.36 mm)
// Botanically Accurate: High clear trunk, thick bark plates, flat-topped tufted canopy rosettes
$fn = 24;

module ponderosa_pine_3_4in(h = 86.36) {
    union() {
        // High Clear Trunk with Plated Bark Ridges
        color([0.48, 0.28, 0.15]) {
            cylinder(r1 = 8.5, r2 = 4.0, h = 5.5);
            hull() {
                translate([0, 0, 4.0]) cylinder(r1 = 4.0, r2 = 2.6, h = h * 0.52);
                translate([0, 0, h * 0.84]) cylinder(r1 = 2.6, r2 = 1.0, h = 4.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a]) hull() {
                    translate([7.8, 0, 0.4]) sphere(r = 0.7, $fn = 8);
                    translate([3.5, 0, 3.2]) sphere(r = 0.4, $fn = 8);
                }
            }
            // Stout Upper Branch Forks
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba]) {
                    hull() {
                        translate([0, 0, h * 0.52]) sphere(r = 2.0, $fn = 8);
                        translate([0, 15.0, h * 0.70]) sphere(r = 1.2, $fn = 8);
                    }
                }
            }
        }

        // Tufted 3-Needle Rosette Clusters (Upper Canopy)
        color([0.18, 0.44, 0.20]) {
            // Main lower Rosette Ring
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba]) {
                    translate([0, 15.0, h * 0.70]) {
                        ponderosa_rosette(r = 10.0);
                    }
                }
            }
            // Upper Rosette Ring
            for (ba = [45, 135, 225, 315]) {
                rotate([0, 0, ba]) {
                    translate([0, 10.0, h * 0.80]) {
                        ponderosa_rosette(r = 8.5);
                    }
                }
            }
            // Top Crown Rosette Dome
            translate([0, 0, h - 10.0]) {
                ponderosa_rosette(r = 8.0);
            }
        }
    }
}

module ponderosa_rosette(r = 9.0) {
    union() {
        cylinder(r1 = 1.2, r2 = r, h = 6.0);
        translate([0, 0, 3.0]) cylinder(r1 = r * 1.05, r2 = 0.6, h = 6.0);
        for (i = [0 : 5]) {
            rotate([0, 0, i * 60])
                translate([0, r * 0.65, 3.0])
                    rotate([20, 0, 0])
                        cylinder(r1 = r * 0.2, r2 = 0.2, h = 5.0, $fn = 6);
        }
    }
}

ponderosa_pine_3_4in();
