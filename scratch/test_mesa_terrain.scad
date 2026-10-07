// Test script for Blender-style Canyon Cliff Mesa Terrain Base
$fn = 32;

module cliff_mesa_mountain_base(r = 20, grid_n = 45) {
    step = (2 * r) / grid_n;
    
    // Blender A.N.T. Landscape style Cliff Mesa & Canyon height function
    function terrain_z(x, y) = 
        let (
            dist = sqrt(x*x + y*y),
            taper = (dist >= r - 0.4) ? 0 : pow(cos(min(1.0, dist / r) * 90), 1.05),
            
            // 1. Domain warping for organic winding canyon walls
            warp_x = x + 1.8 * sin(y * 0.22 + 0.8),
            warp_y = y + 1.8 * cos(x * 0.20 - 0.5),
            
            // 2. Multi-mesa elevation field
            m1 = 4.8 * exp(-((warp_x + 3.5)*(warp_x + 3.5) + (warp_y - 2.8)*(warp_y - 2.8)) / 26),
            m2 = 4.0 * exp(-((warp_x - 4.5)*(warp_x - 4.5) + (warp_y + 3.8)*(warp_y + 3.8)) / 22),
            m3 = 4.5 * exp(-((warp_x + 0.2)*(warp_x + 0.2) + (warp_y + 0.2)*(warp_y + 0.2)) / 18),
            
            ridge = 2.4 * sin(warp_x * 0.25 + warp_y * 0.18),
            canyon = -1.5 * pow(abs(cos(warp_x * 0.28 - warp_y * 0.22)), 0.6),
            
            raw_h = 1.0 + m1 + m2 + m3 + ridge + canyon,
            
            // 3. Cliff Mesa Step Quantization (Steep cliff faces + flat plateau tops)
            step_height = 1.5,
            norm_h = raw_h / step_height,
            floor_h = floor(norm_h),
            frac_h = norm_h - floor_h,
            
            // Sigmoid cliff wall S-curve
            cliff_frac = pow(frac_h, 4.0) / (pow(frac_h, 4.0) + pow(1.0 - frac_h, 4.0)),
            
            stepped_h = (floor_h + cliff_frac) * step_height,
            
            // 4. Fine rock roughness on plateau surfaces
            roughness = 0.35 * sin(x * 1.4 + y * 1.1) * cos(x * 1.6 - y * 1.5),
            
            z_final = 0.8 + max(0, stepped_h + roughness - 0.8) * taper
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
    
    intersection() {
        cylinder(r = r, h = 20, $fn = 64);
        polyhedron(points = all_verts, faces = all_faces, convexity = 10);
    }
}

// Cypress Trunk
module cypress_trunk() {
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

// Foliage Cloud Canopy Pads
module foliage_cloud_pad(rx = 7, ry = 6, rz = 4.5, bump_count = 7) {
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

module complete_tree() {
    union() {
        cliff_mesa_mountain_base(r = 20, grid_n = 45);
        
        // Tree elevated to sit naturally on central mesa summit plateau (Z = 6.2mm)
        translate([-0.2, -0.2, 6.2]) {
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

complete_tree();
