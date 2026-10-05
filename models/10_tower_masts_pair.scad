// ====================================================================
// [PRINT 10] Pair of 3D-Printable Tower Mast Poles (100mm Height)
// 100% Support-Free, standing vertically on build plate at Z = 0.
// Socket Plug-and-Play: Fits baseplate 09 and tower head sockets 06a / 07a.
// ====================================================================

$fn = 50;

mast_outer_d = 6.6;  // Fits 6.8mm socket with 0.1mm clearance
mast_height  = 100.0; // 100mm tall mast column
plug_depth   = 9.5;  // Socket plug depth
bore_d       = 3.6;  // Hollow center bore for lightness & optional cable threading

module tower_mast_pole() {
    difference() {
        union() {
            // Main cylindrical mast shaft
            cylinder(d = mast_outer_d, h = mast_height);
            
            // Lower plug base (rests flat at Z = 0 with removable 12mm brim disk for adhesion)
            cylinder(d = 12.0, h = 1.0);
            
            // Decorative strength ribs along column
            for (a = [0, 90, 180, 270]) {
                rotate([0, 0, a])
                    translate([mast_outer_d / 2 - 0.2, -0.6, 1.0])
                        cube([0.8, 1.2, mast_height - 10.0]);
            }
        }

        // Hollow interior bore (lightweight + cable routing)
        translate([0, 0, -1])
            cylinder(d = bore_d, h = mast_height + 2);

        // Top socket pocket to receive tower head snap post (or stack another mast)
        translate([0, 0, mast_height - plug_depth])
            cylinder(d = mast_outer_d, h = plug_depth + 1);

        // Cross-pin clamp holes for locking pin at top and bottom
        translate([0, 0, 5.0])
            rotate([90, 0, 0])
                cylinder(d = 2.4, h = 16.0, center = true);

        translate([0, 0, mast_height - 5.0])
            rotate([90, 0, 0])
                cylinder(d = 2.4, h = 16.0, center = true);
    }
}

// Pair of 2 Mast Poles spaced comfortably on build plate at Z = 0
translate([-15.0, 0, 0])
    tower_mast_pole();

translate([15.0, 0, 0])
    tower_mast_pole();
