// ====================================================================
// Modular Rotatable Chopper Rotor (34mm Swept Diameter)
// Fits within standard 35mm x 35mm (3.5 cm) square bounding box.
//
// Engineering Specifications:
// - Swept Diameter: 34.0 mm (Radius: 17.0 mm)
// - Hub Diameter: 6.2 mm, Hub Height: 2.2 mm
// - Axle Bore: 2.8 mm through-hole (for 2.4 mm pin -> 0.4mm clearance)
// - Low-friction underside relief pocket (reduces bearing drag)
// - Aerodynamic blade profile with reinforced root cuffs
// - 100% supportless flat print at Z = 0
// - Configurable blade count (2-blade standard or 3-blade heavy lift)
// ====================================================================

$fn = 48;

blade_count = 2; // 2 for high-speed scout, 3 for heavy-lift

module rotor_blade(r = 17.0) {
    hull() {
        // Root cuff near hub
        translate([2.6, 0, 0])
            cylinder(r = 1.6, h = 1.4, center = false);
        // Mid span
        translate([9.0, 0, 0])
            cylinder(r = 1.5, h = 1.2, center = false);
    }
    hull() {
        // Mid span
        translate([9.0, 0, 0])
            cylinder(r = 1.5, h = 1.2, center = false);
        // Blade tip (swept taper)
        translate([r - 0.8, -0.2, 0])
            cylinder(r = 1.1, h = 1.0, center = false);
    }
    // Trailing edge airfoil taper
    hull() {
        translate([4.0, -1.8, 0])
            cube([r - 6.0, 0.4, 0.9]);
        translate([4.0, 0, 0])
            cube([r - 6.0, 1.2, 1.1]);
    }
}

module rotatable_rotor(blades = 2, bore_d = 2.8) {
    hub_r = 3.1;
    hub_h = 2.2;
    angle_step = 360 / blades;

    difference() {
        union() {
            // Central Hub
            cylinder(r = hub_r, h = hub_h, center = false);

            // Hub top bevel ring
            translate([0, 0, hub_h - 0.4])
                cylinder(r1 = hub_r, r2 = hub_r - 0.4, h = 0.4, center = false);

            // Blades
            for (i = [0 : blades - 1]) {
                rotate([0, 0, i * angle_step])
                    rotor_blade(17.0);
            }

            // Pitch control hinge details
            for (i = [0 : blades - 1]) {
                rotate([0, 0, i * angle_step])
                    translate([2.4, 1.4, 0])
                        cylinder(r = 0.6, h = 1.6, center = false);
            }
        }

        // Center axle bore for rotatable pin (clearance gap for smooth spinning)
        translate([0, 0, -0.1])
            cylinder(d = bore_d, h = hub_h + 0.2, center = false);

        // Underside low-friction bearing recess
        // Relieves inner surface so only outer rim contacts the mast collar
        translate([0, 0, -0.05])
            cylinder(d = 4.4, h = 0.4, center = false);

        // Top chamfer on bore for easy pin insertion
        translate([0, 0, hub_h - 0.3])
            cylinder(r1 = bore_d/2, r2 = bore_d/2 + 0.4, h = 0.4, center = false);
    }
}

// Default standalone render (2-blade rotor flat on print bed)
translate([0, 0, 0])
    rotatable_rotor(blades = blade_count, bore_d = 2.8);
