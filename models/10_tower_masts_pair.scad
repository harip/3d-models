// ====================================================================
// [PRINT 10] Pair of 3D-Printable Tower Mast Poles (100mm Height)
// 100% Support-Free, standing vertically on build plate at Z = 0.
// Socket Plug-and-Play: Fits baseplate 09 and tower head sockets 06a / 07a.
// ====================================================================

$fn = 50;

mast_outer_d = 6.6;   // Fits 6.8mm socket with 0.2mm total clearance
mast_height  = 100.0; // 100mm tall mast column
bore_d       = 3.6;   // Hollow center bore for lightness & optional cable threading

module tower_mast_pole() {
    difference() {
        union() {
            // Main cylindrical mast shaft (6.6mm uniform outer diameter for clean socket insertion)
            cylinder(d = mast_outer_d, h = mast_height);
            
            // 0.2mm single-layer breakaway brim disk for 100% bed adhesion (peels off effortlessly)
            cylinder(d = 14.0, h = 0.2);
            
            // Decorative strength ribs along column (start 10mm above base to allow 10mm socket insertion depth)
            for (a = [0, 90, 180, 270]) {
                rotate([0, 0, a])
                    translate([mast_outer_d / 2 - 0.2, -0.6, 10.0])
                        cube([0.8, 1.2, mast_height - 20.0]);
            }
        }

        // Hollow interior bore (lightweight + cable routing)
        translate([0, 0, -1])
            cylinder(d = bore_d, h = mast_height + 2);

        // Bottom cross-pin hole (Z = 5.0mm; aligns with baseplate cross-pin hole when inserted into 3.0mm floor)
        translate([0, 0, 5.0])
            rotate([90, 0, 0])
                cylinder(d = 2.4, h = 16.0, center = true);

        // Top cross-pin hole (Z = 95.0mm; aligns with tower head lower socket cross-pin hole)
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

