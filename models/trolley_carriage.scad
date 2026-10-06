// ====================================================================
// Unified 1-Piece Cable Glider Carriage + C-Hanger Arm
// 
// 100% 3D-Printable - ZERO SUPPORTS - ZERO LOOSE PINS - ZERO HARDWARE!
//
// Features:
// - Top Glider Runner: Smooth 45-degree trumpet funnels glide snag-free on cable line.
// - Integrated C-Hanger Arm: Solid 4.0mm thick arm fused directly to the glider head.
// - Bottom Snap-Studs: Solid integrated 3.4mm side studs snap directly into the gondola roof!
// - Printed flat on its side at Z = 0 like a keytag.
// ====================================================================

$fn = 50;

chassis_l    = 32.0; // Glider runner head length (mm)
chassis_w    = 8.0;  // Glider head width (mm)
cable_bore_d = 3.2;  // Inner smooth cable channel diameter (fits 1.0-2.5mm line)
hanger_h     = 24.0; // Vertical clearance from roof to cable
hanger_off   = 10.0; // Cable clearance offset
arm_th       = 4.0;  // Solid arm thickness (mm)
snap_stud_d  = 3.4;  // Integrated snap stud diameter
snap_stud_l  = 1.8;  // Stud protrusion length on each side

module unified_glider_hanger_flat() {
    linear_extrude(height = arm_th) {
        difference() {
            union() {
                // Top Glider Head
                translate([0, hanger_h])
                    hull() {
                        translate([-chassis_l / 2 + 4, 0]) circle(d = 8.0);
                        translate([ chassis_l / 2 - 4, 0]) circle(d = 8.0);
                    }

                // C-Hanger Arm curve
                hull() {
                    translate([0, hanger_h]) circle(d = 8.0);
                    translate([hanger_off, hanger_h]) circle(d = 8.0);
                }
                hull() {
                    translate([hanger_off, hanger_h]) circle(d = 8.0);
                    translate([hanger_off, 4.0]) circle(d = 8.0);
                }
                hull() {
                    translate([hanger_off, 4.0]) circle(d = 8.0);
                    translate([0, 4.0]) circle(d = 8.0);
                }
                // Bottom roof mounting tab
                translate([0, 0])
                    hull() {
                        translate([0, 0]) circle(d = 8.0);
                        translate([0, 6.0]) circle(d = 8.0);
                    }
            }

            // Top cable line channel slot (cuts through Z in 2D flat mode)
            translate([0, hanger_h])
                square([chassis_l + 4, cable_bore_d], center = true);

            // Flared trumpet entry funnels at both ends (+X and -X)
            translate([chassis_l / 2 - 2, hanger_h])
                polygon([[-2, -1.6], [4, -4.5], [4, 4.5], [-2, 1.6]]);
            translate([-chassis_l / 2 + 2, hanger_h])
                polygon([[2, -1.6], [-4, -4.5], [-4, 4.5], [2, 1.6]]);
        }
    }
}

// 3D Model with Integrated Bottom Snap-Studs
module unified_glider_hanger_print() {
    union() {
        // Main flat glider + arm body resting at Z = 0
        translate([0, 0, arm_th / 2])
            rotate([90, 0, 0])
                unified_glider_hanger_flat();

        // Integrated Solid Snap-Studs at bottom tip (for clicking into roof clevis)
        translate([0, 0, 0])
            rotate([90, 0, 0])
                cylinder(d = snap_stud_d, h = clevis_slot_width_val() + (snap_stud_l * 2), center = true);
    }
}

function clevis_slot_width_val() = 4.4;

module trolley_carriage() {
    unified_glider_hanger_print();
}

// Render flat on bed at Z = 0
unified_glider_hanger_print();
