// ====================================================================
// [PRINT 08] Pair of Tower Sheave Wheels (54mm Snowflake Pulleys)
// High flanges for cable retention, 5mm motor D-shaft / M5 bolt bore.
// Both wheels rest flat on build plate at Z = 0 with generous clearance.
// ZERO SUPPORTS NEEDED!
// ====================================================================

$fn = 60;

sheave_outer_dia = 18.0; // Outer flange diameter [scaled from 54mm]
sheave_pitch_dia = 14.67;// Cable track diameter [scaled from 44mm]
sheave_width     = 4.0;  // Total sheave rim width [scaled from 8mm]
hub_h            = 6.0;  // Extended center hub [scaled from 12mm]
bore_dia         = 5.2;  // 5mm motor shaft / M5 screw clearance
grub_screw_dia   = 3.0;  // M3 set/grub screw for Phase 2 motor lock
hub_lift         = (hub_h - sheave_width) / 2; // 1.0mm standoff from bed

module tower_sheave() {
    difference() {
        union() {
            // Main sheave disc (lifted by hub standoff)
            translate([0, 0, hub_lift])
                cylinder(d = sheave_outer_dia, h = sheave_width);
            // Extended center hub (starts at Z = 0)
            cylinder(d = 14.0, h = hub_h);
        }
        
        // Center shaft bore
        translate([0, 0, -1])
            cylinder(d = bore_dia, h = hub_h + 2);
        
        // Deep cable groove
        translate([0, 0, hub_h / 2])
            rotate_extrude(convexity = 10) {
                translate([sheave_pitch_dia / 2, 0, 0])
                    polygon([
                        [-2.0, 0],
                        [6.0, 3.2],
                        [6.0, -3.2]
                    ]);
            }
        
        // Radial M3 grub screw hole (for clamping onto motor shaft in Phase 2)
        translate([0, 0, hub_h / 2])
            rotate([90, 0, 0])
                cylinder(d = grub_screw_dia, h = 20, center = false);
            
        // Decorative weight-reduction spoke cutouts (holiday snowflake / star style)
        for (a = [0 : 60 : 300]) {
            rotate([0, 0, a])
                translate([16, 0, -1])
                    cylinder(d = 8, h = hub_h + 2);
        }
    }
}

// 2 large sheaves spaced comfortably, centered on bed at Z = 0
translate([-38, 0, 0])
    tower_sheave();

translate([38, 0, 0])
    tower_sheave();
