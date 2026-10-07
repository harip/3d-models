// ====================================================================
// TREE BASE SKILL - Reusable Multi-Feature Terrain Base Library
// Standard: Single Combined 3D-Printable Solid Base Module
// Color: Light Ivory Cream (`color([0.96, 0.94, 0.88])`)
// Geometry: Pure Polar Polyhedron (0 CSG cut artifacts, 100% Watertight)
// ====================================================================

module multi_feature_terrain_base(
    r           = 20.0,  // Base radius (40mm diameter disc)
    rings       = 36,    // Radial ring resolution
    sectors     = 80,    // Angular sector resolution
    min_h       = 0.4,   // Sleek low-profile minimum base thickness (mm)
    max_h       = 6.8    // Maximum mountain height (mm)
) {
    function terrain_z(x, y) = 
        let (
            dist = sqrt(x*x + y*y),
            norm_d = min(1.0, dist / r),
            taper = pow(cos(norm_d * 90), 1.15),
            angle = atan2(y, x),
            
            // Domain warping for organic winding canyon paths
            wx = x + 1.8 * sin(y * 0.22 + 0.6) + 1.0 * cos(x * 0.45),
            wy = y + 1.8 * cos(x * 0.20 - 0.8) + 1.0 * sin(y * 0.42),
            
            // 1. SMOOTH ROLLING HILLS & ROUNDED KNOLSS (Gently rounded mounds & saddles)
            smooth_h1 = 3.5 * exp(-((wx + 0.2)*(wx + 0.2) + (wy + 0.2)*(wy + 0.2)) / 32),
            smooth_h2 = 2.8 * exp(-((x + 7.5)*(x + 7.5) + (y - 5.5)*(y - 5.5)) / 22),
            smooth_h3 = 2.5 * exp(-((x - 7.0)*(x - 7.0) + (y + 7.0)*(y + 7.0)) / 20),
            smooth_h4 = 2.2 * exp(-((x + 6.0)*(x + 6.0) + (y + 8.0)*(y + 8.0)) / 18),
            smooth_waves = 1.4 * sin(x * 0.22) * cos(y * 0.20),
            
            // 2. SHARP ROCK NEEDLES & CRAG RIDGES (Pointed peaks & knife-edges)
            sharp_p1 = 2.4 * exp(-((x - 8.5)*(x - 8.5) + (y - 7.5)*(y - 7.5)) / 5.5),
            sharp_p2 = 2.2 * exp(-((x + 2.0)*(x + 2.0) + (y - 12.0)*(y - 12.0)) / 5.0),
            sharp_p3 = 2.0 * exp(-((x - 11.5)*(x - 11.5) + (y + 1.5)*(y + 1.5)) / 4.5),
            
            radial_crags   = 1.4 * pow(1.0 - abs(sin(4 * angle + 2.5 * norm_d)), 0.6),
            radial_gullies = -1.3 * pow(abs(cos(3 * angle - 2.0 * norm_d)), 0.6),
            
            raw_h = min_h + smooth_h1 + smooth_h2 + smooth_h3 + smooth_h4 + smooth_waves
                    + sharp_p1 + sharp_p2 + sharp_p3 + radial_crags + radial_gullies,
            
            // 3. BLEND 50% SMOOTH CONTINUOUS SLOPES WITH 50% TERRACED CLIFF LEDGES
            step_height = 1.5,
            norm_h = raw_h / step_height,
            floor_h = floor(norm_h),
            frac_h = norm_h - floor_h,
            cliff_frac = pow(frac_h, 3.0) / (pow(frac_h, 3.0) + pow(1.0 - frac_h, 3.5)),
            stepped_h = (floor_h + cliff_frac) * step_height,
            
            blended_h = 0.45 * raw_h + 0.55 * stepped_h,
            
            z_final = min_h + max(0, blended_h - min_h) * taper
        ) (dist >= r - 0.01 ? min_h : z_final);

    // Generate pure polar vertices (Center fan + Concentric rings)
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
    
    // Light Ivory Cream Color ([0.96, 0.94, 0.88])
    color([0.96, 0.94, 0.88])
        polyhedron(points = all_verts, faces = all_faces, convexity = 10);
}
