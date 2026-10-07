// Refined Topographic Contoured Mountain Terrain Base Test
$fn = 32;

module topo_contoured_mountain_base(r = 21, total_h = 5.2, num_levels = 8) {
    step_h = total_h / num_levels; // ~0.65mm step height for crisp printable contours
    
    // Base Disc Rim (Flat bottom, 0.8mm outer lip)
    cylinder(r = r, h = 0.8, $fn = 64);
    
    for (k = [1 : num_levels]) {
        z_pos = 0.8 + (k - 1) * step_h;
        frac = k / num_levels; // 0.125 to 1.0
        
        translate([0, 0, z_pos])
            linear_extrude(height = step_h + 0.04, convexity = 10) {
                offset(r = 0.6) offset(delta = -0.6) {
                    union() {
                        // 1. Central Summit Peak Ridge (where tree stands)
                        translate([-r * 0.05 * frac, r * 0.04 * frac])
                            scale([1.0, 0.85])
                                circle(r = max(2.8, r * 0.90 * (1.0 - 0.78 * pow(frac, 0.65))), $fn = 48);
                        
                        // 2. West Mountain Ridge Lobe (extends out to rim at low levels)
                        if (frac < 0.80) {
                            translate([-r * 0.45 * (1 - frac * 0.8), r * 0.25 * (1 - frac * 0.8)])
                                scale([1.1, 0.75])
                                    circle(r = r * 0.48 * pow(1.0 - frac, 0.7), $fn = 32);
                        }
                        
                        // 3. South-East Shoulder Knoll (secondary peak)
                        if (frac < 0.75) {
                            translate([r * 0.42 * (1 - frac * 0.7), -r * 0.38 * (1 - frac * 0.7)])
                                scale([0.85, 1.1])
                                    circle(r = r * 0.44 * pow(1.0 - frac, 0.7), $fn = 32);
                        }
                        
                        // 4. North-East Rocky Spur Ridge
                        if (frac < 0.60) {
                            translate([r * 0.35 * (1 - frac), r * 0.45 * (1 - frac)])
                                circle(r = r * 0.38 * pow(1.0 - frac, 0.75), $fn = 32);
                        }
                        
                        // 5. South-West Valley Slope Ridge
                        if (frac < 0.50) {
                            translate([-r * 0.38 * (1 - frac), -r * 0.42 * (1 - frac)])
                                circle(r = r * 0.36 * pow(1.0 - frac, 0.75), $fn = 32);
                        }
                    }
                }
            }
    }
}

// Cypress Trunk
module cypress_trunk() {
    union() {
        cylinder(r1 = 4.2, r2 = 3.0, h = 3.5);
        
        hull() {
            translate([0, 0, 1.0]) cylinder(r1 = 3.0, r2 = 2.3, h = 4.0);
            translate([1.2, 0.8, 8.5]) cylinder(r1 = 2.3, r2 = 1.9, h = 4.0);
        }
        
        hull() {
            translate([1.2, 0.8, 8.5]) cylinder(r1 = 2.3, r2 = 1.8, h = 4.0);
            translate([-0.5, 2.2, 16.5]) cylinder(r1 = 1.8, r2 = 1.4, h = 3.0);
        }
        
        for (a = [0 : 60 : 300]) {
            rotate([0, 0, a])
                hull() {
                    translate([2.5, 0, 1.5]) sphere(r = 0.4, $fn = 10);
                    translate([1.4, 0.8, 14.5]) sphere(r = 0.3, $fn = 10);
                }
        }
        
        hull() {
            translate([-0.5, 2.2, 16.5]) sphere(r = 1.5, $fn = 12);
            translate([-6.5, -2.5, 23.5]) sphere(r = 1.1, $fn = 12);
        }
        hull() {
            translate([-6.5, -2.5, 23.5]) sphere(r = 1.1, $fn = 12);
            translate([-10.0, -5.0, 28.5]) sphere(r = 0.8, $fn = 12);
        }
        
        hull() {
            translate([-0.5, 2.2, 16.5]) sphere(r = 1.5, $fn = 12);
            translate([5.5, 4.5, 24.5]) sphere(r = 1.2, $fn = 12);
        }
        hull() {
            translate([5.5, 4.5, 24.5]) sphere(r = 1.2, $fn = 12);
            translate([9.5, 7.5, 30.0]) sphere(r = 0.8, $fn = 12);
        }
        
        hull() {
            translate([-0.5, 2.2, 16.5]) sphere(r = 1.5, $fn = 12);
            translate([0.5, 0.0, 26.5]) sphere(r = 1.1, $fn = 12);
        }
        hull() {
            translate([0.5, 0.0, 26.5]) sphere(r = 1.1, $fn = 12);
            translate([-1.5, -1.0, 33.5]) sphere(r = 0.7, $fn = 12);
        }
    }
}

// Foliage Canopy Pads
module foliage_cloud_pad(rx = 7, ry = 6, rz = 4.5, bump_count = 7) {
    union() {
        translate([0, 0, -rz * 0.8])
            cylinder(r1 = 1.0, r2 = max(rx, ry) * 0.85, h = rz * 0.95);
        
        scale([1.0, ry / rx, rz / rx]) sphere(r = rx, $fn = 20);
        
        for (b = [0 : bump_count - 1]) {
            ang = b * (360 / bump_count);
            rotate([0, 0, ang])
                translate([rx * 0.65, 0, rz * 0.25])
                    scale([1.2, 0.8, 0.9])
                        rotate([0, 45, 30])
                            cube([rx * 0.55, rx * 0.55, rx * 0.55], center = true);
        }
        
        translate([0, 0, rz * 0.45])
            scale([1.1, 0.9, 0.7]) sphere(r = rx * 0.55, $fn = 16);
    }
}

module complete_tree() {
    union() {
        topo_contoured_mountain_base(r = 20, total_h = 5.2, num_levels = 8);
        
        // Tree elevated to sit on summit contour ridge (Z = 5.2mm)
        translate([-0.5, 0.2, 5.2]) {
            cypress_trunk();
            
            translate([-6.5, -2.5, 25.0]) rotate([12, -15, 20]) foliage_cloud_pad(rx = 7.5, ry = 6.0, rz = 4.2);
            translate([-10.5, -5.5, 30.0]) rotate([15, -10, -10]) foliage_cloud_pad(rx = 6.5, ry = 5.2, rz = 3.8);
            translate([5.5, 4.5, 26.0]) rotate([-10, 15, -25]) foliage_cloud_pad(rx = 7.0, ry = 5.8, rz = 4.0);
            translate([9.8, 7.8, 31.5]) rotate([-12, 18, 35]) foliage_cloud_pad(rx = 6.8, ry = 5.5, rz = 3.8);
            translate([-1.5, -1.0, 35.0]) rotate([5, 0, 45]) foliage_cloud_pad(rx = 9.0, ry = 7.5, rz = 5.0);
            translate([0.5, 1.0, 27.0]) rotate([-8, 5, 10]) foliage_cloud_pad(rx = 6.0, ry = 5.0, rz = 3.5);
        }
    }
}

complete_tree();
