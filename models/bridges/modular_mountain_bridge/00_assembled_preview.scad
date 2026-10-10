// ====================================================================
// Modular Mountain Bridge - ASSEMBLED PREVIEW (50% WIDER DECK + V-PYLON)
// ====================================================================

use <01_bridge_deck.scad>
use <02_bottom_center_pillar_30mm.scad>
use <03_top_cable_pylon_tower.scad>

module assembled_bridge() {
    color([0.28, 0.45, 0.65])
        bridge_deck_part();

    color([0.38, 0.40, 0.42])
        translate([0, 0, -30.0])
            bottom_center_pillar_part();

    color([0.88, 0.90, 0.92])
        translate([0, 0, 3.8])
            top_cable_pylon_tower_part();
}

assembled_bridge();
