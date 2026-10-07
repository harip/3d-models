// ====================================================================
// 3D Printable Stylized Alpine Chalet Pine Tree on Extreme Craggy Mountain Base
// Scale: ~45 mm (~1.77 inches) - Fits 1 to 2 inch scale requirement
// Features:
// - Extreme craggy mountain terrain base with low-poly rock facets
// - Integrated angular rock outcrop formations along mountain ridges
// - Clean stylized 4-tiered conical foliage shells with 45° self-supporting slope
// - Tapered trunk with flared root base
// ====================================================================

$fn = 36;

// Overall Dimensions (mm)
tree_total_h  = 45.0;  // ~1.77 inches
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
// 3. STYLIZED ALPINE PINE TREE MODULE
// --------------------------------------------------------------------
module alpine_chalet_pine_tree(h = 42) {
    trunk_d = max(3.5, h * 0.16);
    trunk_h = h * 0.35;
    
    union() {
        for (a = [0 : 60 : 300]) {
            rotate([0, 0, a + 15])
                hull() {
                    translate([0, 0, 1.2]) cylinder(d = trunk_d, h = 2.5);
                    translate([trunk_d * 0.75, 0, 0.5]) sphere(r = 0.9, $fn = 10);
                }
        }
        
        cylinder(d1 = trunk_d * 1.1, d2 = trunk_d * 0.4, h = trunk_h);
        
        num_tiers = 4;
        for (i = [0 : num_tiers - 1]) {
            tier_z = trunk_h * 0.5 + i * (h * 0.18);
            tier_d1 = (h * 0.65) * (1.0 - i * 0.21);
            tier_d2 = max(0.6, tier_d1 * 0.22);
            tier_h  = h * 0.35;
            
            translate([0, 0, tier_z])
                union() {
                    cylinder(d1 = tier_d1, d2 = tier_d2, h = tier_h);
                    cylinder(r1 = tier_d1 * 0.2, r2 = tier_d1 * 0.5, h = tier_h * 0.3);
                }
        }
    }
}

// --------------------------------------------------------------------
// 4. COMPLETE ALPINE CHALET PINE TREE ASSEMBLY
// --------------------------------------------------------------------
module complete_alpine_chalet_pine_tree() {
    union() {
        // 1. Extreme Craggy Mountain Base
        extreme_craggy_mountain_base(r = base_radius, grid_n = 32);
        
        // 2. Alpine Chalet Stylized Pine Tree sitting on mountain crag summit (Z = 6.4mm)
        translate([-0.2, -0.2, 6.4])
            alpine_chalet_pine_tree(h = tree_total_h - 7.8);
    }
}

// Render complete tree
complete_alpine_chalet_pine_tree();
