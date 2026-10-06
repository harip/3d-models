// ====================================================================
// COMPLETE 100% 3D-PRINTABLE GONDOLA SYSTEM - MASTER COMBINED PLATE
// All components laid out side-by-side flat on build plate at Z = 0.
// ZERO SUPPORTS NEEDED FOR ANY PART!
// ====================================================================

use <01_gondola_single_piece.scad>;
use <gondola_cabin.scad>;
use <trolley_carriage.scad>;
use <trolley_wheel.scad>;
use <05_trolley_wheels_pair.scad>;
use <10_tower_masts_pair.scad>;
use <tower_head_station_a.scad>;
use <tower_head_station_b.scad>;
use <tower_sheave.scad>;
use <tower_base_and_stand.scad>;


$fn = 40;

// Master Layout on Build Plate (Generously Spaced)

translate([-40, -30, 0]) gondola_cabin_single_piece();
translate([-40,  30, 0]) unified_glider_hanger_print();





// 2. Tower Heads A & B (Center & Front Right)
translate([10, -30, 0])  tower_head_a_socket();
translate([10, 0, 0])    tower_head_a_bracket();

translate([35, -30, 0])  tower_head_b_socket();
translate([35, 0, 0])    tower_head_b_bracket();

// 3. Tower Sheaves (Center Right)
translate([10, 45, 0])   tower_sheave();
translate([35, 45, 0])   tower_sheave();

// 4. Tower Bases & Masts (Rear)
translate([10, 90, 0])   tower_base();
translate([-40, 90, 0])  tower_base();
translate([60, -20, 0])  tower_mast_pole();
translate([60,  20, 0])  tower_mast_pole();

