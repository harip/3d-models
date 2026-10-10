// ====================================================================
// Modular Chopper System (3.5 cm Square) - Full Assembled Preview
// Zero Floating Objects - 100% Supportless DFAM Architecture
//
// Features:
// - Full interactive 3D assembly of all modular components
// - Rotor rotation control via `rotor_angle` variable or animation ($t)
// - Choice of landing gear (gear_mode = "skids" or "wheels")
// - Choice of rotor style (rotor_blades = 2 or 3)
// - Docked on the 35.0 mm x 35.0 mm modular interlocking helipad tile
// ====================================================================

use <01_chopper_fuselage.scad>
use <02_rotatable_rotor.scad>
use <03_rotor_axle_pin.scad>
use <04_modular_skids.scad>
use <05_modular_35mm_helipad_base.scad>

// Assembly configuration parameters
rotor_angle  = 35;       // Set manually or animate with $t * 360
gear_mode    = "skids";  // "skids" or "wheels"
rotor_blades = 2;        // 2 or 3 blades
show_helipad = true;

// Vertical stack offsets
helipad_top_z   = 3.2;   // Top face of 35mm helipad deck
gear_height_z   = 2.2;   // Height added by landing gear
fuselage_base_z = show_helipad ? helipad_top_z : 0;

module assembled_chopper() {
    translate([0, 0, fuselage_base_z]) {
        // 1. Modular Landing Gear (Skids or Wheeled Taxi Gear)
        if (gear_mode == "skids") {
            color([0.35, 0.38, 0.42]) // Matte gunmetal grey
                landing_skids();
        } else {
            color([0.25, 0.25, 0.28])
                wheeled_gear();
        }

        // 2. Chopper Fuselage (docked onto gear pins at gear_height_z)
        translate([0, 0, gear_height_z]) {
            color([0.96, 0.72, 0.12]) { // Rescue Safety Yellow / Gold
                modular_cabin();
                translate([-6.5, 0, 2.2])
                    modular_tail_boom();
            }

            // 3. Rotatable Rotor Assembly (mounted on mast collar at Z = 12.7mm)
            translate([0, 0, 12.7]) {
                rotate([0, 0, ($t > 0) ? ($t * 360) : rotor_angle]) {
                    color([0.18, 0.20, 0.22]) // Carbon graphite black
                        rotatable_rotor(blades = rotor_blades, bore_d = 2.8);
                }

                // 4. Rotor Axle Pin & Retaining Cap (inserted through rotor into mast)
                translate([0, 0, 2.2 + 1.2])
                    rotate([180, 0, 0])
                        color([0.75, 0.78, 0.82]) // Polished titanium
                            rotor_axle_pin();
            }
        }
    }
}

// 5. Modular 35mm Helipad Base
if (show_helipad) {
    color([0.55, 0.58, 0.62]) // Concrete tarmac with bright markings
        helipad_tile();
}

assembled_chopper();
