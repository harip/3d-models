// ====================================================================
// Alpine Cable Glider Sled Runner (100% 3D-Printable - Wheel-Less Design)
// 
// Features:
// - ZERO moving parts! ZERO wheels to print or assemble!
// - Smooth curved top guide groove with 45-degree flared trumpet funnels
//   at both ends for friction-free sliding along any cable/string line.
// - Snap-retention top lip prevents derailment.
// - Printed upside down flat on top face at Z = 0 (100% support free!).
// ====================================================================

$fn = 50;

chassis_l    = 32.0; // Overall glider length (mm)
chassis_w    = 10.0; // Overall glider width (mm)
chassis_h    = 12.0; // Chassis height (mm)
cable_bore_d = 3.2;  // Inner smooth cable channel diameter (fits 1.0-2.5mm line)
clevis_gap   = 4.6;  // Fits 4.0mm hanger arm tab
clevis_ear_h = 5.5;  // Lower clevis ear height


module trolley_carriage_glider_print() {
    difference() {
        union() {
            // Main chassis block (flat on bed at Z = 0)
            translate([0, 0, chassis_h / 2])
                cube([chassis_l, chassis_w, chassis_h], center = true);
            
            // Lower hanger clevis ears
            translate([0, (clevis_gap + (chassis_w - clevis_gap)/2) / 2, chassis_h + clevis_ear_h / 2])
                cube([16.0, (chassis_w - clevis_gap)/2, clevis_ear_h], center = true);
            translate([0, -(clevis_gap + (chassis_w - clevis_gap)/2) / 2, chassis_h + clevis_ear_h / 2])
                cube([16.0, (chassis_w - clevis_gap)/2, clevis_ear_h], center = true);
        }

        // Longitudinal smooth cable tunnel bore (centered at Z = 4.0mm from top bed face)
        translate([0, 0, 4.0])
            rotate([0, 90, 0])
                cylinder(d = cable_bore_d, h = chassis_l + 4, center = true);

        // Flared trumpet entry funnels at both ends (+X and -X) for snag-free cable glide
        translate([chassis_l / 2 - 2, 0, 4.0])
            rotate([0, 90, 0])
                cylinder(d1 = cable_bore_d, d2 = 8.5, h = 6.0);
        translate([-chassis_l / 2 + 2, 0, 4.0])
            rotate([0, -90, 0])
                cylinder(d1 = cable_bore_d, d2 = 8.5, h = 6.0);

        // Top snap-entry slot (2.2mm top opening allows cable to snap in from above)
        translate([0, 0, 2.0])
            cube([chassis_l + 4, 2.2, 5.0], center = true);

        // Hanger arm pivot pin hole (4.2mm diameter) through lower clevis ears
        translate([0, 0, chassis_h + clevis_ear_h / 2])
            rotate([90, 0, 0])
                cylinder(d = 4.2, h = chassis_w + 4, center = true);

        // Haul-line tie-off / clamp holes for optional motorized pull string
        translate([6, 0, 8.5])
            rotate([0, 90, 0])
                cylinder(d = 2.4, h = chassis_w + 4, center = true);
        translate([-6, 0, 8.5])
            rotate([0, 90, 0])
                cylinder(d = 2.4, h = chassis_w + 4, center = true);
    }
}

module trolley_carriage() {
    translate([0, 0, 9.0])
        rotate([180, 0, 0])
            trolley_carriage_glider_print();
}

// Render flat on bed at Z = 0
trolley_carriage_glider_print();
