// ====================================================================
// Intermediate Alpine Cableway Twin-Sheave Support Tower (Continuous Loop)
// 
// Mechanical & Engineering Features:
// - Continuous Closed-Loop Cable Support: Holds BOTH the Uphill Cable Run and the Downhill Return Cable Run simultaneously!
// - Dual Sheave Cross-Arm: 
//   - Track 1 Sheave (Uphill Line): Positioned at Y = -5.0mm (open cantilever passage for uphill gondolas).
//   - Track 2 Sheave (Downhill Return Line): Positioned at Y = +19.0mm (open cantilever passage for downhill return line).
// - Deep V-Groove Retention: Cable tension forces the rope deep into the 45-degree V-groove track, preventing rope jump-off.
// - 100% Support-Free: Rests flat on build plate at Z = 0.
// ====================================================================

$fn = 40;

// Tower Dimensions (mm)
tower_axle_z  = 91.0;  // Axle center height at midpoint X = 0mm
base_l        = 36.0;  // Foundation baseplate length along X-axis
base_w        = 54.0;  // Wide foundation baseplate width spanning both cable lines
base_h        = 3.0;   // Baseplate thickness
mast_y        = 7.0;   // Central mast column position between Track 1 and Track 2

module rounded_box(l, w, h, r) {
    hull() {
        for (x = [-l/2 + r, l/2 - r]) {
            for (y = [-w/2 + r, w/2 - r]) {
                translate([x, y, 0])
                    cylinder(r = r, h = h);
            }
        }
    }
}

module twin_sheave_intermediate_tower() {
    difference() {
        union() {
            // 1. Centralized Wide Baseplate (Spans Y = -18mm to +32mm at Z = 0)
            translate([0, mast_y, base_h / 2])
                hull() {
                    rounded_box(base_l, base_w, base_h, 4.0);
                }

            // 2. Main Central Mast Column (Positioned at Y = +7.0mm between the two cable lines)
            hull() {
                translate([0, mast_y, base_h])
                    cube([base_l - 10.0, 18.0, 1.0], center = true);
                translate([0, mast_y, tower_axle_z - 10.0])
                    cube([12.0, 12.0, 1.0], center = true);
            }

            // 3. Double-Sided T-Beam Cross-Arm (Extends to Y = -5.0mm on left and Y = +19.0mm on right)
            hull() {
                translate([0, mast_y, tower_axle_z - 8.0])
                    cube([14.0, 12.0, 10.0], center = true);
                translate([0, -5.0, tower_axle_z - 8.0])
                    cube([14.0, 14.0, 6.0], center = true);
                translate([0, 19.0, tower_axle_z - 8.0])
                    cube([14.0, 14.0, 6.0], center = true);
            }

            // 4. Double Vertical Clevis Ear Sets (Track 1 @ Y = -5.0mm & Track 2 @ Y = +19.0mm)
            for (track_y = [-5.0, 19.0]) {
                for (y_sign = [-1, 1]) {
                    translate([0, track_y + y_sign * 5.0, tower_axle_z])
                        cube([16.0, 4.0, 16.0], center = true);
                    
                    // Lower 45-degree self-supporting anchor gussets
                    translate([0, track_y + y_sign * 5.0, tower_axle_z - 6.0])
                        rotate([0, 90, 0])
                            rotate([0, 0, 45])
                                cube([8.0 / sqrt(2), 8.0 / sqrt(2), 16.0], center = true);
                }
            }
        }

        // --- SUBTRACTIONS ---

        // A. Weight-Reduction Arch Cutouts in Central Mast
        translate([0, mast_y, (tower_axle_z - 10.0) / 2])
            rotate([0, 90, 0])
                cylinder(d = 14.0, h = base_l + 10, center = true);

        // B. Axle Bores for Track 1 & Track 2 (5.2mm bore diameter)
        translate([0, -5.0, tower_axle_z])
            rotate([90, 0, 0])
                cylinder(d = 5.2, h = 24, center = true);

        translate([0, 19.0, tower_axle_z])
            rotate([90, 0, 0])
                cylinder(d = 5.2, h = 24, center = true);

        // C. Baseplate Mounting Screw Holes (4x M3 countersunk holes)
        for (x_sign = [-1, 1]) {
            for (y_sign = [-1, 1]) {
                translate([x_sign * (base_l / 2 - 5.0), mast_y + y_sign * (base_w / 2 - 5.0), -1]) {
                    cylinder(d = 3.4, h = base_h + 4);
                    cylinder(d1 = 6.2, d2 = 3.4, h = 2.0);
                }
            }
        }
    }
}

// Render flat on foundation baseplate at Z = 0
twin_sheave_intermediate_tower();
