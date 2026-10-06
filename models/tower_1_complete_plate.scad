// ====================================================================
// TOWER 1 COMPLETE PRINT PLATE (Drive / Station A Tower)
// Contains all 5 parts needed to print & assemble Tower 1:
// 1. Tower Baseplate (Part 09)
// 2. 100mm Tower Mast Pole (Part 10)
// 3. Lower Mast Socket (Part 06-A)
// 4. Upper Motor/Sheave Bracket (Part 06-B)
// 5. Snowflake Sheave Wheel (Part 08)
//
// All parts rest 100% FLAT on build plate at Z = 0.
// ZERO SUPPORTS NEEDED FOR ANY PART!
// ====================================================================

use <09_tower_base.scad>;
use <10_tower_masts_pair.scad>;
use <06a_tower_a_socket.scad>;
use <06b_tower_a_bracket.scad>;
use <tower_sheave.scad>;

$fn = 50;

// Layout on Print Bed (Generously spaced)

// 1. Baseplate (Left)
translate([-30, 0, 0])
    tower_base();

// 2. 100mm Mast Pole (Center Left - standing vertically)
translate([-5, 0, 0])
    tower_mast_pole();

// 3. Lower Socket 06-A (Center Right)
translate([18, -15, 0])
    tower_head_a_socket();

// 4. Upper Bracket 06-B (Center Right - laid flat on rear faceplate)
translate([18, 15, 0])
    translate([0, 1.5, 0])
        rotate([-90, 0, 0])
            tower_head_a_bracket();

// 5. Sheave Wheel 08 (Right)
translate([42, 0, 0])
    tower_sheave();
