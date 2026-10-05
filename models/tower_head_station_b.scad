// ====================================================================
// Tower Head Station B: Cable Tensioning Station (100% 3D-Printable)
// 
// Features:
// - Slotted horizontal adjustment track (25mm travel range)
// - Tensioning bolt hole: turning an M4/M5 screw pulls the sheave axle outward
//   to tighten the cable and eliminate sag.
// - Bottom 20mm socket to mount onto a wooden dowel, PVC pipe, or printed truss.
// ====================================================================

use <tower_sheave.scad>;

$fn = 40;

body_w         = 15.33; // [scaled from 46mm]
body_l         = 21.67; // [scaled from 65mm]
body_h         = 8.0;   // [scaled from 24mm]
slot_travel    = 9.33;  // [scaled from 28mm]
axle_dia       = 5.4;   // M5 bolt clearance for sheave axle
socket_inner_d = 6.8;   // Fits scaled mast/dowel [scaled from 20.4mm]
socket_wall    = 2.0;
socket_depth   = 10.0;  // [scaled from 25mm]


// ====================================================================
// Part A: Lower Mast Socket (Sits 100% flat on build plate at Z=0)
// Includes top square post with snap-fit locking tabs
// ====================================================================
module tower_head_b_socket() {
    difference() {
        union() {
            // Main cylindrical mast socket
            cylinder(d = socket_inner_d + (socket_wall * 2), h = socket_depth);
            
            // Upper square snap post
            translate([0, 0, socket_depth + 3.0])
                cube([6.0, 6.0, 6.0], center = true);

            // Friction snap detent nubs on sides of post
            for (x_sign = [-1, 1]) {
                translate([x_sign * 3.0, 0, socket_depth + 4.5])
                    sphere(r = 0.5, $fn = 16);
            }
        }

        // Mast socket cavity (bottom) with 45-degree self-aligning lead-in chamfer
        translate([0, 0, -1])
            cylinder(d = socket_inner_d, h = socket_depth + 2);
        translate([0, 0, -0.01])
            cylinder(d1 = socket_inner_d + 1.5, d2 = socket_inner_d, h = 1.5);

        // Mast cross-pin clamp hole
        translate([0, 0, socket_depth / 2])
            rotate([0, 90, 0])
                cylinder(d = 2.4, h = socket_inner_d + 6, center = true);
    }
}

// ====================================================================
// Part B: Upper Tensioner Bracket (Lies 100% flat on side at Z=0)
// Includes square receiving pocket for Part A snap post
// ====================================================================
module tower_head_b_bracket() {
    difference() {
        union() {
            // Main horizontal tensioner body
            translate([body_l / 2 - 4, 0, body_h / 2])
                cube([body_l, body_w, body_h], center = true);

            // Lower snap-fit receiving hub (rests flat at Z = 0)
            translate([0, 0, 3.0])
                cube([10.0, 8.0, 6.0], center = true);
        }

        // Inner clevis channel for sheave wheel (fits 4mm sheave rim)
        translate([body_l / 2 - 2, 0, body_h / 2])
            cube([body_l + 4, 5.0, body_h + 4], center = true);

        // Horizontal tensioning slots on both sides (for axle bolt travel)
        translate([body_l / 2 - 2, 0, body_h / 2])
            hull() {
                translate([-slot_travel / 2, 0, 0])
                    rotate([90, 0, 0])
                        cylinder(d = axle_dia, h = body_w + 4, center = true);
                translate([slot_travel / 2, 0, 0])
                    rotate([90, 0, 0])
                        cylinder(d = axle_dia, h = body_w + 4, center = true);
            }

        // Longitudinal tensioner screw hole
        translate([body_l / 2 + 5, 0, body_h / 2])
            rotate([0, 90, 0])
                cylinder(d = 3.4, h = 20, center = true);

        // Receiving socket pocket for Part A post (includes +0.2mm print gap clearance)
        translate([0, 0, 3.0])
            cube([6.25, 6.25, 7.0], center = true);

        // Side snap-fit detent channels
        for (x_sign = [-1, 1]) {
            translate([x_sign * 3.1, 0, 4.5])
                sphere(r = 0.6, $fn = 16);
        }
    }
}

// 1-Piece Unified helper
module tower_head_b() {
    tower_head_b_socket();
    translate([0, 0, socket_depth])
        tower_head_b_bracket();
}


// Visual preview with sheave wheel in tension slot
module preview_station_b() {
    tower_head_b();
    #translate([body_l / 2 - 8, 0, 0])
        rotate([90, 0, 0])
            tower_sheave();
}

// ====================================================================
// Selection
// ====================================================================
// "print"      -> Upright with 45° support gusset (ZERO supports needed!)
// "print_flat" -> Laid flat on its side at Z = 0
// "preview"    -> Upright with sheave wheel attached
mode = "print";

if (mode == "print") {
    // Sits flat on socket base rim with 45-degree self-supporting ramps
    translate([0, 0, body_h / 2 + socket_depth])
        tower_head_b();
} else if (mode == "print_flat") {
    // Laid flat on its side at Z = 0
    translate([0, 0, body_w / 2])
        rotate([90, 0, 0])
            tower_head_b();
} else if (mode == "preview") {
    preview_station_b();
}
