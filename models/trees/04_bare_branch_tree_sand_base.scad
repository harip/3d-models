// ====================================================================
// 3D Printable Bare Branch / Winter Tree on Extreme Craggy Mountain Base
// Scale: ~46 mm (~1.81 inches) - Fits 1 to 2 inch scale requirement
// Features:
// - Extreme craggy mountain terrain base with low-poly rock facets
// - Integrated angular rock outcrop formations along mountain ridges
// - Multi-trunk base flaring into organic spreading wooden limbs
// - Intricate 3D network of primary, secondary & fine tertiary bare twigs
// ====================================================================

$fn = 28;

// Overall Dimensions (mm)
tree_total_h  = 46.0;  // ~1.81 inches
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
                    y = -r + yi * step,
                    z = 0
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
// 3. REUSABLE BRANCH SEGMENT HELPER
// --------------------------------------------------------------------
module branch_segment(p1, p2, r1, r2) {
    hull() {
        translate(p1) sphere(r = r1);
        translate(p2) sphere(r = r2);
    }
}

// --------------------------------------------------------------------
// 4. INTRICATE BARE BRANCH NETWORK MODULE
// --------------------------------------------------------------------
module bare_branch_network() {
    union() {
        branch_segment([ -1.5, 0.0, 0.8 ], [ -2.2, 0.5, 8.5 ], 3.2, 2.4);
        branch_segment([ -2.2, 0.5, 8.5 ], [ -3.5, 1.2, 16.5 ], 2.4, 1.8);
        
        branch_segment([ -3.5, 1.2, 16.5 ], [ -9.0, -3.5, 23.5 ], 1.8, 1.4);
        branch_segment([ -9.0, -3.5, 23.5 ], [ -14.5, -6.5, 29.5 ], 1.4, 1.0);
        branch_segment([ -9.0, -3.5, 23.5 ], [ -11.0, -0.5, 28.5 ], 1.2, 0.8);
        branch_segment([ -11.0, -0.5, 28.5 ], [ -13.5, 2.0, 34.5 ], 0.8, 0.5);
        branch_segment([ -14.5, -6.5, 29.5 ], [ -18.0, -9.0, 34.0 ], 1.0, 0.5);
        branch_segment([ -14.5, -6.5, 29.5 ], [ -15.5, -4.0, 35.5 ], 0.9, 0.5);
        
        branch_segment([ -3.5, 1.2, 16.5 ], [ -2.0, 3.5, 25.5 ], 1.7, 1.2);
        branch_segment([ -2.0, 3.5, 25.5 ], [ -4.5, 6.0, 33.5 ], 1.2, 0.9);
        branch_segment([ -4.5, 6.0, 33.5 ], [ -6.0, 8.5, 41.5 ], 0.9, 0.5);
        branch_segment([ -2.0, 3.5, 25.5 ], [ 1.5, 5.0, 31.5 ], 1.1, 0.7);
        branch_segment([ 1.5, 5.0, 31.5 ], [ 4.0, 7.5, 37.5 ], 0.7, 0.5);
        branch_segment([ -4.5, 6.0, 33.5 ], [ -1.5, 8.0, 39.0 ], 0.8, 0.5);

        branch_segment([ 1.8, -0.5, 0.8 ], [ 3.0, 0.0, 9.0 ], 3.0, 2.2);
        branch_segment([ 3.0, 0.0, 9.0 ], [ 4.8, -1.0, 17.5 ], 2.2, 1.6);
        
        branch_segment([ 4.8, -1.0, 17.5 ], [ 11.0, -4.5, 24.5 ], 1.6, 1.2);
        branch_segment([ 11.0, -4.5, 24.5 ], [ 17.5, -7.5, 30.5 ], 1.2, 0.9);
        branch_segment([ 11.0, -4.5, 24.5 ], [ 14.0, -1.0, 30.0 ], 1.0, 0.6);
        branch_segment([ 14.0, -1.0, 30.0 ], [ 17.0, 2.5, 35.5 ], 0.6, 0.5);
        branch_segment([ 17.5, -7.5, 30.5 ], [ 21.0, -9.5, 35.0 ], 0.8, 0.5);
        branch_segment([ 17.5, -7.5, 30.5 ], [ 19.5, -5.0, 36.5 ], 0.7, 0.5);
        
        branch_segment([ 4.8, -1.0, 17.5 ], [ 5.5, 2.5, 26.5 ], 1.5, 1.1);
        branch_segment([ 5.5, 2.5, 26.5 ], [ 8.0, 5.5, 34.5 ], 1.1, 0.8);
        branch_segment([ 8.0, 5.5, 34.5 ], [ 9.5, 7.5, 42.5 ], 0.8, 0.5);
        branch_segment([ 5.5, 2.5, 26.5 ], [ 2.0, 4.5, 32.5 ], 0.9, 0.6);
        branch_segment([ 2.0, 4.5, 32.5 ], [ 0.0, 7.0, 38.5 ], 0.6, 0.5);
        branch_segment([ 8.0, 5.5, 34.5 ], [ 12.0, 8.0, 40.0 ], 0.7, 0.5);

        branch_segment([ 0.0, 2.0, 0.8 ], [ 0.5, 3.2, 9.5 ], 2.5, 1.8);
        branch_segment([ 0.5, 3.2, 9.5 ], [ 0.0, 5.0, 18.5 ], 1.8, 1.3);
        branch_segment([ 0.0, 5.0, 18.5 ], [ -2.5, 8.0, 27.0 ], 1.3, 0.9);
        branch_segment([ -2.5, 8.0, 27.0 ], [ -4.0, 10.5, 35.5 ], 0.9, 0.5);
        branch_segment([ 0.0, 5.0, 18.5 ], [ 3.0, 7.5, 27.5 ], 1.1, 0.7);
        branch_segment([ 3.0, 7.5, 27.5 ], [ 5.5, 9.5, 36.0 ], 0.7, 0.5);

        root_pts = [
            [[-1.5, 0.0, 0.8], [-5.0, -2.5, 0.5]],
            [[1.8, -0.5, 0.8], [5.5, -3.0, 0.5]],
            [[0.0, 2.0, 0.8], [1.0, 5.5, 0.5]],
            [[-1.5, 0.0, 0.8], [-4.0, 3.0, 0.5]]
        ];
        for (rp = root_pts) {
            branch_segment(rp[0], rp[1], 2.8, 0.8);
        }
    }
}

// --------------------------------------------------------------------
// 5. COMPLETE BARE BRANCH TREE ASSEMBLY
// --------------------------------------------------------------------
module complete_bare_branch_tree() {
    union() {
        // 1. Extreme Craggy Mountain Base
        extreme_craggy_mountain_base(r = base_radius, grid_n = 32);
        
        // 2. Bare Branch Architecture sitting on mountain crag summit (Z = 6.4mm)
        translate([-0.2, -0.2, 6.4])
            bare_branch_network();
    }
}

// Render complete bare branch tree
complete_bare_branch_tree();
