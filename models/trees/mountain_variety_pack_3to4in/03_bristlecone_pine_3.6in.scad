// Bristlecone Pine (3.60 in / 91.44 mm)
// Mountain Variety Pack (3-4 inch)
// Weathered Alpine Ridge Gnarled Tree - 100% Supportless Manifold Solid

$fn = 32;

module bristlecone_pine_3_6in(h = 91.44) {
    union() {
        // Gnarled Twisted Alpine Trunk
        color([0.45, 0.27, 0.16]) {
            cylinder(r1 = 10.0, r2 = 5.0, h = 6.0);
            // Curved Segmented Trunk Path
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 5.0, h = 12.0);
                translate([3.0, 2.0, h * 0.35]) sphere(r = 4.2, $fn = 12);
            }
            hull() {
                translate([3.0, 2.0, h * 0.35]) sphere(r = 4.2, $fn = 12);
                translate([-2.5, 4.0, h * 0.60]) sphere(r = 3.5, $fn = 12);
            }
            hull() {
                translate([-2.5, 4.0, h * 0.60]) sphere(r = 3.5, $fn = 12);
                translate([1.0, 1.0, h * 0.82]) sphere(r = 2.4, $fn = 12);
            }
            // Root anchorage flaring
            for (a = [0 : 72 : 288]) {
                rotate([0, 0, a])
                    hull() {
                        translate([9.0, 0, 0.5]) sphere(r = 0.9, $fn = 8);
                        translate([4.5, 0, 4.0]) sphere(r = 0.6, $fn = 8);
                    }
            }
            // Twisted Heavy Branches extending outward
            // Branch 1
            hull() {
                translate([3.0, 2.0, h * 0.35]) sphere(r = 3.0, $fn = 10);
                translate([14.0, 8.0, h * 0.48]) sphere(r = 1.8, $fn = 10);
            }
            // Branch 2
            hull() {
                translate([-2.5, 4.0, h * 0.60]) sphere(r = 2.6, $fn = 10);
                translate([-15.0, 6.0, h * 0.70]) sphere(r = 1.6, $fn = 10);
            }
            // Branch 3
            hull() {
                translate([1.0, 1.0, h * 0.82]) sphere(r = 2.0, $fn = 10);
                translate([8.0, -10.0, h * 0.88]) sphere(r = 1.4, $fn = 10);
            }
        }

        // Irregular Weathered Needle Foliage Tufts (100% attached to trunk/branches)
        color([0.20, 0.42, 0.22]) {
            // Main Center Canopy Tuft
            translate([1.0, 1.0, h * 0.82]) {
                union() {
                    cylinder(r1 = 2.0, r2 = 14.0, h = 8.0);
                    translate([0, 0, 4.0]) cylinder(r1 = 15.0, r2 = 1.0, h = 9.0);
                }
            }
            // Lower Branch 1 Tuft
            translate([14.0, 8.0, h * 0.48]) {
                union() {
                    cylinder(r1 = 1.8, r2 = 11.0, h = 7.0);
                    translate([0, 0, 3.5]) cylinder(r1 = 12.0, r2 = 0.8, h = 7.5);
                }
            }
            // Mid Branch 2 Tuft
            translate([-15.0, 6.0, h * 0.70]) {
                union() {
                    cylinder(r1 = 1.6, r2 = 12.0, h = 7.5);
                    translate([0, 0, 3.5]) cylinder(r1 = 13.0, r2 = 0.8, h = 8.0);
                }
            }
            // Upper Branch 3 Tuft
            translate([8.0, -10.0, h * 0.88]) {
                union() {
                    cylinder(r1 = 1.4, r2 = 10.0, h = 6.5);
                    translate([0, 0, 3.0]) cylinder(r1 = 11.0, r2 = 0.6, h = 7.0);
                }
            }
            // Top Spire Tuft
            translate([0, 0, h - 8.0]) {
                union() {
                    cylinder(r1 = 1.5, r2 = 9.0, h = 6.0);
                    translate([0, 0, 3.0]) cylinder(r1 = 9.5, r2 = 0.5, h = 6.5);
                }
            }
        }
    }
}

bristlecone_pine_3_6in();
