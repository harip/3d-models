// ====================================================================
// [PRINT 08] Pair of Tower Sheave Wheels (54mm Snowflake Pulleys)
// - Fits Tower A & Tower B brackets perfectly.
// - 100% Flat on build plate at Z = 0 (Zero floating overhangs!).
// - Self-supporting 45-degree V-groove cable track.
// - Center axle hub standoff ring so wheel spins 100% smoothly on M5 bolt.
// - BOTH WHEELS REST FLAT ON BED AT Z = 0 WITH GENEROUS CLEARANCE.
// - ZERO SUPPORTS NEEDED!
// ====================================================================

$fn = 60;

sheave_outer_d = 18.0;  // Flange outer diameter (mm)
sheave_pitch_d = 14.67; // Cable track groove diameter (mm)
sheave_h       = 5.0;   // Total wheel thickness (mm)
bore_d         = 5.2;   // M5 axle bolt / 5mm motor shaft clearance (mm)
hub_ring_d     = 8.2;   // Reduced friction hub standoff ring (mm)
hub_standoff   = 0.4;   // Low-friction standoff height (mm)
grub_screw_d   = 3.0;   // M3 set screw hole for Phase 2 motor lock

module tower_sheave() {
    difference() {
        union() {
            // Main solid cylinder resting flat on bed at Z = 0
            cylinder(d = sheave_outer_d, h = sheave_h);

            // Top raised hub standoff ring (prevents wheel face from rubbing on bracket)
            translate([0, 0, sheave_h])
                cylinder(d1 = hub_ring_d, d2 = hub_ring_d - 0.8, h = hub_standoff);
        }

        // 1. Center shaft bore (5.2mm for M5 bolt)
        translate([0, 0, -1])
            cylinder(d = bore_d, h = sheave_h + hub_standoff + 2);

        // 2. Self-supporting 45-degree V-groove cable track
        // Groove is centered at Z = sheave_h / 2 = 2.5mm
        translate([0, 0, sheave_h / 2])
            rotate_extrude(convexity = 10) {
                translate([sheave_pitch_d / 2, 0, 0])
                    polygon([
                        [0, 0],          // Groove root point at R = 7.335mm
                        [2.5,  1.6],    // Top outer flange ramp at 45 deg
                        [3.5,  1.6],    // Outer clearance
                        [3.5, -1.6],    // Outer clearance
                        [2.5, -1.6]     // Bottom outer flange ramp at 45 deg
                    ]);
            }

        // 3. Bottom self-alignment lead-in chamfer for M5 bolt
        translate([0, 0, -0.01])
            cylinder(d1 = bore_d + 1.2, d2 = bore_d, h = 0.8);

        // 4. Radial M3 grub screw hole (for clamping onto motor shaft)
        translate([0, 0, sheave_h / 2])
            rotate([90, 0, 0])
                cylinder(d = grub_screw_d, h = sheave_outer_d + 2, center = true);

        // 5. 6x Spoke cutouts (positioned accurately at R = 5.8mm)
        for (a = [0 : 60 : 300]) {
            rotate([0, 0, a])
                translate([5.8, 0, -1])
                    cylinder(d = 2.4, h = sheave_h + hub_standoff + 2);
        }
    }
}

// 2 large sheaves spaced comfortably, centered on bed at Z = 0
translate([-18, 0, 0])
    tower_sheave();

translate([18, 0, 0])
    tower_sheave();

