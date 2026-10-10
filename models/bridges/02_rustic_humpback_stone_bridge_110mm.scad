// ====================================================================
// Rustic Stone Arch Bridge (Low-Profile Arch Model)
// Dimensions: Length 7.6 cm (76 mm), Uniform Width 2.0 cm (20 mm)
// Base Height: 0.25 cm (2.5 mm) at ends
// Reduced Arch Height: 0.95 cm (9.5 mm clearance)
// Max Peak Height: 1.6 cm (16.0 mm) at center
// Smooth-Stoned Masonry Walls with Engraved Mortar Relief (ZERO Protrusions)
// 100% Supportless Manifold Solid for FDM 3D Printing
// ====================================================================

$fn = 32;

length     = 76.0;   // 7.6 cm overall length
width      = 20.0;   // Uniform 2.0 cm width
base_h     = 2.5;    // 0.25 cm Base Height
max_h      = 16.0;   // Reduced Peak Height (1.6 cm)

arch_rx    = 26.0;   // Arch Semi-span
arch_rz    = 9.5;    // Reduced Arch Clearance Height (0.95 cm)
arch_z     = 0.5;    // Springing Z

module rustic_low_profile_bridge() {
    difference() {
        // --- 1. MAIN UNIFIED SOLID BODY & RAILINGS ---
        union() {
            // Main Humpback Body (Deck sweeps from 2.5mm base to 13mm deck peak in center)
            hull() {
                for (x = [-38 : 2.0 : 38]) {
                    norm_x = x / 38.0;
                    z_deck = 13.0 - 10.5 * norm_x * norm_x;
                    translate([x, -width/2, 0])
                        cube([2.0, width, max(base_h, z_deck)]);
                }
            }
            
            // Side Parapet Railings (Peak Z = 16mm)
            for (side_y = [-width/2, width/2 - 2.5]) {
                hull() {
                    for (x = [-38 : 2.0 : 38]) {
                        norm_x = x / 38.0;
                        z_deck = 13.0 - 10.5 * norm_x * norm_x;
                        translate([x, side_y, max(base_h, z_deck)])
                            cube([2.0, 2.5, 3.0]); // Railing height = 3.0mm
                    }
                }
            }
        }

        // --- 2. REDUCED-HEIGHT ARCH VAULT CUTOUT ---
        translate([0, -width/2 - 1, arch_z])
            rotate([-90, 0, 0])
                scale([1.0, arch_rz / arch_rx, 1.0])
                    cylinder(r = arch_rx, h = width + 2, $fn = 80);

        // --- 3. RECESSED MASONRY ENGRAVING ON SIDE FACADES ---
        for (side_sign = [-1, 1]) {
            y_cut = side_sign * (width/2 + 0.05);
            for (x = [-length/2 + 1.5 : 2.5 : length/2 - 1.5]) {
                norm_x = x / 38.0;
                
                // Horizontal Mortar Cuts
                for (z = [1.5 : 1.8 : max_h]) {
                    translate([x, y_cut - side_sign * 0.35, z])
                        cube([2.6, 0.4, 0.3]);
                }
                
                // Vertical Mortar Cuts
                z_top = 13.0 - 10.5 * norm_x * norm_x;
                in_arch = (abs(x) < arch_rx);
                arch_clearance = in_arch ? (arch_z + (arch_rz * sqrt(max(0, 1 - (x/arch_rx)*(x/arch_rx)))) + 1.1) : 0;
                
                for (z_pos = [1.5 : 1.8 : max(base_h + 2.5, z_top)]) {
                    if (z_pos > arch_clearance) {
                        translate([x, y_cut - side_sign * 0.35, z_pos])
                            cube([0.35, 0.4, 1.8]);
                    }
                }
            }

            // Engraved Radial Voussoir Joints along Arch Ring
            for (a = [8 : 6 : 172]) {
                rad_ang = a * 3.14159 / 180.0;
                px = arch_rx * cos(rad_ang);
                pz = arch_z + arch_rz * sin(rad_ang);
                
                nx = cos(rad_ang) / arch_rx;
                nz = sin(rad_ang) / arch_rz;
                tang_deg = atan2(nz, nx) - 90;
                
                translate([px, side_sign * (width/2 - 0.1), pz])
                    rotate([0, -tang_deg, 0])
                        translate([0, 0, 1.4])
                            cube([0.35, 0.4, 2.8], center = true);
            }
        }

        // --- 4. ENGRAVED COBBLESTONE ROADBED DECK TEXTURE ---
        for (x = [-35 : 3.2 : 35]) {
            norm_x = x / 38.0;
            z_deck = 13.0 - 10.5 * norm_x * norm_x;
            for (y = [-width/2 + 3.2 : 3.2 : width/2 - 3.2]) {
                translate([x + (y % 2 == 0 ? 0 : 1.2), y, max(base_h, z_deck) - 0.15])
                    rotate([0, 0, 35])
                        cube([1.8, 1.8, 0.35]);
            }
        }
    }
}

rustic_low_profile_bridge();
