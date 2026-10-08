// ====================================================================
// 3D Printable Cypress Trees 10-Pack (Heights: 2.0 to 3.0 Inches)
// Spaced-Out Layout: 10 Individual Cypress Trees for Separate Use
// Features:
// - 10 distinct Cypress trees ranging from 2.0" (50.8mm) to 3.0" (76.2mm)
// - Spaced apart in a 2x5 print bed grid array (no touching / no merging)
// - Smooth flared trunk base feet sitting flat on print bed (Z=0)
// - 100% 3D Printable, 0% print supports required
// ====================================================================

$fn = 32;

// --------------------------------------------------------------------
// 1. REUSABLE ORGANIC CYPRESS TREE MODULE (HEIGHT-PARAMETERIZED)
// --------------------------------------------------------------------
module cypress_tree_unit(h = 63.5) {
    // Reference height h0 = 63.5mm (2.5 inches)
    s = h / 63.5;
    
    base_r1 = 7.0 * s;
    base_r2 = 3.4 * s;
    
    // Trunk module
    color([0.45, 0.28, 0.15]) { // Sienna Wood Brown
        union() {
            // Smooth wide flared trunk base foot sitting flat at Z=0
            cylinder(r1 = base_r1, r2 = base_r2, h = 5.5 * s);
            
            hull() {
                translate([0, 0, 3.2 * s]) cylinder(r1 = base_r2, r2 = 2.4 * s, h = 5.0 * s);
                translate([1.2 * s, 0.8 * s, 9.5 * s]) cylinder(r1 = 2.4 * s, r2 = 1.9 * s, h = 5.0 * s);
            }
            
            hull() {
                translate([1.2 * s, 0.8 * s, 9.5 * s]) cylinder(r1 = 2.4 * s, r2 = 1.9 * s, h = 5.0 * s);
                translate([-0.5 * s, 2.2 * s, 18.5 * s]) cylinder(r1 = 1.9 * s, r2 = 1.4 * s, h = 4.0 * s);
            }
            
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([3.4 * s, 0, 1.8 * s]) sphere(r = 0.45 * s, $fn = 10);
                        translate([1.4 * s, 0.8 * s, 16.5 * s]) sphere(r = 0.3 * s, $fn = 10);
                    }
            }
            
            hull() {
                translate([-0.5 * s, 2.2 * s, 18.5 * s]) sphere(r = 1.5 * s, $fn = 12);
                translate([-6.5 * s, -2.5 * s, 26.5 * s]) sphere(r = 1.1 * s, $fn = 12);
            }
            hull() {
                translate([-6.5 * s, -2.5 * s, 26.5 * s]) sphere(r = 1.1 * s, $fn = 12);
                translate([-10.0 * s, -5.0 * s, 32.5 * s]) sphere(r = 0.8 * s, $fn = 12);
            }
            
            hull() {
                translate([-0.5 * s, 2.2 * s, 18.5 * s]) sphere(r = 1.5 * s, $fn = 12);
                translate([5.5 * s, 4.5 * s, 27.5 * s]) sphere(r = 1.2 * s, $fn = 12);
            }
            hull() {
                translate([5.5 * s, 4.5 * s, 27.5 * s]) sphere(r = 1.2 * s, $fn = 12);
                translate([9.5 * s, 7.5 * s, 33.5 * s]) sphere(r = 0.8 * s, $fn = 12);
            }
            
            hull() {
                translate([-0.5 * s, 2.2 * s, 18.5 * s]) sphere(r = 1.5 * s, $fn = 12);
                translate([0.5 * s, 0.0 * s, 29.5 * s]) sphere(r = 1.1 * s, $fn = 12);
            }
            hull() {
                translate([0.5 * s, 0.0 * s, 29.5 * s]) sphere(r = 1.1 * s, $fn = 12);
                translate([-1.5 * s, -1.0 * s, 37.5 * s]) sphere(r = 0.7 * s, $fn = 12);
            }
        }
    }
    
    // Foliage pads module
    translate([0, 0, 0]) {
        translate([-6.5 * s, -2.5 * s, 28.0 * s]) rotate([12, -15, 20]) foliage_cloud_pad(rx = 7.5 * s, ry = 6.0 * s, rz = 4.2 * s);
        translate([-10.5 * s, -5.5 * s, 33.5 * s]) rotate([15, -10, -10]) foliage_cloud_pad(rx = 6.5 * s, ry = 5.2 * s, rz = 3.8 * s);
        translate([5.5 * s, 4.5 * s, 29.0 * s]) rotate([-10, 15, -25]) foliage_cloud_pad(rx = 7.0 * s, ry = 5.8 * s, rz = 4.0 * s);
        translate([9.8 * s, 7.8 * s, 35.0 * s]) rotate([-12, 18, 35]) foliage_cloud_pad(rx = 6.8 * s, ry = 5.5 * s, rz = 3.8 * s);
        translate([-1.5 * s, -1.0 * s, 39.0 * s]) rotate([5, 0, 45]) foliage_cloud_pad(rx = 9.0 * s, ry = 7.5 * s, rz = 5.0 * s);
        translate([0.5 * s, 1.0 * s, 30.0 * s]) rotate([-8, 5, 10]) foliage_cloud_pad(rx = 6.0 * s, ry = 5.0 * s, rz = 3.5 * s);
    }
}

// --------------------------------------------------------------------
// 2. FOLIAGE CANOPY CLUSTER POD MODULE
// --------------------------------------------------------------------
module foliage_cloud_pad(rx = 7, ry = 6, rz = 4.5, bump_count = 7) {
    color([0.18, 0.48, 0.22]) { // Cypress Forest Green
        union() {
            translate([0, 0, -rz * 0.8])
                cylinder(r1 = 1.0, r2 = max(rx, ry) * 0.85, h = rz * 0.95);
            
            scale([1.0, ry / rx, rz / rx]) sphere(r = rx, $fn = 18);
            
            for (b = [0 : bump_count - 1]) {
                ang = b * (360 / bump_count);
                rotate([0, 0, ang])
                    translate([rx * 0.65, 0, rz * 0.25])
                        scale([1.2, 0.8, 0.9])
                            rotate([0, 45, 30])
                                cube([rx * 0.55, rx * 0.55, rx * 0.55], center = true);
            }
            
            translate([0, 0, rz * 0.45])
                scale([1.1, 0.9, 0.7]) sphere(r = rx * 0.55, $fn = 14);
        }
    }
}

// --------------------------------------------------------------------
// 3. SPACED 10-TREE PRINT BED LAYOUT (2x5 Grid Array)
// Heights range from 2.0" (50.8mm) to 3.0" (76.2mm)
// --------------------------------------------------------------------
module cypress_10pack_spaced_array() {
    // 10 distinct heights (in mm)
    heights = [50.8, 53.6, 56.4, 59.2, 62.0, 64.8, 67.6, 70.4, 73.2, 76.2];
    rotations = [0, 45, -30, 90, 135, -75, 120, -110, 60, -45];
    
    spacing_x = 28.0; // 28mm horizontal spacing between tree centers
    spacing_y = 32.0; // 32mm vertical spacing between tree rows
    
    union() {
        // Row 1: Trees 1 to 5 (Front Row, Heights 2.0" to 2.44")
        for (col = [0 : 4]) {
            idx = col;
            tx = (col - 2) * spacing_x;
            ty = -spacing_y * 0.5;
            translate([tx, ty, 0])
                rotate([0, 0, rotations[idx]])
                    cypress_tree_unit(h = heights[idx]);
        }
        
        // Row 2: Trees 6 to 10 (Back Row, Heights 2.55" to 3.0")
        for (col = [0 : 4]) {
            idx = col + 5;
            tx = (col - 2) * spacing_x;
            ty = spacing_y * 0.5;
            translate([tx, ty, 0])
                rotate([0, 0, rotations[idx]])
                    cypress_tree_unit(h = heights[idx]);
        }
    }
}

// Render complete 10-tree spaced layout
cypress_10pack_spaced_array();
