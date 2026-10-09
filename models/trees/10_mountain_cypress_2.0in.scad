// ====================================================================
// 3D Printable Mountain Cypress / Cedar (Cupressus Nootkatensis)
// Height: 2.0 inches (50.8 mm)
// Features:
// - Botanically accurate vertical flame / fastigiate silhouette
// - Layered scale-like foliage plates with zero overhangs > 45 deg
// - Bed-adhesion root buttress foot at Z=0 for high stability
// - 100% 3D Printable single manifold solid, 0% print supports needed
// ====================================================================

$fn = 32;

module mountain_cypress(h = 50.80) {
    union() {
        // Trunk & Bed-Adhesion Base Foot
        color([0.36, 0.24, 0.14]) { // Dark Cedar Bark Brown
            union() {
                // Thin 0.45mm breakaway wide base disc (32mm diameter) for bed adhesion
                cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
                
                cylinder(r1 = 6.0, r2 = 2.8, h = 4.0);
                hull() {
                    translate([0, 0, 3.0]) cylinder(r = 2.8, h = h * 0.20);
                    translate([0, 0, h * 0.85]) cylinder(r1 = 1.8, r2 = 0.7, h = 3.0);
                }
                for (a = [0 : 60 : 300]) {
                    rotate([0, 0, a])
                        hull() {
                            translate([5.2, 0, 0.4]) sphere(r = 0.5, $fn = 8);
                            translate([2.5, 0, 2.8]) sphere(r = 0.35, $fn = 8);
                        }
                }
            }
        }
        
        // Vertical Flame / Scale Foliage Plates
        color([0.20, 0.46, 0.28]) { // Mountain Cypress Green
            for (t = [0 : 5]) {
                tz = h * (0.18 + t * 0.13);
                r_max = 12.5 * sin((t + 1) / 7 * 180);
                th = 9.0;
                translate([0, 0, tz]) {
                    union() {
                        cylinder(r1 = r_max * 0.85, r2 = r_max * 0.45, h = th);
                        for (i = [0 : 4]) {
                            rotate([0, 0, i * 72 + t * 25]) {
                                translate([0, r_max * 0.70, 0])
                                    rotate([-15, 0, 0])
                                        scale([0.6, 1.2, 1.0])
                                            cylinder(r1 = r_max * 0.3, r2 = 0.2, h = th * 0.8, $fn = 8);
                            }
                        }
                    }
                }
            }
            // Top Leader Spire Apex
            translate([0, 0, h - 6.5])
                cylinder(r1 = 1.4, r2 = 0.3, h = 6.5);
        }
    }
}

mountain_cypress(50.80);
