// Ponderosa Pine (3.40 in / 86.36 mm)
// Mountain Variety Pack (3-4 inch)
// High Canopy Clear Trunk - 100% Supportless Manifold Solid

$fn = 32;

module ponderosa_pine_3_4in(h = 86.36) {
    union() {
        // High Clear Trunk with Thick Bark Plates
        color([0.48, 0.28, 0.15]) {
            cylinder(r1 = 9.0, r2 = 4.2, h = 5.5);
            hull() {
                translate([0, 0, 4.5]) cylinder(r1 = 4.2, r2 = 2.8, h = h * 0.55);
                translate([0, 0, h * 0.85]) cylinder(r1 = 2.8, r2 = 1.1, h = 5.0);
            }
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([8.0, 0, 0.5]) sphere(r = 0.7, $fn = 8);
                        translate([3.8, 0, 3.5]) sphere(r = 0.5, $fn = 8);
                    }
            }
            // Upper branch forks supporting canopy
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba]) {
                    hull() {
                        translate([0, 0, h * 0.55]) sphere(r = 2.2, $fn = 8);
                        translate([0, 14.0, h * 0.72]) sphere(r = 1.3, $fn = 8);
                    }
                }
            }
        }
        // Dense Tufted Needle Rosettes (Upper Half Canopy)
        color([0.18, 0.44, 0.20]) {
            // Lower canopy tufts
            for (ba = [0, 90, 180, 270]) {
                rotate([0, 0, ba]) {
                    translate([0, 14.0, h * 0.72]) {
                        union() {
                            cylinder(r1 = 1.3, r2 = 9.0, h = 7.5);
                            translate([0, 0, 3.5]) cylinder(r1 = 9.5, r2 = 0.6, h = 7.0);
                        }
                    }
                }
            }
            // Upper canopy tufts
            for (ba = [45, 135, 225, 315]) {
                rotate([0, 0, ba]) {
                    translate([0, 9.5, h * 0.82]) {
                        union() {
                            cylinder(r1 = 1.1, r2 = 7.5, h = 6.5);
                            translate([0, 0, 3.0]) cylinder(r1 = 8.0, r2 = 0.5, h = 6.0);
                        }
                    }
                }
            }
            // Top crown tuft
            translate([0, 0, h - 9.5]) {
                union() {
                    cylinder(r1 = 1.5, r2 = 7.0, h = 6.5);
                    translate([0, 0, 3.0]) cylinder(r1 = 7.5, r2 = 0.4, h = 6.5);
                }
            }
        }
    }
}

ponderosa_pine_3_4in();
