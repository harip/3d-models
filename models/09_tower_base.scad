// ====================================================================
// [PRINT 09] Sturdy 110mm Tower Baseplate
// Sits 100% flat on circular bottom at Z = 0.
// Self-centering lead-in chamfer for 20mm (3/4") mast dowels or PVC pipes.
// Includes 4x perimeter hold-down clamp/screw tabs and 2.4mm cross-pin hole.
// (Print 2 of this file: one for Tower A, one for Tower B).
// ZERO SUPPORTS NEEDED!
// ====================================================================

$fn = 60;

base_dia       = 36.67; // Wide footprint [scaled from 110mm]
base_th        = 3.0;   // Base thickness [scaled from 8mm]
socket_inner_d = 6.8;   // Fits scaled 6.8mm mast plug [scaled from 20.4mm]
socket_wall    = 2.0;   // Wall thickness
socket_h       = 13.0;  // Socket column height [scaled from 39mm]

module tower_base() {
    difference() {
        union() {
            // Main disc with beveled edge
            cylinder(d1 = base_dia, d2 = base_dia - 6, h = base_th);
            
            // Central socket column
            translate([0, 0, 0])
                cylinder(d = socket_inner_d + (socket_wall * 2), h = socket_h);
                
            // 4x Rigid support ribs
            for (a = [0 : 90 : 270]) {
                rotate([0, 0, a])
                    translate([socket_inner_d / 2, -socket_wall / 2, 0])
                        cube([base_dia / 2 - socket_inner_d / 2 - 8, socket_wall, socket_h * 0.6]);
            }
        }

        // Central dowel/mast socket (10mm depth from Z=3mm to Z=13mm)
        translate([0, 0, 3])
            cylinder(d = socket_inner_d, h = 11);
        translate([0, 0, socket_h - 2])
            cylinder(d1 = socket_inner_d, d2 = socket_inner_d + 3.0, h = 3.0);

        // 4x Perimeter screw/mounting holes (optional hold-down screws/clamps)
        for (a = [45 : 90 : 315]) {
            rotate([0, 0, a])
                translate([base_dia / 2 - 10, 0, -1])
                    cylinder(d = 4.5, h = base_th + 4);
        }

        // Cross-pin clamp hole for socket (centered at Z = 8.0mm = 5mm above socket floor at Z=3mm)
        translate([0, 0, 8.0])
            rotate([90, 0, 0])
                cylinder(d = 2.4, h = socket_inner_d + 16, center = true);
    }
}

// Render flat on bed at Z = 0
tower_base();

