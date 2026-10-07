// ====================================================================
// 3D Printable Windswept Coastal Cypress Tree on Multi-Feature Terrain Base
// Scale: ~40 mm (~1.57 inches) - Fits 1 to 2 inch scale requirement
// Features:
// - Combination of sharp rock needles/crag ridges & smooth rolling hill mounds
// - Watertight 3D polyhedron terrain base with flat bottom bed interface
// - Crisp Light Ivory Cream color styling (`color([0.96, 0.94, 0.88])`) for maximum contour contrast
// - Parameterized grid resolution, base size, minimum thickness, and max mountain height
// - Organic S-curved cypress trunk emerging naturally from center mountain summit
// - Multi-lobed cloud canopy foliage pads textured with leaf clusters
// ====================================================================

$fn = 32;

// --------------------------------------------------------------------
// USER TWEAKABLE PARAMETERS (Top of Script)
// --------------------------------------------------------------------
grid_resolution  = 48;    // High grid density for sharp/smooth micro-features
base_radius      = 20.0;  // Base radius (40mm diameter base disc)
base_min_thick   = 1.0;   // Minimum base thickness (mm) for flat 3D print bed
max_mountain_h   = 6.8;   // Maximum mountain height (mm)
tree_total_h     = 40.0;  // Overall tree height (mm)

// --------------------------------------------------------------------
// 1. SHARP & SMOOTH MULTI-FEATURE TERRAIN BASE MODULE (Pure Polar Polyhedron)
// --------------------------------------------------------------------
module multi_feature_terrain_base(r = base_radius, rings = 28, sectors = 64, min_h = base_min_thick, max_h = max_mountain_h) {
    function terrain_z(x, y) = 
        let (
            dist = sqrt(x*x + y*y),
            norm_d = min(1.0, dist / r),
            taper = pow(cos(norm_d * 90), 1.15),
            
            // Domain warping for organic winding canyon paths
            wx = x + 1.8 * sin(y * 0.22 + 0.6) + 1.0 * cos(x * 0.45),
            wy = y + 1.8 * cos(x * 0.20 - 0.8) + 1.0 * sin(y * 0.42),
            
            // 1. SMOOTH FEATURES: Rolling hills, broad mounds & gentle saddles
            smooth_h1 = 3.2 * exp(-((wx + 0.2)*(wx + 0.2) + (wy + 0.2)*(wy + 0.2)) / 35),
            smooth_h2 = 2.4 * exp(-((wx + 6.5)*(wx + 6.5) + (wy - 5.5)*(wy - 5.5)) / 28),
            smooth_h3 = 2.2 * exp(-((wx - 6.0)*(wx - 6.0) + (wy + 6.0)*(wy + 6.0)) / 25),
            smooth_waves = 1.2 * sin(wx * 0.28) * cos(wy * 0.24) + 0.8 * cos(wx * 0.18 + wy * 0.32),
            
            // 2. SHARP FEATURES: Sharp rock needle peaks, knife-edge crags & V-cut gullies
            needle1 = 2.8 * exp(-((wx - 5.5)*(wx - 5.5) + (wy - 4.5)*(wy - 4.5)) / 6.0),
            needle2 = 2.4 * exp(-((wx + 5.0)*(wx + 5.0) + (wy + 5.5)*(wy + 5.5)) / 5.0),
            needle3 = 2.2 * exp(-((wx - 3.8)*(wx - 3.8) + (wy + 4.2)*(wy + 4.2)) / 4.5),
            needle4 = 2.0 * exp(-((wx + 4.2)*(wx + 4.2) + (wy - 6.0)*(wy - 6.0)) / 4.0),
            
            sharp_ridges  = 1.8 * pow(1.0 - abs(sin(wx * 0.45 + wy * 0.35)), 0.4),
            sharp_gullies = -1.6 * pow(abs(cos(wx * 0.38 - wy * 0.42)), 0.4),
            
            raw_h = min_h + smooth_h1 + smooth_h2 + smooth_h3 + smooth_waves + needle1 + needle2 + needle3 + needle4 + sharp_ridges + sharp_gullies,
            
            step_height = 1.5,
            norm_h = raw_h / step_height,
            floor_h = floor(norm_h),
            frac_h = norm_h - floor_h,
            cliff_frac = pow(frac_h, 3.5) / (pow(frac_h, 3.5) + pow(1.0 - frac_h, 3.5)),
            stepped_h = (floor_h + cliff_frac) * step_height,
            
            micro_texture = 0.35 * sin(x * 1.6 + y * 1.3) * cos(x * 1.9 - y * 1.7),
            
            z_final = min_h + max(0, stepped_h + micro_texture - min_h) * taper
        ) (dist >= r - 0.01 ? min_h : z_final);

    top_center = [[0, 0, terrain_z(0, 0)]];
    bot_center = [[0, 0, 0]];
    
    top_ring_points = [
        for (ri = [1 : rings])
            let (R = (ri / rings) * r)
            for (si = [0 : sectors - 1])
                let (
                    ang = si * (360 / sectors),
                    x = R * cos(ang),
                    y = R * sin(ang),
                    z = terrain_z(x, y)
                )
                [x, y, z]
    ];
    
    bot_ring_points = [
        for (ri = [1 : rings])
            let (R = (ri / rings) * r)
            for (si = [0 : sectors - 1])
                let (
                    ang = si * (360 / sectors),
                    x = R * cos(ang),
                    y = R * sin(ang)
                )
                [x, y, 0]
    ];
    
    top_verts = concat(top_center, top_ring_points);
    bot_verts = concat(bot_center, bot_ring_points);
    all_verts = concat(top_verts, bot_verts);
    
    num_top = len(top_verts);
    
    function p_idx(ri, si) = (ri == 0) ? 0 : 1 + (ri - 1) * sectors + (si % sectors);
    function b_idx(ri, si) = num_top + p_idx(ri, si);
    
    top_center_faces = [
        for (si = [0 : sectors - 1])
            [0, p_idx(1, si), p_idx(1, si + 1)]
    ];
    
    bot_center_faces = [
        for (si = [0 : sectors - 1])
            [b_idx(0, 0), b_idx(1, si + 1), b_idx(1, si)]
    ];
    
    top_ring_faces = [
        for (ri = [1 : rings - 1])
            for (si = [0 : sectors - 1])
                for (t = [0, 1])
                    t == 0 ?
                        [p_idx(ri, si), p_idx(ri + 1, si), p_idx(ri + 1, si + 1)] :
                        [p_idx(ri, si), p_idx(ri + 1, si + 1), p_idx(ri, si + 1)]
    ];
    
    bot_ring_faces = [
        for (ri = [1 : rings - 1])
            for (si = [0 : sectors - 1])
                for (t = [0, 1])
                    t == 0 ?
                        [b_idx(ri, si), b_idx(ri + 1, si + 1), b_idx(ri + 1, si)] :
                        [b_idx(ri, si), b_idx(ri, si + 1), b_idx(ri + 1, si + 1)]
    ];
    
    wall_faces = [
        for (si = [0 : sectors - 1])
            for (t = [0, 1])
                t == 0 ?
                    [p_idx(rings, si), b_idx(rings, si), b_idx(rings, si + 1)] :
                    [p_idx(rings, si), b_idx(rings, si + 1), p_idx(rings, si + 1)]
    ];
    
    all_faces = concat(top_center_faces, top_ring_faces, bot_center_faces, bot_ring_faces, wall_faces);
    
    // Vibrant Light Warm Ivory Sand Color ([0.98, 0.95, 0.78])
    color([0.98, 0.95, 0.78])
        polyhedron(points = all_verts, faces = all_faces, convexity = 10);
}

// --------------------------------------------------------------------
// 2. CLEAN ORGANIC CYPRESS TRUNK
// --------------------------------------------------------------------
module cypress_trunk() {
    color([0.45, 0.28, 0.15]) { // Sienna Wood Brown
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
}

// --------------------------------------------------------------------
// 3. FOLIAGE CANOPY CLUSTER POD MODULE
// --------------------------------------------------------------------
module foliage_cloud_pad(rx = 7, ry = 6, rz = 4.5, bump_count = 7) {
    color([0.18, 0.48, 0.22]) { // Cypress Forest Green
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
}

// --------------------------------------------------------------------
// 4. COMPLETE UNIFIED CYPRESS TREE ASSEMBLY
// --------------------------------------------------------------------
module complete_cypress_tree() {
    union() {
        // 1. Terrain Base
        multi_feature_terrain_base(
            r = base_radius,
            rings = 28,
            sectors = 64,
            min_h = base_min_thick,
            max_h = max_mountain_h
        );
        
        // 2. Tree Trunk & Canopy sitting on center mountain summit (anchored inside terrain)
        translate([-0.2, -0.2, 3.2]) {
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

complete_cypress_tree();
