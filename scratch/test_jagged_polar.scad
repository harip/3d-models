// Test script for Polar Radial Mesh Jagged Mountain Terrain Base
$fn = 32;

module jagged_mountain_base_polar(r = 21, nr = 28, nt = 56) {
    // Multi-frequency directional height function for craggy jagged mountain terrain
    function terrain_z(x, y, frac) = 
        let (
            // Radial taper to flat 0.8mm at outer edge
            taper = pow(cos(frac * 90), 1.1),
            
            // Frequencies for random craggy rock face topology
            f1 = sin(x * 0.28 + 1.2) * cos(y * 0.22 - 0.7),
            f2 = sin(x * 0.55 - y * 0.42 + 2.3) * cos(y * 0.62 + 1.1),
            f3 = cos(x * 1.15 + y * 0.95 - 1.8) * sin(x * 1.05 - y * 1.12 + 0.5),
            f4 = sin(x * 2.15 - y * 1.85 + 3.1) * cos(x * 1.95 + y * 2.25 - 1.7), // sharp rock texture
            
            // Asymmetric craggy mountain ridges & peak
            ridge1 = pow(abs(sin(x * 0.32 + y * 0.18 + 0.4)), 1.5) * 3.2,
            ridge2 = pow(abs(cos(x * 0.42 - y * 0.35 - 0.9)), 1.7) * 2.5,
            peak   = 3.8 * exp(-((x + 0.8)*(x + 0.8) + (y - 0.6)*(y - 0.6)) / 38),
            
            raw_h = 1.0 + peak + ridge1 + ridge2 + 1.5 * f1 + 0.95 * f2 + 0.5 * f3 + 0.28 * f4,
            
            z_out = 0.8 + max(0, raw_h - 0.8) * taper
        ) z_out;

    // Center top and bottom vertices
    center_top = [0, 0, terrain_z(0, 0, 0)];
    center_bot = [0, 0, 0];

    // Radial ring vertices
    top_ring_verts = [
        for (ri = [1 : nr])
            for (ti = [0 : nt - 1])
                let (
                    frac  = ri / nr,
                    rad   = frac * r,
                    angle = ti * (360 / nt),
                    x     = rad * cos(angle),
                    y     = rad * sin(angle),
                    z     = terrain_z(x, y, frac)
                )
                [x, y, z]
    ];
    
    bot_ring_verts = [
        for (ri = [1 : nr])
            for (ti = [0 : nt - 1])
                let (
                    frac  = ri / nr,
                    rad   = frac * r,
                    angle = ti * (360 / nt),
                    x     = rad * cos(angle),
                    y     = rad * sin(angle)
                )
                [x, y, 0]
    ];
    
    all_verts = concat([center_top, center_bot], top_ring_verts, bot_ring_verts);
    num_ring = len(top_ring_verts);
    
    function top_idx(ri, ti) = (ri == 0) ? 0 : 2 + (ri - 1) * nt + (ti % nt);
    function bot_idx(ri, ti) = (ri == 0) ? 1 : 2 + num_ring + (ri - 1) * nt + (ti % nt);
    
    // Top center fan
    top_center_faces = [
        for (ti = [0 : nt - 1])
            [0, top_idx(1, ti), top_idx(1, ti + 1)]
    ];
    
    // Top grid faces
    top_grid_faces = [
        for (ri = [1 : nr - 1])
            for (ti = [0 : nt - 1])
                for (t = [0, 1])
                    t == 0 ?
                        [top_idx(ri, ti), top_idx(ri + 1, ti), top_idx(ri + 1, ti + 1)] :
                        [top_idx(ri, ti), top_idx(ri + 1, ti + 1), top_idx(ri, ti + 1)]
    ];
    
    // Bottom center fan
    bot_center_faces = [
        for (ti = [0 : nt - 1])
            [1, bot_idx(1, ti + 1), bot_idx(1, ti)]
    ];
    
    // Bottom grid faces
    bot_grid_faces = [
        for (ri = [1 : nr - 1])
            for (ti = [0 : nt - 1])
                for (t = [0, 1])
                    t == 0 ?
                        [bot_idx(ri, ti), bot_idx(ri + 1, ti + 1), bot_idx(ri + 1, ti)] :
                        [bot_idx(ri, ti), bot_idx(ri, ti + 1), bot_idx(ri + 1, ti + 1)]
    ];
    
    // Outer wall vertical rim faces
    wall_faces = [
        for (ti = [0 : nt - 1])
            for (t = [0, 1])
                t == 0 ?
                    [top_idx(nr, ti), bot_idx(nr, ti), bot_idx(nr, ti + 1)] :
                    [top_idx(nr, ti), bot_idx(nr, ti + 1), top_idx(nr, ti + 1)]
    ];
    
    polyhedron(
        points = all_verts, 
        faces = concat(top_center_faces, top_grid_faces, bot_center_faces, bot_grid_faces, wall_faces), 
        convexity = 10
    );
}

jagged_mountain_base_polar();
