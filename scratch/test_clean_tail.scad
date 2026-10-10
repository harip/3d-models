// ====================================================================
// Pure Supportless Tail Boom - Solid Fin, 0 Overhangs > 45 deg
// ====================================================================

$fn = 36;

module pure_supportless_tail_boom() {
    difference() {
        union() {
            // 1. Male Connector Plug (Bottom 100% flat at Z = 0!)
            hull() {
                translate([0.0, 0, 1.35])
                    cube([0.5, 2.7, 2.7], center = true);
                translate([3.2, 0, 1.35])
                    cube([0.5, 2.7, 2.7], center = true);
                // Tip chamfer (ONLY top and side taper, bottom stays flat on Z = 0)
                translate([3.8, 0, 1.0])
                    cube([0.2, 2.0, 2.0], center = true);
            }

            // Bulkhead stop flange (X = 0)
            hull() {
                translate([0, 0, 1.8])
                    cube([0.8, 4.4, 3.6], center = true);
                translate([-0.6, 0, 1.8])
                    cube([0.4, 4.4, 3.6], center = true);
            }

            // 2. Tail Boom Spine (Continuous flat bed runner on Z = 0)
            hull() {
                translate([0, 0, 1.8])
                    cube([1.0, 3.2, 3.6], center = true);
                translate([-10.0, 0, 1.2])
                    cube([1.0, 2.0, 2.4], center = true);
            }

            // 3. Horizontal Stabilizer Wing (100% grounded flat on Z = 0)
            hull() {
                translate([-10.0, 0, 0.6])
                    cube([2.6, 14.0, 1.2], center = true);
                translate([-10.8, 0, 0.4])
                    cube([1.0, 13.0, 0.8], center = true);
            }
            // Endplate fins (rise vertically from wings, bottom on Z = 0)
            for (sy = [-1, 1]) {
                hull() {
                    translate([-10.0, sy * 6.5, 1.4])
                        cube([2.4, 0.8, 2.8], center = true);
                    translate([-10.6, sy * 6.5, 1.0])
                        cube([1.2, 0.8, 2.0], center = true);
                }
            }

            // 4. Swept Vertical Stabilizer Fin (Solid fin, 90° vertical rise)
            // Leading edge swept back at 45° (self-supporting)
            // Trailing edge vertical (0° overhang)
            hull() {
                translate([-9.5, 0, 1.2])
                    cube([2.0, 1.2, 2.4], center = true);
                translate([-12.5, 0, 11.0])
                    cube([1.6, 1.0, 1.0], center = true);
                translate([-14.0, 0, 10.4])
                    cube([1.0, 1.0, 0.8], center = true);
                translate([-12.0, 0, 0.6])
                    cube([2.0, 1.2, 1.2], center = true);
            }
        }

        // Bed trim plane at Z = 0
        translate([0, 0, -5.0])
            cube([40, 40, 10], center = true);
    }
}

pure_supportless_tail_boom();
