// ====================================================================
// Rustic Stone Arch Bridge (110mm Length with Visible Central Support Pier)
// Dimensions: Length 11.0 cm (110 mm), Uniform Width 2.0 cm (20 mm)
// Base Height: 0.25 cm (2.5 mm) at ends
// Smooth-Stoned Masonry Walls with Engraved Mortar Relief
// Integrated Visible Central Stone Support Pier
// 100% Supportless Manifold Solid for FDM 3D Printing (NoError)
// ====================================================================

$fn = 32;

length     = 110.0;  // 11.0 cm overall length
width      = 20.0;   // Uniform 2.0 cm width
base_h     = 2.5;    // 0.25 cm Base Height
max_h      = 22.0;   // Center Peak Height

arch_rx    = 26.0;   // Arch Semi-span
arch_rz    = 14.5;   // Arch Clearance Height
arch_z     = 0.5;    // Springing Z

module rustic_low_profile_bridge() {
    half_l = length / 2.0;
    union() {
        difference() {
            // Main Body & Parapets
            union() {
                hull() {
                    for (x = [-half_l : 2.0 : half_l]) {
                        norm_x = x / half_l;
                        z_deck = 18.0 - 15.5 * norm_x * norm_x;
                        translate([x, -width/2, 0])
                            cube([2.0, width, max(base_h, z_deck)]);
                    }
                }
                
                for (side_y = [-width/2, width/2 - 2.5]) {
                    hull() {
                        for (x = [-half_l : 2.0 : half_l]) {
                            norm_x = x / half_l;
                            z_deck = 18.0 - 15.5 * norm_x * norm_x;
                            translate([x, side_y, max(base_h, z_deck)])
                                cube([2.0, 2.5, 4.0]);
                        }
                    }
                }
            }

            // Arch Cutout
            translate([0, -width/2 - 1, arch_z])
                rotate([-90, 0, 0])
                    scale([1.0, arch_rz / arch_rx, 1.0])
                        cylinder(r = arch_rx, h = width + 2, $fn = 80);

            // Side Wall Engravings
            for (side_sign = [-1, 1]) {
                y_cut = side_sign * (width/2 + 0.05);
                for (x = [-half_l + 1.5 : 2.5 : half_l - 1.5]) {
                    norm_x = x / half_l;
                    
                    for (z = [1.5 : 2.2 : max_h]) {
                        translate([x, y_cut - side_sign * 0.35, z])
                            cube([2.6, 0.4, 0.35]);
                    }
                    
                    z_top = 18.0 - 15.5 * norm_x * norm_x;
                    in_arch = (abs(x) < arch_rx);
                    arch_clearance = in_arch ? (arch_z + (arch_rz * sqrt(max(0, 1 - (x/arch_rx)*(x/arch_rx)))) + 1.2) : 0;
                    
                    for (z_pos = [1.5 : 2.2 : max(base_h + 3.0, z_top)]) {
                        if (z_pos > arch_clearance) {
                            translate([x, y_cut - side_sign * 0.35, z_pos])
                                cube([0.35, 0.4, 2.2]);
                        }
                    }
                }

                for (a = [8 : 6 : 172]) {
                    rad_ang = a * 3.14159 / 180.0;
                    px = arch_rx * cos(rad_ang);
                    pz = arch_z + arch_rz * sin(rad_ang);
                    
                    nx = cos(rad_ang) / arch_rx;
                    nz = sin(rad_ang) / arch_rz;
                    tang_deg = atan2(nz, nx) - 90;
                    
                    translate([px, side_sign * (width/2 - 0.1), pz])
                        rotate([0, -tang_deg, 0])
                            translate([0, 0, 1.8])
                                cube([0.35, 0.4, 3.6], center = true);
                }
            }

            // Roadbed Cobblestones
            for (x = [-half_l + 4 : 3.2 : half_l - 4]) {
                norm_x = x / half_l;
                z_deck = 18.0 - 15.5 * norm_x * norm_x;
                for (y = [-width/2 + 3.2 : 3.2 : width/2 - 3.2]) {
                    translate([x + (y % 2 == 0 ? 0 : 1.2), y, max(base_h, z_deck) - 0.15])
                        rotate([0, 0, 35])
                            cube([1.8, 1.8, 0.35]);
                }
            }
        }

        // --- HEAVY VISIBLE CENTRAL SUPPORT PIER ---
        color([0.35, 0.35, 0.35])
            hull() {
                translate([-5.0, -width/2, 0.0]) cube([10.0, width, base_h]);
                translate([-2.5, -width/2, arch_z + arch_rz - 0.2]) cube([5.0, width, 0.5]);
            }
    }
}

rustic_low_profile_bridge();
