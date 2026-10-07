// Test script for Jagged Craggy Mountain Terrain Base
$fn = 32;

module jagged_mountain_base(r = 21, max_h = 6.0, grid_n = 50) {
    step = (2 * r) / grid_n;
    
    // Multi-frequency directional height function
    function terrain_height(x, y) = 
        let (
            dist = sqrt(x*x + y*y),
            taper = (dist >= r - 0.2) ? 0 : pow(cos(min(1.0, dist / r) * 90), 1.15),
            
            // Frequencies for jagged rock topology
            f1 = sin(x * 0.22 + 1.4) * cos(y * 0.18 - 0.8),
            f2 = sin(x * 0.48 - y * 0.35 + 2.1) * cos(y * 0.55 + 1.2),
            f3 = cos(x * 0.95 + y * 0.82 - 1.5) * sin(x * 0.88 - y * 0.92 + 0.6),
            f4 = sin(x * 1.85 - y * 1.62 + 3.4) * cos(x * 1.75 + y * 1.95 - 2.1), // fine sharp rock facets
            
            // Craggy mountain ridges & peak
            ridge1 = pow(abs(sin(x * 0.28 + y * 0.16 + 0.5)), 1.6) * 2.8,
            ridge2 = pow(abs(cos(x * 0.38 - y * 0.32 - 0.8)), 1.8) * 2.2,
            peak   = 3.2 * exp(-((x + 0.5)*(x + 0.5) + (y - 0.5)*(y - 0.5)) / 45),
            
            raw_h = 1.0 + peak + ridge1 + ridge2 + 1.3 * f1 + 0.85 * f2 + 0.45 * f3 + 0.25 * f4,
            
            final_z = 0.8 + max(0, raw_h - 0.8) * taper
        ) final_z;

    // Generate grid points
    top_points = [
        for (yi = [0 : grid_n])
            for (xi = [0 : grid_n])
                let (
                    x = -r + xi * step,
                    y = -r + yi * step,
                    z = terrain_height(x, y)
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
                    t == 0 ?
                        [idx(xi, yi), idx(xi + 1, yi), idx(xi + 1, yi + 1)] :
                        [idx(xi, yi), idx(xi + 1, yi + 1), idx(xi, yi + 1)]
    ];
    
    bot_faces = [
        for (yi = [0 : grid_n - 1])
            for (xi = [0 : grid_n - 1])
                for (t = [0, 1])
                    t == 0 ?
                        [bidx(xi, yi), bidx(xi, yi + 1), bidx(xi + 1, yi + 1)] :
                        [bidx(xi, yi), bidx(xi + 1, yi + 1), bidx(xi + 1, yi)]
    ];
    
    // Perimeter wall faces to enclose mesh
    wall_south = [
        for (xi = [0 : grid_n - 1])
            for (t = [0, 1])
                t == 0 ?
                    [idx(xi, 0), bidx(xi, 0), bidx(xi + 1, 0)] :
                    [idx(xi, 0), bidx(xi + 1, 0), idx(xi + 1, 0)]
    ];
    
    wall_north = [
        for (xi = [0 : grid_n - 1])
            for (t = [0, 1])
                t == 0 ?
                    [idx(xi, grid_n), idx(xi + 1, grid_n), bidx(xi + 1, grid_n)] :
                    [idx(xi, grid_n), bidx(xi + 1, grid_n), bidx(xi, grid_n)]
    ];
    
    wall_west = [
        for (yi = [0 : grid_n - 1])
            for (t = [0, 1])
                t == 0 ?
                    [idx(0, yi), idx(0, yi + 1), bidx(0, yi + 1)] :
                    [idx(0, yi), bidx(0, yi + 1), bidx(0, yi)]
    ];
    
    wall_east = [
        for (yi = [0 : grid_n - 1])
            for (t = [0, 1])
                t == 0 ?
                    [idx(grid_n, yi), bidx(grid_n, yi), bidx(grid_n, yi + 1)] :
                    [idx(grid_n, yi), bidx(grid_n, yi + 1), idx(grid_n, yi + 1)]
    ];
    
    all_faces = concat(top_faces, bot_faces, wall_south, wall_north, wall_west, wall_east);
    
    // Clean cylinder clipping mask for flat circular disc boundary
    intersection() {
        cylinder(r = r, h = max_h + 5, $fn = 64);
        polyhedron(points = all_verts, faces = all_faces, convexity = 10);
    }
}

jagged_mountain_base();
