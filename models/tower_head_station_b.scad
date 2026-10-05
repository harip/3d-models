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


module tower_head_b() {
    difference() {
        union() {
            // Main horizontal tensioner body
            translate([body_l / 2 - 15, 0, 0])
                cube([body_l, body_w, body_h], center = true);

            // Lower mast mounting socket
            translate([0, 0, -body_h / 2 - socket_depth / 2])
                cylinder(d = socket_inner_d + (socket_wall * 2), h = socket_depth, center = true);
                
            // 45-degree self-supporting diagonal bracket underneath the cantilever
            translate([0, 0, -body_h / 2])
                rotate([0, 90, 0])
                    linear_extrude(height = 16.0, center = true)
                        polygon([[0, socket_inner_d / 2], [socket_depth, socket_inner_d / 2], [0, body_l - 15]]);
        }

        // Inner clevis channel for sheave wheel
        translate([body_l / 2 - 10, 0, 0])
            cube([body_l + 4, 16.0, body_h + 4], center = true);

        // Horizontal tensioning slots on both sides (for axle bolt travel)
        translate([body_l / 2 - 8, 0, 0])
            hull() {
                translate([-slot_travel / 2, 0, 0])
                    rotate([90, 0, 0])
                        cylinder(d = axle_dia, h = body_w + 4, center = true);
                translate([slot_travel / 2, 0, 0])
                    rotate([90, 0, 0])
                        cylinder(d = axle_dia, h = body_w + 4, center = true);
            }

        // Longitudinal tensioner screw hole (M4/M5 bolt pulls/pushes the axle)
        translate([body_l - 15, 0, 0])
            rotate([0, 90, 0])
                cylinder(d = 4.4, h = 30, center = true);

        // Mast socket cavity (bottom) with 45-degree self-aligning lead-in chamfer
        translate([0, 0, -body_h / 2 - socket_depth / 2 - 1])
            cylinder(d = socket_inner_d, h = socket_depth + 2, center = true);
        translate([0, 0, -body_h / 2 - socket_depth])
            cylinder(d1 = socket_inner_d + 3.0, d2 = socket_inner_d, h = 3.0);

        // Mast cross-pin clamp hole
        translate([0, 0, -body_h / 2 - socket_depth / 2])
            rotate([0, 90, 0])
                cylinder(d = 4.2, h = socket_inner_d + 12, center = true);

        // Embossed Station Identification on side: "B - TENSION"
        translate([body_l / 2 - 24, body_w / 2 - 0.2, -body_h / 4])
            rotate([90, 0, 0])
                linear_extrude(height = 0.8)
                    text("B - TENSION", size = 4.0, font = "Liberation Sans:style=Bold");
    }
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
