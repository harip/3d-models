// ====================================================================
// Master Assembly Preview: Complete 3-Point Alpine Cableway System
// Open this file in OpenSCAD and press F5 for full 3D visual preview!
//
// System Components:
// 1. Station A: Alpine Base Station Chalet (Valley Floor @ X = -160mm)
// 2. Intermediate Cable Support Tower (Single-Piece Structure @ Midpoint X = 0mm)
// 3. Station B: Mountain Summit Chalet (Summit @ X = +160mm, Z = 60mm Elevation)
// 4. Gondola Vehicle: Riding smoothly along the inclined cable line!
// ALL 3 STRUCTURES USE THE EXACT SAME SHEAVE WHEEL, AXLE PIN & END CAP HARDWARE!
// ====================================================================

use <station_a_valley_building.scad>;
use <station_b_mountain_building.scad>;
use <intermediate_support_tower_single_piece.scad>;
use <01_gondola_single_piece.scad>;
use <03_hanger_arm.scad>;
use <04_trolley_carriage.scad>;
use <08a_tower_sheave_single.scad>;
use <08c_m5_axle_pin_only.scad>;
use <08d_m5_end_cap_only.scad>;

$fn = 30;

// System Spacing Parameters
span_distance  = 320.0; // Total distance between Station A & Station B (mm)
hill_elevation = 60.0;  // Mountain summit elevation height (mm)

// 1. Station A: Alpine Base Station Chalet (Bottom of Hill at X = -160)
translate([-span_distance / 2, 0, 0]) {
    color("sienna")
        station_a_valley_building();
    
    // Drive Sheave Wheel inside Roof Clevis
    color("gold")
        translate([0, -5.0, 61.0])
            rotate([90, 0, 0])
                tower_sheave();

    // Axle Pin & Retaining Cap Assembly
    color("silver")
        translate([0, -5.0, 61.0])
            rotate([90, 0, 0]) {
                translate([0, 0, -7.0]) precision_axle_pin();
                translate([0, 0,  7.0]) precision_retaining_end_cap();
            }
}

// 2. Intermediate Cable Support Tower Structure (Single-Piece @ Midpoint X = 0)
translate([0, 0, 0]) {
    color("steelblue")
        intermediate_support_tower();

    // Intermediate Support Sheave Wheel inside Tower Head Clevis
    color("gold")
        translate([0, -5.0, 91.0])
            rotate([90, 0, 0])
                tower_sheave();

    // Axle Pin & Retaining Cap Assembly
    color("silver")
        translate([0, -5.0, 91.0])
            rotate([90, 0, 0]) {
                translate([0, 0, -7.0]) precision_axle_pin();
                translate([0, 0,  7.0]) precision_retaining_end_cap();
            }
}

// 3. Station B: Mountain Summit Station Chalet (Top of Hill at X = +160, Z = +60)
translate([span_distance / 2, 0, hill_elevation]) {
    color("darkred")
        station_b_mountain_building();
    
    // Return Sheave Wheel inside Summit Roof Clevis
    color("gold")
        translate([0, -5.0, 61.0])
            rotate([90, 0, 0])
                tower_sheave();

    // Axle Pin & Retaining Cap Assembly
    color("silver")
        translate([0, -5.0, 61.0])
            rotate([90, 0, 0]) {
                translate([0, 0, -7.0]) precision_axle_pin();
                translate([0, 0,  7.0]) precision_retaining_end_cap();
            }
}

// 4. Continuous Inclined Track Cable Line (Passing across all 3 sheave wheels)
station_a_cable_z = 61.0;
station_b_cable_z = hill_elevation + 61.0;

cable_dx = span_distance;
cable_dz = station_b_cable_z - station_a_cable_z;
cable_angle = atan2(cable_dz, cable_dx);
cable_len   = sqrt(cable_dx*cable_dx + cable_dz*cable_dz);

translate([-span_distance / 2, -5.0, station_a_cable_z])
    rotate([0, -cable_angle, 0])
        color("black")
            translate([cable_len / 2, 0, 0])
                rotate([0, 90, 0])
                    cylinder(d = 1.2, h = cable_len, center = true);

// 5. Gondola Cabin Vehicle (Gliding along upper inclined section)
gondola_pos = 0.70; // 70% along the span
gondola_x   = -span_distance / 2 + (span_distance * gondola_pos);
gondola_z   = station_a_cable_z + (cable_dz * gondola_pos);

translate([gondola_x, -5.0, gondola_z]) {
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
