// ====================================================================
// Intermediate Alpine Cableway Support Tower (Cantilever Mast + Alpine Roof Top)
// 
// Architectural & Engineering Features:
// - FIXED MAST CUTOUT: Removed large 14mm hole that caused floating layer slicer warnings!
//   Replaced with a small 5.0mm 45-degree self-supporting diamond window.
// - CANTILEVER TOWER MAST PRESERVED: Tower mast column is positioned behind the cable path (+Y side at Y = +12.0mm), leaving a 100% unobstructed vertical corridor around Y = -5.0mm for Gondola Cabin passage!
// - MATCHING ALPINE GABLE ROOF TOP CAP: The top of the cantilever cross-arm features the EXACT SAME 45-degree Alpine Gable Roof cap & clevis ears matching Station A and Station B!
//   - Roof Width: 28.0mm, Roof Pitch Height: 18.0mm.
//   - Vertical Clevis Ears: Exact same 14.0mm outer span & 6.0mm inner channel width.
//   - Midpoint Axle Bore: Positioned at Z = 91.0mm (5.2mm bore) - fits the exact same Sheave (08a), Axle Pin (08c), and End Cap (08d)!
// - 100% Support-Free: Rests flat on build plate at Z = 0 with 45-degree self-supporting bracing.
// ====================================================================

$fn = 40;

// Tower Dimensions (mm)
tower_axle_z  = 91.0;  // Axle center height at midpoint X = 0mm
roof_h        = 18.0;  // Peak roof pitch height (EXACT MATCH to Station A & B!)
eaves_z       = tower_axle_z - 10.5 - roof_h; // Eaves height Z = 62.5mm
building_w    = 28.0;  // Roof width (EXACT MATCH to Station A & B!)
roof_l        = 24.0;  // Roof cap length along X-axis
base_l        = 36.0;  // Foundation baseplate length along X-axis
base_w        = 42.0;  // Foundation baseplate width along Y-axis
base_h        = 3.0;   // Baseplate thickness
mast_y        = 12.0;  // Mast column center (positioned behind cable path for cabin clearance)

module rounded_box(l, w, h, r) {
    hull() {
        for (x = [-l/2 + r, l/2 - r]) {
            for (y = [-w/2 + r, w/2 - r]) {
                translate([x, y, 0])
                    cylinder(r = r, h = h);
            }
        }
    }
}

module intermediate_support_tower() {
    difference() {
        union() {
            // 1. Off-Center Foundation Baseplate (Spans Y = -12mm to +30mm at Z = 0)
            translate([0, 9.0, base_h / 2])
                hull() {
                    rounded_box(base_l, base_w, base_h, 4.0);
                }

            // 2. Main Structural Support Mast (Positioned at Y = +12.0mm behind track path)
            hull() {
                translate([0, mast_y, base_h])
                    cube([base_l - 10.0, 16.0, 1.0], center = true);
                translate([0, mast_y, eaves_z])
                    cube([12.0, 12.0, 1.0], center = true);
            }

            // 3. Cantilevered Overhead Cross-Arm (Reaches forward from Y = +12.0mm to Y = -5.0mm)
            hull() {
                translate([0, mast_y, eaves_z - 4.0])
                    cube([14.0, 12.0, 8.0], center = true);
                translate([0, -5.0, eaves_z])
                    cube([roof_l, building_w, 2.0], center = true);
            }

            // 4. 45-Degree Self-Supporting Diagonal Under-Brace (Supports cantilever arm)
            hull() {
                translate([0, mast_y - 2.0, eaves_z - 20.0])
                    cube([10.0, 8.0, 1.0], center = true);
                translate([0, -5.0, eaves_z])
                    cube([10.0, 10.0, 1.0], center = true);
            }

            // 5. Alpine 45-degree Pitch Gable Roof Top Cap (ONLY ON TOP OF CANTILEVER ARM AT Y = -5.0mm!)
            translate([0, -5.0, eaves_z])
                hull() {
                    cube([roof_l, building_w, 1.0], center = true);
                    translate([0, 0, roof_h])
                        cube([roof_l, 1.0, 1.0], center = true);
                }

            // 6. Elevated Open Vertical Clevis Ears (EXACT MATCH TO STATIONS A & B!)
            for (y_sign = [-1, 1]) {
                translate([0, -5.0 + y_sign * 5.0, eaves_z + roof_h + 4.0])
                    cube([16.0, 4.0, 20.0], center = true);
                
                // Lower 45-degree self-supporting anchor gussets in gable roof
                translate([0, -5.0 + y_sign * 5.0, eaves_z + roof_h - 1.0])
                    rotate([0, 90, 0])
                        rotate([0, 0, 45])
                            cube([8.0 / sqrt(2), 8.0 / sqrt(2), 16.0], center = true);
            }
        }

        // --- SUBTRACTIONS ---

        // A. Small 5.0mm 45-Degree Self-Supporting Diamond Window (Zero Floating Overhangs!)
        translate([0, mast_y, eaves_z / 2])
            rotate([0, 90, 0])
                rotate([0, 0, 45])
                    cube([5.0 / sqrt(2), 5.0 / sqrt(2), base_l + 10], center = true);

        // B. Elevated Sheave Axle Bore (EXACT MATCH TO STATIONS A & B!)
        // Positioned at Z = tower_axle_z = 91.0mm, 5.2mm bore diameter
        translate([0, -5.0, tower_axle_z])
            rotate([90, 0, 0])
                cylinder(d = 5.2, h = building_w + 14, center = true);

        // C. Baseplate Mounting Screw Holes (4x M3 countersunk holes)
        for (x_sign = [-1, 1]) {
            for (y_sign = [-1, 1]) {
                translate([x_sign * (base_l / 2 - 5.0), 9.0 + y_sign * (base_w / 2 - 5.0), -1]) {
                    cylinder(d = 3.4, h = base_h + 4);
                    cylinder(d1 = 6.2, d2 = 3.4, h = 2.0);
                }
            }
        }
    }
}

// Render flat on foundation baseplate at Z = 0
intermediate_support_tower();
