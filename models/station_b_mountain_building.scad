// ====================================================================
// Alpine Gondola Mountain Summit Station Chalet (Station B - Top Station)
// 
// Architectural & Engineering Features:
// - Compact Mountain Summit Chalet Layout: Streamlined single-building summit terminal (32mm x 28mm).
// - Plain Baseplate: Trees removed for clean, plain 3D printing!
// - ROOFING & CLEVIS EXACT MATCH TO GROUND STATION (Station A):
//   - Main Roof Pitch: 45-degree Alpine Gable Roof (Width = 28.0mm, Eaves = 30.0mm, Peak = 18.0mm).
//   - Elevated Vertical Clevis Ears: Exact same 14.0mm outer span & 6.0mm channel width.
//   - Axle Bore: Positioned at Z = 61.0mm (5.2mm bore) - fits the exact same Sheave (08a), Axle Pin (08c), and End Cap (08d)!
// - 100% Support-Free: Rests flat on summit crag baseplate at Z = 0.
// ====================================================================

$fn = 40;

// Compact Summit Building Dimensions (mm)
building_l  = 32.0;  // Streamlined summit length along X-axis
building_w  = 28.0;  // Main Boarding Hall Width (EXACT MATCH to Station A!)
eaves_h     = 30.0;  // Wall height to main roof eaves (EXACT MATCH!)
roof_h      = 18.0;  // Peak main roof height above eaves (EXACT MATCH! Total H = 48mm)
wall_th     = 1.4;   // Thinned wall thickness
tunnel_w    = 22.0;  // Boarding tunnel width (fits 16mm cabin)
tunnel_h    = 26.0;  // Tunnel clearance height

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

module summit_rock(rx = 6, ry = 5, rz = 4) {
    hull() {
        translate([0, 0, 0]) cube([rx, ry, 1], center = true);
        translate([0.3, 0.3, rz / 2]) cube([rx * 0.7, ry * 0.7, rz], center = true);
        translate([-0.3, -0.2, rz * 0.8]) sphere(r = min(rx, ry) * 0.25, $fn = 8);
    }
}

module summit_boarding_platform() {
    // Compact summit passenger exit platform along track in Boarding Hall
    translate([0, -8.5, 2.5 + 1.25])
        cube([building_l - 4.0, 7.0, 2.5], center = true);
}

module station_b_mountain_building() {
    difference() {
        union() {
            // 1. Summit Mountain Baseplate (68mm x 58mm Footprint - Compact & Plain)
            translate([0, -2.0, 1.25])
                hull() {
                    rounded_box(building_l + 36.0, building_w + 30.0, 2.5, 6.0);
                }

            // 2. Compact Boarding Hall Chassis Block (lifted onto 2.5mm base)
            translate([0, -5.0, 2.5 + eaves_h / 2])
                cube([building_l, building_w, eaves_h], center = true);

            // 3. Summit Boarding Platform
            summit_boarding_platform();

            // 4. Alpine 45-degree Pitch Gable Roof (EXACT MATCH TO STATION A!)
            translate([0, -5.0, 2.5 + eaves_h])
                hull() {
                    cube([building_l + 3.0, building_w + 3.0, 1.0], center = true);
                    translate([0, 0, roof_h])
                        cube([building_l + 3.0, 1.0, 1.0], center = true);
                }

            // 5. Elevated Open Vertical Clevis Ears (EXACT MATCH TO STATION A!)
            for (y_sign = [-1, 1]) {
                translate([0, -5.0 + y_sign * 5.0, 2.5 + eaves_h + roof_h + 4.0])
                    cube([16.0, 4.0, 20.0], center = true);
                
                translate([0, -5.0 + y_sign * 5.0, 2.5 + eaves_h + roof_h - 1.0])
                    rotate([0, 90, 0])
                        rotate([0, 0, 45])
                            cube([8.0 / sqrt(2), 8.0 / sqrt(2), 16.0], center = true);
            }

            // 6. Decorative Timber Corner Posts
            for (x_sign = [-1, 1]) {
                for (y_sign = [-1, 1]) {
                    translate([x_sign * (building_l / 2 - 1.2), -5.0 + y_sign * (building_w / 2 - 1.2), 2.5 + eaves_h / 2])
                        cube([2.4, 2.4, eaves_h], center = true);
                }
            }

            // 7. 6x Summit Rocky Formations (Trees removed for plain finish!)
            translate([-28.0,  -8.0, 2.5]) summit_rock(rx = 7, ry = 5, rz = 4.0);
            translate([ 28.0,  -6.0, 2.5]) summit_rock(rx = 7, ry = 6, rz = 4.5);
            translate([ 18.0,  20.0, 2.5]) summit_rock(rx = 6, ry = 5, rz = 3.5);
            translate([-18.0,  20.0, 2.5]) summit_rock(rx = 6, ry = 5, rz = 3.5);
            translate([  0.0,  20.0, 2.5]) summit_rock(rx = 8, ry = 5, rz = 4.0);
            translate([  0.0, -24.0, 2.5]) summit_rock(rx = 7, ry = 5, rz = 3.5);
        }

        // --- SUBTRACTIONS ---

        // A. Summit Gondola Track Tunnel (Runs along X-axis at Y = -5.0)
        translate([0, -5.0, 2.5 + tunnel_h / 2 - 0.01])
            cube([building_l + 10, tunnel_w, tunnel_h], center = true);
        
        // 45-degree self-supporting arch roof for boarding tunnel
        translate([0, -5.0, 2.5 + tunnel_h])
            rotate([0, 90, 0])
                rotate([0, 0, 45])
                    cube([tunnel_w / sqrt(2), tunnel_w / sqrt(2), building_l + 10], center = true);

        // B. Summit Operator & Control Room Windows (+Y face)
        for (x = [-7.0, 7.0]) {
            translate([x, 9.0, 2.5 + 16.0]) {
                cube([7.0, wall_th + 4, 7.0], center = true);
                rotate([90, 0, 0]) rotate([0, 0, 45]) cube([7.0 / sqrt(2), 7.0 / sqrt(2), wall_th + 4], center = true);
            }
        }

        // Summit Staff Access Door (+Y face)
        translate([0, 9.0, 2.5 + 8.0])
            cube([7.0, wall_th + 4, 13.0], center = true);

        // C. Alpine Windows on Front and Back Gables (+X and -X ends)
        for (x_sign = [-1, 1]) {
            translate([x_sign * (building_l / 2), -5.0, 2.5 + eaves_h + roof_h * 0.4]) {
                cube([wall_th + 4, 7.0, 7.0], center = true);
                rotate([0, 90, 0]) rotate([0, 0, 45]) cube([7.0 / sqrt(2), 7.0 / sqrt(2), wall_th + 4], center = true);
            }
        }

        // D. Elevated Drive Sheave Axle Bore through Clevis Ears (EXACT MATCH TO STATION A!)
        translate([0, -5.0, 2.5 + eaves_h + roof_h + 10.5])
            rotate([90, 0, 0])
                cylinder(d = 5.2, h = building_w + 14, center = true);

        // E. Decorative Timber Siding Grooves on Exterior Walls
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
