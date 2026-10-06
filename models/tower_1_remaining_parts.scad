// ====================================================================
// TOWER 1 REMAINING PARTS PRINT PLATE
// Contains ONLY the parts you need to print for Tower 1:
// 1. Part 08: Redesigned Sheave Wheel (Resting flat at Z = 0)
// 2. Part 09: Tower Baseplate
// 3. Part 10: 100mm Tower Mast Pole
//
// (You already printed 06-A and 06-B, which are 100% compatible!)
// ====================================================================

use <tower_sheave.scad>;
use <09_tower_base.scad>;
use <10_tower_masts_pair.scad>;

$fn = 50;

// 1. Redesigned Sheave Wheel 08 (Left)
translate([-25, 0, 0])
    tower_sheave();

// 2. Baseplate 09 (Center)
translate([0, 0, 0])
    tower_base();

// 3. 100mm Mast Pole 10 (Right - standing vertically)
translate([28, 0, 0])
    tower_mast_pole();
