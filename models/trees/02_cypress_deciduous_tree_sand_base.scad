// ====================================================================
// 3D Printable Windswept Coastal Cypress Tree on Procedural Math Terrain Base
// Scale: ~40 mm (~1.57 inches) - Fits 1 to 2 inch scale requirement
// Features:
// - Watertight 3D polyhedron terrain base with flat bottom bed interface
// - Bright LightYellow terrain base color styling for high contour contrast
// - Procedurally generated via sin(), cos() & spatial harmonic math functions
// - Parameterized grid resolution, base size, minimum thickness, and max mountain height
// - Organic S-curved cypress trunk emerging naturally from center mountain summit
// - Multi-lobed cloud canopy foliage pads textured with leaf clusters
// ====================================================================

$fn = 32;

// --------------------------------------------------------------------
// USER TWEAKABLE PARAMETERS (Top of Script)
// --------------------------------------------------------------------
grid_resolution  = 44;    // Grid density for smooth procedural terrain
base_radius      = 20.0;  // Base radius (40mm diameter base disc)
base_min_thick   = 1.0;   // Minimum base thickness (mm) for flat 3D print bed
max_mountain_h   = 6.5;   // Maximum mountain height (mm)
tree_total_h     = 40.0;  // Overall tree height (mm)

// Part Selection for Multi-Color Slicing (0 = Complete, 1 = Base Only, 2 = Tree Only)
part_select      = 0;

// --------------------------------------------------------------------
// 1. PROCEDURAL MATH TERRAIN LANDSCAPE BASE MODULE (Watertight Mesh)
// --------------------------------------------------------------------
module procedural_landscape_base(r = base_radius, grid_n = grid_resolution, min_h = base_min_thick, max_h = max_mountain_h) {
    step = (2 * r) / grid_n;
    
    function landscape_z(x, y) = 
        let (
            dist = sqrt(x*x + y*y),
            taper = (dist >= r - 0.5) ? pow(max(0, (r - dist) / 0.5), 1.1) : 1.0,
            
            f1 = 2.8 * sin(x * 0.25 + 0.8) * cos(y * 0.22 - 0.4),
            f2 = 1.6 * sin(x * 0.45 - y * 0.38 + 1.5),
            f3 = 0.9 * cos(x * 0.85 + y * 0.72 - 2.1) * sin(y * 0.95 + 1.2),
            f4 = 0.4 * sin(x * 1.75 - y * 1.55 + 3.2),
            
            peak = 3.8 * exp(-((x + 0.2)*(x + 0.2) + (y + 0.2)*(y + 0.2)) / 30),
            ridge = 2.2 * pow(abs(cos(x * 0.3 - y * 0.25)), 1.2),
            
            raw_z = min_h + peak + ridge + f1 + f2 + f3 + f4,
            
            z_final = min_h + max(0, raw_z - min_h) * taper
        ) z_final;

    top_points = [
        for (yi = [0 : grid_n])
            for (xi = [0 : grid_n])
                let (
                    x = -r + xi * step,
                    y = -r + yi * step,
                    z = landscape_z(x, y)
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
    
    // Bright LightYellow / Ivory Sand Color for high contour contrast
    color("LightYellow") {
        intersection() {
            cylinder(r = r, h = max_h + 15, $fn = 64);
            polyhedron(points = all_verts, faces = all_faces, convexity = 10);
        }
    }
}

// --------------------------------------------------------------------
// 2. CLEAN ORGANIC CYPRESS TRUNK
// --------------------------------------------------------------------
module cypress_trunk() {
    color("SaddleBrown") {
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
    color("ForestGreen") {
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
// 4. COMPLETE CYPRESS TREE ASSEMBLY
// --------------------------------------------------------------------
module complete_cypress_tree() {
    if (part_select == 0 || part_select == 1) {
        // 1. Procedural Math Landscape Base (Bright LightYellow Color)
        procedural_landscape_base(
            r = base_radius,
            grid_n = grid_resolution,
            min_h = base_min_thick,
            max_h = max_mountain_h
        );
    }
    
    if (part_select == 0 || part_select == 2) {
        // 2. Cypress Trunk & Canopy sitting naturally on center mountain peak summit (Z = 6.2mm)
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

// Render selected assembly
complete_cypress_tree();
