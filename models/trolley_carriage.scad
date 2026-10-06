// ====================================================================
// Alpine Cable Glider Sled Runner (100% Snap-In - ZERO Through-Holes)
// 
// Features:
// - Top Glider Channel: Smooth 45-degree trumpet funnels glide snag-free on cable line.
// - Bottom Snap-Socket: 100% blind inner detents with 45-degree lead-in chamfers.
// - ZERO exterior holes! ZERO loose pins! ZERO screws!
// - Top tab of C-Hanger Arm (03) pushes straight into the bottom slot and CLICKS!
// ====================================================================

$fn = 50;

chassis_l    = 32.0; // Overall glider length (mm)
chassis_w    = 10.0; // Overall glider width (mm)
chassis_h    = 12.0; // Chassis height (mm)
cable_bore_d = 3.2;  // Inner smooth cable channel diameter
clevis_gap   = 4.4;  // Fits 4.0mm hanger arm tab
clevis_ear_h = 5.5;  // Lower clevis ear height
snap_stud_d  = 3.4;  // Blind socket detent diameter


module trolley_carriage_glider_print() {
    difference() {
        union() {
            // Main chassis block (flat on bed at Z = 0)
            translate([0, 0, chassis_h / 2])
                cube([chassis_l, chassis_w, chassis_h], center = true);
            
            // Lower hanger clevis ears (Solid outer walls - ZERO exterior holes!)
            translate([0, (clevis_gap + (chassis_w - clevis_gap)/2) / 2, chassis_h + clevis_ear_h / 2])
                cube([16.0, (chassis_w - clevis_gap)/2, clevis_ear_h], center = true);
            translate([0, -(clevis_gap + (chassis_w - clevis_gap)/2) / 2, chassis_h + clevis_ear_h / 2])
                cube([16.0, (chassis_w - clevis_gap)/2, clevis_ear_h], center = true);
        }

        // 1. Longitudinal smooth cable tunnel bore
        translate([0, 0, 4.0])
            rotate([0, 90, 0])
                cylinder(d = cable_bore_d, h = chassis_l + 4, center = true);

        // 2. Flared trumpet entry funnels at both ends (+X and -X)
        translate([chassis_l / 2 - 2, 0, 4.0])
            rotate([0, 90, 0])
                cylinder(d1 = cable_bore_d, d2 = 8.5, h = 6.0);
        translate([-chassis_l / 2 + 2, 0, 4.0])
            rotate([0, -90, 0])
                cylinder(d1 = cable_bore_d, d2 = 8.5, h = 6.0);

        // 3. Top snap-entry slot (2.2mm top opening)
        translate([0, 0, 2.0])
            cube([chassis_l + 4, 2.2, 5.0], center = true);

        // --- BLIND INNER SNAP-DETENT SOCKET (ZERO THROUGH-HOLES) ---
        // 4. Central receiving slot for 4.0mm C-Hanger Arm top tab
        translate([0, 0, chassis_h + clevis_ear_h / 2 + 0.5])
            cube([12.0, clevis_gap, clevis_ear_h + 2], center = true);

        // 5. Blind inner circular socket detents (3.4mm dia, 1.8mm depth - stops before outer wall!)
        for (y_sign = [-1, 1]) {
            translate([0, y_sign * (clevis_gap / 2 + 0.9), chassis_h + clevis_ear_h / 2])
                rotate([90, 0, 0])
                    cylinder(d = snap_stud_d, h = 1.8, center = true);
        }

        // 6. 45-degree self-guiding lead-in chamfers at entry mouth
        translate([0, 0, chassis_h + clevis_ear_h + 0.5])
            rotate([45, 0, 0])
                cube([4.0, 4.0, 18.0], center = true);

        // Optional haul-line tie-off slots (for motorized pull string)
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
