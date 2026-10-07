// Test script for High-Relief Craggy Jagged Mountain Terrain Base
$fn = 32;

module craggy_mountain_base(r = 21, nr = 32, nt = 64) {
    // Sharp ridged multifractal terrain height function
    function terrain_z(x, y, frac) = 
        let (
            // Radial taper to flat 0.8mm at outer edge
            taper = pow(cos(frac * 90), 1.1),
            
            // Sharp knife-edge ridges using abs(sin) and abs(cos)
            r1 = pow(1.0 - abs(sin(x * 0.28 + y * 0.15)), 0.7) * 3.5,
            r2 = pow(1.0 - abs(cos(x * 0.35 - y * 0.28 + 1.2)), 0.7) * 2.8,
            r3 = pow(abs(sin(x * 0.65 + y * 0.55)), 1.2) * 1.8,
            
            // High-frequency rocky noise
            n1 = sin(x * 0.85 + 2.1) * cos(y * 0.92 - 1.4) * 1.2,
            n2 = cos(x * 1.65 - y * 1.45 + 0.8) * sin(y * 1.85 + 2.3) * 0.7,
            n3 = sin(x * 3.1 - y * 2.8 + 1.5) * 0.35, // sharp rock grain
            
            // Asymmetric craggy summit peak
            peak = 4.2 * exp(-((x + 1.2)*(x + 1.2) + (y - 0.8)*(y - 0.8)) / 40),
            
            raw_h = 0.8 + peak + r1 + r2 + r3 + n1 + n2 + n3,
            
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
    
    // Top grid faces (alternating diagonals for sharp triangulation)
    top_grid_faces = [
        for (ri = [1 : nr - 1])
            for (ti = [0 : nt - 1])
                for (t = [0, 1])
                    ((ri + ti) % 2 == 0) ?
                        (t == 0 ? [top_idx(ri, ti), top_idx(ri + 1, ti), top_idx(ri + 1, ti + 1)] :
                                  [top_idx(ri, ti), top_idx(ri + 1, ti + 1), top_idx(ri, ti + 1)]) :
                        (t == 0 ? [top_idx(ri, ti), top_idx(ri + 1, ti), top_idx(ri, ti + 1)] :
                                  [top_idx(ri + 1, ti), top_idx(ri + 1, ti + 1), top_idx(ri, ti + 1)])
    ];
    
    // Bottom faces
    bot_center_faces = [
        for (ti = [0 : nt - 1])
            [1, bot_idx(1, ti + 1), bot_idx(1, ti)]
    ];
    
    bot_grid_faces = [
        for (ri = [1 : nr - 1])
            for (ti = [0 : nt - 1])
                for (t = [0, 1])
                    t == 0 ?
                        [bot_idx(ri, ti), bot_idx(ri + 1, ti + 1), bot_idx(ri + 1, ti)] :
                        [bot_idx(ri, ti), bot_idx(ri, ti + 1), bot_idx(ri + 1, ti + 1)]
    ];
    
    // Wall faces
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

craggy_mountain_base();
