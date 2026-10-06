// ====================================================================
// Alpine Cable Glider Sled Runner (100% Snap-Fit Carriage)
// 
// Features:
// - Top Glider Channel: Smooth 45-degree trumpet funnels glide snag-free on cable line.
// - Bottom Clevis Ears: Open 45-degree snap lead-in slots for receiving the 
//   integrated snap-studs of the classic C-Hanger Arm (03).
// - ZERO MOVING PARTS, ZERO BRIDGES, ZERO SUPPORTS NEEDED!
// ====================================================================

$fn = 50;

chassis_l    = 32.0; // Overall glider length (mm)
chassis_w    = 10.0; // Overall glider width (mm)
chassis_h    = 12.0; // Chassis height (mm)
cable_bore_d = 3.2;  // Inner smooth cable channel diameter (fits 1.0-2.5mm line)
clevis_gap   = 4.4;  // Fits 4.0mm hanger arm tab with 0.2mm clearance per side
clevis_ear_h = 5.5;  // Lower clevis ear height
snap_stud_d  = 3.4;  // Socket diameter for hanger arm studs


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

        // Longitudinal smooth cable tunnel bore
        translate([0, 0, 4.0])
            rotate([0, 90, 0])
                cylinder(d = cable_bore_d, h = chassis_l + 4, center = true);

        // Flared trumpet entry funnels at both ends (+X and -X)
        translate([chassis_l / 2 - 2, 0, 4.0])
            rotate([0, 90, 0])
                cylinder(d1 = cable_bore_d, d2 = 8.5, h = 6.0);
        translate([-chassis_l / 2 + 2, 0, 4.0])
            rotate([0, -90, 0])
                cylinder(d1 = cable_bore_d, d2 = 8.5, h = 6.0);

        // Top snap-entry slot (2.2mm top opening)
        translate([0, 0, 2.0])
            cube([chassis_l + 4, 2.2, 5.0], center = true);

        // --- LOWER CLEVIS SNAP SOCKETS FOR RECEIVING C-HANGER ARM STUDS ---
        // 1. Round bearing sockets (3.4mm diameter)
        translate([0, 0, chassis_h + clevis_ear_h / 2])
            rotate([90, 0, 0])
                cylinder(d = snap_stud_d, h = chassis_w + 4, center = true);

        // 2. Open-top vertical snap entry slots (3.0mm constriction width)
        translate([0, 0, chassis_h + clevis_ear_h * 0.25])
            cube([3.0, chassis_w + 4, 5.0], center = true);

        // 3. 45-degree self-guiding lead-in mouth at entry
        translate([0, 0, chassis_h - 0.5])
            rotate([45, 0, 0])
                cube([4.0, 4.0, 18.0], center = true);

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
