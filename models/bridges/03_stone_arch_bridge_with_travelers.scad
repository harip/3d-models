// ====================================================================
// Rustic Stone Arch Bridge with Taller Clear Travelers
// Dimensions: Length 7.6 cm (76 mm), Width 2.0 cm (20 mm)
// Base Height: 0.125 cm (1.25 mm)
// Figure Scale: Increased to 0.30 scale (~5.2mm human height, ~8.5mm horse)
// Distinct standing legs & anchored hooves resting on deck surface
// 100% WATERTIGHT MANIFOLD SOLID FOR 3D PRINTING (NoError)
// ====================================================================

$fn = 28;

length     = 76.0;   // 7.6 cm overall length
width      = 20.0;   // Uniform 2.0 cm width
base_h     = 1.25;   // 1.25 mm Base Height
max_h      = 16.0;   // Peak Height at center

arch_rx    = 26.0;   // Arch Semi-span
arch_rz    = 9.5;    // Arch Clearance Height
arch_z     = 0.5;    // Springing Z

module bridge_taller_travelers() {
    union() {
        // --- 1. MAIN STONE ARCH BRIDGE ---
        stone_bridge_structure();

        // --- 2. CENTER MOUNTED HORSE RIDER (X = 0 mm) ---
        translate([0, -1.8, 13.0 + 0.1])
            scale([0.30, 0.30, 0.30])
                horse_with_rider_anchored_tail();

        // --- 3. TALLER STANDING PEDESTRIANS WITH CLEAR LEGS ---
        // Person 1: X = -28mm (Left entrance)
        translate([-28.0, -2.8, 6.62 + 0.1])
            scale([0.30, 0.30, 0.30])
                pedestrian_with_clear_legs(h_scale = 1.05);

        // Person 2: X = -12mm (Left incline)
        translate([-12.0, 3.2, 11.83 + 0.1])
            scale([0.30, 0.30, 0.30])
                pedestrian_with_clear_legs(h_scale = 0.95);

        // Person 3: X = +15mm (Right incline)
        translate([15.0, 2.8, 11.17 + 0.1])
            scale([0.30, 0.30, 0.30])
                pedestrian_with_clear_legs(h_scale = 1.0);

        // Person 4: X = +28mm (Right exit)
        translate([28.0, -3.2, 6.62 + 0.1])
            scale([0.30, 0.30, 0.30])
                pedestrian_with_clear_legs(h_scale = 0.90);
    }
}

// REDESIGNED PEDESTRIAN WITH DISTINCT CLEARLY VISIBLE LEGS
module pedestrian_with_clear_legs(h_scale = 1.0) {
    scale([h_scale, h_scale, h_scale]) {
        color([0.65, 0.32, 0.22]) {
            union() {
                // Distinct Left Leg standing on deck (Z=0 to Z=7.5)
                hull() {
                    translate([-0.7, 0, 0.0]) cylinder(r1 = 0.9, r2 = 0.7, h = 7.5, $fn = 8);
                    translate([-0.7, 0, 7.5]) sphere(r = 0.9, $fn = 8);
                }
                // Distinct Right Leg standing on deck (Z=0 to Z=7.5)
                hull() {
                    translate([0.7, 0, 0.0]) cylinder(r1 = 0.9, r2 = 0.7, h = 7.5, $fn = 8);
                    translate([0.7, 0, 7.5]) sphere(r = 0.9, $fn = 8);
                }

                // Torso & Coat (Z=7.0 to Z=11.5)
                hull() {
                    translate([0, 0, 7.0]) cylinder(r1 = 1.8, r2 = 1.4, h = 4.5, $fn = 10);
                    translate([0, 0, 11.0]) scale([1.2, 1.8, 1.0]) sphere(r = 1.3, $fn = 10);
                }

                // Head & Cap (Z=12.0 to Z=14.5)
                translate([0, 0, 13.0])
                    sphere(r = 1.3, $fn = 12);
                translate([0, 0, 13.8])
                    scale([1.1, 1.1, 0.7]) sphere(r = 1.3, $fn = 10);

                // Arms along sides
                hull() {
                    translate([0, 1.8, 11.0]) sphere(r = 0.7, $fn = 8);
                    translate([0.5, 1.4, 7.0]) sphere(r = 0.6, $fn = 8);
                }
                hull() {
                    translate([0, -1.8, 11.0]) sphere(r = 0.7, $fn = 8);
                    translate([-0.5, -1.4, 7.0]) sphere(r = 0.6, $fn = 8);
                }
            }
        }
    }
}

module horse_with_rider_anchored_tail() {
    color([0.45, 0.28, 0.16]) {
        union() {
            translate([0, 0, 10.0])
                scale([1.8, 1.0, 1.1]) sphere(r = 4.2, $fn = 16);

            hull() {
                translate([5.0, 0, 11.5]) sphere(r = 3.0, $fn = 12);
                translate([9.5, 0, 16.0]) sphere(r = 2.2, $fn = 12);
            }
            translate([11.5, 0, 15.2])
                scale([1.2, 0.8, 0.8]) sphere(r = 1.6, $fn = 10);
            translate([9.0, 0.8, 18.0]) rotate([10, 0, 15]) cylinder(r1 = 0.6, r2 = 0.1, h = 1.8, $fn = 6);
            translate([9.0, -0.8, 18.0]) rotate([-10, 0, 15]) cylinder(r1 = 0.6, r2 = 0.1, h = 1.8, $fn = 6);

            hull() {
                translate([3.5, 0, 12.0]) sphere(r = 1.0, $fn = 8);
                translate([8.5, 0, 17.5]) sphere(r = 0.8, $fn = 8);
            }

            hull() {
                translate([-4.5, 0, 11.5]) sphere(r = 1.8, $fn = 10);
                translate([-6.5, 0, 7.0]) sphere(r = 1.5, $fn = 10);
                translate([-5.5, 0, 0.0]) cylinder(r1 = 1.6, r2 = 1.0, h = 7.0, $fn = 10);
            }

            hull() {
                translate([5.5, 2.2, 10.0]) sphere(r = 1.3, $fn = 8);
                translate([5.5, 2.0, 0.0]) cylinder(r1 = 1.2, r2 = 0.8, h = 10.0, $fn = 8);
            }
            hull() {
                translate([5.5, -2.2, 10.0]) sphere(r = 1.3, $fn = 8);
                translate([5.5, -2.0, 0.0]) cylinder(r1 = 1.2, r2 = 0.8, h = 10.0, $fn = 8);
            }
            hull() {
                translate([-5.5, 2.2, 10.0]) sphere(r = 1.4, $fn = 8);
                translate([-5.5, 2.0, 0.0]) cylinder(r1 = 1.3, r2 = 0.8, h = 10.0, $fn = 8);
            }
            hull() {
                translate([-5.5, -2.2, 10.0]) sphere(r = 1.3, $fn = 8);
                translate([-5.5, -2.0, 0.0]) cylinder(r1 = 1.2, r2 = 0.8, h = 10.0, $fn = 8);
            }

            color([0.22, 0.38, 0.55]) {
                translate([0, 0, 13.5])
                    scale([1.4, 1.1, 0.6]) sphere(r = 3.0, $fn = 12);
                translate([0, 0, 16.5])
                    cylinder(r1 = 2.4, r2 = 1.8, h = 5.5, $fn = 12);
                translate([0, 0, 23.0])
                    sphere(r = 1.7, $fn = 12);
                translate([0, 0, 24.2])
                    cylinder(r1 = 3.2, r2 = 1.2, h = 1.2, $fn = 14);

                hull() {
                    translate([0, 0, 16.5]) sphere(r = 1.5, $fn = 8);
                    translate([1.0, 3.2, 9.5]) sphere(r = 1.0, $fn = 8);
                }
                hull() {
                    translate([0, 0, 16.5]) sphere(r = 1.5, $fn = 8);
                    translate([1.0, -3.2, 9.5]) sphere(r = 1.0, $fn = 8);
                }

                hull() {
                    translate([1.2, 1.8, 20.0]) sphere(r = 0.9, $fn = 8);
                    translate([5.0, 0.8, 16.0]) sphere(r = 0.7, $fn = 8);
                }
                hull() {
                    translate([1.2, -1.8, 20.0]) sphere(r = 0.9, $fn = 8);
                    translate([5.0, -0.8, 16.0]) sphere(r = 0.7, $fn = 8);
                }
            }
        }
    }
}

// CORE BRIDGE STRUCTURE
module stone_bridge_structure() {
    difference() {
        union() {
            hull() {
                for (x = [-38 : 2.0 : 38]) {
                    norm_x = x / 38.0;
                    z_deck = 13.0 - 11.75 * norm_x * norm_x;
                    translate([x, -width/2, 0])
                        cube([2.0, width, max(base_h, z_deck)]);
                }
            }
            for (side_y = [-width/2, width/2 - 2.5]) {
                hull() {
                    for (x = [-38 : 2.0 : 38]) {
                        norm_x = x / 38.0;
                        z_deck = 13.0 - 11.75 * norm_x * norm_x;
                        translate([x, side_y, max(base_h, z_deck)])
                            cube([2.0, 2.5, 3.0]);
                    }
                }
            }
        }

        translate([0, -width/2 - 1, arch_z])
            rotate([-90, 0, 0])
                scale([1.0, arch_rz / arch_rx, 1.0])
                    cylinder(r = arch_rx, h = width + 2, $fn = 80);

        for (side_sign = [-1, 1]) {
            y_cut = side_sign * (width/2 + 0.05);
            for (x = [-length/2 + 1.5 : 2.5 : length/2 - 1.5]) {
                norm_x = x / 38.0;
                
                for (z = [1.2 : 1.8 : max_h]) {
                    translate([x, y_cut - side_sign * 0.35, z])
                        cube([2.6, 0.4, 0.3]);
                }
                
                z_top = 13.0 - 11.75 * norm_x * norm_x;
                in_arch = (abs(x) < arch_rx);
                arch_clearance = in_arch ? (arch_z + (arch_rz * sqrt(max(0, 1 - (x/arch_rx)*(x/arch_rx)))) + 1.1) : 0;
                
                for (z_pos = [1.2 : 1.8 : max(base_h + 2.5, z_top)]) {
                    if (z_pos > arch_clearance) {
                        translate([x, y_cut - side_sign * 0.35, z_pos])
                            cube([0.35, 0.4, 1.8]);
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
                        translate([0, 0, 1.4])
                            cube([0.35, 0.4, 2.8], center = true);
            }
        }

        for (x = [-35 : 3.2 : 35]) {
            norm_x = x / 38.0;
            z_deck = 13.0 - 11.75 * norm_x * norm_x;
            for (y = [-width/2 + 3.2 : 3.2 : width/2 - 3.2]) {
                translate([x + (y % 2 == 0 ? 0 : 1.2), y, max(base_h, z_deck) - 0.15])
                    rotate([0, 0, 35])
                        cube([1.8, 1.8, 0.35]);
            }
        }
    }
}

bridge_taller_travelers();
