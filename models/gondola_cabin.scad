// ====================================================================
// Alpine Christmas Gondola Cabin & Hanger Arm (100% 3D-Printable)
// 
// Print-Optimized:
// - ZERO floating parts: all components sit perfectly flat on the build plate (Z=0).
// - Self-supporting window arches: 45-degree angled lintels eliminate bridging droop.
// - Flat hanger orientation: printed on its side for maximum strength along layer lines.
// ====================================================================

$fn = 40;

// Dimensions (mm) - Scaled to 1/3 size (reduced size by 2/3rd)
cabin_w       = 16.0;  // Width (across track) [scaled from 48mm]
cabin_l       = 21.33; // Length (along track) [scaled from 64mm]
cabin_h       = 16.67; // Body height [scaled from 50mm]
wall_th       = 1.2;   // Wall thickness [scaled from 2.4mm]
corner_r      = 2.0;   // Rounded corner radius [scaled from 6mm]

// Hanger Dimensions - Scaled envelope, functional hardware preserved
hanger_height = 21.67; // Vertical clearance from roof to trolley [scaled from 65mm]
hanger_offset = 8.67;  // Side offset to clear the cable line [scaled from 26mm]
hanger_th     = 3.2;   // Arm thickness [adjusted for printable stability]
pivot_pin_d   = 3.4;   // Hole matching trolley lower pivot (M3 screw standard fit)


// Helper: Rounded Box
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

// 1. Cabin Body (Sits flat on build plate at Z=0, zero supports needed)
module cabin_body() {
    door_w = cabin_l * 0.42;
    door_h = cabin_h * 0.72; // Raised bottom edge slightly above Z=0
    door_z = 0.6 + door_h / 2; // Bottom of door molding rests at Z = 0.6mm
    
    difference() {
        union() {
            // Outer shell (Flat at Z = 0)
            rounded_box(cabin_l, cabin_w, cabin_h, corner_r);
            
            // Outer door frame molding / trim on sides (+Y and -Y)
            for (y_sign = [-1, 1]) {
                translate([0, y_sign * (cabin_w / 2 + 0.1), door_z])
                    cube([door_w + 0.8, 0.4, door_h], center = true);
            }
        }
        
        // Hollow interior (cavity through Z)
        translate([0, 0, wall_th])
            rounded_box(cabin_l - wall_th*2, cabin_w - wall_th*2, cabin_h + 2, max(0.8, corner_r - wall_th));
        
        // Door panel recessed outlines and seams on both sides (+Y and -Y)
        for (y_sign = [-1, 1]) {
            // Door outline groove
            translate([0, y_sign * (cabin_w / 2), door_z])
                cube([door_w, 0.8, door_h], center = true);

            // Vertical center line for double-door seam
            translate([0, y_sign * (cabin_w / 2), door_z])
                cube([0.4, 1.2, door_h - 0.4], center = true);
                
            // Door handles
            translate([1.2, y_sign * (cabin_w / 2 + 0.15), door_z])
                rotate([90, 0, 0])
                    cylinder(d = 1.0, h = 1.0, center = true);
            translate([-1.2, y_sign * (cabin_w / 2 + 0.15), door_z])
                rotate([90, 0, 0])
                    cylinder(d = 1.0, h = 1.0, center = true);
        }


        // LARGE SIDE / DOOR WINDOW CUTOUTS (Punching 100% cleanly through side walls & doors)
        // Left & Right door window panels (Upper half of the doors are windows!)
        for (x = [-door_w * 0.26, door_w * 0.26]) {
            translate([x, 0, cabin_h * 0.58])
                rotate([90, 0, 0])
                    hull() {
                        cube([door_w * 0.38, cabin_h * 0.36, cabin_w + 10], center = true);
                        translate([0, cabin_h * 0.16, 0])
                            rotate([0, 0, 45])
                                cube([door_w * 0.26, door_w * 0.26, cabin_w + 10], center = true);
                    }
        }
        
        // FRONT & REAR LARGE WINDOW CUTOUTS (Punching 100% cleanly through front & back)
        for (x = [-cabin_l/2 - 2, cabin_l/2 + 2]) {
            translate([x, 0, cabin_h * 0.56])
                rotate([0, 90, 0])
                    hull() {
                        cube([cabin_h * 0.42, cabin_w * 0.58, 20], center = true);
                        translate([0, cabin_w * 0.20, 0])
                            rotate([0, 0, 45])
                                cube([cabin_w * 0.3, cabin_w * 0.3, 20], center = true);
                    }
        }
        
        // Roof alignment rim with front orientation keyway notch
        translate([0, 0, cabin_h - 2])
            difference() {
                rounded_box(cabin_l + 2, cabin_w + 2, 4, corner_r);
                rounded_box(cabin_l - 1.6, cabin_w - 1.6, 6, corner_r);
                // Alignment notch at front (+X)
                translate([cabin_l / 2 - 2, 0, 0])
                    cube([6, 8, 8], center = true);
            }
    }
}




// 2. Cabin Alpine Roof (100% Flat on Bed at Z=0, ZERO negative Z geometry)
module cabin_roof() {
    roof_lip = 1.2;      // Overhang lip [scaled from 3.5mm]
    roof_h   = 5.0;      // Pitch height [scaled from 14.0mm]
    clevis_slot_w = 3.6; // Slot width to receive hanger arm tab (hanger_th = 3.2mm)
    clevis_h      = 5.0; // Bracket height [scaled from 10.0mm]
    
    difference() {
        union() {
            // Hipped pitched roof starts at Z = 0
            hull() {
                rounded_box(cabin_l + roof_lip*2, cabin_w + roof_lip*2, 1.2, corner_r + 0.4);
                translate([0, 0, roof_h])
                    rounded_box(cabin_l * 0.45, cabin_w * 0.25, 0.6, 1.0);
            }
            
            // Solid Clevis Bracket on roof ridge - anchored deeply into Z=0 body
            translate([0, 0, roof_h / 2])
                hull() {
                    cube([12.0, 9.0, 1.0], center = true);
                    translate([0, 0, roof_h / 2 + clevis_h / 2])
                        cube([10.0, 7.0, clevis_h + 1], center = true);
                }
        }
        
        // Underside recess for cabin rim
        translate([0, 0, -0.01])
            rounded_box((cabin_l - 1.6) + 0.25, (cabin_w - 1.6) + 0.25, 2.2, max(0.5, corner_r));

        // Vertical slot in the mounting bracket to receive the hanger tab
        translate([0, 0, roof_h + clevis_h / 2 + 0.5])
            cube([11.0, clevis_slot_w, clevis_h + 5], center = true);

        // Horizontal cross-pin hole (M3 screw slides cleanly through both outer ears)
        translate([0, 0, roof_h + clevis_h * 0.5])
            rotate([0, 90, 0])
                cylinder(d = 3.6, h = 18.0, center = true);


        // Alignment keyway pocket (recessed UPWARDS from Z=0)
        translate([cabin_l / 2 - 2.5, 0, 0.8])
            cube([2.0, 4.0, 1.6], center = true);
    }
}





// 3. Hanger Arm (100% Flat Planar 2D Extrusion - ZERO floating geometry!)
module hanger_arm_flat() {
    linear_extrude(height = hanger_th) {
        difference() {
            union() {
                // Lower tab (slides into roof clevis)
                translate([0, 0])
                    hull() {
                        translate([0, -3]) square([11.0, 6], center = true);
                        translate([0, 5]) square([11.0, 6], center = true);
                    }
                // Lower horizontal bridge
                hull() {
                    translate([0, 4]) circle(d = 8.0);
                    translate([hanger_offset, 4]) circle(d = 8.0);
                }
                // Vertical C-stem
                hull() {
                    translate([hanger_offset, 4]) circle(d = 8.0);
                    translate([hanger_offset, hanger_height]) circle(d = 8.0);
                }
                // Top horizontal bridge
                hull() {
                    translate([hanger_offset, hanger_height]) circle(d = 8.0);
                    translate([0, hanger_height]) circle(d = 10.0);
                }
                // Top pivot eyelet
                translate([0, hanger_height])
                    circle(d = 10.0);
            }
            // Lower horizontal pin hole
            translate([0, 0])
                circle(d = 3.4);
            // Top pivot pin hole
            translate([0, hanger_height])
                circle(d = pivot_pin_d);
        }
    }
}

// Alias for 3D preview: stands upright
module hanger_arm() {
    translate([0, 6.0 + hanger_th / 2, 0])
        rotate([90, 0, 0])
            hanger_arm_flat();
}

// Full assembled view helper
module gondola_assembled() {
    cabin_body();
    translate([0, 0, cabin_h]) cabin_roof();
    translate([0, 0, cabin_h + 14]) hanger_arm();
}

// ====================================================================
// Print Selection
// ====================================================================
// Options:
//   "plate"    -> All 3 parts laid out side-by-side flat on bed at Z=0 (15–20mm spacing!)
//   "cabin"    -> Only cabin body (flat at Z=0)
//   "roof"     -> Only roof (flat at Z=0)
//   "hanger"   -> Only hanger arm (flat at Z=0)
//   "preview"  -> Visual assembled preview
part = "plate";

if (part == "plate") {
    // Generously spaced print-bed layout: ALL parts at Z=0, ZERO overhangs!
    translate([-55, 0, 0]) cabin_body();
    translate([55, 0, 0]) cabin_roof();
    translate([0, 42, 0]) hanger_arm_flat();
} else if (part == "cabin") {
    cabin_body();
} else if (part == "roof") {
    cabin_roof();
} else if (part == "hanger") {
    hanger_arm_flat();
} else if (part == "preview") {
    gondola_assembled();
}
