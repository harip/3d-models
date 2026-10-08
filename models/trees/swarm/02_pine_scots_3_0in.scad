// ====================================================================
// Tree Swarm #2: Scots Pine (Pinus Sylvestris)
// Scale: 3.0 inches (76.2 mm height)
// Style: Smooth flared trunk base foot (0 terrain base, 0 protrusions)
// 100% 3D Printable, 0% supports needed
// ====================================================================

$fn = 36;

tree_height = 76.2; // 3.0 inches
base_r1     = 9.5;  // 19mm wide smooth flared base foot
base_r2     = 4.5;

module pine_trunk_3_0in(h = 72.0) {
    color([0.45, 0.28, 0.15]) { // Sienna Brown
        union() {
            // Smooth wide flared trunk base foot (sitting flat on Z=0)
            cylinder(r1 = base_r1, r2 = base_r2, h = 8.5);
            
            hull() {
                translate([0, 0, 5.0]) cylinder(r1 = base_r2, r2 = 2.2, h = h * 0.85);
                translate([0, 0, h]) cylinder(d = 1.8, h = 1);
            }
            
            for (a = [0 : 36 : 324]) {
                rotate([0, 0, a])
                    hull() {
                        translate([base_r2 * 0.95, 0, 2.2]) sphere(r = 0.5, $fn = 8);
                        translate([1.0, 0, h * 0.82]) sphere(r = 0.25, $fn = 8);
                    }
            }
        }
    }
}

module needle_tuft(r_tuft = 6.2, h_tuft = 5.0, num_spines = 10) {
    color([0.15, 0.42, 0.20]) { // Dark Forest Pine Green
        union() {
            translate([0, 0, -h_tuft * 0.5])
                cylinder(r1 = 0.8, r2 = r_tuft * 0.75, h = h_tuft * 0.6);
            
            scale([1.0, 1.0, h_tuft / r_tuft]) sphere(r = r_tuft * 0.6, $fn = 14);
            
            for (i = [0 : num_spines - 1]) {
                ang = i * (360 / num_spines);
                rotate([0, 0, ang]) {
                    translate([r_tuft * 0.45, 0, 0])
                        rotate([0, 38, 0])
                            scale([1.3, 0.5, 0.6])
                                rotate([0, 45, 0])
                                    cube([r_tuft * 0.45, r_tuft * 0.45, r_tuft * 0.45], center = true);
                }
            }
        }
    }
}

module organic_pine_bough(bough_len = 18.0, branch_d = 2.4, tuft_r = 6.0, dip_angle = 12) {
    color([0.45, 0.28, 0.15]) {
        rotate([dip_angle, 0, 0]) {
            union() {
                hull() {
                    translate([0, 0, 0]) cylinder(d = branch_d, h = 1.0);
                    translate([0, bough_len * 0.5, -bough_len * 0.1]) cylinder(d = branch_d * 0.65, h = 1.0);
                }
                
                hull() {
                    translate([0, bough_len * 0.4, -bough_len * 0.08]) sphere(r = branch_d * 0.3, $fn = 8);
                    translate([-bough_len * 0.28, bough_len * 0.72, -bough_len * 0.15]) sphere(r = branch_d * 0.2, $fn = 8);
                }
                
                hull() {
                    translate([0, bough_len * 0.45, -bough_len * 0.09]) sphere(r = branch_d * 0.3, $fn = 8);
                    translate([bough_len * 0.28, bough_len * 0.75, -bough_len * 0.15]) sphere(r = branch_d * 0.2, $fn = 8);
                }
                
                translate([0, bough_len * 0.85, -bough_len * 0.18]) needle_tuft(r_tuft = tuft_r, h_tuft = tuft_r * 0.85, num_spines = 10);
                translate([-bough_len * 0.28, bough_len * 0.72, -bough_len * 0.16]) rotate([5, -20, -15]) needle_tuft(r_tuft = tuft_r * 0.78, h_tuft = tuft_r * 0.7, num_spines = 9);
                translate([bough_len * 0.28, bough_len * 0.75, -bough_len * 0.16]) rotate([5, 20, 15]) needle_tuft(r_tuft = tuft_r * 0.78, h_tuft = tuft_r * 0.7, num_spines = 9);
            }
        }
    }
}

module tree_swarm_02_pine() {
    union() {
        pine_trunk_3_0in(h = tree_height - 6.0);
        
        // 5 Bough Tiers
        l1_angles = [0, 72, 144, 216, 288];
        l1_lens   = [21.0, 19.5, 22.0, 20.0, 21.5];
        for (i = [0 : len(l1_angles) - 1]) {
            ang = l1_angles[i];
            blen = l1_lens[i];
            translate([0, 0, 16.0]) rotate([0, 0, ang]) organic_pine_bough(bough_len = blen, branch_d = 2.6, tuft_r = 6.8, dip_angle = 14);
        }
        
        l2_angles = [36, 108, 180, 252, 324];
        l2_lens   = [18.0, 17.2, 18.8, 17.5, 18.2];
        for (i = [0 : len(l2_angles) - 1]) {
            ang = l2_angles[i];
            blen = l2_lens[i];
            translate([0, 0, 28.0]) rotate([0, 0, ang]) organic_pine_bough(bough_len = blen, branch_d = 2.3, tuft_r = 6.2, dip_angle = 12);
        }
        
        l3_angles = [18, 90, 162, 234, 306];
        l3_lens   = [15.0, 14.2, 15.5, 14.8, 15.2];
        for (i = [0 : len(l3_angles) - 1]) {
            ang = l3_angles[i];
            blen = l3_lens[i];
            translate([0, 0, 40.0]) rotate([0, 0, ang]) organic_pine_bough(bough_len = blen, branch_d = 2.0, tuft_r = 5.5, dip_angle = 10);
        }
        
        l4_angles = [45, 135, 225, 315];
        l4_lens   = [12.0, 11.5, 12.2, 11.8];
        for (i = [0 : len(l4_angles) - 1]) {
            ang = l4_angles[i];
            blen = l4_lens[i];
            translate([0, 0, 52.0]) rotate([0, 0, ang]) organic_pine_bough(bough_len = blen, branch_d = 1.7, tuft_r = 4.8, dip_angle = 8);
        }
        
        l5_angles = [15, 105, 195, 285];
        for (i = [0 : len(l5_angles) - 1]) {
            ang = l5_angles[i];
            translate([0, 0, 62.0]) rotate([0, 0, ang]) organic_pine_bough(bough_len = 8.5, branch_d = 1.4, tuft_r = 4.0, dip_angle = 6);
        }
        
        translate([0, 0, 68.0])
            color([0.15, 0.42, 0.20]) {
                union() {
                    cylinder(r1 = 1.8, r2 = 0.4, h = 8.2);
                    for (a = [0, 90, 180, 270]) {
                        rotate([0, 0, a]) translate([0, 1.8, 2.2]) needle_tuft(r_tuft = 3.6, h_tuft = 3.0, num_spines = 8);
                    }
                }
            }
    }
}

tree_swarm_02_pine();
