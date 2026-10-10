// Colorado Blue Spruce (4.00 in / 101.60 mm)
// Mountain Variety Pack (3-4 inch)
// 100% Supportless Single Manifold Solid

$fn = 32;

module colorado_blue_spruce_4_0in(h = 101.6) {
    union() {
        // Flared Base & Trunk
        color([0.38, 0.24, 0.14]) {
            cylinder(r1 = 9.5, r2 = 4.5, h = 6.0);
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 4.5, h = h * 0.25);
                translate([0, 0, h * 0.85]) cylinder(r1 = 3.0, r2 = 1.2, h = 5.0);
            }
            // Root Buttresses
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([8.8, 0, 0.5]) sphere(r = 0.8, $fn = 8);
                        translate([4.0, 0, 4.0]) sphere(r = 0.5, $fn = 8);
                    }
            }
        }
        // Slate Blue-Green Tiered Needle Branches
        color([0.22, 0.46, 0.44]) {
            for (t = [0 : 8]) {
                tz = h * (0.18 + t * 0.09);
                r_b = 28.0 * (1 - t / 9.2);
                r_t = r_b * 0.58;
                th = 13.5 * (1 - t / 11.0);
                translate([0, 0, tz]) {
                    union() {
                        // Central Core Cone overlapping trunk
                        translate([0, 0, -th * 0.15])
                            cylinder(r1 = r_b * 0.65, r2 = r_t * 0.85, h = th * 1.15);
                        // Radiant Layered Boughs
                        for (i = [0 : 7]) {
                            rotate([0, 0, i * 45 + t * 21]) {
                                rotate([14, 0, 0]) {
                                    hull() {
                                        translate([0, 0, th * 0.55]) scale([1.2, 0.8, 0.8]) sphere(r = r_t * 0.45, $fn = 10);
                                        translate([0, r_b * 0.88, -th * 0.10]) scale([1.4, 0.6, 0.6]) sphere(r = r_b * 0.18, $fn = 10);
                                    }
                                    for (k = [-2 : 2]) {
                                        rotate([0, 0, k * 12])
                                            translate([0, r_b * 0.92, -th * 0.16])
                                                rotate([32, 0, 0])
                                                    cylinder(r1 = r_b * 0.11, r2 = 0.3, h = th * 0.48, $fn = 6);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // Top Leader Spire
            translate([0, 0, h - 11.0])
                cylinder(r1 = 2.2, r2 = 0.4, h = 11.0);
        }
    }
}

colorado_blue_spruce_4_0in();
