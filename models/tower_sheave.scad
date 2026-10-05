// ====================================================================
// Tower End Sheave Wheel (100% 3D-Printable - Flat on Bed at Z = 0)
// Used at Tower A and Tower B.
// - High flanges to retain cable line securely.
// - 5mm central bore: spins on an M4/M5 bolt in Phase 1;
//   directly accepts a NEMA 17 D-shaft in Phase 2 (includes M3 grub screw hole).
// ====================================================================

$fn = 60;

// Dimensions (mm) - Scaled to 1/3 size (reduced size by 2/3rd)
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

// Render flat on bed at Z = 0
tower_sheave();
