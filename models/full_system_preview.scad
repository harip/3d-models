// ====================================================================
// Master Assembly Preview (Christmas Gondola System - Phase 1)
// Open this file in OpenSCAD and press F5 to view the complete setup!
// ====================================================================

use <tower_base_and_stand.scad>;
use <tower_head_station_a.scad>;
use <tower_head_station_b.scad>;
use <tower_sheave.scad>;
use <trolley_carriage.scad>;
use <trolley_wheel.scad>;
use <gondola_cabin.scad>;

$fn = 30;

// Preview parameters
span_distance = 320; // Visual preview span (mm)
tower_height  = 160; // Visual preview mast height (mm)
gondola_pos   = 0.45; // Position along span (0.0 to 1.0)

// 1. Tower A (Drive-Ready Station)
translate([-span_distance / 2, 0, 0]) {
    color("darkslategray") tower_base();
    color("silver") translate([0, 0, 10]) cylinder(d = 6.6, h = tower_height - 10);
    color("crimson") translate([0, 0, tower_height]) tower_head_a();
    color("gold") translate([0, 3, tower_height + 9]) rotate([90, 0, 0]) tower_sheave();
}

// 2. Tower B (Tension Station)
translate([span_distance / 2, 0, 0]) {
    color("darkslategray") tower_base();
    color("silver") translate([0, 0, 10]) cylinder(d = 6.6, h = tower_height - 10);
    color("forestgreen") translate([0, 0, tower_height + 4]) tower_head_b();
    color("gold") translate([5, 0, tower_height + 4]) rotate([90, 0, 0]) tower_sheave();
}

// 3. Track Cable (Visualized in black)
cable_z = tower_height + 9;
color("black")
    translate([0, 0, cable_z])
        rotate([0, 90, 0])
            cylinder(d = 1.0, h = span_distance + 20, center = true);

// 4. Gondola & Trolley Carriage
gondola_x = -span_distance / 2 + (span_distance * gondola_pos);

translate([gondola_x, 0, cable_z]) {
    // Trolley carriage
    color("firebrick") trolley_carriage();
    
    // Trolley wheels
    color("gold") {
        translate([6.33, 0, 1]) rotate([90, 0, 0]) trolley_wheel();
        translate([-6.33, 0, 1]) rotate([90, 0, 0]) trolley_wheel();
    }
    
    // Hanger arm
    color("snow")
        translate([0, -2, -28])
            hanger_arm_snap_print();

                
    // Gondola Roof
    color("darkred")
        translate([0, -2, -28])
            cabin_roof();
            
    // Gondola Cabin Body
    color("crimson")
        translate([0, -2, -44.67])
            cabin_body();
}


