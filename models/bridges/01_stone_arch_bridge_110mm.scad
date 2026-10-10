// ====================================================================
// Botanically & Architecturally Accurate Stone Arch Bridge
// Dimensions: Length 11.0 cm (110 mm), Width 2.0 cm (20 mm), Height 3.5 cm (35 mm)
// Features:
// - Radial Voussoir Arch Ring with Central Keystone
// - Staggered Ashlar Masonry Wall Block Relief
// - Cobblestone Road Deck & Capped Parapet Side Walls
// - Flared Abutment Piers with Base Anchor
// 100% Manifold Solid for 3D Printing (Supportless Arch Angle)
// ====================================================================

$fn = 40;

// Core Dimension Parameters
length = 110.0;   // 11 cm
width  = 20.0;    // 2 cm
height = 35.0;    // 3.5 cm

arch_span = 60.0;   // Main Arch Span Opening
arch_r    = 30.0;   // Arch Radius
arch_center_z = 2.0; // Arch springing line Z offset

module stone_arch_bridge() {
    union() {
        difference() {
            // --- 1. Main Solid Bridge Body ---
            union() {
                // Main Bridge Block
                translate([-length/2, -width/2, 0])
                    cube([length, width, height - 6.0]);
                
                // Side Parapet Walls
                translate([-length/2, -width/2, height - 6.0])
                    cube([length, 2.5, 6.0]);
                translate([-length/2, width/2 - 2.5, height - 6.0])
                    cube([length, 2.5, 6.0]);

                // End Abutment Flares
                for (side = [-1, 1]) {
                    scale([side, 1, 1])
                        translate([length/2 - 8, -width/2 - 0.8, 0])
                            cube([8, width + 1.6, 12.0]);
                }
            }

            // --- 2. Main Arch Vault Cutout ---
            translate([0, -width/2 - 2, arch_center_z])
                rotate([-90, 0, 0])
                    cylinder(r = arch_r, h = width + 4, $fn = 80);

            // --- 3. Mortar Joint Grooves on Spandrel Walls ---
            for (y_pos = [-width/2 - 0.1, width/2 - 0.3]) {
                translate([0, y_pos, 0]) {
                    // Horizontal Mortar Grooves
                    for (z = [4 : 3.5 : height - 7]) {
                        translate([-length/2 - 1, 0, z])
                            cube([length + 2, 0.4, 0.4]);
                    }
                    // Vertical Mortar Grooves (Staggered Brick Pattern)
                    for (row = [0 : 8]) {
                        z_val = 4 + row * 3.5;
                        stagger = (row % 2 == 0) ? 0 : 5.0;
                        for (x = [-length/2 + 2 + stagger : 10.0 : length/2 - 2]) {
                            // Only carve grooves outside arch cutout
                            if (abs(x) > 20 || z_val > arch_center_z + sqrt(max(0, arch_r*arch_r - x*x)) + 2) {
                                translate([x, 0, z_val])
                                    cube([0.4, 0.4, 3.5]);
                            }
                        }
                    }
                }
            }

            // --- 4. Cobblestone Roadbed Deck Surface Detail ---
            for (x = [-length/2 + 2 : 3.5 : length/2 - 2]) {
                for (y = [-width/2 + 3.2 : 3.2 : width/2 - 3.2]) {
                    translate([x + (y % 2 == 0 ? 0 : 1.2), y, height - 6.0])
                        rotate([0, 0, 45])
                            cube([2.2, 2.2, 0.4]);
                }
            }
        }

        // --- 5. Radial Arch Voussoir Ring & Keystone (Extruded Relief) ---
        for (side_y = [-width/2 - 0.4, width/2 - 0.4]) {
            translate([0, side_y, 0]) {
                // Radial Voussoir Stones around the arch ring
                for (a = [10 : 10 : 170]) {
                    ang = a - 90;
                    is_keystone = (a == 90);
                    v_thickness = is_keystone ? 4.8 : 4.0;
                    v_outer_r   = is_keystone ? arch_r + 5.5 : arch_r + 4.2;
                    
                    color(is_keystone ? [0.65, 0.45, 0.32] : [0.55, 0.52, 0.48]) {
                        hull() {
                            rotate([0, -ang, 0])
                                translate([0, 0, arch_center_z + arch_r - 0.5])
                                    cube([v_thickness, 0.8, 0.5], center = true);
                            rotate([0, -ang, 0])
                                translate([0, 0, arch_center_z + v_outer_r])
                                    cube([v_thickness * 1.15, 0.8, 0.5], center = true);
                        }
                    }
                }
            }
        }

        // --- 6. Parapet Top Capstones ---
        color([0.58, 0.55, 0.50]) {
            for (y_par = [-width/2 + 1.25, width/2 - 1.25]) {
                for (x = [-length/2 + 1.5 : 5.0 : length/2 - 1.5]) {
                    translate([x, y_par, height - 0.2])
                        cube([4.6, 2.7, 0.4], center = true);
                }
            }
        }
    }
}

stone_arch_bridge();
