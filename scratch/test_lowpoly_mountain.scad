// Low-Poly Faceted Rocky Mountain Base Test
$fn = 32;

module lowpoly_rocky_mountain_base(r = 21, grid_n = 22) {
    step = (2 * r) / grid_n;
    
    // Low-poly terrain height function with sharp mountain ridges and rock outcrops
    function terrain_z(x, y) = 
        let (
            dist = sqrt(x*x + y*y),
            taper = (dist >= r - 0.5) ? 0 : pow(cos(min(1.0, dist / r) * 90), 1.2),
            
            // Sharp angular low-poly ridges
            r1 = pow(abs(sin(x * 0.35 + y * 0.22 + 0.4)), 1.8) * 4.2,
            r2 = pow(abs(cos(x * 0.45 - y * 0.38 - 0.7)), 2.0) * 3.5,
            
            // Rocky peak summit
            peak = 4.8 * exp(-((x + 1.0)*(x + 1.0) + (y - 0.5)*(y - 0.5)) / 36),
            
            // Angular facet noise
            n1 = floor(sin(x * 0.8 + y * 0.6) * 3.0) * 0.4,
            n2 = floor(cos(x * 1.4 - y * 1.2) * 2.5) * 0.3,
            
            raw_h = 1.0 + peak + r1 + r2 + n1 + n2,
            
            z_val = 0.8 + max(0, raw_h - 0.8) * taper
        ) z_val;

    // Build grid vertices
    top_verts = [
        for (yi = [0 : grid_n])
            for (xi = [0 : grid_n])
                let (
                    x = -r + xi * step,
                    y = -r + yi * step,
                    z = terrain_z(x, y)
                )
                [x, y, z]
    ];
    
    bot_verts = [
        for (yi = [0 : grid_n])
            for (xi = [0 : grid_n])
                let (
                    x = -r + xi * step,
                    y = -r + yi * step
                )
                [x, y, 0]
    ];
    
    all_verts = concat(top_verts, bot_verts);
    num_pts = len(top_verts);
    
    function idx(xi, yi) = yi * (grid_n + 1) + xi;
    function bidx(xi, yi) = num_pts + yi * (grid_n + 1) + xi;
    
    // Render top faces as individual low-poly facet prisms for crisp sharp edges
    intersection() {
        cylinder(r = r, h = 12, $fn = 64);
        
        union() {
            // Flat base slab
            cylinder(r = r + 2, h = 0.8, $fn = 64);
            
            // Low-poly facet blocks
            for (yi = [0 : grid_n - 1]) {
                for (xi = [0 : grid_n - 1]) {
                    p00 = top_verts[idx(xi, yi)];
                    p10 = top_verts[idx(xi + 1, yi)];
                    p11 = top_verts[idx(xi + 1, yi + 1)];
                    p01 = top_verts[idx(xi, yi + 1)];
                    
                    // Triangle 1
                    polyhedron(
                        points = [
                            p00, p10, p11,
                            [p00[0], p00[1], 0], [p10[0], p10[1], 0], [p11[0], p11[1], 0]
                        ],
                        faces = [
                            [0, 1, 2], // top
                            [3, 5, 4], // bot
                            [0, 3, 4], [0, 4, 1],
                            [1, 4, 5], [1, 5, 2],
                            [2, 5, 3], [2, 3, 0]
                        ],
                        convexity = 4
                    );
                    
                    // Triangle 2
                    polyhedron(
                        points = [
                            p00, p11, p01,
                            [p00[0], p00[1], 0], [p11[0], p11[1], 0], [p01[0], p01[1], 0]
                        ],
                        faces = [
                            [0, 1, 2], // top
                            [3, 5, 4], // bot
                            [0, 3, 4], [0, 4, 1],
                            [1, 4, 5], [1, 5, 2],
                            [2, 5, 3], [2, 3, 0]
                        ],
                        convexity = 4
                    );
                }
            }
        }
    }
}

lowpoly_rocky_mountain_base();
