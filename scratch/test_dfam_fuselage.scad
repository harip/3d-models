// ====================================================================
// Modular Chopper Fuselage (3.5 cm Square Standard)
// Zero Floating Objects - 100% Supportless DFAM Architecture
//
// Engineering Specifications:
// - Part 01A: Modular Cabin Core (Flat Z=0 bed contact, 45° nose chamfer)
// - Part 01B: Modular Tail Boom & Empennage (Flat Z=0 bed contact)
// - Keyed 3.0mm registration joint with 0.3mm tolerance
// - Rotor mast: Vertical cylinder (90° Z), 3.6mm thrust collar, 2.2mm bore
// - Chassis sockets: Dual 2.2mm sockets (9.0mm pitch) for modular skids
// ====================================================================

$fn = 36;

module modular_cabin() {
    difference() {
        union() {
            // Main Cabin Body: 100% grounded at Z = 0, all slopes <= 45°
            hull() {
                // Flat bed contact footprint (Z = 0)
                translate([ 0.0, 0, 0.1])
                    cube([12.0, 7.6, 0.2], center = true);

                // Mid cabin shoulder (Z = 4.5)
                translate([ 0.0, 0, 4.5])
                    cube([12.0, 9.2, 0.2], center = true);

                // Nose tip (Z = 3.5, 45° chamfer from bed)
                translate([ 9.5, 0, 3.5])
                    cube([ 1.5, 5.0, 0.2], center = true);

                // Aft cabin bulkhead (Z = 4.0)
                translate([-6.0, 0, 4.0])
                    cube([ 1.0, 8.2, 0.2], center = true);
            }

            // Cockpit Windshield & Roof (45° backward rake)
            hull() {
                translate([ 0.0, 0, 4.5])
                    cube([12.0, 9.2, 0.2], center = true);
                translate([-1.0, 0, 7.8])
                    cube([ 8.0, 6.4, 0.2], center = true);
                translate([ 5.5, 0, 5.8])
                    cube([ 2.0, 5.2, 0.2], center = true);
            }

            // Top Turbine Housing
            hull() {
                translate([-1.0, 0, 7.8])
                    cube([ 8.0, 6.4, 0.2], center = true);
                translate([-1.5, 0, 9.2])
                    cube([ 6.5, 4.6, 0.2], center = true);
                translate([-5.8, 0, 8.4])
                    cube([ 1.5, 3.8, 0.2], center = true);
            }

            // Lower Side Sponsons: 45° chamfered flare grounded straight to Z = 0
            for (sy = [-1, 1]) {
                hull() {
                    translate([ 0.0, sy * 3.8, 0.1])
                        cube([8.0, 0.2, 0.2], center = true);
                    translate([ 0.0, sy * 5.2, 2.4])
                        cube([7.0, 0.4, 0.2], center = true);
                    translate([ 0.0, sy * 4.6, 4.0])
                        cube([7.0, 0.2, 0.2], center = true);
                }
            }

            // Rotor Mast Tower & Low-Friction Collar
            translate([0, 0, 9.2]) {
                cylinder(d = 4.2, h = 3.0, center = false);
                // Low-friction raised thrust face collar
                translate([0, 0, 3.0])
                    cylinder(d = 3.6, h = 0.5, center = false);
            }
        }

        // --- Cockpit Window Recesses (Subtle 0.6mm surface cuts) ---
        // Windshield
        translate([5.6, 0, 6.4])
            rotate([0, 35, 0])
                cube([1.2, 5.6, 3.2], center = true);
        // Chin windows
        translate([7.8, 0, 2.6])
            rotate([0, 45, 0])
                cube([1.0, 4.8, 1.8], center = true);
        // Side windows
        for (sy = [-1, 1]) {
            translate([0.5, sy * 4.4, 5.8])
                cube([4.8, 1.0, 2.2], center = true);
        }

        // --- Rotor Mast Center Bore ---
        translate([0, 0, 7.4])
            cylinder(d = 2.2, h = 6.0, center = false);
        // Snap-lock detent ring for pin barb
        translate([0, 0, 9.6])
            cylinder(d = 2.5, h = 0.8, center = false);
        // Top lead-in chamfer
        translate([0, 0, 12.3])
            cylinder(d1 = 2.2, d2 = 2.8, h = 0.5, center = false);

        // --- Underside Modular Chassis Sockets ---
        for (sx = [-4.5, 4.5]) {
            translate([sx, 0, -0.1]) {
                cylinder(d = 2.2, h = 2.8, center = false);
                cylinder(d1 = 2.6, d2 = 2.2, h = 0.6, center = false);
            }
        }

        // --- Rear Tail Boom Keyway Receiver Socket ---
        translate([-6.5 - 0.1, 0, 3.6]) {
            // Keyway socket (3.2mm x 3.2mm x 4.0mm deep)
            cube([4.2, 3.2, 3.2], center = true);
            // 45° lead-in chamfer
            translate([-1.8, 0, 0])
                rotate([0, 45, 0])
                    cube([1.2, 3.6, 3.6], center = true);
        }

        // Flat bed cut plane at Z = 0
        translate([0, 0, -5.0])
            cube([40, 40, 10], center = true);
    }
}

module modular_tail_boom() {
    difference() {
        union() {
            // 1. Male Keyway Connector Plug (enters cabin socket)
            // Positioned at X = -6.5 forward to X = -2.8
            translate([-4.7, 0, 3.6])
                cube([3.6, 2.8, 2.8], center = true);
            // Plug lead-in chamfer
            translate([-2.8, 0, 3.6])
                rotate([0, 45, 0])
                    cube([0.8, 2.6, 2.6], center = true);

            // Plug base collar / bulkhead (X = -6.5)
            translate([-7.0, 0, 3.6])
                cube([1.0, 5.0, 4.4], center = true);

            // 2. Tail Boom Body (Flat runner at Z = 0, chamfered sides)
            hull() {
                // Front root at X = -7.0
                translate([-7.0, 0, 0.1])
                    cube([1.0, 2.4, 0.2], center = true);
                translate([-7.0, 0, 3.6])
                    cube([1.0, 3.4, 2.4], center = true);

                // Aft boom at X = -17.0
                translate([-17.0, 0, 0.1])
                    cube([1.0, 1.8, 0.2], center = true);
                translate([-17.0, 0, 2.4])
                    cube([1.0, 2.0, 1.6], center = true);
            }

            // 3. Horizontal Stabilizer (Grounded flat at Z = 0!)
            translate([-17.0, 0, 0]) {
                hull() {
                    translate([0, 0, 0.6])
                        cube([2.8, 14.0, 1.2], center = true);
                    translate([-0.8, 0, 0.4])
                        cube([1.4, 14.0, 0.8], center = true);
                }
                // Endplate vertical fins (rise at 90°)
                for (sy = [-1, 1]) {
                    translate([0, sy * 6.6, 1.5])
                        cube([2.6, 0.8, 3.0], center = true);
                }
            }

            // 4. Swept Vertical Stabilizer Fin (Rises vertically at 90° from Z = 0)
            hull() {
                translate([-17.0, 0, 2.4])
                    cube([2.0, 1.2, 1.0], center = true);
                translate([-19.5, 0, 11.0])
                    cube([1.4, 1.0, 1.0], center = true);
                translate([-21.0, 0, 10.5])
                    cube([1.0, 1.0, 0.8], center = true);
                translate([-19.0, 0, 0.6])
                    cube([2.0, 1.2, 1.2], center = true);
            }

            // Port-side Tail Rotor (flat 45° beveled detail, grounded on fin face)
            translate([-19.2, 0.6 + 0.3, 8.5]) {
                rotate([90, 0, 0]) {
                    cylinder(d = 2.0, h = 0.6, center = true);
                    rotate([0, 0, 35])
                        cube([0.8, 6.5, 0.5], center = true);
                }
            }
        }

        // Bed trim plane at Z = 0
        translate([0, 0, -5.0])
            cube([60, 40, 10], center = true);
    }
}
