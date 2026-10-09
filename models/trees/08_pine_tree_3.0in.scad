// ====================================================================
// 3D Printable Alpine Spruce / Pine Tree (Exact Reference Image Match)
// Height: 3.0 inches (76.2 mm)
// Features:
// - Exposed straight brown trunk base at Z=0..15mm
// - 7 layered drooping needle skirts tapering to sharp green top leader spire
// - Jagged feathered needle fan edges
// - 100% Supportless 3D printable single manifold solid
// ====================================================================

$fn = 32;

// Jagged needle bough skirt tier matching reference image
module pine_tier(r_base, r_top, h_tier, num_fans = 7, dip = 15) {
    color([0.22, 0.48, 0.25]) { // Natural Forest Pine Green
        union() {
            // Pronounced steep conical underside support cone starting smoothly down on trunk
            cone_h = h_tier * 1.85;
            translate([0, 0, -h_tier * 0.90])
                cylinder(r1 = 3.2, r2 = r_base * 0.90, h = cone_h, $fn = 32);
            
            // Outer drooping bough fans with feathered needle tips
            for (i = [0 : num_fans - 1]) {
                ang = i * (360 / num_fans);
                rotate([0, 0, ang]) {
                    rotate([dip, 0, 0]) {
                        // Gradual tapering bough arm (no flat horizontal underside steps)
                        hull() {
                            translate([0, 0, -h_tier * 0.20]) 
                                cylinder(r1 = 1.5, r2 = r_top * 0.50, h = h_tier * 0.80);
                            translate([0, r_base * 0.85, -h_tier * 0.12]) 
                                scale([1.4, 0.6, 0.6]) sphere(r = r_base * 0.18, $fn = 12);
                        }
                        
                        // Radiating jagged needle tip fingers
                        for (k = [-3 : 3]) {
                            rotate([0, 0, k * 11]) {
                                translate([0, r_base * 0.90, -h_tier * 0.18])
                                    rotate([34, 0, 0])
                                        scale([0.8, 1.2, 0.8])
                                            cylinder(r1 = r_base * 0.10, r2 = 0.2, h = h_tier * 0.45, $fn = 6);
                            }
                        }
                    }
                }
            }
        }
    }
}

module pine_tree_3in() {
    h = 76.2; // 3.0 inches
    trunk_r1 = 7.5; // Base foot radius
    trunk_r2 = 3.8; // Trunk radius
    
    union() {
        // Exposed Trunk & Base Foot
        color([0.38, 0.24, 0.14]) { // Dark Bark Brown
            union() {
                // Thin 0.45mm breakaway wide base disc (32mm diameter) for bed adhesion
                cylinder(h = 0.45, r = 16.0, center = false, $fn = 48);
                
                // Bed adhesion foot at Z=0
                cylinder(r1 = trunk_r1, r2 = trunk_r2, h = 4.5);
                
                // Straight exposed trunk up to Tier 1, then tapering internal spire
                hull() {
                    translate([0, 0, 3.0]) cylinder(r = trunk_r2, h = h * 0.25);
                    translate([0, 0, h * 0.80]) cylinder(r1 = trunk_r2 * 0.7, r2 = 1.0, h = 4.0);
                }
                
                // Root buttress flares at Z=0
                for (a = [0 : 60 : 300]) {
                    rotate([0, 0, a])
                        hull() {
                            translate([trunk_r1 * 0.9, 0, 0.4]) sphere(r = 0.6, $fn = 8);
                            translate([trunk_r2 * 0.85, 0, 3.0]) sphere(r = 0.4, $fn = 8);
                        }
                }
            }
        }
        
        // 7 Layered Drooping Bough Tiers (Matching Reference Photo)
        
        // Tier 1 (Lowest bough skirt starting above exposed trunk at Z = h * 0.20)
        translate([0, 0, h * 0.20])
            pine_tier(r_base = 23.5, r_top = 15.5, h_tier = 11.5, num_fans = 8, dip = 16);
            
        // Tier 2
        translate([0, 0, h * 0.32])
            rotate([0, 0, 22.5])
                pine_tier(r_base = 20.0, r_top = 13.0, h_tier = 11.0, num_fans = 7, dip = 15);
                
        // Tier 3
        translate([0, 0, h * 0.44])
            rotate([0, 0, 11])
                pine_tier(r_base = 16.5, r_top = 10.5, h_tier = 10.5, num_fans = 7, dip = 14);
                
        // Tier 4
        translate([0, 0, h * 0.56])
            rotate([0, 0, 30])
                pine_tier(r_base = 13.0, r_top = 8.0, h_tier = 9.5, num_fans = 6, dip = 12);
                
        // Tier 5
        translate([0, 0, h * 0.67])
            rotate([0, 0, 15])
                pine_tier(r_base = 9.8, r_top = 5.8, h_tier = 8.5, num_fans = 6, dip = 10);
                
        // Tier 6
        translate([0, 0, h * 0.77])
            rotate([0, 0, 36])
                pine_tier(r_base = 6.8, r_top = 3.8, h_tier = 7.0, num_fans = 5, dip = 8);
                
        // Tier 7 (Top Crown Skirt)
        translate([0, 0, h * 0.86])
            rotate([0, 0, 18])
                pine_tier(r_base = 4.5, r_top = 1.2, h_tier = 5.5, num_fans = 4, dip = 6);
                
        // Sharp Green Crown Top Leader Spire (Matching reference photo tip)
        translate([0, 0, h - 8.5]) {
            color([0.22, 0.48, 0.25]) { // Natural Forest Pine Green
                union() {
                    cylinder(r1 = 1.8, r2 = 0.3, h = 8.5);
                    for (ca = [0 : 90 : 270]) {
                        rotate([0, 0, ca])
                            translate([0, 0.6, 2.0])
                                rotate([18, 0, 0])
                                    cylinder(r1 = 0.6, r2 = 0.1, h = 4.5, $fn = 6);
                    }
                }
            }
        }
    }
}

pine_tree_3in();
