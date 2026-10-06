// ====================================================================
// Alpine Gondola Base Station Chalet Building (Station A - Valley Station)
// 
// Architectural Features:
// - L-Shaped Alpine Chalet Layout: Main Gondola Boarding Terminal (Room 2) + Stepped-Out Ticket Lobby Wing (Room 1).
// - Stepped Alpine Pitch Roofs: Main roof ridge with open clevis ears + stepped Annex chalet roof over Ticket Lounge.
// - Covered Entrance Porch: Sheltered ticket entry porch supported by twin timber posts.
// - Panoramic Viewing Windows: Large multi-pane alpine windows revealing ticket counter, waiting table, and benches inside!
// - Passenger Boarding Terminal: Open 22mm x 26mm tunnel with raised boarding platform.
// - Plain Baseplate: Trees removed for clean, plain 3D printing!
// - Roof & Vertical Clevis: 100% UNCHANGED (Axle bore @ Z=61mm, 1.5mm wheel air gap above main roof peak).
// - 100% Support-Free: Rests flat on terrain baseplate at Z = 0.
// ====================================================================

$fn = 40;

// Dimensions (mm)
building_l  = 48.0;  // Length along cable X-axis
building_w  = 28.0;  // Main Boarding Hall Width
eaves_h     = 30.0;  // Wall height to main roof eaves
roof_h      = 18.0;  // Peak main roof height above eaves (Total H = 48mm)
wall_th     = 1.4;   // Thinned wall thickness
tunnel_w    = 22.0;  // Boarding tunnel width (fits 16mm cabin)
tunnel_h    = 26.0;  // Tunnel clearance height

// Annex Wing Dimensions (Room 1: Ticket Lounge)
annex_l     = 32.0;  // Length of Ticket Lounge wing
annex_w     = 18.0;  // Step-out width to +Y side
annex_h     = 24.0;  // Annex eaves height
annex_roof_h= 12.0;  // Annex roof pitch height

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

module alpine_rock(rx = 5, ry = 4, rz = 3) {
    hull() {
        translate([0, 0, 0]) cube([rx, ry, 1], center = true);
        translate([0.4, 0.4, rz / 2]) cube([rx * 0.7, ry * 0.7, rz], center = true);
        translate([-0.4, -0.2, rz * 0.8]) sphere(r = min(rx, ry) * 0.25, $fn = 8);
    }
}

module ticket_counter_and_furniture() {
    // Ticket Desk / Counter in Room 1 (Annex Wing)
    translate([8.0, 16.0, 2.5 + 2.5])
        cube([9.0, 3.2, 5.0], center = true);
    // Ticket Counter Stool
    translate([8.0, 19.2, 2.5 + 0.1])
        cylinder(d = 2.6, h = 3.6);

    // Waiting Lounge Round Table
    translate([-6.0, 15.5, 2.5 + 3.2])
        cylinder(d = 6.5, h = 0.8); // Table top
    translate([-6.0, 15.5, 2.5 + 0.1])
        cylinder(d = 1.6, h = 3.2); // Table leg

    // Waiting Lounge Bench along back wall
    translate([-6.0, 20.5, 2.5 + 1.6])
        cube([12.0, 2.6, 3.2], center = true);
}

module boarding_platform() {
    // Raised passenger boarding platform along gondola track in Room 2 (Main Boarding Hall)
    translate([0, -8.5, 2.5 + 1.25])
        cube([building_l - 6.0, 7.0, 2.5], center = true);
}

module station_a_valley_building() {
    difference() {
        union() {
            // 1. Expanded Terrain Baseplate (92mm x 82mm Footprint)
            translate([0, 2.0, 1.25])
                hull() {
                    rounded_box(building_l + 44.0, building_w + 54.0, 2.5, 8.0);
                }

            // 2. Room 2 Main Boarding Hall Chassis Block (lifted onto 2.5mm terrain base)
            translate([0, -5.0, 2.5 + eaves_h / 2])
                cube([building_l, building_w, eaves_h], center = true);

            // 3. Room 1 Stepped-Out Ticket Lounge Annex Wing (L-Extension to +Y side)
            translate([-2.0, 14.0, 2.5 + annex_h / 2])
                cube([annex_l, annex_w, annex_h], center = true);

            // 4. Room 1 Stepped Alpine Pitch Roof
            translate([-2.0, 14.0, 2.5 + annex_h])
                hull() {
                    cube([annex_l + 3.0, annex_w + 3.0, 1.0], center = true);
                    translate([0, 0, annex_roof_h])
                        cube([annex_l + 3.0, 1.0, 1.0], center = true);
                }

            // 5. Covered Entrance Porch Canopy over Ticket Entrance
            translate([17.0, 14.0, 2.5 + 15.0])
                hull() {
                    cube([10.0, 12.0, 1.2], center = true);
                    translate([0, 0, 3.0])
                        cube([10.0, 1.0, 1.0], center = true);
                }
            // Timber Support Posts for Porch
            translate([20.0, 9.0, 2.5 + 7.5])
                cylinder(d = 2.0, h = 15.0);
            translate([20.0, 19.0, 2.5 + 7.5])
                cylinder(d = 2.0, h = 15.0);

            // 6. Room 1 Interior Furniture & Ticket Counter
            ticket_counter_and_furniture();

            // 7. Room 2 Raised Passenger Boarding Platform
            boarding_platform();

            // 8. Alpine 45-degree Pitch Gable Roof (ROOF GEOMETRY 100% UNCHANGED!)
            translate([0, -5.0, 2.5 + eaves_h])
                hull() {
                    cube([building_l + 3.0, building_w + 3.0, 1.0], center = true);
                    translate([0, 0, roof_h])
                        cube([building_l + 3.0, 1.0, 1.0], center = true);
                }

            // 9. Elevated Open Vertical Clevis Ears (CLEVIS GEOMETRY 100% UNCHANGED!)
            for (y_sign = [-1, 1]) {
                translate([0, -5.0 + y_sign * 5.0, 2.5 + eaves_h + roof_h + 4.0])
                    cube([16.0, 4.0, 20.0], center = true);
                
                translate([0, -5.0 + y_sign * 5.0, 2.5 + eaves_h + roof_h - 1.0])
                    rotate([0, 90, 0])
                        rotate([0, 0, 45])
                            cube([8.0 / sqrt(2), 8.0 / sqrt(2), 16.0], center = true);
            }

            // 10. Decorative Timber Corner Posts
            for (x_sign = [-1, 1]) {
                for (y_sign = [-1, 1]) {
                    translate([x_sign * (building_l / 2 - 1.2), -5.0 + y_sign * (building_w / 2 - 1.2), 2.5 + eaves_h / 2])
                        cube([2.4, 2.4, eaves_h], center = true);
                }
            }

            // 11. 8x Alpine Mountain Landscape Rock Clusters (Trees removed for plain finish!)
            translate([-40.0, -12.0, 2.5]) alpine_rock(rx = 8, ry = 6, rz = 4.5);
            translate([-30.0, -32.0, 2.5]) alpine_rock(rx = 6, ry = 5, rz = 3.5);
            translate([ 20.0, -32.0, 2.5]) alpine_rock(rx = 6, ry = 6, rz = 4.0);
            translate([ 40.0, -10.0, 2.5]) alpine_rock(rx = 8, ry = 6, rz = 5.0);
            translate([ 30.0,  32.0, 2.5]) alpine_rock(rx = 7, ry = 5, rz = 4.0);
            translate([-22.0,  32.0, 2.5]) alpine_rock(rx = 6, ry = 6, rz = 3.8);
            translate([-40.0,  14.0, 2.5]) alpine_rock(rx = 6, ry = 8, rz = 4.0);
            translate([  0.0,  34.0, 2.5]) alpine_rock(rx = 7, ry = 5, rz = 3.5);
        }

        // --- SUBTRACTIONS (100% Support-Free Arches & Cavities) ---

        // A. Room 2: Gondola Boarding Hall & Track Tunnel (Runs along X axis at Y = -5.0)
        translate([0, -5.0, 2.5 + tunnel_h / 2 - 0.01])
            cube([building_l + 10, tunnel_w, tunnel_h], center = true);
        
        // 45-degree self-supporting arch roof for boarding tunnel
        translate([0, -5.0, 2.5 + tunnel_h])
            rotate([0, 90, 0])
                rotate([0, 0, 45])
                    cube([tunnel_w / sqrt(2), tunnel_w / sqrt(2), building_l + 10], center = true);

        // B. Room 1: Stepped-Out Ticket Lobby & Lounge Interior Cavity
        translate([-2.0, 14.0, 2.5 + annex_h / 2 + 0.5])
            cube([annex_l - wall_th * 2, annex_w - wall_th * 2, annex_h - 2.0], center = true);

        // Connecting Interior Doorway Arch between Room 1 (Lobby) & Room 2 (Boarding Terminal)
        translate([-2.0, 5.0, 2.5 + 7.5])
            cube([8.0, 6.0, 13.0], center = true);

        // C. Panoramic Multi-Pane Alpine Viewing Windows on Room 1
        translate([14.0, 14.0, 2.5 + 11.0]) {
            cube([wall_th + 4, 12.0, 10.0], center = true);
            rotate([0, 90, 0]) rotate([0, 0, 45]) cube([12.0 / sqrt(2), 12.0 / sqrt(2), wall_th + 4], center = true);
        }

        // Side Viewing Windows on Annex (+Y side)
        for (x = [-10.0, 4.0]) {
            translate([x, 23.0, 2.5 + 11.0]) {
                cube([8.0, wall_th + 4, 8.0], center = true);
                rotate([90, 0, 0]) rotate([0, 0, 45]) cube([8.0 / sqrt(2), 8.0 / sqrt(2), wall_th + 4], center = true);
            }
        }

        // Main Exterior Arched Passenger Entrance Door into Ticket Lounge (+X side)
        translate([14.0, 14.0, 2.5 + 8.0])
            cube([wall_th + 4, 8.0, 13.0], center = true);

        // D. Alpine Windows on Front and Back Gables of Main Building (+X and -X ends)
        for (x_sign = [-1, 1]) {
            translate([x_sign * (building_l / 2), -5.0, 2.5 + eaves_h + roof_h * 0.4]) {
                cube([wall_th + 4, 7.0, 7.0], center = true);
                rotate([0, 90, 0]) rotate([0, 0, 45]) cube([7.0 / sqrt(2), 7.0 / sqrt(2), wall_th + 4], center = true);
            }
        }

        // E. Elevated Drive Sheave Axle Bore through Clevis Ears (EXACT MATCH!)
        translate([0, -5.0, 2.5 + eaves_h + roof_h + 10.5])
            rotate([90, 0, 0])
                cylinder(d = 5.2, h = building_w + 14, center = true);

        // F. Decorative Timber Siding Grooves on Exterior Walls
        for (z = [4 : 4 : eaves_h - 2]) {
            for (y_sign = [-1, 1]) {
                translate([0, -5.0 + y_sign * (building_w / 2), 2.5 + z])
                    cube([building_l + 2, 0.6, 0.8], center = true);
            }
        }
    }
}

// Render flat on foundation floor at Z = 0
station_a_valley_building();
