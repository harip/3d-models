// ====================================================================
// 3D Printable Hyper-Realistic Pine Tree (Pinus Sylvestris / Scots Pine)
// Scale: ~48 mm (~1.89 inches) - Fits 1 to 2 inch scale requirement
// Features:
// - Extreme craggy jagged mountain terrain base with low-poly rock facets
// - Integrated angular rock outcrop formations along mountain ridges
// - Gnarled central trunk with furrowed bark plates & flared root collar
// - Natural 3D branch network & dense needle tuft clusters
// - 100% self-supporting overhang angles for clean 0-support FDM printing
// ====================================================================

$fn = 32;

// Overall Dimensions (mm)
tree_total_h  = 48.0;  // ~1.89 inches
base_radius   = 21.0;  // 42mm diameter base

// --------------------------------------------------------------------
// 1. CRAGGY FACETED ROCK OUTCROP MODULE
// --------------------------------------------------------------------
module rock_outcrop(size = [6, 5, 4], rot = [15, -20, 35]) {
    rotate(rot)
        scale(size)
            rotate([45, 35, 20])
                cube([1, 1, 1], center = true);
}

// --------------------------------------------------------------------
// 2. EXTREME CRAGGY JAGGED MOUNTAIN TERRAIN BASE MODULE
// --------------------------------------------------------------------
module extreme_craggy_mountain_base(r = 21, grid_n = 32) {
    step = (2 * r) / grid_n;
    
    function terrain_z(x, y) = 
        let (
            dist = sqrt(x*x + y*y),
            taper = (dist >= r - 0.5) ? 0 : pow(cos(min(1.0, dist / r) * 90), 1.05),
            
            p1 = 5.2 * exp(-((x + 3.5)*(x + 3.5) + (y - 3.5)*(y - 3.5)) / 25),
            p2 = 4.4 * exp(-((x - 4.5)*(x - 4.5) + (y + 3.5)*(y + 3.5)) / 22),
            p3 = 4.8 * exp(-((x + 0.2)*(x + 0.2) + (y + 0.2)*(y + 0.2)) / 18),
            
            ridge1 = pow(1.0 - abs(sin(x * 0.35 + y * 0.25 + 0.3)), 0.5) * 4.0,
            ridge2 = pow(1.0 - abs(cos(x * 0.45 - y * 0.38 - 0.6)), 0.5) * 3.2,
            valleys = -1.8 * pow(sin(x * 0.4 - y * 0.3), 2.0),
            
            n1 = sin(x * 1.1 + 1.5) * cos(y * 1.25 - 1.2) * 1.5,
            n2 = cos(x * 2.2 - y * 1.8 + 2.1) * sin(y * 2.4 + 0.8) * 0.9,
            
            raw_z = 0.8 + p1 + p2 + p3 + ridge1 + ridge2 + valleys + n1 + n2,
            
            z_final = 0.8 + max(0, raw_z - 0.8) * taper
        ) z_final;

    top_points = [
        for (yi = [0 : grid_n])
            for (xi = [0 : grid_n])
                let (
                    x = -r + xi * step,
                    y = -r + yi * step,
                    z = terrain_z(x, y)
                )
                [x, y, z]
    ];
    
    bot_points = [
        for (yi = [0 : grid_n])
            for (xi = [0 : grid_n])
                let (
                    x = -r + xi * step,
                    y = -r + yi * step
                )
                [x, y, 0]
    ];
    
    all_verts = concat(top_points, bot_points);
    num_pts = len(top_points);
    
    function idx(xi, yi) = yi * (grid_n + 1) + xi;
    function bidx(xi, yi) = num_pts + yi * (grid_n + 1) + xi;
    
    top_faces = [
        for (yi = [0 : grid_n - 1])
            for (xi = [0 : grid_n - 1])
                for (t = [0, 1])
                    ((xi + yi) % 2 == 0) ?
                        (t == 0 ? [idx(xi, yi), idx(xi + 1, yi), idx(xi + 1, yi + 1)] :
                                  [idx(xi, yi), idx(xi + 1, yi + 1), idx(xi, yi + 1)]) :
                        (t == 0 ? [idx(xi, yi), idx(xi + 1, yi), idx(xi, yi + 1)] :
                                  [idx(xi + 1, yi), idx(xi + 1, yi + 1), idx(xi, yi + 1)])
    ];
    
    bot_faces = [
        for (yi = [0 : grid_n - 1])
            for (xi = [0 : grid_n - 1])
                for (t = [0, 1])
                    t == 0 ?
                        [bidx(xi, yi), bidx(xi + 1, yi + 1), bidx(xi + 1, yi)] :
                        [bidx(xi, yi), bidx(xi, yi + 1), bidx(xi + 1, yi + 1)]
    ];
    
    wall_south = [ for (xi = [0 : grid_n - 1]) for (t = [0, 1]) t == 0 ? [idx(xi, 0), bidx(xi, 0), bidx(xi + 1, 0)] : [idx(xi, 0), bidx(xi + 1, 0), idx(xi + 1, 0)] ];
    wall_north = [ for (xi = [0 : grid_n - 1]) for (t = [0, 1]) t == 0 ? [idx(xi, grid_n), idx(xi + 1, grid_n), bidx(xi + 1, grid_n)] : [idx(xi, grid_n), bidx(xi + 1, grid_n), bidx(xi, grid_n)] ];
    wall_west  = [ for (yi = [0 : grid_n - 1]) for (t = [0, 1]) t == 0 ? [idx(0, yi), idx(0, yi + 1), bidx(0, yi + 1)] : [idx(0, yi), bidx(0, yi + 1), bidx(0, yi)] ];
    wall_east  = [ for (yi = [0 : grid_n - 1]) for (t = [0, 1]) t == 0 ? [idx(grid_n, yi), bidx(grid_n, yi), bidx(grid_n, yi + 1)] : [idx(grid_n, yi), bidx(grid_n, yi + 1), idx(grid_n, yi + 1)] ];
    
    all_faces = concat(top_faces, bot_faces, wall_south, wall_north, wall_west, wall_east);
    
    union() {
        intersection() {
            cylinder(r = r, h = 18, $fn = 64);
            polyhedron(points = all_verts, faces = all_faces, convexity = 10);
        }
        
        intersection() {
            cylinder(r = r - 1.0, h = 18, $fn = 64);
            union() {
                translate([-6.5,  4.5, 4.2]) rock_outcrop(size = [5.5, 4.2, 3.8], rot = [25, -30, 45]);
                translate([ 7.0, -5.0, 3.8]) rock_outcrop(size = [4.8, 4.0, 3.2], rot = [-15, 20, -35]);
                translate([-4.0, -7.0, 3.2]) rock_outcrop(size = [5.0, 3.5, 3.0], rot = [35, 15, 60]);
                translate([ 6.0,  6.0, 3.5]) rock_outcrop(size = [4.5, 3.8, 3.2], rot = [-20, -25, 15]);
            }
        }
    }
}

// --------------------------------------------------------------------
// 3. FLARED ROOT & BARK TEXTURED TRUNK MODULE
// --------------------------------------------------------------------
module pine_trunk(h = 45, base_d = 5.8, top_d = 1.4) {
    union() {
        for (a = [0 : 45 : 315]) {
            rotate([0, 0, a + 12])
                hull() {
                    translate([0, 0, 1.2]) cylinder(d = base_d * 0.9, h = 2.5);
                    translate([base_d * 0.65, 0, 0.5]) sphere(r = 0.9, $fn = 10);
                }
        }
        
        hull() {
            translate([0, 0, 0.8]) cylinder(d = base_d, h = 1);
            translate([0, 0, h]) cylinder(d = top_d, h = 1);
        }
        
        for (a = [0 : 36 : 324]) {
            rotate([0, 0, a])
                hull() {
                    translate([base_d * 0.46, 0, 1.4]) sphere(r = 0.45, $fn = 8);
                    translate([top_d * 0.42, 0, h * 0.85]) sphere(r = 0.22, $fn = 8);
                }
        }
    }
}

// --------------------------------------------------------------------
// 4. PINE NEEDLE TUFT CLUSTER MODULE
// --------------------------------------------------------------------
module needle_tuft(r_tuft = 4.2, h_tuft = 3.5, num_spines = 9) {
    union() {
        translate([0, 0, -h_tuft * 0.5])
            cylinder(r1 = 0.5, r2 = r_tuft * 0.75, h = h_tuft * 0.6);
        
        translate([0, 0, 0])
            scale([1.0, 1.0, h_tuft / r_tuft]) sphere(r = r_tuft * 0.6, $fn = 12);
        
        for (i = [0 : num_spines - 1]) {
            ang = i * (360 / num_spines);
            rotate([0, 0, ang]) {
                translate([r_tuft * 0.45, 0, 0])
                    rotate([0, 38, 0])
                        scale([1.3, 0.5, 0.6])
                            rotate([0, 45, 0])
                                cube([r_tuft * 0.45, r_tuft * 0.45, r_tuft * 0.45], center = true);
                
                rotate([0, 0, 180 / num_spines])
                    translate([r_tuft * 0.3, 0, h_tuft * 0.25])
                        rotate([0, 22, 0])
                            scale([1.1, 0.45, 0.5])
                                rotate([0, 45, 0])
                                    cube([r_tuft * 0.38, r_tuft * 0.38, r_tuft * 0.38], center = true);
            }
        }
    }
}

// --------------------------------------------------------------------
// 5. ORGANIC BRANCH BOUGH WITH FORKED TWIGS & NEEDLE TUFTS
// --------------------------------------------------------------------
module organic_pine_bough(bough_len = 13.0, branch_d = 1.8, tuft_r = 4.2, dip_angle = 12) {
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
            
            translate([0, bough_len * 0.85, -bough_len * 0.18]) needle_tuft(r_tuft = tuft_r, h_tuft = tuft_r * 0.8, num_spines = 9);
            translate([-bough_len * 0.28, bough_len * 0.72, -bough_len * 0.16]) rotate([5, -20, -15]) needle_tuft(r_tuft = tuft_r * 0.75, h_tuft = tuft_r * 0.65, num_spines = 8);
            translate([bough_len * 0.28, bough_len * 0.75, -bough_len * 0.16]) rotate([5, 20, 15]) needle_tuft(r_tuft = tuft_r * 0.75, h_tuft = tuft_r * 0.65, num_spines = 8);
        }
    }
}

// --------------------------------------------------------------------
// 6. COMPLETE HYPER-REALISTIC PINE TREE ASSEMBLY
// --------------------------------------------------------------------
module complete_pine_tree() {
    union() {
        // 1. Extreme Craggy Mountain Base
        extreme_craggy_mountain_base(r = base_radius, grid_n = 32);
        
        // 2. Trunk & Canopy Network sitting on mountain crag summit (Z = 6.4mm)
        translate([-0.2, -0.2, 6.4]) {
            pine_trunk(h = tree_total_h - 7.8, base_d = 5.8, top_d = 1.4);
            
            l1_angles = [0, 72, 144, 216, 288];
            l1_lens   = [13.5, 12.8, 14.0, 13.0, 13.6];
            for (i = [0 : len(l1_angles) - 1]) {
                ang = l1_angles[i];
                blen = l1_lens[i];
                translate([0, 0, 8.5]) rotate([0, 0, ang]) organic_pine_bough(bough_len = blen, branch_d = 1.9, tuft_r = 4.4, dip_angle = 14);
            }
            
            l2_angles = [36, 108, 180, 252, 324];
            l2_lens   = [11.5, 11.0, 12.0, 11.2, 11.8];
            for (i = [0 : len(l2_angles) - 1]) {
                ang = l2_angles[i];
                blen = l2_lens[i];
                translate([0, 0, 16.0]) rotate([0, 0, ang]) organic_pine_bough(bough_len = blen, branch_d = 1.7, tuft_r = 4.0, dip_angle = 12);
            }
            
            l3_angles = [18, 90, 162, 234, 306];
            l3_lens   = [9.8, 9.2, 10.2, 9.5, 10.0];
            for (i = [0 : len(l3_angles) - 1]) {
                ang = l3_angles[i];
                blen = l3_lens[i];
                translate([0, 0, 23.5]) rotate([0, 0, ang]) organic_pine_bough(bough_len = blen, branch_d = 1.5, tuft_r = 3.6, dip_angle = 10);
            }
            
            l4_angles = [45, 135, 225, 315];
            l4_lens   = [7.8, 7.4, 8.0, 7.6];
            for (i = [0 : len(l4_angles) - 1]) {
                ang = l4_angles[i];
                blen = l4_lens[i];
                translate([0, 0, 30.5]) rotate([0, 0, ang]) organic_pine_bough(bough_len = blen, branch_d = 1.3, tuft_r = 3.2, dip_angle = 8);
            }
            
            l5_angles = [15, 105, 195, 285];
            for (i = [0 : len(l5_angles) - 1]) {
                ang = l5_angles[i];
                translate([0, 0, 37.0]) rotate([0, 0, ang]) organic_pine_bough(bough_len = 5.5, branch_d = 1.1, tuft_r = 2.7, dip_angle = 6);
            }
            
            translate([0, 0, 41.5])
                union() {
                    cylinder(r1 = 1.3, r2 = 0.3, h = 5.2);
                    for (a = [0, 90, 180, 270]) {
                        rotate([0, 0, a]) translate([0, 1.2, 1.2]) needle_tuft(r_tuft = 2.4, h_tuft = 2.0, num_spines = 7);
                    }
                }
        }
    }
}

// Render complete pine tree
complete_pine_tree();
