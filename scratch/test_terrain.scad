// Test terrain base models
$fn = 32;

// --- OPTION A: Stepped Topographic Terrace Base ---
module topo_stepped_base(r = 22, max_h = 5.0, steps = 6) {
    step_h = max_h / steps;
    
    for (k = [0 : steps - 1]) {
        frac = k / steps; // 0 to 1
        z_pos = k * step_h;
        // Radius of this terrace layer shrinks organically
        r_step = r * (1.0 - 0.75 * pow(frac, 0.8));
        
        translate([0, 0, z_pos])
            linear_extrude(height = step_h + 0.05, convexity = 10) {
                // Organic multi-lobe contour shape
                union() {
                    // Main central mound
                    circle(r = r_step);
                    // Secondary ridge mound offset to the side
                    translate([-r_step * 0.35, r_step * 0.25])
                        circle(r = r_step * 0.75);
                    // Small rock outcrop ridge
                    translate([r_step * 0.4, -r_step * 0.3])
                        circle(r = r_step * 0.6);
                }
            }
    }
}

// --- OPTION B: Low-Poly Faceted Mountain Ridge Base ---
module mountain_faceted_base(r = 22, grid_n = 30) {
    step = (2 * r) / grid_n;
    
    // Create points grid
    points = [
        for (yi = [0 : grid_n])
            for (xi = [0 : grid_n])
                let (
                    x = -r + xi * step,
                    y = -r + yi * step,
                    dist = sqrt(x*x + y*y),
                    
                    // Multi-peak mountain height formula
                    peak1 = 3.5 * exp(-((x-2)*(x-2) + (y+3)*(y+3)) / 60),
                    peak2 = 2.8 * exp(-((x+6)*(x+6) + (y-4)*(y-4)) / 40),
                    ridge = 1.8 * cos(x * 25 + y * 18),
                    
                    raw_z = 0.8 + peak1 + peak2 + ridge,
                    
                    // Smooth edge taper to zero at rim radius r
                    taper = (dist >= r) ? 0 : pow(cos((dist / r) * 90), 1.3),
                    z_top = (dist >= r) ? 0.8 : max(0.8, 0.8 + (raw_z - 0.8) * taper)
                )
                [x, y, z_top]
    ];
    
    // Bottom points
    bot_points = [
        for (yi = [0 : grid_n])
            for (xi = [0 : grid_n])
                let (
                    x = -r + xi * step,
                    y = -r + yi * step
                )
                [x, y, 0]
    ];
    
    all_verts = concat(points, bot_points);
    num_pts = len(points);
    
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
    
    // Boundary cylinder mask
    intersection() {
        cylinder(r = r, h = 10, $fn = 64);
        polyhedron(points = all_verts, faces = concat(top_faces, bot_faces), convexity = 10);
    }
}

// Render Option B for preview
mountain_faceted_base();
