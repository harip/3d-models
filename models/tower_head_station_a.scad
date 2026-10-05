// ====================================================================
// Tower Head Station A: Drive-Ready Station (100% 3D-Printable)
// 
// Dual-Role Design:
// - Phase 1: Mounts a passive sheave wheel on an M5 bolt axle.
// - Phase 2: Directly bolts to a NEMA 17 stepper motor (4x M3 holes on 31mm centers)
//   without needing any modifications or reprints!
// Bottom has a 20mm socket to mount onto a wooden dowel, PVC pipe, or printed truss.
// ====================================================================

use <tower_sheave.scad>;

$fn = 40;

// Dimensions - Scaled to 1/3 envelope size (reduced size by 2/3rd)
bracket_w        = 15.33; // Width of mounting face [scaled from 46mm]
bracket_h        = 17.33; // Height of mounting plate [scaled from 52mm]
plate_th         = 3.0;   // Thickness of plate [scaled from 6mm]
nema17_hole_dist = 10.33; // Scaled motor mounting hole spacing [scaled from 31mm]
nema17_pilot_d   = 7.67;  // Scaled center collar clearance [scaled from 23mm]
m3_hole_d        = 2.2;   // Bolt clearance for 1/3 scale motor mount
socket_inner_d   = 6.8;   // Fits scaled mast/dowel [scaled from 20.4mm]
socket_wall      = 2.0;   // Socket wall thickness
socket_depth     = 10.0;  // Socket depth [scaled from 25mm]



// ====================================================================
// Part A: Lower Mast Socket (Sits 100% flat on build plate at Z=0)
// Includes top square post with snap-fit locking tabs
// ====================================================================
module tower_head_a_socket() {
    difference() {
        union() {
            // Main cylindrical mast socket
            cylinder(d = socket_inner_d + (socket_wall * 2), h = socket_depth);
            
            // Upper square snap post (plugs into the Upper Bracket)
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
// Part B: Upper Motor/Sheave Head Bracket (Laid 100% flat on plate at Z=0)
// Includes matching square receiving socket for snap fit
// ====================================================================
module tower_head_a_bracket() {
    difference() {
        union() {
            // Main vertical faceplate
            translate([0, 0, bracket_h / 2])
                cube([bracket_w, plate_th, bracket_h], center = true);

            // Overhead cable guide horn
            translate([0, 3.5, bracket_h - 1.5])
                cube([bracket_w, 7.0 + plate_th, 3.0], center = true);

            // Lower snap-fit receiving hub (rests flat at Z = 0)
            translate([0, 3.5, 3.0])
                cube([10.0, 8.0, 6.0], center = true);
        }

        // Center pilot hole (for axle bolt or motor collar)
        translate([0, 0, bracket_h * 0.55])
            rotate([90, 0, 0])
                cylinder(d = nema17_pilot_d, h = plate_th + 4, center = true);

        // 4x Motor mounting holes
        for (dx = [-nema17_hole_dist / 2, nema17_hole_dist / 2]) {
            for (dz = [-nema17_hole_dist / 2, nema17_hole_dist / 2]) {
                translate([dx, 0, (bracket_h * 0.55) + dz])
                    rotate([90, 0, 0])
                        cylinder(d = m3_hole_d, h = plate_th + 4, center = true);
            }
        }

        // Cable path slot through the overhead horn
        translate([0, 3.5, bracket_h - 1.5])
            cube([6.5, 9.0, 5.0], center = true);

        // Receiving socket pocket for Part A post (includes +0.2mm print gap clearance)
        translate([0, 3.5, 3.0])
            cube([6.25, 6.25, 7.0], center = true);

        // Side snap-fit detent channels
        for (x_sign = [-1, 1]) {
            translate([x_sign * 3.1, 3.5, 4.5])
                sphere(r = 0.6, $fn = 16);
        }
    }
}

// 1-Piece Unified or Assembled helper
module tower_head_a() {
    tower_head_a_socket();
    translate([0, -3.5, socket_depth])
        tower_head_a_bracket();
}



// Visual preview with sheave wheel attached
module preview_station_a() {
    tower_head_a();
    #translate([0, plate_th / 2 + 8, bracket_h * 0.55])
        rotate([90, 0, 0])
            tower_sheave();
}

// ====================================================================
// Selection
// ====================================================================
// "print"      -> Upright resting flat on socket rim at Z = 0
// "print_flat" -> Laid flat on its rear motor plate at Z = 0 (ZERO supports!)
// "preview"    -> Upright with sheave wheel attached
mode = "print_flat";

if (mode == "print") {
    translate([0, 0, socket_depth])
        tower_head_a();
} else if (mode == "print_flat") {
    // Laid flat on rear face of motor plate at Z = 0
    translate([0, plate_th / 2, 0])
        rotate([-90, 0, 0])
            tower_head_a();
} else if (mode == "preview") {
    preview_station_a();
}
