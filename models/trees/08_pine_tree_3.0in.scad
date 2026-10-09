// ====================================================================
// 3D Printable Pine Tree (Pinus Sylvestris)
// Height: 3.0 inches (76.2 mm)
// Features:
// - Botanically accurate pine architecture (central tapered trunk, organic root flare)
// - 5 layered bough tiers with dipping branches & starburst needle sprays
// - Smooth flared root foot flat on Z=0 for high stability & print bed adhesion
// - 100% 3D Printable, 0% print supports required
// ====================================================================

$fn = 32;

module pine_needle_tuft(r_tuft = 5.2, h_tuft = 4.4, num_spines = 10) {
    color([0.14, 0.40, 0.18]) { // Deep Forest Pine Green
        union() {
            // Self-supporting core cone base
            translate([0, 0, -h_tuft * 0.4])
                cylinder(r1 = 0.7, r2 = r_tuft * 0.72, h = h_tuft * 0.75);
            
            // Central body dome
            scale([1.0, 1.0, h_tuft / r_tuft]) 
                sphere(r = r_tuft * 0.58, $fn = 14);
            
            // Starburst radiating needles angled upwards (36 degrees)
            for (i = [0 : num_spines - 1]) {
                ang = i * (360 / num_spines);
                rotate([0, 0, ang]) {
                    translate([r_tuft * 0.42, 0, 0])
                        rotate([0, 36, 0])
                            scale([1.25, 0.45, 0.55])
                                rotate([0, 45, 0])
                                    cube([r_tuft * 0.42, r_tuft * 0.42, r_tuft * 0.42], center = true);
                }
            }
        }
    }
}

module pine_bough_unit(bough_len = 17.0, branch_d = 2.4, tuft_r = 5.5, dip_angle = 12) {
    color([0.42, 0.26, 0.14]) { // Sienna Bark Brown
        rotate([dip_angle, 0, 0]) {
            union() {
                // Primary branch arm tapering outward
                hull() {
                    translate([0, 0, 0]) cylinder(d = branch_d, h = 0.8);
                    translate([0, bough_len * 0.55, -bough_len * 0.08]) cylinder(d = branch_d * 0.65, h = 0.8);
                }
                hull() {
                    translate([0, bough_len * 0.55, -bough_len * 0.08]) cylinder(d = branch_d * 0.65, h = 0.8);
                    translate([0, bough_len * 0.92, -bough_len * 0.04]) cylinder(d = branch_d * 0.38, h = 0.8);
                }
                
                // Left lateral spray branch
                hull() {
                    translate([0, bough_len * 0.35, -bough_len * 0.05]) sphere(r = branch_d * 0.32, $fn = 8);
                    translate([-bough_len * 0.30, bough_len * 0.68, -bough_len * 0.10]) sphere(r = branch_d * 0.22, $fn = 8);
                }
                
                // Right lateral spray branch
                hull() {
                    translate([0, bough_len * 0.40, -bough_len * 0.05]) sphere(r = branch_d * 0.32, $fn = 8);
                    translate([bough_len * 0.30, bough_len * 0.70, -bough_len * 0.10]) sphere(r = branch_d * 0.22, $fn = 8);
                }
                
                // Needle tuft clusters
                translate([0, bough_len * 0.94, -bough_len * 0.03]) 
                    pine_needle_tuft(r_tuft = tuft_r, h_tuft = tuft_r * 0.85, num_spines = 10);
                    
                translate([-bough_len * 0.30, bough_len * 0.68, -bough_len * 0.09]) 
                    rotate([4, -18, -14]) pine_needle_tuft(r_tuft = tuft_r * 0.78, h_tuft = tuft_r * 0.68, num_spines = 8);
                    
                translate([bough_len * 0.30, bough_len * 0.70, -bough_len * 0.09]) 
                    rotate([4, 18, 14]) pine_needle_tuft(r_tuft = tuft_r * 0.78, h_tuft = tuft_r * 0.68, num_spines = 8);
            }
        }
    }
}

module pine_tree_3in() {
    h = 76.2; // 3.0 inches in mm
    base_r1 = 9.5; // 19mm wide base foot
    base_r2 = 4.4;
    
    union() {
        // Trunk & Flared Base Foot
        color([0.42, 0.26, 0.14]) {
            union() {
                cylinder(r1 = base_r1, r2 = base_r2, h = 6.8);
                
                hull() {
                    translate([0, 0, 4.0]) cylinder(r1 = base_r2, r2 = 2.2, h = h * 0.82);
                    translate([0, 0, h - 6.0]) cylinder(r1 = 2.2, r2 = 1.0, h = 5.0);
                }
                
                // Organic flared root buttresses flat on Z=0
                for (a = [0 : 60 : 300]) {
                    rotate([0, 0, a])
                        hull() {
                            translate([base_r1 * 0.92, 0, 0.4]) sphere(r = 0.65, $fn = 8);
                            translate([base_r2 * 0.90, 0, 3.2]) sphere(r = 0.40, $fn = 8);
                        }
                }
            }
        }
        
        // Tier 1 (Lowest Boughs - 5 branches, widest spread)
        l1_angles = [0, 72, 144, 216, 288];
        l1_lens   = [22.0, 20.5, 22.5, 21.0, 22.0];
        for (i = [0 : len(l1_angles) - 1]) {
            translate([0, 0, h * 0.22]) 
                rotate([0, 0, l1_angles[i]]) 
                    pine_bough_unit(bough_len = l1_lens[i], branch_d = 2.5, tuft_r = 6.2, dip_angle = 14);
        }
        
        // Tier 2 (Mid-Low Boughs - 5 branches)
        l2_angles = [36, 108, 180, 252, 324];
        l2_lens   = [18.5, 17.5, 19.0, 18.0, 18.5];
        for (i = [0 : len(l2_angles) - 1]) {
            translate([0, 0, h * 0.38]) 
                rotate([0, 0, l2_angles[i]]) 
                    pine_bough_unit(bough_len = l2_lens[i], branch_d = 2.2, tuft_r = 5.5, dip_angle = 12);
        }
        
        // Tier 3 (Mid-Upper Boughs - 4 branches)
        l3_angles = [18, 108, 198, 288];
        l3_lens   = [15.5, 14.5, 16.0, 15.0];
        for (i = [0 : len(l3_angles) - 1]) {
            translate([0, 0, h * 0.54]) 
                rotate([0, 0, l3_angles[i]]) 
                    pine_bough_unit(bough_len = l3_lens[i], branch_d = 1.9, tuft_r = 4.8, dip_angle = 10);
        }
        
        // Tier 4 (Upper Boughs - 4 branches)
        l4_angles = [54, 144, 234, 324];
        l4_lens   = [12.0, 11.2, 12.5, 11.8];
        for (i = [0 : len(l4_angles) - 1]) {
            translate([0, 0, h * 0.68]) 
                rotate([0, 0, l4_angles[i]]) 
                    pine_bough_unit(bough_len = l4_lens[i], branch_d = 1.6, tuft_r = 4.2, dip_angle = 8);
        }
        
        // Tier 5 (Near-Top Boughs - 3 small sprigs)
        l5_angles = [30, 150, 270];
        l5_lens   = [8.8, 8.2, 8.5];
        for (i = [0 : len(l5_angles) - 1]) {
            translate([0, 0, h * 0.80]) 
                rotate([0, 0, l5_angles[i]]) 
                    pine_bough_unit(bough_len = l5_lens[i], branch_d = 1.3, tuft_r = 3.6, dip_angle = 6);
        }
        
        // Crown Leader Spire & Top Needle Tufts
        translate([0, 0, h - 7.5])
            color([0.14, 0.40, 0.18]) {
                union() {
                    cylinder(r1 = 1.4, r2 = 0.4, h = 8.5);
                    for (c_a = [0, 90, 180, 270]) {
                        rotate([0, 0, c_a]) 
                            translate([0, 1.4, 2.2]) 
                                pine_needle_tuft(r_tuft = 3.2, h_tuft = 2.8, num_spines = 7);
                    }
                }
            }
    }
}

pine_tree_3in();
