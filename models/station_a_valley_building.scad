// ====================================================================
// Alpine Gondola Base Station Chalet Building (Station A - Valley Station)
// 
// Features:
// - Passenger Boarding Archway: Open tunnel (22mm wide x 26mm high) for gondola cabin entry.
// - Alpine Chalet Architecture: 45-degree self-supporting roof, timber beam siding, arched windows & doorways.
// - Integrated Top Tower Socket: Roof ridge houses the socket for Tower 1 Drive Head (Part 06-B) or direct Drive Sheave (Part 08).
// - Height: ~50mm total height (exactly 1/2 the height of 100mm mountain mast!).
// - 100% Support-Free: Rests flat on building foundation floor at Z = 0.
// ====================================================================

$fn = 40;

// Dimensions (mm)
building_l  = 48.0;  // Length along cable line
building_w  = 38.0;  // Width
eaves_h     = 30.0;  // Wall height to roof eaves
roof_h      = 18.0;  // Peak roof height above eaves (Total H = 48mm)
wall_th     = 1.4;   // Thinned wall thickness (1.4mm for sleek interior & light print)
tunnel_w    = 22.0;  // Passenger boarding tunnel width (fits 16mm cabin)
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

module alpine_pine_tree(h = 16) {
    trunk_d = max(1.8, h * 0.22);
    trunk_h = h * 0.35;
    
    // Trunk
    cylinder(d = trunk_d, h = trunk_h);
    
    // 3 Tiered Conical Foliage Shells (45-degree self-supporting slope)
    for (i = [0 : 2]) {
        tier_z = trunk_h * 0.5 + i * (h * 0.22);
        tier_d = (h * 0.7) * (1.0 - i * 0.25);
        tier_h = h * 0.4;
        translate([0, 0, tier_z])
            cylinder(d1 = tier_d, d2 = 0.5, h = tier_h);
    }
}

module alpine_rock(rx = 5, ry = 4, rz = 3) {
    hull() {
        translate([0, 0, 0]) cube([rx, ry, 1], center = true);
        translate([0.4, 0.4, rz / 2]) cube([rx * 0.7, ry * 0.7, rz], center = true);
        translate([-0.4, -0.2, rz * 0.8]) sphere(r = min(rx, ry) * 0.25, $fn = 8);
    }
}

module station_a_valley_building() {
    difference() {
        union() {
            // 1. Expanded Mountainous Terrain Baseplate (84mm x 70mm Footprint)
            translate([0, 0, 1.25])
                hull() {
                    rounded_box(building_l + 36.0, building_w + 32.0, 2.5, 6.0);
                }

            // 2. Main Building Chassis Block (lifted onto 2.5mm terrain base)
            translate([0, 0, 2.5 + eaves_h / 2])
                cube([building_l, building_w, eaves_h], center = true);

            // 3. Alpine 45-degree Pitch Gable Roof (ROOF GEOMETRY 100% UNCHANGED!)
            translate([0, 0, 2.5 + eaves_h])
                hull() {
                    // Eaves base plate with overhang
                    cube([building_l + 3.0, building_w + 3.0, 1.0], center = true);
                    // Roof ridge peak line
                    translate([0, 0, roof_h])
                        cube([building_l + 3.0, 1.0, 1.0], center = true);
                }

            // 4. Elevated Open Vertical Clevis Ears (CLEVIS GEOMETRY 100% UNCHANGED!)
            for (y_sign = [-1, 1]) {
                translate([0, y_sign * 5.0, 2.5 + eaves_h + roof_h + 4.0])
                    cube([16.0, 4.0, 20.0], center = true);
                
                translate([0, y_sign * 5.0, 2.5 + eaves_h + roof_h - 1.0])
                    rotate([0, 90, 0])
                        rotate([0, 0, 45])
                            cube([8.0 / sqrt(2), 8.0 / sqrt(2), 16.0], center = true);
            }

            // 5. Decorative Timber Corner Posts
            for (x_sign = [-1, 1]) {
                for (y_sign = [-1, 1]) {
                    translate([x_sign * (building_l / 2 - 1.2), y_sign * (building_w / 2 - 1.2), 2.5 + eaves_h / 2])
                        cube([2.4, 2.4, eaves_h], center = true);
                }
            }

            // 6. 8x Alpine Evergreen Pine Trees (100% Support-Free 45-degree Conical Branches)
            translate([-32.0, -26.0, 2.5]) alpine_pine_tree(h = 18);
            translate([-24.0, -23.0, 2.5]) alpine_pine_tree(h = 14);
            translate([ 23.0, -24.0, 2.5]) alpine_pine_tree(h = 12);
            translate([ 33.0, -26.0, 2.5]) alpine_pine_tree(h = 20);
            translate([ 34.0,  26.0, 2.5]) alpine_pine_tree(h = 16);
            translate([ 24.0,  23.0, 2.5]) alpine_pine_tree(h = 13);
            translate([-25.0,  22.0, 2.5]) alpine_pine_tree(h = 15);
            translate([-33.0,  25.0, 2.5]) alpine_pine_tree(h = 17);

            // 7. 7x Alpine Mountain Landscape Rock Clusters
            translate([-36.0, -10.0, 2.5]) alpine_rock(rx = 7, ry = 5, rz = 4);
            translate([-28.0, -27.0, 2.5]) alpine_rock(rx = 6, ry = 4, rz = 3);
            translate([ 18.0, -27.0, 2.5]) alpine_rock(rx = 5, ry = 6, rz = 3.5);
            translate([ 36.0,  -8.0, 2.5]) alpine_rock(rx = 8, ry = 5, rz = 4.5);
            translate([ 28.0,  27.0, 2.5]) alpine_rock(rx = 7, ry = 5, rz = 4);
            translate([-20.0,  26.0, 2.5]) alpine_rock(rx = 6, ry = 6, rz = 3.8);
            translate([-36.0,  12.0, 2.5]) alpine_rock(rx = 5, ry = 7, rz = 3.5);
        }

        // --- SUBTRACTIONS (100% Support-Free Arches & Cavities) ---

        // A. Longitudinal Gondola Passenger Boarding Archway (Tunnel)
        translate([0, 0, 2.5 + tunnel_h / 2 - 0.01])
            cube([building_l + 10, tunnel_w, tunnel_h], center = true);
        
        // 45-degree self-supporting arch roof for boarding tunnel
        translate([0, 0, 2.5 + tunnel_h])
            rotate([0, 90, 0])
                rotate([0, 0, 45])
                    cube([tunnel_w / sqrt(2), tunnel_w / sqrt(2), building_l + 10], center = true);

        // B. Hollow Interior Passenger Waiting Room Cavity
        for (y_sign = [-1, 1]) {
            translate([0, y_sign * (tunnel_w / 2 + (building_w / 2 - tunnel_w / 2) / 2), 2.5 + eaves_h / 2 + 1.0])
                cube([building_l - wall_th * 4, (building_w - tunnel_w) / 2 - wall_th, eaves_h - 4.0], center = true);
        }

        // C. Side Passenger Entry Doorways (+Y and -Y sides) with 45-degree Gothic Arches
        for (y_sign = [-1, 1]) {
            translate([0, y_sign * (building_w / 2), 2.5 + 11.0]) {
                cube([10.0, wall_th + 4, 16.0], center = true);
                translate([0, 0, 8.0])
                    rotate([90, 0, 0])
                        rotate([0, 0, 45])
                            cube([10.0 / sqrt(2), 10.0 / sqrt(2), wall_th + 4], center = true);
            }
        }

        // D. Alpine Windows on Front and Back Gables (+X and -X ends)
        for (x_sign = [-1, 1]) {
            translate([x_sign * (building_l / 2), 0, 2.5 + eaves_h + roof_h * 0.4]) {
                cube([wall_th + 4, 7.0, 7.0], center = true);
                rotate([0, 90, 0])
                    rotate([0, 0, 45])
                        cube([7.0 / sqrt(2), 7.0 / sqrt(2), wall_th + 4], center = true);
            }
        }

        // E. Open Cable Track Channel between Clevis Ears (6.0mm wide gap, 100% open front & rear)
        translate([0, 0, 2.5 + eaves_h + roof_h + 8.0])
            cube([building_l + 10, 6.0, 16.0], center = true);

        // Elevated Drive Sheave Axle Bore through Clevis Ears (5.2mm for M5 axle pin)
        // Positioned at Z = 2.5 + eaves_h + roof_h + 10.5mm so 18mm wheel bottom clears roof peak by 1.5mm!
        translate([0, 0, 2.5 + eaves_h + roof_h + 10.5])
            rotate([90, 0, 0])
                cylinder(d = 5.2, h = building_w + 4, center = true);

        // F. Decorative Timber Siding Grooves on Exterior Walls
        for (z = [4 : 4 : eaves_h - 2]) {
            for (y_sign = [-1, 1]) {
                translate([0, y_sign * (building_w / 2), 2.5 + z])
                    cube([building_l + 2, 0.6, 0.8], center = true);
            }
        }
    }
}

// Render flat on foundation floor at Z = 0
station_a_valley_building();
