// ====================================================================
// Mountain Tour Helicopter - Airbus H125 (AS350 B3 "Ecureuil") @ 1:120
//
// Real aircraft -> model (1:120):
//   Fuselage length (nose to fin)  10.93 m -> ~89 mm
//   Main rotor diameter            10.69 m -> 89 mm (3 blades, Starflex hub)
//   Tail rotor diameter             1.86 m -> 15.5 mm (2 blades, LEFT side)
//   Height to rotor head            3.34 m -> ~28 mm
//   Cabin width                     1.87 m -> 15.6 mm
//   Skid track                      2.35 m -> 19.6 mm
//
// Axes: +X = forward (nose), +Y = left (port), +Z = up. Skids sit at Z = 0.
//
// MODES (set with -D mode=\"...\" or edit below):
//   "assembled"   -> full display model in one piece (rotor attached)
//   "print_body"  -> fuselage + skids + tail, mast ends in a 2.0 mm peg
//   "print_rotor" -> main rotor lying flat, 2.2 mm socket for the peg
// ====================================================================

mode = "assembled";

$fn = 48;

// ---------- Key dimensions (mm) ----------
belly_z     = 4.6;    // flat belly height (ground clearance)
mast_x      = -1.0;   // rotor mast position
mast_top_z  = 27.0;   // top of mast / bottom of rotor hub
boom_z      = 14.0;   // tail boom centreline height
boom_x0     = -15.0;  // boom root
boom_x1     = -62.0;  // boom end
rotor_r     = 44.5;   // main rotor radius
tr_d        = 15.5;   // tail rotor diameter
tr_pos      = [-63.0, 2.2, 20.5]; // tail rotor hub (left side of fin)
skid_y      = 9.8;    // skid half-track
recess      = 0.5;    // window recess depth

// ---------- Helpers ----------
module E(c, s) { translate(c) scale(s / 2) sphere(d = 2); }   // ellipsoid by full size
module tube(p1, p2, d) { hull() { translate(p1) sphere(d = d, $fn = 20); translate(p2) sphere(d = d, $fn = 20); } }
module chain(pts, d) { for (i = [0 : len(pts) - 2]) tube(pts[i], pts[i + 1], d); }

// ---------- Fuselage ----------
// i = inset (positive shrinks the hull, used to build the window recess shell)
module fuselage_core(i = 0) {
    intersection() {
        hull() {
            E([15, 0, 10.5], [14 - 2*i, 13.5 - 2*i, 13 - 2*i]);   // rounded nose bubble
            E([ 6, 0, 11.5], [22 - 2*i, 15.6 - 2*i, 17 - 2*i]);   // front cabin (pilot + 2 pax)
            E([-5, 0, 12.0], [20 - 2*i, 15.2 - 2*i, 16 - 2*i]);   // rear cabin (bench, 4 pax)
            E([-15, 0, 13.5], [12 - 2*i, 8 - 2*i, 9 - 2*i]);      // tail cone / boom fairing
        }
        translate([-50, -20, belly_z]) cube([100, 40, 40]);        // flat belly
    }
}

module window_regions() {
    // Large wrap-around windscreen with centre post
    difference() {
        translate([8.8, -12, 11.2]) cube([20, 24, 14]);
        translate([0, -0.45, 0]) cube([40, 0.9, 40]);
    }
    // Twin chin (floor) windows - the classic H125 sightseeing feature
    difference() {
        translate([15.5, -12, 5.6]) cube([12, 24, 4.0]);
        translate([0, -0.6, 0]) cube([40, 1.2, 40]);
    }
    // Front + rear door windows, both sides
    for (s = [-1, 1]) {
        translate([0.9,  (s > 0) ? 4.5 : -12, 11.2]) cube([7.2, 7.5, 7.6]);
        translate([-10.5, (s > 0) ? 4.5 : -12, 11.2]) cube([10.6, 7.5, 7.0]);
    }
}

module door_seams() {
    for (s = [-1, 1]) {
        y0 = (s > 0) ? 3.0 : -12.0;
        for (x = [-11.2, 0.5, 8.45])
            translate([x - 0.15, y0, 5.4]) cube([0.3, 9, 14]);       // vertical door edges
        translate([-11.2, y0, 5.6]) cube([19.6, 9, 0.3]);            // door sill line
    }
}

module fuselage() {
    difference() {
        fuselage_core(0);
        // Recessed glazing + door seams cut only into the outer skin
        intersection() {
            union() { window_regions(); door_seams(); }
            difference() { fuselage_core(-0.6); fuselage_core(recess); }
        }
    }
    // Landing light under the nose
    translate([14, 0, belly_z - 0.4]) cylinder(d = 2.0, h = 0.6);
}

// ---------- Engine / transmission cowling ----------
module engine_cowl() {
    difference() {
        hull() {
            E([  2, 0, 19.5], [12, 10, 6.0]);   // main gearbox fairing
            E([-12, 0, 19.5], [16,  9, 5.5]);   // Arriel 2D turbine cowl
            E([-18, 0, 18.0], [ 6,  6, 4.0]);   // tapered rear
        }
        // Side air-intake grilles
        for (s = [-1, 1], k = [0 : 3])
            translate([-5.5 - k * 1.5, s * 4.7, 20.2]) cube([0.8, 2.0, 1.8], center = true);
    }
    // Exhaust pipe: aft, up and to the right (starboard)
    translate([-18.5, -0.8, 18.6]) rotate([0, 0, 15]) rotate([0, -75, 0])
        difference() {
            cylinder(d1 = 3.6, d2 = 3.2, h = 4.5);
            translate([0, 0, 1.0]) cylinder(d = 2.3, h = 5);
        }
    // Red anti-collision beacon
    translate([-15, 0, 21.0]) E([0, 0, 0], [2.0, 1.6, 1.6]);
}

// ---------- Rotor mast + swashplate ----------
module mast(peg = false) {
    translate([mast_x, 0, 20.5]) {
        cylinder(d = 2.6, h = mast_top_z - 20.5);           // mast
        translate([0, 0, 2.6]) cylinder(d = 5.0, h = 0.8);  // swashplate
        for (a = [0, 120, 240])                             // pitch-change rods
            rotate([0, 0, a]) translate([2.0, 0, 3.0]) cylinder(d = 0.7, h = mast_top_z - 23.6, $fn = 12);
        if (peg) translate([0, 0, mast_top_z - 20.5]) cylinder(d = 2.0, h = 1.4);
    }
}

// ---------- Main rotor (Starflex hub, 3 blades) - built flat from Z = 0 ----------
module blade() {
    linear_extrude(height = 1.0)
        polygon([[7.5, -1.5], [rotor_r - 2.5, -1.5], [rotor_r, -0.7],
                 [rotor_r, 1.2], [7.5, 1.5]]);
}

module main_rotor(socket = false) {
    difference() {
        union() {
            cylinder(d = 6.0, h = 1.6);                                  // hub
            for (a = [0, 120, 240]) rotate([0, 0, a]) {
                hull() { cylinder(d = 3.0, h = 1.2); translate([5, 0, 0]) cylinder(d = 2.4, h = 1.2); } // Starflex arm
                translate([4.0, -1.3, 0]) cube([5.0, 2.6, 1.4]);         // blade sleeve
                blade();
            }
            translate([0, 0, 1.6]) scale([1, 1, 0.5]) sphere(d = 4.0);   // hub cap
        }
        if (socket) translate([0, 0, -0.01]) cylinder(d = 2.2, h = 1.5);
    }
}

// ---------- Tail boom & empennage ----------
module tail() {
    // Tapered boom
    translate([boom_x0, 0, boom_z]) rotate([0, -90, 0])
        cylinder(d1 = 7.0, d2 = 3.2, h = boom_x0 - boom_x1);
    E([boom_x1, 0, boom_z], [4, 3.2, 3.2]);                       // boom end fairing

    // Horizontal stabiliser with endplate fins
    translate([-50, 0, boom_z]) {
        hull() {
            translate([0, 0, 0]) cube([4.0, 20.0, 0.6], center = true);
            translate([-0.6, 0, 0]) cube([2.4, 20.0, 1.0], center = true);
        }
        for (s = [-1, 1])
            translate([-0.8, s * 10.0, 0]) rotate([90, 0, 0])
                linear_extrude(height = 0.8, center = true)
                    polygon([[2, -1.5], [-2, -1.5], [-3, 3.0], [0, 3.0]]);
    }

    // Swept vertical fin (upper) + ventral fin (lower)
    rotate([90, 0, 0]) linear_extrude(height = 1.2, center = true)
        polygon([[-54, 15.5], [-63.5, 27], [-67, 27], [-64.5, 14],
                 [-64.5, 6.5], [-61.5, 6.5], [-57, 12.5]]);

    // Tail skid guard
    tube([-60, 0, 7.0], [-62.5, 0, 5.2], 0.9);

    // Tail rotor gearbox + 2-blade tail rotor on the LEFT side
    E([tr_pos[0], 0, tr_pos[2]], [4, 2.6, 4]);
    translate(tr_pos) rotate([90, 0, 0]) {
        translate([0, 0, -1.1]) cylinder(d = 2.6, h = 3.3, center = true); // hub into gearbox
        rotate([0, 0, 30]) cube([1.6, tr_d, 0.8], center = true);         // blades
    }

    // VHF antenna on top of the boom
    translate([-30, 0, boom_z + 2.5]) rotate([90, 0, 0])
        linear_extrude(height = 0.6, center = true)
            polygon([[0, -1], [2, -1], [-1, 3.5], [-2, 3.5]]);
}

// ---------- Skid landing gear ----------
module skids() {
    intersection() {
        union() {
            for (s = [-1, 1]) {
                y = s * skid_y;
                // Skid tube with upturned toe and short rear kick
                chain([[-14.5, y, 1.4], [-13, y, 0.9], [13, y, 0.9],
                       [16, y, 1.6], [18, y, 3.2]], 1.8);
                // Boarding step on the front cross-tube
                translate([6, s * 7.6, 4.4]) cube([3.0, 1.8, 0.5], center = true);
            }
            // Arched front and rear cross-tubes
            for (x = [6, -8])
                for (s = [-1, 1])
                    chain([[x, 0, 5.5], [x, s * 4, 5.0], [x, s * 7.5, 4.3],
                           [x, s * 9.3, 2.6], [x, s * skid_y, 1.0]], 1.7);
        }
        translate([-50, -20, 0]) cube([100, 40, 40]);   // flat skid soles at Z = 0
    }
}

// ---------- Assemblies ----------
module helicopter_body(peg = false) {
    color("gold")      fuselage();
    color("gold")      engine_cowl();
    color("firebrick") tail();
    color("dimgray")   skids();
    color("silver")    mast(peg);
}

if (mode == "assembled") {
    helicopter_body(false);
    color("dimgray") translate([mast_x, 0, mast_top_z]) main_rotor(false);
} else if (mode == "print_body") {
    helicopter_body(true);
} else if (mode == "print_rotor") {
    main_rotor(true);
}
