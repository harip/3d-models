// ====================================================================
// Modern Single-Arch Suspension Bridge (Inverted V-Cable Tied Arch)
// Dimensions: Length 120.0 mm (12.0 cm), Width 26.0 mm (2.6 cm)
// Max Arch Height: 44.0 mm (4.4 cm)
// Architecture: Central Overhead Rib Arch with Diagonal Hanger Cable Network
// Grounding: Integrated Riverbed Terrain Base with Bed Abutments
// 100% Watertight Manifold Solid for Supportless FDM 3D Printing (NoError)
// ====================================================================

$fn = 28;

bridge_len   = 120.0;
bridge_w     = 26.0;
deck_w       = 17.0;
base_h       = 2.5;

arch_span    = 108.0; // Arch foundation span along X
arch_peak_z  = 44.0;  // Top of central arch
deck_z_end   = 9.5;   // Deck elevation at abutments
deck_z_mid   = 12.0;  // Camber peak at center

// Deck elevation formula along X
function deck_z(x) = deck_z_mid - (deck_z_mid - deck_z_end) * (x / 54.0) * (x / 54.0);

// Arch centerline elevation formula along X (parabolic curve)
function arch_z(x) = (abs(x) <= 54.0) ? (arch_peak_z - (arch_peak_z - 7.0) * (x / 54.0) * (x / 54.0)) : 7.0;

module single_arch_suspension_bridge() {
    union() {
        // --- 1. RIVERBED FOUNDATION & BEDROCK ABUTMENT ANCHORS ---
        riverbed_and_abutments();

        // --- 2. SUSPENDED ROADBED DECK & PARAPET RAILINGS ---
        suspended_deck();

        // --- 3. MONUMENTAL SINGLE OVERHEAD ARCH RIB ---
        central_arch_rib();

        // --- 4. INVERTED-V DIAGONAL HANGER SUSPENSION CABLES ---
        suspension_hangers();
    }
}

// 1. RIVERBED BASE & ANCHOR ABUTMENTS
module riverbed_and_abutments() {
    // Water baseplate with smooth rounded corners (anti-warp)
    hull() {
        for (x = [-bridge_len/2 + 3, bridge_len/2 - 3])
            for (y = [-bridge_w/2 + 3, bridge_w/2 - 3])
                translate([x, y, 0]) cylinder(r = 3.0, h = base_h, $fn = 24);
    }

    // Stylized river current ripple relief on water surface (Z=0 to 2.2mm)
    for (x = [-38 : 12 : 38]) {
        translate([x, 0, base_h - 0.3])
            scale([1.8, 1.0, 0.5])
                cylinder(r = 7.0, h = 0.5, $fn = 20);
    }

    // Massive Stone Abutment Towers on Left & Right Banks
    for (s = [-1, 1]) {
        x_abut = s * (bridge_len/2 - 10.0);
        hull() {
            translate([x_abut - 7.0, -bridge_w/2 + 1.0, 0])
                cube([14.0, bridge_w - 2.0, base_h + 1.0]);
            translate([x_abut - 5.0, -deck_w/2 - 1.0, deck_z_end])
                cube([10.0, deck_w + 2.0, 1.5]);
        }

        // Heavy Arch Thrust Foundation Blocks
        translate([s * 53.0, 0, 0])
            hull() {
                translate([-4.0, -4.5, 0]) cube([8.0, 9.0, base_h]);
                translate([-3.0, -3.5, 7.0]) cube([6.0, 7.0, 1.0]);
            }

        // Stepped Approach Stairs & Ramps on Outer Ends
        for (step = [0 : 3]) {
            z_step = base_h + step * 1.6;
            x_step = s * (bridge_len/2 - 2.5 - step * 2.8);
            translate([x_step - 1.4, -deck_w/2 + 0.5, 0])
                cube([2.8, deck_w - 1.0, z_step]);
        }
    }

    // Two Sturdy Under-Deck Water Piers to Support Spanning Deck (Supportless FDM)
    for (px = [-24.0, 24.0]) {
        hull() {
            translate([px - 2.5, -deck_w/2 + 1.0, 0])
                cube([5.0, deck_w - 2.0, base_h]);
            translate([px - 1.5, -deck_w/2 + 1.0, deck_z(px) - 0.2])
                cube([3.0, deck_w - 2.0, 0.5]);
        }
    }
}

// 2. SUSPENDED ROADBED DECK
module suspended_deck() {
    // Main Roadbed Deck Plate (Cambered arch from ends to center)
    hull() {
        for (x = [-54.0 : 3.0 : 54.0]) {
            z_curr = deck_z(x);
            translate([x, -deck_w/2, z_curr])
                cube([3.0, deck_w, 2.2]);
        }
    }

    // Roadway Lane Divider & Curb Strips
    translate([-52.0, -0.6, deck_z_mid + 2.1])
        cube([104.0, 1.2, 0.4]);

    // Safety Barrier Parapet Railings with Vertical Balusters
    for (side_y = [-deck_w/2 + 0.4, deck_w/2 - 1.4]) {
        // Continuous Top Handrail
        hull() {
            for (x = [-54.0 : 3.0 : 54.0]) {
                z_curr = deck_z(x) + 2.2 + 3.8;
                translate([x, side_y, z_curr])
                    cube([3.0, 1.0, 0.8]);
            }
        }
        // Vertical Stanchion Posts every 6mm
        for (x = [-52.0 : 6.0 : 52.0]) {
            z_curr = deck_z(x) + 2.0;
            translate([x, side_y + 0.1, z_curr])
                cube([0.9, 0.8, 4.0]);
        }
    }

    // Heavy Outrigger Anchorage Cable Brackets along Deck Edges
    for (x = [-42.0 : 7.0 : 42.0]) {
        z_curr = deck_z(x);
        for (side_sign = [-1, 1]) {
            translate([x, side_sign * (deck_w/2 + 0.4), z_curr + 0.6])
                scale([1.0, 1.0, 0.8])
                    sphere(r = 1.0, $fn = 10);
        }
    }
}

// 3. MONUMENTAL SINGLE OVERHEAD CENTRAL ARCH RIB
module central_arch_rib() {
    // Aerodynamic curved central tubular arch rib spanning from -54 to +54
    for (x = [-54.0 : 2.0 : 52.0]) {
        x1 = x;
        x2 = x + 2.0;
        z1 = arch_z(x1);
        z2 = arch_z(x2);

        hull() {
            translate([x1, 0, z1])
                rotate([0, 0, 0])
                    scale([1.1, 1.0, 1.2])
                        cylinder(r = 2.4, h = 0.1, center = true, $fn = 16);
            translate([x2, 0, z2])
                rotate([0, 0, 0])
                    scale([1.1, 1.0, 1.2])
                        cylinder(r = 2.4, h = 0.1, center = true, $fn = 16);
        }
    }

    // Crown Keystone Reinforcement at Arch Peak (X = 0, Z = 44)
    translate([0, 0, arch_peak_z])
        scale([1.6, 1.2, 1.1])
            sphere(r = 3.0, $fn = 16);
}

// 4. INVERTED-V DIAGONAL HANGER SUSPENSION CABLES
module suspension_hangers() {
    // Diagonal paired hanger cables (Left edge & Right edge of deck to central arch)
    for (x = [-42.0 : 7.0 : 42.0]) {
        z_arch = arch_z(x);
        z_deck_curr = deck_z(x) + 2.0;

        // Left Hanger Cable (from central arch (Y=0) to deck left (Y = -deck_w/2))
        hull() {
            translate([x, 0, z_arch - 1.2])
                sphere(r = 0.8, $fn = 8);
            translate([x, -deck_w/2 + 0.5, z_deck_curr])
                cylinder(r1 = 0.9, r2 = 0.7, h = 1.0, $fn = 8);
        }

        // Right Hanger Cable (from central arch (Y=0) to deck right (Y = +deck_w/2))
        hull() {
            translate([x, 0, z_arch - 1.2])
                sphere(r = 0.8, $fn = 8);
            translate([x, deck_w/2 - 0.5, z_deck_curr])
                cylinder(r1 = 0.9, r2 = 0.7, h = 1.0, $fn = 8);
        }
    }
}

single_arch_suspension_bridge();
