// ====================================================================
// Master Assembly Preview: Alpine Gondola System (Valley to Mountain)
// Open this file in OpenSCAD and press F5 for full 3D visual preview!
// ====================================================================

use <station_a_valley_building.scad>;
use <01_gondola_single_piece.scad>;
use <03_hanger_arm.scad>;
use <04_trolley_carriage.scad>;
use <trolley_wheel.scad>;
use <tower_head_station_b.scad>;
use <tower_sheave.scad>;
use <tower_base_and_stand.scad>;
use <10_tower_masts_pair.scad>;

$fn = 30;

// Preview Parameters
span_distance = 320.0; // Distance between stations (mm)
hill_elevation= 50.0;  // Height elevation of top station up the hill (mm)

// 1. Station A: Alpine Base Station Chalet (Bottom of Hill at X = -160)
translate([-span_distance / 2, 0, 0]) {
    color("sienna")
        station_a_valley_building();
    
    // Drive Sheave Wheel inside Roof Ridge Cupola
    color("gold")
        translate([0, 0, 51.0])
            rotate([90, 0, 0])
                tower_sheave();
}

// 2. Station B: Mountain Tensioning Tower (Top of Hill at X = +160, Z = +50)
translate([span_distance / 2, 0, hill_elevation]) {
    color("darkslategray")
        tower_base();
    color("silver")
        translate([0, 0, 3.0])
            cylinder(d = 6.6, h = 100.0);
    color("forestgreen")
        translate([0, 0, 103.0])
            tower_head_b();
    color("gold")
        translate([0, 0, 112.53])
            rotate([90, 0, 0])
                tower_sheave();
}

// 3. Inclined Track Cable Line (Visualized in black spanning up the hill)
station_a_cable_z = 51.0;
station_b_cable_z = hill_elevation + 112.53;

cable_dx = span_distance;
cable_dz = station_b_cable_z - station_a_cable_z;
cable_angle = atan2(cable_dz, cable_dx);
cable_len   = sqrt(cable_dx*cable_dx + cable_dz*cable_dz);

translate([-span_distance / 2, 0, station_a_cable_z])
    rotate([0, -cable_angle, 0])
        color("black")
            translate([cable_len / 2, 0, 0])
                rotate([0, 90, 0])
                    cylinder(d = 1.2, h = cable_len, center = true);

// 4. Gondola Cabin Vehicle (Positioned gliding along inclined cable line)
gondola_pos = 0.35; // 35% along the span
gondola_x   = -span_distance / 2 + (span_distance * gondola_pos);
gondola_z   = station_a_cable_z + (cable_dz * gondola_pos);

translate([gondola_x, 0, gondola_z]) {
    // Cable Glider Sled Runner
    color("firebrick")
        trolley_carriage_glider_print();
    
    // C-Hanger Arm
    color("snow")
        translate([0, 0, -28.0])
            hanger_arm_snap_print();
            
    // Gondola Cabin & Roof
    color("crimson")
        translate([0, 0, -44.67])
            gondola_cabin_single_piece();
}
