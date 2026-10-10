// 3. Bristlecone Pine (3.60 in / 91.44 mm)
// Botanically Accurate: Gnarled twisted trunk, deadwood spike top, foxtail needle tufts
$fn = 24;

module bristlecone_pine_3_6in(h = 91.44) {
    union() {
        // Weathered Gnarled Alpine Trunk & Deadwood Spike
        color([0.46, 0.28, 0.17]) {
            cylinder(r1 = 9.5, r2 = 4.8, h = 6.0);
            hull() {
                translate([0, 0, 4.0]) cylinder(r = 4.8, h = 10.0);
                translate([4.0, 2.0, h * 0.35]) sphere(r = 4.0, $fn = 10);
            }
            hull() {
                translate([4.0, 2.0, h * 0.35]) sphere(r = 4.0, $fn = 10);
                translate([-3.0, 4.0, h * 0.60]) sphere(r = 3.2, $fn = 10);
            }
            hull() {
                translate([-3.0, 4.0, h * 0.60]) sphere(r = 3.2, $fn = 10);
                translate([1.5, 1.0, h * 0.85]) sphere(r = 2.2, $fn = 10);
            }
            // Exposed Deadwood Spike Top (characteristic of ancient subalpine pines)
            translate([1.5, 1.0, h * 0.85])
                cylinder(r1 = 2.0, r2 = 0.2, h = h * 0.15, $fn = 8);

            // Root buttresses
            for (a = [0 : 72 : 288]) {
                rotate([0, 0, a]) hull() {
                    translate([8.5, 0, 0.5]) sphere(r = 0.9, $fn = 8);
                    translate([4.2, 0, 3.5]) sphere(r = 0.5, $fn = 8);
                }
            }
            // Heavy twisted limb forks
            hull() {
                translate([4.0, 2.0, h * 0.35]) sphere(r = 2.8, $fn = 8);
                translate([16.0, 8.0, h * 0.48]) sphere(r = 1.6, $fn = 8);
            }
            hull() {
                translate([-3.0, 4.0, h * 0.60]) sphere(r = 2.4, $fn = 8);
                translate([-17.0, 5.0, h * 0.68]) sphere(r = 1.4, $fn = 8);
            }
            hull() {
                translate([1.5, 1.0, h * 0.82]) sphere(r = 1.8, $fn = 8);
                translate([10.0, -11.0, h * 0.86]) sphere(r = 1.2, $fn = 8);
            }
        }

        // Foxtail Needle Tufts (Dense bottleneck clusters attached to limbs)
        color([0.22, 0.44, 0.24]) {
            // Main Center Canopy Tuft
            translate([1.5, 1.0, h * 0.78])
                foxtail_tuft(r = 14.0, length = 16.0);
            // Limb 1 Tuft
            translate([16.0, 8.0, h * 0.48])
                foxtail_tuft(r = 12.0, length = 14.0);
            // Limb 2 Tuft
            translate([-17.0, 5.0, h * 0.68])
                foxtail_tuft(r = 13.0, length = 15.0);
            // Limb 3 Tuft
            translate([10.0, -11.0, h * 0.86])
                foxtail_tuft(r = 11.0, length = 13.0);
        }
    }
}

module foxtail_tuft(r = 12.0, length = 14.0) {
    union() {
        cylinder(r1 = 1.8, r2 = r, h = length * 0.5);
        translate([0, 0, length * 0.45])
            cylinder(r1 = r, r2 = 0.8, h = length * 0.55);
        for (a = [0 : 45 : 315]) {
            rotate([0, 0, a]) translate([0, r * 0.6, length * 0.3])
                rotate([25, 0, 0])
                    scale([0.8, 1.2, 0.8]) sphere(r = r * 0.3, $fn = 8);
        }
    }
}

bristlecone_pine_3_6in();
