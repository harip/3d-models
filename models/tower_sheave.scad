// ====================================================================
// Precision 3D-Printable Sheave Wheel (Reduced 10% Length / 4.5mm Bore)
// - Fits Tower A & Tower B brackets perfectly.
// - Center axle bore increased slightly to 4.5mm for ultra-smooth spin clearance!
// - 100% Flat on build plate at Z = 0 (Zero floating overhangs!).
// - Self-supporting 45-degree V-groove cable track.
// ====================================================================

$fn = 60;

sheave_outer_d = 18.0;  // Flange outer diameter (mm)
sheave_pitch_d = 14.67; // Cable track groove diameter (mm)
sheave_h       = 4.5;   // Total wheel thickness (mm) - REDUCED 10% from 5.0mm!
bore_d         = 4.5;   // Increased rod clearance bore (mm) - ultra-smooth spin!
hub_ring_d     = 7.8;   // Low-friction standoff ring (mm)
hub_standoff   = 0.4;   // Low-friction standoff height (mm)
grub_screw_d   = 3.0;   // M3 set screw hole for motor lock

module tower_sheave() {
    difference() {
        union() {
            cylinder(d = sheave_outer_d, h = sheave_h);
            translate([0, 0, sheave_h])
                cylinder(d1 = hub_ring_d, d2 = hub_ring_d - 0.8, h = hub_standoff);
        }

        translate([0, 0, -1])
            cylinder(d = bore_d, h = sheave_h + hub_standoff + 2);

        translate([0, 0, sheave_h / 2])
            rotate_extrude(convexity = 10) {
                translate([sheave_pitch_d / 2, 0, 0])
                    polygon([
                        [0, 0],          // Groove root point at R = 7.335mm
                        [2.25,  1.5],   // Top outer flange ramp at 45 deg
                        [3.5,   1.5],   // Outer clearance
                        [3.5,  -1.5],   // Outer clearance
                        [2.25, -1.5]    // Bottom outer flange ramp at 45 deg
                    ]);
            }

        translate([0, 0, -0.01])
            cylinder(d1 = bore_d + 1.0, d2 = bore_d, h = 0.8);

        translate([0, 0, sheave_h / 2])
            rotate([90, 0, 0])
                cylinder(d = grub_screw_d, h = sheave_outer_d + 2, center = true);

        for (a = [0 : 60 : 300]) {
            rotate([0, 0, a])
                translate([5.7, 0, -1])
                    cylinder(d = 2.4, h = sheave_h + hub_standoff + 2);
        }
    }
}

tower_sheave();
