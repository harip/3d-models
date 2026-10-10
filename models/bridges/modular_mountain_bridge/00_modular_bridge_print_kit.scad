// ====================================================================
// Modular Snap-In Mountain Bridge - 3-IN-1 PRINT KIT
// ====================================================================

use <01_bridge_deck.scad>
use <02_bottom_center_pillar_30mm.scad>
use <03_top_cable_pylon_tower.scad>

module modular_bridge_print_kit() {
    translate([0, 0, 0])
        bridge_deck_part();

    translate([0, -24.0, 0])
        bottom_center_pillar_part();

    translate([0, 24.0, 2.2])
        top_cable_pylon_tower_part();
}

modular_bridge_print_kit();
