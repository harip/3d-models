// ====================================================================
// Tree Swarm #3: Ancient Broadleaf Oak Tree
// Scale: 2.25 inches (57.2 mm height)
// Style: Smooth flared trunk base foot (0 terrain base, 0 protrusions)
// 100% 3D Printable, 0% supports needed
// ====================================================================

$fn = 36;

tree_height = 57.2; // 2.25 inches
base_r1     = 9.0;  // 18mm wide smooth flared base foot
base_r2     = 4.5;

module broadleaf_oak_trunk_2_25in() {
    color([0.45, 0.28, 0.15]) { // Sienna Brown
        union() {
            // Smooth wide flared trunk base foot (sitting flat on Z=0)
            cylinder(r1 = base_r1, r2 = base_r2, h = 8.0);
            
            hull() {
                translate([0, 0, 3.0]) cylinder(r1 = base_r2, r2 = 3.6, h = 8.0);
                translate([0.8, 0.5, 16.0]) cylinder(r1 = 3.6, r2 = 2.8, h = 8.0);
            }
            
            hull() {
                translate([0.8, 0.5, 16.0]) cylinder(r1 = 3.6, r2 = 2.8, h = 5.0);
                translate([0.0, 0.0, 25.0]) sphere(r = 3.0, $fn = 16);
            }
            
            hull() {
                translate([0.0, 0.0, 25.0]) sphere(r = 2.8, $fn = 14);
                translate([-7.5, -4.8, 34.0]) sphere(r = 1.9, $fn = 12);
            }
            
            hull() {
                translate([0.0, 0.0, 25.0]) sphere(r = 2.8, $fn = 14);
                translate([6.8, 5.5, 34.5]) sphere(r = 1.9, $fn = 12);
            }
            
            hull() {
                translate([0.0, 0.0, 25.0]) sphere(r = 2.8, $fn = 14);
                translate([-0.8, 1.4, 38.0]) sphere(r = 1.8, $fn = 12);
            }
            
            for (a = [0 : 45 : 315]) {
                rotate([0, 0, a])
                    hull() {
                        translate([base_r2 * 0.95, 0, 2.2]) sphere(r = 0.6, $fn = 10);
                        translate([2.6, 0.4, 21.0]) sphere(r = 0.4, $fn = 10);
                    }
            }
        }
    }
}

module leaf_cluster_dome(rx = 15.0, ry = 13.0, rz = 9.5, scale_count = 16) {
    color([0.22, 0.52, 0.25]) { // Lush Oak Leaf Green
        union() {
            translate([0, 0, -rz * 0.85])
                cylinder(r1 = 1.4, r2 = max(rx, ry) * 0.8, h = rz * 0.9);
            
            scale([1.0, ry / rx, rz / rx]) sphere(r = rx, $fn = 24);
            
            for (i = [0 : scale_count - 1]) {
                ang = i * (360 / scale_count);
                rotate([0, 0, ang]) {
                    translate([rx * 0.75, 0, -rz * 0.1])
                        rotate([20, 35, 15])
                            scale([1.3, 0.7, 0.8])
                                rotate([0, 45, 0])
                                    cube([rx * 0.42, rx * 0.42, rx * 0.42], center = true);
                }
            }
            
            translate([0, 0, rz * 0.5])
                scale([1.1, 0.9, 0.75]) sphere(r = rx * 0.55, $fn = 16);
        }
    }
}

module tree_swarm_03_oak() {
    union() {
        broadleaf_oak_trunk_2_25in();
        
        translate([-0.8, 1.4, 43.0]) rotate([0, 0, 15]) leaf_cluster_dome(rx = 17.5, ry = 15.5, rz = 11.5, scale_count = 18);
        translate([-8.5, -5.2, 37.0]) rotate([10, -12, 35]) leaf_cluster_dome(rx = 14.0, ry = 12.0, rz = 9.5, scale_count = 15);
        translate([7.8, 6.5, 37.5]) rotate([-8, 14, -20]) leaf_cluster_dome(rx = 14.5, ry = 12.5, rz = 9.8, scale_count = 15);
        translate([7.0, -4.5, 35.0]) rotate([12, 10, -45]) leaf_cluster_dome(rx = 12.0, ry = 10.5, rz = 8.5, scale_count = 13);
        translate([-6.5, 6.8, 36.0]) rotate([-10, -15, 60]) leaf_cluster_dome(rx = 12.5, ry = 10.8, rz = 8.5, scale_count = 13);
    }
}

tree_swarm_03_oak();
