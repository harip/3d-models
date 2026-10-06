// ====================================================================
// Alpine Gondola Mountain Summit Station Chalet (Station B - Top Station)
// 
// Architectural & Engineering Features:
// - Shorter Compact Baseplate: Baseplate footprint shortened to 42mm x 36mm!
// - Rocks Removed on Longer Sides: Clean, streamlined mountain base without clutter!
// - Open-Ended Drive-Through Alpine Canopy: Front (+X) and back (-X) walls open for gondola passage.
// - Solid Side Support Walls: Rigid +Y and -Y side walls supporting the alpine gable roof overhead.
// - ROOFING & CLEVIS EXACT MATCH TO GROUND STATION (Station A):
//   - Main Roof Pitch: 45-degree Alpine Gable Roof (Width = 28.0mm, Eaves = 30.0mm, Peak = 18.0mm).
//   - Elevated Vertical Clevis Ears: Exact same 14.0mm outer span & 6.0mm channel width.
//   - Axle Bore: Positioned at Z = 61.0mm (5.2mm bore) - fits the exact same Sheave (08a), Axle Pin (08c), and End Cap (08d)!
// - 100% Support-Free: Rests flat on summit baseplate at Z = 0.
// ====================================================================

$fn = 40;

// Compact Summit Building Dimensions (mm)
building_l  = 32.0;  // Summit length along X-axis
building_w  = 28.0;  // Main Boarding Hall Width (EXACT MATCH to Station A!)
eaves_h     = 30.0;  // Wall height to main roof eaves (EXACT MATCH!)
roof_h      = 18.0;  // Peak main roof height above eaves (EXACT MATCH! Total H = 48mm)
wall_th     = 2.4;   // Side wall thickness

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

module station_b_mountain_building() {
    difference() {
        union() {
            // 1. Shorter & Compact Summit Baseplate (42mm x 36mm Footprint)
            translate([0, -5.0, 1.25])
                hull() {
                    rounded_box(building_l + 10.0, building_w + 8.0, 2.5, 4.0);
                }

            // 2. Solid Side Support Walls (+Y and -Y side walls lifted onto 2.5mm base)
            translate([0, -5.0, 2.5 + eaves_h / 2])
                cube([building_l, building_w, eaves_h], center = true);

            // 3. Alpine 45-degree Pitch Gable Roof (EXACT MATCH TO STATION A!)
            translate([0, -5.0, 2.5 + eaves_h])
                hull() {
                    cube([building_l + 3.0, building_w + 3.0, 1.0], center = true);
                    translate([0, 0, roof_h])
                        cube([building_l + 3.0, 1.0, 1.0], center = true);
                }

            // 4. Elevated Open Vertical Clevis Ears (EXACT MATCH TO STATION A!)
            for (y_sign = [-1, 1]) {
                translate([0, -5.0 + y_sign * 5.0, 2.5 + eaves_h + roof_h + 4.0])
                    cube([16.0, 4.0, 20.0], center = true);
                
                translate([0, -5.0 + y_sign * 5.0, 2.5 + eaves_h + roof_h - 1.0])
                    rotate([0, 90, 0])
                        rotate([0, 0, 45])
                            cube([8.0 / sqrt(2), 8.0 / sqrt(2), 16.0], center = true);
            }

            // 5. Decorative Timber Corner Posts
            for (x_sign = [-1, 1]) {
                for (y_sign = [-1, 1]) {
                    translate([x_sign * (building_l / 2 - 1.2), -5.0 + y_sign * (building_w / 2 - 1.2), 2.5 + eaves_h / 2])
                        cube([2.4, 2.4, eaves_h], center = true);
                }
            }
        }

        // --- SUBTRACTIONS ---

        // A. FRONT AND BACK WALL REMOVAL (Complete Drive-Through Corridor along X-axis)
        translate([0, -5.0, 2.5 + eaves_h / 2 + 0.5])
            cube([building_l + 10.0, building_w - wall_th * 2, eaves_h + 2.0], center = true);

        // B. Elevated Drive Sheave Axle Bore through Clevis Ears (EXACT MATCH TO STATION A!)
        translate([0, -5.0, 2.5 + eaves_h + roof_h + 10.5])
            rotate([90, 0, 0])
                cylinder(d = 5.2, h = building_w + 14, center = true);

        // C. Decorative Timber Siding Grooves on Exterior Side Walls
        for (z = [4 : 4 : eaves_h - 2]) {
            for (y_sign = [-1, 1]) {
                translate([0, -5.0 + y_sign * (building_w / 2), 2.5 + z])
                    cube([building_l + 2, 0.6, 0.8], center = true);
            }
        }
    }
}

// Render flat on foundation floor at Z = 0
station_b_mountain_building();
