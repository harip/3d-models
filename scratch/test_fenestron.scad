// ====================================================================
// Test Fenestron Ducted Fan with Overlapping CSG Stators
// ====================================================================

$fn = 36;

module tail_boom_with_fenestron() {
    difference() {
        union() {
            // Main structure with duct hole
            difference() {
                union() {
                    // Male Keyway Connector Plug (flat on Z = 0)
                    translate([2.0, 0, 1.4])
                        cube([4.0, 2.7, 2.7], center = true);
                    // Lead-in chamfer
                    translate([3.8, 0, 1.4])
                        rotate([0, 45, 0])
                            cube([0.8, 2.5, 2.5], center = true);

                    // Bulkhead stop flange (X = 0)
                    translate([0, 0, 1.8])
                        cube([1.0, 4.4, 3.6], center = true);

                    // Tail Boom Spine (Continuous flat bed runner on Z = 0)
                    hull() {
                        translate([0, 0, 0.1])
                            cube([1.0, 2.4, 0.2], center = true);
                        translate([0, 0, 2.2])
                            cube([1.0, 3.2, 1.8], center = true);
                        translate([-10.0, 0, 0.1])
                            cube([1.0, 1.8, 0.2], center = true);
                        translate([-10.0, 0, 1.8])
                            cube([1.0, 2.0, 1.4], center = true);
                    }

                    // Horizontal Stabilizer (Grounded 100% flat on Z = 0)
                    translate([-10.0, 0, 0]) {
                        hull() {
                            translate([0, 0, 0.6])
                                cube([2.6, 14.0, 1.2], center = true);
                            translate([-0.6, 0, 0.4])
                                cube([1.2, 14.0, 0.8], center = true);
                        }
                        // Endplate vertical fins (rise at 90°)
                        for (sy = [-1, 1]) {
                            translate([0, sy * 6.5, 1.4])
                                cube([2.4, 0.8, 2.6], center = true);
                        }
                    }

                    // Swept Vertical Stabilizer Fin (Rises vertically at 90° from Z = 0)
                    hull() {
                        translate([-9.5, 0, 1.8])
                            cube([2.0, 1.4, 1.2], center = true);
                        translate([-12.5, 0, 11.2])
                            cube([1.8, 1.2, 1.2], center = true);
                        translate([-14.2, 0, 10.6])
                            cube([1.2, 1.2, 0.8], center = true);
                        translate([-12.5, 0, 0.6])
                            cube([2.5, 1.4, 1.2], center = true);
                    }
                }

                // Fenestron through-hole
                translate([-12.5, 0, 7.5])
                    rotate([90, 0, 0])
                        cylinder(d = 4.4, h = 3.0, center = true);
            }

            // Ducted fan hub & stators
            translate([-12.5, 0, 7.5]) {
                rotate([90, 0, 0])
                    cylinder(d = 1.8, h = 1.0, center = true);
                for (a = [30, 90, 150]) {
                    rotate([0, a, 0])
                        cube([0.7, 0.8, 4.4], center = true);
                }
            }
        }

        // Bed trim plane at Z = 0
        translate([0, 0, -5.0])
            cube([40, 40, 10], center = true);
    }
}

tail_boom_with_fenestron();
