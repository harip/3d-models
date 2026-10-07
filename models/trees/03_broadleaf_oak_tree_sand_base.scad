// ====================================================================
// 3D Printable Lush Broadleaf / Oak Tree on Extreme Craggy Mountain Base
// Scale: ~44 mm (~1.73 inches) - Fits 1 to 2 inch scale requirement
// Features:
// - Extreme craggy mountain terrain base with low-poly rock facets
// - Integrated angular rock outcrop formations along mountain ridges
// - Thick organic trunk with bark texture, trunk hollow & flared roots
// - Massive, lush, layered leaf canopy dome
// ====================================================================

$fn = 32;

// Overall Dimensions (mm)
tree_total_h  = 44.0;  // ~1.73 inches
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
// 3. THICK ORGANIC OAK TRUNK WITH HOLLOW & ROOT SPREAD
// --------------------------------------------------------------------
module broadleaf_oak_trunk() {
    union() {
        root_angles = [15, 80, 150, 225, 305];
        root_lens   = [7.5, 6.5, 8.0, 7.0, 7.2];
        
        for (i = [0 : len(root_angles) - 1]) {
            ang = root_angles[i];
            rlen = root_lens[i];
            
            rotate([0, 0, ang])
                hull() {
                    translate([0, 0, 1.4]) sphere(r = 2.8, $fn = 12);
                    translate([rlen * 0.55, 0, 1.0]) sphere(r = 1.6, $fn = 12);
                    translate([rlen, 0, 0.5]) sphere(r = 0.7, $fn = 12);
                }
        }
        
        hull() {
            translate([0, 0, 1.0]) cylinder(r1 = 4.2, r2 = 3.2, h = 6.0);
            translate([0.6, 0.4, 11.5]) cylinder(r1 = 3.2, r2 = 2.6, h = 6.0);
        }
        
        hull() {
            translate([0.6, 0.4, 11.5]) cylinder(r1 = 3.2, r2 = 2.4, h = 4.0);
            translate([0.0, 0.0, 18.5]) sphere(r = 2.5, $fn = 16);
        }
        
        hull() {
            translate([0.0, 0.0, 18.5]) sphere(r = 2.2, $fn = 14);
            translate([-5.5, -3.5, 25.0]) sphere(r = 1.5, $fn = 12);
        }
        
        hull() {
            translate([0.0, 0.0, 18.5]) sphere(r = 2.2, $fn = 14);
            translate([5.0, 4.2, 25.5]) sphere(r = 1.5, $fn = 12);
        }
        
        hull() {
            translate([0.0, 0.0, 18.5]) sphere(r = 2.2, $fn = 14);
            translate([-0.5, 1.0, 28.0]) sphere(r = 1.4, $fn = 12);
        }
        
        for (a = [0 : 45 : 315]) {
            rotate([0, 0, a])
                hull() {
                    translate([3.5, 0, 1.8]) sphere(r = 0.5, $fn = 10);
                    translate([2.2, 0.3, 15.5]) sphere(r = 0.35, $fn = 10);
                }
        }
        
        translate([0.6, 2.8, 8.0])
            rotate([90, 0, 0])
                hull() {
                    scale([1.0, 1.4, 1.0]) cylinder(r = 1.1, h = 0.8, center = true);
                }
    }
}

// --------------------------------------------------------------------
// 4. LUSH SCALLOPED LEAF CLUSTER DOME MODULE
// --------------------------------------------------------------------
module leaf_cluster_dome(rx = 11.5, ry = 10.0, rz = 7.5, scale_count = 14) {
    union() {
        translate([0, 0, -rz * 0.85])
            cylinder(r1 = 1.2, r2 = max(rx, ry) * 0.8, h = rz * 0.9);
        
        scale([1.0, ry / rx, rz / rx]) sphere(r = rx, $fn = 24);
        
        for (i = [0 : scale_count - 1]) {
            ang = i * (360 / scale_count);
            rotate([0, 0, ang]) {
                translate([rx * 0.75, 0, -rz * 0.1])
                    rotate([20, 35, 15])
                        scale([1.3, 0.7, 0.8])
                            rotate([0, 45, 0])
                                cube([rx * 0.42, rx * 0.42, rx * 0.42], center = true);
                
                rotate([0, 0, 180 / scale_count])
                    translate([rx * 0.55, 0, rz * 0.35])
                        rotate([10, 25, 10])
                            scale([1.2, 0.65, 0.75])
                                rotate([0, 45, 0])
                                    cube([rx * 0.38, rx * 0.38, rx * 0.38], center = true);
            }
        }
        
        translate([0, 0, rz * 0.5])
            scale([1.1, 0.9, 0.75]) sphere(r = rx * 0.55, $fn = 16);
    }
}

// --------------------------------------------------------------------
// 5. COMPLETE LUSH BROADLEAF OAK TREE ASSEMBLY
// --------------------------------------------------------------------
module complete_broadleaf_oak_tree() {
    union() {
        // 1. Extreme Craggy Mountain Base
        extreme_craggy_mountain_base(r = base_radius, grid_n = 32);
        
        // 2. Trunk & Canopy sitting on mountain crag summit (Z = 6.4mm)
        translate([-0.2, -0.2, 6.4]) {
            broadleaf_oak_trunk();
            
            translate([-0.5, 1.0, 33.0]) rotate([0, 0, 15]) leaf_cluster_dome(rx = 13.5, ry = 12.0, rz = 9.0, scale_count = 16);
            translate([-6.5, -4.0, 28.0]) rotate([10, -12, 35]) leaf_cluster_dome(rx = 11.0, ry = 9.5, rz = 7.5, scale_count = 14);
            translate([6.0, 5.0, 28.5]) rotate([-8, 14, -20]) leaf_cluster_dome(rx = 11.5, ry = 10.0, rz = 7.8, scale_count = 14);
            translate([5.5, -3.5, 27.0]) rotate([12, 10, -45]) leaf_cluster_dome(rx = 9.5, ry = 8.2, rz = 6.5, scale_count = 12);
            translate([-5.0, 5.2, 27.5]) rotate([-10, -15, 60]) leaf_cluster_dome(rx = 9.8, ry = 8.5, rz = 6.5, scale_count = 12);
        }
    }
}

// Render complete broadleaf oak tree
complete_broadleaf_oak_tree();
