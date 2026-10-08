// ====================================================================
// Tree Swarm #1: Windswept Coastal Cypress Tree
// Scale: 2.5 inches (63.5 mm height)
// Style: Smooth flared trunk base foot (0 terrain base, 0 protrusions)
// 100% 3D Printable, 0% supports needed
// ====================================================================

$fn = 36;

tree_height = 63.5; // 2.5 inches
base_r1     = 8.5;  // 17mm wide smooth flared base foot
base_r2     = 4.2;

module cypress_trunk_2_5in() {
    color([0.45, 0.28, 0.15]) { // Sienna Brown
        union() {
            // Smooth wide flared trunk base foot (sitting flat on Z=0)
            cylinder(r1 = base_r1, r2 = base_r2, h = 7.5);
            
            hull() {
                translate([0, 0, 4.5]) cylinder(r1 = base_r2, r2 = 3.2, h = 7.0);
                translate([1.8, 1.2, 13.5]) cylinder(r1 = 3.2, r2 = 2.6, h = 7.0);
            }
            
            hull() {
                translate([1.8, 1.2, 13.5]) cylinder(r1 = 3.2, r2 = 2.5, h = 7.0);
                translate([-0.8, 3.2, 26.0]) cylinder(r1 = 2.5, r2 = 1.9, h = 5.0);
            }
            
            for (a = [0 : 60 : 300]) {
                rotate([0, 0, a])
                    hull() {
                        translate([4.5, 0, 2.2]) sphere(r = 0.6, $fn = 10);
                        translate([2.0, 1.2, 23.0]) sphere(r = 0.4, $fn = 10);
                    }
            }
            
            hull() {
                translate([-0.8, 3.2, 26.0]) sphere(r = 2.0, $fn = 14);
                translate([-9.5, -3.8, 37.0]) sphere(r = 1.4, $fn = 12);
            }
            hull() {
                translate([-9.5, -3.8, 37.0]) sphere(r = 1.4, $fn = 12);
                translate([-14.5, -7.5, 45.0]) sphere(r = 1.0, $fn = 12);
            }
            
            hull() {
                translate([-0.8, 3.2, 26.0]) sphere(r = 2.0, $fn = 14);
                translate([8.5, 6.8, 38.5]) sphere(r = 1.5, $fn = 12);
            }
            hull() {
                translate([8.5, 6.8, 38.5]) sphere(r = 1.5, $fn = 12);
                translate([14.5, 11.5, 47.0]) sphere(r = 1.0, $fn = 12);
            }
            
            hull() {
                translate([-0.8, 3.2, 26.0]) sphere(r = 2.0, $fn = 14);
                translate([0.8, 0.0, 41.5]) sphere(r = 1.4, $fn = 12);
            }
            hull() {
                translate([0.8, 0.0, 41.5]) sphere(r = 1.4, $fn = 12);
                translate([-2.2, -1.5, 52.5]) sphere(r = 0.9, $fn = 12);
            }
        }
    }
}

module foliage_cloud_pad(rx = 11, ry = 9, rz = 6.5, bump_count = 8) {
    color([0.18, 0.48, 0.22]) { // Cypress Forest Green
        union() {
            translate([0, 0, -rz * 0.8])
                cylinder(r1 = 1.4, r2 = max(rx, ry) * 0.85, h = rz * 0.95);
            
            scale([1.0, ry / rx, rz / rx]) sphere(r = rx, $fn = 24);
            
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
}

module tree_swarm_01_cypress() {
    union() {
        cypress_trunk_2_5in();
        
        translate([-9.5, -3.8, 39.0]) rotate([12, -15, 20]) foliage_cloud_pad(rx = 11.5, ry = 9.0, rz = 6.2);
        translate([-15.5, -8.5, 47.0]) rotate([15, -10, -10]) foliage_cloud_pad(rx = 10.0, ry = 8.0, rz = 5.5);
        translate([8.5, 6.8, 40.5]) rotate([-10, 15, -25]) foliage_cloud_pad(rx = 11.0, ry = 8.8, rz = 6.0);
        translate([15.0, 12.0, 49.0]) rotate([-12, 18, 35]) foliage_cloud_pad(rx = 10.2, ry = 8.2, rz = 5.6);
        translate([-2.2, -1.5, 55.0]) rotate([5, 0, 45]) foliage_cloud_pad(rx = 13.5, ry = 11.0, rz = 7.5);
        translate([0.8, 1.5, 42.0]) rotate([-8, 5, 10]) foliage_cloud_pad(rx = 9.0, ry = 7.5, rz = 5.2);
    }
}

tree_swarm_01_cypress();
