// Extreme Craggy Rock Mountain Base with Integrated Faceted Rock Outcrops
$fn = 32;

// --- 1. CRAGGY FACETED ROCK OUTCROP MODULE ---
module rock_outcrop(size = [6, 5, 4], rot = [15, -20, 35]) {
    rotate(rot)
        scale(size)
            rotate([45, 35, 20])
                cube([1, 1, 1], center = true);
}

// --- 2. HIGH-RELIEF CRAGGY MOUNTAIN TERRAIN MODULE ---
module extreme_craggy_mountain_base(r = 20, grid_n = 32) {
    step = (2 * r) / grid_n;
    
    function terrain_z(x, y) = 
        let (
            dist = sqrt(x*x + y*y),
            taper = (dist >= r - 0.5) ? 0 : pow(cos(min(1.0, dist / r) * 90), 1.05),
            
            // Peak 1: Steep Northwest Crag Peak
            p1 = 5.2 * exp(-((x + 3.5)*(x + 3.5) + (y - 3.5)*(y - 3.5)) / 25),
            
            // Peak 2: Steep Southeast Mountain Ridge Peak
            p2 = 4.4 * exp(-((x - 4.5)*(x - 4.5) + (y + 3.5)*(y + 3.5)) / 22),
            
            // Central Ridge Mount (Tree position)
            p3 = 4.8 * exp(-((x + 0.2)*(x + 0.2) + (y + 0.2)*(y + 0.2)) / 18),
            
            // Knife-edge mountain crest ridges & deep valleys
            ridge1 = pow(1.0 - abs(sin(x * 0.35 + y * 0.25 + 0.3)), 0.5) * 4.0,
            ridge2 = pow(1.0 - abs(cos(x * 0.48 - y * 0.38 - 0.6)), 0.5) * 3.2,
            valleys = -1.8 * pow(sin(x * 0.4 - y * 0.3), 2.0),
            
            // Sharp rock noise grain
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
        
        // Integrated Craggy Rock Outcrop Formations on Mountain Slopes
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
        extreme_craggy_mountain_base(r = 20, grid_n = 32);
        
        // Tree elevated onto the central mountain crag ridge summit (Z = 6.4mm)
        translate([-0.2, -0.2, 6.4]) {
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
